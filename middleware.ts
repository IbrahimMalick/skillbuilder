import { NextResponse, type NextRequest } from "next/server";
import { createServerClient, type CookieOptions } from "@supabase/ssr";
import createIntlMiddleware from "next-intl/middleware";
import { locales, defaultLocale } from "@/lib/i18n";

const intlMiddleware = createIntlMiddleware({
  locales: locales as unknown as string[],
  defaultLocale,
  localePrefix: "always",
});

export async function middleware(request: NextRequest) {
  // 1. Locale routing first — produces a response we'll forward Supabase
  //    cookies onto.
  const response = intlMiddleware(request);

  // 2. Refresh Supabase session by re-reading & re-writing the auth cookies.
  const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const supabaseAnon = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!supabaseUrl || !supabaseAnon) return response;

  const supabase = createServerClient(supabaseUrl, supabaseAnon, {
    cookies: {
      get(name: string) {
        return request.cookies.get(name)?.value;
      },
      set(name: string, value: string, options: CookieOptions) {
        response.cookies.set({ name, value, ...options });
      },
      remove(name: string, options: CookieOptions) {
        response.cookies.set({ name, value: "", ...options });
      },
    },
  });

  await supabase.auth.getUser();
  return response;
}

export const config = {
  // Match everything except Next internals, static files, and API routes.
  matcher: ["/((?!api|_next|_vercel|.*\\..*).*)"],
};
