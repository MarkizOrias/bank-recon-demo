export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const { results } = await env.recon_demo_db
      .prepare("SELECT name FROM sqlite_master WHERE type='table'")
      .all();

    return Response.json(results);
  },
};
