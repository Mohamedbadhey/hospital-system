-- ============================================
-- CLEAR ALL TABLE DATA SCRIPT
-- Created: December 19, 2025
-- Purpose: Delete all data from tables while preserving structure
-- WARNING: This will DELETE ALL DATA from your database!
-- ============================================

USE [db_ac228a_vafmadow]
GO

PRINT '============================================'
PRINT 'WARNING: THIS WILL DELETE ALL DATA!'
PRINT '============================================'
PRINT 'Starting data clearing process...'
PRINT ''

-- Disable all foreign key constraints temporarily
PRINT 'Disabling foreign key constraints...'
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
PRINT '✓ Foreign key constraints disabled'
PRINT ''

-- ============================================
-- DELETE DATA IN CORRECT ORDER (respecting dependencies)
-- ============================================

-- Level 5: Most dependent tables (delete first)
PRINT 'Clearing Level 5 tables (most dependent)...'

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_return_items')
BEGIN
    DELETE FROM [dbo].[pharmacy_return_items]
    PRINT '  ✓ Cleared pharmacy_return_items - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales_items')
BEGIN
    DELETE FROM [dbo].[pharmacy_sales_items]
    PRINT '  ✓ Cleared pharmacy_sales_items - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'lab_results')
BEGIN
    DELETE FROM [dbo].[lab_results]
    PRINT '  ✓ Cleared lab_results - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'xray_results')
BEGIN
    DELETE FROM [dbo].[xray_results]
    PRINT '  ✓ Cleared xray_results - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

PRINT ''

-- Level 4: Dependent on Level 3
PRINT 'Clearing Level 4 tables...'

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_returns')
BEGIN
    DELETE FROM [dbo].[pharmacy_returns]
    PRINT '  ✓ Cleared pharmacy_returns - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine_dispensing')
BEGIN
    DELETE FROM [dbo].[medicine_dispensing]
    PRINT '  ✓ Cleared medicine_dispensing - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'patient_bed_charges')
BEGIN
    DELETE FROM [dbo].[patient_bed_charges]
    PRINT '  ✓ Cleared patient_bed_charges - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'patient_charges')
BEGIN
    DELETE FROM [dbo].[patient_charges]
    PRINT '  ✓ Cleared patient_charges - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

PRINT ''

-- Level 3: Prescription-related tables
PRINT 'Clearing Level 3 tables (prescription-related)...'

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'medication')
BEGIN
    DELETE FROM [dbo].[medication]
    PRINT '  ✓ Cleared medication - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'lab_test')
BEGIN
    DELETE FROM [dbo].[lab_test]
    PRINT '  ✓ Cleared lab_test - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'presxray')
BEGIN
    DELETE FROM [dbo].[presxray]
    PRINT '  ✓ Cleared presxray - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'totalamount')
BEGIN
    DELETE FROM [dbo].[totalamount]
    PRINT '  ✓ Cleared totalamount - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

PRINT ''

-- Level 2: Patient and sales tables
PRINT 'Clearing Level 2 tables (patient and sales)...'

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales')
BEGIN
    DELETE FROM [dbo].[pharmacy_sales]
    PRINT '  ✓ Cleared pharmacy_sales - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'prescribtion')
BEGIN
    DELETE FROM [dbo].[prescribtion]
    PRINT '  ✓ Cleared prescribtion - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'registre')
BEGIN
    DELETE FROM [dbo].[registre]
    PRINT '  ✓ Cleared registre - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

PRINT ''

-- Level 1: Base tables with minimal dependencies
PRINT 'Clearing Level 1 tables (base tables)...'

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'patient')
BEGIN
    DELETE FROM [dbo].[patient]
    PRINT '  ✓ Cleared patient - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine_inventory')
BEGIN
    DELETE FROM [dbo].[medicine_inventory]
    PRINT '  ✓ Cleared medicine_inventory - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine')
BEGIN
    DELETE FROM [dbo].[medicine]
    PRINT '  ✓ Cleared medicine - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_customer')
BEGIN
    DELETE FROM [dbo].[pharmacy_customer]
    PRINT '  ✓ Cleared pharmacy_customer - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'xray')
BEGIN
    DELETE FROM [dbo].[xray]
    PRINT '  ✓ Cleared xray - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

PRINT ''

-- Level 0: Configuration and reference tables (DON'T DELETE USERS!)
PRINT 'Clearing Level 0 tables (configuration - keeping users)...'

-- DON'T clear user tables - keep login credentials!
-- IF EXISTS (SELECT * FROM sys.tables WHERE name = 'admin')
-- IF EXISTS (SELECT * FROM sys.tables WHERE name = 'doctor')
-- IF EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_user')
-- IF EXISTS (SELECT * FROM sys.tables WHERE name = 'lab_user')
-- IF EXISTS (SELECT * FROM sys.tables WHERE name = 'xrayuser')
-- IF EXISTS (SELECT * FROM sys.tables WHERE name = 'registre_user')

PRINT '  ℹ User tables preserved (admin, doctor, pharmacy_user, lab_user, xrayuser, registre)'
PRINT '  ℹ Configuration tables preserved (medicine_units, charges_config, hospital_settings, lab_test_prices)'

-- Optionally clear configuration tables (uncomment if needed)
/*
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine_units')
BEGIN
    DELETE FROM [dbo].[medicine_units]
    PRINT '  ✓ Cleared medicine_units - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'charges_config')
BEGIN
    DELETE FROM [dbo].[charges_config]
    PRINT '  ✓ Cleared charges_config - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'lab_test_prices')
BEGIN
    DELETE FROM [dbo].[lab_test_prices]
    PRINT '  ✓ Cleared lab_test_prices - ' + CAST(@@ROWCOUNT AS VARCHAR) + ' rows deleted'
END
*/

PRINT ''

-- ============================================
-- RESET IDENTITY COLUMNS
-- ============================================
PRINT 'Resetting identity columns...'

-- Reset identity seeds for all tables
DBCC CHECKIDENT ('pharmacy_return_items', RESEED, 0)
DBCC CHECKIDENT ('pharmacy_returns', RESEED, 0)
DBCC CHECKIDENT ('pharmacy_sales_items', RESEED, 0)
DBCC CHECKIDENT ('pharmacy_sales', RESEED, 0)
DBCC CHECKIDENT ('lab_results', RESEED, 0)
DBCC CHECKIDENT ('xray_results', RESEED, 0)
DBCC CHECKIDENT ('medicine_dispensing', RESEED, 0)
DBCC CHECKIDENT ('patient_bed_charges', RESEED, 0)
DBCC CHECKIDENT ('patient_charges', RESEED, 0)
DBCC CHECKIDENT ('medication', RESEED, 0)
DBCC CHECKIDENT ('lab_test', RESEED, 0)
DBCC CHECKIDENT ('presxray', RESEED, 0)
DBCC CHECKIDENT ('totalamount', RESEED, 0)
DBCC CHECKIDENT ('prescribtion', RESEED, 0)
DBCC CHECKIDENT ('registre', RESEED, 0)
DBCC CHECKIDENT ('patient', RESEED, 0)
DBCC CHECKIDENT ('medicine_inventory', RESEED, 0)
DBCC CHECKIDENT ('medicine', RESEED, 0)
DBCC CHECKIDENT ('pharmacy_customer', RESEED, 0)
DBCC CHECKIDENT ('xray', RESEED, 0)

PRINT '✓ Identity columns reset'
PRINT ''

-- ============================================
-- RE-ENABLE FOREIGN KEY CONSTRAINTS
-- ============================================
PRINT 'Re-enabling foreign key constraints...'
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'
PRINT '✓ Foreign key constraints re-enabled'
PRINT ''

PRINT '============================================'
PRINT 'DATA CLEARING COMPLETED SUCCESSFULLY'
PRINT '============================================'
PRINT ''
PRINT 'Summary:'
PRINT '  • All transactional data has been deleted'
PRINT '  • User accounts have been preserved'
PRINT '  • Configuration tables have been preserved'
PRINT '  • Identity columns have been reset'
PRINT '  • Database structure is intact'
PRINT ''
PRINT 'You can now run your fresh database script!'
PRINT ''
GO
