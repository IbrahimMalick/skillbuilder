import Link from "next/link";

export function TrackCard({
  index,
  slug,
  title,
  description,
  locale,
}: {
  index: number;
  slug: string;
  title: string;
  description: string | null;
  locale: string;
}) {
  return (
    <Link
      href={`/${locale}/tracks/${slug}`}
      className="group block border-b border-border py-8 transition-colors hover:bg-secondary/40"
    >
      <div className="flex items-baseline gap-6">
        <span className="font-mono text-sm text-accent w-10 shrink-0">
          §0{index}
        </span>
        <div className="flex-1">
          <h3 className="font-serif text-3xl tracking-tight md:text-4xl">
            {title}
          </h3>
          {description && (
            <p className="mt-2 max-w-2xl text-muted-foreground">
              {description}
            </p>
          )}
        </div>
        <span className="hidden md:inline text-muted-foreground transition-transform group-hover:translate-x-1">
          →
        </span>
      </div>
    </Link>
  );
}
