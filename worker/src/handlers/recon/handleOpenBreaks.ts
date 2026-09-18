import { requireReconciler } from "../../handlers/admin/auth";

export default async function handleOpenBreaks(
  request: Request,
  env: Env,
): Promise<Response> {
  const session = await requireReconciler(request, env);
  if (!session) return Response.json({ error: "Forbidden" }, { status: 403 });

  const { results } = await env.recon_demo_db
    .prepare(
      "SELECT id, side, reference, amount, currency, value_date, description FROM ReconRecords WHERE status = 'unmatched' ORDER BY side, value_date",
    )
    .all();

  return Response.json(results);
}
