"use client";

import Link from "next/link";
import { useFormState, useFormStatus } from "react-dom";
import { useTranslations } from "next-intl";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { signupAction, magicLinkAction, type AuthState } from "@/app/[locale]/(auth)/actions";

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

export function SignupForm({ locale }: { locale: string }) {
  const t = useTranslations("auth");
  const [state, action] = useFormState(signupAction, initial);
  const [magicState, magicAction] = useFormState(magicLinkAction, initial);

  return (
    <>
      <form action={action} className="space-y-5">
        <input type="hidden" name="locale" value={locale} />
        <div>
          <Label htmlFor="fullName">{t("fullName")}</Label>
          <Input id="fullName" name="fullName" type="text" autoComplete="name" className="mt-2" />
        </div>
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
            autoComplete="new-password"
            minLength={8}
            required
            className="mt-2"
          />
        </div>

        {state.error && (
          <p className="text-sm text-destructive">{t("errorGeneric")}</p>
        )}
        {state.ok && state.message === "checkEmail" && (
          <p className="text-sm text-accent">{t("checkEmail")}</p>
        )}

        <SubmitButton label={t("createAccount")} />
      </form>

      <div className="my-8 flex items-center gap-4">
        <span className="h-px flex-1 bg-border" />
        <span className="section-label">or</span>
        <span className="h-px flex-1 bg-border" />
      </div>

      <form action={magicAction} className="space-y-3">
        <input type="hidden" name="locale" value={locale} />
        <Input name="email" type="email" placeholder={t("email")} required />
        <button
          type="submit"
          className="text-sm underline underline-offset-4 decoration-accent hover:text-accent"
        >
          {t("magicLink")}
        </button>
        {magicState.ok && (
          <p className="text-sm text-accent">{t("magicLinkSent")}</p>
        )}
      </form>

      <p className="mt-10 text-sm text-muted-foreground">
        {t("haveAccount")}{" "}
        <Link
          href={`/${locale}/login`}
          className="underline underline-offset-4 decoration-accent hover:text-accent"
        >
          {t("logIn")}
        </Link>
      </p>
    </>
  );
}
