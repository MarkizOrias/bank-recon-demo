export function bufferToHex(buffer: ArrayBuffer | Uint8Array): string {
  return Array.from(new Uint8Array(buffer))
    .map((byte) => byte.toString(16).padStart(2, "0"))
    .join("");
}

export async function hashPassword(
  password: string,
  salt: Uint8Array,
): Promise<string> {
  const encoder = new TextEncoder();
  const keyMaterial = await crypto.subtle.importKey(
    "raw",
    encoder.encode(password),
    "PBKDF2",
    false,
    ["deriveBits"],
  );

  const derivedBits = await crypto.subtle.deriveBits(
    {
      name: "PBKDF2",
      salt: salt,
      iterations: 100000,
      hash: "SHA-256",
    },
    keyMaterial,
    256,
  );

  return bufferToHex(derivedBits);
}

export function generateSalt(): Uint8Array {
  return crypto.getRandomValues(new Uint8Array(16));
}

export async function verifyPassword(
  password: string,
  saltHex: string,
  expectedHashHex: string,
): Promise<boolean> {
  const salt = hexToBuffer(saltHex);
  const actualHashHex = await hashPassword(password, salt);
  return actualHashHex === expectedHashHex;
}

export function hexToBuffer(hex: string): Uint8Array {
  const bytes = new Uint8Array(hex.length / 2);
  for (let i = 0; i < hex.length; i += 2) {
    bytes[i / 2] = parseInt(hex.substr(i, 2), 16);
  }
  return bytes;
}

export async function verifySession(
  token: string,
  env: Env,
): Promise<{ userId: number; username: string; role: string } | null> {
  const session = await env.recon_demo_db
    .prepare(
      `SELECT Sessions.user_id, Sessions.expires_at, Sessions.revoked, Users.username, Users.role, Users.active
       FROM Sessions
       JOIN Users ON Users.id = Sessions.user_id
       WHERE Sessions.token = ?`,
    )
    .bind(token)
    .first<{
      user_id: number;
      expires_at: string;
      revoked: number;
      username: string;
      role: string;
      active: number;
    }>();

  if (!session) return null;
  if (session.revoked === 1) return null;
  if (session.active !== 1) return null;
  if (new Date(session.expires_at) < new Date()) return null;

  return {
    userId: session.user_id,
    username: session.username,
    role: session.role,
  };
}

export async function requireAdmin(
  request: Request,
  env: Env,
): Promise<{ userId: number; username: string; role: string } | null> {
  const authHeader = request.headers.get("Authorization");
  const token = authHeader?.startsWith("Bearer ") ? authHeader.slice(7) : null;

  if (!token) return null;

  const session = await verifySession(token, env);

  if (!session || session.role !== "admin") return null;

  return session;
}
