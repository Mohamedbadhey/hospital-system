-- ========================================
-- SIMPLIFY TO TWO CATEGORIES
-- Tablets/Capsules = Complex (box/strip/piece)
-- Everything Else = Simple (quantity only)
-- ========================================

USE [juba_clinick]
GO

PRINT '========================================';
PRINT 'SIMPLIFYING MEDICINE UNITS';
PRINT '========================================';
PRINT '';

-- Keep Tablet and Capsule as they are
PRINT 'Keeping Tablet and Capsule configurations...';

UPDATE medicine_units
SET selling_method = 'countable',
    base_unit_name = 'piece',
    subdivision_unit = 'strip',
    allows_subdivision = 1,
    unit_size_label = 'pieces per strip'
WHERE unit_name IN ('Tablet', 'Capsule');

PRINT '✓ Tablet and Capsule configured for box/strip/piece selling';
PRINT '';

-- Simplify ALL other units to just quantity-based
PRINT 'Simplifying all other units...';

UPDATE medicine_units
SET selling_method = 'countable',
    base_unit_name = 'unit',
    subdivision_unit = NULL,
    allows_subdivision = 0,
    unit_size_label = 'Units'
WHERE unit_name NOT IN ('Tablet', 'Capsule');

PRINT '✓ All other units simplified to quantity-only selling';
PRINT '';

-- Show final configuration
PRINT '========================================';
PRINT 'FINAL CONFIGURATION:';
PRINT '========================================';
PRINT '';

SELECT 
    unit_name AS [Unit Type],
    CASE 
        WHEN allows_subdivision = 1 THEN 'Box/Strip/Piece (Complex)'
        ELSE 'Quantity Only (Simple)'
    END AS [Selling Method],
    CASE 
        WHEN allows_subdivision = 1 THEN 'piece → strip → box'
        ELSE 'Direct quantity'
    END AS [Structure]
FROM medicine_units
WHERE is_active = 1
ORDER BY 
    CASE WHEN unit_name IN ('Tablet', 'Capsule') THEN 1 ELSE 2 END,
    unit_name;

PRINT '';
PRINT '========================================';
PRINT 'SUMMARY:';
PRINT '========================================';
PRINT '';
PRINT 'COMPLEX SELLING (3 options):';
PRINT '  • Tablet - Sell by piece, strip, or box';
PRINT '  • Capsule - Sell by piece, strip, or box';
PRINT '';
PRINT 'SIMPLE SELLING (quantity only):';
PRINT '  • Syrup - Sell by bottles (1, 2, 3...)';
PRINT '  • Injection - Sell by vials (1, 2, 3...)';
PRINT '  • Cream - Sell by tubes (1, 2, 3...)';
PRINT '  • Drops - Sell by bottles (1, 2, 3...)';
PRINT '  • Ointment - Sell by tubes (1, 2, 3...)';
PRINT '  • All others - Sell by units (1, 2, 3...)';
PRINT '';
PRINT '✓✓✓ SIMPLIFICATION COMPLETE! ✓✓✓';
PRINT '';
