using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace juba_hospital
{
    public partial class patient_lab_history : Page
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                return;
            }

            string patientId = Request.QueryString["patientid"];
            if (string.IsNullOrWhiteSpace(patientId))
            {
                ShowError("Missing patient identifier.");
                return;
            }

            try
            {
                LoadPatientLabHistory(patientId);
            }
            catch (Exception ex)
            {
                ShowError("Unable to load patient lab history. Details: " + ex.Message);
            }
        }

        private void LoadPatientLabHistory(string patientId)
        {
            // Get patient information
            var patientInfo = GetPatientInfo(patientId);
            if (patientInfo == null)
            {
                ShowError("Patient not found.");
                return;
            }

            // Display patient information
            PatientNameLiteral.Text = patientInfo.FullName;
            PatientIdLiteral.Text = patientInfo.PatientId;
            PatientSexLiteral.Text = patientInfo.Sex;
            PatientDOBLiteral.Text = patientInfo.DOB?.ToString("dd MMM yyyy") ?? "—";
            PatientPhoneLiteral.Text = patientInfo.Phone ?? "—";
            PatientLocationLiteral.Text = patientInfo.Location ?? "—";

            // Get all lab orders for this patient
            var labOrders = GetPatientLabOrders(patientId);

            if (labOrders.Count == 0)
            {
                LabHistoryLiteral.Text = "<div class='no-results'><i class='fas fa-info-circle'></i> No laboratory test history found for this patient.</div>";
                TotalOrdersLiteral.Text = "0";
                CompletedOrdersLiteral.Text = "0";
                PendingOrdersLiteral.Text = "0";
            }
            else
            {
                // Calculate statistics
                int totalOrders = labOrders.Count;
                int completedOrders = 0;
                int pendingOrders = 0;

                foreach (var order in labOrders)
                {
                    if (order.IsCompleted)
                        completedOrders++;
                    else
                        pendingOrders++;
                }

                TotalOrdersLiteral.Text = totalOrders.ToString();
                CompletedOrdersLiteral.Text = completedOrders.ToString();
                PendingOrdersLiteral.Text = pendingOrders.ToString();

                // Build lab history HTML
                StringBuilder historyHtml = new StringBuilder();

                foreach (var order in labOrders)
                {
                    historyHtml.Append(BuildOrderSection(order));
                }

                LabHistoryLiteral.Text = historyHtml.ToString();
            }

            // Add print header
            PrintHeaderLiteral.Text = HospitalSettingsHelper.GetPrintHeaderHTML();

            ContentPanel.Visible = true;
        }

        private PatientInfo GetPatientInfo(string patientId)
        {
            const string query = @"
                SELECT patientid, full_name, sex, dob, phone, location
                FROM patient
                WHERE patientid = @patientid";

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@patientid", patientId);
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        return new PatientInfo
                        {
                            PatientId = reader["patientid"].ToString(),
                            FullName = reader["full_name"].ToString(),
                            Sex = reader["sex"].ToString(),
                            DOB = reader["dob"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["dob"]),
                            Phone = reader["phone"].ToString(),
                            Location = reader["location"].ToString()
                        };
                    }
                }
            }

            return null;
        }

        private List<LabOrder> GetPatientLabOrders(string patientId)
        {
            var orders = new List<LabOrder>();

            const string query = @"
                SELECT 
                    lt.med_id as order_id,
                    lt.prescid,
                    lt.date_taken as order_date,
                    ISNULL(lt.is_reorder, 0) as is_reorder,
                    lt.reorder_reason,
                    CASE WHEN lr.lab_result_id IS NOT NULL THEN 1 ELSE 0 END as is_completed,
                    lr.lab_result_id,
                    d.doctortitle,
                    STUFF((SELECT ', ' + charge_name 
                           FROM patient_charges 
                           WHERE reference_id = lt.med_id AND charge_type = 'Lab'
                           FOR XML PATH('')), 1, 2, '') as charge_name,
                    ISNULL((SELECT SUM(amount) 
                            FROM patient_charges 
                            WHERE reference_id = lt.med_id AND charge_type = 'Lab'), 0) as charge_amount
                FROM lab_test lt
                INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
                INNER JOIN patient p ON pr.patientid = p.patientid
                LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                LEFT JOIN lab_results lr ON lt.prescid = lr.prescid AND lr.lab_test_id = lt.med_id
                WHERE p.patientid = @patientid
                GROUP BY lt.med_id, lt.prescid, lt.date_taken, lt.is_reorder, lt.reorder_reason, 
                         lr.lab_result_id, d.doctortitle
                ORDER BY lt.date_taken DESC, lt.med_id DESC";

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@patientid", patientId);
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        var order = new LabOrder
                        {
                            OrderId = reader["order_id"].ToString(),
                            PrescId = reader["prescid"].ToString(),
                            OrderDate = reader["order_date"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["order_date"]),
                            IsReorder = Convert.ToInt32(reader["is_reorder"]) == 1,
                            ReorderReason = reader["reorder_reason"]?.ToString(),
                            IsCompleted = Convert.ToInt32(reader["is_completed"]) == 1,
                            LabResultId = reader["lab_result_id"]?.ToString(),
                            DoctorName = reader["doctortitle"]?.ToString(),
                            ChargeName = reader["charge_name"]?.ToString(),
                            ChargeAmount = reader["charge_amount"] == DBNull.Value ? 0 : Convert.ToDecimal(reader["charge_amount"])
                        };

                        // Get ordered tests for this order
                        order.OrderedTests = GetOrderedTests(order.PrescId, order.OrderId);

                        // Get results if completed
                        if (order.IsCompleted && !string.IsNullOrEmpty(order.LabResultId))
                        {
                            order.Results = GetLabResults(order.PrescId);
                        }

                        orders.Add(order);
                    }
                }
            }

            return orders;
        }

        private List<string> GetOrderedTests(string prescId, string orderId)
        {
            var tests = new List<string>();

            const string query = @"
                SELECT *
                FROM lab_test
                WHERE prescid = @prescid AND med_id = @orderid";

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@prescid", prescId);
                cmd.Parameters.AddWithValue("@orderid", orderId);
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        // Loop through all columns to find ordered tests
                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            string columnName = reader.GetName(i);

                            // Skip system columns
                            if (columnName.ToLower().Contains("id") ||
                                columnName.ToLower().Contains("date") ||
                                columnName.ToLower().Contains("prescid") ||
                                columnName.ToLower() == "type" ||
                                columnName == "is_reorder")
                                continue;

                            if (reader[columnName] != DBNull.Value)
                            {
                                string value = reader[columnName].ToString().Trim();

                                if (!string.IsNullOrEmpty(value) &&
                                    !value.Equals("not checked", StringComparison.OrdinalIgnoreCase) &&
                                    !value.Equals("0", StringComparison.OrdinalIgnoreCase) &&
                                    !value.Equals("false", StringComparison.OrdinalIgnoreCase))
                                {
                                    // Format column name to readable test name
                                    string testName = columnName.Replace("_", " ");
                                    tests.Add(testName);
                                }
                            }
                        }
                    }
                }
            }

            return tests;
        }

        private Dictionary<string, string> GetLabResults(string prescId)
        {
            var results = new Dictionary<string, string>();

            const string query = @"
                SELECT *
                FROM lab_results
                WHERE prescid = @prescid
                ORDER BY date_taken DESC";

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@prescid", prescId);
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        var excludedColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
                        {
                            "lab_result_id", "prescid", "date_taken", "date_added", "last_updated", "lab_test_id"
                        };

                        for (int i = 0; i < reader.FieldCount; i++)
                        {
                            string columnName = reader.GetName(i);
                            if (excludedColumns.Contains(columnName))
                                continue;

                            object value = reader.GetValue(i);
                            if (value == null || value == DBNull.Value)
                                continue;

                            string stringValue = value.ToString();
                            if (string.IsNullOrWhiteSpace(stringValue) || string.Equals(stringValue, "not checked", StringComparison.OrdinalIgnoreCase))
                                continue;

                            results[FormatLabel(columnName)] = stringValue;
                        }
                    }
                }
            }

            return results;
        }

        private string BuildOrderSection(LabOrder order)
        {
            StringBuilder html = new StringBuilder();

            html.Append("<div class='test-order-section'>");
            
            // Section header
            html.Append("<div class='section-header'>");
            html.AppendFormat("<div class='order-title'>Order #{0}", order.OrderId);
            if (order.IsReorder)
            {
                html.Append(" <span class='badge bg-warning text-dark'>Follow-up</span>");
            }
            html.Append("</div>");
            
            html.Append("<div class='order-meta'>");
            html.AppendFormat("<span><i class='fas fa-calendar'></i> {0}</span>", 
                order.OrderDate?.ToString("dd MMM yyyy HH:mm") ?? "Unknown date");
            html.AppendFormat("<span><i class='fas fa-user-md'></i> {0}</span>", 
                order.DoctorName ?? "Unknown doctor");
            
            string statusClass = order.IsCompleted ? "status-completed" : "status-pending";
            string statusText = order.IsCompleted ? "Completed" : "Pending";
            string statusIcon = order.IsCompleted ? "fa-check-circle" : "fa-hourglass-half";
            html.AppendFormat("<span class='status-badge {0}'><i class='fas {1}'></i> {2}</span>", 
                statusClass, statusIcon, statusText);
            html.Append("</div>");
            html.Append("</div>");

            // Charge information
            if (!string.IsNullOrEmpty(order.ChargeName))
            {
                html.AppendFormat("<p><strong>Charge:</strong> {0} - ${1:F2}</p>", 
                    order.ChargeName, order.ChargeAmount);
            }

            // Reorder reason
            if (order.IsReorder && !string.IsNullOrEmpty(order.ReorderReason))
            {
                html.AppendFormat("<p><strong>Follow-up Reason:</strong> <em>{0}</em></p>", order.ReorderReason);
            }

            // Ordered tests
            html.Append("<h5 style='margin-top: 15px;'>Ordered Tests:</h5>");
            if (order.OrderedTests != null && order.OrderedTests.Count > 0)
            {
                html.Append("<ul style='margin-left: 20px;'>");
                foreach (var test in order.OrderedTests)
                {
                    html.AppendFormat("<li>{0}</li>", test);
                }
                html.Append("</ul>");
            }
            else
            {
                html.Append("<p class='text-muted'>No tests found for this order.</p>");
            }

            // Results
            if (order.IsCompleted)
            {
                html.Append("<h5 style='margin-top: 20px;'>Test Results:</h5>");
                
                if (order.Results != null && order.Results.Count > 0)
                {
                    html.Append("<table class='results-table'>");
                    html.Append("<thead><tr><th>Test Parameter</th><th>Result</th></tr></thead>");
                    html.Append("<tbody>");
                    
                    foreach (var result in order.Results)
                    {
                        html.AppendFormat("<tr><td>{0}</td><td><strong>{1}</strong></td></tr>", 
                            result.Key, result.Value);
                    }
                    
                    html.Append("</tbody></table>");
                }
                else
                {
                    html.Append("<p class='text-muted'>No results recorded for this order.</p>");
                }
            }
            else
            {
                html.Append("<div style='background: #fef3c7; padding: 15px; border-radius: 8px; margin-top: 15px;'>");
                html.Append("<i class='fas fa-exclamation-triangle'></i> <strong>Status:</strong> Test results pending. Results will be available once the lab technician completes the tests.");
                html.Append("</div>");
            }

            html.Append("</div>");

            return html.ToString();
        }

        private static string FormatLabel(string columnName)
        {
            string label = columnName.Replace("_", " ");
            return System.Globalization.CultureInfo.CurrentCulture.TextInfo.ToTitleCase(label.ToLowerInvariant());
        }

        private void ShowError(string message)
        {
            ErrorLiteral.Text = message;
            ErrorPanel.Visible = true;
            ContentPanel.Visible = false;
        }

        // Helper classes
        private class PatientInfo
        {
            public string PatientId { get; set; }
            public string FullName { get; set; }
            public string Sex { get; set; }
            public DateTime? DOB { get; set; }
            public string Phone { get; set; }
            public string Location { get; set; }
        }

        private class LabOrder
        {
            public string OrderId { get; set; }
            public string PrescId { get; set; }
            public DateTime? OrderDate { get; set; }
            public bool IsReorder { get; set; }
            public string ReorderReason { get; set; }
            public bool IsCompleted { get; set; }
            public string LabResultId { get; set; }
            public string DoctorName { get; set; }
            public string ChargeName { get; set; }
            public decimal ChargeAmount { get; set; }
            public List<string> OrderedTests { get; set; }
            public Dictionary<string, string> Results { get; set; }
        }
    }
}
