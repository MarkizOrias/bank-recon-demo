import { requireAdmin } from "./auth";

export default async function handleDeactivateUser(
  request: Request,
  env: Env,
  targetId: number,
): Promise<Response> {
  const admin = await requireAdmin(request, env);
  if (!admin) {
    return Response.json({ error: "Forbidden" }, { status: 403 });
  }

  if (targetId === admin.userId) {
    return Response.json(
      { error: "Cannot deactivate your own account" },
      { status: 400 },
    );
  }

  await env.recon_demo_db
    .prepare("UPDATE Users SET active = 0 WHERE id = ?")
    .bind(targetId)
    .run();

  await env.recon_demo_db
    .prepare(
      "INSERT INTO AuditLog (user_id, action, target_table, target_id, details) VALUES (?, 'deactivate_user', 'Users', ?, NULL)",
    )
    .bind(admin.userId, targetId)
    .run();

  return Response.json({ id: targetId, active: false });
}
