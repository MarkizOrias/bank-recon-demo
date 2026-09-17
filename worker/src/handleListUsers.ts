import { requireAdmin } from "./auth";

export default async function handleListUsers(
  request: Request,
  env: Env,
): Promise<Response> {
  const admin = await requireAdmin(request, env);
  if (!admin) {
    return Response.json({ error: "Forbidden" }, { status: 403 });
  }

  const { results } = await env.recon_demo_db
    .prepare(
      "SELECT id, username, role, active, created_at FROM Users ORDER BY username",
    )
    .all();

  return Response.json(results);
}
