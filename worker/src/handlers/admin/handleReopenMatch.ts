import { requireAdmin } from "./auth";

export default async function handleReopenMatch(
  request: Request,
  env: Env,
  matchId: number,
): Promise<Response> {
  const admin = await requireAdmin(request, env);
  if (!admin) return Response.json({ error: "Forbidden" }, { status: 403 });

  const match = await env.recon_demo_db
    .prepare("SELECT id, status FROM MatchResults WHERE id = ?")
    .bind(matchId)
    .first<{ id: number; status: string }>();

  if (!match)
    return Response.json({ error: "Match not found" }, { status: 404 });
  if (match.status !== "approved") {
    return Response.json(
      { error: "Only an approved match can be reopened" },
      { status: 409 },
    );
  }

  await env.recon_demo_db
    .prepare("UPDATE MatchResults SET status = 'rejected' WHERE id = ?")
    .bind(matchId)
    .run();

  const { results: matchRecords } = await env.recon_demo_db
    .prepare("SELECT record_id FROM MatchResultRecords WHERE match_id = ?")
    .bind(matchId)
    .all<{ record_id: number }>();

  for (const r of matchRecords) {
    await env.recon_demo_db
      .prepare("UPDATE ReconRecords SET status = 'unmatched' WHERE id = ?")
      .bind(r.record_id)
      .run();
  }

  await env.recon_demo_db
    .prepare(
      "INSERT INTO AuditLog (user_id, action, target_table, target_id, details) VALUES (?, 'reopen_match', 'MatchResults', ?, NULL)",
    )
    .bind(admin.userId, matchId)
    .run();

  return Response.json({ id: matchId, status: "reopened" });
}
