using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace juba_hospital
{
    public partial class lab_result_print : Page
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

            string prescid = Request.QueryString["prescid"];
            if (string.IsNullOrWhiteSpace(prescid))
            {
                ShowError("Missing lab request identifier.");
                return;
            }

            try
            {
                LabResultModel model = LoadLabResult(prescid);
                if (model == null)
                {
                    ShowError("No lab tests found for this visit.");
                    return;
                }

                PrintHeaderLiteral.Text = HospitalSettingsHelper.GetPrintHeaderHTML();
                BindMeta(model);
                
                // Show ordered tests if available
                if (model.OrderedTests != null && model.OrderedTests.Count > 0)
                {
                    OrderedTestsRepeater.DataSource = model.OrderedTests;
                    OrderedTestsRepeater.DataBind();
                    OrderedTestsPanel.Visible = true;
                }
                
                // Show results if available
                if (model.Results != null && model.Results.Count > 0)
                {
                    ResultsRepeater.DataSource = model.Results;
                    ResultsRepeater.DataBind();
                    ResultsPanel.Visible = true;
                }
                
                // Show no data message if neither ordered tests nor results
                if ((model.OrderedTests == null || model.OrderedTests.Count == 0) && 
                    (model.Results == null || model.Results.Count == 0))
                {
                    NoDataPanel.Visible = true;
                }
                
                ReportDateLiteral.Text = DateTimeHelper.Now.ToString("dd MMM yyyy HH:mm");
                ContentPanel.Visible = true;
            }
            catch (Exception ex)
            {
                ShowError("Unable to load lab results. Details: " + ex.Message);
            }
        }

        private static LabResultModel LoadLabResult(string prescid)
        {
            using (SqlConnection con = new SqlConnection(ConnectionString))
            {
                con.Open();
                
                // Get patient and prescription info
                const string patientQuery = @"
                    SELECT 
                        p.patientid,
                        p.full_name,
                        p.phone,
                        p.location,
                        p.dob,
                        p.sex,
                        d.doctortitle,
                        pr.date_prescribed
                    FROM prescribtion pr
                    INNER JOIN patient p ON pr.patientid = p.patientid
                    LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                    WHERE pr.prescid = @prescid";

                LabResultModel model = null;
                
                using (SqlCommand cmd = new SqlCommand(patientQuery, con))
                {
                    cmd.Parameters.AddWithValue("@prescid", prescid);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            model = new LabResultModel
                            {
                                PatientId = reader["patientid"].ToString(),
                                PatientName = reader["full_name"].ToString(),
                                PatientPhone = reader["phone"] == DBNull.Value ? "—" : reader["phone"].ToString(),
                                PatientLocation = reader["location"] == DBNull.Value ? "—" : reader["location"].ToString(),
                                PatientSex = reader["sex"] == DBNull.Value ? "—" : reader["sex"].ToString(),
                                PatientAge = CalculateAge(reader["dob"]),
                                DoctorName = reader["doctortitle"] == DBNull.Value ? "—" : reader["doctortitle"].ToString(),
                                SampleDate = reader["date_prescribed"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["date_prescribed"])
                            };
                        }
                    }
                }

                if (model == null)
                {
                    return null;
                }

                // Try to get lab results (processed tests)
                const string resultsQuery = @"
                    SELECT TOP 1 lr.*
                    FROM lab_results lr
                    WHERE lr.prescid = @prescid
                    ORDER BY lr.date_taken DESC, lr.lab_result_id DESC";

                using (SqlCommand cmd = new SqlCommand(resultsQuery, con))
                {
                    cmd.Parameters.AddWithValue("@prescid", prescid);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            model.Results = BuildResultList(reader);
                            model.LabResultId = reader["lab_result_id"].ToString();
                            if (reader["date_taken"] != DBNull.Value)
                            {
                                model.SampleDate = Convert.ToDateTime(reader["date_taken"]);
                            }
                        }
                    }
                }

                // Get ordered tests
                const string orderedQuery = @"
                    SELECT lt.*
                    FROM lab_test lt
                    WHERE lt.med_id = @prescid";

                using (SqlCommand cmd = new SqlCommand(orderedQuery, con))
                {
                    cmd.Parameters.AddWithValue("@prescid", prescid);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            model.OrderedTests = BuildOrderedTestsList(reader);
                        }
                    }
                }

                return model;
            }
        }
        
        private static string CalculateAge(object dobValue)
        {
            if (dobValue == DBNull.Value)
            {
                return "—";
            }
            
            try
            {
                DateTime dob = Convert.ToDateTime(dobValue);
                DateTime today = DateTimeHelper.Today;
                int age = today.Year - dob.Year;
                if (dob.Date > today.AddYears(-age))
                {
                    age--;
                }
                return age.ToString() + " years";
            }
            catch
            {
                return "—";
            }
        }

        private static List<LabResultEntry> BuildOrderedTestsList(SqlDataReader reader)
        {
            var list = new List<LabResultEntry>();
            var excludedColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "med_id",
                "patientid",
                "full_name",
                "phone",
                "location",
                "doctortitle",
                "date_taken",
                "date_added",
                "last_updated",
                "lab_test_id"
            };

            for (int i = 0; i < reader.FieldCount; i++)
            {
                string columnName = reader.GetName(i);
                if (excludedColumns.Contains(columnName))
                {
                    continue;
                }

                object value = reader.GetValue(i);
                if (value == null || value == DBNull.Value)
                {
                    continue;
                }

                string stringValue = value.ToString();
                if (string.IsNullOrWhiteSpace(stringValue))
                {
                    continue;
                }

                list.Add(new LabResultEntry
                {
                    Label = FormatLabel(columnName),
                    Value = "Ordered (Pending Results)"
                });
            }

            list.Sort((a, b) => string.Compare(a.Label, b.Label, StringComparison.OrdinalIgnoreCase));
            return list;
        }

        private static List<LabResultEntry> BuildResultList(SqlDataReader reader)
        {
            var list = new List<LabResultEntry>();
            var excludedColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "lab_result_id",
                "prescid",
                "patientid",
                "full_name",
                "phone",
                "location",
                "doctortitle",
                "date_taken",
                "date_added",
                "last_updated"
            };

            for (int i = 0; i < reader.FieldCount; i++)
            {
                string columnName = reader.GetName(i);
                if (excludedColumns.Contains(columnName))
                {
                    continue;
                }

                object value = reader.GetValue(i);
                if (value == null || value == DBNull.Value)
                {
                    continue;
                }

                string stringValue = value.ToString();
                if (string.IsNullOrWhiteSpace(stringValue) || string.Equals(stringValue, "not checked", StringComparison.OrdinalIgnoreCase))
                {
                    continue;
                }

                list.Add(new LabResultEntry
                {
                    Label = FormatLabel(columnName),
                    Value = stringValue
                });
            }

            list.Sort((a, b) => string.Compare(a.Label, b.Label, StringComparison.OrdinalIgnoreCase));
            return list;
        }

        private static string FormatLabel(string columnName)
        {
            string label = columnName.Replace("_", " ");
            return CultureInfo.CurrentCulture.TextInfo.ToTitleCase(label.ToLowerInvariant());
        }

        private void BindMeta(LabResultModel model)
        {
            PatientNameLiteral.Text = model.PatientName;
            PatientIdLiteral.Text = model.PatientId;
            AgeLiteral.Text = model.PatientAge;
            SexLiteral.Text = model.PatientSex;
            PhoneLiteral.Text = model.PatientPhone;
            LocationLiteral.Text = model.PatientLocation;
            DoctorLiteral.Text = model.DoctorName;
            SampleDateLiteral.Text = model.SampleDate?.ToString("dd MMM yyyy") ?? DateTimeHelper.Now.ToString("dd MMM yyyy");
        }

        private void ShowError(string message)
        {
            ErrorLiteral.Text = message;
            ErrorPanel.Visible = true;
            ContentPanel.Visible = false;
        }

        private sealed class LabResultModel
        {
            public string LabResultId { get; set; }
            public DateTime? SampleDate { get; set; }
            public string PatientId { get; set; }
            public string PatientName { get; set; }
            public string PatientAge { get; set; }
            public string PatientSex { get; set; }
            public string PatientPhone { get; set; }
            public string PatientLocation { get; set; }
            public string DoctorName { get; set; }
            public List<LabResultEntry> OrderedTests { get; set; }
            public List<LabResultEntry> Results { get; set; }
        }

        private sealed class LabResultEntry
        {
            public string Label { get; set; }
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

