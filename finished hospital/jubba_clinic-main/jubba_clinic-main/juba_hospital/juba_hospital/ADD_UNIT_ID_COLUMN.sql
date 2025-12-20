-- ========================================
-- SIMPLE FIX: Add unit_id column to medicine table
-- Based on your actual database structure
-- ========================================

USE [juba_clinick]
GO

PRINT '========================================';
PRINT 'Adding unit_id column to medicine table';
PRINT '========================================';
PRINT '';

-- Check if unit_id column already exists
IF NOT EXISTS (SELECT * FROM sys.columns 
               WHERE object_id = OBJECT_ID('medicine') 
               AND name = 'unit_id')
BEGIN
    PRINT 'Adding unit_id column...';
    
    -- Add the column
    ALTER TABLE [dbo].[medicine] 
    ADD [unit_id] INT NULL;
    
    PRINT '✓ unit_id column added successfully!';
    PRINT '';
    
    -- Update existing medicines to match their unit names
    PRINT 'Updating existing medicines...';
    
    -- Match medicine.unit (text) with medicine_units.unit_name
    UPDATE m
    SET m.unit_id = mu.unit_id
    FROM medicine m
    INNER JOIN medicine_units mu ON LOWER(LTRIM(RTRIM(m.unit))) = LOWER(mu.unit_name)
    WHERE m.unit_id IS NULL;
    
    DECLARE @matchedCount INT = @@ROWCOUNT;
    PRINT '✓ Matched ' + CAST(@matchedCount AS VARCHAR) + ' medicines with unit types';
    
    -- Set remaining NULL unit_id to Tablet (unit_id = 1)
    UPDATE medicine 
    SET unit_id = 1 
    WHERE unit_id IS NULL;
    
    DECLARE @defaultCount INT = @@ROWCOUNT;
    PRINT '✓ Set ' + CAST(@defaultCount AS VARCHAR) + ' medicines to default unit (Tablet)';
    PRINT '';
END
ELSE
BEGIN
    PRINT '✓ unit_id column already exists!';
    PRINT '';
END

-- Verification
PRINT '========================================';
PRINT 'VERIFICATION REPORT';
PRINT '========================================';

DECLARE @totalMedicines INT;
DECLARE @medicinesWithUnits INT;

SELECT @totalMedicines = COUNT(*) FROM medicine;
SELECT @medicinesWithUnits = COUNT(*) FROM medicine WHERE unit_id IS NOT NULL;

PRINT 'Total medicines: ' + CAST(@totalMedicines AS VARCHAR);
PRINT 'Medicines with unit_id: ' + CAST(@medicinesWithUnits AS VARCHAR);

IF @totalMedicines > 0
BEGIN
    PRINT '';
    PRINT 'Sample medicines with units:';
    SELECT TOP 5 
        medicineid,
        medicine_name,
        unit AS old_unit_text,
        unit_id,
        mu.unit_name AS new_unit_name
    FROM medicine m
    LEFT JOIN medicine_units mu ON m.unit_id = mu.unit_id
    ORDER BY medicineid;
END

PRINT '';
PRINT '========================================';
PRINT '✓✓✓ DONE! ✓✓✓';
PRINT '========================================';
PRINT '';
PRINT 'Next step: Fix pharmacy_pos.aspx in Visual Studio';
PRINT 'See START_HERE_FIX_GUIDE.md for instructions';
PRINT '';
