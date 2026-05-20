import Link from "next/link";
import { Wordmark } from "@/components/marketing/wordmark";
import { isLocale } from "@/lib/i18n";
import { notFound } from "next/navigation";
import { getTranslations } from "next-intl/server";

export default async function AuthLayout({
  children,
  params: { locale },
}: {
  children: React.ReactNode;
  params: { locale: string };
}) {
  if (!isLocale(locale)) notFound();
  const t = await getTranslations("common");

  return (
    <div className="grid min-h-screen md:grid-cols-2">
      <div className="hidden md:flex flex-col justify-between bg-ink text-paper p-12">
        <Wordmark locale={locale} />
        <div className="max-w-md">
          <p className="font-serif text-4xl leading-tight tracking-tight">
            {t("tagline")}
          </p>
        </div>
        <div className="text-xs text-paper/60">
          <Link href={`/${locale}`} className="hover:text-paper">
            ← {t("back")}
          </Link>
        </div>
      </div>
      <div className="flex items-center justify-center p-8 md:p-12">
        <div className="w-full max-w-md">{children}</div>
      </div>
    </div>
  );
}
