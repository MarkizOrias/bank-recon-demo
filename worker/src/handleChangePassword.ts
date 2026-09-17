import {
  requireAuth,
  verifyPassword,
  generateSalt,
  bufferToHex,
  hashPassword,
} from "./auth";

export default async function handleChangePassword(
  request: Request,
  env: Env,
): Promise<Response> {
  const session = await requireAuth(request, env);
  if (!session)
    return Response.json({ error: "Unauthorized" }, { status: 401 });

  const body = await request.json<{
    currentPassword?: string;
    newPassword?: string;
  }>();
  if (!body.currentPassword || !body.newPassword) {
    return Response.json(
      { error: "Missing currentPassword or newPassword" },
      { status: 400 },
    );
  }

  const user = await env.recon_demo_db
    .prepare("SELECT password_hash, salt FROM Users WHERE id = ?")
    .bind(session.userId)
    .first<{ password_hash: string; salt: string }>();

  if (!user) return Response.json({ error: "User not found" }, { status: 404 });

  const currentValid = await verifyPassword(
    body.currentPassword,
    user.salt,
    user.password_hash,
  );
  if (!currentValid)
    return Response.json(
      { error: "Current password is incorrect" },
      { status: 401 },
    );

  const salt = generateSalt();
  const saltHex = bufferToHex(salt);
  const newHash = await hashPassword(body.newPassword, salt);

  await env.recon_demo_db
    .prepare(
      "UPDATE Users SET password_hash = ?, salt = ?, must_change_password = 0 WHERE id = ?",
    )
    .bind(newHash, saltHex, session.userId)
    .run();

  await env.recon_demo_db
    .prepare(
      "INSERT INTO AuditLog (user_id, action, target_table, target_id, details) VALUES (?, 'change_password', 'Users', ?, NULL)",
    )
    .bind(session.userId, session.userId)
    .run();

  return Response.json({ success: true });
}
