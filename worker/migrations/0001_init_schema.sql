-- Migration number: 0001    2026-09-16T15:40:21.000Z
-- The initial schema injection to DB
CREATE TABLE Users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('admin', 'reconciler')),
  active INTEGER NOT NULL DEFAULT 1,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE ReconRecords (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  side TEXT NOT NULL CHECK (side IN ('internal', 'external')),
  reference TEXT NOT NULL,
  amount REAL NOT NULL,
  currency TEXT NOT NULL,
  value_date TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'unmatched' CHECK (status IN ('unmatched', 'matched', 'exception')),
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE MatchResults (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  internal_record_id INTEGER NOT NULL REFERENCES ReconRecords(id),
  external_record_id INTEGER NOT NULL REFERENCES ReconRecords(id),
  matched_by INTEGER NOT NULL REFERENCES Users(id),
  matched_at TEXT NOT NULL DEFAULT (datetime('now')),
  match_type TEXT NOT NULL CHECK (match_type IN ('auto', 'manual'))
);

CREATE TABLE Exceptions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  record_id INTEGER NOT NULL REFERENCES ReconRecords(id),
  reason TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'investigating', 'resolved')),
  owner_id INTEGER REFERENCES Users(id),
  opened_at TEXT NOT NULL DEFAULT (datetime('now')),
  sla_due_date TEXT,
  resolved_at TEXT,
  resolution_note TEXT
);

CREATE TABLE AuditLog (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES Users(id),
  action TEXT NOT NULL,
  target_table TEXT NOT NULL,
  target_id INTEGER NOT NULL,
  details TEXT,
  timestamp TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX idx_reconrecords_status ON ReconRecords(status);
CREATE INDEX idx_exceptions_status ON Exceptions(status);
CREATE INDEX idx_auditlog_user ON AuditLog(user_id);