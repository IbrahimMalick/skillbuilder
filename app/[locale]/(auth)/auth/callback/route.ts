import { NextResponse, type NextRequest } from "next/server";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { defaultLocale, isLocale } from "@/lib/i18n";

// Exchange the email-confirmation / magic-link / password-reset code for a
// session, then redirect into the app. `next` is an opt-in landing path.
export async function GET(
  request: NextRequest,
  { params }: { params: { locale: string } }
) {
  const url = new URL(request.url);
  const code = url.searchParams.get("code");
  const next = url.searchParams.get("next") ?? "/dashboard";
  const locale = isLocale(params.locale) ? params.locale : defaultLocale;

  if (code) {
    const supabase = createSupabaseServerClient();
    const { error } = await supabase.auth.exchangeCodeForSession(code);
    if (error) {
      return NextResponse.redirect(
        new URL(`/${locale}/login?error=callback`, url.origin)
      );
    }
  }

  // Ensure `next` always starts with `/` and is locale-prefixed.
  const safeNext = next.startsWith("/") ? next : `/${next}`;
  const target = safeNext.startsWith(`/${locale}/`)
    ? safeNext
    : `/${locale}${safeNext}`;
  return NextResponse.redirect(new URL(target, url.origin));
}
