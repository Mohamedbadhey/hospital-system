-- Test Data for Revenue Dashboard
-- This adds sample charges to test the revenue reporting system

USE [juba_clinick]
GO

-- First, check if patient_charges table exists
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[patient_charges]') AND type in (N'U'))
BEGIN
    PRINT 'ERROR: patient_charges table does not exist. Please run charges_management_database.sql first.'
    RETURN;
END
GO

PRINT 'Adding test charge data...'
GO

-- Clear existing test data (optional - comment out if you want to keep existing data)
-- DELETE FROM patient_charges WHERE invoice_number LIKE 'TEST-%';
-- GO

-- Insert sample registration charges
PRINT 'Adding registration charges...'
INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, paid_date, invoice_number, date_added, paid_by)
VALUES 
-- Today's registrations (PAID)
(1, 'Registration', 'Patient Registration Fee', 50.00, 1, GETDATE(), 'TEST-REG-001', GETDATE(), 1),
(2, 'Registration', 'Patient Registration Fee', 50.00, 1, GETDATE(), 'TEST-REG-002', GETDATE(), 1),
(3, 'Registration', 'Patient Registration Fee', 50.00, 1, GETDATE(), 'TEST-REG-003', GETDATE(), 1),

-- Today's registrations (UNPAID)
(4, 'Registration', 'Patient Registration Fee', 50.00, 0, NULL, 'TEST-REG-004', GETDATE(), NULL),
(5, 'Registration', 'Patient Registration Fee', 50.00, 0, NULL, 'TEST-REG-005', GETDATE(), NULL);

PRINT 'Registration charges added: 5 total (3 paid, 2 unpaid)'
GO

-- Insert sample lab test charges
PRINT 'Adding lab test charges...'
INSERT INTO patient_charges (patientid, prescid, charge_type, charge_name, amount, is_paid, paid_date, invoice_number, date_added, paid_by)
VALUES 
-- Today's lab tests (PAID)
(1, NULL, 'Lab', 'Complete Blood Count (CBC)', 75.00, 1, GETDATE(), 'TEST-LAB-001', GETDATE(), 1),
(2, NULL, 'Lab', 'Urine Analysis', 50.00, 1, GETDATE(), 'TEST-LAB-002', GETDATE(), 1),
(3, NULL, 'Lab', 'Blood Sugar Test', 60.00, 1, GETDATE(), 'TEST-LAB-003', GETDATE(), 1),
(4, NULL, 'Lab', 'Lipid Profile', 100.00, 1, GETDATE(), 'TEST-LAB-004', GETDATE(), 1),

-- Today's lab tests (UNPAID)
(5, NULL, 'Lab', 'Liver Function Test', 120.00, 0, NULL, 'TEST-LAB-005', GETDATE(), NULL),
(1, NULL, 'Lab', 'Kidney Function Test', 110.00, 0, NULL, 'TEST-LAB-006', GETDATE(), NULL);

PRINT 'Lab test charges added: 6 total (4 paid, 2 unpaid)'
GO

-- Insert sample X-ray charges
PRINT 'Adding X-ray charges...'
INSERT INTO patient_charges (patientid, prescid, charge_type, charge_name, amount, is_paid, paid_date, invoice_number, date_added, paid_by)
VALUES 
-- Today's X-rays (PAID)
(1, NULL, 'Xray', 'Chest X-Ray', 120.00, 1, GETDATE(), 'TEST-XRAY-001', GETDATE(), 1),
(2, NULL, 'Xray', 'Abdomen X-Ray', 150.00, 1, GETDATE(), 'TEST-XRAY-002', GETDATE(), 1),
(3, NULL, 'Xray', 'Leg X-Ray', 130.00, 1, GETDATE(), 'TEST-XRAY-003', GETDATE(), 1),

-- Today's X-rays (UNPAID)
(4, NULL, 'Xray', 'Skull X-Ray', 180.00, 0, NULL, 'TEST-XRAY-004', GETDATE(), NULL),
(5, NULL, 'Xray', 'Spine X-Ray', 200.00, 0, NULL, 'TEST-XRAY-005', GETDATE(), NULL);

PRINT 'X-ray charges added: 5 total (3 paid, 2 unpaid)'
GO

-- Add some charges from yesterday for comparison
PRINT 'Adding yesterday charges for comparison...'
INSERT INTO patient_charges (patientid, charge_type, charge_name, amount, is_paid, paid_date, invoice_number, date_added, paid_by)
VALUES 
(1, 'Registration', 'Patient Registration Fee', 50.00, 1, DATEADD(day, -1, GETDATE()), 'TEST-REG-Y001', DATEADD(day, -1, GETDATE()), 1),
(2, 'Lab', 'Blood Test', 80.00, 1, DATEADD(day, -1, GETDATE()), 'TEST-LAB-Y001', DATEADD(day, -1, GETDATE()), 1),
(3, 'Xray', 'Chest X-Ray', 120.00, 1, DATEADD(day, -1, GETDATE()), 'TEST-XRAY-Y001', DATEADD(day, -1, GETDATE()), 1);

PRINT 'Yesterday charges added: 3 total (all paid)'
GO

-- Verify the data
PRINT ''
PRINT '========================================='
PRINT 'TEST DATA SUMMARY'
PRINT '========================================='
PRINT ''

-- Today's charges summary
PRINT 'TODAY''S CHARGES:'
SELECT 
    charge_type as 'Charge Type',
    COUNT(*) as 'Total Count',
    SUM(amount) as 'Total Amount',
    SUM(CASE WHEN is_paid = 1 THEN 1 ELSE 0 END) as 'Paid Count',
    SUM(CASE WHEN is_paid = 1 THEN amount ELSE 0 END) as 'Paid Amount',
    SUM(CASE WHEN is_paid = 0 THEN 1 ELSE 0 END) as 'Unpaid Count',
    SUM(CASE WHEN is_paid = 0 THEN amount ELSE 0 END) as 'Unpaid Amount'
FROM patient_charges
WHERE CAST(date_added AS DATE) = CAST(GETDATE() AS DATE)
AND invoice_number LIKE 'TEST-%'
GROUP BY charge_type
ORDER BY charge_type;

PRINT ''
PRINT 'TODAY''S TOTAL REVENUE (PAID ONLY):'
SELECT 
    '$' + CAST(SUM(CASE WHEN is_paid = 1 THEN amount ELSE 0 END) AS VARCHAR(20)) as 'Total Revenue'
FROM patient_charges
WHERE CAST(date_added AS DATE) = CAST(GETDATE() AS DATE)
AND invoice_number LIKE 'TEST-%';

PRINT ''
PRINT 'YESTERDAY''S TOTAL REVENUE (PAID ONLY):'
SELECT 
    '$' + CAST(SUM(CASE WHEN is_paid = 1 THEN amount ELSE 0 END) AS VARCHAR(20)) as 'Total Revenue'
FROM patient_charges
WHERE CAST(date_added AS DATE) = CAST(DATEADD(day, -1, GETDATE()) AS DATE)
AND invoice_number LIKE 'TEST-%';

PRINT ''
PRINT '========================================='
PRINT 'EXPECTED DASHBOARD VALUES:'
PRINT '========================================='
PRINT 'Registration Revenue: $150.00 (3 paid x $50)'
PRINT 'Lab Tests Revenue: $285.00 (4 paid tests)'
PRINT 'X-Ray Revenue: $400.00 (3 paid x-rays)'
PRINT 'Pharmacy Revenue: $0.00 (no pharmacy data added)'
PRINT 'Total Revenue: $835.00'
PRINT '========================================='
PRINT ''
PRINT 'Test data inserted successfully!'
PRINT 'Now open your Admin Dashboard to see the revenue!'
GO
