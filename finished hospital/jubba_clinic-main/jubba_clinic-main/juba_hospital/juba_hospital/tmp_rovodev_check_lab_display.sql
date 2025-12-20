-- SQL Query to Check How Lab Tests Are Displayed in Reports
-- This shows you exactly what test names will appear for each patient

-- 1. See all lab test columns and their values for recent orders
SELECT TOP 5
    med_id,
    prescid,
    date_taken,
    -- Show only columns with actual test values (not 'not checked')
    CASE WHEN Low_density_lipoprotein_LDL != 'not checked' THEN Low_density_lipoprotein_LDL ELSE NULL END as LDL,
    CASE WHEN High_density_lipoprotein_HDL != 'not checked' THEN High_density_lipoprotein_HDL ELSE NULL END as HDL,
    CASE WHEN Hemoglobin != 'not checked' THEN Hemoglobin ELSE NULL END as Hemoglobin,
    CASE WHEN Malaria != 'not checked' THEN Malaria ELSE NULL END as Malaria,
    CASE WHEN Blood_sugar != 'not checked' THEN Blood_sugar ELSE NULL END as Blood_sugar,
    CASE WHEN Typhoid_IgG != 'not checked' THEN Typhoid_IgG ELSE NULL END as Typhoid_IgG,
    CASE WHEN Typhoid_Ag != 'not checked' THEN Typhoid_Ag ELSE NULL END as Typhoid_Ag,
    CASE WHEN Electrolyte_Test != 'not checked' THEN Electrolyte_Test ELSE NULL END as Electrolyte_Test,
    CASE WHEN CRP_Titer != 'not checked' THEN CRP_Titer ELSE NULL END as CRP_Titer,
    CASE WHEN Ultra != 'not checked' THEN Ultra ELSE NULL END as Ultra,
    CASE WHEN Chloride != 'not checked' THEN Chloride ELSE NULL END as Chloride,
    CASE WHEN Rheumatoid_factor_RF != 'not checked' THEN Rheumatoid_factor_RF ELSE NULL END as Rheumatoid_Factor,
    CASE WHEN Seminal_Fluid_Analysis_Male_B_HCG != 'not checked' THEN Seminal_Fluid_Analysis_Male_B_HCG ELSE NULL END as Seminal_Fluid,
    CASE WHEN Thyroid_profile != 'not checked' THEN Thyroid_profile ELSE NULL END as Thyroid_Profile,
    CASE WHEN Uric_acid != 'not checked' THEN Uric_acid ELSE NULL END as Uric_Acid
FROM lab_test
ORDER BY date_taken DESC;

-- 2. Get a list of ONLY the ordered tests for each lab order (comma-separated like the report will show)
SELECT TOP 10
    lt.med_id,
    lt.prescid,
    p.full_name as patient_name,
    lt.date_taken,
    -- This simulates what GetTestNamesForOrder() does - shows all non-"not checked" values
    STUFF((
        SELECT ', ' + 
            CASE 
                WHEN col.value != 'not checked' THEN col.value
                ELSE NULL
            END
        FROM (
            SELECT Low_density_lipoprotein_LDL as value FROM lab_test WHERE med_id = lt.med_id AND Low_density_lipoprotein_LDL != 'not checked'
            UNION ALL SELECT High_density_lipoprotein_HDL FROM lab_test WHERE med_id = lt.med_id AND High_density_lipoprotein_HDL != 'not checked'
            UNION ALL SELECT Total_cholesterol FROM lab_test WHERE med_id = lt.med_id AND Total_cholesterol != 'not checked'
            UNION ALL SELECT Hemoglobin FROM lab_test WHERE med_id = lt.med_id AND Hemoglobin != 'not checked'
            UNION ALL SELECT Malaria FROM lab_test WHERE med_id = lt.med_id AND Malaria != 'not checked'
            UNION ALL SELECT Blood_sugar FROM lab_test WHERE med_id = lt.med_id AND Blood_sugar != 'not checked'
            UNION ALL SELECT Typhoid_IgG FROM lab_test WHERE med_id = lt.med_id AND Typhoid_IgG != 'not checked'
            UNION ALL SELECT Typhoid_Ag FROM lab_test WHERE med_id = lt.med_id AND Typhoid_Ag != 'not checked'
            UNION ALL SELECT Electrolyte_Test FROM lab_test WHERE med_id = lt.med_id AND Electrolyte_Test != 'not checked'
            UNION ALL SELECT CRP_Titer FROM lab_test WHERE med_id = lt.med_id AND CRP_Titer != 'not checked'
            UNION ALL SELECT Ultra FROM lab_test WHERE med_id = lt.med_id AND Ultra != 'not checked'
            UNION ALL SELECT Chloride FROM lab_test WHERE med_id = lt.med_id AND Chloride != 'not checked'
            UNION ALL SELECT Rheumatoid_factor_RF FROM lab_test WHERE med_id = lt.med_id AND Rheumatoid_factor_RF != 'not checked'
            UNION ALL SELECT Uric_acid FROM lab_test WHERE med_id = lt.med_id AND Uric_acid != 'not checked'
        ) col
        WHERE col.value IS NOT NULL
        FOR XML PATH('')
    ), 1, 2, '') as ordered_tests
FROM lab_test lt
INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
INNER JOIN patient p ON pr.patientid = p.patientid
ORDER BY lt.date_taken DESC;

-- 3. Simple check - show specific patient's lab orders and what will display
SELECT 
    lt.med_id,
    lt.prescid,
    p.full_name,
    lt.date_taken,
    -- Count how many tests were ordered
    (
        SELECT COUNT(*)
        FROM (
            SELECT CASE WHEN Low_density_lipoprotein_LDL != 'not checked' THEN 1 END
            UNION ALL SELECT CASE WHEN High_density_lipoprotein_HDL != 'not checked' THEN 1 END
            UNION ALL SELECT CASE WHEN Hemoglobin != 'not checked' THEN 1 END
            UNION ALL SELECT CASE WHEN Malaria != 'not checked' THEN 1 END
            UNION ALL SELECT CASE WHEN Typhoid_IgG != 'not checked' THEN 1 END
            UNION ALL SELECT CASE WHEN Typhoid_Ag != 'not checked' THEN 1 END
            UNION ALL SELECT CASE WHEN Electrolyte_Test != 'not checked' THEN 1 END
            UNION ALL SELECT CASE WHEN CRP_Titer != 'not checked' THEN 1 END
            UNION ALL SELECT CASE WHEN Ultra != 'not checked' THEN 1 END
        ) x(test)
        FROM lab_test lt2
        WHERE lt2.med_id = lt.med_id AND test IS NOT NULL
    ) as test_count,
    -- Show specific tests that are ordered
    CASE WHEN Typhoid_IgG != 'not checked' THEN 'YES' ELSE 'NO' END as Has_Typhoid_IgG,
    CASE WHEN Typhoid_Ag != 'not checked' THEN 'YES' ELSE 'NO' END as Has_Typhoid_Ag,
    CASE WHEN Electrolyte_Test != 'not checked' THEN 'YES' ELSE 'NO' END as Has_Electrolyte,
    CASE WHEN CRP_Titer != 'not checked' THEN 'YES' ELSE 'NO' END as Has_CRP_Titer,
    CASE WHEN Ultra != 'not checked' THEN 'YES' ELSE 'NO' END as Has_Ultra
FROM lab_test lt
INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
INNER JOIN patient p ON pr.patientid = p.patientid
WHERE pr.status >= 4
ORDER BY lt.date_taken DESC;

-- 4. Check specific med_id to see all its data
-- Replace 48 with your actual med_id
SELECT *
FROM lab_test
WHERE med_id = 48;
