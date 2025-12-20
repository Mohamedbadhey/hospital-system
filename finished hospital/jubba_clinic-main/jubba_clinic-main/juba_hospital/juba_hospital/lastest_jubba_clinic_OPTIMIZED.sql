-- ============================================
-- OPTIMIZED DATABASE SCRIPT WITH PERFORMANCE INDEXES
-- Created: December 19, 2025
-- Purpose: Enhanced version with indexes for better query performance
-- ============================================

-- This script adds strategic indexes based on query patterns found in the application
-- Indexes are designed to optimize:
-- 1. Foreign key lookups
-- 2. Date range queries (sale_date, return_date, etc.)
-- 3. Status filtering
-- 4. Invoice and reference number searches
-- 5. Patient and prescription lookups

USE [db_ac228a_vafmadow]
GO

PRINT '============================================'
PRINT 'ADDING PERFORMANCE INDEXES'
PRINT '============================================'
PRINT ''

-- ============================================
-- PATIENT TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for patient table...'

-- Index for patient status filtering (heavily used in registration pages)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_status' AND object_id = OBJECT_ID('patient'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_patient_status 
    ON [dbo].[patient] ([patient_status]) 
    INCLUDE ([patientid], [full_name], [phone], [location])
    PRINT '  ✓ Created IX_patient_status'
END

-- Index for patient name searches
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_name' AND object_id = OBJECT_ID('patient'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_patient_name 
    ON [dbo].[patient] ([full_name])
    INCLUDE ([patientid], [patient_status])
    PRINT '  ✓ Created IX_patient_name'
END

-- ============================================
-- PRESCRIPTION (prescribtion) TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for prescribtion table...'

-- Index for patient lookups (most common join)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_prescribtion_patientid' AND object_id = OBJECT_ID('prescribtion'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_prescribtion_patientid 
    ON [dbo].[prescribtion] ([patientid]) 
    INCLUDE ([prescid], [status], [xray_status], [completed_date])
    PRINT '  ✓ Created IX_prescribtion_patientid'
END

-- Index for status filtering (frequently used in queries)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_prescribtion_status' AND object_id = OBJECT_ID('prescribtion'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_prescribtion_status 
    ON [dbo].[prescribtion] ([status]) 
    INCLUDE ([prescid], [patientid], [completed_date])
    PRINT '  ✓ Created IX_prescribtion_status'
END

-- Index for xray status filtering
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_prescribtion_xray_status' AND object_id = OBJECT_ID('prescribtion'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_prescribtion_xray_status 
    ON [dbo].[prescribtion] ([xray_status]) 
    INCLUDE ([prescid], [patientid])
    PRINT '  ✓ Created IX_prescribtion_xray_status'
END

-- Composite index for patient + status (very common combination)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_prescribtion_patient_status' AND object_id = OBJECT_ID('prescribtion'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_prescribtion_patient_status 
    ON [dbo].[prescribtion] ([patientid], [status])
    INCLUDE ([prescid], [xray_status], [completed_date])
    PRINT '  ✓ Created IX_prescribtion_patient_status'
END

-- ============================================
-- PHARMACY SALES TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for pharmacy_sales table...'

-- Index for date range queries (very common for reports)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_sales_date' AND object_id = OBJECT_ID('pharmacy_sales'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_pharmacy_sales_date 
    ON [dbo].[pharmacy_sales] ([sale_date]) 
    INCLUDE ([saleid], [invoice_number], [total_amount], [final_amount], [total_profit], [status])
    PRINT '  ✓ Created IX_pharmacy_sales_date'
END

-- Index for invoice number lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_sales_invoice' AND object_id = OBJECT_ID('pharmacy_sales'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_pharmacy_sales_invoice 
    ON [dbo].[pharmacy_sales] ([invoice_number])
    INCLUDE ([saleid], [customer_name], [sale_date], [final_amount], [status])
    PRINT '  ✓ Created IX_pharmacy_sales_invoice'
END

-- Index for status filtering (used in returns and reports)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_sales_status' AND object_id = OBJECT_ID('pharmacy_sales'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_pharmacy_sales_status 
    ON [dbo].[pharmacy_sales] ([status]) 
    INCLUDE ([saleid], [sale_date], [final_amount])
    PRINT '  ✓ Created IX_pharmacy_sales_status'
END

-- Index for customer searches
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_sales_customer' AND object_id = OBJECT_ID('pharmacy_sales'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_pharmacy_sales_customer 
    ON [dbo].[pharmacy_sales] ([customer_name])
    INCLUDE ([saleid], [sale_date], [invoice_number])
    PRINT '  ✓ Created IX_pharmacy_sales_customer'
END

-- ============================================
-- PHARMACY SALES ITEMS TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for pharmacy_sales_items table...'

-- Index for sale lookups (foreign key)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_sales_items_saleid' AND object_id = OBJECT_ID('pharmacy_sales_items'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_pharmacy_sales_items_saleid 
    ON [dbo].[pharmacy_sales_items] ([saleid]) 
    INCLUDE ([medicineid], [quantity], [total_price], [profit])
    PRINT '  ✓ Created IX_pharmacy_sales_items_saleid'
END

-- Index for medicine lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_sales_items_medicineid' AND object_id = OBJECT_ID('pharmacy_sales_items'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_pharmacy_sales_items_medicineid 
    ON [dbo].[pharmacy_sales_items] ([medicineid])
    INCLUDE ([saleid], [quantity], [total_price])
    PRINT '  ✓ Created IX_pharmacy_sales_items_medicineid'
END

-- Index for inventory tracking
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_sales_items_inventoryid' AND object_id = OBJECT_ID('pharmacy_sales_items'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_pharmacy_sales_items_inventoryid 
    ON [dbo].[pharmacy_sales_items] ([inventoryid])
    PRINT '  ✓ Created IX_pharmacy_sales_items_inventoryid'
END

-- ============================================
-- PHARMACY RETURNS TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for pharmacy_returns table...'

-- Index for original sale lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_returns_saleid' AND object_id = OBJECT_ID('pharmacy_returns'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_pharmacy_returns_saleid 
    ON [dbo].[pharmacy_returns] ([original_saleid]) 
    INCLUDE ([returnid], [return_date], [status], [total_return_amount])
    PRINT '  ✓ Created IX_pharmacy_returns_saleid'
END

-- Index for status filtering
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_returns_status' AND object_id = OBJECT_ID('pharmacy_returns'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_pharmacy_returns_status 
    ON [dbo].[pharmacy_returns] ([status])
    INCLUDE ([returnid], [original_saleid])
    PRINT '  ✓ Created IX_pharmacy_returns_status'
END

-- Index for date queries
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_returns_date' AND object_id = OBJECT_ID('pharmacy_returns'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_pharmacy_returns_date 
    ON [dbo].[pharmacy_returns] ([return_date])
    PRINT '  ✓ Created IX_pharmacy_returns_date'
END

-- ============================================
-- PHARMACY RETURN ITEMS TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for pharmacy_return_items table...'

-- Index for return lookups (foreign key)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_pharmacy_return_items_returnid' AND object_id = OBJECT_ID('pharmacy_return_items'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_pharmacy_return_items_returnid 
    ON [dbo].[pharmacy_return_items] ([returnid])
    INCLUDE ([medicineid], [quantity_returned], [return_amount])
    PRINT '  ✓ Created IX_pharmacy_return_items_returnid'
END

-- ============================================
-- MEDICINE TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for medicine table...'

-- Index for medicine name searches
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_medicine_name' AND object_id = OBJECT_ID('medicine'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_medicine_name 
    ON [dbo].[medicine] ([medicine_name])
    INCLUDE ([medicineid], [generic_name], [unit_id])
    PRINT '  ✓ Created IX_medicine_name'
END

-- Index for barcode lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_medicine_barcode' AND object_id = OBJECT_ID('medicine'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_medicine_barcode 
    ON [dbo].[medicine] ([barcode])
    INCLUDE ([medicineid], [medicine_name])
    PRINT '  ✓ Created IX_medicine_barcode'
END

-- ============================================
-- MEDICINE INVENTORY TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for medicine_inventory table...'

-- Index for medicine lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_medicine_inventory_medicineid' AND object_id = OBJECT_ID('medicine_inventory'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_medicine_inventory_medicineid 
    ON [dbo].[medicine_inventory] ([medicineid])
    INCLUDE ([inventoryid], [batch_number], [primary_quantity], [expiry_date], [purchase_price])
    PRINT '  ✓ Created IX_medicine_inventory_medicineid'
END

-- Index for expiry date monitoring
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_medicine_inventory_expiry' AND object_id = OBJECT_ID('medicine_inventory'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_medicine_inventory_expiry 
    ON [dbo].[medicine_inventory] ([expiry_date])
    INCLUDE ([medicineid], [batch_number], [primary_quantity])
    PRINT '  ✓ Created IX_medicine_inventory_expiry'
END

-- Index for batch number lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_medicine_inventory_batch' AND object_id = OBJECT_ID('medicine_inventory'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_medicine_inventory_batch 
    ON [dbo].[medicine_inventory] ([batch_number])
    PRINT '  ✓ Created IX_medicine_inventory_batch'
END

-- ============================================
-- MEDICATION TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for medication table...'

-- Index for prescription lookups (foreign key)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_medication_prescid' AND object_id = OBJECT_ID('medication'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_medication_prescid 
    ON [dbo].[medication] ([prescid])
    INCLUDE ([medid], [med_name], [dosage])
    PRINT '  ✓ Created IX_medication_prescid'
END

-- ============================================
-- LAB TEST TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for lab_test table...'

-- Index for prescription lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_lab_test_prescid' AND object_id = OBJECT_ID('lab_test'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_lab_test_prescid 
    ON [dbo].[lab_test] ([prescid])
    INCLUDE ([med_id], [patientid], [status])
    PRINT '  ✓ Created IX_lab_test_prescid'
END

-- Index for patient lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_lab_test_patientid' AND object_id = OBJECT_ID('lab_test'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_lab_test_patientid 
    ON [dbo].[lab_test] ([patientid])
    INCLUDE ([med_id], [prescid], [status])
    PRINT '  ✓ Created IX_lab_test_patientid'
END

-- Index for status filtering
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_lab_test_status' AND object_id = OBJECT_ID('lab_test'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_lab_test_status 
    ON [dbo].[lab_test] ([status])
    INCLUDE ([med_id], [prescid], [patientid])
    PRINT '  ✓ Created IX_lab_test_status'
END

-- ============================================
-- LAB RESULTS TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for lab_results table...'

-- Index for lab test lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_lab_results_testid' AND object_id = OBJECT_ID('lab_results'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_lab_results_testid 
    ON [dbo].[lab_results] ([lab_test_id])
    INCLUDE ([result_id], [test_date], [result_value])
    PRINT '  ✓ Created IX_lab_results_testid'
END

-- ============================================
-- XRAY (presxray) TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for presxray table...'

-- Index for prescription lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_presxray_prescid' AND object_id = OBJECT_ID('presxray'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_presxray_prescid 
    ON [dbo].[presxray] ([prescid])
    INCLUDE ([x_id], [patientid], [status])
    PRINT '  ✓ Created IX_presxray_prescid'
END

-- Index for patient lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_presxray_patientid' AND object_id = OBJECT_ID('presxray'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_presxray_patientid 
    ON [dbo].[presxray] ([patientid])
    INCLUDE ([x_id], [prescid], [status])
    PRINT '  ✓ Created IX_presxray_patientid'
END

-- ============================================
-- PATIENT CHARGES TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for patient_charges table...'

-- Index for prescription lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_charges_prescid' AND object_id = OBJECT_ID('patient_charges'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_patient_charges_prescid 
    ON [dbo].[patient_charges] ([prescid])
    INCLUDE ([charge_id], [patientid], [amount], [is_paid])
    PRINT '  ✓ Created IX_patient_charges_prescid'
END

-- Index for patient lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_charges_patientid' AND object_id = OBJECT_ID('patient_charges'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_patient_charges_patientid 
    ON [dbo].[patient_charges] ([patientid])
    INCLUDE ([charge_id], [prescid], [amount], [is_paid])
    PRINT '  ✓ Created IX_patient_charges_patientid'
END

-- Index for payment status filtering
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_charges_payment_status' AND object_id = OBJECT_ID('patient_charges'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_patient_charges_payment_status 
    ON [dbo].[patient_charges] ([is_paid])
    INCLUDE ([charge_id], [patientid], [amount])
    PRINT '  ✓ Created IX_patient_charges_payment_status'
END

-- Index for invoice number lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_charges_invoice' AND object_id = OBJECT_ID('patient_charges'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_patient_charges_invoice 
    ON [dbo].[patient_charges] ([invoice_number])
    INCLUDE ([charge_id], [patientid], [prescid])
    PRINT '  ✓ Created IX_patient_charges_invoice'
END

-- ============================================
-- PATIENT BED CHARGES TABLE INDEXES
-- ============================================
PRINT 'Adding indexes for patient_bed_charges table...'

-- Index for prescription lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_bed_charges_prescid' AND object_id = OBJECT_ID('patient_bed_charges'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_patient_bed_charges_prescid 
    ON [dbo].[patient_bed_charges] ([prescid])
    INCLUDE ([bed_charge_id], [patientid], [charge_date], [bed_charge_amount])
    PRINT '  ✓ Created IX_patient_bed_charges_prescid'
END

-- Index for patient lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_patient_bed_charges_patientid' AND object_id = OBJECT_ID('patient_bed_charges'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_patient_bed_charges_patientid 
    ON [dbo].[patient_bed_charges] ([patientid])
    INCLUDE ([bed_charge_id], [prescid], [charge_date], [bed_charge_amount])
    PRINT '  ✓ Created IX_patient_bed_charges_patientid'
END

-- ============================================
-- REGISTRE TABLE INDEXES (User Registration - skipped, not transactional)
-- ============================================
-- Note: The 'registre' table is for user registration, not patient registration
-- No indexes needed as it's rarely queried

PRINT ''
PRINT '============================================'
PRINT 'INDEX CREATION COMPLETED SUCCESSFULLY'
PRINT '============================================'
PRINT ''
PRINT 'Performance optimization complete! Your database queries should now run faster.'
PRINT ''
GO
