-- Check medicine table structure for cost columns
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'medicine' 
AND COLUMN_NAME LIKE '%cost%'
ORDER BY ORDINAL_POSITION;

-- Check sample medicine data to see if costs are populated
SELECT TOP 5
    medicineid,
    medicinename,
    cost_per_tablet,
    cost_per_strip,
    cost_per_box,
    price_per_tablet,
    price_per_strip,
    price_per_box
FROM medicine
ORDER BY medicineid DESC;

-- Check if any medicines have cost values
SELECT 
    COUNT(*) as total_medicines,
    COUNT(cost_per_tablet) as has_tablet_cost,
    COUNT(cost_per_strip) as has_strip_cost,
    COUNT(cost_per_box) as has_box_cost,
    SUM(CASE WHEN cost_per_tablet IS NOT NULL AND cost_per_tablet > 0 THEN 1 ELSE 0 END) as tablet_cost_gt_zero,
    SUM(CASE WHEN cost_per_strip IS NOT NULL AND cost_per_strip > 0 THEN 1 ELSE 0 END) as strip_cost_gt_zero,
    SUM(CASE WHEN cost_per_box IS NOT NULL AND cost_per_box > 0 THEN 1 ELSE 0 END) as box_cost_gt_zero
FROM medicine;
