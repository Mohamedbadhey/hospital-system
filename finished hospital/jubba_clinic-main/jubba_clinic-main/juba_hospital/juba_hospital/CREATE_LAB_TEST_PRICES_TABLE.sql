-- ================================================================
-- Lab Test Pricing System - Database Setup
-- Creates table for individual test pricing
-- ================================================================

USE [juba_clinick]
GO

-- Create lab_test_prices table
IF OBJECT_ID('lab_test_prices', 'U') IS NOT NULL
    DROP TABLE [lab_test_prices];
GO

CREATE TABLE [dbo].[lab_test_prices](
    [test_price_id] [int] IDENTITY(1,1) NOT NULL,
    [test_name] [varchar](100) NOT NULL,
    [test_display_name] [varchar](150) NOT NULL,
    [test_category] [varchar](50) NULL,
    [test_price] [decimal](10, 2) NOT NULL DEFAULT 0,
    [is_active] [bit] NOT NULL DEFAULT 1,
    [date_added] [datetime] NOT NULL DEFAULT GETDATE(),
    [last_updated] [datetime] NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [PK_lab_test_prices] PRIMARY KEY CLUSTERED 
    (
        [test_price_id] ASC
    )
) ON [PRIMARY]
GO

-- Create unique index on test_name
CREATE UNIQUE NONCLUSTERED INDEX [IX_lab_test_prices_name] 
ON [dbo].[lab_test_prices]([test_name] ASC)
GO

-- Create index on category for filtering
CREATE NONCLUSTERED INDEX [IX_lab_test_prices_category] 
ON [dbo].[lab_test_prices]([test_category] ASC)
GO

PRINT 'Created lab_test_prices table successfully'
PRINT ''
GO

-- ================================================================
-- Insert Default Test Prices
-- Organized by category with reasonable default pricing
-- ================================================================

-- HEMATOLOGY TESTS
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Hemoglobin', 'Hemoglobin (Hb)', 'Hematology', 5.00),
('Malaria', 'Malaria Test', 'Hematology', 5.00),
('ESR', 'Erythrocyte Sedimentation Rate (ESR)', 'Hematology', 5.00),
('Blood_grouping', 'Blood Grouping', 'Hematology', 10.00),
('Blood_sugar', 'Blood Sugar (Random)', 'Hematology', 5.00),
('CBC', 'Complete Blood Count (CBC)', 'Hematology', 15.00),
('Cross_matching', 'Cross Matching', 'Hematology', 15.00);

-- BIOCHEMISTRY - LIPID PROFILE
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Lipid_profile', 'Lipid Profile (Complete)', 'Biochemistry - Lipid', 25.00),
('Low_density_lipoprotein_LDL', 'LDL Cholesterol', 'Biochemistry - Lipid', 8.00),
('High_density_lipoprotein_HDL', 'HDL Cholesterol', 'Biochemistry - Lipid', 8.00),
('Total_cholesterol', 'Total Cholesterol', 'Biochemistry - Lipid', 7.00),
('Triglycerides', 'Triglycerides', 'Biochemistry - Lipid', 8.00);

-- BIOCHEMISTRY - LIVER FUNCTION
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Liver_function_test', 'Liver Function Test (Complete)', 'Biochemistry - Liver', 30.00),
('SGPT_ALT', 'SGPT/ALT', 'Biochemistry - Liver', 8.00),
('SGOT_AST', 'SGOT/AST', 'Biochemistry - Liver', 8.00),
('Alkaline_phosphates_ALP', 'Alkaline Phosphatase (ALP)', 'Biochemistry - Liver', 8.00),
('Total_bilirubin', 'Total Bilirubin', 'Biochemistry - Liver', 7.00),
('Direct_bilirubin', 'Direct Bilirubin', 'Biochemistry - Liver', 7.00),
('Albumin', 'Albumin', 'Biochemistry - Liver', 7.00),
('JGlobulin', 'Globulin', 'Biochemistry - Liver', 7.00);

-- BIOCHEMISTRY - RENAL FUNCTION
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Renal_profile', 'Renal Profile (Complete)', 'Biochemistry - Renal', 25.00),
('Urea', 'Urea', 'Biochemistry - Renal', 7.00),
('Creatinine', 'Creatinine', 'Biochemistry - Renal', 8.00),
('Uric_acid', 'Uric Acid', 'Biochemistry - Renal', 8.00);

-- BIOCHEMISTRY - ELECTROLYTES
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Electrolytes', 'Electrolytes (Complete Panel)', 'Biochemistry - Electrolytes', 20.00),
('Sodium', 'Sodium (Na+)', 'Biochemistry - Electrolytes', 6.00),
('Potassium', 'Potassium (K+)', 'Biochemistry - Electrolytes', 6.00),
('Chloride', 'Chloride (Cl-)', 'Biochemistry - Electrolytes', 6.00),
('Calcium', 'Calcium (Ca)', 'Biochemistry - Electrolytes', 7.00),
('Phosphorous', 'Phosphorous', 'Biochemistry - Electrolytes', 7.00),
('Magnesium', 'Magnesium (Mg)', 'Biochemistry - Electrolytes', 7.00);

-- BIOCHEMISTRY - PANCREATIC
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Pancreases', 'Pancreatic Enzymes', 'Biochemistry - Pancreatic', 15.00),
('Amylase', 'Amylase', 'Biochemistry - Pancreatic', 10.00);

-- IMMUNOLOGY/VIROLOGY
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Immunology_Virology', 'Immunology/Virology Panel', 'Immunology', 40.00),
('TPHA', 'TPHA (Syphilis)', 'Immunology', 12.00),
('Human_immune_deficiency_HIV', 'HIV Test', 'Immunology', 15.00),
('Hepatitis_B_virus_HBV', 'Hepatitis B (HBsAg)', 'Immunology', 15.00),
('Hepatitis_C_virus_HCV', 'Hepatitis C (HCV)', 'Immunology', 15.00),
('Brucella_melitensis', 'Brucella Melitensis', 'Immunology', 12.00),
('Brucella_abortus', 'Brucella Abortus', 'Immunology', 12.00),
('C_reactive_protein_CRP', 'C-Reactive Protein (CRP)', 'Immunology', 10.00),
('Rheumatoid_factor_RF', 'Rheumatoid Factor (RF)', 'Immunology', 10.00),
('Antistreptolysin_O_ASO', 'ASO (Anti-Streptolysin O)', 'Immunology', 10.00),
('Toxoplasmosis', 'Toxoplasmosis', 'Immunology', 15.00),
('Typhoid_hCG', 'Typhoid Test', 'Immunology', 10.00),
('Hpylori_antibody', 'H. Pylori Antibody', 'Immunology', 12.00),
('VDRL', 'VDRL (Syphilis)', 'Immunology', 10.00),
('Dengue_Fever_IgG_IgM', 'Dengue Fever (IgG/IgM)', 'Immunology', 20.00),
('Gonorrhea_Ag', 'Gonorrhea Antigen', 'Immunology', 15.00);

-- PARASITOLOGY
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Parasitology', 'Parasitology Examination', 'Parasitology', 10.00),
('Stool_occult_blood', 'Stool Occult Blood', 'Parasitology', 8.00),
('General_stool_examination', 'General Stool Examination', 'Parasitology', 8.00);

-- HORMONES - THYROID
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Hormones', 'Hormone Panel (Complete)', 'Hormones', 50.00),
('Thyroid_profile', 'Thyroid Profile (Complete)', 'Hormones - Thyroid', 30.00),
('Triiodothyronine_T3', 'T3 (Triiodothyronine)', 'Hormones - Thyroid', 12.00),
('Thyroxine_T4', 'T4 (Thyroxine)', 'Hormones - Thyroid', 12.00),
('Thyroid_stimulating_hormone_TSH', 'TSH (Thyroid Stimulating Hormone)', 'Hormones - Thyroid', 15.00);

-- HORMONES - FERTILITY
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Fertility_profile', 'Fertility Profile (Complete)', 'Hormones - Fertility', 60.00),
('Progesterone_Female', 'Progesterone (Female)', 'Hormones - Fertility', 15.00),
('Follicle_stimulating_hormone_FSH', 'FSH (Follicle Stimulating Hormone)', 'Hormones - Fertility', 15.00),
('Estradiol', 'Estradiol', 'Hormones - Fertility', 15.00),
('Luteinizing_hormone_LH', 'LH (Luteinizing Hormone)', 'Hormones - Fertility', 15.00),
('Testosterone_Male', 'Testosterone (Male)', 'Hormones - Fertility', 15.00),
('Prolactin', 'Prolactin', 'Hormones - Fertility', 15.00),
('AMH', 'AMH (Anti-Mullerian Hormone)', 'Hormones - Fertility', 25.00),
('Seminal_Fluid_Analysis_Male_B_HCG', 'Seminal Fluid Analysis', 'Hormones - Fertility', 20.00);

-- CLINICAL PATHOLOGY
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Clinical_path', 'Clinical Pathology (Complete)', 'Clinical Pathology', 25.00),
('Urine_examination', 'Urine Examination', 'Clinical Pathology', 7.00),
('Stool_examination', 'Stool Examination', 'Clinical Pathology', 7.00),
('Sperm_examination', 'Sperm Examination', 'Clinical Pathology', 15.00),
('Virginal_swab_trichomonas_virginals', 'Vaginal Swab (Trichomonas)', 'Clinical Pathology', 10.00),
('Human_chorionic_gonadotropin_hCG', 'hCG (Pregnancy Test)', 'Clinical Pathology', 8.00),
('Hpylori_Ag_stool', 'H. Pylori Antigen (Stool)', 'Clinical Pathology', 12.00),
('General_urine_examination', 'General Urine Examination', 'Clinical Pathology', 7.00);

-- DIABETES PANEL
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Diabetes', 'Diabetes Panel (Complete)', 'Diabetes', 20.00),
('Fasting_blood_sugar', 'Fasting Blood Sugar (FBS)', 'Diabetes', 7.00),
('Hemoglobin_A1c', 'HbA1c (Glycated Hemoglobin)', 'Diabetes', 15.00);

-- CARDIAC MARKERS
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Troponin_I', 'Troponin I (Cardiac)', 'Cardiac Markers', 25.00),
('CK_MB', 'CK-MB (Creatine Kinase-MB)', 'Cardiac Markers', 20.00);

-- COAGULATION PROFILE
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('aPTT', 'aPTT (Activated Partial Thromboplastin Time)', 'Coagulation', 15.00),
('INR', 'INR (International Normalized Ratio)', 'Coagulation', 15.00),
('D_Dimer', 'D-Dimer', 'Coagulation', 20.00);

-- VITAMINS & MINERALS
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Vitamin_D', 'Vitamin D', 'Vitamins', 20.00),
('Vitamin_B12', 'Vitamin B12', 'Vitamins', 20.00),
('Ferritin', 'Ferritin (Iron Storage)', 'Vitamins', 15.00);

-- TUMOR MARKERS
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('AFP', 'AFP (Alpha-Fetoprotein)', 'Tumor Markers', 25.00),
('Total_PSA', 'PSA (Prostate Specific Antigen)', 'Tumor Markers', 25.00);

-- SPECIAL CATEGORIES (Headers/Groups)
INSERT INTO lab_test_prices (test_name, test_display_name, test_category, test_price) VALUES
('Biochemistry', 'Biochemistry (Complete Panel)', 'Biochemistry', 80.00),
('Hematology', 'Hematology (Complete Panel)', 'Hematology', 40.00);

GO

PRINT ''
PRINT '================================================================='
PRINT 'SUCCESS: Lab Test Prices Table Created'
PRINT ''
PRINT 'Total Tests with Prices: ' + CAST((SELECT COUNT(*) FROM lab_test_prices) AS VARCHAR(10))
PRINT ''
PRINT 'Test Categories:'
PRINT '  - Hematology'
PRINT '  - Biochemistry (Lipid, Liver, Renal, Electrolytes, Pancreatic)'
PRINT '  - Immunology/Virology'
PRINT '  - Hormones (Thyroid, Fertility)'
PRINT '  - Clinical Pathology'
PRINT '  - Diabetes'
PRINT '  - Cardiac Markers'
PRINT '  - Coagulation'
PRINT '  - Vitamins & Minerals'
PRINT '  - Tumor Markers'
PRINT ''
PRINT 'Next Steps:'
PRINT '  1. Run this script to create the table and default prices'
PRINT '  2. Admin can modify prices via admin interface'
PRINT '  3. System will calculate total based on ordered tests'
PRINT '================================================================='
PRINT ''
GO
