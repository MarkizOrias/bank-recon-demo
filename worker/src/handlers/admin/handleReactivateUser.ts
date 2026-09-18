import {
  requireAdmin,
  generateSalt,
  bufferToHex,
  hashPassword,
  generateTempPassword,
} from "./auth";

export default async function handleReactivateUser(
  request: Request,
  env: Env,
  targetId: number,
): Promise<Response> {
  const admin = await requireAdmin(request, env);
  if (!admin) return Response.json({ error: "Forbidden" }, { status: 403 });

  const tempPassword = generateTempPassword();
  const salt = generateSalt();
  const saltHex = bufferToHex(salt);
  const passwordHash = await hashPassword(tempPassword, salt);

  await env.recon_demo_db
    .prepare(
      "UPDATE Users SET active = 1, password_hash = ?, salt = ?, must_change_password = 1 WHERE id = ?",
    )
    .bind(passwordHash, saltHex, targetId)
    .run();

  await env.recon_demo_db
    .prepare(
      "INSERT INTO AuditLog (user_id, action, target_table, target_id, details) VALUES (?, 'reactivate_user', 'Users', ?, NULL)",
    )
    .bind(admin.userId, targetId)
    .run();

  return Response.json({ id: targetId, active: true, tempPassword });
}
