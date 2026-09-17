import { verifyPassword } from "./auth";
import { generateToken } from "./generateToken";

export default async function handleLogin(
  request: Request,
  env: Env,
): Promise<Response> {
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
