import Link from "next/link";
import { getTranslations } from "next-intl/server";
import { LocaleSwitcher } from "./locale-switcher";
import type { Locale } from "@/lib/i18n";

export async function MarketingFooter({ locale }: { locale: Locale }) {
  const t = await getTranslations();
  const year = new Date().getFullYear();

  return (
    <footer className="border-t border-border/60 mt-32">
      <div className="mx-auto grid max-w-6xl grid-cols-2 gap-12 px-6 py-16 md:grid-cols-4">
        <div className="col-span-2 md:col-span-2">
          <p className="font-serif text-xl tracking-tight">
            {t("common.appName")}
          </p>
          <p className="mt-3 max-w-sm text-sm text-muted-foreground">
            {t("common.tagline")}
          </p>
        </div>

        <div>
          <p className="section-label mb-4">{t("footer.product")}</p>
          <ul className="space-y-2 text-sm">
            <li>
              <Link href={`/${locale}/pricing`} className="hover:text-accent">
                {t("common.pricing")}
              </Link>
            </li>
            <li>
              <Link href={`/${locale}#tracks`} className="hover:text-accent">
                {t("common.tracks")}
              </Link>
            </li>
            <li>
              <Link href={`/${locale}/signup`} className="hover:text-accent">
                {t("common.signUp")}
              </Link>
            </li>
          </ul>
        </div>

        <div>
          <p className="section-label mb-4">{t("footer.legal")}</p>
          <ul className="space-y-2 text-sm">
            <li>
              <Link href={`/${locale}/terms`} className="hover:text-accent">
                {t("footer.terms")}
              </Link>
            </li>
            <li>
              <Link href={`/${locale}/privacy`} className="hover:text-accent">
                {t("footer.privacy")}
              </Link>
            </li>
            <li>
              <Link href={`/${locale}/contact`} className="hover:text-accent">
                {t("footer.contact")}
              </Link>
            </li>
          </ul>
        </div>
      </div>

      <div className="mx-auto flex max-w-6xl flex-col items-start justify-between gap-6 border-t border-border/60 px-6 py-6 md:flex-row md:items-center">
        <p className="text-xs text-muted-foreground">
          {t("footer.rights", { year })}
        </p>
        <div className="flex items-center gap-4">
          <span className="section-label">{t("footer.language")}</span>
          <LocaleSwitcher current={locale} />
        </div>
      </div>
    </footer>
  );
}
