using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class lab_orders_print : Page
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Add dynamic favicon
            AddFavicon();
            
            if (IsPostBack)
            {
                return;
            }

            // Add hospital print header
            PrintHeaderLiteral.Text = HospitalSettingsHelper.GetPrintHeaderHTML();

            int prescid = 0;
            
            // Try to get prescid from query string
            string prescidValue = Request.QueryString["prescid"];
            string orderIdValue = Request.QueryString["order_id"];
            
            // Debug info
            string debugInfo = $"prescid param: '{prescidValue}', order_id param: '{orderIdValue}'";
            
            if (!string.IsNullOrEmpty(prescidValue) && int.TryParse(prescidValue, out prescid))
            {
                // Got prescid directly
            }
            else if (!string.IsNullOrEmpty(orderIdValue) && int.TryParse(orderIdValue, out int orderId))
            {
                // Try to get order_id and lookup the prescid
                try
                {
                    using (var connection = new SqlConnection(ConnectionString))
                    {
                        connection.Open();
                        using (var cmd = new SqlCommand("SELECT prescid FROM lab_test WHERE med_id = @orderId", connection))
                        {
                            cmd.Parameters.AddWithValue("@orderId", orderId);
                            object result = cmd.ExecuteScalar();
                            if (result != null && int.TryParse(result.ToString(), out prescid))
                            {
                                // Got prescid from order_id
                            }
                            else
                            {
                                ShowError($"Lab order #{orderId} not found in database. The order may have been deleted or does not exist.");
                                return;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowError($"Database error while looking up order #{orderId}: {ex.Message}");
                    return;
                }
            }
            else
            {
                ShowError($"Invalid or missing prescription ID. Please access this page from a valid patient record.<br/><small>Debug: {debugInfo}</small>");
                return;
            }

            try
            {
                using (var connection = new SqlConnection(ConnectionString))
                {
                    connection.Open();

                    // Load patient information
                    LoadPatientInfo(connection, prescid);

                    // Load lab orders
                    LoadLabOrders(connection, prescid);
                }

                ContentPanel.Visible = true;
                ErrorPanel.Visible = false;
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while loading the lab orders report: " + ex.Message);
            }
        }

        private void LoadPatientInfo(SqlConnection connection, int prescid)
        {
            string query = @"
                SELECT 
                    p.patientid,
                    p.full_name,
                    p.date_registered,
                    ISNULL(d.doctorname, '') as doctorname,
                    ISNULL(d.doctortitle, '') as doctortitle
                FROM prescribtion pr
                INNER JOIN patient p ON pr.patientid = p.patientid
                LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                WHERE pr.prescid = @prescid";

            using (var cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@prescid", prescid);
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        PatientNameLiteral.Text = reader["full_name"]?.ToString() ?? "—";
                        PatientIdLiteral.Text = reader["patientid"]?.ToString() ?? "—";
                        
                        string doctorName = reader["doctorname"]?.ToString() ?? "";
                        string doctorTitle = reader["doctortitle"]?.ToString() ?? "";
                        DoctorLiteral.Text = string.IsNullOrWhiteSpace(doctorTitle) 
                            ? (string.IsNullOrWhiteSpace(doctorName) ? "—" : doctorName)
                            : $"{doctorTitle} ({doctorName})";

                        DateLiteral.Text = DateTimeHelper.Now.ToString("dd MMM yyyy HH:mm");
                    }
                    else
                    {
                        ShowError("Patient information not found for the given prescription ID.");
                    }
                }
            }
        }

        private void LoadLabOrders(SqlConnection connection, int prescid)
        {
            var orders = new List<LabOrder>();

            // Get all lab test order IDs for this prescription (avoiding ambiguous columns)
            string orderIdsQuery = @"
                SELECT 
                    lt.med_id,
                    lt.date_taken,
                    lt.is_reorder
                FROM lab_test lt
                WHERE lt.prescid = @prescid 
                ORDER BY lt.date_taken DESC, lt.med_id DESC";

            using (var cmd = new SqlCommand(orderIdsQuery, connection))
            {
                cmd.Parameters.AddWithValue("@prescid", prescid);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var order = new LabOrder
                        {
                            OrderId = reader["med_id"] != DBNull.Value ? Convert.ToInt32(reader["med_id"]) : 0,
                            OrderDate = reader["date_taken"] != DBNull.Value ? Convert.ToDateTime(reader["date_taken"]).ToString("dd MMM yyyy") : "",
                            IsReorder = reader["is_reorder"] != DBNull.Value && Convert.ToBoolean(reader["is_reorder"]),
                            OrderedTests = new List<string>(),
                            Results = new List<TestResult>()
                        };
                        orders.Add(order);
                    }
                }
            }

            // For each order, get the detailed tests and results
            foreach (var order in orders)
            {
                // Get ordered tests using UNPIVOT (same method as tab display)
                string orderedQuery = @"
                    SELECT TestName
                    FROM (
                        SELECT
                            Hemoglobin, Malaria, ESR, Blood_grouping, Blood_sugar, CBC, 
                            Cross_matching, TPHA, Human_immune_deficiency_HIV, 
                            Hepatitis_B_virus_HBV, Hepatitis_C_virus_HCV,
                            Low_density_lipoprotein_LDL, High_density_lipoprotein_HDL,
                            Total_cholesterol, Triglycerides, SGPT_ALT, SGOT_AST,
                            Alkaline_phosphates_ALP, Total_bilirubin, Direct_bilirubin,
                            Albumin, Urea, Creatinine, Uric_acid, Sodium, Potassium,
                            Chloride, Calcium, Phosphorous, Magnesium,
                            General_urine_examination, Progesterone_Female, Amylase,
                            JGlobulin, Follicle_stimulating_hormone_FSH, Estradiol, 
                            Luteinizing_hormone_LH, Testosterone_Male, Prolactin, 
                            Seminal_Fluid_Analysis_Male_B_HCG, Urine_examination, 
                            Stool_examination, Brucella_melitensis, Brucella_abortus, 
                            C_reactive_protein_CRP, Rheumatoid_factor_RF, 
                            Antistreptolysin_O_ASO, Toxoplasmosis, Typhoid_hCG, 
                            Hpylori_antibody, Stool_occult_blood, General_stool_examination,
                            Thyroid_profile, Triiodothyronine_T3, Thyroxine_T4, 
                            Thyroid_stimulating_hormone_TSH, Sperm_examination, 
                            Virginal_swab_trichomonas_virginals, Human_chorionic_gonadotropin_hCG, 
                            Hpylori_Ag_stool, Fasting_blood_sugar, Hemoglobin_A1c,
                            Troponin_I, CK_MB, aPTT, INR, D_Dimer, Vitamin_D, Vitamin_B12, 
                            Ferritin, VDRL, Dengue_Fever_IgG_IgM, Gonorrhea_Ag, AFP, Total_PSA, AMH,
                            Electrolyte_Test, CRP_Titer, Ultra, Typhoid_IgG, Typhoid_Ag
                        FROM lab_test
                        WHERE med_id = @orderId
                    ) src
                    UNPIVOT (
                        TestValue FOR TestName IN (
                            Hemoglobin, Malaria, ESR, Blood_grouping, Blood_sugar, CBC,
                            Cross_matching, TPHA, Human_immune_deficiency_HIV,
                            Hepatitis_B_virus_HBV, Hepatitis_C_virus_HCV,
                            Low_density_lipoprotein_LDL, High_density_lipoprotein_HDL,
                            Total_cholesterol, Triglycerides, SGPT_ALT, SGOT_AST,
                            Alkaline_phosphates_ALP, Total_bilirubin, Direct_bilirubin,
                            Albumin, Urea, Creatinine, Uric_acid, Sodium, Potassium,
                            Chloride, Calcium, Phosphorous, Magnesium,
                            General_urine_examination, Progesterone_Female, Amylase,
                            JGlobulin, Follicle_stimulating_hormone_FSH, Estradiol,
                            Luteinizing_hormone_LH, Testosterone_Male, Prolactin,
                            Seminal_Fluid_Analysis_Male_B_HCG, Urine_examination,
                            Stool_examination, Brucella_melitensis, Brucella_abortus,
                            C_reactive_protein_CRP, Rheumatoid_factor_RF,
                            Antistreptolysin_O_ASO, Toxoplasmosis, Typhoid_hCG,
                            Hpylori_antibody, Stool_occult_blood, General_stool_examination,
                            Thyroid_profile, Triiodothyronine_T3, Thyroxine_T4,
                            Thyroid_stimulating_hormone_TSH, Sperm_examination,
                            Virginal_swab_trichomonas_virginals, Human_chorionic_gonadotropin_hCG,
                            Hpylori_Ag_stool, Fasting_blood_sugar, Hemoglobin_A1c,
                            Troponin_I, CK_MB, aPTT, INR, D_Dimer, Vitamin_D, Vitamin_B12,
                            Ferritin, VDRL, Dengue_Fever_IgG_IgM, Gonorrhea_Ag, AFP, Total_PSA, AMH,
                            Electrolyte_Test, CRP_Titer, Ultra, Typhoid_IgG, Typhoid_Ag
                        )
                    ) unpvt
                    WHERE TestValue != 'not checked' AND TestValue IS NOT NULL AND TestValue != ''";
                
                using (var cmd = new SqlCommand(orderedQuery, connection))
                {
                    cmd.Parameters.AddWithValue("@orderId", order.OrderId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            order.OrderedTests.Add(FormatTestName(reader["TestName"].ToString()));
                        }
                    }
                }

                // Get results for this specific order
                string resultsQuery = "SELECT * FROM lab_results WHERE lab_test_id = @orderId";
                
                using (var cmd = new SqlCommand(resultsQuery, connection))
                {
                    cmd.Parameters.AddWithValue("@orderId", order.OrderId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Extract results from columns
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                string columnName = reader.GetName(i);
                                
                                // Skip system columns
                                if (columnName.ToLower().Contains("id") || 
                                    columnName.ToLower().Contains("date") || 
                                    columnName.ToLower().Contains("prescid") ||
                                    columnName.ToLower() == "type")
                                    continue;

                                if (reader[columnName] != DBNull.Value)
                                {
                                    string value = reader[columnName].ToString().Trim();
                                    
                                    // Use same filtering logic as lab_result_print.aspx.cs - don't exclude "0" values
                                    if (!string.IsNullOrWhiteSpace(value) && 
                                        !value.Equals("not checked", StringComparison.OrdinalIgnoreCase))
                                    {
                                        order.Results.Add(new TestResult
                                        {
                                            TestName = FormatTestName(columnName),
                                            Value = value
                                        });
                                    }
                                }
                            }
                        }
                    }
                }

                // Get charge information - sum all charges for this order
                string chargeQuery = @"
                    SELECT 
                        SUM(amount) as total_amount, 
                        MAX(CAST(is_paid AS INT)) as is_paid
                    FROM patient_charges 
                    WHERE reference_id = @orderId AND charge_type = 'Lab'
                    GROUP BY reference_id";

                using (var cmd = new SqlCommand(chargeQuery, connection))
                {
                    cmd.Parameters.AddWithValue("@orderId", order.OrderId);
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            order.ChargeAmount = reader["total_amount"] != DBNull.Value ? Convert.ToDecimal(reader["total_amount"]) : 0;
                            order.IsPaid = reader["is_paid"] != DBNull.Value && Convert.ToInt32(reader["is_paid"]) == 1;
                        }
                    }
                }
            }

            // Render orders (only those with ordered tests)
            var ordersToRender = orders.Where(o => o.OrderedTests.Count > 0).ToList();
            
            if (ordersToRender.Count > 0)
            {
                RenderOrders(ordersToRender);
                NoOrdersPanel.Visible = false;
            }
            else
            {
                NoOrdersPanel.Visible = true;
            }
        }

        private void RenderOrders(List<LabOrder> orders)
        {
            var sb = new StringBuilder();
            int orderNumber = 1;

            foreach (var order in orders)
            {
                string headerClass = order.IsReorder ? "order-header reorder" : "order-header";
                string badge = order.IsReorder 
                    ? "<span class='badge badge-warning'>Follow-up Order</span>" 
                    : "<span class='badge badge-primary'>Initial Order</span>";
                
                string paymentBadge = order.IsPaid
                    ? $"<span class='badge badge-success'><i class='fas fa-check-circle'></i> Paid (${order.ChargeAmount:F2})</span>"
                    : $"<span class='badge badge-danger'><i class='fas fa-exclamation-circle'></i> Unpaid (${order.ChargeAmount:F2})</span>";

                sb.Append("<div class='order-card'>");
                sb.Append($"<div class='{headerClass}'>");
                sb.Append($"<i class='fas fa-flask'></i> Lab Order #{orderNumber} {badge} {paymentBadge}");
                sb.Append($"<span style='float: right; font-weight: normal; font-size: 14px;'>{order.OrderDate}</span>");
                sb.Append("</div>");
                sb.Append("<div class='order-body'>");

                // Ordered Tests
                sb.Append("<div class='section-title'><i class='fas fa-clipboard-list'></i> Ordered Tests</div>");
                sb.Append("<div class='tests-grid'>");
                foreach (var test in order.OrderedTests)
                {
                    sb.Append($"<div class='test-badge'><i class='fas fa-check'></i> {test}</div>");
                }
                sb.Append("</div>");

                // Results
                if (order.Results != null && order.Results.Count > 0)
                {
                    sb.Append("<div class='section-title'><i class='fas fa-check-circle'></i> Results Available</div>");
                    sb.Append("<table class='results-table'>");
                    sb.Append("<thead><tr><th>Test</th><th>Result</th></tr></thead>");
                    sb.Append("<tbody>");
                    foreach (var result in order.Results)
                    {
                        sb.Append("<tr>");
                        sb.Append($"<td>{result.TestName}</td>");
                        sb.Append($"<td class='result-value'>{result.Value}</td>");
                        sb.Append("</tr>");
                    }
                    sb.Append("</tbody></table>");
                }
                else
                {
                    sb.Append("<div class='no-results'>");
                    sb.Append("<i class='fas fa-hourglass-half'></i> Waiting for results...");
                    sb.Append("</div>");
                }

                sb.Append("</div></div>");
                orderNumber++;
            }

            OrdersPlaceHolder.Controls.Add(new LiteralControl(sb.ToString()));
        }

        private string FormatTestName(string columnName)
        {
            // Convert column names to readable format
            return columnName
                .Replace("_", " ")
                .Replace("  ", " - ");
        }

        private void ShowError(string message)
        {
            ErrorLiteral.Text = message;
            ErrorPanel.Visible = true;
            ContentPanel.Visible = false;
        }

        private class LabOrder
        {
            public int OrderId { get; set; }
            public string OrderDate { get; set; }
            public bool IsReorder { get; set; }
            public List<string> OrderedTests { get; set; }
            public List<TestResult> Results { get; set; }
            public decimal ChargeAmount { get; set; }
            public bool IsPaid { get; set; }
        }

        private class TestResult
        {
            public string TestName { get; set; }
            public string Value { get; set; }
        }
    
        /// <summary>
        /// Add dynamic favicon to page head
        /// </summary>
        private void AddFavicon()
        {
            string faviconUrl = HospitalSettingsHelper.GetFaviconUrl();
            HtmlLink favicon = new HtmlLink();
            favicon.Href = faviconUrl;
            favicon.Attributes["rel"] = "shortcut icon";
            favicon.Attributes["type"] = "image/x-icon";
            Page.Header.Controls.Add(favicon);
        }

        }
}
