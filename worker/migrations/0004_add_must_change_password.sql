-- Migration number: 0004 	 2026-09-17T15:28:01.251Z
-- Adding password change functionality
ALTER TABLE Users ADD COLUMN must_change_password INTEGER NOT NULL DEFAULT 0;