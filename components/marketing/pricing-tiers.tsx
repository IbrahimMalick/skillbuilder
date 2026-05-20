"use client";

import Link from "next/link";
import { useState } from "react";
import { useTranslations } from "next-intl";

type Billing = "monthly" | "annual";

export function PricingTiers({
  locale,
  seatsRemaining,
}: {
  locale: string;
  seatsRemaining: number;
}) {
  const t = useTranslations("pricing");
  const [billing, setBilling] = useState<Billing>("monthly");

  const foundingItems = t.raw("founding.items") as string[];
  const premiumItems = t.raw("premium.items") as string[];
  const soldOut = seatsRemaining <= 0;

  return (
    <>
      {/* Billing toggle */}
      <div className="mb-12 inline-flex items-center border border-border">
        {(["monthly", "annual"] as const).map((b) => (
          <button
            key={b}
            onClick={() => setBilling(b)}
            className={
              "h-10 px-5 text-sm transition-colors " +
              (billing === b
                ? "bg-ink text-paper"
                : "bg-background hover:bg-secondary")
            }
            aria-pressed={billing === b}
          >
            {t(b)}
            {b === "annual" && (
              <span className="ms-2 text-xs text-accent">
                · {t("annualSavings")}
              </span>
            )}
          </button>
        ))}
      </div>

      <div className="grid gap-px bg-border md:grid-cols-2">
        {/* Founding */}
        <div className="bg-background p-10">
          <div className="flex items-baseline justify-between">
            <h2 className="font-serif text-3xl tracking-tight">
              {t("founding.name")}
            </h2>
            <span className="section-label">
              {soldOut
                ? t("founding.tagSoldOut")
                : t("founding.tag", { count: seatsRemaining })}
            </span>
          </div>
          <div className="mt-6 flex items-baseline gap-2">
            <span className="font-serif text-5xl tracking-tight">
              {billing === "monthly"
                ? t("founding.priceMonthly")
                : t("founding.priceAnnual")}
            </span>
            <span className="text-muted-foreground">
              {billing === "monthly" ? t("founding.per") : t("founding.perAnnual")}
            </span>
          </div>
          <ul className="mt-10 space-y-3">
            {foundingItems.map((item, i) => (
              <li key={i} className="flex gap-3">
                <span className="text-accent mt-1">§</span>
                <span>{item}</span>
              </li>
            ))}
          </ul>
          <Link
            href={
              soldOut
                ? `/${locale}/signup`
                : `/${locale}/signup?plan=founding&billing=${billing}`
            }
            aria-disabled={soldOut}
            className={
              "mt-12 inline-flex h-12 w-full items-center justify-center transition-colors " +
              (soldOut
                ? "bg-secondary text-muted-foreground pointer-events-none"
                : "bg-ink text-paper hover:bg-accent")
            }
          >
            {soldOut ? t("founding.tagSoldOut") : t("founding.cta")}
          </Link>
        </div>

        {/* Premium */}
        <div className="bg-background p-10">
          <h2 className="font-serif text-3xl tracking-tight">
            {t("premium.name")}
          </h2>
          <div className="mt-6 flex items-baseline gap-2">
            <span className="font-serif text-5xl tracking-tight">
              {billing === "monthly"
                ? t("premium.priceMonthly")
                : t("premium.priceAnnual")}
            </span>
            <span className="text-muted-foreground">
              {billing === "monthly" ? t("premium.per") : t("premium.perAnnual")}
            </span>
          </div>
          <ul className="mt-10 space-y-3">
            {premiumItems.map((item, i) => (
              <li key={i} className="flex gap-3">
                <span className="text-accent mt-1">§</span>
                <span>{item}</span>
              </li>
            ))}
          </ul>
          <Link
            href={`/${locale}/signup?plan=premium&billing=${billing}`}
            className="mt-12 inline-flex h-12 w-full items-center justify-center border border-ink text-ink hover:bg-ink hover:text-paper transition-colors"
          >
            {t("premium.cta")}
          </Link>
        </div>
      </div>
    </>
  );
}
