-- IDesire Academy — initial schema
-- Convention: every user-scoped table has RLS enabled with deny-by-default,
-- explicit policies for the owner, and an admin bypass via is_admin().

set check_function_bodies = off;

-- ─────────────────────────────────────────────────────────────────────────────
-- Extensions
-- ─────────────────────────────────────────────────────────────────────────────
create extension if not exists "uuid-ossp";
create extension if not exists "pgcrypto";
create extension if not exists "vector";

-- ─────────────────────────────────────────────────────────────────────────────
-- Helpers
-- ─────────────────────────────────────────────────────────────────────────────

-- Admin check: matches either a top-level `role` JWT claim (set via a custom
-- claim hook) or app_metadata.role on the auth user.
create or replace function public.is_admin() returns boolean
  language sql stable security definer
  set search_path = public, auth
  as $$
    select coalesce(
      (auth.jwt() ->> 'role') = 'admin',
      (auth.jwt() -> 'app_metadata' ->> 'role') = 'admin',
      false
    );
  $$;

create or replace function public.touch_updated_at() returns trigger
  language plpgsql
  as $$
    begin
      new.updated_at := now();
      return new;
    end;
  $$;

-- ─────────────────────────────────────────────────────────────────────────────
-- profiles
-- ─────────────────────────────────────────────────────────────────────────────
create table public.profiles (
  id              uuid primary key references auth.users(id) on delete cascade,
  email           text not null,
  full_name       text,
  locale          text not null default 'en' check (locale in ('en','es','ur')),
  country         text,
  persona         text check (persona in ('immigrant','side_hustler','corporate_escapee','b2b')),
  founding_member boolean not null default false,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
create index profiles_email_idx on public.profiles (lower(email));
create trigger profiles_touch_updated before update on public.profiles
  for each row execute function public.touch_updated_at();

alter table public.profiles enable row level security;

create policy "profiles_select_self_or_admin" on public.profiles
  for select using (id = auth.uid() or public.is_admin());
create policy "profiles_insert_self" on public.profiles
  for insert with check (id = auth.uid() or public.is_admin());
create policy "profiles_update_self_or_admin" on public.profiles
  for update using (id = auth.uid() or public.is_admin())
              with check (id = auth.uid() or public.is_admin());

-- ─────────────────────────────────────────────────────────────────────────────
-- Curriculum: tracks → courses → modules → lessons → lesson_translations
-- All curriculum metadata is publicly readable; gating happens on lessons
-- (video + locked content) via has_lesson_access().
-- ─────────────────────────────────────────────────────────────────────────────
create table public.tracks (
  id           uuid primary key default gen_random_uuid(),
  slug         text not null unique,
  title        text not null,
  description  text,
  order_index  int  not null default 0,
  is_published boolean not null default true,
  created_at   timestamptz not null default now()
);
alter table public.tracks enable row level security;
create policy "tracks_select_public" on public.tracks for select using (true);
create policy "tracks_write_admin"    on public.tracks for all
  using (public.is_admin()) with check (public.is_admin());

create table public.courses (
  id           uuid primary key default gen_random_uuid(),
  track_id     uuid not null references public.tracks(id) on delete cascade,
  slug         text not null unique,
  title        text not null,
  description  text,
  cover_url    text,
  order_index  int  not null default 0,
  is_published boolean not null default true,
  created_at   timestamptz not null default now()
);
create index courses_track_idx on public.courses (track_id, order_index);
alter table public.courses enable row level security;
create policy "courses_select_public" on public.courses for select using (true);
create policy "courses_write_admin"    on public.courses for all
  using (public.is_admin()) with check (public.is_admin());

create table public.modules (
  id          uuid primary key default gen_random_uuid(),
  course_id   uuid not null references public.courses(id) on delete cascade,
  title       text not null,
  order_index int  not null default 0,
  created_at  timestamptz not null default now()
);
create index modules_course_idx on public.modules (course_id, order_index);
alter table public.modules enable row level security;
create policy "modules_select_public" on public.modules for select using (true);
create policy "modules_write_admin"    on public.modules for all
  using (public.is_admin()) with check (public.is_admin());

create table public.lessons (
  id               uuid primary key default gen_random_uuid(),
  module_id        uuid not null references public.modules(id) on delete cascade,
  slug             text not null,
  video_url        text,
  duration_seconds int not null default 0,
  order_index      int not null default 0,
  is_free_preview  boolean not null default false,
  created_at       timestamptz not null default now(),
  unique (module_id, slug)
);
create index lessons_module_idx on public.lessons (module_id, order_index);
alter table public.lessons enable row level security;

create table public.lesson_translations (
  id          uuid primary key default gen_random_uuid(),
  lesson_id   uuid not null references public.lessons(id) on delete cascade,
  locale      text not null check (locale in ('en','es','ur')),
  title       text not null,
  transcript  text not null,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  unique (lesson_id, locale)
);
create index lesson_tx_lesson_idx on public.lesson_translations (lesson_id, locale);
create trigger lesson_tx_touch_updated before update on public.lesson_translations
  for each row execute function public.touch_updated_at();
alter table public.lesson_translations enable row level security;

-- ─────────────────────────────────────────────────────────────────────────────
-- Member data: subscriptions, enrollments, lesson_progress
-- ─────────────────────────────────────────────────────────────────────────────
create table public.subscriptions (
  id                     uuid primary key default gen_random_uuid(),
  user_id                uuid not null references auth.users(id) on delete cascade,
  stripe_customer_id     text,
  stripe_subscription_id text unique,
  tier                   text not null check (tier in ('founding','premium')),
  status                 text not null check (status in
                            ('trialing','active','past_due','canceled','incomplete','incomplete_expired','unpaid','paused')),
  price_id               text,
  current_period_end     timestamptz,
  cancel_at_period_end   boolean not null default false,
  created_at             timestamptz not null default now(),
  updated_at             timestamptz not null default now()
);
create index subscriptions_user_idx on public.subscriptions (user_id, status);
create trigger subscriptions_touch_updated before update on public.subscriptions
  for each row execute function public.touch_updated_at();

alter table public.subscriptions enable row level security;
create policy "subscriptions_select_self_or_admin" on public.subscriptions
  for select using (user_id = auth.uid() or public.is_admin());
create policy "subscriptions_write_admin" on public.subscriptions
  for all using (public.is_admin()) with check (public.is_admin());

create table public.enrollments (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references auth.users(id) on delete cascade,
  course_id   uuid not null references public.courses(id) on delete cascade,
  enrolled_at timestamptz not null default now(),
  unique (user_id, course_id)
);
create index enrollments_user_idx on public.enrollments (user_id);
alter table public.enrollments enable row level security;
create policy "enrollments_select_self_or_admin" on public.enrollments
  for select using (user_id = auth.uid() or public.is_admin());
create policy "enrollments_insert_self" on public.enrollments
  for insert with check (user_id = auth.uid() or public.is_admin());
create policy "enrollments_delete_self_or_admin" on public.enrollments
  for delete using (user_id = auth.uid() or public.is_admin());

create table public.lesson_progress (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null references auth.users(id) on delete cascade,
  lesson_id        uuid not null references public.lessons(id) on delete cascade,
  watch_seconds    int  not null default 0,
  completed_at     timestamptz,
  last_watched_at  timestamptz not null default now(),
  unique (user_id, lesson_id)
);
create index lesson_progress_user_idx on public.lesson_progress (user_id, last_watched_at desc);
alter table public.lesson_progress enable row level security;
create policy "lesson_progress_select_self_or_admin" on public.lesson_progress
  for select using (user_id = auth.uid() or public.is_admin());
create policy "lesson_progress_upsert_self" on public.lesson_progress
  for insert with check (user_id = auth.uid());
create policy "lesson_progress_update_self" on public.lesson_progress
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

-- ─────────────────────────────────────────────────────────────────────────────
-- Lesson access gate. The function is referenced from RLS policies on lessons
-- and lesson_translations. Free-preview lessons bypass the subscription check;
-- everything else requires (a) an active sub and (b) an enrollment in the
-- parent course.
-- ─────────────────────────────────────────────────────────────────────────────
create or replace function public.has_lesson_access(p_lesson_id uuid) returns boolean
  language plpgsql stable security definer
  set search_path = public
  as $$
    declare
      v_user uuid := auth.uid();
      v_course uuid;
      v_free  boolean;
    begin
      if public.is_admin() then
        return true;
      end if;

      select l.is_free_preview, m.course_id
        into v_free, v_course
        from public.lessons l
        join public.modules m on m.id = l.module_id
       where l.id = p_lesson_id;

      if not found then
        return false;
      end if;

      if v_free then
        return true;
      end if;

      if v_user is null then
        return false;
      end if;

      return exists (
        select 1 from public.subscriptions s
         where s.user_id = v_user and s.status in ('active','trialing')
      ) and exists (
        select 1 from public.enrollments e
         where e.user_id = v_user and e.course_id = v_course
      );
    end;
  $$;

create policy "lessons_select_gated" on public.lessons
  for select using (public.has_lesson_access(id));
create policy "lessons_write_admin" on public.lessons
  for all using (public.is_admin()) with check (public.is_admin());

create policy "lesson_tx_select_gated" on public.lesson_translations
  for select using (public.has_lesson_access(lesson_id));
create policy "lesson_tx_write_admin" on public.lesson_translations
  for all using (public.is_admin()) with check (public.is_admin());

-- ─────────────────────────────────────────────────────────────────────────────
-- Support Agent: conversations + messages
-- ─────────────────────────────────────────────────────────────────────────────
create table public.support_conversations (
  id                  uuid primary key default gen_random_uuid(),
  user_id             uuid references auth.users(id) on delete set null,
  locale              text not null default 'en' check (locale in ('en','es','ur')),
  status              text not null default 'open' check (status in ('open','closed','escalated')),
  csat_score          int check (csat_score between 1 and 5),
  csat_submitted_at   timestamptz,
  total_tokens_in     int not null default 0,
  total_tokens_out    int not null default 0,
  estimated_cost_usd  numeric(10,4) not null default 0,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now()
);
create index support_conv_user_idx on public.support_conversations (user_id, created_at desc);
create trigger support_conv_touch_updated before update on public.support_conversations
  for each row execute function public.touch_updated_at();
alter table public.support_conversations enable row level security;
create policy "support_conv_select_self_or_admin" on public.support_conversations
  for select using (user_id = auth.uid() or public.is_admin());
create policy "support_conv_insert_self" on public.support_conversations
  for insert with check (user_id = auth.uid() or public.is_admin());
create policy "support_conv_update_self_or_admin" on public.support_conversations
  for update using (user_id = auth.uid() or public.is_admin())
              with check (user_id = auth.uid() or public.is_admin());

create table public.support_messages (
  id              uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.support_conversations(id) on delete cascade,
  role            text not null check (role in ('user','assistant','tool','system')),
  content         text not null,
  tool_calls      jsonb,
  tokens_in       int,
  tokens_out      int,
  created_at      timestamptz not null default now()
);
create index support_msg_conv_idx on public.support_messages (conversation_id, created_at);
alter table public.support_messages enable row level security;
create policy "support_msg_select_via_conv" on public.support_messages
  for select using (
    public.is_admin() or exists (
      select 1 from public.support_conversations c
       where c.id = conversation_id and c.user_id = auth.uid()
    )
  );
create policy "support_msg_insert_via_conv" on public.support_messages
  for insert with check (
    public.is_admin() or exists (
      select 1 from public.support_conversations c
       where c.id = conversation_id and c.user_id = auth.uid()
    )
  );

-- ─────────────────────────────────────────────────────────────────────────────
-- RAG content chunks (Voyage 1024-dim embedding by default; swap dim
-- here if migrating embedding providers).
-- ─────────────────────────────────────────────────────────────────────────────
create table public.content_chunks (
  id          uuid primary key default gen_random_uuid(),
  source_type text not null check (source_type in ('lesson','article','faq')),
  source_id   uuid not null,
  locale      text not null check (locale in ('en','es','ur')),
  chunk_index int  not null default 0,
  content     text not null,
  embedding   vector(1024),
  created_at  timestamptz not null default now()
);
create index content_chunks_source_idx on public.content_chunks (source_type, source_id, locale);
create index content_chunks_embedding_idx on public.content_chunks
  using ivfflat (embedding vector_cosine_ops) with (lists = 100);
alter table public.content_chunks enable row level security;
-- RAG is exclusively read by the Support Agent route via the service role
-- (which bypasses RLS). Members never read this table directly, so the only
-- policy is the admin escape hatch for dashboarding.
create policy "content_chunks_admin_only" on public.content_chunks
  for all using (public.is_admin()) with check (public.is_admin());

-- ─────────────────────────────────────────────────────────────────────────────
-- Content Agent queue
-- ─────────────────────────────────────────────────────────────────────────────
create table public.content_queue (
  id              uuid primary key default gen_random_uuid(),
  platform        text not null check (platform in ('ig','tiktok','linkedin')),
  status          text not null default 'draft' check (status in ('draft','approved','posted','failed')),
  content         jsonb not null,
  scheduled_for   timestamptz,
  posted_at       timestamptz,
  external_post_id text,
  error           text,
  created_by      uuid references auth.users(id) on delete set null,
  approved_by     uuid references auth.users(id) on delete set null,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);
create index content_queue_status_idx on public.content_queue (status, scheduled_for);
create trigger content_queue_touch_updated before update on public.content_queue
  for each row execute function public.touch_updated_at();
alter table public.content_queue enable row level security;
create policy "content_queue_admin_only" on public.content_queue
  for all using (public.is_admin()) with check (public.is_admin());

-- ─────────────────────────────────────────────────────────────────────────────
-- Daily KPI snapshot (cron-populated)
-- ─────────────────────────────────────────────────────────────────────────────
create table public.daily_kpis (
  date                       date primary key,
  mrr_cents                  int not null default 0,
  active_subs                int not null default 0,
  new_subs                   int not null default 0,
  churned_subs               int not null default 0,
  founding_seats_remaining   int not null default 50,
  support_conversations      int not null default 0,
  computed_at                timestamptz not null default now()
);
alter table public.daily_kpis enable row level security;
create policy "daily_kpis_admin_only" on public.daily_kpis
  for all using (public.is_admin()) with check (public.is_admin());

-- ─────────────────────────────────────────────────────────────────────────────
-- Webhook idempotency log
-- ─────────────────────────────────────────────────────────────────────────────
create table public.processed_webhooks (
  id         text primary key,
  created_at timestamptz not null default now()
);
alter table public.processed_webhooks enable row level security;
-- Only the service role writes here; no policies means deny-by-default for
-- authenticated/anon users.
