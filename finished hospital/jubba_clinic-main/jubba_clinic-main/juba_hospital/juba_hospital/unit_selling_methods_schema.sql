-- ============================================
-- Unit-Specific Selling Methods Schema
-- Adds flexible selling configurations for each unit type
-- ============================================

USE [juba_clinick]
GO

PRINT '============================================';
PRINT 'Starting Unit-Specific Selling Methods Update';
PRINT '============================================';
GO

-- ============================================
-- 1. Add selling configuration columns to medicine_units
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_units') AND name = 'selling_method')
BEGIN
    ALTER TABLE [dbo].[medicine_units]
    ADD [selling_method] VARCHAR(50) NULL,           -- 'countable', 'volume', 'weight'
        [base_unit_name] VARCHAR(20) NULL,           -- 'piece', 'bottle', 'vial', 'ml'
        [subdivision_unit] VARCHAR(20) NULL,         -- 'strip', 'box', 'ml', NULL
        [allows_subdivision] BIT DEFAULT 0,
        [unit_size_label] VARCHAR(50) NULL;          -- e.g., 'pieces per strip', 'ml per bottle'

    PRINT 'Selling configuration columns added to medicine_units table.';
END
ELSE
BEGIN
    PRINT 'Selling configuration columns already exist in medicine_units table.';
END
GO

-- ============================================
-- 2. Configure each unit type with appropriate selling methods
-- ============================================

-- Tablets/Capsules (countable with subdivisions)
UPDATE [dbo].[medicine_units] SET 
    selling_method = 'countable',
    base_unit_name = 'piece',
    subdivision_unit = 'strip',
    allows_subdivision = 1,
    unit_size_label = 'pieces per strip'
WHERE unit_name IN ('Tablet', 'Capsule');

PRINT 'Configured Tablet and Capsule units.';
GO

-- Bottles/Syrup (volume-based)
UPDATE [dbo].[medicine_units] SET 
    selling_method = 'volume',
    base_unit_name = 'bottle',
    subdivision_unit = 'ml',
    allows_subdivision = 1,
    unit_size_label = 'ml per bottle'
WHERE unit_name IN ('Bottle', 'Syrup');

PRINT 'Configured Bottle and Syrup units.';
GO

-- Injections (countable, no subdivision)
UPDATE [dbo].[medicine_units] SET 
    selling_method = 'countable',
    base_unit_name = 'vial',
    subdivision_unit = NULL,
    allows_subdivision = 0,
    unit_size_label = 'mg per vial'
WHERE unit_name = 'Injection';

PRINT 'Configured Injection units.';
GO

-- Drops (volume-based)
UPDATE [dbo].[medicine_units] SET 
    selling_method = 'volume',
    base_unit_name = 'bottle',
    subdivision_unit = 'ml',
    allows_subdivision = 1,
    unit_size_label = 'ml per bottle'
WHERE unit_name = 'Drops';

PRINT 'Configured Drops units.';
GO

-- Creams/Ointments/Gels (countable containers)
UPDATE [dbo].[medicine_units] SET 
    selling_method = 'countable',
    base_unit_name = 'tube',
    subdivision_unit = NULL,
    allows_subdivision = 0,
    unit_size_label = 'grams per tube'
WHERE unit_name IN ('Cream', 'Ointment', 'Gel');

PRINT 'Configured Cream, Ointment, and Gel units.';
GO

-- Inhalers (countable)
UPDATE [dbo].[medicine_units] SET 
    selling_method = 'countable',
    base_unit_name = 'inhaler',
    subdivision_unit = NULL,
    allows_subdivision = 0,
    unit_size_label = 'doses per inhaler'
WHERE unit_name = 'Inhaler';

PRINT 'Configured Inhaler units.';
GO

-- Powders/Sachets (countable)
UPDATE [dbo].[medicine_units] SET 
    selling_method = 'countable',
    base_unit_name = 'sachet',
    subdivision_unit = NULL,
    allows_subdivision = 0,
    unit_size_label = 'grams per sachet'
WHERE unit_name IN ('Powder', 'Sachet');

PRINT 'Configured Powder and Sachet units.';
GO

-- Suppositories/Patches (countable)
UPDATE [dbo].[medicine_units] SET 
    selling_method = 'countable',
    base_unit_name = 'piece',
    subdivision_unit = NULL,
    allows_subdivision = 0,
    unit_size_label = 'pieces'
WHERE unit_name IN ('Suppository', 'Patch');

PRINT 'Configured Suppository and Patch units.';
GO

-- Sprays (countable)
UPDATE [dbo].[medicine_units] SET 
    selling_method = 'countable',
    base_unit_name = 'bottle',
    subdivision_unit = NULL,
    allows_subdivision = 0,
    unit_size_label = 'ml per bottle'
WHERE unit_name = 'Spray';

PRINT 'Configured Spray units.';
GO

-- ============================================
-- 3. Add flexible storage columns to medicine_inventory
-- ============================================
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'primary_quantity')
BEGIN
    ALTER TABLE [dbo].[medicine_inventory]
    ADD [primary_quantity] INT DEFAULT 0,           -- Main containers (bottles, vials, boxes, etc.)
        [secondary_quantity] FLOAT DEFAULT 0,       -- Loose items (ml, tablets, etc.)
        [unit_size] FLOAT DEFAULT 0,                -- Size of each primary unit
        [unit_size_measure] VARCHAR(10) NULL;       -- 'ml', 'mg', 'pieces', etc.

    PRINT 'Flexible storage columns added to medicine_inventory table.';
END
ELSE
BEGIN
    PRINT 'Flexible storage columns already exist in medicine_inventory table.';
END
GO

-- ============================================
-- 4. Migrate existing inventory data
-- ============================================
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'primary_quantity')
AND EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'total_strips')
BEGIN
    -- Migrate existing strip-based inventory to flexible format
    UPDATE mi
    SET 
        mi.primary_quantity = ISNULL(mi.total_strips, 0),
        mi.secondary_quantity = ISNULL(mi.loose_tablets, 0),
        mi.unit_size = ISNULL(m.tablets_per_strip, 10),
        mi.unit_size_measure = 'pieces'
    FROM [dbo].[medicine_inventory] mi
    INNER JOIN [dbo].[medicine] m ON mi.medicineid = m.medicineid
    WHERE mi.primary_quantity = 0 AND mi.total_strips > 0;

    PRINT 'Existing inventory data migrated to flexible format.';
END
GO

-- ============================================
-- 5. Verification
-- ============================================
PRINT '============================================';
PRINT 'Verification:';
SELECT 
    unit_name,
    selling_method,
    base_unit_name,
    subdivision_unit,
    allows_subdivision,
    unit_size_label
FROM medicine_units
ORDER BY unit_name;

PRINT '============================================';
PRINT 'Unit-Specific Selling Methods Update Complete!';
PRINT '============================================';
PRINT 'Next steps:';
PRINT '1. Update medicine units management UI';
PRINT '2. Update POS system for dynamic selling options';
PRINT '3. Update inventory management';
PRINT '4. Test with different unit types';
PRINT '============================================';
