import {
  requireAdmin,
  generateSalt,
  bufferToHex,
  hashPassword,
  generateTempPassword,
} from "./auth";

export default async function handleCreateUser(
  request: Request,
  env: Env,
): Promise<Response> {
  const admin = await requireAdmin(request, env);
  if (!admin) return Response.json({ error: "Forbidden" }, { status: 403 });

  const body = await request.json<{ username?: string; role?: string }>();

  if (!body.username || !body.role) {
    return Response.json(
      { error: "Missing username or role" },
      { status: 400 },
    );
  }
  if (body.role !== "admin" && body.role !== "reconciler") {
    return Response.json({ error: "Invalid role" }, { status: 400 });
  }

  const tempPassword = generateTempPassword();
  const salt = generateSalt();
  const saltHex = bufferToHex(salt);
  const passwordHash = await hashPassword(tempPassword, salt);

  try {
    const result = await env.recon_demo_db
      .prepare(
        "INSERT INTO Users (username, password_hash, salt, role, active, must_change_password) VALUES (?, ?, ?, ?, 1, 1)",
      )
      .bind(body.username, passwordHash, saltHex, body.role)
      .run();

    await env.recon_demo_db
      .prepare(
        "INSERT INTO AuditLog (user_id, action, target_table, target_id, details) VALUES (?, 'create_user', 'Users', ?, ?)",
      )
      .bind(
        admin.userId,
        result.meta.last_row_id,
        JSON.stringify({ created_username: body.username, role: body.role }),
      )
      .run();

    return Response.json(
      {
        id: result.meta.last_row_id,
        username: body.username,
        role: body.role,
        tempPassword,
      },
      { status: 201 },
    );
  } catch (e) {
    return Response.json(
      { error: "Username may already exist" },
      { status: 409 },
    );
  }
}
