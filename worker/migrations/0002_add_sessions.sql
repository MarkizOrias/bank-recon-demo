-- Migration number: 0002 	 2026-09-16T19:16:01.877Z
-- Prod sessions table
CREATE TABLE Sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES Users(id),
  token TEXT NOT NULL UNIQUE,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  expires_at TEXT NOT NULL,
  revoked INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_sessions_token ON Sessions(token);