-- npx wrangler d1 execute recon-demo-db --local --file=scripts/feed-recon-breaks.sql
-- npx wrangler d1 execute recon-demo-db --remote --file=scripts/feed-recon-breaks.sql

INSERT INTO ReconRecords (side, reference, amount, currency, value_date, description, status) VALUES
('internal', 'INT-1006', 7800.00, 'CHF', '2026-09-17', 'Custody fee settlement - client B', 'unmatched'),
('external', 'EXT-2005', 7800.00, 'CHF', '2026-09-17', 'Bank confirm - custody fee client B', 'unmatched'),

('internal', 'INT-1007', 2500.00, 'EUR', '2026-09-17', 'Dividend payment - equity holding', 'unmatched'),
('external', 'EXT-2006', 2500.00, 'EUR', '2026-09-17', 'Bank confirm - dividend receipt', 'unmatched'),

('internal', 'INT-1008', 1000.00, 'USD', '2026-09-18', 'Trade settlement - tranche 1', 'unmatched'),
('internal', 'INT-1009', 1500.00, 'USD', '2026-09-18', 'Trade settlement - tranche 2', 'unmatched'),
('internal', 'INT-1010', 750.00, 'USD', '2026-09-18', 'Trade settlement - tranche 3', 'unmatched'),
('external', 'EXT-2007', 3250.00, 'USD', '2026-09-18', 'Bank confirm - combined trade settlement', 'unmatched'),

('internal', 'INT-1011', 4200.10, 'GBP', '2026-09-18', 'Coupon payment - bond holding', 'unmatched'),
('external', 'EXT-2008', 4200.00, 'GBP', '2026-09-18', 'Bank confirm - coupon receipt', 'unmatched'),

('internal', 'INT-1012', 150000.00, 'JPY', '2026-09-16', 'FX forward settlement', 'unmatched'),
('external', 'EXT-2009', 149850.00, 'JPY', '2026-09-16', 'Bank confirm - FX forward', 'unmatched'),

('internal', 'INT-1013', 620.00, 'CHF', '2026-09-15', 'Unreconciled internal accrual', 'unmatched'),

('external', 'EXT-2010', 390.00, 'EUR', '2026-09-16', 'Unidentified bank credit', 'unmatched'),

('internal', 'INT-1014', 9999.99, 'USD', '2026-09-17', 'Loan interest settlement', 'unmatched'),
('external', 'EXT-2011', 9999.99, 'USD', '2026-09-17', 'Bank confirm - loan interest', 'unmatched'),

('internal', 'INT-1015', 300.00, 'EUR', '2026-09-18', 'Fee allocation - part A', 'unmatched'),
('internal', 'INT-1016', 300.00, 'EUR', '2026-09-18', 'Fee allocation - part B', 'unmatched'),
('internal', 'INT-1017', 400.00, 'EUR', '2026-09-18', 'Fee allocation - part C', 'unmatched'),
('external', 'EXT-2012', 1000.00, 'EUR', '2026-09-18', 'Bank confirm - combined fee allocation', 'unmatched'),

('internal', 'INT-1001', 5000.00, 'CHF', '2026-09-15', 'FX settlement - counterparty A', 'unmatched'),
('external', 'EXT-2001', 5000.00, 'CHF', '2026-09-15', 'Bank confirm - counterparty A', 'unmatched'),

('internal', 'INT-1002', 1200.00, 'EUR', '2026-09-16', 'Securities trade - partial 1', 'unmatched'),
('internal', 'INT-1003', 800.00, 'EUR', '2026-09-16', 'Securities trade - partial 2', 'unmatched'),
('external', 'EXT-2002', 2000.00, 'EUR', '2026-09-16', 'Bank confirm - combined settlement', 'unmatched'),

('internal', 'INT-1004', 3450.75, 'USD', '2026-09-16', 'Wire transfer - vendor payment', 'unmatched'),
('external', 'EXT-2003', 3450.49, 'USD', '2026-09-16', 'Bank confirm - vendor payment', 'unmatched'),

('internal', 'INT-1005', 750.00, 'GBP', '2026-09-17', 'Unreconciled internal entry', 'unmatched'),
('external', 'EXT-2004', 920.00, 'GBP', '2026-09-17', 'Unrelated bank entry', 'unmatched'),

('internal', 'INT-1001', 5000.00, 'CHF', '2026-09-15', 'FX settlement - counterparty A', 'unmatched'),
('external', 'EXT-2001', 5000.00, 'CHF', '2026-09-15', 'Bank confirm - counterparty A', 'unmatched'),

('internal', 'INT-1002', 1200.00, 'EUR', '2026-09-16', 'Securities trade - partial 1', 'unmatched'),
('internal', 'INT-1003', 800.00, 'EUR', '2026-09-16', 'Securities trade - partial 2', 'unmatched'),
('external', 'EXT-2002', 2000.00, 'EUR', '2026-09-16', 'Bank confirm - combined settlement', 'unmatched'),

('internal', 'INT-1004', 3450.75, 'USD', '2026-09-16', 'Wire transfer - vendor payment', 'unmatched'),
('external', 'EXT-2003', 3450.49, 'USD', '2026-09-16', 'Bank confirm - vendor payment', 'unmatched'),

('internal', 'INT-1005', 750.00, 'GBP', '2026-09-17', 'Unreconciled internal entry', 'unmatched'),
('external', 'EXT-2004', 920.00, 'GBP', '2026-09-17', 'Unrelated bank entry', 'unmatched'),

('internal', 'INT-1006', 7800.00, 'CHF', '2026-09-17', 'Custody fee settlement - client B', 'unmatched'),
('external', 'EXT-2005', 7800.00, 'CHF', '2026-09-17', 'Bank confirm - custody fee client B', 'unmatched'),

('internal', 'INT-1007', 2500.00, 'EUR', '2026-09-17', 'Dividend payment - equity holding', 'unmatched'),
('external', 'EXT-2006', 2500.00, 'EUR', '2026-09-17', 'Bank confirm - dividend receipt', 'unmatched'),

('internal', 'INT-1008', 1000.00, 'USD', '2026-09-18', 'Trade settlement - tranche 1', 'unmatched'),
('internal', 'INT-1009', 1500.00, 'USD', '2026-09-18', 'Trade settlement - tranche 2', 'unmatched'),
('internal', 'INT-1010', 750.00, 'USD', '2026-09-18', 'Trade settlement - tranche 3', 'unmatched'),
('external', 'EXT-2007', 3250.00, 'USD', '2026-09-18', 'Bank confirm - combined trade settlement', 'unmatched'),

('internal', 'INT-1011', 4200.10, 'GBP', '2026-09-18', 'Coupon payment - bond holding', 'unmatched'),
('external', 'EXT-2008', 4200.00, 'GBP', '2026-09-18', 'Bank confirm - coupon receipt', 'unmatched'),

('internal', 'INT-1012', 150000.00, 'JPY', '2026-09-16', 'FX forward settlement', 'unmatched'),
('external', 'EXT-2009', 149850.00, 'JPY', '2026-09-16', 'Bank confirm - FX forward', 'unmatched'),

('internal', 'INT-1013', 620.00, 'CHF', '2026-09-15', 'Unreconciled internal accrual', 'unmatched'),
('external', 'EXT-2010', 390.00, 'EUR', '2026-09-16', 'Unidentified bank credit', 'unmatched'),

('internal', 'INT-1014', 9999.99, 'USD', '2026-09-17', 'Loan interest settlement', 'unmatched'),
('external', 'EXT-2011', 9999.99, 'USD', '2026-09-17', 'Bank confirm - loan interest', 'unmatched'),

('internal', 'INT-1015', 300.00, 'EUR', '2026-09-18', 'Fee allocation - part A', 'unmatched'),
('internal', 'INT-1016', 300.00, 'EUR', '2026-09-18', 'Fee allocation - part B', 'unmatched'),
('internal', 'INT-1017', 400.00, 'EUR', '2026-09-18', 'Fee allocation - part C', 'unmatched'),
('external', 'EXT-2012', 1000.00, 'EUR', '2026-09-18', 'Bank confirm - combined fee allocation', 'unmatched'),

('internal', 'INT-1018', 12500.00, 'CHF', '2026-09-15', 'Repo settlement - counterparty C', 'unmatched'),
('external', 'EXT-2013', 12500.00, 'CHF', '2026-09-15', 'Bank confirm - repo settlement C', 'unmatched'),

('internal', 'INT-1019', 4750.00, 'EUR', '2026-09-15', 'Bond purchase settlement', 'unmatched'),
('external', 'EXT-2014', 4750.00, 'EUR', '2026-09-16', 'Bank confirm - bond purchase', 'unmatched'),

('internal', 'INT-1020', 6325.55, 'USD', '2026-09-15', 'Broker commission settlement', 'unmatched'),
('external', 'EXT-2015', 6325.50, 'USD', '2026-09-15', 'Bank confirm - broker commission', 'unmatched'),

('internal', 'INT-1021', 2200.00, 'GBP', '2026-09-15', 'Corporate action cash payment', 'unmatched'),
('external', 'EXT-2016', 2200.00, 'GBP', '2026-09-15', 'Bank confirm - corporate action', 'unmatched'),

('internal', 'INT-1022', 4000.00, 'CHF', '2026-09-16', 'Client withdrawal instruction', 'unmatched'),
('external', 'EXT-2017', 4000.00, 'CHF', '2026-09-17', 'Bank debit - client withdrawal', 'unmatched'),

('internal', 'INT-1023', 1750.00, 'EUR', '2026-09-16', 'Management fee accrual', 'unmatched'),
('external', 'EXT-2018', 1749.85, 'EUR', '2026-09-16', 'Bank debit - management fee', 'unmatched'),

('internal', 'INT-1024', 8750.00, 'USD', '2026-09-16', 'Treasury transfer - account A', 'unmatched'),
('external', 'EXT-2019', 8750.00, 'USD', '2026-09-16', 'Bank confirm - treasury transfer A', 'unmatched'),

('internal', 'INT-1025', 900.00, 'CHF', '2026-09-16', 'Custody charge - portfolio 01', 'unmatched'),
('internal', 'INT-1026', 600.00, 'CHF', '2026-09-16', 'Custody charge - portfolio 02', 'unmatched'),
('external', 'EXT-2020', 1500.00, 'CHF', '2026-09-16', 'Bank debit - combined custody charges', 'unmatched'),

('internal', 'INT-1027', 13500.00, 'EUR', '2026-09-17', 'FX spot settlement EUR leg', 'unmatched'),
('external', 'EXT-2021', 13500.00, 'EUR', '2026-09-17', 'Bank confirm - FX spot EUR leg', 'unmatched'),

('internal', 'INT-1028', 22500.00, 'USD', '2026-09-17', 'Commercial paper maturity', 'unmatched'),
('external', 'EXT-2022', 22500.00, 'USD', '2026-09-17', 'Bank confirm - commercial paper maturity', 'unmatched'),

('internal', 'INT-1029', 3100.25, 'GBP', '2026-09-17', 'Bond coupon distribution', 'unmatched'),
('external', 'EXT-2023', 3100.00, 'GBP', '2026-09-17', 'Bank credit - bond coupon', 'unmatched'),

('internal', 'INT-1030', 5500.00, 'CHF', '2026-09-17', 'Cash sweep to treasury', 'unmatched'),
('external', 'EXT-2024', 5500.00, 'CHF', '2026-09-18', 'Bank confirm - cash sweep', 'unmatched'),

('internal', 'INT-1031', 1250.00, 'EUR', '2026-09-17', 'Securities fee - component 1', 'unmatched'),
('internal', 'INT-1032', 750.00, 'EUR', '2026-09-17', 'Securities fee - component 2', 'unmatched'),
('internal', 'INT-1033', 500.00, 'EUR', '2026-09-17', 'Securities fee - component 3', 'unmatched'),
('external', 'EXT-2025', 2500.00, 'EUR', '2026-09-17', 'Bank debit - aggregated securities fees', 'unmatched'),

('internal', 'INT-1034', 18000.00, 'USD', '2026-09-18', 'Equity trade settlement - Apple', 'unmatched'),
('external', 'EXT-2026', 18000.00, 'USD', '2026-09-18', 'Bank confirm - equity settlement Apple', 'unmatched'),

('internal', 'INT-1035', 7200.00, 'CHF', '2026-09-18', 'Structured product redemption', 'unmatched'),
('external', 'EXT-2027', 7200.00, 'CHF', '2026-09-18', 'Bank credit - structured product redemption', 'unmatched'),

('internal', 'INT-1036', 2850.75, 'EUR', '2026-09-18', 'Fund subscription settlement', 'unmatched'),
('external', 'EXT-2028', 2850.75, 'EUR', '2026-09-18', 'Bank debit - fund subscription', 'unmatched'),

('internal', 'INT-1037', 1150.00, 'GBP', '2026-09-18', 'Tax withholding adjustment', 'unmatched'),
('external', 'EXT-2029', 1149.90, 'GBP', '2026-09-18', 'Bank debit - withholding adjustment', 'unmatched'),

('internal', 'INT-1038', 42000.00, 'USD', '2026-09-15', 'Money market placement', 'unmatched'),
('external', 'EXT-2030', 42000.00, 'USD', '2026-09-15', 'Bank confirm - money market placement', 'unmatched'),

('internal', 'INT-1039', 1600.00, 'CHF', '2026-09-15', 'Advisory fee - client C', 'unmatched'),
('external', 'EXT-2031', 1600.00, 'CHF', '2026-09-15', 'Bank debit - advisory fee client C', 'unmatched'),

('internal', 'INT-1040', 3250.00, 'EUR', '2026-09-15', 'Derivative premium payment', 'unmatched'),
('external', 'EXT-2032', 3250.00, 'EUR', '2026-09-15', 'Bank confirm - derivative premium', 'unmatched'),

('internal', 'INT-1041', 2750.00, 'USD', '2026-09-16', 'Settlement allocation A', 'unmatched'),
('internal', 'INT-1042', 2250.00, 'USD', '2026-09-16', 'Settlement allocation B', 'unmatched'),
('external', 'EXT-2033', 5000.00, 'USD', '2026-09-16', 'Bank confirm - combined allocations A+B', 'unmatched'),

('internal', 'INT-1043', 850.00, 'GBP', '2026-09-16', 'Exchange fee settlement', 'unmatched'),
('external', 'EXT-2034', 850.00, 'GBP', '2026-09-16', 'Bank debit - exchange fee', 'unmatched'),

('internal', 'INT-1044', 6700.00, 'CHF', '2026-09-16', 'Client cash transfer - portfolio D', 'unmatched'),
('external', 'EXT-2035', 6700.00, 'CHF', '2026-09-16', 'Bank confirm - client transfer portfolio D', 'unmatched'),

('internal', 'INT-1045', 50000.00, 'EUR', '2026-09-17', 'Term deposit maturity', 'unmatched'),
('external', 'EXT-2036', 50000.00, 'EUR', '2026-09-17', 'Bank credit - term deposit maturity', 'unmatched'),

('internal', 'INT-1046', 3750.00, 'USD', '2026-09-17', 'Option premium settlement', 'unmatched'),
('external', 'EXT-2037', 3749.75, 'USD', '2026-09-17', 'Bank debit - option premium', 'unmatched'),

('internal', 'INT-1047', 2100.00, 'CHF', '2026-09-17', 'Fund administration fee', 'unmatched'),
('external', 'EXT-2038', 2100.00, 'CHF', '2026-09-17', 'Bank debit - fund administration fee', 'unmatched'),

('internal', 'INT-1048', 800.00, 'EUR', '2026-09-18', 'Broker fee allocation A', 'unmatched'),
('internal', 'INT-1049', 1200.00, 'EUR', '2026-09-18', 'Broker fee allocation B', 'unmatched'),
('external', 'EXT-2039', 2000.00, 'EUR', '2026-09-18', 'Bank debit - aggregated broker fees', 'unmatched'),

('internal', 'INT-1050', 15500.00, 'GBP', '2026-09-18', 'Gilt settlement', 'unmatched'),
('external', 'EXT-2040', 15500.00, 'GBP', '2026-09-18', 'Bank confirm - gilt settlement', 'unmatched'),

('internal', 'INT-1051', 4350.00, 'USD', '2026-09-18', 'ETF purchase settlement', 'unmatched'),
('external', 'EXT-2041', 4350.00, 'USD', '2026-09-18', 'Bank debit - ETF purchase', 'unmatched'),

('internal', 'INT-1052', 990.00, 'CHF', '2026-09-15', 'Safekeeping fee', 'unmatched'),
('external', 'EXT-2042', 989.95, 'CHF', '2026-09-15', 'Bank debit - safekeeping fee', 'unmatched'),

('internal', 'INT-1053', 25000.00, 'EUR', '2026-09-15', 'Bond redemption proceeds', 'unmatched'),
('external', 'EXT-2043', 25000.00, 'EUR', '2026-09-15', 'Bank credit - bond redemption', 'unmatched'),

('internal', 'INT-1054', 5100.00, 'USD', '2026-09-16', 'Client payment - invoice 8841', 'unmatched'),
('external', 'EXT-2044', 5100.00, 'USD', '2026-09-16', 'Bank credit - invoice 8841', 'unmatched'),

('internal', 'INT-1055', 1400.00, 'GBP', '2026-09-16', 'Clearing fee - futures', 'unmatched'),
('external', 'EXT-2045', 1400.00, 'GBP', '2026-09-16', 'Bank debit - futures clearing fee', 'unmatched'),

('internal', 'INT-1056', 3600.00, 'CHF', '2026-09-17', 'Portfolio transfer fee', 'unmatched'),
('external', 'EXT-2046', 3600.00, 'CHF', '2026-09-17', 'Bank debit - portfolio transfer fee', 'unmatched'),

('internal', 'INT-1057', 1850.00, 'EUR', '2026-09-17', 'Trade correction settlement', 'unmatched'),
('external', 'EXT-2047', 1850.00, 'EUR', '2026-09-18', 'Bank confirm - trade correction', 'unmatched'),

('internal', 'INT-1058', 10000.00, 'USD', '2026-09-17', 'Treasury funding transfer', 'unmatched'),
('external', 'EXT-2048', 10000.00, 'USD', '2026-09-17', 'Bank confirm - treasury funding', 'unmatched'),

('internal', 'INT-1059', 650.00, 'CHF', '2026-09-18', 'Transaction charge A', 'unmatched'),
('internal', 'INT-1060', 350.00, 'CHF', '2026-09-18', 'Transaction charge B', 'unmatched'),
('external', 'EXT-2049', 1000.00, 'CHF', '2026-09-18', 'Bank debit - combined transaction charges', 'unmatched'),

('internal', 'INT-1061', 7600.00, 'EUR', '2026-09-18', 'Corporate bond purchase', 'unmatched'),
('external', 'EXT-2050', 7600.00, 'EUR', '2026-09-18', 'Bank confirm - corporate bond purchase', 'unmatched'),

('internal', 'INT-1062', 27500.00, 'USD', '2026-09-15', 'Equity block trade settlement', 'unmatched'),
('external', 'EXT-2051', 27500.00, 'USD', '2026-09-15', 'Bank confirm - equity block trade', 'unmatched'),

('internal', 'INT-1063', 4800.00, 'GBP', '2026-09-15', 'Dividend distribution - UK equity', 'unmatched'),
('external', 'EXT-2052', 4800.00, 'GBP', '2026-09-15', 'Bank credit - UK dividend', 'unmatched'),

('internal', 'INT-1064', 720.00, 'EUR', '2026-09-16', 'Unmatched administration charge', 'unmatched'),

('external', 'EXT-2053', 1337.50, 'USD', '2026-09-16', 'Unknown incoming payment', 'unmatched'),

('internal', 'INT-1065', 9100.00, 'CHF', '2026-09-16', 'Private banking transfer', 'unmatched'),
('external', 'EXT-2054', 9100.00, 'CHF', '2026-09-16', 'Bank confirm - private banking transfer', 'unmatched'),

('internal', 'INT-1066', 2300.00, 'EUR', '2026-09-17', 'Fund redemption - partial A', 'unmatched'),
('internal', 'INT-1067', 2700.00, 'EUR', '2026-09-17', 'Fund redemption - partial B', 'unmatched'),
('external', 'EXT-2055', 5000.00, 'EUR', '2026-09-17', 'Bank credit - combined fund redemption', 'unmatched'),

('internal', 'INT-1068', 6000.00, 'USD', '2026-09-17', 'Swap cashflow settlement', 'unmatched'),
('external', 'EXT-2056', 5999.80, 'USD', '2026-09-17', 'Bank confirm - swap cashflow', 'unmatched'),

('internal', 'INT-1069', 3250.00, 'GBP', '2026-09-18', 'Pension fund contribution', 'unmatched'),
('external', 'EXT-2057', 3250.00, 'GBP', '2026-09-18', 'Bank debit - pension contribution', 'unmatched'),

('internal', 'INT-1070', 1800.00, 'CHF', '2026-09-18', 'Service fee allocation 01', 'unmatched'),
('internal', 'INT-1071', 1200.00, 'CHF', '2026-09-18', 'Service fee allocation 02', 'unmatched'),
('internal', 'INT-1072', 2000.00, 'CHF', '2026-09-18', 'Service fee allocation 03', 'unmatched'),
('external', 'EXT-2058', 5000.00, 'CHF', '2026-09-18', 'Bank debit - combined service fees', 'unmatched'),

('internal', 'INT-1073', 44000.00, 'EUR', '2026-09-15', 'Institutional client subscription', 'unmatched'),
('external', 'EXT-2059', 44000.00, 'EUR', '2026-09-15', 'Bank credit - institutional subscription', 'unmatched'),

('internal', 'INT-1074', 8450.00, 'USD', '2026-09-16', 'Cross-border payment', 'unmatched'),
('external', 'EXT-2060', 8450.00, 'USD', '2026-09-17', 'Bank confirm - cross-border payment', 'unmatched'),

('internal', 'INT-1075', 725.00, 'GBP', '2026-09-16', 'Settlement agent fee', 'unmatched'),
('external', 'EXT-2061', 725.00, 'GBP', '2026-09-16', 'Bank debit - settlement agent fee', 'unmatched'),

('internal', 'INT-1076', 36000.00, 'CHF', '2026-09-17', 'Fixed income maturity proceeds', 'unmatched'),
('external', 'EXT-2062', 36000.00, 'CHF', '2026-09-17', 'Bank credit - fixed income maturity', 'unmatched'),

('internal', 'INT-1077', 950.00, 'EUR', '2026-09-17', 'Tax reclaim processing fee', 'unmatched'),
('external', 'EXT-2063', 949.75, 'EUR', '2026-09-17', 'Bank debit - tax reclaim fee', 'unmatched'),

('internal', 'INT-1078', 11250.00, 'USD', '2026-09-18', 'Hedge settlement - strategy A', 'unmatched'),
('external', 'EXT-2064', 11250.00, 'USD', '2026-09-18', 'Bank confirm - hedge strategy A', 'unmatched'),

('internal', 'INT-1079', 2000.00, 'CHF', '2026-09-18', 'Cash allocation - desk A', 'unmatched'),
('internal', 'INT-1080', 3000.00, 'CHF', '2026-09-18', 'Cash allocation - desk B', 'unmatched'),
('external', 'EXT-2065', 5000.00, 'CHF', '2026-09-18', 'Bank confirm - aggregated desk allocation', 'unmatched'),

('internal', 'INT-1081', 1500.00, 'EUR', '2026-09-15', 'Same amount test - transaction Alpha', 'unmatched'),
('internal', 'INT-1082', 1500.00, 'EUR', '2026-09-15', 'Same amount test - transaction Beta', 'unmatched'),
('external', 'EXT-2066', 1500.00, 'EUR', '2026-09-15', 'Bank confirm - transaction Beta', 'unmatched'),
('external', 'EXT-2067', 1500.00, 'EUR', '2026-09-15', 'Bank confirm - transaction Alpha', 'unmatched'),

('internal', 'INT-1083', 7500.00, 'USD', '2026-09-15', 'Delayed settlement test', 'unmatched'),
('external', 'EXT-2068', 7500.00, 'USD', '2026-09-18', 'Bank confirm - delayed settlement', 'unmatched'),

('internal', 'INT-1084', 10000.00, 'GBP', '2026-09-16', 'Large tolerance test', 'unmatched'),
('external', 'EXT-2069', 9998.50, 'GBP', '2026-09-16', 'Bank confirm - amount discrepancy', 'unmatched'),

('internal', 'INT-1085', 1000.00, 'EUR', '2026-09-17', 'Complex allocation - leg A', 'unmatched'),
('internal', 'INT-1086', 2000.00, 'EUR', '2026-09-17', 'Complex allocation - leg B', 'unmatched'),
('internal', 'INT-1087', 3000.00, 'EUR', '2026-09-17', 'Complex allocation - leg C', 'unmatched'),
('internal', 'INT-1088', 4000.00, 'EUR', '2026-09-17', 'Complex allocation - leg D', 'unmatched'),
('external', 'EXT-2070', 10000.00, 'EUR', '2026-09-17', 'Bank confirm - aggregated complex allocation', 'unmatched'),

('internal', 'INT-1089', 5555.55, 'CHF', '2026-09-18', 'Precision amount test', 'unmatched'),
('external', 'EXT-2071', 5555.54, 'CHF', '2026-09-18', 'Bank confirm - precision amount test', 'unmatched'),

('internal', 'INT-1090', 8800.00, 'USD', '2026-09-18', 'Unmatched internal payment - investigation required', 'unmatched'),

('external', 'EXT-2072', 1275.00, 'CHF', '2026-09-18', 'Unidentified external cash movement', 'unmatched'),

('internal', 'INT-1091', 6400.00, 'GBP', '2026-09-18', 'Final securities settlement', 'unmatched'),
('external', 'EXT-2073', 6400.00, 'GBP', '2026-09-18', 'Bank confirm - final securities settlement', 'unmatched');