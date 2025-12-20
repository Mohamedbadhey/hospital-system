using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace juba_hospital
{
    public partial class inpatient_full_report : System.Web.UI.Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Add hospital print header
                PrintHeaderLiteral.Text = HospitalSettingsHelper.GetPrintHeaderHTML();
                
                string patientId = Request.QueryString["patientid"];
                string prescid = Request.QueryString["prescid"];

                if (!string.IsNullOrEmpty(patientId))
                {
                    LoadInpatientFullReport(patientId, prescid);
                }
                else
                {
                    reportContent.InnerHtml = "<div class='alert alert-danger'>Invalid patient ID</div>";
                }
            }
        }

        private void LoadInpatientFullReport(string patientId, string prescid)
        {
            StringBuilder html = new StringBuilder();

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Section 1: Patient Information
                html.Append(GetPatientInfo(con, patientId));

                // Section 2: Admission Information (Inpatient specific)
                html.Append(GetAdmissionInfo(con, patientId));

                // Section 3: Medications
                html.Append(GetMedications(con, patientId));

                // Section 4: Lab Tests - ALL ORDERS WITH INDIVIDUAL RESULTS
                html.Append(GetAllLabTestsWithResults(con, patientId));

                // Section 5: X-Ray Tests
                html.Append(GetXrayTests(con, patientId));

                // Section 6: Charges and Payment
                html.Append(GetCharges(con, patientId));

                // Section 7: Patient History
                html.Append(GetPatientHistory(con, patientId));

                // Section 8: Summary
                html.Append(GetSummary(con, patientId));
            }

            reportContent.InnerHtml = html.ToString();
        }

        private string GetPatientInfo(SqlConnection con, string patientId)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title'>📋 PATIENT INFORMATION</div>");

            string query = @"
                SELECT patientid, full_name, dob, sex, phone, location, date_registered
                FROM patient
                WHERE patientid = @patientId";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@patientId", patientId);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        html.Append($"<div class='info-row'><div class='info-label'>Patient ID:</div><div class='info-value'><strong>{dr["patientid"]}</strong></div></div>");
                        html.Append($"<div class='info-row'><div class='info-label'>Full Name:</div><div class='info-value'><strong style='font-size:18px;'>{dr["full_name"]}</strong></div></div>");
                        
                        DateTime dob = Convert.ToDateTime(dr["dob"]);
                        int age = DateTimeHelper.Now.Year - dob.Year;
                        if (DateTimeHelper.Now < dob.AddYears(age)) age--;
                        
                        html.Append($"<div class='info-row'><div class='info-label'>Date of Birth:</div><div class='info-value'>{dob.ToString("MMMM dd, yyyy")} ({age} years old)</div></div>");
                        html.Append($"<div class='info-row'><div class='info-label'>Sex:</div><div class='info-value'>{dr["sex"]}</div></div>");
                        html.Append($"<div class='info-row'><div class='info-label'>Phone:</div><div class='info-value'>{dr["phone"]}</div></div>");
                        html.Append($"<div class='info-row'><div class='info-label'>Location:</div><div class='info-value'>{dr["location"]}</div></div>");
                        html.Append($"<div class='info-row'><div class='info-label'>Registration Date:</div><div class='info-value'>{Convert.ToDateTime(dr["date_registered"]).ToString("MMMM dd, yyyy hh:mm tt")}</div></div>");
                    }
                }
            }

            html.Append("</div>");
            return html.ToString();
        }

        private string GetAdmissionInfo(SqlConnection con, string patientId)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title inpatient'>🏥 ADMISSION INFORMATION</div>");

            string query = @"
                SELECT 
                    bed_admission_date,
                    DATEDIFF(DAY, bed_admission_date, GETDATE()) as days_admitted,
                    patient_status
                FROM patient
                WHERE patientid = @patientId";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@patientId", patientId);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        if (dr["bed_admission_date"] != DBNull.Value)
                        {
                            DateTime admissionDate = Convert.ToDateTime(dr["bed_admission_date"]);
                            int daysAdmitted = Convert.ToInt32(dr["days_admitted"]);
                            
                            html.Append("<div class='admission-info'>");
                            html.Append($"<div class='info-row'><div class='info-label'>Admission Date:</div><div class='info-value'><strong>{admissionDate.ToString("MMMM dd, yyyy hh:mm tt")}</strong></div></div>");
                            html.Append($"<div class='info-row'><div class='info-label'>Length of Stay:</div><div class='info-value'><span class='highlight'>{daysAdmitted} Days</span></div></div>");
                            html.Append($"<div class='info-row'><div class='info-label'>Status:</div><div class='info-value'><span class='badge badge-success'>Active Inpatient</span></div></div>");
                            html.Append("</div>");
                        }
                        else
                        {
                            html.Append("<div class='no-data'>No admission information available</div>");
                        }
                    }
                }
            }

            html.Append("</div>");
            return html.ToString();
        }

        private string GetMedications(SqlConnection con, string patientId)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title medication'>💊 MEDICATIONS PRESCRIBED</div>");

            string query = @"
                SELECT 
                    m.med_name, 
                    m.dosage, 
                    m.frequency, 
                    m.duration, 
                    m.special_inst, 
                    m.date_taken,
                    pr.prescid
                FROM medication m
                INNER JOIN prescribtion pr ON m.prescid = pr.prescid
                WHERE pr.patientid = @patientId
                ORDER BY m.date_taken DESC, m.medid DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@patientId", patientId);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.HasRows)
                    {
                        html.Append("<table style='border-collapse: collapse; width: 100%;'>");
                        html.Append("<thead><tr>");
                        html.Append("<th style='padding: 10px; border: 1px solid #bdc3c7; background: #ecf0f1;'>Date Prescribed</th>");
                        html.Append("<th style='padding: 10px; border: 1px solid #bdc3c7; background: #ecf0f1;'>Medication</th>");
                        html.Append("<th style='padding: 10px; border: 1px solid #bdc3c7; background: #ecf0f1;'>Dosage</th>");
                        html.Append("<th style='padding: 10px; border: 1px solid #bdc3c7; background: #ecf0f1;'>Frequency</th>");
                        html.Append("<th style='padding: 10px; border: 1px solid #bdc3c7; background: #ecf0f1;'>Duration</th>");
                        html.Append("<th style='padding: 10px; border: 1px solid #bdc3c7; background: #ecf0f1;'>Special Instructions</th>");
                        html.Append("</tr></thead><tbody>");

                        while (dr.Read())
                        {
                            html.Append("<tr>");
                            html.Append($"<td style='padding: 10px; border: 1px solid #ddd;'>{(dr["date_taken"] != DBNull.Value ? Convert.ToDateTime(dr["date_taken"]).ToString("MMM dd, yyyy") : "-")}</td>");
                            html.Append($"<td style='padding: 10px; border: 1px solid #ddd;'><strong>{dr["med_name"]}</strong></td>");
                            html.Append($"<td style='padding: 10px; border: 1px solid #ddd;'>{dr["dosage"]}</td>");
                            html.Append($"<td style='padding: 10px; border: 1px solid #ddd;'>{dr["frequency"]}</td>");
                            html.Append($"<td style='padding: 10px; border: 1px solid #ddd;'>{dr["duration"]}</td>");
                            html.Append($"<td style='padding: 10px; border: 1px solid #ddd;'>{(dr["special_inst"] != DBNull.Value ? dr["special_inst"].ToString() : "-")}</td>");
                            html.Append("</tr>");
                        }

                        html.Append("</tbody></table>");
                    }
                    else
                    {
                        html.Append("<div class='no-data'>No medications prescribed</div>");
                    }
                }
            }

            html.Append("</div>");
            return html.ToString();
        }

        private string GetAllLabTestsWithResults(SqlConnection con, string patientId)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title lab'>🔬 LABORATORY TESTS - ALL ORDERS</div>");

            // Get all LAB ORDERS (each med_id is a separate order) for this patient
            string prescQuery = @"
                SELECT 
                    lt.med_id as order_id,
                    lt.prescid,
                    pr.status,
                    lt.date_taken as order_date,
                    CASE WHEN lr.lab_result_id IS NOT NULL THEN 'Completed' ELSE 'Pending' END as order_status
                FROM lab_test lt
                INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
                LEFT JOIN lab_results lr ON lt.prescid = lr.prescid AND lr.lab_test_id = lt.med_id
                WHERE pr.patientid = @patientId 
                    AND pr.status >= 4
                ORDER BY lt.date_taken DESC, lt.med_id DESC";

            using (SqlCommand cmd = new SqlCommand(prescQuery, con))
            {
                cmd.Parameters.AddWithValue("@patientId", patientId);
                
                DataTable prescriptions = new DataTable();
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(prescriptions);
                }

                if (prescriptions.Rows.Count > 0)
                {
                    int orderNumber = 1;
                    foreach (DataRow prescRow in prescriptions.Rows)
                    {
                        string orderId = prescRow["order_id"].ToString();
                        string prescid = prescRow["prescid"].ToString();
                        DateTime orderDate = prescRow["order_date"] != DBNull.Value 
                            ? Convert.ToDateTime(prescRow["order_date"]) 
                            : DateTimeHelper.Now;
                        string orderStatus = prescRow["order_status"].ToString();

                        html.Append("<div class='lab-test-order'>");
                        html.Append($"<div class='lab-test-header'>");
                        html.Append($"LAB ORDER #{orderNumber} - Order ID: {orderId} (Prescription: {prescid})");
                        html.Append("</div>");

                        // Status and dates
                        html.Append("<div class='info-row'>");
                        html.Append("<div class='info-label'>Status:</div>");
                        html.Append($"<div class='info-value'>{(orderStatus == "Completed" ? "<span class='badge badge-success'>Completed</span>" : "<span class='badge badge-warning'>Pending</span>")}</div>");
                        html.Append("</div>");

                        html.Append("<div class='info-row'>");
                        html.Append("<div class='info-label'>Ordered Date:</div>");
                        html.Append($"<div class='info-value'>{orderDate.ToString("MMMM dd, yyyy hh:mm tt")}</div>");
                        html.Append("</div>");

                        // Get tests ordered and results for THIS specific order
                        html.Append(GetLabTestDetailsForOrder(con, orderId, prescid, orderStatus));

                        html.Append("</div>");
                        orderNumber++;
                    }
                }
                else
                {
                    html.Append("<div class='no-data'>No laboratory tests ordered</div>");
                }
            }

            html.Append("</div>");
            return html.ToString();
        }

        private string GetLabTestDetailsForOrder(SqlConnection con, string orderId, string prescid, string orderStatus)
        {
            StringBuilder html = new StringBuilder();

            // Get all lab test columns
            string[] labTests = new string[]
            {
                "Low_density_lipoprotein_LDL", "High_density_lipoprotein_HDL", "Total_cholesterol", "Triglycerides",
                "SGPT_ALT", "SGOT_AST", "Alkaline_phosphates_ALP", "Total_bilirubin", "Direct_bilirubin", 
                "Albumin", "JGlobulin", "Urea", "Creatinine", "Uric_acid",
                "Sodium", "Potassium", "Chloride", "Calcium", "Phosphorous", "Magnesium",
                "Amylase", "Hemoglobin", "Malaria", "ESR", "Blood_grouping", "Blood_sugar",
                "CBC", "Cross_matching", "TPHA", "Human_immune_deficiency_HIV", 
                "Hepatitis_B_virus_HBV", "Hepatitis_C_virus_HCV", "Brucella_melitensis",
                "Brucella_abortus", "C_Reactive_Protein_CRP", "Rheumatoid_Factor_RF",
                "Antistreptolysin_O_ASO", "Toxoplasmosis", "H_pylori_antibody",
                "Triiodothyronine_T3", "Thyroxine_T4", "Thyroid_stimulating_hormone_TSH",
                "Follicle_stimulating_hormone_FSH", "Luteinizing_hormone_LH",
                "Progesterone_female", "Testosterone_male", "Estradiol", "Prolactin",
                "Human_chorionic_gonadotropin_HCG", "General_urine_examination",
                "Stool_examination", "Stool_for_occult_blood", "Sperm_examination",
                "Vaginal_swab", "H_pylori_antigen_stool", "Fasting_blood_sugar_FBS",
                "Hemoglobin_A1c_HbA1c"
            };

            string[] testLabels = new string[]
            {
                "Low Density Lipoprotein (LDL)", "High Density Lipoprotein (HDL)", "Total Cholesterol", "Triglycerides",
                "SGPT/ALT", "SGOT/AST", "Alkaline Phosphatase (ALP)", "Total Bilirubin", "Direct Bilirubin",
                "Albumin", "Globulin", "Urea", "Creatinine", "Uric Acid",
                "Sodium", "Potassium", "Chloride", "Calcium", "Phosphorous", "Magnesium",
                "Amylase", "Hemoglobin", "Malaria Test", "ESR", "Blood Grouping", "Blood Sugar",
                "Complete Blood Count (CBC)", "Cross Matching", "TPHA (Syphilis)", "HIV Test",
                "Hepatitis B (HBV)", "Hepatitis C (HCV)", "Brucella Melitensis",
                "Brucella Abortus", "C-Reactive Protein (CRP)", "Rheumatoid Factor (RF)",
                "Antistreptolysin O (ASO)", "Toxoplasmosis", "H. Pylori Antibody",
                "Triiodothyronine (T3)", "Thyroxine (T4)", "Thyroid Stimulating Hormone (TSH)",
                "Follicle Stimulating Hormone (FSH)", "Luteinizing Hormone (LH)",
                "Progesterone (Female)", "Testosterone (Male)", "Estradiol", "Prolactin",
                "Beta-HCG (Pregnancy Test)", "General Urine Examination",
                "Stool Examination", "Stool for Occult Blood", "Sperm Examination",
                "Vaginal Swab", "H. Pylori Antigen (Stool)", "Fasting Blood Sugar (FBS)",
                "Hemoglobin A1c (HbA1c)"
            };

            // Get ordered tests FOR THIS SPECIFIC ORDER (med_id)
            string orderedQuery = "SELECT * FROM lab_test WHERE med_id = @orderId";
            DataTable orderedTests = new DataTable();
            
            using (SqlCommand cmd = new SqlCommand(orderedQuery, con))
            {
                cmd.Parameters.AddWithValue("@orderId", orderId);
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(orderedTests);
                }
            }

            // Get results FOR THIS SPECIFIC ORDER (matching lab_test_id)
            string resultsQuery = "SELECT * FROM lab_results WHERE lab_test_id = @orderId";
            DataTable results = new DataTable();
            
            using (SqlCommand cmd = new SqlCommand(resultsQuery, con))
            {
                cmd.Parameters.AddWithValue("@orderId", orderId);
                using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(results);
                }
            }

            bool hasOrders = orderedTests.Rows.Count > 0;
            bool hasResults = results.Rows.Count > 0;

            if (!hasOrders)
            {
                html.Append("<div class='no-data'>No tests ordered for this prescription</div>");
                return html.ToString();
            }

            // Build list of ordered tests and results FOR THIS SPECIFIC PRESCRIPTION
            // NOTE: A prescription can have MULTIPLE lab_test rows (multiple orders/reorders)
            // We need to loop through ALL rows
            
            var orderedTestsList = new System.Collections.Generic.List<string>();
            var testResultsDict = new System.Collections.Generic.Dictionary<string, string>();

            // Loop through ALL lab_test rows for this prescription
            foreach (DataRow orderedRow in orderedTests.Rows)
            {
                // Find matching result row (if any)
                DataRow resultRow = null;
                if (hasResults)
                {
                    // Try to match by laborderid or med_id if available
                    if (orderedTests.Columns.Contains("med_id") && results.Columns.Contains("lab_result_id"))
                    {
                        int medId = Convert.ToInt32(orderedRow["med_id"]);
                        foreach (DataRow resRow in results.Rows)
                        {
                            // Check if this result matches this order
                            if (resRow["prescid"].ToString() == prescid)
                            {
                                resultRow = resRow;
                                break;
                            }
                        }
                    }
                    else
                    {
                        resultRow = results.Rows[0];  // Fallback to first result
                    }
                }

                // Loop through all columns in THIS lab_test row to find ordered tests
                foreach (System.Data.DataColumn col in orderedTests.Columns)
            {
                string columnName = col.ColumnName;
                
                // Skip ID and date columns
                if (columnName.ToLower().Contains("id") || 
                    columnName.ToLower().Contains("date") || 
                    columnName.ToLower().Contains("prescid") ||
                    columnName.ToLower() == "type")
                {
                    continue;
                }

                // Check if this test was ordered (has a non-null, non-empty value)
                if (orderedRow[columnName] != DBNull.Value)
                {
                    string orderValue = orderedRow[columnName].ToString().Trim();
                    
                    // Test is ordered if it has any value (not empty, not "not checked")
                    if (!string.IsNullOrEmpty(orderValue) && 
                        !orderValue.Equals("not checked", StringComparison.OrdinalIgnoreCase) &&
                        !orderValue.Equals("0", StringComparison.OrdinalIgnoreCase) &&
                        !orderValue.Equals("false", StringComparison.OrdinalIgnoreCase))
                    {
                        // Humanize the column name
                        string testLabel = Humanize(columnName);
                        orderedTestsList.Add(testLabel);

                        // Check if result exists
                        if (resultRow != null && results.Columns.Contains(columnName) && resultRow[columnName] != DBNull.Value)
                        {
                            string resultValue = resultRow[columnName].ToString().Trim();
                            if (!string.IsNullOrEmpty(resultValue) && 
                                !resultValue.Equals("not checked", StringComparison.OrdinalIgnoreCase) &&
                                !resultValue.Equals("0", StringComparison.OrdinalIgnoreCase))
                            {
                                testResultsDict[testLabel] = resultValue;
                            }
                        }
                    }
                }
            }  // End loop through columns
            }  // End loop through all lab_test rows

            // Display tests ordered as a list
            if (orderedTestsList.Count > 0)
            {
                html.Append("<div class='info-row' style='margin-top:15px'>");
                html.Append("<div class='info-label'>Tests Ordered:</div>");
                html.Append("<div class='info-value'><ul style='margin:0; padding-left:20px; line-height:1.8;'>");
                
                // Remove duplicates and sort
                var uniqueTests = new System.Collections.Generic.HashSet<string>(orderedTestsList);
                var sortedTests = new System.Collections.Generic.List<string>(uniqueTests);
                sortedTests.Sort();
                
                foreach (var test in sortedTests)
                {
                    html.Append($"<li style='margin-bottom:5px;'>{test}</li>");
                }
                html.Append("</ul></div>");
                html.Append("</div>");

                // Display results if available (order status = Completed)
                if (orderStatus == "Completed" && testResultsDict.Count > 0)
                {
                    html.Append("<div style='margin-top:15px'>");
                    html.Append("<strong>Lab Results:</strong>");
                    html.Append("<table style='margin-top:10px; border-collapse:collapse; width:100%; border:1px solid #ddd'>");
                    html.Append("<tr><th style='background:#ecf0f1; padding:12px; border:1px solid #bdc3c7; text-align:left;'>Test</th><th style='background:#ecf0f1; padding:12px; border:1px solid #bdc3c7; text-align:left;'>Result</th></tr>");

                    foreach (var kvp in testResultsDict)
                    {
                        html.Append("<tr>");
                        html.Append($"<td style='padding:10px; border:1px solid #ddd; vertical-align:top;'><strong>{kvp.Key}</strong></td>");
                        html.Append($"<td style='padding:10px; border:1px solid #ddd; vertical-align:top;'>{kvp.Value}</td>");
                        html.Append("</tr>");
                    }

                    html.Append("</table>");
                    html.Append("</div>");
                }
                else if (orderStatus == "Pending")
                {
                    html.Append("<div style='margin-top:15px; padding:10px; background:#fff3cd; border-left:4px solid #ffc107'>");
                    html.Append("<strong>Note:</strong> Lab tests are pending. Results not yet available.");
                    html.Append("</div>");
                }
            }
            else
            {
                html.Append("<div style='margin-top:15px; padding:10px; background:#f0f0f0; border-left:4px solid #999'>");
                html.Append("<em>No tests were found for this lab order.</em>");
                html.Append("</div>");
            }

            return html.ToString();
        }  // End of GetLabTestDetails method

        private string Humanize(string columnName)
        {
            // Convert column names to readable format
            return columnName
                .Replace("_", " ")
                .Replace("  ", " ")
                .Trim();
        }

        private string GetLabStatusText(int status)
        {
            switch (status)
            {
                case 0: return "Waiting";
                case 1: return "Processed";
                case 2: return "Pending X-ray";
                case 3: return "X-ray Processed";
                case 4: return "Pending Lab";
                case 5: return "Lab Processed";
                default: return "Unknown";
            }
        }

        private string GetXrayTests(SqlConnection con, string patientId)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title xray'>📷 X-RAY EXAMINATIONS</div>");

            string query = @"
                SELECT 
                    pr.prescid,
                    pr.xray_status,
                    x.xryname as xray_name,
                    xr.xray_result_id,
                    pc.date_added as order_date
                FROM prescribtion pr
                LEFT JOIN presxray px ON pr.prescid = px.prescid
                LEFT JOIN xray x ON px.xrayid = x.xrayid
                LEFT JOIN xray_results xr ON pr.prescid = xr.prescid
                LEFT JOIN patient_charges pc ON pr.patientid = pc.patientid 
                    AND pr.prescid = pc.prescid 
                    AND pc.charge_type = 'Xray'
                WHERE pr.patientid = @patientId AND pr.xray_status > 0
                ORDER BY pr.prescid DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@patientId", patientId);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.HasRows)
                    {
                        html.Append("<table>");
                        html.Append("<thead><tr>");
                        html.Append("<th>Prescription ID</th>");
                        html.Append("<th>X-ray Type</th>");
                        html.Append("<th>Order Date</th>");
                        html.Append("<th>Status</th>");
                        html.Append("<th>Result Available</th>");
                        html.Append("</tr></thead><tbody>");

                        while (dr.Read())
                        {
                            int xrayStatus = Convert.ToInt32(dr["xray_status"]);
                            bool hasResult = dr["xray_result_id"] != DBNull.Value;
                            
                            html.Append("<tr>");
                            html.Append($"<td>{dr["prescid"]}</td>");
                            html.Append($"<td>{(dr["xray_name"] != DBNull.Value ? dr["xray_name"].ToString() : "X-ray")}</td>");
                            html.Append($"<td>{(dr["order_date"] != DBNull.Value ? Convert.ToDateTime(dr["order_date"]).ToString("MMM dd, yyyy") : "-")}</td>");
                            html.Append($"<td>{GetXrayStatusBadge(xrayStatus)}</td>");
                            html.Append($"<td>{(hasResult ? "<span class='badge badge-success'>Yes</span>" : "<span class='badge badge-warning'>Pending</span>")}</td>");
                            html.Append("</tr>");
                        }

                        html.Append("</tbody></table>");
                    }
                    else
                    {
                        html.Append("<div class='no-data'>No X-ray examinations ordered</div>");
                    }
                }
            }

            html.Append("</div>");
            return html.ToString();
        }

        private string GetXrayStatusBadge(int status)
        {
            switch (status)
            {
                case 0: return "<span class='badge badge-secondary'>Not Ordered</span>";
                case 1: return "<span class='badge badge-warning'>Pending</span>";
                case 2: return "<span class='badge badge-success'>Completed</span>";
                default: return "<span class='badge badge-secondary'>Unknown</span>";
            }
        }

        private string GetCharges(SqlConnection con, string patientId)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title charges'>💰 CHARGES & PAYMENTS</div>");

            string query = @"
                SELECT 
                    charge_type, 
                    charge_name, 
                    amount, 
                    is_paid, 
                    payment_method, 
                    date_added,
                    paid_date
                FROM patient_charges
                WHERE patientid = @patientId
                ORDER BY date_added DESC";

            decimal totalCharges = 0;
            decimal totalPaid = 0;
            decimal totalUnpaid = 0;

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@patientId", patientId);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.HasRows)
                    {
                        html.Append("<table>");
                        html.Append("<thead><tr>");
                        html.Append("<th>Date</th>");
                        html.Append("<th>Type</th>");
                        html.Append("<th>Description</th>");
                        html.Append("<th>Amount</th>");
                        html.Append("<th>Payment Status</th>");
                        html.Append("<th>Payment Method</th>");
                        html.Append("</tr></thead><tbody>");

                        while (dr.Read())
                        {
                            decimal amount = Convert.ToDecimal(dr["amount"]);
                            bool isPaid = Convert.ToBoolean(dr["is_paid"]);
                            totalCharges += amount;
                            
                            if (isPaid)
                                totalPaid += amount;
                            else
                                totalUnpaid += amount;

                            html.Append("<tr>");
                            html.Append($"<td>{Convert.ToDateTime(dr["date_added"]).ToString("MMM dd, yyyy")}</td>");
                            html.Append($"<td>{dr["charge_type"]}</td>");
                            html.Append($"<td>{dr["charge_name"]}</td>");
                            html.Append($"<td>${amount:N2}</td>");
                            html.Append($"<td>{(isPaid ? "<span class='badge badge-success'>Paid</span>" : "<span class='badge badge-danger'>Unpaid</span>")}</td>");
                            html.Append($"<td>{(dr["payment_method"] != DBNull.Value ? dr["payment_method"].ToString() : "-")}</td>");
                            html.Append("</tr>");
                        }

                        html.Append("<tr class='total-row'>");
                        html.Append("<td colspan='3'><strong>TOTAL CHARGES</strong></td>");
                        html.Append($"<td colspan='3'><strong>${totalCharges:N2}</strong></td>");
                        html.Append("</tr>");
                        
                        html.Append("<tr style='background: #d4edda;'>");
                        html.Append("<td colspan='3'><strong>TOTAL PAID</strong></td>");
                        html.Append($"<td colspan='3'><strong>${totalPaid:N2}</strong></td>");
                        html.Append("</tr>");
                        
                        html.Append("<tr style='background: #f8d7da;'>");
                        html.Append("<td colspan='3'><strong>TOTAL UNPAID</strong></td>");
                        html.Append($"<td colspan='3'><strong>${totalUnpaid:N2}</strong></td>");
                        html.Append("</tr>");

                        html.Append("</tbody></table>");
                    }
                    else
                    {
                        html.Append("<div class='no-data'>No charges recorded</div>");
                    }
                }
            }

            html.Append("</div>");
            return html.ToString();
        }

        private string GetPatientHistory(SqlConnection con, string patientId)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title'>📋 PATIENT HISTORY RECORDS</div>");

            string query = @"
                SELECT 
                    history_id,
                    history_text,
                    created_date,
                    last_updated,
                    created_by,
                    updated_by
                FROM patient_history
                WHERE patientid = @patientId
                ORDER BY created_date DESC";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@patientId", patientId);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.HasRows)
                    {
                        int recordNumber = 1;
                        while (dr.Read())
                        {
                            html.Append("<div style='margin-bottom:20px; border:1px solid #ddd; border-radius:5px; padding:15px; background:#f8f9fa;'>");
                            
                            // Header with date
                            html.Append("<div style='background:#667eea; color:white; padding:8px 12px; margin:-15px -15px 15px -15px; border-radius:5px 5px 0 0; font-weight:bold;'>");
                            html.Append($"History Record #{recordNumber}");
                            html.Append("</div>");
                            
                            // Date information
                            html.Append("<div style='margin-bottom:10px; color:#666; font-size:13px;'>");
                            html.Append($"<strong>Recorded:</strong> {Convert.ToDateTime(dr["created_date"]).ToString("MMMM dd, yyyy hh:mm tt")}");
                            
                            if (dr["last_updated"] != DBNull.Value)
                            {
                                html.Append($" | <strong>Last Updated:</strong> {Convert.ToDateTime(dr["last_updated"]).ToString("MMMM dd, yyyy hh:mm tt")}");
                            }
                            html.Append("</div>");
                            
                            // History text content
                            html.Append("<div style='background:white; padding:15px; border-radius:5px; border-left:4px solid #667eea; white-space:pre-wrap; line-height:1.6;'>");
                            html.Append(System.Web.HttpUtility.HtmlEncode(dr["history_text"].ToString()));
                            html.Append("</div>");
                            
                            html.Append("</div>");
                            recordNumber++;
                        }
                    }
                    else
                    {
                        html.Append("<div class='alert alert-info' style='background:#d1ecf1; border:1px solid #bee5eb; padding:15px; border-radius:5px;'>");
                        html.Append("<strong>No History Records:</strong> No patient history has been recorded for this patient.");
                        html.Append("</div>");
                    }
                }
            }

            html.Append("</div>");
            return html.ToString();
        }

        private string GetSummary(SqlConnection con, string patientId)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title'>📊 SUMMARY</div>");

            html.Append("<div class='summary-box'>");
            html.Append("<h5>Report Summary</h5>");
            html.Append("<p>This comprehensive inpatient report contains all medical records, laboratory test results, medications, X-ray examinations, and financial charges for the patient's admission period.</p>");
            html.Append($"<p><strong>Report Generated:</strong> {DateTimeHelper.Now.ToString("MMMM dd, yyyy hh:mm tt")}</p>");
            html.Append("<p><strong>Report Type:</strong> Inpatient Comprehensive Medical Report</p>");
            html.Append("</div>");

            html.Append("</div>");
            return html.ToString();
        }
    }
}
