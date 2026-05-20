import { getTranslations } from "next-intl/server";
import { PricingTiers } from "@/components/marketing/pricing-tiers";
import { FaqAccordion } from "@/components/marketing/faq-accordion";
import { getFoundingSeatsRemaining } from "@/lib/marketing";

export default async function PricingPage({
  params: { locale },
}: {
  params: { locale: string };
}) {
  const [t, tFaq, seatsRemaining] = await Promise.all([
    getTranslations("pricing"),
    getTranslations("faqs"),
    getFoundingSeatsRemaining(),
  ]);

  const faqItems = (["q3", "q4", "q5", "q2"] as const).map((k) => ({
    q: tFaq(`${k}.q`),
    a: tFaq(`${k}.a`),
  }));

  return (
    <>
      <section className="mx-auto max-w-6xl px-6 py-24 md:py-32">
        <p className="section-label mb-6">{t("eyebrow")}</p>
        <h1 className="font-serif text-5xl leading-[1.05] tracking-tight md:text-6xl max-w-3xl">
          {t("title")}
        </h1>
        <p className="mt-8 max-w-2xl text-lg text-muted-foreground">
          {t("subtitle")}
        </p>

        <div className="mt-16">
          <PricingTiers locale={locale} seatsRemaining={seatsRemaining} />
        </div>
      </section>

      <section className="border-t border-border bg-secondary/30">
        <div className="mx-auto max-w-4xl px-6 py-24">
          <FaqAccordion items={faqItems} />
        </div>
      </section>
    </>
  );
}
