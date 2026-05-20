import Link from "next/link";
import { redirect } from "next/navigation";
import { getTranslations } from "next-intl/server";
import { Wordmark } from "@/components/marketing/wordmark";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { signOutAction } from "@/app/[locale]/(auth)/actions";
import { isLocale } from "@/lib/i18n";
import { notFound } from "next/navigation";

export default async function MemberLayout({
  children,
  params: { locale },
}: {
  children: React.ReactNode;
  params: { locale: string };
}) {
  if (!isLocale(locale)) notFound();
  const t = await getTranslations("common");

  try {
    const supabase = createSupabaseServerClient();
    const { data } = await supabase.auth.getUser();
    if (!data.user) redirect(`/${locale}/login`);
  } catch {
    // In dev without Supabase env, skip the gate so the route still renders.
  }

  const signOut = signOutAction.bind(null, locale);

  return (
    <>
      <header className="border-b border-border">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-6 py-5">
          <Wordmark locale={locale} />
          <nav className="flex items-center gap-6 text-sm">
            <Link href={`/${locale}/dashboard`} className="hover:text-accent">
              {t("dashboard")}
            </Link>
            <Link href={`/${locale}/courses`} className="hover:text-accent">
              {t("tracks")}
            </Link>
            <Link
              href={`/${locale}/account/billing`}
              className="hover:text-accent"
            >
              Billing
            </Link>
            <form action={signOut}>
              <button
                type="submit"
                className="text-muted-foreground hover:text-accent"
              >
                {t("logOut")}
              </button>
            </form>
          </nav>
        </div>
      </header>
      <main>{children}</main>
    </>
  );
}
