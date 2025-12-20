-- =============================================
-- Hospital Charging System - Database Migration
-- Created: 2025-11-30
-- Description: Adds bed charges, delivery charges, and patient type management
-- =============================================

USE [jubbclickin]
GO

-- =============================================
-- Step 1: Add new columns to patient table
-- =============================================
PRINT 'Adding new columns to patient table...'

-- Add patient_type column (inpatient/outpatient)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'patient' AND COLUMN_NAME = 'patient_type')
BEGIN
    ALTER TABLE [dbo].[patient]
    ADD [patient_type] VARCHAR(20) NULL DEFAULT 'outpatient'
    PRINT 'Added patient_type column'
END
ELSE
BEGIN
    PRINT 'patient_type column already exists'
END
GO

-- Add bed_admission_date column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'patient' AND COLUMN_NAME = 'bed_admission_date')
BEGIN
    ALTER TABLE [dbo].[patient]
    ADD [bed_admission_date] DATETIME NULL
    PRINT 'Added bed_admission_date column'
END
ELSE
BEGIN
    PRINT 'bed_admission_date column already exists'
END
GO

-- Add delivery_charge column
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'patient' AND COLUMN_NAME = 'delivery_charge')
BEGIN
    ALTER TABLE [dbo].[patient]
    ADD [delivery_charge] DECIMAL(10, 2) NULL DEFAULT 0
    PRINT 'Added delivery_charge column'
END
ELSE
BEGIN
    PRINT 'delivery_charge column already exists'
END
GO

-- =============================================
-- Step 2: Create patient_bed_charges table
-- =============================================
PRINT 'Creating patient_bed_charges table...'

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES 
               WHERE TABLE_NAME = 'patient_bed_charges')
BEGIN
    CREATE TABLE [dbo].[patient_bed_charges](
        [bed_charge_id] [int] IDENTITY(1,1) NOT NULL,
        [patientid] [int] NOT NULL,
        [prescid] [int] NULL,
        [charge_date] [date] NOT NULL,
        [bed_charge_amount] [decimal](10, 2) NOT NULL,
        [is_paid] [bit] NOT NULL DEFAULT 0,
        [created_at] [datetime] NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [PK_patient_bed_charges] PRIMARY KEY CLUSTERED ([bed_charge_id] ASC),
        CONSTRAINT [FK_patient_bed_charges_patient] FOREIGN KEY([patientid]) 
            REFERENCES [dbo].[patient] ([patientid]),
        CONSTRAINT [FK_patient_bed_charges_prescription] FOREIGN KEY([prescid]) 
            REFERENCES [dbo].[prescribtion] ([prescid])
    )
    PRINT 'Created patient_bed_charges table'
END
ELSE
BEGIN
    PRINT 'patient_bed_charges table already exists'
END
GO

-- Create index on charge_date for faster queries
IF NOT EXISTS (SELECT * FROM sys.indexes 
               WHERE name = 'IX_patient_bed_charges_date' AND object_id = OBJECT_ID('patient_bed_charges'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_patient_bed_charges_date]
    ON [dbo].[patient_bed_charges] ([charge_date] ASC)
    PRINT 'Created index on charge_date'
END
GO

-- Create index on patientid for faster queries
IF NOT EXISTS (SELECT * FROM sys.indexes 
               WHERE name = 'IX_patient_bed_charges_patient' AND object_id = OBJECT_ID('patient_bed_charges'))
BEGIN
    CREATE NONCLUSTERED INDEX [IX_patient_bed_charges_patient]
    ON [dbo].[patient_bed_charges] ([patientid] ASC)
    PRINT 'Created index on patientid'
END
GO

-- =============================================
-- Step 3: Add default charge configurations
-- =============================================
PRINT 'Adding default charge configurations...'

-- Add Bed charge type if not exists
IF NOT EXISTS (SELECT * FROM [dbo].[charges_config] 
               WHERE charge_type = 'Bed' AND charge_name = 'Standard Bed Charge (Per Night)')
BEGIN
    INSERT INTO [dbo].[charges_config] (charge_type, charge_name, amount, is_active)
    VALUES ('Bed', 'Standard Bed Charge (Per Night)', 50.00, 1)
    PRINT 'Added default Bed charge configuration'
END
ELSE
BEGIN
    PRINT 'Bed charge configuration already exists'
END
GO

-- Add Delivery charge type if not exists
IF NOT EXISTS (SELECT * FROM [dbo].[charges_config] 
               WHERE charge_type = 'Delivery' AND charge_name = 'Delivery Service Charge')
BEGIN
    INSERT INTO [dbo].[charges_config] (charge_type, charge_name, amount, is_active)
    VALUES ('Delivery', 'Delivery Service Charge', 200.00, 1)
    PRINT 'Added default Delivery charge configuration'
END
ELSE
BEGIN
    PRINT 'Delivery charge configuration already exists'
END
GO

-- =============================================
-- Step 4: Update existing patient records
-- =============================================
PRINT 'Updating existing patient records...'

-- Set default patient_type for existing records
UPDATE [dbo].[patient]
SET patient_type = 'outpatient'
WHERE patient_type IS NULL
GO

PRINT 'Migration completed successfully!'
PRINT '========================================='
PRINT 'Summary:'
PRINT '- Added patient_type, bed_admission_date, delivery_charge columns to patient table'
PRINT '- Created patient_bed_charges table with indexes'
PRINT '- Added default Bed and Delivery charge configurations'
PRINT '- Updated existing patient records with default values'
PRINT '========================================='
GO
