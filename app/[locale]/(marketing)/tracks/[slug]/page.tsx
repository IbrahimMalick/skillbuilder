import Link from "next/link";
import { getTranslations } from "next-intl/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

interface CourseRow {
  id: string;
  slug: string;
  title: string;
  description: string | null;
  order_index: number;
  modules: { id: string; lessons: { id: string }[] }[];
}

async function fetchTrackWithCourses(slug: string) {
  if (!process.env.SUPABASE_SERVICE_ROLE_KEY) return null;
  try {
    const supabase = createSupabaseAdminClient();
    const { data: track } = await supabase
      .from("tracks")
      .select("id, slug, title, description")
      .eq("slug", slug)
      .eq("is_published", true)
      .maybeSingle();
    if (!track) return null;

    const { data: courses } = await supabase
      .from("courses")
      .select("id, slug, title, description, order_index, modules(id, lessons(id))")
      .eq("track_id", track.id)
      .eq("is_published", true)
      .order("order_index");

    return { track, courses: (courses ?? []) as CourseRow[] };
  } catch {
    return null;
  }
}

export default async function TrackPage({
  params: { locale, slug },
}: {
  params: { locale: string; slug: string };
}) {
  const [t, data] = await Promise.all([
    getTranslations("tracks"),
    fetchTrackWithCourses(slug),
  ]);

  if (!data) {
    // Track exists in seed but DB not configured — render a degraded page
    // so the route still resolves in dev.
    return (
      <section className="mx-auto max-w-4xl px-6 py-32">
        <Link
          href={`/${locale}#tracks`}
          className="section-label hover:text-accent"
        >
          ← {t("comingSoon")}
        </Link>
        <h1 className="mt-8 font-serif text-5xl tracking-tight">{slug}</h1>
        <p className="mt-6 text-muted-foreground">
          Database not configured. This page will populate once Supabase is connected.
        </p>
      </section>
    );
  }

  const { track, courses } = data;

  return (
    <section className="mx-auto max-w-5xl px-6 py-24 md:py-32">
      <Link
        href={`/${locale}#tracks`}
        className="section-label hover:text-accent"
      >
        ← All tracks
      </Link>
      <h1 className="mt-6 font-serif text-5xl leading-tight tracking-tight md:text-7xl max-w-3xl">
        {track.title}
      </h1>
      {track.description && (
        <p className="mt-8 max-w-2xl text-lg text-muted-foreground leading-relaxed">
          {track.description}
        </p>
      )}

      {courses.length === 0 ? (
        <div className="mt-16 border border-dashed border-border p-12 text-center">
          <p className="font-serif text-2xl">{t("comingSoon")}</p>
        </div>
      ) : (
        <div className="mt-16 divide-y divide-border border-y border-border">
          {courses.map((course, i) => {
            const lessonCount = course.modules.reduce(
              (acc, m) => acc + m.lessons.length,
              0
            );
            return (
              <Link
                key={course.id}
                href={`/${locale}/courses/${course.slug}`}
                className="group flex items-baseline gap-6 py-8 hover:bg-secondary/40 transition-colors"
              >
                <span className="font-mono text-sm text-accent w-12 shrink-0">
                  0{i + 1}
                </span>
                <div className="flex-1">
                  <h3 className="font-serif text-2xl tracking-tight md:text-3xl">
                    {course.title}
                  </h3>
                  {course.description && (
                    <p className="mt-2 max-w-2xl text-muted-foreground">
                      {course.description}
                    </p>
                  )}
                  <p className="mt-3 section-label">
                    {t("lessonsCount", { count: lessonCount })}
                  </p>
                </div>
                <span className="hidden md:inline text-muted-foreground transition-transform group-hover:translate-x-1">
                  →
                </span>
              </Link>
            );
          })}
        </div>
      )}

      <p className="mt-16 max-w-xl text-sm text-muted-foreground">
        {t("lockedNotice")}{" "}
        <Link
          href={`/${locale}/pricing`}
          className="underline underline-offset-4 decoration-accent hover:text-accent"
        >
          See pricing
        </Link>
        .
      </p>
    </section>
  );
}
