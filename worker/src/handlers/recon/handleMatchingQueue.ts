import { requireReconciler } from "../../handlers/admin/auth";

export default async function handleMatchingQueue(
  request: Request,
  env: Env,
): Promise<Response> {
  const session = await requireReconciler(request, env);
  if (!session) return Response.json({ error: "Forbidden" }, { status: 403 });

  const { results: matches } = await env.recon_demo_db
    .prepare(
      `SELECT MatchResults.id, MatchResults.matched_at, MatchResults.amount_variance, Users.username as proposed_by
       FROM MatchResults
       JOIN Users ON Users.id = MatchResults.matched_by
       WHERE MatchResults.status = 'pending' AND MatchResults.matched_by != ?
       ORDER BY MatchResults.matched_at`,
    )
    .bind(session.userId)
    .all<{
      id: number;
      matched_at: string;
      amount_variance: number;
      proposed_by: string;
    }>();

  const queue = [];

  for (const match of matches) {
    const { results: matchRecords } = await env.recon_demo_db
      .prepare(
        `SELECT ReconRecords.id, ReconRecords.side, ReconRecords.reference, ReconRecords.amount, ReconRecords.currency, ReconRecords.value_date, ReconRecords.description
         FROM MatchResultRecords
         JOIN ReconRecords ON ReconRecords.id = MatchResultRecords.record_id
         WHERE MatchResultRecords.match_id = ?`,
      )
      .bind(match.id)
      .all();

    queue.push({
      matchId: match.id,
      proposedBy: match.proposed_by,
      matchedAt: match.matched_at,
      amountVariance: match.amount_variance,
      records: matchRecords,
    });
  }

  return Response.json(queue);
}
