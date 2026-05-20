import { getTranslations } from "next-intl/server";
import { SignupForm } from "@/components/auth/signup-form";

export default async function SignupPage({
  params: { locale },
}: {
  params: { locale: string };
}) {
  const t = await getTranslations("auth");
  return (
    <>
      <p className="section-label mb-4">§01 — Create account</p>
      <h1 className="font-serif text-4xl tracking-tight leading-tight md:text-5xl">
        {t("signupTitle")}
      </h1>
      <p className="mt-3 text-muted-foreground">{t("signupBody")}</p>
      <div className="mt-10">
        <SignupForm locale={locale} />
      </div>
    </>
  );
}
