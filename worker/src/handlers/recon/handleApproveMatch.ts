import { requireReconciler } from "../../handlers/admin/auth";

export default async function handleApproveMatch(
  request: Request,
  env: Env,
  matchId: number,
): Promise<Response> {
  const session = await requireReconciler(request, env);
  if (!session) return Response.json({ error: "Forbidden" }, { status: 403 });

  const match = await env.recon_demo_db
    .prepare("SELECT id, status, matched_by FROM MatchResults WHERE id = ?")
    .bind(matchId)
    .first<{ id: number; status: string; matched_by: number }>();

  if (!match)
    return Response.json({ error: "Match not found" }, { status: 404 });
  if (match.status !== "pending")
    return Response.json({ error: "Match is not pending" }, { status: 409 });
  if (match.matched_by === session.userId) {
    return Response.json(
      { error: "Cannot approve your own proposed match" },
      { status: 403 },
    );
  }

  await env.recon_demo_db
    .prepare(
      "UPDATE MatchResults SET status = 'approved', approved_by = ?, approved_at = datetime('now') WHERE id = ?",
    )
    .bind(session.userId, matchId)
    .run();

  const { results: matchRecords } = await env.recon_demo_db
    .prepare("SELECT record_id FROM MatchResultRecords WHERE match_id = ?")
    .bind(matchId)
    .all<{ record_id: number }>();

  for (const r of matchRecords) {
    await env.recon_demo_db
      .prepare("UPDATE ReconRecords SET status = 'matched' WHERE id = ?")
      .bind(r.record_id)
      .run();
  }

  await env.recon_demo_db
    .prepare(
      "INSERT INTO AuditLog (user_id, action, target_table, target_id, details) VALUES (?, 'approve_match', 'MatchResults', ?, NULL)",
    )
    .bind(session.userId, matchId)
    .run();

  return Response.json({ id: matchId, status: "approved" });
}
