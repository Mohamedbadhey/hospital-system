-- Check medicine units configuration
USE [juba_clinick]
GO

PRINT '========================================='
PRINT 'Medicine Units Configuration'
PRINT '========================================='
PRINT ''

-- Check all medicines with their units
SELECT 
    m.medicineid,
    m.medicine_name,
    m.unit_id,
    u.unit_name,
    u.base_unit_name,
    u.subdivision_unit,
    u.selling_method,
    u.allows_subdivision
FROM medicine m
LEFT JOIN medicine_units u ON m.unit_id = u.unit_id
ORDER BY m.medicineid
GO

PRINT ''
PRINT 'Sharoobo qufac details:'
SELECT 
    m.medicine_name,
    u.unit_name as 'Primary Unit',
    u.base_unit_name as 'Base Unit',
    u.subdivision_unit as 'Subdivision',
    u.selling_method,
    u.allows_subdivision,
    mi.primary_quantity,
    mi.secondary_quantity,
    mi.total_strips,
    mi.loose_tablets
FROM medicine m
LEFT JOIN medicine_units u ON m.unit_id = u.unit_id
LEFT JOIN medicine_inventory mi ON m.medicineid = mi.medicineid
WHERE m.medicine_name LIKE '%sharoobo%'
GO
