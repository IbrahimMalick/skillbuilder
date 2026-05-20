import { getTranslations } from "next-intl/server";
import { ResetForm } from "@/components/auth/reset-form";

export default async function ResetPage({
  params: { locale },
}: {
  params: { locale: string };
}) {
  const t = await getTranslations("auth");
  return (
    <>
      <p className="section-label mb-4">§02 — Reset</p>
      <h1 className="font-serif text-4xl tracking-tight leading-tight md:text-5xl">
        {t("resetTitle")}
      </h1>
      <p className="mt-3 text-muted-foreground">{t("resetBody")}</p>
      <div className="mt-10">
        <ResetForm locale={locale} />
      </div>
    </>
  );
}
