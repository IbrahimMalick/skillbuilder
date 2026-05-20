import "server-only";
import { createSupabaseAdminClient } from "@/lib/supabase/admin";

const FOUNDING_SEAT_CAP = 50;

export interface TrackPreview {
  id: string;
  slug: string;
  title: string;
  description: string | null;
  order_index: number;
}

// Number of founding seats still available. Reads live from the subscriptions
// table; falls back to the full cap when Supabase isn't configured (dev).
export async function getFoundingSeatsRemaining(): Promise<number> {
  if (!process.env.SUPABASE_SERVICE_ROLE_KEY) return FOUNDING_SEAT_CAP;

  try {
    const supabase = createSupabaseAdminClient();
    const { count, error } = await supabase
      .from("subscriptions")
      .select("id", { count: "exact", head: true })
      .eq("tier", "founding")
      .in("status", ["active", "trialing"]);
    if (error) return FOUNDING_SEAT_CAP;
    return Math.max(0, FOUNDING_SEAT_CAP - (count ?? 0));
  } catch {
    return FOUNDING_SEAT_CAP;
  }
}

// Marketing-facing list of tracks, ordered. Returns hard-coded fallback in
// dev when Supabase isn't available so the landing page still renders.
export async function getTracks(): Promise<TrackPreview[]> {
  const fallback: TrackPreview[] = [
    { id: "fallback-1", slug: "foundations", title: "Foundations",
      description: "For the first-time founder. Find your edge, validate the idea, land the first paying customer.",
      order_index: 1 },
    { id: "fallback-2", slug: "side-to-full", title: "Side hustle to full-time",
      description: "Engineer your exit: replace your salary, build the runway, and time the leap without breaking your family.",
      order_index: 2 },
    { id: "fallback-3", slug: "scale", title: "Scale",
      description: "You have customers. Now build the systems, hires, and offers that let the business outgrow your inbox.",
      order_index: 3 },
    { id: "fallback-4", slug: "biz-to-wealth", title: "Business to wealth",
      description: "Turn cash flow into capital. Tax, holding companies, investing in yourself and in others.",
      order_index: 4 },
    { id: "fallback-5", slug: "legacy", title: "Legacy",
      description: "For the operator who has already won. Pass on what you know — to your family, your team, and the next generation.",
      order_index: 5 },
  ];

  if (!process.env.SUPABASE_SERVICE_ROLE_KEY) return fallback;

  try {
    const supabase = createSupabaseAdminClient();
    const { data, error } = await supabase
      .from("tracks")
      .select("id, slug, title, description, order_index")
      .eq("is_published", true)
      .order("order_index");
    if (error || !data || data.length === 0) return fallback;
    return data;
  } catch {
    return fallback;
  }
}
