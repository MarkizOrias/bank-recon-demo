-- Migration number: 0005 	 2026-09-18T09:15:12.111Z
-- Enrichment of the recon matchin engine

DROP TABLE MatchResults;

CREATE TABLE MatchResults (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected')),
  matched_by INTEGER NOT NULL REFERENCES Users(id),
  matched_at TEXT NOT NULL DEFAULT (datetime('now')),
  approved_by INTEGER REFERENCES Users(id),
  approved_at TEXT,
  match_type TEXT NOT NULL DEFAULT 'manual' CHECK (match_type IN ('auto', 'manual')),
  amount_variance REAL NOT NULL DEFAULT 0
);

CREATE TABLE MatchResultRecords (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  match_id INTEGER NOT NULL REFERENCES MatchResults(id),
  record_id INTEGER NOT NULL REFERENCES ReconRecords(id)
);

CREATE INDEX idx_matchresultrecords_match ON MatchResultRecords(match_id);
CREATE INDEX idx_matchresultrecords_record ON MatchResultRecords(record_id);

CREATE TABLE ReconRecords_new (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  side TEXT NOT NULL CHECK (side IN ('internal', 'external')),
  reference TEXT NOT NULL,
  amount REAL NOT NULL,
  currency TEXT NOT NULL,
  value_date TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'unmatched' CHECK (status IN ('unmatched', 'proposed', 'matched', 'exception')),
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);

INSERT INTO ReconRecords_new SELECT * FROM ReconRecords;
DROP TABLE ReconRecords;
ALTER TABLE ReconRecords_new RENAME TO ReconRecords;

CREATE INDEX idx_reconrecords_status ON ReconRecords(status);