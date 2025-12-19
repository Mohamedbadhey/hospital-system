-- =====================================================
-- FIX PHARMACY_SALES TABLE - Add sale_id column
-- =====================================================
USE [juba_clinick]
GO

PRINT '====================================================='
PRINT 'FIXING PHARMACY_SALES TABLE'
PRINT '====================================================='
PRINT ''

-- Check if table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'pharmacy_sales')
BEGIN
    PRINT '❌ ERROR: pharmacy_sales table does not exist!'
    RETURN
END

PRINT '✅ Table pharmacy_sales exists'
PRINT ''

-- Check current columns
PRINT 'Current columns in pharmacy_sales:'
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'pharmacy_sales'
ORDER BY ORDINAL_POSITION;

PRINT ''
PRINT 'Checking for sale_id column...'
PRINT ''

-- Add sale_id column if it doesn't exist
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales' AND COLUMN_NAME = 'saleid')
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales' AND COLUMN_NAME = 'sale_id')
    BEGIN
        PRINT '  Adding sale_id column and copying data from saleid...'
        ALTER TABLE pharmacy_sales ADD sale_id INT NULL;
        EXEC('UPDATE pharmacy_sales SET sale_id = saleid');
        PRINT '  ✅ sale_id column added'
    END
    ELSE
        PRINT '  ✅ sale_id column already exists'
END
ELSE IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'pharmacy_sales' AND COLUMN_NAME = 'sale_id')
BEGIN
    PRINT '  Adding sale_id column...'
    ALTER TABLE pharmacy_sales ADD sale_id INT NULL;
    PRINT '  ✅ sale_id column added'
END
ELSE
    PRINT '  ✅ sale_id column already exists'

PRINT ''
PRINT 'Final table structure:'
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'pharmacy_sales'
ORDER BY ORDINAL_POSITION;

PRINT ''
PRINT '====================================================='
PRINT '✅ PHARMACY_SALES TABLE READY'
PRINT '====================================================='
