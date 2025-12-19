-- =====================================================
-- RESET DATABASE - KEEP USER TABLES ONLY (FIXED)
-- =====================================================
-- This script will delete all data from non-user tables
-- and reset identity columns while preserving:
-- - admin
-- - doctor
-- - lab_user
-- - pharmacy_user
-- - registre
-- - xrayuser
-- - usertype
-- =====================================================

USE [jubba_clinick]
GO

PRINT '======================================='
PRINT 'Starting Database Reset...'
PRINT 'Preserving User Tables Only'
PRINT '======================================='
GO

-- Disable all constraints temporarily
PRINT 'Disabling constraints...'
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO

-- =====================================================
-- DELETE DATA FROM NON-USER TABLES
-- =====================================================

PRINT 'Deleting patient-related data...'
DELETE FROM [dbo].[patient_charges]
DELETE FROM [dbo].[prescribtion]
DELETE FROM [dbo].[patient]
GO

PRINT 'Deleting medical records...'
DELETE FROM [dbo].[lab_results]
DELETE FROM [dbo].[lab_test]
-- lab_orders doesn't exist in your database
DELETE FROM [dbo].[preslab]
DELETE FROM [dbo].[presxray]
-- xray_images doesn't exist in your database
GO

PRINT 'Deleting medicine and inventory data...'
DELETE FROM [dbo].[pharmacy_sales_items]
DELETE FROM [dbo].[pharmacy_sales]
DELETE FROM [dbo].[medicine_inventory]
DELETE FROM [dbo].[medicine]
DELETE FROM [dbo].[medicine_units]
GO

PRINT 'Deleting pharmacy data...'
DELETE FROM [dbo].[pharmacy_customer]
GO

PRINT 'Deleting hospital settings...'
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'hospital_settings')
    DELETE FROM [dbo].[hospital_settings]
GO

-- These tables don't exist, skipping
-- bed_charges, delivery_charges, lab_charges, xray_charges, job_title

-- =====================================================
-- RESET IDENTITY COLUMNS FOR NON-USER TABLES
-- =====================================================

PRINT 'Resetting identity columns...'

-- Patient related
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'patient')
    DBCC CHECKIDENT ('[dbo].[patient]', RESEED, 1000)

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'patient_charges')
    DBCC CHECKIDENT ('[dbo].[patient_charges]', RESEED, 0)

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'prescribtion')
    DBCC CHECKIDENT ('[dbo].[prescribtion]', RESEED, 3000)

-- Medical records
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'lab_results')
    DBCC CHECKIDENT ('[dbo].[lab_results]', RESEED, 0)

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'lab_test')
    DBCC CHECKIDENT ('[dbo].[lab_test]', RESEED, 0)

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'preslab')
    DBCC CHECKIDENT ('[dbo].[preslab]', RESEED, 0)

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'presxray')
    DBCC CHECKIDENT ('[dbo].[presxray]', RESEED, 0)

-- Medicine and inventory
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine')
    DBCC CHECKIDENT ('[dbo].[medicine]', RESEED, 0)

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine_units')
    DBCC CHECKIDENT ('[dbo].[medicine_units]', RESEED, 0)

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine_inventory')
    DBCC CHECKIDENT ('[dbo].[medicine_inventory]', RESEED, 0)

-- Pharmacy
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales')
    DBCC CHECKIDENT ('[dbo].[pharmacy_sales]', RESEED, 0)

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales_items')
    DBCC CHECKIDENT ('[dbo].[pharmacy_sales_items]', RESEED, 0)

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_customer')
    DBCC CHECKIDENT ('[dbo].[pharmacy_customer]', RESEED, 0)

-- Other
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'hospital_settings')
    DBCC CHECKIDENT ('[dbo].[hospital_settings]', RESEED, 0)
GO

-- =====================================================
-- RE-ENABLE CONSTRAINTS
-- =====================================================

PRINT 'Re-enabling constraints...'
EXEC sp_MSForEachTable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'
GO

-- =====================================================
-- VERIFY USER TABLES ARE INTACT
-- =====================================================

PRINT ''
PRINT '======================================='
PRINT 'VERIFICATION: User Tables Data Count'
PRINT '======================================='

SELECT 'admin' AS TableName, COUNT(*) AS RecordCount FROM [dbo].[admin]
UNION ALL
SELECT 'doctor', COUNT(*) FROM [dbo].[doctor]
UNION ALL
SELECT 'lab_user', COUNT(*) FROM [dbo].[lab_user]
UNION ALL
SELECT 'pharmacy_user', COUNT(*) FROM [dbo].[pharmacy_user]
UNION ALL
SELECT 'registre', COUNT(*) FROM [dbo].[registre]
UNION ALL
SELECT 'xrayuser', COUNT(*) FROM [dbo].[xrayuser]
UNION ALL
SELECT 'usertype', COUNT(*) FROM [dbo].[usertype]
GO

PRINT ''
PRINT '======================================='
PRINT 'VERIFICATION: Non-User Tables (Should be 0)'
PRINT '======================================='

SELECT 'patient' AS TableName, COUNT(*) AS RecordCount FROM [dbo].[patient]
UNION ALL
SELECT 'patient_charges', COUNT(*) FROM [dbo].[patient_charges]
UNION ALL
SELECT 'prescribtion', COUNT(*) FROM [dbo].[prescribtion]
UNION ALL
SELECT 'medicine', COUNT(*) FROM [dbo].[medicine]
UNION ALL
SELECT 'medicine_inventory', COUNT(*) FROM [dbo].[medicine_inventory]
UNION ALL
SELECT 'pharmacy_sales', COUNT(*) FROM [dbo].[pharmacy_sales]
UNION ALL
SELECT 'lab_results', COUNT(*) FROM [dbo].[lab_results]
UNION ALL
SELECT 'lab_test', COUNT(*) FROM [dbo].[lab_test]
GO

PRINT ''
PRINT '======================================='
PRINT 'Database Reset Complete!'
PRINT 'All user accounts preserved.'
PRINT 'All patient and transactional data deleted.'
PRINT '======================================='
GO
