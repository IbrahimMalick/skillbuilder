"use client";

import Link from "next/link";
import { useFormState, useFormStatus } from "react-dom";
import { useTranslations } from "next-intl";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { loginAction, magicLinkAction, type AuthState } from "@/app/[locale]/(auth)/actions";

const initial: AuthState = { ok: false };

function SubmitButton({ label }: { label: string }) {
  const { pending } = useFormStatus();
  return (
    <button
      type="submit"
      disabled={pending}
      className="mt-4 inline-flex h-12 w-full items-center justify-center bg-ink text-paper hover:bg-accent transition-colors disabled:opacity-50"
    >
      {pending ? "…" : label}
    </button>
  );
}

export function LoginForm({ locale }: { locale: string }) {
  const t = useTranslations("auth");
  const [state, action] = useFormState(loginAction, initial);
  const [magicState, magicAction] = useFormState(magicLinkAction, initial);

  return (
    <>
      <form action={action} className="space-y-5">
        <input type="hidden" name="locale" value={locale} />
        <div>
          <Label htmlFor="email">{t("email")}</Label>
          <Input id="email" name="email" type="email" autoComplete="email" required className="mt-2" />
        </div>
        <div>
          <Label htmlFor="password">{t("password")}</Label>
          <Input
            id="password"
            name="password"
            type="password"
            autoComplete="current-password"
            required
            className="mt-2"
          />
        </div>

        {state.error === "invalidCredentials" && (
          <p className="text-sm text-destructive">{t("errorInvalidCredentials")}</p>
        )}
        {state.error && state.error !== "invalidCredentials" && (
          <p className="text-sm text-destructive">{t("errorGeneric")}</p>
        )}

        <SubmitButton label={t("logIn")} />
      </form>

      <div className="mt-6 flex justify-between text-sm">
        <Link
          href={`/${locale}/reset`}
          className="underline underline-offset-4 decoration-accent hover:text-accent"
        >
          {t("forgotPassword")}
        </Link>
        <form action={magicAction} className="inline">
          <input type="hidden" name="locale" value={locale} />
          <input
            type="email"
            name="email"
            placeholder={t("email")}
            className="border-b border-border bg-transparent px-1 text-sm focus:outline-none focus:border-accent"
            required
          />
          <button
            type="submit"
            className="ms-2 underline underline-offset-4 decoration-accent hover:text-accent"
          >
            {t("magicLink")}
          </button>
        </form>
      </div>
      {magicState.ok && (
        <p className="mt-3 text-sm text-accent">{t("magicLinkSent")}</p>
      )}

      <p className="mt-10 text-sm text-muted-foreground">
        {t("noAccount")}{" "}
        <Link
          href={`/${locale}/signup`}
          className="underline underline-offset-4 decoration-accent hover:text-accent"
        >
          {t("signUp")}
        </Link>
      </p>
    </>
  );
}
