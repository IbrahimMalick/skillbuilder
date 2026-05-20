"use server";

import { redirect } from "next/navigation";
import { headers } from "next/headers";
import { z } from "zod";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";
import { defaultLocale, isLocale, type Locale } from "@/lib/i18n";
import { log } from "@/lib/log";

const signupSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8).max(72),
  fullName: z.string().min(1).max(120).optional(),
  locale: z.string(),
});

const loginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(1),
  locale: z.string(),
});

const magicSchema = z.object({
  email: z.string().email(),
  locale: z.string(),
});

const resetSchema = z.object({
  email: z.string().email(),
  locale: z.string(),
});

export type AuthState = { ok: boolean; error?: string; message?: string };

function detectLocaleFromHeader(): Locale {
  const accept = headers().get("accept-language")?.split(",")[0]?.trim().slice(0, 2);
  return accept && isLocale(accept) ? accept : defaultLocale;
}

function siteUrl(): string {
  return (
    process.env.NEXT_PUBLIC_SITE_URL ??
    `https://${headers().get("host") ?? "localhost:3000"}`
  );
}

export async function signupAction(
  _prev: AuthState,
  formData: FormData
): Promise<AuthState> {
  const parsed = signupSchema.safeParse({
    email: formData.get("email"),
    password: formData.get("password"),
    fullName: formData.get("fullName") || undefined,
    locale: formData.get("locale"),
  });
  if (!parsed.success) return { ok: false, error: "invalid" };

  const { email, password, fullName, locale } = parsed.data;
  const localeForProfile = isLocale(locale) ? locale : detectLocaleFromHeader();

  try {
    const supabase = createSupabaseServerClient();
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        emailRedirectTo: `${siteUrl()}/${localeForProfile}/auth/callback`,
        data: { full_name: fullName, locale: localeForProfile },
      },
    });
    if (error) {
      log.warn("signup_failed", { email, error: error.message });
      return { ok: false, error: error.message };
    }

    // Provision a profile row using the service role so it bypasses RLS and
    // doesn't require the user's first session to land.
    if (data.user) {
      const admin = createSupabaseAdminClient();
      await admin.from("profiles").upsert({
        id: data.user.id,
        email,
        full_name: fullName ?? null,
        locale: localeForProfile,
      });
    }
  } catch (e) {
    log.error("signup_error", { email, error: String(e) });
    return { ok: false, error: "generic" };
  }

  return { ok: true, message: "checkEmail" };
}

export async function loginAction(
  _prev: AuthState,
  formData: FormData
): Promise<AuthState> {
  const parsed = loginSchema.safeParse({
    email: formData.get("email"),
    password: formData.get("password"),
    locale: formData.get("locale"),
  });
  if (!parsed.success) return { ok: false, error: "invalid" };

  const { email, password, locale } = parsed.data;
  try {
    const supabase = createSupabaseServerClient();
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) {
      return { ok: false, error: "invalidCredentials" };
    }
  } catch (e) {
    log.error("login_error", { email, error: String(e) });
    return { ok: false, error: "generic" };
  }

  redirect(`/${isLocale(locale) ? locale : defaultLocale}/dashboard`);
}

export async function magicLinkAction(
  _prev: AuthState,
  formData: FormData
): Promise<AuthState> {
  const parsed = magicSchema.safeParse({
    email: formData.get("email"),
    locale: formData.get("locale"),
  });
  if (!parsed.success) return { ok: false, error: "invalid" };

  const { email, locale } = parsed.data;
  try {
    const supabase = createSupabaseServerClient();
    const { error } = await supabase.auth.signInWithOtp({
      email,
      options: {
        emailRedirectTo: `${siteUrl()}/${
          isLocale(locale) ? locale : defaultLocale
        }/auth/callback`,
      },
    });
    if (error) return { ok: false, error: error.message };
  } catch (e) {
    log.error("magic_error", { email, error: String(e) });
    return { ok: false, error: "generic" };
  }
  return { ok: true, message: "magicLinkSent" };
}

export async function resetPasswordAction(
  _prev: AuthState,
  formData: FormData
): Promise<AuthState> {
  const parsed = resetSchema.safeParse({
    email: formData.get("email"),
    locale: formData.get("locale"),
  });
  if (!parsed.success) return { ok: false, error: "invalid" };

  const { email, locale } = parsed.data;
  try {
    const supabase = createSupabaseServerClient();
    await supabase.auth.resetPasswordForEmail(email, {
      redirectTo: `${siteUrl()}/${
        isLocale(locale) ? locale : defaultLocale
      }/auth/callback?next=/account/billing`,
    });
  } catch (e) {
    log.error("reset_error", { email, error: String(e) });
    // Always show generic confirmation to avoid leaking account existence.
  }
  return { ok: true, message: "resetSent" };
}

export async function signOutAction(locale: string) {
  try {
    const supabase = createSupabaseServerClient();
    await supabase.auth.signOut();
  } catch {
    // best-effort
  }
  redirect(`/${isLocale(locale) ? locale : defaultLocale}`);
}
