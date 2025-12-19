-- ========================================
-- ADD ALL MISSING COLUMNS TO MEDICINE_INVENTORY
-- Based on your actual table structure
-- ========================================

USE [juba_clinick]
GO

PRINT '========================================';
PRINT 'ADDING MISSING COLUMNS TO MEDICINE_INVENTORY';
PRINT '========================================';
PRINT '';

PRINT 'Current medicine_inventory structure:';
PRINT 'inventoryid, medicineid, total_strips, loose_tablets, total_boxes,';
PRINT 'reorder_level_strips, expiry_date, batch_number, purchase_price,';
PRINT 'date_added, last_updated';
PRINT '';

-- Add primary_quantity (for strips, bottles, vials, etc.)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'primary_quantity')
BEGIN
    PRINT 'Adding primary_quantity column...';
    ALTER TABLE medicine_inventory ADD primary_quantity INT NULL;
    
    -- Migrate existing data from total_strips
    UPDATE medicine_inventory 
    SET primary_quantity = ISNULL(total_strips, 0);
    
    PRINT '  ✓ Added and synced with total_strips';
END
ELSE
BEGIN
    PRINT '✓ primary_quantity already exists';
END

-- Add secondary_quantity (for loose pieces, ml, etc.)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'secondary_quantity')
BEGIN
    PRINT 'Adding secondary_quantity column...';
    ALTER TABLE medicine_inventory ADD secondary_quantity FLOAT NULL;
    
    -- Migrate existing data from loose_tablets
    UPDATE medicine_inventory 
    SET secondary_quantity = ISNULL(loose_tablets, 0);
    
    PRINT '  ✓ Added and synced with loose_tablets';
END
ELSE
BEGIN
    PRINT '✓ secondary_quantity already exists';
END

-- Add unit_size (pieces per strip, ml per bottle, etc.)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'unit_size')
BEGIN
    PRINT 'Adding unit_size column...';
    ALTER TABLE medicine_inventory ADD unit_size FLOAT NULL;
    
    -- Set default to 10 (common tablets per strip)
    UPDATE medicine_inventory 
    SET unit_size = 10
    WHERE unit_size IS NULL;
    
    PRINT '  ✓ Added with default value of 10';
END
ELSE
BEGIN
    PRINT '✓ unit_size already exists';
END

-- Ensure purchase_price exists (you already have it, but let's check)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('medicine_inventory') AND name = 'purchase_price')
BEGIN
    PRINT 'Adding purchase_price column...';
    ALTER TABLE medicine_inventory ADD purchase_price FLOAT NULL;
    PRINT '  ✓ Added';
END
ELSE
BEGIN
    PRINT '✓ purchase_price already exists';
END

PRINT '';
PRINT '========================================';
PRINT 'SETTING UP SYNC BETWEEN OLD AND NEW COLUMNS';
PRINT '========================================';
PRINT '';

-- Create triggers to keep old and new columns in sync
-- This ensures backward compatibility

-- Drop existing triggers if they exist
IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_sync_inventory_insert')
    DROP TRIGGER trg_sync_inventory_insert;

IF EXISTS (SELECT * FROM sys.triggers WHERE name = 'trg_sync_inventory_update')
    DROP TRIGGER trg_sync_inventory_update;

PRINT 'Creating triggers to sync old and new columns...';

-- Trigger for INSERT
CREATE TRIGGER trg_sync_inventory_insert
ON medicine_inventory
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Sync new columns from old columns if new columns are NULL
    UPDATE mi
    SET 
        mi.primary_quantity = CASE 
            WHEN mi.primary_quantity IS NULL THEN ISNULL(i.total_strips, 0)
            ELSE mi.primary_quantity
        END,
        mi.secondary_quantity = CASE 
            WHEN mi.secondary_quantity IS NULL THEN ISNULL(i.loose_tablets, 0)
            ELSE mi.secondary_quantity
        END,
        mi.unit_size = CASE 
            WHEN mi.unit_size IS NULL THEN 10
            ELSE mi.unit_size
        END
    FROM medicine_inventory mi
    INNER JOIN inserted i ON mi.inventoryid = i.inventoryid;
    
    -- Sync old columns from new columns
    UPDATE mi
    SET 
        mi.total_strips = mi.primary_quantity,
        mi.loose_tablets = mi.secondary_quantity
    FROM medicine_inventory mi
    INNER JOIN inserted i ON mi.inventoryid = i.inventoryid;
END;
GO

PRINT '  ✓ Insert trigger created';

-- Trigger for UPDATE
CREATE TRIGGER trg_sync_inventory_update
ON medicine_inventory
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- If old columns (total_strips, loose_tablets) are updated, sync to new columns
    IF UPDATE(total_strips) OR UPDATE(loose_tablets)
    BEGIN
        UPDATE mi
        SET 
            mi.primary_quantity = ISNULL(i.total_strips, mi.primary_quantity),
            mi.secondary_quantity = ISNULL(i.loose_tablets, mi.secondary_quantity)
        FROM medicine_inventory mi
        INNER JOIN inserted i ON mi.inventoryid = i.inventoryid;
    END
    
    -- If new columns (primary_quantity, secondary_quantity) are updated, sync to old columns
    IF UPDATE(primary_quantity) OR UPDATE(secondary_quantity)
    BEGIN
        UPDATE mi
        SET 
            mi.total_strips = ISNULL(i.primary_quantity, mi.total_strips),
            mi.loose_tablets = ISNULL(i.secondary_quantity, mi.loose_tablets)
        FROM medicine_inventory mi
        INNER JOIN inserted i ON mi.inventoryid = i.inventoryid;
    END
END;
GO

PRINT '  ✓ Update trigger created';
PRINT '';

PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';
PRINT '';

-- Show all columns
PRINT 'All columns in medicine_inventory:';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'medicine_inventory'
ORDER BY ORDINAL_POSITION;

-- Count records
DECLARE @recordCount INT;
SELECT @recordCount = COUNT(*) FROM medicine_inventory;
PRINT '';
PRINT 'Total inventory records: ' + CAST(@recordCount AS VARCHAR);

PRINT '';
PRINT '========================================';
PRINT '✓✓✓ COMPLETE! ✓✓✓';
PRINT '========================================';
PRINT '';
PRINT 'What was done:';
PRINT '  ✓ Added primary_quantity (synced with total_strips)';
PRINT '  ✓ Added secondary_quantity (synced with loose_tablets)';
PRINT '  ✓ Added unit_size (default: 10)';
PRINT '  ✓ Created triggers to keep columns in sync';
PRINT '';
PRINT 'Now refresh the POS page in your browser!';
PRINT '';
