import handleCreateUser from "./handleCreateUser";
import handleDeactivateUser from "./handleDeactivateUser";
import handleListUsers from "./handleListUsers";
import handleLogin from "./handleLogin";
import handleMe from "./handleMe";
import handleReactivateUser from "./handleReactivateUser";

// Run server: npx wrangler dev
export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);

    // SQL query to list tables - run server: npx wrangler dev, in separate terminal: Invoke-RestMethod -Uri "http://127.0.0.1:8787/debug/tables"
    if (url.pathname === "/debug/tables") {
      const { results } = await env.recon_demo_db
        .prepare("SELECT name FROM sqlite_master WHERE type='table'")
        .all();
      return Response.json(results);
    }

    // For PS - run server: npx wrangler dev, in separate terminal: Invoke-RestMethod -Uri "http://127.0.0.1:8787/login" -Method Post -ContentType "application/json" -Body '{"username":"admin","password":"<YOUR PWD>"}'
    // It it will print session's token
    if (url.pathname === "/login" && request.method === "POST") {
      return handleLogin(request, env);
    }

    // For PS - run server: npx wrangler dev, in separate terminal: Invoke-RestMethod -Uri "http://127.0.0.1:8787/me" -Headers @{ Authorization = "Bearer <PASTE SESSION's TOKEN HERE>" }
    if (url.pathname === "/me" && request.method === "GET")
      return handleMe(request, env);

    // For PS - run server: npx wrangler dev, in separate terminal: Invoke-RestMethod -Uri "http://127.0.0.1:8787/admin/users" -Headers @{ Authorization = "Bearer <PASTE SESSION's TOKEN HERE>" }
    if (url.pathname === "/admin/users" && request.method === "GET")
      return handleListUsers(request, env);

    // User cration (admin only)
    // For PS - run server: npx wrangler dev, in separate terminal:
    // Invoke-RestMethod -Uri "http://127.0.0.1:8787/admin/users" -Method Post -Headers @{ Authorization = "Bearer <PASTE SESSION's TOKEN HERE>" } -ContentType "application/json" -Body '{"username":"jsmith","password":"TestPass123!","role":"reconciler"}'
    if (url.pathname === "/admin/users" && request.method === "POST")
      return handleCreateUser(request, env);

    // User's deactivation endpoint
    // For PS - run server: npx wrangler dev, in separate terminal:
    // Invoke-RestMethod -Uri "http://127.0.0.1:8787/admin/users/2" -Method Delete -Headers @{ Authorization = "Bearer <PASTE SESSION's TOKEN HERE>" }
    const deactivateMatch = url.pathname.match(/^\/admin\/users\/(\d+)$/);
    if (deactivateMatch && request.method === "DELETE") {
      return handleDeactivateUser(
        request,
        env,
        parseInt(deactivateMatch[1], 10),
      );
    }

    // User's reactivation endpoint
    // For PS - run server: npx wrangler dev, in separate terminal:
    // Invoke-RestMethod -Uri "http://127.0.0.1:8787/admin/users/2/reactivate" -Method Patch -Headers @{ Authorization = "Bearer <PASTE SESSION's TOKEN HERE>" } -ContentType "application/json" -Body '{"password":"<PASTE NEW PWD HERE"}'
    const reactivateMatch = url.pathname.match(
      /^\/admin\/users\/(\d+)\/reactivate$/,
    );
    if (reactivateMatch && request.method === "PATCH") {
      return handleReactivateUser(
        request,
        env,
        parseInt(reactivateMatch[1], 10),
      );
    }

    return new Response("Not found", { status: 404 });
  },
};
