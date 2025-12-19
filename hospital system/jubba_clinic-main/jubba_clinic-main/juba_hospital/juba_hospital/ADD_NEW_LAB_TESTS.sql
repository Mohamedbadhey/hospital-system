-- =============================================
-- ADD NEW LAB TESTS TO SYSTEM
-- =============================================
-- Tests to add:
-- 1. Electrolyte - $5
-- 2. CRP Title - $10
-- 3. Ultra - $13
-- 4. Typhoid IgG - $3
-- 5. Typhoid Ag - $5
-- =============================================

USE [juba_clinick]
GO

PRINT 'Adding new lab test columns to lab_test and lab_results tables...'
PRINT ''

-- =============================================
-- Step 1: Add columns to lab_test table
-- =============================================

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_test' AND COLUMN_NAME = 'Electrolyte')
BEGIN
    ALTER TABLE [dbo].[lab_test] ADD [Electrolyte] [nvarchar](100) NULL
    PRINT '✓ Added Electrolyte to lab_test'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_test' AND COLUMN_NAME = 'CRP_Titer')
BEGIN
    ALTER TABLE [dbo].[lab_test] ADD [CRP_Titer] [nvarchar](100) NULL
    PRINT '✓ Added CRP_Titer to lab_test'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_test' AND COLUMN_NAME = 'Ultra')
BEGIN
    ALTER TABLE [dbo].[lab_test] ADD [Ultra] [nvarchar](100) NULL
    PRINT '✓ Added Ultra to lab_test'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_test' AND COLUMN_NAME = 'Typhoid_IgG')
BEGIN
    ALTER TABLE [dbo].[lab_test] ADD [Typhoid_IgG] [nvarchar](100) NULL
    PRINT '✓ Added Typhoid_IgG to lab_test'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_test' AND COLUMN_NAME = 'Typhoid_Ag')
BEGIN
    ALTER TABLE [dbo].[lab_test] ADD [Typhoid_Ag] [nvarchar](100) NULL
    PRINT '✓ Added Typhoid_Ag to lab_test'
END

PRINT ''

-- =============================================
-- Step 2: Add columns to lab_results table
-- =============================================

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_results' AND COLUMN_NAME = 'Electrolyte')
BEGIN
    ALTER TABLE [dbo].[lab_results] ADD [Electrolyte] [nvarchar](100) NULL
    PRINT '✓ Added Electrolyte to lab_results'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_results' AND COLUMN_NAME = 'CRP_Titer')
BEGIN
    ALTER TABLE [dbo].[lab_results] ADD [CRP_Titer] [nvarchar](100) NULL
    PRINT '✓ Added CRP_Titer to lab_results'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_results' AND COLUMN_NAME = 'Ultra')
BEGIN
    ALTER TABLE [dbo].[lab_results] ADD [Ultra] [nvarchar](100) NULL
    PRINT '✓ Added Ultra to lab_results'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_results' AND COLUMN_NAME = 'Typhoid_IgG')
BEGIN
    ALTER TABLE [dbo].[lab_results] ADD [Typhoid_IgG] [nvarchar](100) NULL
    PRINT '✓ Added Typhoid_IgG to lab_results'
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_results' AND COLUMN_NAME = 'Typhoid_Ag')
BEGIN
    ALTER TABLE [dbo].[lab_results] ADD [Typhoid_Ag] [nvarchar](100) NULL
    PRINT '✓ Added Typhoid_Ag to lab_results'
END

PRINT ''

-- =============================================
-- Step 3: Add test prices to lab_test_prices table
-- =============================================

-- Check if lab_test_prices table exists, if not create it
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'lab_test_prices')
BEGIN
    CREATE TABLE [dbo].[lab_test_prices] (
        [test_id] [int] IDENTITY(1,1) PRIMARY KEY,
        [test_name] [nvarchar](100) NOT NULL UNIQUE,
        [price] [decimal](10, 2) NOT NULL,
        [date_added] [datetime] NULL DEFAULT (GETDATE()),
        [last_updated] [datetime] NULL
    )
    PRINT '✓ Created lab_test_prices table'
END

-- Insert test prices
IF NOT EXISTS (SELECT * FROM lab_test_prices WHERE test_name = 'Electrolyte')
BEGIN
    INSERT INTO [dbo].[lab_test_prices] (test_name, price) VALUES ('Electrolyte', 5.00)
    PRINT '✓ Added Electrolyte price: $5.00'
END

IF NOT EXISTS (SELECT * FROM lab_test_prices WHERE test_name = 'CRP_Titer')
BEGIN
    INSERT INTO [dbo].[lab_test_prices] (test_name, price) VALUES ('CRP_Titer', 10.00)
    PRINT '✓ Added CRP_Titer price: $10.00'
END

IF NOT EXISTS (SELECT * FROM lab_test_prices WHERE test_name = 'Ultra')
BEGIN
    INSERT INTO [dbo].[lab_test_prices] (test_name, price) VALUES ('Ultra', 13.00)
    PRINT '✓ Added Ultra price: $13.00'
END

IF NOT EXISTS (SELECT * FROM lab_test_prices WHERE test_name = 'Typhoid_IgG')
BEGIN
    INSERT INTO [dbo].[lab_test_prices] (test_name, price) VALUES ('Typhoid_IgG', 3.00)
    PRINT '✓ Added Typhoid_IgG price: $3.00'
END

IF NOT EXISTS (SELECT * FROM lab_test_prices WHERE test_name = 'Typhoid_Ag')
BEGIN
    INSERT INTO [dbo].[lab_test_prices] (test_name, price) VALUES ('Typhoid_Ag', 5.00)
    PRINT '✓ Added Typhoid_Ag price: $5.00'
END

PRINT ''
PRINT '========================================='
PRINT 'NEW LAB TESTS ADDED SUCCESSFULLY!'
PRINT '========================================='
PRINT ''
PRINT 'Added Tests:'
PRINT '  1. Electrolyte ............... $5.00'
PRINT '  2. CRP Titer ................. $10.00'
PRINT '  3. Ultra ..................... $13.00'
PRINT '  4. Typhoid IgG ............... $3.00'
PRINT '  5. Typhoid Ag ................ $5.00'
PRINT ''
PRINT 'Next Steps:'
PRINT '  - Update UI pages to include new test checkboxes'
PRINT '  - Update lap_operation.aspx INSERT statement'
PRINT '  - Test ordering and results entry'
PRINT '========================================='
GO
