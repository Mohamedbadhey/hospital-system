-- Check medicine conversion rules
USE [juba_clinick]
GO

SELECT 
    m.medicineid,
    m.medicine_name,
    m.tablets_per_strip,
    m.strips_per_box,
    u.unit_name,
    u.base_unit_name,
    u.subdivision_unit,
    mi.primary_quantity as 'Boxes',
    mi.total_strips as 'Strips',
    mi.loose_tablets as 'Loose Pieces'
FROM medicine m
LEFT JOIN medicine_units u ON m.unit_id = u.unit_id
LEFT JOIN medicine_inventory mi ON m.medicineid = mi.medicineid
ORDER BY m.medicineid
