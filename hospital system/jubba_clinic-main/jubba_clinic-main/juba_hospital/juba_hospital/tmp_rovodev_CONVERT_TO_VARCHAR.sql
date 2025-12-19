-- Convert new test columns from nvarchar to varchar to match existing tests
-- This ensures consistency with other lab test columns

USE juba_clinick;
GO

-- ============================================================================
-- 1. Convert lab_test table columns from nvarchar to varchar
-- ============================================================================

PRINT '=== Converting lab_test columns from nvarchar to varchar ===';

-- Electrolyte_Test
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'lab_test' 
           AND COLUMN_NAME = 'Electrolyte_Test' 
           AND DATA_TYPE = 'nvarchar')
BEGIN
    ALTER TABLE lab_test ADD Electrolyte_Test_temp varchar(500);
    UPDATE lab_test SET Electrolyte_Test_temp = Electrolyte_Test;
    ALTER TABLE lab_test DROP COLUMN Electrolyte_Test;
    EXEC sp_rename 'lab_test.Electrolyte_Test_temp', 'Electrolyte_Test', 'COLUMN';
    PRINT 'Converted lab_test.Electrolyte_Test: nvarchar -> varchar(500)';
END
ELSE IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_test' AND COLUMN_NAME = 'Electrolyte_Test')
BEGIN
    ALTER TABLE lab_test ADD Electrolyte_Test varchar(500);
    PRINT 'Added lab_test.Electrolyte_Test as varchar(500)';
END
ELSE
BEGIN
    PRINT 'lab_test.Electrolyte_Test already varchar';
END
GO

-- CRP_Titer
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'lab_test' 
           AND COLUMN_NAME = 'CRP_Titer' 
           AND DATA_TYPE = 'nvarchar')
BEGIN
    ALTER TABLE lab_test ADD CRP_Titer_temp varchar(500);
    UPDATE lab_test SET CRP_Titer_temp = CRP_Titer;
    ALTER TABLE lab_test DROP COLUMN CRP_Titer;
    EXEC sp_rename 'lab_test.CRP_Titer_temp', 'CRP_Titer', 'COLUMN';
    PRINT 'Converted lab_test.CRP_Titer: nvarchar -> varchar(500)';
END
ELSE IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_test' AND COLUMN_NAME = 'CRP_Titer')
BEGIN
    ALTER TABLE lab_test ADD CRP_Titer varchar(500);
    PRINT 'Added lab_test.CRP_Titer as varchar(500)';
END
ELSE
BEGIN
    PRINT 'lab_test.CRP_Titer already varchar';
END
GO

-- Ultra
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'lab_test' 
           AND COLUMN_NAME = 'Ultra' 
           AND DATA_TYPE = 'nvarchar')
BEGIN
    ALTER TABLE lab_test ADD Ultra_temp varchar(500);
    UPDATE lab_test SET Ultra_temp = Ultra;
    ALTER TABLE lab_test DROP COLUMN Ultra;
    EXEC sp_rename 'lab_test.Ultra_temp', 'Ultra', 'COLUMN';
    PRINT 'Converted lab_test.Ultra: nvarchar -> varchar(500)';
END
ELSE IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_test' AND COLUMN_NAME = 'Ultra')
BEGIN
    ALTER TABLE lab_test ADD Ultra varchar(500);
    PRINT 'Added lab_test.Ultra as varchar(500)';
END
ELSE
BEGIN
    PRINT 'lab_test.Ultra already varchar';
END
GO

-- Typhoid_IgG
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'lab_test' 
           AND COLUMN_NAME = 'Typhoid_IgG' 
           AND DATA_TYPE = 'nvarchar')
BEGIN
    ALTER TABLE lab_test ADD Typhoid_IgG_temp varchar(500);
    UPDATE lab_test SET Typhoid_IgG_temp = Typhoid_IgG;
    ALTER TABLE lab_test DROP COLUMN Typhoid_IgG;
    EXEC sp_rename 'lab_test.Typhoid_IgG_temp', 'Typhoid_IgG', 'COLUMN';
    PRINT 'Converted lab_test.Typhoid_IgG: nvarchar -> varchar(500)';
END
ELSE IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_test' AND COLUMN_NAME = 'Typhoid_IgG')
BEGIN
    ALTER TABLE lab_test ADD Typhoid_IgG varchar(500);
    PRINT 'Added lab_test.Typhoid_IgG as varchar(500)';
END
ELSE
BEGIN
    PRINT 'lab_test.Typhoid_IgG already varchar';
END
GO

-- Typhoid_Ag
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'lab_test' 
           AND COLUMN_NAME = 'Typhoid_Ag' 
           AND DATA_TYPE = 'nvarchar')
BEGIN
    ALTER TABLE lab_test ADD Typhoid_Ag_temp varchar(500);
    UPDATE lab_test SET Typhoid_Ag_temp = Typhoid_Ag;
    ALTER TABLE lab_test DROP COLUMN Typhoid_Ag;
    EXEC sp_rename 'lab_test.Typhoid_Ag_temp', 'Typhoid_Ag', 'COLUMN';
    PRINT 'Converted lab_test.Typhoid_Ag: nvarchar -> varchar(500)';
END
ELSE IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_test' AND COLUMN_NAME = 'Typhoid_Ag')
BEGIN
    ALTER TABLE lab_test ADD Typhoid_Ag varchar(500);
    PRINT 'Added lab_test.Typhoid_Ag as varchar(500)';
END
ELSE
BEGIN
    PRINT 'lab_test.Typhoid_Ag already varchar';
END
GO

-- ============================================================================
-- 2. Convert lab_results table columns from nvarchar to varchar
-- ============================================================================

PRINT '';
PRINT '=== Converting lab_results columns from nvarchar to varchar ===';

-- Electrolyte_Test
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'lab_results' 
           AND COLUMN_NAME = 'Electrolyte_Test' 
           AND DATA_TYPE = 'nvarchar')
BEGIN
    -- Create temp column
    ALTER TABLE lab_results ADD Electrolyte_Test_temp varchar(500);
    
    -- Copy data
    UPDATE lab_results SET Electrolyte_Test_temp = Electrolyte_Test;
    
    -- Drop old column
    ALTER TABLE lab_results DROP COLUMN Electrolyte_Test;
    
    -- Rename temp column
    EXEC sp_rename 'lab_results.Electrolyte_Test_temp', 'Electrolyte_Test', 'COLUMN';
    
    PRINT 'Converted lab_results.Electrolyte_Test: nvarchar -> varchar(500)';
END
ELSE IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_results' AND COLUMN_NAME = 'Electrolyte_Test')
BEGIN
    ALTER TABLE lab_results ADD Electrolyte_Test varchar(500);
    PRINT 'Added lab_results.Electrolyte_Test as varchar(500)';
END
ELSE
BEGIN
    PRINT 'lab_results.Electrolyte_Test already varchar';
END
GO

-- CRP_Titer
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'lab_results' 
           AND COLUMN_NAME = 'CRP_Titer' 
           AND DATA_TYPE = 'nvarchar')
BEGIN
    ALTER TABLE lab_results ADD CRP_Titer_temp varchar(500);
    UPDATE lab_results SET CRP_Titer_temp = CRP_Titer;
    ALTER TABLE lab_results DROP COLUMN CRP_Titer;
    EXEC sp_rename 'lab_results.CRP_Titer_temp', 'CRP_Titer', 'COLUMN';
    PRINT 'Converted lab_results.CRP_Titer: nvarchar -> varchar(500)';
END
ELSE IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_results' AND COLUMN_NAME = 'CRP_Titer')
BEGIN
    ALTER TABLE lab_results ADD CRP_Titer varchar(500);
    PRINT 'Added lab_results.CRP_Titer as varchar(500)';
END
ELSE
BEGIN
    PRINT 'lab_results.CRP_Titer already varchar';
END
GO

-- Ultra
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'lab_results' 
           AND COLUMN_NAME = 'Ultra' 
           AND DATA_TYPE = 'nvarchar')
BEGIN
    ALTER TABLE lab_results ADD Ultra_temp varchar(500);
    UPDATE lab_results SET Ultra_temp = Ultra;
    ALTER TABLE lab_results DROP COLUMN Ultra;
    EXEC sp_rename 'lab_results.Ultra_temp', 'Ultra', 'COLUMN';
    PRINT 'Converted lab_results.Ultra: nvarchar -> varchar(500)';
END
ELSE IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_results' AND COLUMN_NAME = 'Ultra')
BEGIN
    ALTER TABLE lab_results ADD Ultra varchar(500);
    PRINT 'Added lab_results.Ultra as varchar(500)';
END
ELSE
BEGIN
    PRINT 'lab_results.Ultra already varchar';
END
GO

-- Typhoid_IgG
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'lab_results' 
           AND COLUMN_NAME = 'Typhoid_IgG' 
           AND DATA_TYPE = 'nvarchar')
BEGIN
    ALTER TABLE lab_results ADD Typhoid_IgG_temp varchar(500);
    UPDATE lab_results SET Typhoid_IgG_temp = Typhoid_IgG;
    ALTER TABLE lab_results DROP COLUMN Typhoid_IgG;
    EXEC sp_rename 'lab_results.Typhoid_IgG_temp', 'Typhoid_IgG', 'COLUMN';
    PRINT 'Converted lab_results.Typhoid_IgG: nvarchar -> varchar(500)';
END
ELSE IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_results' AND COLUMN_NAME = 'Typhoid_IgG')
BEGIN
    ALTER TABLE lab_results ADD Typhoid_IgG varchar(500);
    PRINT 'Added lab_results.Typhoid_IgG as varchar(500)';
END
ELSE
BEGIN
    PRINT 'lab_results.Typhoid_IgG already varchar';
END
GO

-- Typhoid_Ag
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
           WHERE TABLE_NAME = 'lab_results' 
           AND COLUMN_NAME = 'Typhoid_Ag' 
           AND DATA_TYPE = 'nvarchar')
BEGIN
    ALTER TABLE lab_results ADD Typhoid_Ag_temp varchar(500);
    UPDATE lab_results SET Typhoid_Ag_temp = Typhoid_Ag;
    ALTER TABLE lab_results DROP COLUMN Typhoid_Ag;
    EXEC sp_rename 'lab_results.Typhoid_Ag_temp', 'Typhoid_Ag', 'COLUMN';
    PRINT 'Converted lab_results.Typhoid_Ag: nvarchar -> varchar(500)';
END
ELSE IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'lab_results' AND COLUMN_NAME = 'Typhoid_Ag')
BEGIN
    ALTER TABLE lab_results ADD Typhoid_Ag varchar(500);
    PRINT 'Added lab_results.Typhoid_Ag as varchar(500)';
END
ELSE
BEGIN
    PRINT 'lab_results.Typhoid_Ag already varchar';
END
GO

-- ============================================================================
-- 3. Verify the changes
-- ============================================================================

PRINT '';
PRINT '=== VERIFICATION ===';
PRINT '';
PRINT '--- lab_test table (should all be varchar) ---';
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'lab_test' 
AND COLUMN_NAME IN ('Electrolyte_Test', 'CRP_Titer', 'Ultra', 'Typhoid_IgG', 'Typhoid_Ag')
ORDER BY COLUMN_NAME;

PRINT '';
PRINT '--- lab_results table (should all be varchar) ---';
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'lab_results' 
AND COLUMN_NAME IN ('Electrolyte_Test', 'CRP_Titer', 'Ultra', 'Typhoid_IgG', 'Typhoid_Ag')
ORDER BY COLUMN_NAME;

PRINT '';
PRINT '=== CONVERSION COMPLETE ===';
PRINT 'lab_test columns: varchar(500) type (matches other tests)';
PRINT 'lab_results columns: varchar(500) type (matches other tests)';
