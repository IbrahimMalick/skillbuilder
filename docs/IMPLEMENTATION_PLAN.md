# IDesire Academy — Implementation Plan

> Status: Phase 1 complete (bootstrap). Awaiting plan content from founder; this is a
> phase-tracking stub that will be replaced when the full plan document is provided.

## Vision

IDesire Academy is an online subscription education platform teaching
entrepreneurship to immigrants, side hustlers, corporate escapees, and B2B
clients. Founder: Eman Desire.

**Phase 1 target:** ship a 60–90 day MVP that reaches $5K MRR with 50 founding
members at $97/mo.

## Phases

- **Phase 1 — Bootstrap.** Next.js 14 app, dependencies, design tokens,
  Supabase clients, middleware, i18n scaffolding.
- **Phase 2 — Database.** Migrations + seed (5 tracks, 1 sample course in EN/ES/UR).
- **Phase 3 — Auth + marketing site.** Signup/login, landing, pricing, track pages.
- **Phase 4 — Stripe billing.** Checkout, portal, webhook, RLS gating.
- **Phase 5 — Course player + progress.** Dashboard, lesson player, progress tracking.
- **Phase 6 — Support Agent.** RAG, streaming Claude chat, tool use, widget.
- **Phase 7 — Mission Control (admin).** Members, content queue, agent metrics.
- **Phase 8 — Content Agent + cron + analytics.** Drafts, n8n bridge, KPIs, PostHog, Mailchimp.
- **Phase 9 — Quality gate.** Vitest, Playwright, a11y, perf budget, launch checklist.

## Conventions

- TypeScript strict; no `any` without justification.
- Zod validation at every API boundary.
- Server Components by default; opt into Client Components only for interactivity.
- Editorial design language: warm off-white #FAF7F2, ink #141414, terracotta #B14A2F,
  Fraunces serif + Geist sans, generous whitespace, no glassmorphism, no purple gradients.
