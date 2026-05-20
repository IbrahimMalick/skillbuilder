import { getTranslations } from "next-intl/server";
import { LoginForm } from "@/components/auth/login-form";

export default async function LoginPage({
  params: { locale },
}: {
  params: { locale: string };
}) {
  const t = await getTranslations("auth");
  return (
    <>
      <p className="section-label mb-4">§01 — Welcome</p>
      <h1 className="font-serif text-4xl tracking-tight leading-tight md:text-5xl">
        {t("loginTitle")}
      </h1>
      <p className="mt-3 text-muted-foreground">{t("loginBody")}</p>
      <div className="mt-10">
        <LoginForm locale={locale} />
      </div>
    </>
  );
}
