-- Find the 2 extra charges that don't have corresponding test columns
-- Lab order #41 has 83 charges but only 81 test columns in lab_test table

DECLARE @lab_order_id INT = 42;

-- Map all 81 lab_test columns to their charge names
-- Then find charges that DON'T match any of these
SELECT 
    pc.charge_id,
    pc.charge_name,
    pc.amount,
    'Extra charge - no matching test column in lab_test table' AS issue
FROM patient_charges pc
WHERE pc.reference_id = @lab_order_id
  AND pc.charge_type = 'Lab'
  AND pc.charge_name NOT IN (
    'LDL Cholesterol',  -- Low_density_lipoprotein_LDL
    'HDL Cholesterol',  -- High_density_lipoprotein_HDL
    'Total Cholesterol',  -- Total_cholesterol
    'Triglycerides',  -- Triglycerides
    'SGPT/ALT',  -- SGPT_ALT
    'SGOT/AST',  -- SGOT_AST
    'Alkaline Phosphatase (ALP)',  -- Alkaline_phosphates_ALP
    'Total Bilirubin',  -- Total_bilirubin
    'Direct Bilirubin',  -- Direct_bilirubin
    'Albumin',  -- Albumin
    'Globulin',  -- JGlobulin
    'Urea',  -- Urea
    'Creatinine',  -- Creatinine
    'Uric Acid',  -- Uric_acid
    'Sodium (Na+)',  -- Sodium
    'Potassium (K+)',  -- Potassium
    'Chloride (Cl-)',  -- Chloride
    'Calcium (Ca)',  -- Calcium
    'Phosphorous',  -- Phosphorous
    'Magnesium (Mg)',  -- Magnesium
    'Amylase',  -- Amylase
    'Hemoglobin (Hb)',  -- Hemoglobin
    'Malaria Test',  -- Malaria
    'Erythrocyte Sedimentation Rate (ESR)',  -- ESR
    'Blood Grouping',  -- Blood_grouping
    'Blood Sugar (Random)',  -- Blood_sugar
    'Complete Blood Count (CBC)',  -- CBC
    'Cross Matching',  -- Cross_matching
    'TPHA (Syphilis)',  -- TPHA
    'HIV Test',  -- Human_immune_deficiency_HIV
    'Hepatitis B (HBsAg)',  -- Hepatitis_B_virus_HBV
    'Hepatitis C (HCV)',  -- Hepatitis_C_virus_HCV
    'Brucella Melitensis',  -- Brucella_melitensis
    'Brucella Abortus',  -- Brucella_abortus
    'C-Reactive Protein (CRP)',  -- C_reactive_protein_CRP
    'Rheumatoid Factor (RF)',  -- Rheumatoid_factor_RF
    'ASO (Anti-Streptolysin O)',  -- Antistreptolysin_O_ASO
    'Toxoplasmosis',  -- Toxoplasmosis
    'Typhoid Test',  -- Typhoid_hCG
    'H. Pylori Antibody',  -- Hpylori_antibody
    'Stool Occult Blood',  -- Stool_occult_blood
    'General Stool Examination',  -- General_stool_examination
    'Thyroid Profile (Complete)',  -- Thyroid_profile
    'T3 (Triiodothyronine)',  -- Triiodothyronine_T3
    'T4 (Thyroxine)',  -- Thyroxine_T4
    'TSH (Thyroid Stimulating Hormone)',  -- Thyroid_stimulating_hormone_TSH
    'Progesterone (Female)',  -- Progesterone_Female
    'FSH (Follicle Stimulating Hormone)',  -- Follicle_stimulating_hormone_FSH
    'Estradiol',  -- Estradiol
    'LH (Luteinizing Hormone)',  -- Luteinizing_hormone_LH
    'Testosterone (Male)',  -- Testosterone_Male
    'Prolactin',  -- Prolactin
    'Seminal Fluid Analysis',  -- Seminal_Fluid_Analysis_Male_B_HCG
    'Urine Examination',  -- Urine_examination
    'Stool Examination',  -- Stool_examination
    'Sperm Examination',  -- Sperm_examination
    'Vaginal Swab (Trichomonas)',  -- Virginal_swab_trichomonas_virginals
    'hCG (Pregnancy Test)',  -- Human_chorionic_gonadotropin_hCG
    'H. Pylori Antigen (Stool)',  -- Hpylori_Ag_stool
    'Fasting Blood Sugar (FBS)',  -- Fasting_blood_sugar
    'HbA1c (Glycated Hemoglobin)',  -- Hemoglobin_A1c
    'General Urine Examination',  -- General_urine_examination
    'AMH (Anti-Mullerian Hormone)',  -- AMH
    'Troponin I (Cardiac)',  -- Troponin_I
    'CK-MB (Creatine Kinase-MB)',  -- CK_MB
    'aPTT (Activated Partial Thromboplastin Time)',  -- aPTT
    'INR (International Normalized Ratio)',  -- INR
    'D-Dimer',  -- D_Dimer
    'Vitamin D',  -- Vitamin_D
    'Vitamin B12',  -- Vitamin_B12
    'Ferritin (Iron Storage)',  -- Ferritin
    'VDRL (Syphilis)',  -- VDRL
    'Dengue Fever (IgG/IgM)',  -- Dengue_Fever_IgG_IgM
    'Gonorrhea Antigen',  -- Gonorrhea_Ag
    'AFP (Alpha-Fetoprotein)',  -- AFP
    'PSA (Prostate Specific Antigen)',  -- Total_PSA
    'Electrolyte Test',  -- Electrolyte_Test
    'CRP Titer',  -- CRP_Titer
    'Ultra',  -- Ultra
    'Typhoid IgG',  -- Typhoid_IgG
    'Typhoid Ag'  -- Typhoid_Ag
  )
ORDER BY pc.charge_name;

-- Count verification
SELECT 
    'VERIFICATION' AS section,
    81 AS lab_test_columns,
    (SELECT COUNT(*) FROM patient_charges WHERE reference_id = @lab_order_id AND charge_type = 'Lab') AS charges_created,
    (SELECT COUNT(*) FROM patient_charges WHERE reference_id = @lab_order_id AND charge_type = 'Lab') - 81 AS extra_charges
