-- ========================================
-- ADD COLUMNS ONE BY ONE (SIMPLE VERSION)
-- ========================================

USE [juba_clinick]
GO

PRINT 'Adding primary_quantity...';
ALTER TABLE medicine_inventory ADD primary_quantity INT NULL;
PRINT '✓ primary_quantity added';
GO

PRINT 'Adding secondary_quantity...';
ALTER TABLE medicine_inventory ADD secondary_quantity FLOAT NULL;
PRINT '✓ secondary_quantity added';
GO

PRINT 'Adding unit_size...';
ALTER TABLE medicine_inventory ADD unit_size FLOAT NULL;
PRINT '✓ unit_size added';
GO

PRINT 'Syncing data...';
UPDATE medicine_inventory SET primary_quantity = ISNULL(total_strips, 0);
UPDATE medicine_inventory SET secondary_quantity = ISNULL(loose_tablets, 0);
UPDATE medicine_inventory SET unit_size = 10;
PRINT '✓ Data synced';
GO

PRINT '';
PRINT 'Verification:';
SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'medicine_inventory' 
ORDER BY ORDINAL_POSITION;
GO

PRINT '';
PRINT '✓✓✓ DONE! Should show 14 columns now.';
