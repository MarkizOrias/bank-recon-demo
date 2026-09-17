import { bufferToHex, generateSalt, hashPassword, requireAdmin } from "./auth";

export default async function handleReactivateUser(
  request: Request,
  env: Env,
  targetId: number,
): Promise<Response> {
  const admin = await requireAdmin(request, env);
  if (!admin) {
    return Response.json({ error: "Forbidden" }, { status: 403 });
  }

  const body = await request.json<{ password?: string }>();

  if (!body.password) {
    return Response.json(
      { error: "New password required to reactivate" },
      { status: 400 },
    );
  }

  const salt = generateSalt();
  const saltHex = bufferToHex(salt);
  const passwordHash = await hashPassword(body.password, salt);

  await env.recon_demo_db
    .prepare(
      "UPDATE Users SET active = 1, password_hash = ?, salt = ? WHERE id = ?",
    )
    .bind(passwordHash, saltHex, targetId)
    .run();

  await env.recon_demo_db
    .prepare(
      "INSERT INTO AuditLog (user_id, action, target_table, target_id, details) VALUES (?, 'reactivate_user', 'Users', ?, NULL)",
    )
    .bind(admin.userId, targetId)
    .run();

  return Response.json({ id: targetId, active: true });
}
