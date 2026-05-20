type LogLevel = "debug" | "info" | "warn" | "error";

interface LogContext {
  user_id?: string;
  conversation_id?: string;
  [key: string]: unknown;
}

function emit(level: LogLevel, message: string, ctx?: LogContext) {
  const payload = { ts: new Date().toISOString(), level, message, ...ctx };
  const line = JSON.stringify(payload);
  if (level === "error" || level === "warn") {
    process.stderr.write(line + "\n");
  } else {
    process.stdout.write(line + "\n");
  }
}

export const log = {
  debug: (m: string, c?: LogContext) =>
    process.env.NODE_ENV !== "production" && emit("debug", m, c),
  info: (m: string, c?: LogContext) => emit("info", m, c),
  warn: (m: string, c?: LogContext) => emit("warn", m, c),
  error: (m: string, c?: LogContext) => emit("error", m, c),
};
