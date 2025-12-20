-- Check all Typhoid-related columns in lab_test table

SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'lab_test' 
AND COLUMN_NAME LIKE '%Typhoid%'
ORDER BY COLUMN_NAME;

-- Check the exact UNPIVOT result
DECLARE @orderId INT = 19; -- Your med_id

SELECT TestName, TestValue
FROM (
    SELECT 
        Typhoid_hCG, Typhoid_IgG, Typhoid_Ag
    FROM lab_test
    WHERE med_id = @orderId
) src
UNPIVOT (
    TestValue FOR TestName IN (
        Typhoid_hCG, Typhoid_IgG, Typhoid_Ag
    )
) unpvt;

-- Check raw values
SELECT 
    med_id,
    Typhoid_hCG,
    Typhoid_IgG,
    Typhoid_Ag
FROM lab_test 
WHERE med_id = @orderId;
