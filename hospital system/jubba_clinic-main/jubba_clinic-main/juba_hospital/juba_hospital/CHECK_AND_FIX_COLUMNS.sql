-- ========================================
-- CHECK IF COLUMNS WERE ADDED
-- ========================================

USE [juba_clinick]
GO

PRINT '========================================';
PRINT 'CHECKING MEDICINE_INVENTORY COLUMNS';
PRINT '========================================';
PRINT '';

-- Check for the 3 critical columns
SELECT 
    CASE WHEN EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'primary_quantity') 
        THEN 'YES' ELSE 'NO' END AS primary_quantity_exists,
    CASE WHEN EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'secondary_quantity') 
        THEN 'YES' ELSE 'NO' END AS secondary_quantity_exists,
    CASE WHEN EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'unit_size') 
        THEN 'YES' ELSE 'NO' END AS unit_size_exists;

-- If any are missing, add them
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'primary_quantity')
BEGIN
    PRINT 'Adding primary_quantity...';
    ALTER TABLE medicine_inventory ADD primary_quantity INT NULL;
    UPDATE medicine_inventory SET primary_quantity = ISNULL(total_strips, 0);
END

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'secondary_quantity')
BEGIN
    PRINT 'Adding secondary_quantity...';
    ALTER TABLE medicine_inventory ADD secondary_quantity FLOAT NULL;
    UPDATE medicine_inventory SET secondary_quantity = ISNULL(loose_tablets, 0);
END

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'unit_size')
BEGIN
    PRINT 'Adding unit_size...';
    ALTER TABLE medicine_inventory ADD unit_size FLOAT NULL;
    UPDATE medicine_inventory SET unit_size = 10;
END

PRINT '';
PRINT 'Final check:';
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'medicine_inventory'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '✓ All columns should be ready now!';
