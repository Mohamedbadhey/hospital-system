-- =====================================================
-- FIX PHARMACY_SALES_ITEMS COLUMN NAMES
-- =====================================================
-- This script ensures pharmacy_sales_items has the correct
-- column names to match the backend code
-- =====================================================

USE [juba_clinick]
GO

PRINT '====================================================='
PRINT 'FIXING PHARMACY_SALES_ITEMS COLUMN NAMES'
PRINT '====================================================='
PRINT ''

-- =====================================================
-- STEP 1: Check if table exists
-- =====================================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales_items')
BEGIN
    PRINT '❌ ERROR: pharmacy_sales_items table does not exist!'
    PRINT '   Please run pharmacy_pos_database.sql first to create the table.'
    RETURN
END

PRINT '✅ Table pharmacy_sales_items exists'
PRINT ''

-- =====================================================
-- STEP 2: Add/Rename columns to match backend code
-- =====================================================
PRINT 'STEP 2: Ensuring correct column names...'
PRINT ''

-- Handle saleid vs sale_id
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'saleid')
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'sale_id')
    BEGIN
        PRINT '  Adding sale_id column and copying data from saleid...'
        ALTER TABLE pharmacy_sales_items ADD sale_id INT NULL;
        EXEC('UPDATE pharmacy_sales_items SET sale_id = saleid');
        PRINT '  ✅ sale_id column added'
    END
    ELSE
        PRINT '  ✅ sale_id column already exists'
END
ELSE IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'sale_id')
BEGIN
    PRINT '  Adding sale_id column...'
    ALTER TABLE pharmacy_sales_items ADD sale_id INT NULL;
    PRINT '  ✅ sale_id column added'
END
ELSE
    PRINT '  ✅ sale_id column already exists'

-- Handle medicineid vs medicine_id
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'medicineid')
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'medicine_id')
    BEGIN
        PRINT '  Adding medicine_id column and copying data from medicineid...'
        ALTER TABLE pharmacy_sales_items ADD medicine_id INT NULL;
        EXEC('UPDATE pharmacy_sales_items SET medicine_id = medicineid');
        PRINT '  ✅ medicine_id column added'
    END
    ELSE
        PRINT '  ✅ medicine_id column already exists'
END
ELSE IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'medicine_id')
BEGIN
    PRINT '  Adding medicine_id column...'
    ALTER TABLE pharmacy_sales_items ADD medicine_id INT NULL;
    PRINT '  ✅ medicine_id column added'
END
ELSE
    PRINT '  ✅ medicine_id column already exists'

-- Handle inventoryid vs inventory_id
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'inventoryid')
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'inventory_id')
    BEGIN
        PRINT '  Adding inventory_id column and copying data from inventoryid...'
        ALTER TABLE pharmacy_sales_items ADD inventory_id INT NULL;
        EXEC('UPDATE pharmacy_sales_items SET inventory_id = inventoryid');
        PRINT '  ✅ inventory_id column added'
    END
    ELSE
        PRINT '  ✅ inventory_id column already exists'
END
ELSE IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'inventory_id')
BEGIN
    PRINT '  Adding inventory_id column...'
    ALTER TABLE pharmacy_sales_items ADD inventory_id INT NULL;
    PRINT '  ✅ inventory_id column added'
END
ELSE
    PRINT '  ✅ inventory_id column already exists'

PRINT ''

-- =====================================================
-- STEP 3: Ensure cost tracking columns exist
-- =====================================================
PRINT 'STEP 3: Ensuring cost tracking columns exist...'
PRINT ''

-- Add cost_price column if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'cost_price')
BEGIN
    PRINT '  Adding cost_price column...'
    ALTER TABLE pharmacy_sales_items ADD cost_price FLOAT DEFAULT 0;
    PRINT '  ✅ cost_price column added'
END
ELSE
    PRINT '  ✅ cost_price column already exists'

-- Add profit column if missing
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'profit')
BEGIN
    PRINT '  Adding profit column...'
    ALTER TABLE pharmacy_sales_items ADD profit FLOAT DEFAULT 0;
    PRINT '  ✅ profit column added'
END
ELSE
    PRINT '  ✅ profit column already exists'

PRINT ''

-- =====================================================
-- STEP 4: Verify all required columns exist
-- =====================================================
PRINT 'STEP 4: Verification...'
PRINT ''

DECLARE @missingColumns INT = 0;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'sale_item_id')
BEGIN
    PRINT '  ❌ MISSING: sale_item_id'
    SET @missingColumns = @missingColumns + 1
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'sale_id')
BEGIN
    PRINT '  ❌ MISSING: sale_id'
    SET @missingColumns = @missingColumns + 1
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'medicine_id')
BEGIN
    PRINT '  ❌ MISSING: medicine_id'
    SET @missingColumns = @missingColumns + 1
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'inventory_id')
BEGIN
    PRINT '  ❌ MISSING: inventory_id'
    SET @missingColumns = @missingColumns + 1
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'quantity_type')
BEGIN
    PRINT '  ❌ MISSING: quantity_type'
    SET @missingColumns = @missingColumns + 1
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'quantity')
BEGIN
    PRINT '  ❌ MISSING: quantity'
    SET @missingColumns = @missingColumns + 1
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'unit_price')
BEGIN
    PRINT '  ❌ MISSING: unit_price'
    SET @missingColumns = @missingColumns + 1
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'total_price')
BEGIN
    PRINT '  ❌ MISSING: total_price'
    SET @missingColumns = @missingColumns + 1
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'cost_price')
BEGIN
    PRINT '  ❌ MISSING: cost_price'
    SET @missingColumns = @missingColumns + 1
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales_items' AND COLUMN_NAME = 'profit')
BEGIN
    PRINT '  ❌ MISSING: profit'
    SET @missingColumns = @missingColumns + 1
END

IF @missingColumns = 0
BEGIN
    PRINT '  ✅ All required columns exist!'
    PRINT ''
    PRINT '====================================================='
    PRINT '✅ SUCCESS - pharmacy_sales_items is ready!'
    PRINT '====================================================='
END
ELSE
BEGIN
    PRINT ''
    PRINT '  ⚠️  WARNING: ' + CAST(@missingColumns AS VARCHAR) + ' required columns are missing'
    PRINT '  You may need to add them manually or run pharmacy_pos_database.sql'
    PRINT ''
    PRINT '====================================================='
    PRINT '⚠️  INCOMPLETE - Some columns missing'
    PRINT '====================================================='
END

PRINT ''
PRINT 'Current table structure:'
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'pharmacy_sales_items'
ORDER BY ORDINAL_POSITION;

PRINT ''
PRINT '====================================================='
PRINT 'SCRIPT COMPLETE'
PRINT '====================================================='
