import "server-only";
import { createClient } from "@supabase/supabase-js";
import { serverEnv } from "@/lib/env";

// Service-role client — bypasses RLS. Server-only; never import from a
// Client Component. The `server-only` import enforces this at build time.
export function createSupabaseAdminClient() {
  return createClient(serverEnv.supabaseUrl, serverEnv.supabaseServiceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}
