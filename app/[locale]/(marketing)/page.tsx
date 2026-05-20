import Link from "next/link";
import { getTranslations } from "next-intl/server";
import { TrackCard } from "@/components/marketing/track-card";
import { FaqAccordion } from "@/components/marketing/faq-accordion";
import { getFoundingSeatsRemaining, getTracks } from "@/lib/marketing";

export default async function LandingPage({
  params: { locale },
}: {
  params: { locale: string };
}) {
  const [t, tFaq, seatsRemaining, tracks] = await Promise.all([
    getTranslations("landing"),
    getTranslations("faqs"),
    getFoundingSeatsRemaining(),
    getTracks(),
  ]);
  const seatsSoldOut = seatsRemaining <= 0;

  const perks = t.raw("perks") as string[];
  const faqItems = (["q1", "q2", "q3", "q4", "q5"] as const).map((k) => ({
    q: tFaq(`${k}.q`),
    a: tFaq(`${k}.a`),
  }));

  return (
    <>
      {/* Hero */}
      <section className="mx-auto max-w-6xl px-6 py-24 md:py-36">
        <p className="section-label mb-10">{t("heroEyebrow")}</p>
        <h1 className="font-serif text-5xl leading-[1.05] tracking-tight text-balance md:text-7xl max-w-4xl">
          {t("heroTitle")}
        </h1>
        <p className="mt-10 max-w-2xl text-lg leading-relaxed text-muted-foreground">
          {t("heroBody")}
        </p>
        <div className="mt-14 flex flex-wrap items-center gap-6">
          <Link
            href={`/${locale}/signup`}
            className="inline-flex h-12 items-center bg-ink px-7 text-base text-paper hover:bg-accent transition-colors"
          >
            {t("heroCta")}
          </Link>
          <Link
            href={`/${locale}#tracks`}
            className="text-sm underline underline-offset-4 decoration-accent hover:text-accent"
          >
            {t("heroSecondary")}
          </Link>
          <span className="section-label ms-auto">
            {seatsSoldOut
              ? t("seatsSoldOut")
              : t("seatsRemaining", { count: seatsRemaining })}
          </span>
        </div>
      </section>

      {/* What you get */}
      <section className="border-y border-border bg-secondary/30">
        <div className="mx-auto grid max-w-6xl gap-16 px-6 py-24 md:grid-cols-[1fr_1.4fr] md:py-32">
          <div>
            <p className="section-label mb-6">{t("whatYouGetEyebrow")}</p>
            <h2 className="font-serif text-4xl leading-tight tracking-tight md:text-5xl">
              {t("whatYouGetTitle")}
            </h2>
          </div>
          <div>
            <p className="text-lg leading-relaxed text-muted-foreground drop-cap">
              {t("whatYouGetBody")}
            </p>
            <ul className="mt-10 space-y-4">
              {perks.map((perk, i) => (
                <li key={i} className="flex gap-4 text-base">
                  <span className="font-mono text-sm text-accent w-10 shrink-0 pt-1">
                    0{i + 1}
                  </span>
                  <span>{perk}</span>
                </li>
              ))}
            </ul>
          </div>
        </div>
      </section>

      {/* Tracks preview */}
      <section id="tracks" className="mx-auto max-w-6xl px-6 py-24 md:py-32">
        <p className="section-label mb-6">{t("tracksEyebrow")}</p>
        <h2 className="font-serif text-4xl leading-tight tracking-tight md:text-5xl max-w-2xl">
          {t("tracksTitle")}
        </h2>
        <div className="mt-12 border-t border-border">
          {tracks.map((track, i) => (
            <TrackCard
              key={track.id}
              index={i + 1}
              slug={track.slug}
              title={track.title}
              description={track.description}
              locale={locale}
            />
          ))}
        </div>
      </section>

      {/* Founder */}
      <section className="border-y border-border bg-secondary/30">
        <div className="mx-auto grid max-w-6xl gap-12 px-6 py-24 md:grid-cols-[1fr_1.6fr] md:py-32">
          <div>
            <p className="section-label mb-6">{t("founderEyebrow")}</p>
            <div className="aspect-[3/4] w-full bg-ink/90 flex items-end p-6">
              <div className="text-paper">
                <p className="font-serif text-2xl">{t("founderName")}</p>
                <p className="mt-1 text-xs uppercase tracking-[0.2em] text-paper/70">
                  Founder
                </p>
              </div>
            </div>
          </div>
          <div className="flex flex-col justify-center">
            <blockquote className="pull-quote">
              {t("founderQuote")}
            </blockquote>
            <p className="mt-10 max-w-2xl text-muted-foreground leading-relaxed">
              {t("founderBio")}
            </p>
          </div>
        </div>
      </section>

      {/* Pricing teaser */}
      <section className="mx-auto max-w-6xl px-6 py-24 md:py-32">
        <p className="section-label mb-6">{t("pricingTeaserEyebrow")}</p>
        <div className="grid gap-12 md:grid-cols-[1.4fr_1fr]">
          <h2 className="font-serif text-4xl leading-tight tracking-tight md:text-5xl">
            {t("pricingTeaserTitle")}
          </h2>
          <div>
            <p className="text-muted-foreground leading-relaxed">
              {t("pricingTeaserBody")}
            </p>
            <Link
              href={`/${locale}/pricing`}
              className="mt-8 inline-flex h-11 items-center bg-ink px-6 text-paper hover:bg-accent transition-colors"
            >
              {t("pricingTeaserCta")}
            </Link>
          </div>
        </div>
      </section>

      {/* FAQ */}
      <section className="border-t border-border bg-secondary/30">
        <div className="mx-auto max-w-4xl px-6 py-24 md:py-32">
          <p className="section-label mb-6">{t("faqEyebrow")}</p>
          <h2 className="font-serif text-4xl leading-tight tracking-tight md:text-5xl">
            {t("faqTitle")}
          </h2>
          <div className="mt-12">
            <FaqAccordion items={faqItems} />
          </div>
        </div>
      </section>
    </>
  );
}
