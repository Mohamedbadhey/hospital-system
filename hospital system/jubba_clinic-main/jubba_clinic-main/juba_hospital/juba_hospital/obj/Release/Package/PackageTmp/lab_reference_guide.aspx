<%@ Page Title="Lab Test Reference Guide" Language="C#" MasterPageFile="~/labtest.Master" AutoEventWireup="true" CodeBehind="lab_reference_guide.aspx.cs" Inherits="juba_hospital.lab_reference_guide" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="row mb-3">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0"><i class="fas fa-book-medical"></i> Laboratory Test Reference Guide</h4>
                        <small>International Standards & Clinical Interpretation</small>
                    </div>
                    <div class="card-body">
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <input type="text" id="searchBox" class="form-control" placeholder="🔍 Search tests (e.g., hemoglobin, glucose, liver function...)">
                            </div>
                            <div class="col-md-3">
                                <select id="categoryFilter" class="form-control">
                                    <option value="">All Categories</option>
                                    <option value="hematology">Hematology</option>
                                    <option value="biochemistry">Biochemistry</option>
                                    <option value="immunology">Immunology</option>
                                    <option value="microbiology">Microbiology</option>
                                    <option value="hormones">Hormones</option>
                                    <option value="urine">Urine Analysis</option>
                                    <option value="stool">Stool Analysis</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button class="btn btn-info btn-block" onclick="printReference()">
                                    <i class="fas fa-print"></i> Print Guide
                                </button>
                            </div>
                        </div>

                        <div id="testReference" class="test-reference-container"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .test-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            background: white;
            transition: all 0.3s;
        }
        
        .test-card:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        
        .test-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 2px solid #007bff;
        }
        
        .test-name {
            font-size: 18px;
            font-weight: bold;
            color: #007bff;
        }
        
        .test-category {
            background: #007bff;
            color: white;
            padding: 4px 12px;
            border-radius: 15px;
            font-size: 12px;
        }
        
        .range-table {
            width: 100%;
            margin: 10px 0;
        }
        
        .range-table th {
            background: #f8f9fa;
            padding: 8px;
            text-align: left;
            font-weight: 600;
        }
        
        .range-table td {
            padding: 8px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .normal-range {
            color: #28a745;
            font-weight: bold;
        }
        
        .abnormal-high {
            color: #dc3545;
        }
        
        .abnormal-low {
            color: #ffc107;
        }
        
        .clinical-note {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        
        .interpretation {
            background: #d1ecf1;
            border-left: 4px solid #17a2b8;
            padding: 10px;
            margin: 10px 0;
            border-radius: 4px;
        }
        
        @media print {
            .card-header, #searchBox, #categoryFilter, button {
                display: none;
            }
        }
    </style>

    <script>
        var testDatabase = [
            // HEMATOLOGY
            {
                name: "Hemoglobin (Hb)",
                category: "hematology",
                unit: "g/dL",
                normalRanges: [
                    { group: "Adult Male", range: "13.5 - 17.5", low: 13.5, high: 17.5 },
                    { group: "Adult Female", range: "12.0 - 16.0", low: 12.0, high: 16.0 },
                    { group: "Pregnant Women", range: "11.0 - 14.0", low: 11.0, high: 14.0 },
                    { group: "Children (6-12 yrs)", range: "11.5 - 15.5", low: 11.5, high: 15.5 }
                ],
                interpretation: {
                    high: "Polycythemia, dehydration, COPD, high altitude, heart disease",
                    low: "Anemia (iron deficiency, B12/folate deficiency), blood loss, chronic disease"
                },
                clinicalNotes: "Critical value: <7 g/dL or >20 g/dL requires immediate attention. Check MCV, MCH to determine anemia type."
            },
            {
                name: "White Blood Cell Count (WBC)",
                category: "hematology",
                unit: "×10³/μL",
                normalRanges: [
                    { group: "Adult", range: "4.5 - 11.0", low: 4.5, high: 11.0 },
                    { group: "Children", range: "5.0 - 14.0", low: 5.0, high: 14.0 }
                ],
                interpretation: {
                    high: "Infection, inflammation, leukemia, stress, steroid use, tissue damage",
                    low: "Viral infection, bone marrow disorders, autoimmune disease, certain medications"
                },
                clinicalNotes: "Very high (>30) or very low (<2) values require immediate medical attention."
            },
            {
                name: "Platelet Count",
                category: "hematology",
                unit: "×10³/μL",
                normalRanges: [
                    { group: "Adult", range: "150 - 400", low: 150, high: 400 }
                ],
                interpretation: {
                    high: "Thrombocytosis: inflammation, iron deficiency, post-splenectomy, malignancy",
                    low: "Thrombocytopenia: ITP, medications, viral infections, bone marrow disorders, splenomegaly"
                },
                clinicalNotes: "Critical low: <50 (bleeding risk), <20 (spontaneous bleeding). Monitor for bruising/petechiae."
            },
            {
                name: "ESR (Erythrocyte Sedimentation Rate)",
                category: "hematology",
                unit: "mm/hr",
                normalRanges: [
                    { group: "Men <50 yrs", range: "0 - 15", low: 0, high: 15 },
                    { group: "Men >50 yrs", range: "0 - 20", low: 0, high: 20 },
                    { group: "Women <50 yrs", range: "0 - 20", low: 0, high: 20 },
                    { group: "Women >50 yrs", range: "0 - 30", low: 0, high: 30 }
                ],
                interpretation: {
                    high: "Inflammation, infection, autoimmune disease, cancer, pregnancy, kidney disease",
                    low: "Polycythemia, sickle cell disease, CHF"
                },
                clinicalNotes: "Non-specific marker. Very high (>100) suggests serious inflammation, infection, or malignancy."
            },
            
            // BIOCHEMISTRY - GLUCOSE
            {
                name: "Fasting Blood Sugar (FBS)",
                category: "biochemistry",
                unit: "mg/dL",
                normalRanges: [
                    { group: "Normal", range: "70 - 100", low: 70, high: 100 },
                    { group: "Pre-diabetes", range: "100 - 125", low: 100, high: 125 },
                    { group: "Diabetes", range: "≥126", low: 126, high: 999 }
                ],
                interpretation: {
                    high: "Diabetes mellitus, stress, Cushing's syndrome, pancreatitis, medications (steroids)",
                    low: "Hypoglycemia, insulin overdose, prolonged fasting, liver disease, sepsis"
                },
                clinicalNotes: "Critical low: <50 (confusion, seizures). Critical high: >400 (DKA risk). Requires 8-hour fast."
            },
            {
                name: "HbA1c (Glycated Hemoglobin)",
                category: "biochemistry",
                unit: "%",
                normalRanges: [
                    { group: "Normal", range: "<5.7", low: 0, high: 5.7 },
                    { group: "Pre-diabetes", range: "5.7 - 6.4", low: 5.7, high: 6.4 },
                    { group: "Diabetes", range: "≥6.5", low: 6.5, high: 15 }
                ],
                interpretation: {
                    high: "Poor glucose control over past 3 months, diabetes",
                    low: "Recent blood loss, hemolytic anemia, shortened RBC lifespan"
                },
                clinicalNotes: "Reflects average blood glucose over past 2-3 months. Target <7% for diabetics."
            },

            // LIVER FUNCTION TESTS
            {
                name: "SGPT / ALT (Alanine Aminotransferase)",
                category: "biochemistry",
                unit: "U/L",
                normalRanges: [
                    { group: "Male", range: "7 - 55", low: 7, high: 55 },
                    { group: "Female", range: "7 - 45", low: 7, high: 45 }
                ],
                interpretation: {
                    high: "Liver damage: hepatitis, cirrhosis, fatty liver, alcohol, medications, heart failure",
                    low: "Usually not clinically significant"
                },
                clinicalNotes: "More specific for liver than AST. >10× normal suggests acute hepatitis. Check with AST for pattern."
            },
            {
                name: "SGOT / AST (Aspartate Aminotransferase)",
                category: "biochemistry",
                unit: "U/L",
                normalRanges: [
                    { group: "Male", range: "8 - 48", low: 8, high: 48 },
                    { group: "Female", range: "8 - 43", low: 8, high: 43 }
                ],
                interpretation: {
                    high: "Liver disease, heart attack, muscle damage, hemolysis, medications",
                    low: "Usually not clinically significant"
                },
                clinicalNotes: "Less specific than ALT. AST/ALT ratio >2 suggests alcoholic liver disease, <1 suggests non-alcoholic."
            },
            {
                name: "Total Bilirubin",
                category: "biochemistry",
                unit: "mg/dL",
                normalRanges: [
                    { group: "Adult", range: "0.3 - 1.2", low: 0.3, high: 1.2 },
                    { group: "Newborn", range: "<12 (varies)", low: 0, high: 12 }
                ],
                interpretation: {
                    high: "Jaundice, hepatitis, cirrhosis, bile duct obstruction, hemolytic anemia, Gilbert's syndrome",
                    low: "Usually not clinically significant"
                },
                clinicalNotes: "Jaundice visible when >3 mg/dL. Check direct vs indirect to determine cause. Newborn >15 needs phototherapy."
            },
            {
                name: "Alkaline Phosphatase (ALP)",
                category: "biochemistry",
                unit: "U/L",
                normalRanges: [
                    { group: "Adult", range: "30 - 120", low: 30, high: 120 },
                    { group: "Children/Adolescents", range: "up to 350", low: 0, high: 350 }
                ],
                interpretation: {
                    high: "Bile duct obstruction, bone disease, Paget's disease, pregnancy, growth in children",
                    low: "Malnutrition, zinc deficiency, hypothyroidism"
                },
                clinicalNotes: "Elevated in liver disease (cholestasis) and bone disorders. Higher in children (bone growth)."
            },
            {
                name: "Albumin",
                category: "biochemistry",
                unit: "g/dL",
                normalRanges: [
                    { group: "Adult", range: "3.5 - 5.5", low: 3.5, high: 5.5 }
                ],
                interpretation: {
                    high: "Dehydration (rarely clinically significant)",
                    low: "Liver disease, malnutrition, kidney disease (nephrotic syndrome), inflammation, malabsorption"
                },
                clinicalNotes: "Main protein made by liver. Low albumin (<3.0) indicates poor nutrition or chronic disease."
            },

            // RENAL FUNCTION
            {
                name: "Creatinine",
                category: "biochemistry",
                unit: "mg/dL",
                normalRanges: [
                    { group: "Adult Male", range: "0.7 - 1.3", low: 0.7, high: 1.3 },
                    { group: "Adult Female", range: "0.6 - 1.1", low: 0.6, high: 1.1 }
                ],
                interpretation: {
                    high: "Kidney disease, dehydration, muscle damage, high protein diet",
                    low: "Low muscle mass, malnutrition, pregnancy"
                },
                clinicalNotes: "Used to calculate GFR. Doubles with each 50% loss of kidney function. Monitor in CKD, diabetes, HTN."
            },
            {
                name: "Urea / Blood Urea Nitrogen (BUN)",
                category: "biochemistry",
                unit: "mg/dL",
                normalRanges: [
                    { group: "Adult", range: "7 - 20", low: 7, high: 20 }
                ],
                interpretation: {
                    high: "Kidney disease, dehydration, high protein diet, GI bleeding, heart failure",
                    low: "Liver disease, malnutrition, over-hydration, pregnancy"
                },
                clinicalNotes: "BUN/Creatinine ratio >20:1 suggests pre-renal azotemia (dehydration). <10:1 suggests liver disease."
            },
            {
                name: "Uric Acid",
                category: "biochemistry",
                unit: "mg/dL",
                normalRanges: [
                    { group: "Male", range: "3.5 - 7.2", low: 3.5, high: 7.2 },
                    { group: "Female", range: "2.6 - 6.0", low: 2.6, high: 6.0 }
                ],
                interpretation: {
                    high: "Gout, kidney disease, metabolic syndrome, high purine diet, tumor lysis syndrome",
                    low: "Wilson's disease, Fanconi syndrome, SIADH"
                },
                clinicalNotes: "Levels >7 increase gout risk. Acute gout attack often occurs with sudden changes in uric acid."
            },

            // LIPID PROFILE
            {
                name: "Total Cholesterol",
                category: "biochemistry",
                unit: "mg/dL",
                normalRanges: [
                    { group: "Desirable", range: "<200", low: 0, high: 200 },
                    { group: "Borderline High", range: "200 - 239", low: 200, high: 239 },
                    { group: "High", range: "≥240", low: 240, high: 400 }
                ],
                interpretation: {
                    high: "Increased cardiovascular risk, familial hypercholesterolemia, hypothyroidism, diet",
                    low: "Malnutrition, hyperthyroidism, liver disease, malabsorption"
                },
                clinicalNotes: "Should be measured fasting. Check with HDL, LDL, triglycerides for full lipid profile."
            },
            {
                name: "LDL Cholesterol (Bad Cholesterol)",
                category: "biochemistry",
                unit: "mg/dL",
                normalRanges: [
                    { group: "Optimal", range: "<100", low: 0, high: 100 },
                    { group: "Near Optimal", range: "100 - 129", low: 100, high: 129 },
                    { group: "Borderline High", range: "130 - 159", low: 130, high: 159 },
                    { group: "High", range: "160 - 189", low: 160, high: 189 },
                    { group: "Very High", range: "≥190", low: 190, high: 300 }
                ],
                interpretation: {
                    high: "Major risk factor for atherosclerosis, heart disease, stroke",
                    low: "Generally beneficial, but very low (<40) may indicate malnutrition"
                },
                clinicalNotes: "Target <70 for high-risk patients (previous MI, diabetes). Main target for treatment."
            },
            {
                name: "HDL Cholesterol (Good Cholesterol)",
                category: "biochemistry",
                unit: "mg/dL",
                normalRanges: [
                    { group: "Male - Low Risk", range: "≥40", low: 40, high: 100 },
                    { group: "Female - Low Risk", range: "≥50", low: 50, high: 100 },
                    { group: "Optimal", range: "≥60", low: 60, high: 100 }
                ],
                interpretation: {
                    high: "Protective against heart disease, longevity factor",
                    low: "Increased cardiovascular risk, metabolic syndrome, sedentary lifestyle"
                },
                clinicalNotes: "HDL >60 is cardioprotective. Exercise and weight loss can increase HDL."
            },
            {
                name: "Triglycerides",
                category: "biochemistry",
                unit: "mg/dL",
                normalRanges: [
                    { group: "Normal", range: "<150", low: 0, high: 150 },
                    { group: "Borderline High", range: "150 - 199", low: 150, high: 199 },
                    { group: "High", range: "200 - 499", low: 200, high: 499 },
                    { group: "Very High", range: "≥500", low: 500, high: 2000 }
                ],
                interpretation: {
                    high: "Increased cardiovascular risk, pancreatitis risk (>500), metabolic syndrome, diabetes, alcohol",
                    low: "Malnutrition, malabsorption, hyperthyroidism"
                },
                clinicalNotes: "Must be fasting (12-14 hours). Very high levels (>1000) risk acute pancreatitis."
            },

            // ELECTROLYTES
            {
                name: "Sodium (Na+)",
                category: "biochemistry",
                unit: "mEq/L",
                normalRanges: [
                    { group: "Adult", range: "135 - 145", low: 135, high: 145 }
                ],
                interpretation: {
                    high: "Hypernatremia: dehydration, diabetes insipidus, excessive salt intake, Cushing's",
                    low: "Hyponatremia: SIADH, heart failure, liver disease, kidney disease, vomiting, diarrhea, diuretics"
                },
                clinicalNotes: "Critical: <120 or >160. Rapid correction of chronic hyponatremia can cause brain damage."
            },
            {
                name: "Potassium (K+)",
                category: "biochemistry",
                unit: "mEq/L",
                normalRanges: [
                    { group: "Adult", range: "3.5 - 5.0", low: 3.5, high: 5.0 }
                ],
                interpretation: {
                    high: "Hyperkalemia: kidney failure, medications (ACE inhibitors, spironolactone), acidosis, tissue damage",
                    low: "Hypokalemia: vomiting, diarrhea, diuretics, low intake, alkalosis, insulin"
                },
                clinicalNotes: "CRITICAL: <2.5 or >6.5 (cardiac arrhythmia risk). Check ECG if abnormal. Hemolysis causes false high."
            },
            {
                name: "Chloride (Cl-)",
                category: "biochemistry",
                unit: "mEq/L",
                normalRanges: [
                    { group: "Adult", range: "96 - 106", low: 96, high: 106 }
                ],
                interpretation: {
                    high: "Hyperchloremia: dehydration, metabolic acidosis, respiratory alkalosis",
                    low: "Hypochloremia: vomiting, diarrhea, metabolic alkalosis, heart failure"
                },
                clinicalNotes: "Usually follows sodium. Check anion gap for acid-base disorders."
            },
            {
                name: "Calcium (Ca)",
                category: "biochemistry",
                unit: "mg/dL",
                normalRanges: [
                    { group: "Adult", range: "8.5 - 10.5", low: 8.5, high: 10.5 }
                ],
                interpretation: {
                    high: "Hypercalcemia: hyperparathyroidism, cancer, vitamin D toxicity, immobilization, thiazides",
                    low: "Hypocalcemia: hypoparathyroidism, vitamin D deficiency, kidney disease, low albumin, pancreatitis"
                },
                clinicalNotes: "Correct for albumin: add 0.8 mg/dL for each 1 g/dL albumin below 4. Check ionized calcium if unsure."
            },

            // THYROID
            {
                name: "TSH (Thyroid Stimulating Hormone)",
                category: "hormones",
                unit: "μIU/mL",
                normalRanges: [
                    { group: "Adult", range: "0.4 - 4.0", low: 0.4, high: 4.0 }
                ],
                interpretation: {
                    high: "Hypothyroidism (primary), thyroid hormone resistance",
                    low: "Hyperthyroidism, excessive thyroid hormone replacement, pituitary disorder"
                },
                clinicalNotes: "First-line test for thyroid function. If abnormal, check free T3 and T4."
            },

            // IMMUNOLOGY/SEROLOGY
            {
                name: "HIV Test (Antibody)",
                category: "immunology",
                unit: "Reactive/Non-reactive",
                normalRanges: [
                    { group: "Normal", range: "Non-reactive", low: 0, high: 0 }
                ],
                interpretation: {
                    high: "HIV infection - confirm with Western blot or PCR",
                    low: "No HIV infection detected"
                },
                clinicalNotes: "Window period: 3-12 weeks after exposure. Reactive result requires confirmatory testing. Counsel patient."
            },
            {
                name: "Hepatitis B Surface Antigen (HBsAg)",
                category: "immunology",
                unit: "Reactive/Non-reactive",
                normalRanges: [
                    { group: "Normal", range: "Non-reactive", low: 0, high: 0 }
                ],
                interpretation: {
                    high: "Active HBV infection (acute or chronic)",
                    low: "No current HBV infection"
                },
                clinicalNotes: "Positive >6 months indicates chronic infection. Check HBeAg, anti-HBc, and viral load for status."
            },
            {
                name: "Hepatitis C Antibody (Anti-HCV)",
                category: "immunology",
                unit: "Reactive/Non-reactive",
                normalRanges: [
                    { group: "Normal", range: "Non-reactive", low: 0, high: 0 }
                ],
                interpretation: {
                    high: "HCV exposure (past or current) - confirm with HCV RNA PCR",
                    low: "No HCV exposure"
                },
                clinicalNotes: "Antibody indicates exposure but not active infection. Confirm active infection with HCV RNA."
            },

            // URINE ANALYSIS
            {
                name: "Urine Protein",
                category: "urine",
                unit: "mg/dL",
                normalRanges: [
                    { group: "Normal", range: "Negative or <10", low: 0, high: 10 }
                ],
                interpretation: {
                    high: "Proteinuria: kidney disease, UTI, diabetes, hypertension, preeclampsia, multiple myeloma",
                    low: "Normal finding"
                },
                clinicalNotes: "Persistent proteinuria indicates kidney damage. Quantify with 24-hour urine collection or spot protein/creatinine ratio."
            },
            {
                name: "Urine Glucose",
                category: "urine",
                unit: "mg/dL",
                normalRanges: [
                    { group: "Normal", range: "Negative", low: 0, high: 0 }
                ],
                interpretation: {
                    high: "Glucosuria: diabetes (blood glucose >180), renal tubular disease, pregnancy",
                    low: "Normal finding"
                },
                clinicalNotes: "Glucose appears in urine when blood glucose exceeds renal threshold (~180 mg/dL)."
            },
            {
                name: "Urine RBC (Red Blood Cells)",
                category: "urine",
                unit: "cells/HPF",
                normalRanges: [
                    { group: "Normal", range: "0 - 2", low: 0, high: 2 }
                ],
                interpretation: {
                    high: "Hematuria: UTI, kidney stones, glomerulonephritis, trauma, cancer, menstruation",
                    low: "Normal finding"
                },
                clinicalNotes: "Microscopic hematuria requires investigation. Check for casts, protein. Rule out malignancy in older patients."
            },
            {
                name: "Urine WBC (White Blood Cells)",
                category: "urine",
                unit: "cells/HPF",
                normalRanges: [
                    { group: "Normal", range: "0 - 5", low: 0, high: 5 }
                ],
                interpretation: {
                    high: "Pyuria: UTI, pyelonephritis, urethritis, interstitial nephritis, contamination",
                    low: "Normal finding"
                },
                clinicalNotes: "If elevated with bacteria, suggests UTI. If elevated without bacteria (sterile pyuria), consider TB, stones, cancer."
            }
        ];

        $(document).ready(function() {
            displayTests(testDatabase);
            
            $('#searchBox').on('keyup', filterTests);
            $('#categoryFilter').on('change', filterTests);
        });

        function displayTests(tests) {
            var html = '';
            
            tests.forEach(function(test) {
                html += '<div class="test-card" data-category="' + test.category + '">';
                html += '<div class="test-header">';
                html += '<div class="test-name">' + test.name + '</div>';
                html += '<div class="test-category">' + test.category.toUpperCase() + '</div>';
                html += '</div>';
                
                // Normal ranges table
                html += '<table class="range-table">';
                html += '<thead><tr><th>Population Group</th><th>Normal Range</th><th>Unit</th></tr></thead>';
                html += '<tbody>';
                test.normalRanges.forEach(function(range) {
                    html += '<tr>';
                    html += '<td>' + range.group + '</td>';
                    html += '<td class="normal-range">' + range.range + '</td>';
                    html += '<td>' + test.unit + '</td>';
                    html += '</tr>';
                });
                html += '</tbody></table>';
                
                // Interpretation
                html += '<div class="interpretation">';
                html += '<strong><i class="fas fa-info-circle"></i> Clinical Interpretation:</strong><br>';
                html += '<strong class="abnormal-high">↑ High Values:</strong> ' + test.interpretation.high + '<br>';
                html += '<strong class="abnormal-low">↓ Low Values:</strong> ' + test.interpretation.low;
                html += '</div>';
                
                // Clinical notes
                if (test.clinicalNotes) {
                    html += '<div class="clinical-note">';
                    html += '<strong><i class="fas fa-exclamation-triangle"></i> Important Notes:</strong> ' + test.clinicalNotes;
                    html += '</div>';
                }
                
                html += '</div>';
            });
            
            $('#testReference').html(html);
        }

        function filterTests() {
            var searchTerm = $('#searchBox').val().toLowerCase();
            var category = $('#categoryFilter').val();
            
            var filtered = testDatabase.filter(function(test) {
                var matchesSearch = test.name.toLowerCase().includes(searchTerm) || 
                                  test.interpretation.high.toLowerCase().includes(searchTerm) ||
                                  test.interpretation.low.toLowerCase().includes(searchTerm);
                var matchesCategory = !category || test.category === category;
                
                return matchesSearch && matchesCategory;
            });
            
            displayTests(filtered);
        }

        function printReference() {
            window.print();
        }
    </script>
    
    <!-- Watermark -->
    <div class="print-watermark">
        <img src="assets/vafmadow.png" alt="Hospital Logo Watermark" />
    </div>
</asp:Content>