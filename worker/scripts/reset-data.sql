-- npx wrangler d1 execute recon-demo-db --local --file=scripts/reset-data.sql
-- npx wrangler d1 execute recon-demo-db --remote --file=scripts/reset-data.sql

DELETE FROM AuditLog;
DELETE FROM Sessions;
DELETE FROM MatchResults;
DELETE FROM Exceptions;
DELETE FROM ReconRecords;
DELETE FROM Users;
DELETE FROM sqlite_sequence WHERE name IN ('AuditLog', 'Sessions', 'MatchResults', 'Exceptions', 'ReconRecords', 'Users');