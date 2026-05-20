import Link from "next/link";
import { getTranslations } from "next-intl/server";
import { Wordmark } from "./wordmark";
import { createSupabaseServerClient } from "@/lib/supabase/server";

export async function MarketingNav({ locale }: { locale: string }) {
  const t = await getTranslations("common");

  let signedIn = false;
  try {
    const supabase = createSupabaseServerClient();
    const { data } = await supabase.auth.getUser();
    signedIn = !!data.user;
  } catch {
    // Supabase env not configured in dev — render unauthenticated nav.
  }

  return (
    <header className="border-b border-border/60">
      <div className="mx-auto flex max-w-6xl items-center justify-between px-6 py-5">
        <Wordmark locale={locale} />
        <nav className="flex items-center gap-7 text-sm">
          <Link href={`/${locale}#tracks`} className="hover:text-accent">
            {t("tracks")}
          </Link>
          <Link href={`/${locale}/pricing`} className="hover:text-accent">
            {t("pricing")}
          </Link>
          {signedIn ? (
            <Link
              href={`/${locale}/dashboard`}
              className="inline-flex h-9 items-center bg-ink px-4 text-paper hover:bg-accent transition-colors"
            >
              {t("dashboard")}
            </Link>
          ) : (
            <>
              <Link href={`/${locale}/login`} className="hover:text-accent">
                {t("signIn")}
              </Link>
              <Link
                href={`/${locale}/signup`}
                className="inline-flex h-9 items-center bg-ink px-4 text-paper hover:bg-accent transition-colors"
              >
                {t("signUp")}
              </Link>
            </>
          )}
        </nav>
      </div>
    </header>
  );
}
