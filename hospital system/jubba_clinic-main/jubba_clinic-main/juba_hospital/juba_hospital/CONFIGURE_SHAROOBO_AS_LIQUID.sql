-- ========================================
-- CONFIGURE SHAROOBO AS LIQUID (like syrup)
-- ========================================

USE [juba_clinick]
GO

PRINT 'Configuring sharoobo as liquid medicine (like syrup)...';

UPDATE medicine_units
SET 
    selling_method = 'volume',           -- Changed from 'countable' to 'volume'
    base_unit_name = 'ml',               -- Smallest unit is milliliters
    subdivision_unit = 'bottle',         -- Container is bottle
    allows_subdivision = 1,              -- Can sell by ml OR by bottle
    unit_size_label = 'ml per bottle'    -- Label for size field
WHERE unit_name = 'sharoobo';

PRINT '✓ Sharoobo configured as liquid medicine';
PRINT '';

-- Verify
SELECT 
    unit_name,
    selling_method,
    base_unit_name,
    subdivision_unit,
    allows_subdivision,
    unit_size_label
FROM medicine_units 
WHERE unit_name = 'sharoobo';

PRINT '';
PRINT '========================================';
PRINT 'CONFIGURATION COMPLETE!';
PRINT '========================================';
PRINT '';
PRINT 'Now sharoobo works like syrup:';
PRINT '  - Measured in ml';
PRINT '  - Sold by ml or by bottle';
PRINT '  - Price per ml AND price per bottle';
PRINT '';
PRINT 'Next: Refresh Add Medicine page and test!';
PRINT '';
