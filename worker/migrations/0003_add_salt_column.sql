-- Migration number: 0003 	 2026-09-16T19:39:15.016Z
-- Adding salt column to User's table

ALTER TABLE Users ADD COLUMN salt TEXT NOT NULL DEFAULT '';