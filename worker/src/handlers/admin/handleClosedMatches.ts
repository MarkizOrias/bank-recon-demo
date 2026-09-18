import { requireAdmin } from "./auth";

export default async function handleClosedMatches(
  request: Request,
  env: Env,
): Promise<Response> {
  const admin = await requireAdmin(request, env);
  if (!admin) return Response.json({ error: "Forbidden" }, { status: 403 });

  const { results: matches } = await env.recon_demo_db
    .prepare(
      `SELECT MatchResults.id, MatchResults.matched_at, MatchResults.amount_variance,
              Proposer.username as proposed_by, Approver.username as approved_by, MatchResults.approved_at
       FROM MatchResults
       JOIN Users Proposer ON Proposer.id = MatchResults.matched_by
       JOIN Users Approver ON Approver.id = MatchResults.approved_by
       WHERE MatchResults.status = 'approved'
       ORDER BY MatchResults.approved_at DESC`,
    )
    .all<{
      id: number;
      matched_at: string;
      amount_variance: number;
      proposed_by: string;
      approved_by: string;
      approved_at: string;
    }>();

  const closed = [];
  for (const match of matches) {
    const { results: matchRecords } = await env.recon_demo_db
      .prepare(
        `SELECT ReconRecords.id, ReconRecords.side, ReconRecords.reference, ReconRecords.amount, ReconRecords.currency
         FROM MatchResultRecords JOIN ReconRecords ON ReconRecords.id = MatchResultRecords.record_id
         WHERE MatchResultRecords.match_id = ?`,
      )
      .bind(match.id)
      .all();

    closed.push({
      matchId: match.id,
      proposedBy: match.proposed_by,
      approvedBy: match.approved_by,
      approvedAt: match.approved_at,
      amountVariance: match.amount_variance,
      records: matchRecords,
    });
  }

  return Response.json(closed);
}
