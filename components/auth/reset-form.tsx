"use client";

import { useFormState, useFormStatus } from "react-dom";
import { useTranslations } from "next-intl";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { resetPasswordAction, type AuthState } from "@/app/[locale]/(auth)/actions";

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

export function ResetForm({ locale }: { locale: string }) {
  const t = useTranslations("auth");
  const [state, action] = useFormState(resetPasswordAction, initial);

  return (
    <form action={action} className="space-y-5">
      <input type="hidden" name="locale" value={locale} />
      <div>
        <Label htmlFor="email">{t("email")}</Label>
        <Input id="email" name="email" type="email" required className="mt-2" />
      </div>
      {state.ok && <p className="text-sm text-accent">{t("resetSent")}</p>}
      <SubmitButton label={t("sendResetLink")} />
    </form>
  );
}
