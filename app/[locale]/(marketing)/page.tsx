import { useTranslations } from "next-intl";
import Link from "next/link";

export default function LandingPage() {
  const t = useTranslations();

  return (
    <main className="mx-auto max-w-5xl px-6 py-24 md:py-32">
      <p className="section-label mb-8">{t("landing.heroEyebrow")}</p>
      <h1 className="font-serif text-5xl md:text-7xl leading-[1.05] tracking-tight text-balance max-w-3xl">
        {t("landing.heroTitle")}
      </h1>
      <p className="mt-8 max-w-xl text-lg leading-relaxed text-muted-foreground">
        {t("landing.heroBody")}
      </p>
      <div className="mt-12 flex items-center gap-6">
        <Link
          href="/pricing"
          className="inline-flex h-12 items-center bg-ink text-paper px-6 hover:bg-accent transition-colors"
        >
          {t("landing.heroCta")}
        </Link>
        <span className="section-label">
          {t("landing.seatsRemaining", { count: 37 })}
        </span>
      </div>
    </main>
  );
}
