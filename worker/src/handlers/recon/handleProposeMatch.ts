import { requireReconciler } from "../../handlers/admin/auth";

export default async function handleProposeMatch(
  request: Request,
  env: Env,
): Promise<Response> {
  const session = await requireReconciler(request, env);
  if (!session) return Response.json({ error: "Forbidden" }, { status: 403 });

  const body = await request.json<{ recordIds?: number[] }>();

  if (!body.recordIds || body.recordIds.length < 2) {
    return Response.json(
      { error: "At least two records required to propose a match" },
      { status: 400 },
    );
  }

  const placeholders = body.recordIds.map(() => "?").join(",");
  const { results: records } = await env.recon_demo_db
    .prepare(
      `SELECT id, side, amount, currency, status FROM ReconRecords WHERE id IN (${placeholders})`,
    )
    .bind(...body.recordIds)
    .all<{
      id: number;
      side: string;
      amount: number;
      currency: string;
      status: string;
    }>();

  if (records.length !== body.recordIds.length) {
    return Response.json(
      { error: "One or more records not found" },
      { status: 404 },
    );
  }

  if (records.some((r) => r.status !== "unmatched")) {
    return Response.json(
      { error: "One or more records are no longer unmatched" },
      { status: 409 },
    );
  }

  if (new Set(records.map((r) => r.currency)).size > 1) {
    return Response.json(
      { error: "All records in a match must share the same currency" },
      { status: 400 },
    );
  }

  const hasInternal = records.some((r) => r.side === "internal");
  const hasExternal = records.some((r) => r.side === "external");
  if (!hasInternal || !hasExternal) {
    return Response.json(
      {
        error: "A match requires at least one internal and one external record",
      },
      { status: 400 },
    );
  }

  const internalSum = records
    .filter((r) => r.side === "internal")
    .reduce((sum, r) => sum + r.amount, 0);
  const externalSum = records
    .filter((r) => r.side === "external")
    .reduce((sum, r) => sum + r.amount, 0);
  const variance = Math.round((internalSum - externalSum) * 100) / 100;

  const matchResult = await env.recon_demo_db
    .prepare(
      "INSERT INTO MatchResults (status, matched_by, match_type, amount_variance) VALUES ('pending', ?, 'manual', ?)",
    )
    .bind(session.userId, variance)
    .run();

  const matchId = matchResult.meta.last_row_id;

  for (const recordId of body.recordIds) {
    await env.recon_demo_db
      .prepare(
        "INSERT INTO MatchResultRecords (match_id, record_id) VALUES (?, ?)",
      )
      .bind(matchId, recordId)
      .run();

    await env.recon_demo_db
      .prepare("UPDATE ReconRecords SET status = 'proposed' WHERE id = ?")
      .bind(recordId)
      .run();
  }

  await env.recon_demo_db
    .prepare(
      "INSERT INTO AuditLog (user_id, action, target_table, target_id, details) VALUES (?, 'propose_match', 'MatchResults', ?, ?)",
    )
    .bind(
      session.userId,
      matchId,
      JSON.stringify({ recordIds: body.recordIds, variance }),
    )
    .run();

  return Response.json(
    { id: matchId, status: "pending", variance },
    { status: 201 },
  );
}
