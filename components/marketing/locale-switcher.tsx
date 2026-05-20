"use client";

import { usePathname, useRouter } from "next/navigation";
import { useTransition } from "react";
import { locales, type Locale } from "@/lib/i18n";

const labels: Record<Locale, string> = {
  en: "English",
  es: "Español",
  ur: "اردو",
};

export function LocaleSwitcher({ current }: { current: Locale }) {
  const router = useRouter();
  const pathname = usePathname();
  const [, startTransition] = useTransition();

  function switchTo(next: Locale) {
    // Strip current locale segment; default to /<next>
    const stripped = pathname.replace(new RegExp(`^/${current}(?=/|$)`), "") || "/";
    const target = `/${next}${stripped === "/" ? "" : stripped}`;
    startTransition(() => router.push(target));
  }

  return (
    <div className="inline-flex items-center gap-3 text-sm">
      {locales.map((l) => (
        <button
          key={l}
          onClick={() => switchTo(l)}
          className={
            l === current
              ? "text-foreground underline underline-offset-4 decoration-accent"
              : "text-muted-foreground hover:text-foreground transition-colors"
          }
          aria-current={l === current}
        >
          {labels[l]}
        </button>
      ))}
    </div>
  );
}
