-- ========================================
-- FIX SHAROOBO UNIT CONFIGURATION
-- ========================================

USE [juba_clinick]
GO

PRINT 'Fixing sharoobo unit configuration...';

UPDATE medicine_units
SET 
    selling_method = 'countable',
    base_unit_name = 'sharoobo',
    subdivision_unit = NULL,
    allows_subdivision = 0,
    unit_size_label = 'pieces per sharoobo'
WHERE unit_name = 'sharoobo';

PRINT '✓ Updated sharoobo unit';

-- Verify
SELECT * FROM medicine_units WHERE unit_name = 'sharoobo';

PRINT '';
PRINT '✓ Done! Now refresh your Add Medicine page and test.';
