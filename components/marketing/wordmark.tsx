import Link from "next/link";

export function Wordmark({ locale }: { locale: string }) {
  return (
    <Link
      href={`/${locale}`}
      className="inline-flex items-baseline gap-2 font-serif text-lg leading-none tracking-tight"
    >
      <span className="text-accent">§</span>
      <span>IDesire Academy</span>
    </Link>
  );
}
