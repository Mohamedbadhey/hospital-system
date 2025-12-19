-- Check what unit names are in the database
USE [juba_clinick]
GO

PRINT 'All Medicine Units in Database:'
PRINT '============================================'

SELECT 
    unit_id,
    unit_name,
    unit_abbreviation,
    selling_method,
    allows_subdivision,
    base_unit_name,
    subdivision_unit
FROM medicine_units
ORDER BY unit_id

PRINT ''
PRINT 'Medicines and their units:'
PRINT '============================================'

SELECT 
    m.medicineid,
    m.medicine_name,
    u.unit_name,
    u.selling_method,
    m.cost_per_tablet,
    m.cost_per_strip,
    m.cost_per_box
FROM medicine m
LEFT JOIN medicine_units u ON m.unit_id = u.unit_id
ORDER BY m.medicineid
