DELETE FROM AuditLog;
DELETE FROM Sessions;
DELETE FROM MatchResults;
DELETE FROM Exceptions;
DELETE FROM ReconRecords;
DELETE FROM Users;
DELETE FROM sqlite_sequence WHERE name IN ('AuditLog', 'Sessions', 'MatchResults', 'Exceptions', 'ReconRecords', 'Users');