-- ========================================
-- COMPLETE FIX SCRIPT FOR UNIT-BASED SELLING
-- This adds ALL missing columns and data
-- ========================================

USE [juba_clinick]
GO

PRINT '========================================';
PRINT 'UNIT-BASED SELLING - COMPLETE SETUP';
PRINT '========================================';
PRINT '';

-- ========================================
-- STEP 1: Check and create medicine_units table
-- ========================================
PRINT 'Step 1: Checking medicine_units table...';

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine_units')
BEGIN
    PRINT 'Creating medicine_units table...';
    
    CREATE TABLE medicine_units (
        unit_id INT IDENTITY(1,1) PRIMARY KEY,
        unit_name VARCHAR(50) NOT NULL,
        unit_abbreviation VARCHAR(10),
        selling_method VARCHAR(50) DEFAULT 'countable',
        base_unit_name VARCHAR(20) DEFAULT 'piece',
        subdivision_unit VARCHAR(20) NULL,
        allows_subdivision BIT DEFAULT 1,
        unit_size_label VARCHAR(50) DEFAULT 'pieces per strip',
        created_date DATETIME DEFAULT GETDATE()
    );
    
    PRINT '✓ medicine_units table created';
END
ELSE
BEGIN
    PRINT '✓ medicine_units table exists';
    
    -- Add missing columns if they don't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_units') AND name = 'selling_method')
    BEGIN
        PRINT 'Adding selling_method column...';
        ALTER TABLE medicine_units ADD selling_method VARCHAR(50) DEFAULT 'countable';
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_units') AND name = 'base_unit_name')
    BEGIN
        PRINT 'Adding base_unit_name column...';
        ALTER TABLE medicine_units ADD base_unit_name VARCHAR(20) DEFAULT 'piece';
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_units') AND name = 'subdivision_unit')
    BEGIN
        PRINT 'Adding subdivision_unit column...';
        ALTER TABLE medicine_units ADD subdivision_unit VARCHAR(20) NULL;
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_units') AND name = 'allows_subdivision')
    BEGIN
        PRINT 'Adding allows_subdivision column...';
        ALTER TABLE medicine_units ADD allows_subdivision BIT DEFAULT 1;
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_units') AND name = 'unit_size_label')
    BEGIN
        PRINT 'Adding unit_size_label column...';
        ALTER TABLE medicine_units ADD unit_size_label VARCHAR(50) DEFAULT 'pieces per strip';
    END
    
    PRINT '✓ All medicine_units columns verified';
END

PRINT '';

-- ========================================
-- STEP 2: Check and update medicine table
-- ========================================
PRINT 'Step 2: Checking medicine table...';

-- Add unit_id column to medicine table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'unit_id')
BEGIN
    PRINT 'Adding unit_id column to medicine table...';
    ALTER TABLE medicine ADD unit_id INT NULL;
    PRINT '✓ unit_id column added to medicine table';
END
ELSE
BEGIN
    PRINT '✓ medicine table already has unit_id column';
END

-- Add other missing columns to medicine table if needed
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'tablets_per_strip')
BEGIN
    PRINT 'Adding tablets_per_strip column...';
    ALTER TABLE medicine ADD tablets_per_strip INT DEFAULT 10;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'strips_per_box')
BEGIN
    PRINT 'Adding strips_per_box column...';
    ALTER TABLE medicine ADD strips_per_box INT DEFAULT 10;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'price_per_tablet')
BEGIN
    PRINT 'Adding price_per_tablet column...';
    ALTER TABLE medicine ADD price_per_tablet FLOAT DEFAULT 0;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'price_per_strip')
BEGIN
    PRINT 'Adding price_per_strip column...';
    ALTER TABLE medicine ADD price_per_strip FLOAT DEFAULT 0;
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine') AND name = 'price_per_box')
BEGIN
    PRINT 'Adding price_per_box column...';
    ALTER TABLE medicine ADD price_per_box FLOAT DEFAULT 0;
END

PRINT '✓ All medicine columns verified';
PRINT '';

-- ========================================
-- STEP 3: Check and update medicine_inventory table
-- ========================================
PRINT 'Step 3: Checking medicine_inventory table...';

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'medicine_inventory')
BEGIN
    -- Add flexible storage columns
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'primary_quantity')
    BEGIN
        PRINT 'Adding primary_quantity column...';
        ALTER TABLE medicine_inventory ADD primary_quantity INT DEFAULT 0;
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'secondary_quantity')
    BEGIN
        PRINT 'Adding secondary_quantity column...';
        ALTER TABLE medicine_inventory ADD secondary_quantity FLOAT DEFAULT 0;
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'unit_size')
    BEGIN
        PRINT 'Adding unit_size column...';
        ALTER TABLE medicine_inventory ADD unit_size FLOAT DEFAULT 10;
    END
    
    -- Migrate existing data if total_strips and loose_tablets exist
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'total_strips')
       AND EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'loose_tablets')
    BEGIN
        PRINT 'Migrating existing inventory data...';
        UPDATE medicine_inventory 
        SET primary_quantity = ISNULL(total_strips, 0),
            secondary_quantity = ISNULL(loose_tablets, 0),
            unit_size = 10
        WHERE primary_quantity = 0 OR primary_quantity IS NULL;
        PRINT '✓ Inventory data migrated';
    END
    
    PRINT '✓ medicine_inventory columns verified';
END
ELSE
BEGIN
    PRINT '⚠ medicine_inventory table does not exist (will need to be created separately)';
END

PRINT '';

-- ========================================
-- STEP 4: Insert 15 unit types
-- ========================================
PRINT 'Step 4: Setting up unit types...';

DECLARE @unitCount INT;
SELECT @unitCount = COUNT(*) FROM medicine_units;
PRINT 'Current unit types: ' + CAST(@unitCount AS VARCHAR);

-- Clear and re-insert if less than 15
IF @unitCount < 15
BEGIN
    PRINT 'Inserting all 15 unit types...';
    
    -- Clear existing to avoid duplicates (only if very few exist)
    IF @unitCount <= 2
    BEGIN
        DELETE FROM medicine_units;
        PRINT 'Cleared existing units';
    END
    
    -- Insert Tablet
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Tablet')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Tablet', 'Tab', 'countable', 'piece', 'strip', 1, 'pieces per strip');
    
    -- Insert Capsule
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Capsule')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Capsule', 'Cap', 'countable', 'piece', 'strip', 1, 'pieces per strip');
    
    -- Insert Syrup
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Syrup')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Syrup', 'Syr', 'volume', 'ml', 'bottle', 1, 'ml per bottle');
    
    -- Insert Bottle
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Bottle')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Bottle', 'Btl', 'volume', 'ml', 'bottle', 1, 'ml per bottle');
    
    -- Insert Injection
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Injection')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Injection', 'Inj', 'countable', 'vial', NULL, 0, 'ml per vial');
    
    -- Insert Drops
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Drops')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Drops', 'Drp', 'volume', 'ml', 'bottle', 1, 'ml per bottle');
    
    -- Insert Cream
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Cream')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Cream', 'Crm', 'countable', 'tube', NULL, 0, 'grams per tube');
    
    -- Insert Ointment
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Ointment')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Ointment', 'Oint', 'countable', 'tube', NULL, 0, 'grams per tube');
    
    -- Insert Gel
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Gel')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Gel', 'Gel', 'countable', 'tube', NULL, 0, 'grams per tube');
    
    -- Insert Inhaler
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Inhaler')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Inhaler', 'Inh', 'countable', 'inhaler', NULL, 0, 'doses per inhaler');
    
    -- Insert Powder
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Powder')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Powder', 'Pwd', 'countable', 'sachet', NULL, 0, 'grams per sachet');
    
    -- Insert Sachet
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Sachet')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Sachet', 'Sach', 'countable', 'sachet', NULL, 0, 'grams per sachet');
    
    -- Insert Suppository
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Suppository')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Suppository', 'Supp', 'countable', 'piece', NULL, 0, 'suppositories');
    
    -- Insert Patch
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Patch')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Patch', 'Ptch', 'countable', 'piece', NULL, 0, 'patches');
    
    -- Insert Spray
    IF NOT EXISTS (SELECT 1 FROM medicine_units WHERE unit_name = 'Spray')
        INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label)
        VALUES ('Spray', 'Spry', 'countable', 'bottle', NULL, 0, 'ml per bottle');
    
    PRINT '✓ All 15 unit types inserted';
END
ELSE
BEGIN
    PRINT '✓ All unit types already exist';
END

PRINT '';

-- ========================================
-- STEP 5: Update existing medicines
-- ========================================
PRINT 'Step 5: Updating existing medicines...';

-- Get Tablet unit_id
DECLARE @tabletUnitId INT;
SELECT @tabletUnitId = unit_id FROM medicine_units WHERE unit_name = 'Tablet';

IF @tabletUnitId IS NOT NULL
BEGIN
    -- Update medicines without unit_id
    DECLARE @medicinesUpdated INT;
    UPDATE medicine 
    SET unit_id = @tabletUnitId 
    WHERE unit_id IS NULL OR unit_id = 0 OR unit_id NOT IN (SELECT unit_id FROM medicine_units);
    
    SELECT @medicinesUpdated = @@ROWCOUNT;
    PRINT '✓ Updated ' + CAST(@medicinesUpdated AS VARCHAR) + ' medicines to use Tablet as default unit';
END
ELSE
BEGIN
    PRINT '⚠ Could not find Tablet unit to set as default';
END

PRINT '';

-- ========================================
-- STEP 6: Verification Report
-- ========================================
PRINT '========================================';
PRINT 'VERIFICATION REPORT';
PRINT '========================================';

-- Unit types count
SELECT @unitCount = COUNT(*) FROM medicine_units;
PRINT 'Total unit types: ' + CAST(@unitCount AS VARCHAR);

-- Medicine count
DECLARE @medicineCount INT;
SELECT @medicineCount = COUNT(*) FROM medicine;
PRINT 'Total medicines: ' + CAST(@medicineCount AS VARCHAR);

-- Medicines with valid units
DECLARE @medicinesWithUnits INT;
SELECT @medicinesWithUnits = COUNT(*) 
FROM medicine 
WHERE unit_id IS NOT NULL 
  AND unit_id > 0 
  AND unit_id IN (SELECT unit_id FROM medicine_units);
PRINT 'Medicines with valid units: ' + CAST(@medicinesWithUnits AS VARCHAR);

PRINT '';
PRINT '========================================';
PRINT 'ALL 15 UNIT TYPES:';
PRINT '========================================';

SELECT 
    unit_id as [ID],
    unit_name as [Unit],
    unit_abbreviation as [Abbr],
    selling_method as [Method],
    base_unit_name as [Base Unit],
    ISNULL(subdivision_unit, 'N/A') as [Subdivision],
    CASE WHEN allows_subdivision = 1 THEN 'Yes' ELSE 'No' END as [Can Subdivide]
FROM medicine_units
ORDER BY unit_name;

PRINT '';
PRINT '========================================';
PRINT '✓✓✓ SETUP COMPLETE! ✓✓✓';
PRINT '========================================';
PRINT '';
PRINT 'Next steps:';
PRINT '1. In Visual Studio: Fix pharmacy_pos.aspx (remove duplicate content)';
PRINT '2. Copy content from pharmacy_pos_CLEAN.aspx';
PRINT '3. Build solution (Ctrl+Shift+B)';
PRINT '4. Run and test!';
PRINT '';
PRINT 'See START_HERE_FIX_GUIDE.md for detailed instructions';
PRINT '========================================';
