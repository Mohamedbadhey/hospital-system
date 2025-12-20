using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;

namespace juba_hospital
{
    public partial class outpatient_full_report : System.Web.UI.Page
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
                    LoadFullReport(patientId, prescid);
                }
                else
                {
                    reportContent.InnerHtml = "<div class='alert alert-danger'>Invalid patient ID</div>";
                }
            }
        }

        private void LoadFullReport(string patientId, string prescid)
        {
            StringBuilder html = new StringBuilder();

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Section 1: Patient Information
                html.Append(GetPatientInfo(con, patientId));

                // Section 2: Visit Information
                html.Append(GetVisitInfo(con, patientId, prescid));

                // Section 3: Medications
                html.Append(GetMedications(con, prescid));

                // Section 4: Lab Tests
                html.Append(GetLabTests(con, patientId, prescid));

                // Section 5: X-Ray Tests
                html.Append(GetXrayTests(con, patientId, prescid));

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
                        html.Append($"<div class='info-row'><div class='info-label'>Patient ID:</div><div class='info-value'>{dr["patientid"]}</div></div>");
                        html.Append($"<div class='info-row'><div class='info-label'>Full Name:</div><div class='info-value'><strong>{dr["full_name"]}</strong></div></div>");
                        html.Append($"<div class='info-row'><div class='info-label'>Date of Birth:</div><div class='info-value'>{Convert.ToDateTime(dr["dob"]).ToString("MMMM dd, yyyy")}</div></div>");
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

        private string GetVisitInfo(SqlConnection con, string patientId, string prescid)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title'>🏥 VISIT INFORMATION</div>");

            string query = @"
                SELECT pr.prescid, d.doctorname, d.doctortitle, pr.status, pr.xray_status
                FROM prescribtion pr
                LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                WHERE pr.patientid = @patientId AND pr.prescid = @prescid";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@patientId", patientId);
                cmd.Parameters.AddWithValue("@prescid", prescid);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        string doctorName = dr["doctortitle"] != DBNull.Value ? dr["doctortitle"].ToString() + " " : "";
                        doctorName += dr["doctorname"] != DBNull.Value ? dr["doctorname"].ToString() : "Unknown";
                        
                        html.Append($"<div class='info-row'><div class='info-label'>Prescription ID:</div><div class='info-value'>{dr["prescid"]}</div></div>");
                        html.Append($"<div class='info-row'><div class='info-label'>Attending Doctor:</div><div class='info-value'><strong>{doctorName}</strong></div></div>");
                        html.Append($"<div class='info-row'><div class='info-label'>Patient Type:</div><div class='info-value'><span class='badge badge-primary'>Outpatient</span></div></div>");
                    }
                    else
                    {
                        html.Append("<p>No visit information found.</p>");
                    }
                }
            }

            html.Append("</div>");
            return html.ToString();
        }

        private string GetMedications(SqlConnection con, string prescid)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title'>💊 MEDICATIONS PRESCRIBED</div>");

            string query = "SELECT med_name, dosage, frequency, duration, special_inst FROM medication WHERE prescid = @prescid";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@prescid", prescid);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.HasRows)
                    {
                        html.Append("<table>");
                        html.Append("<tr><th>Medication</th><th>Dosage</th><th>Frequency</th><th>Duration</th><th>Instructions</th></tr>");
                        
                        while (dr.Read())
                        {
                            html.Append("<tr>");
                            html.Append($"<td><strong>{dr["med_name"]}</strong></td>");
                            html.Append($"<td>{dr["dosage"]}</td>");
                            html.Append($"<td>{dr["frequency"]}</td>");
                            html.Append($"<td>{dr["duration"]}</td>");
                            html.Append($"<td>{(dr["special_inst"] != DBNull.Value ? dr["special_inst"].ToString() : "-")}</td>");
                            html.Append("</tr>");
                        }
                        
                        html.Append("</table>");
                    }
                    else
                    {
                        html.Append("<p>No medications prescribed.</p>");
                    }
                }
            }

            html.Append("</div>");
            return html.ToString();
        }

        private string GetLabTests(SqlConnection con, string patientId, string prescid)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title'>🔬 LABORATORY TESTS - ALL ORDERS</div>");

            // Use the same comprehensive lab display logic as inpatient report
            return GetAllLabTestsWithResults(con, patientId, prescid);
        }

        private string GetAllLabTestsWithResults(SqlConnection con, string patientId, string specificPrescid = null)
        {
            StringBuilder html = new StringBuilder();

            // Get all LAB ORDERS for this patient (optionally filtered by prescid for outpatients)
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
                    AND pr.status >= 4";

            // For outpatients, filter by specific prescid if provided
            if (!string.IsNullOrEmpty(specificPrescid))
            {
                prescQuery += " AND pr.prescid = @prescid";
            }

            prescQuery += " ORDER BY lt.date_taken DESC, lt.med_id DESC";

            using (SqlCommand cmd = new SqlCommand(prescQuery, con))
            {
                cmd.Parameters.AddWithValue("@patientId", patientId);
                if (!string.IsNullOrEmpty(specificPrescid))
                {
                    cmd.Parameters.AddWithValue("@prescid", specificPrescid);
                }

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.HasRows)
                    {
                        var labOrders = new System.Collections.Generic.List<dynamic>();
                        
                        // First, collect all order data
                        while (dr.Read())
                        {
                            labOrders.Add(new 
                            {
                                OrderId = dr["order_id"].ToString(),
                                PrescId = dr["prescid"].ToString(),
                                OrderDate = dr["order_date"] != DBNull.Value ? Convert.ToDateTime(dr["order_date"]) : DateTimeHelper.Now,
                                OrderStatus = dr["order_status"].ToString()
                            });
                        }

                        dr.Close();

                        // Now display each order with its details
                        int orderNumber = 1;
                        foreach (var order in labOrders)
                        {
                            html.Append("<div class='lab-test-order' style='margin-bottom:25px; border:1px solid #ddd; border-radius:5px; padding:15px;'>");
                            html.Append($"<div style='background:#3498db; color:white; padding:8px 12px; margin:-15px -15px 15px -15px; border-radius:5px 5px 0 0; font-weight:bold;'>");
                            html.Append($"LAB ORDER #{orderNumber} - Order ID: {order.OrderId} (Prescription: {order.PrescId})");
                            html.Append("</div>");

                            // Status and dates
                            html.Append("<div class='info-row'>");
                            html.Append("<div class='info-label'>Status:</div>");
                            html.Append($"<div class='info-value'>{(order.OrderStatus == "Completed" ? "<span class='badge badge-success'>Completed</span>" : "<span class='badge' style='background:#ffc107; color:white;'>Pending</span>")}</div>");
                            html.Append("</div>");

                            html.Append("<div class='info-row'>");
                            html.Append("<div class='info-label'>Ordered Date:</div>");
                            html.Append($"<div class='info-value'>{order.OrderDate.ToString("MMMM dd, yyyy hh:mm tt")}</div>");
                            html.Append("</div>");

                            // Get test details for this specific order
                            html.Append(GetLabTestDetailsForOrder(con, order.OrderId, order.PrescId, order.OrderStatus));

                            html.Append("</div>");
                            orderNumber++;
                        }
                    }
                    else
                    {
                        html.Append("<div style='padding:20px; text-align:center; color:#666;'>No laboratory tests ordered</div>");
                    }
                }
            }

            return html.ToString();
        }

        private string GetLabTestDetailsForOrder(SqlConnection con, string orderId, string prescid, string orderStatus)
        {
            StringBuilder html = new StringBuilder();

            // Get ordered tests FOR THIS SPECIFIC ORDER (med_id)
            string orderedQuery = "SELECT * FROM lab_test WHERE med_id = @orderId";
            
            using (SqlCommand cmd = new SqlCommand(orderedQuery, con))
            {
                cmd.Parameters.AddWithValue("@orderId", orderId);
                using (SqlDataReader orderedReader = cmd.ExecuteReader())
                {
                    if (orderedReader.Read())
                    {
                        var orderedTestsList = new System.Collections.Generic.List<string>();

                        // Loop through all columns to find ordered tests
                        for (int i = 0; i < orderedReader.FieldCount; i++)
                        {
                            string columnName = orderedReader.GetName(i);

                            // Skip system columns
                            if (columnName.ToLower().Contains("id") || 
                                columnName.ToLower().Contains("date") || 
                                columnName.ToLower().Contains("prescid") ||
                                columnName.ToLower() == "type" ||
                                columnName == "is_reorder")
                                continue;

                            if (orderedReader[columnName] != DBNull.Value)
                            {
                                string value = orderedReader[columnName].ToString().Trim();
                                
                                if (!string.IsNullOrEmpty(value) && 
                                    !value.Equals("not checked", StringComparison.OrdinalIgnoreCase) &&
                                    !value.Equals("0", StringComparison.OrdinalIgnoreCase) &&
                                    !value.Equals("false", StringComparison.OrdinalIgnoreCase) &&
                                    !value.Equals("no", StringComparison.OrdinalIgnoreCase))
                                {
                                    string testLabel = columnName.Replace("_", " ").Replace("  ", " ").Trim();
                                    orderedTestsList.Add(testLabel);
                                }
                            }
                        }

                        orderedReader.Close();

                        // Display tests ordered
                        if (orderedTestsList.Count > 0)
                        {
                            html.Append("<div class='info-row' style='margin-top:15px'>");
                            html.Append("<div class='info-label'>Tests Ordered:</div>");
                            html.Append("<div class='info-value'><ul style='margin:0; padding-left:20px; line-height:1.8;'>");
                            
                            orderedTestsList.Sort();
                            foreach (var test in orderedTestsList)
                            {
                                html.Append($"<li style='margin-bottom:3px;'>{test}</li>");
                            }
                            html.Append("</ul></div>");
                            html.Append("</div>");

                            // Get and display results if completed
                            if (orderStatus == "Completed")
                            {
                                string resultsQuery = "SELECT * FROM lab_results WHERE lab_test_id = @orderId";
                                using (SqlCommand resultsCmd = new SqlCommand(resultsQuery, con))
                                {
                                    resultsCmd.Parameters.AddWithValue("@orderId", orderId);
                                    using (SqlDataReader resultsReader = resultsCmd.ExecuteReader())
                                    {
                                        if (resultsReader.Read())
                                        {
                                            html.Append("<div style='margin-top:15px'>");
                                            html.Append("<strong>Lab Results:</strong>");
                                            html.Append("<table style='margin-top:10px; border-collapse:collapse; width:100%; border:1px solid #ddd'>");
                                            html.Append("<tr><th style='background:#ecf0f1; padding:10px; border:1px solid #bdc3c7; text-align:left;'>Test</th><th style='background:#ecf0f1; padding:10px; border:1px solid #bdc3c7; text-align:left;'>Result</th></tr>");

                                            foreach (var testName in orderedTestsList)
                                            {
                                                string columnName = testName.Replace(" ", "_");
                                                
                                                for (int i = 0; i < resultsReader.FieldCount; i++)
                                                {
                                                    if (resultsReader.GetName(i).Equals(columnName, StringComparison.OrdinalIgnoreCase))
                                                    {
                                                        if (resultsReader[i] != DBNull.Value)
                                                        {
                                                            string resultValue = resultsReader[i].ToString().Trim();
                                                            if (!string.IsNullOrEmpty(resultValue))
                                                            {
                                                                html.Append("<tr>");
                                                                html.Append($"<td style='padding:8px; border:1px solid #ddd; vertical-align:top;'><strong>{testName}</strong></td>");
                                                                html.Append($"<td style='padding:8px; border:1px solid #ddd; vertical-align:top;'>{resultValue}</td>");
                                                                html.Append("</tr>");
                                                            }
                                                        }
                                                        break;
                                                    }
                                                }
                                            }

                                            html.Append("</table>");
                                            html.Append("</div>");
                                        }
                                    }
                                }
                            }
                            else
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
                    }
                }
            }

            return html.ToString();
        }

        private string GetXrayTests(SqlConnection con, string patientId, string prescid)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title'>🩻 X-RAY EXAMINATIONS</div>");

            string query = @"
                SELECT x.xryname, pr.xray_status
                FROM prescribtion pr
                INNER JOIN presxray px ON pr.prescid = px.prescid
                LEFT JOIN xray x ON px.xrayid = x.xrayid
                WHERE pr.patientid = @patientId AND pr.prescid = @prescid AND pr.xray_status > 0";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@patientId", patientId);
                cmd.Parameters.AddWithValue("@prescid", prescid);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.HasRows)
                    {
                        html.Append("<table>");
                        html.Append("<tr><th>X-Ray Type</th><th>Status</th></tr>");
                        
                        while (dr.Read())
                        {
                            string status = "";
                            switch (Convert.ToInt32(dr["xray_status"]))
                            {
                                case 1: status = "<span class='badge' style='background:#ffc107'>Pending</span>"; break;
                                case 2: status = "<span class='badge badge-success'>Completed</span>"; break;
                                default: status = "<span class='badge' style='background:#6c757d'>Not Ordered</span>"; break;
                            }
                            
                            html.Append("<tr>");
                            html.Append($"<td>{dr["xryname"]}</td>");
                            html.Append($"<td>{status}</td>");
                            html.Append("</tr>");
                        }
                        
                        html.Append("</table>");
                    }
                    else
                    {
                        html.Append("<p>No X-ray examinations ordered.</p>");
                    }
                }
            }

            html.Append("</div>");
            return html.ToString();
        }

        private string GetCharges(SqlConnection con, string patientId)
        {
            StringBuilder html = new StringBuilder();
            html.Append("<div class='section'>");
            html.Append("<div class='section-title'>💰 CHARGES AND PAYMENT</div>");

            string query = @"
                SELECT charge_type, charge_name, amount, is_paid, payment_method, date_added
                FROM patient_charges
                WHERE patientid = @patientId
                ORDER BY date_added";

            decimal totalCharges = 0;
            decimal paidAmount = 0;

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@patientId", patientId);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.HasRows)
                    {
                        html.Append("<table>");
                        html.Append("<tr><th>Date</th><th>Type</th><th>Description</th><th>Amount</th><th>Status</th><th>Payment Method</th></tr>");
                        
                        while (dr.Read())
                        {
                            decimal amount = Convert.ToDecimal(dr["amount"]);
                            bool isPaid = Convert.ToBoolean(dr["is_paid"]);
                            
                            totalCharges += amount;
                            if (isPaid) paidAmount += amount;
                            
                            string statusBadge = isPaid ? 
                                "<span class='badge badge-success'>Paid</span>" : 
                                "<span class='badge badge-danger'>Unpaid</span>";
                            
                            html.Append("<tr>");
                            html.Append($"<td>{Convert.ToDateTime(dr["date_added"]).ToString("MMM dd, yyyy")}</td>");
                            html.Append($"<td>{dr["charge_type"]}</td>");
                            html.Append($"<td>{dr["charge_name"]}</td>");
                            html.Append($"<td>${amount:F2}</td>");
                            html.Append($"<td>{statusBadge}</td>");
                            html.Append($"<td>{(dr["payment_method"] != DBNull.Value ? dr["payment_method"].ToString() : "-")}</td>");
                            html.Append("</tr>");
                        }
                        
                        html.Append("<tr class='total-row'>");
                        html.Append("<td colspan='3' style='text-align:right'>TOTAL:</td>");
                        html.Append($"<td>${totalCharges:F2}</td>");
                        html.Append("<td colspan='2'></td>");
                        html.Append("</tr>");
                        
                        html.Append("</table>");
                        
                        html.Append("<div class='summary-box'>");
                        html.Append($"<strong>Financial Summary:</strong><br>");
                        html.Append($"Total Charges: <span class='highlight'>${totalCharges:F2}</span><br>");
                        html.Append($"Amount Paid: <span class='highlight' style='background:#d4edda'>${paidAmount:F2}</span><br>");
                        html.Append($"Balance Due: <span class='highlight' style='background:#f8d7da'>${(totalCharges - paidAmount):F2}</span>");
                        html.Append("</div>");
                    }
                    else
                    {
                        html.Append("<p>No charges recorded.</p>");
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
            html.Append("<div class='section-title'>📊 VISIT SUMMARY</div>");

            html.Append("<div class='summary-box'>");
            html.Append("<p><strong>This report provides a comprehensive overview of the patient's outpatient visit including:</strong></p>");
            html.Append("<ul>");
            html.Append("<li>Complete patient demographic information</li>");
            html.Append("<li>All medications prescribed during the visit</li>");
            html.Append("<li>Laboratory tests ordered and their status</li>");
            html.Append("<li>X-ray examinations ordered and their status</li>");
            html.Append("<li>Complete financial breakdown of all charges</li>");
            html.Append("</ul>");
            html.Append($"<p style='margin-top:20px'><strong>Report Generated:</strong> {DateTimeHelper.Now.ToString("MMMM dd, yyyy hh:mm tt")}</p>");
            html.Append($"<p><strong>Generated By:</strong> Registration Department</p>");
            html.Append("</div>");

            html.Append("</div>");
            return html.ToString();
        }
    }
}
