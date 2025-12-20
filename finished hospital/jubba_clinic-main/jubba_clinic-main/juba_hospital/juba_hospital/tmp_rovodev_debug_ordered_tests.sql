-- Debug why GetOrderTests only returns 3 tests instead of all ordered tests

-- 1. Check what tests are actually stored for a specific order (replace with your orderId)
DECLARE @orderId INT = 3007; -- Replace with your actual orderId

PRINT '=== RAW DATA IN lab_test TABLE ===';
SELECT * FROM lab_test WHERE med_id = @orderId;

PRINT '';
PRINT '=== CHECKING WHICH COLUMNS HAVE VALUES ===';
SELECT 
    med_id,
    CASE WHEN Hemoglobin IS NOT NULL AND Hemoglobin != '' THEN 'Hemoglobin' ELSE NULL END AS Hemoglobin,
    CASE WHEN Malaria IS NOT NULL AND Malaria != '' THEN 'Malaria' ELSE NULL END AS Malaria,
    CASE WHEN ESR IS NOT NULL AND ESR != '' THEN 'ESR' ELSE NULL END AS ESR,
    CASE WHEN Blood_grouping IS NOT NULL AND Blood_grouping != '' THEN 'Blood_grouping' ELSE NULL END AS Blood_grouping,
    CASE WHEN Electrolyte_Test IS NOT NULL AND Electrolyte_Test != '' THEN 'Electrolyte_Test' ELSE NULL END AS Electrolyte_Test,
    CASE WHEN CRP_Titer IS NOT NULL AND CRP_Titer != '' THEN 'CRP_Titer' ELSE NULL END AS CRP_Titer,
    CASE WHEN Ultra IS NOT NULL AND Ultra != '' THEN 'Ultra' ELSE NULL END AS Ultra,
    CASE WHEN Typhoid_IgG IS NOT NULL AND Typhoid_IgG != '' THEN 'Typhoid_IgG' ELSE NULL END AS Typhoid_IgG,
    CASE WHEN Typhoid_Ag IS NOT NULL AND Typhoid_Ag != '' THEN 'Typhoid_Ag' ELSE NULL END AS Typhoid_Ag
FROM lab_test 
WHERE med_id = @orderId;

PRINT '';
PRINT '=== ACTUAL VALUES IN NEW TEST COLUMNS ===';
SELECT 
    med_id,
    Electrolyte_Test,
    CRP_Titer,
    Ultra,
    Typhoid_IgG,
    Typhoid_Ag
FROM lab_test 
WHERE med_id = @orderId;

PRINT '';
PRINT '=== DATA TYPES OF NEW TEST COLUMNS ===';
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'lab_test' 
AND COLUMN_NAME IN ('Electrolyte_Test', 'CRP_Titer', 'Ultra', 'Typhoid_IgG', 'Typhoid_Ag');

PRINT '';
PRINT '=== TESTING UNPIVOT MANUALLY ===';
-- This is what GetOrderTests does
SELECT TestName
FROM (
    SELECT 
        Hemoglobin, Malaria, ESR, Blood_grouping, Blood_sugar, CBC,
        Cross_matching, TPHA, Human_immune_deficiency_HIV,
        Hepatitis_B_virus_HBV, Hepatitis_C_virus_HCV,
        Electrolyte_Test, CRP_Titer, Ultra, Typhoid_IgG, Typhoid_Ag
    FROM lab_test
    WHERE med_id = @orderId
) src
UNPIVOT (
    TestValue FOR TestName IN (
        Hemoglobin, Malaria, ESR, Blood_grouping, Blood_sugar, CBC,
        Cross_matching, TPHA, Human_immune_deficiency_HIV,
        Hepatitis_B_virus_HBV, Hepatitis_C_virus_HCV,
        Electrolyte_Test, CRP_Titer, Ultra, Typhoid_IgG, Typhoid_Ag
    )
) unpvt
WHERE (TestValue = 'on' OR TestValue = '1' OR TestValue = 'true' OR (TestValue != 'not checked' AND TestValue IS NOT NULL AND TestValue != ''));

PRINT '';
PRINT '=== CHECK IF VALUES ARE "on" or "1" ===';
SELECT 
    med_id,
    CASE WHEN Electrolyte_Test = 'on' THEN 'YES-on' 
         WHEN Electrolyte_Test = '1' THEN 'YES-1' 
         WHEN Electrolyte_Test = 'true' THEN 'YES-true'
         ELSE 'NO: [' + ISNULL(Electrolyte_Test, 'NULL') + ']' END AS Electrolyte_Test_Check,
    CASE WHEN CRP_Titer = 'on' THEN 'YES-on' 
         WHEN CRP_Titer = '1' THEN 'YES-1' 
         WHEN CRP_Titer = 'true' THEN 'YES-true'
         ELSE 'NO: [' + ISNULL(CRP_Titer, 'NULL') + ']' END AS CRP_Titer_Check,
    CASE WHEN Ultra = 'on' THEN 'YES-on' 
         WHEN Ultra = '1' THEN 'YES-1' 
         WHEN Ultra = 'true' THEN 'YES-true'
         ELSE 'NO: [' + ISNULL(Ultra, 'NULL') + ']' END AS Ultra_Check,
    CASE WHEN Typhoid_IgG = 'on' THEN 'YES-on' 
         WHEN Typhoid_IgG = '1' THEN 'YES-1' 
         WHEN Typhoid_IgG = 'true' THEN 'YES-true'
         ELSE 'NO: [' + ISNULL(Typhoid_IgG, 'NULL') + ']' END AS Typhoid_IgG_Check,
    CASE WHEN Typhoid_Ag = 'on' THEN 'YES-on' 
         WHEN Typhoid_Ag = '1' THEN 'YES-1' 
         WHEN Typhoid_Ag = 'true' THEN 'YES-true'
         ELSE 'NO: [' + ISNULL(Typhoid_Ag, 'NULL') + ']' END AS Typhoid_Ag_Check
FROM lab_test 
WHERE med_id = @orderId;
