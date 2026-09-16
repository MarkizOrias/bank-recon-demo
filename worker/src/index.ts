import { verifyPassword, verifySession } from "./auth";

// npx wrangler dev
export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    if (url.pathname === "/debug/tables") {
      const { results } = await env.recon_demo_db
        .prepare("SELECT name FROM sqlite_master WHERE type='table'")
        .all();
      return Response.json(results);
    }

    if (url.pathname === "/login" && request.method === "POST") {
      return handleLogin(request, env);
    }

    if (url.pathname === "/me" && request.method === "GET") {
      const authHeader = request.headers.get("Authorization");
      const token = authHeader?.startsWith("Bearer ")
        ? authHeader.slice(7)
        : null;

      if (!token) {
        return Response.json({ error: "Missing token" }, { status: 401 });
      }

      const session = await verifySession(token, env);

      if (!session) {
        return Response.json(
          { error: "Invalid or expired session" },
          { status: 401 },
        );
      }

      return Response.json({ username: session.username, role: session.role });
    }

    return new Response("Not found", { status: 404 });
  },
};

async function handleLogin(request: Request, env: Env): Promise<Response> {
  const body = await request.json<{ username?: string; password?: string }>();

  if (!body.username || !body.password) {
    return Response.json(
      { error: "Missing username or password" },
      { status: 400 },
    );
  }

  const user = await env.recon_demo_db
    .prepare(
      "SELECT id, password_hash, salt, role, active FROM Users WHERE username = ?",
    )
    .bind(body.username)
    .first<{
      id: number;
      password_hash: string;
      salt: string;
      role: string;
      active: number;
    }>();

  if (!user || user.active !== 1) {
    return Response.json({ error: "Invalid credentials" }, { status: 401 });
  }

  const passwordValid = await verifyPassword(
    body.password,
    user.salt,
    user.password_hash,
  );

  if (!passwordValid) {
    return Response.json({ error: "Invalid credentials" }, { status: 401 });
  }

  const token = generateToken();
  const expiresAt = new Date(Date.now() + 8 * 60 * 60 * 1000).toISOString();

  await env.recon_demo_db
    .prepare(
      "INSERT INTO Sessions (user_id, token, expires_at) VALUES (?, ?, ?)",
    )
    .bind(user.id, token, expiresAt)
    .run();

  return Response.json({ token, role: user.role });
}

function generateToken(): string {
  const bytes = crypto.getRandomValues(new Uint8Array(32));
  return Array.from(bytes)
    .map((b) => b.toString(16).padStart(2, "0"))
    .join("");
}
