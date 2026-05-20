import { MarketingNav } from "@/components/marketing/nav";
import { MarketingFooter } from "@/components/marketing/footer";
import { isLocale } from "@/lib/i18n";
import { notFound } from "next/navigation";

export default function MarketingLayout({
  children,
  params: { locale },
}: {
  children: React.ReactNode;
  params: { locale: string };
}) {
  if (!isLocale(locale)) notFound();

  return (
    <>
      <MarketingNav locale={locale} />
      <main>{children}</main>
      <MarketingFooter locale={locale} />
    </>
  );
}
