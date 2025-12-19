-- ========================================
-- SHOW ACTUAL DATABASE DATA
-- ========================================

USE [juba_clinick]
GO

-- 1. Show medicine_units columns
PRINT 'MEDICINE_UNITS COLUMNS:';
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'medicine_units'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT 'MEDICINE_UNITS DATA (First 5):';
SELECT TOP 5 * FROM medicine_units;

PRINT '';
PRINT 'ALL MEDICINE_UNITS (ALL 23 ROWS):';
SELECT * FROM medicine_units ORDER BY unit_id;

PRINT '';
PRINT 'MEDICINE COUNT:';
SELECT COUNT(*) AS TotalMedicines FROM medicine;

PRINT '';
PRINT 'MEDICINES WITH NULL unit_id:';
SELECT COUNT(*) AS MedicinesWithoutUnitId FROM medicine WHERE unit_id IS NULL;

PRINT '';
PRINT 'MEDICINE_INVENTORY COLUMNS:';
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'medicine_inventory'
ORDER BY ORDINAL_POSITION;

-- Most important check: Do the new columns exist?
PRINT '';
PRINT 'CRITICAL CHECK - Do these columns exist?';
SELECT 
    CASE WHEN EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('medicine_units') AND name = 'selling_method') 
        THEN 'YES' ELSE 'NO' END AS selling_method_exists,
    CASE WHEN EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('medicine_units') AND name = 'base_unit_name') 
        THEN 'YES' ELSE 'NO' END AS base_unit_name_exists,
    CASE WHEN EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('medicine_units') AND name = 'subdivision_unit') 
        THEN 'YES' ELSE 'NO' END AS subdivision_unit_exists,
    CASE WHEN EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('medicine_units') AND name = 'allows_subdivision') 
        THEN 'YES' ELSE 'NO' END AS allows_subdivision_exists;
