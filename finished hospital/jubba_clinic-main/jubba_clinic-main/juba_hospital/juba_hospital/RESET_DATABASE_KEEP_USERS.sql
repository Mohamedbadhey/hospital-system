-- =============================================
-- DATABASE RESET SCRIPT
-- Removes all data EXCEPT user tables
-- Preserves: admin, doctor, lab_user, pharmacy_user, xrayuser, usertype, registre
-- =============================================

USE [juba_clinick]
GO

PRINT 'Starting database reset...'
PRINT 'User tables will be preserved: admin, doctor, lab_user, pharmacy_user, xrayuser, usertype, registre'
PRINT ''

-- Disable all foreign key constraints
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO

PRINT 'Step 1: Clearing patient-related data...'

-- Clear patient charges and bed charges
DELETE FROM [dbo].[patient_charges];
DELETE FROM [dbo].[patient_bed_charges];
PRINT '  ✓ Patient charges cleared'

-- Clear prescriptions and related data
DELETE FROM [dbo].[presxray];
DELETE FROM [dbo].[prescribtion];
PRINT '  ✓ Prescriptions cleared'

-- Clear patients
DELETE FROM [dbo].[patient];
PRINT '  ✓ Patients cleared'

PRINT ''
PRINT 'Step 2: Clearing lab data...'

-- Clear lab results and tests
DELETE FROM [dbo].[lab_results];
DELETE FROM [dbo].[lab_test];
PRINT '  ✓ Lab tests and results cleared'

PRINT ''
PRINT 'Step 3: Clearing x-ray data...'

-- Clear x-ray results and orders
DELETE FROM [dbo].[xray_results];
DELETE FROM [dbo].[xray];
PRINT '  ✓ X-ray data cleared'

PRINT ''
PRINT 'Step 4: Clearing pharmacy data...'

-- Clear pharmacy sales
DELETE FROM [dbo].[pharmacy_sales_items];
DELETE FROM [dbo].[pharmacy_sales];
DELETE FROM [dbo].[pharmacy_customer];
PRINT '  ✓ Pharmacy sales cleared'

PRINT ''
PRINT 'Step 5: Clearing medicine and inventory data...'

-- Clear medicine dispensing and inventory
DELETE FROM [dbo].[medicine_dispensing];
DELETE FROM [dbo].[medicine_inventory];
DELETE FROM [dbo].[medication];
DELETE FROM [dbo].[medicine];
DELETE FROM [dbo].[medicine_units];
PRINT '  ✓ Medicine data cleared'

PRINT ''
PRINT 'Step 6: Clearing other data...'

-- Clear other tables
DELETE FROM [dbo].[totalamount];
PRINT '  ✓ Total amount cleared'

-- Note: charges_config and hospital_settings are configuration tables, clearing them too
DELETE FROM [dbo].[charges_config];
PRINT '  ✓ Charges config cleared'

DELETE FROM [dbo].[hospital_settings];
PRINT '  ✓ Hospital settings cleared'

PRINT ''
PRINT 'Step 7: Re-enabling constraints and reseeding identity columns...'

-- Re-enable all foreign key constraints
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'
GO

-- Reset identity seeds for cleared tables
DBCC CHECKIDENT ('[patient]', RESEED, 1000);
DBCC CHECKIDENT ('[prescribtion]', RESEED, 3000);
DBCC CHECKIDENT ('[lab_test]', RESEED, 0);
DBCC CHECKIDENT ('[lab_results]', RESEED, 0);
DBCC CHECKIDENT ('[xray]', RESEED, 0);
DBCC CHECKIDENT ('[xray_results]', RESEED, 0);
DBCC CHECKIDENT ('[patient_charges]', RESEED, 0);
DBCC CHECKIDENT ('[patient_bed_charges]', RESEED, 0);
DBCC CHECKIDENT ('[pharmacy_sales]', RESEED, 0);
DBCC CHECKIDENT ('[pharmacy_sales_items]', RESEED, 0);
DBCC CHECKIDENT ('[medicine]', RESEED, 0);
DBCC CHECKIDENT ('[medicine_inventory]', RESEED, 0);
DBCC CHECKIDENT ('[medicine_dispensing]', RESEED, 0);
DBCC CHECKIDENT ('[medication]', RESEED, 0);
GO

PRINT ''
PRINT '========================================='
PRINT 'DATABASE RESET COMPLETE!'
PRINT '========================================='
PRINT ''
PRINT 'PRESERVED USER TABLES:'
PRINT '  ✓ admin - All admin users preserved'
PRINT '  ✓ doctor - All doctors preserved'
PRINT '  ✓ lab_user - All lab users preserved'
PRINT '  ✓ pharmacy_user - All pharmacy users preserved'
PRINT '  ✓ xrayuser - All x-ray users preserved'
PRINT '  ✓ registre - All registration users preserved'
PRINT '  ✓ usertype - User types preserved'
PRINT ''
PRINT 'CLEARED DATA:'
PRINT '  • All patients and their records'
PRINT '  • All prescriptions'
PRINT '  • All lab tests and results'
PRINT '  • All x-ray orders and results'
PRINT '  • All pharmacy sales'
PRINT '  • All medicine inventory'
PRINT '  • All charges and payments'
PRINT ''
PRINT 'You can now start fresh with existing users!'
PRINT '========================================='
GO
