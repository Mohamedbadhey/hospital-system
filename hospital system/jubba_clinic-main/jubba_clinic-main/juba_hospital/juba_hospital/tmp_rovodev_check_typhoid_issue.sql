-- Check if Typhoid_IgG and Typhoid_Ag columns exist in lab_test table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'lab_test'
  AND COLUMN_NAME IN ('Typhoid_IgG', 'Typhoid_Ag')
ORDER BY COLUMN_NAME;

-- Check actual data in these columns
SELECT TOP 10
    med_id,
    prescid,
    Typhoid_IgG,
    Typhoid_Ag,
    date_taken
FROM lab_test
WHERE (Typhoid_IgG IS NOT NULL OR Typhoid_Ag IS NOT NULL)
ORDER BY date_taken DESC;

-- Check what values are stored
SELECT 
    'Typhoid_IgG' as ColumnName,
    Typhoid_IgG as Value,
    COUNT(*) as Count
FROM lab_test
WHERE Typhoid_IgG IS NOT NULL AND Typhoid_IgG != ''
GROUP BY Typhoid_IgG
UNION ALL
SELECT 
    'Typhoid_Ag' as ColumnName,
    Typhoid_Ag as Value,
    COUNT(*) as Count
FROM lab_test
WHERE Typhoid_Ag IS NOT NULL AND Typhoid_Ag != ''
GROUP BY Typhoid_Ag;
