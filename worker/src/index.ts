import handleChangePassword from "./handlers/admin/handleChangePassword";
import handleCreateUser from "./handlers/admin/handleCreateUser";
import handleDeactivateUser from "./handlers/admin/handleDeactivateUser";
import handleListUsers from "./handlers/admin/handleListUsers";
import handleLogin from "./handlers/admin/handleLogin";
import handleMe from "./handlers/admin/handleMe";
import handleReactivateUser from "./handlers/admin/handleReactivateUser";
import handleOpenBreaks from "./handlers/recon/handleOpenBreaks";
import handleProposeMatch from "./handlers/recon/handleProposeMatch";
import handleMatchingQueue from "./handlers/recon/handleMatchingQueue";
import handleApproveMatch from "./handlers/recon/handleApproveMatch";
import handleRejectMatch from "./handlers/recon/handleRejectMatch";

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

    // User's change password endpoint
    // For PS - run server: npx wrangler dev, in separate terminal:
    // Invoke-RestMethod -Uri "http://127.0.0.1:8787/users/me/password" -Method Patch -Headers @{ Authorization = "Bearer <PASTE SESSION's TOKEN HERE>" } -ContentType "application/json" -Body '{"currentPassword":"<CURRENT PWD>","newPassword":"<NEW PWD>"}'
    if (url.pathname === "/users/me/password" && request.method === "PATCH") {
      return handleChangePassword(request, env);
    }

    // Reconciler's open breaks endpoint
    // For PS - run server: npx wrangler dev, in separate terminal:
    // Invoke-RestMethod -Uri "http://127.0.0.1:8787/recon/open-breaks" -Headers @{ Authorization = "Bearer <PASTE SESSION's TOKEN HERE>" }
    if (url.pathname === "/recon/open-breaks" && request.method === "GET")
      return handleOpenBreaks(request, env);

    // Reconciler's propose match endpoint
    // For PS - run server: npx wrangler dev, in separate terminal:
    // Invoke-RestMethod -Uri "http://127.0.0.1:8787/recon/propose-match" -Method Post -Headers @{ Authorization = "Bearer <PASTE SESSION's TOKEN HERE>" } -ContentType "application/json" -Body '{"recordIds":[1,2]}'
    if (url.pathname === "/recon/propose-match" && request.method === "POST")
      return handleProposeMatch(request, env);

    // Reconciler's matching queue endpoint (excludes own proposals)
    // For PS - run server: npx wrangler dev, in separate terminal:
    // Invoke-RestMethod -Uri "http://127.0.0.1:8787/recon/matching-queue" -Headers @{ Authorization = "Bearer <PASTE SESSION's TOKEN HERE>" }
    if (url.pathname === "/recon/matching-queue" && request.method === "GET")
      return handleMatchingQueue(request, env);

    // Reconciler's approve match endpoint (checker only, cannot approve own proposal)
    // For PS - run server: npx wrangler dev, in separate terminal:
    // Invoke-RestMethod -Uri "http://127.0.0.1:8787/recon/approve-match/1" -Method Post -Headers @{ Authorization = "Bearer <PASTE SESSION's TOKEN HERE>" }
    const approveMatch = url.pathname.match(/^\/recon\/approve-match\/(\d+)$/);
    if (approveMatch && request.method === "POST")
      return handleApproveMatch(request, env, parseInt(approveMatch[1], 10));

    // Reconciler's reject match endpoint (checker only, cannot reject own proposal)
    // For PS - run server: npx wrangler dev, in separate terminal:
    // Invoke-RestMethod -Uri "http://127.0.0.1:8787/recon/reject-match/1" -Method Post -Headers @{ Authorization = "Bearer <PASTE SESSION's TOKEN HERE>" }
    const rejectMatch = url.pathname.match(/^\/recon\/reject-match\/(\d+)$/);
    if (rejectMatch && request.method === "POST")
      return handleRejectMatch(request, env, parseInt(rejectMatch[1], 10));

    return new Response("Not found", { status: 404 });
  },
};
