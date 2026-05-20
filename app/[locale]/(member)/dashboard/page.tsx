import { getTranslations } from "next-intl/server";

export default async function DashboardPage() {
  const t = await getTranslations("common");

  return (
    <section className="mx-auto max-w-4xl px-6 py-24">
      <p className="section-label mb-4">§01 — {t("dashboard")}</p>
      <h1 className="font-serif text-5xl tracking-tight">
        Welcome back.
      </h1>
      <p className="mt-6 max-w-xl text-muted-foreground">
        Your full dashboard arrives with Phase 5 (course player + progress).
        For now, this confirms auth works end-to-end.
      </p>
    </section>
  );
}
