import { verifySession } from "./auth";

export default async function handleMe(
  request: Request,
  env: Env,
): Promise<Response> {
  const authHeader = request.headers.get("Authorization");
  const token = authHeader?.startsWith("Bearer ") ? authHeader.slice(7) : null;

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
