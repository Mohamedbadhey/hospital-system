-- ========================================
-- CHECK DATABASE STATUS
-- Let's see what's actually in your database
-- ========================================

USE [juba_clinick]
GO

PRINT '========================================';
PRINT 'DATABASE STATUS CHECK';
PRINT '========================================';
PRINT '';

-- Check medicine_units table structure
PRINT '1. MEDICINE_UNITS TABLE STRUCTURE:';
PRINT '----------------------------------------';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'medicine_units'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '2. MEDICINE_UNITS DATA:';
PRINT '----------------------------------------';
SELECT * FROM medicine_units;

PRINT '';
PRINT '3. MEDICINE TABLE - UNIT_ID STATUS:';
PRINT '----------------------------------------';
SELECT 
    COUNT(*) AS total_medicines,
    COUNT(unit_id) AS medicines_with_unit_id,
    COUNT(*) - COUNT(unit_id) AS medicines_without_unit_id
FROM medicine;

PRINT '';
PRINT '4. SAMPLE MEDICINES:';
PRINT '----------------------------------------';
SELECT TOP 5
    medicineid,
    medicine_name,
    unit AS old_unit_text,
    unit_id,
    price_per_strip
FROM medicine;

PRINT '';
PRINT '5. MEDICINE_INVENTORY TABLE CHECK:';
PRINT '----------------------------------------';
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine_inventory')
BEGIN
    SELECT 
        COLUMN_NAME,
        DATA_TYPE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'medicine_inventory'
    ORDER BY ORDINAL_POSITION;
    
    PRINT '';
    SELECT TOP 3 * FROM medicine_inventory;
END
ELSE
BEGIN
    PRINT '⚠ medicine_inventory table does not exist';
END

PRINT '';
PRINT '========================================';
PRINT 'DIAGNOSTIC COMPLETE';
PRINT '========================================';
