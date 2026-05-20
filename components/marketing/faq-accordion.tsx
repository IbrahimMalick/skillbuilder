interface FaqItem {
  q: string;
  a: string;
}

export function FaqAccordion({ items }: { items: FaqItem[] }) {
  return (
    <div className="divide-y divide-border border-y border-border">
      {items.map((item, i) => (
        <details
          key={i}
          className="group [&[open]>summary>span:last-child]:rotate-45"
        >
          <summary className="flex cursor-pointer list-none items-center justify-between gap-6 py-6 pr-2">
            <span className="font-serif text-xl tracking-tight md:text-2xl">
              {item.q}
            </span>
            <span className="text-2xl text-accent transition-transform">+</span>
          </summary>
          <p className="pb-6 pr-12 text-muted-foreground leading-relaxed">
            {item.a}
          </p>
        </details>
      ))}
    </div>
  );
}
