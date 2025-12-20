-- ================================================
-- JUBA HOSPITAL DATABASE RESET SCRIPT
-- This script deletes ALL data but keeps table structures
-- Created based on jubba_clinick.sql schema
-- ================================================

USE juba_clinick;
GO

PRINT 'Starting database reset...';
GO

-- ================================================
-- DISABLE ALL FOREIGN KEY CONSTRAINTS
-- ================================================
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

PRINT 'Foreign key constraints disabled...';
GO

-- ================================================
-- DELETE DATA FROM ALL TABLES (in proper order)
-- ================================================

-- Patient-related transactions (delete first - have most dependencies)
DELETE FROM patient_bed_charges;
DELETE FROM patient_charges;
DELETE FROM medicine_dispensing;

-- Lab transactions
DELETE FROM lab_results;
DELETE FROM lab_test;

-- X-ray transactions
DELETE FROM xray_results;
DELETE FROM presxray;
DELETE FROM xray;

-- Pharmacy transactions
DELETE FROM pharmacy_sales_items;
DELETE FROM pharmacy_sales;
DELETE FROM pharmacy_customer;

-- Medication and prescriptions
DELETE FROM medication;
DELETE FROM prescribtion;

-- Medicine inventory
DELETE FROM medicine_inventory;
DELETE FROM medicine;

-- Patient table
DELETE FROM patient;

-- User tables
DELETE FROM lab_user;
DELETE FROM xrayuser;
DELETE FROM pharmacy_user;
DELETE FROM doctor;
DELETE FROM registre;
DELETE FROM admin;

-- Configuration tables (optional - you may want to keep these)
-- DELETE FROM charges_config;
-- DELETE FROM hospital_settings;
-- DELETE FROM medicine_units;

-- Other tables
DELETE FROM totalamount;
DELETE FROM usertype;

PRINT 'All data deleted...';
GO

-- ================================================
-- RESET IDENTITY COLUMNS (start from 1)
-- ================================================

-- Patient-related
DBCC CHECKIDENT ('patient_bed_charges', RESEED, 0);
DBCC CHECKIDENT ('patient_charges', RESEED, 0);
DBCC CHECKIDENT ('patient', RESEED, 1000); -- Starting from 1000 for patient IDs

-- Prescription and medication
DBCC CHECKIDENT ('prescribtion', RESEED, 3000); -- Starting from 3000 for prescription IDs
DBCC CHECKIDENT ('medication', RESEED, 0);

-- Lab
DBCC CHECKIDENT ('lab_results', RESEED, 0);
DBCC CHECKIDENT ('lab_test', RESEED, 0);
DBCC CHECKIDENT ('lab_user', RESEED, 0);

-- X-ray
DBCC CHECKIDENT ('xray_results', RESEED, 0);
DBCC CHECKIDENT ('xray', RESEED, 0);
DBCC CHECKIDENT ('xrayuser', RESEED, 0);

-- Pharmacy
DBCC CHECKIDENT ('pharmacy_sales', RESEED, 0);
DBCC CHECKIDENT ('pharmacy_sales_items', RESEED, 0);
DBCC CHECKIDENT ('pharmacy_customer', RESEED, 0);
DBCC CHECKIDENT ('pharmacy_user', RESEED, 0);

-- Medicine
DBCC CHECKIDENT ('medicine', RESEED, 0);
DBCC CHECKIDENT ('medicine_inventory', RESEED, 0);
-- DBCC CHECKIDENT ('medicine_units', RESEED, 0); -- Keep units if needed

-- Staff
DBCC CHECKIDENT ('doctor', RESEED, 0);
DBCC CHECKIDENT ('registre', RESEED, 0);
DBCC CHECKIDENT ('admin', RESEED, 0);

-- Configuration (optional)
-- DBCC CHECKIDENT ('charges_config', RESEED, 0);
-- DBCC CHECKIDENT ('hospital_settings', RESEED, 0);

PRINT 'Identity columns reset...';
GO

-- ================================================
-- RE-ENABLE ALL FOREIGN KEY CONSTRAINTS
-- ================================================
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO

PRINT 'Foreign key constraints re-enabled...';
GO

-- ================================================
-- VERIFICATION - Check row counts for main tables
-- ================================================

SELECT 'VERIFICATION - Row Counts After Reset' as Info;
GO

SELECT 
    'patient' as TableName, 
    COUNT(*) as RowCount 
FROM patient
UNION ALL
SELECT 'patient_bed_charges', COUNT(*) FROM patient_bed_charges
UNION ALL
SELECT 'patient_charges', COUNT(*) FROM patient_charges
UNION ALL
SELECT 'prescribtion', COUNT(*) FROM prescribtion
UNION ALL
SELECT 'medication', COUNT(*) FROM medication
UNION ALL
SELECT 'lab_test', COUNT(*) FROM lab_test
UNION ALL
SELECT 'lab_results', COUNT(*) FROM lab_results
UNION ALL
SELECT 'xray', COUNT(*) FROM xray
UNION ALL
SELECT 'pharmacy_sales', COUNT(*) FROM pharmacy_sales
UNION ALL
SELECT 'medicine', COUNT(*) FROM medicine
UNION ALL
SELECT 'doctor', COUNT(*) FROM doctor
UNION ALL
SELECT 'admin', COUNT(*) FROM admin
UNION ALL
SELECT 'lab_user', COUNT(*) FROM lab_user
UNION ALL
SELECT 'pharmacy_user', COUNT(*) FROM pharmacy_user
ORDER BY TableName;
GO

PRINT '';
PRINT '================================================';
PRINT 'DATABASE RESET COMPLETE!';
PRINT '================================================';
PRINT '';
PRINT 'All transactional data has been deleted.';
PRINT 'Table structures remain intact.';
PRINT 'Identity columns have been reset.';
PRINT '';
PRINT 'NEXT STEPS:';
PRINT '1. Review the verification counts above';
PRINT '2. Add test users (admin, doctors, lab users, etc.)';
PRINT '3. Configure hospital settings';
PRINT '4. Add medicine units and medicines';
PRINT '5. Configure charge rates';
PRINT '6. Start testing with fresh data';
PRINT '';
PRINT '================================================';
GO
```

### **⚠️ IMPORTANT - Read Before Running:**

This script will:
- ✅ **DELETE ALL DATA** from all tables
- ✅ Keep all table structures intact
- ✅ Reset ID counters
- ⚠️ **Keep configuration tables** (commented out - uncomment if you want to delete):
  - `charges_config`
  - `hospital_settings`
  - `medicine_units`

### **📋 What Gets Deleted:**
- All patients and their records
- All prescriptions and medications
- All lab tests and results
- All x-ray tests and results
- All pharmacy sales
- All medicines in inventory
- All users (doctors, lab staff, pharmacy staff, registration staff)

### **🔒 What's Preserved:**
- Table structures
- Indexes
- Relationships (foreign keys)
- Configuration tables (if you keep them commented)

### **🚀 To Run:**
1. **Backup first** (if needed)
2. Open SQL Server Management Studio
3. Open this file: `tmp_rovodev_RESET_DATABASE.sql`
4. Review the script
5. Execute (F5)
6. Check verification counts at the end

**Would you like me to also create a minimal test data script to quickly populate the database with sample users and data after the reset?**