using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class lab_comprehensive_report : Page
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;



        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                return;
            }

            string prescid = Request.QueryString["prescid"];
            string reportType = Request.QueryString["type"] ?? "both"; // both, ordered, results

            if (string.IsNullOrWhiteSpace(prescid))
            {
                ShowError("Missing prescription identifier.");
                return;
            }

            try
            {
                using (SqlConnection connection = new SqlConnection(ConnectionString))
                {
                    connection.Open();

                    // Load patient info
                    PatientInfo patient = LoadPatientInfo(connection, prescid);
                    if (patient == null)
                    {
                        ShowError("No patient record found for this prescription.");
                        return;
                    }

                    PrintHeaderLiteral.Text = HospitalSettingsHelper.GetPrintHeaderHTML();
                    BindPatientInfo(patient);
                    ReportTypeLiteral.Text = GetReportTypeLabel(reportType);

                    // Load and display based on report type
                    if (reportType == "ordered" || reportType == "both")
                    {
                        List<LabTestEntry> orderedTests = LoadOrderedTests(connection, prescid);
                        BindOrderedTests(orderedTests);
                        OrderedTestsPanel.Visible = true;
                    }
                    else
                    {
                        OrderedTestsPanel.Visible = false;
                    }

                    if (reportType == "results" || reportType == "both")
                    {
                        LabResultData resultData = LoadLabResults(connection, prescid);
                        BindResults(resultData);
                        ResultsPanel.Visible = resultData != null && resultData.Results.Count > 0;
                    }
                    else
                    {
                        ResultsPanel.Visible = false;
                    }

                    ContentPanel.Visible = true;
                    ErrorPanel.Visible = false;
                }
            }
            catch (Exception ex)
            {
                ShowError("Unable to load lab report. Details: " + ex.Message);
            }
        }

        private static string GetReportTypeLabel(string reportType)
        {
            switch (reportType.ToLower())
            {
                case "ordered":
                    return "Ordered Lab Tests";
                case "results":
                    return "Lab Test Results";
                case "both":
                    return "Complete Lab Report (Ordered Tests & Results)";
                default:
                    return "Lab Report";
            }
        }

        private static PatientInfo LoadPatientInfo(SqlConnection connection, string prescid)
        {
            const string query = @"
                SELECT TOP 1
                    p.patientid,
                    p.full_name,
                    d.doctorname,
                    d.doctortitle
                FROM prescribtion pr
                INNER JOIN patient p ON pr.patientid = p.patientid
                LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                WHERE pr.prescid = @prescid";

            using (SqlCommand cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@prescid", prescid);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        return null;
                    }

                    return new PatientInfo
                    {
                        PatientId = reader["patientid"].ToString(),
                        FullName = reader["full_name"].ToString(),
                        Doctor = BuildDoctorName(reader["doctorname"], reader["doctortitle"])
                    };
                }
            }
        }

        private static string BuildDoctorName(object doctorName, object doctorTitle)
        {
            string name = doctorName == DBNull.Value ? string.Empty : doctorName.ToString();
            string title = doctorTitle == DBNull.Value ? string.Empty : doctorTitle.ToString();

            if (string.IsNullOrWhiteSpace(name) && string.IsNullOrWhiteSpace(title))
            {
                return "—";
            }

            if (string.IsNullOrWhiteSpace(title))
            {
                return name;
            }

            if (string.IsNullOrWhiteSpace(name))
            {
                return title;
            }

            return $"{title} ({name})";
        }

        private static List<LabTestEntry> LoadOrderedTests(SqlConnection connection, string prescid)
        {
            const string query = "SELECT TOP 1 * FROM lab_test WHERE prescid = @prescid ORDER BY date_taken DESC";
            var tests = new List<LabTestEntry>();

            var excludedColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "med_id", "prescid", "date_taken"
            };

            using (SqlCommand cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@prescid", prescid);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        return tests;
                    }

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
                        if (string.IsNullOrWhiteSpace(stringValue) || 
                            string.Equals(stringValue, "not checked", StringComparison.OrdinalIgnoreCase))
                        {
                            continue;
                        }

                        tests.Add(new LabTestEntry
                        {
                            TestName = FormatLabel(columnName),
                            Status = stringValue
                        });
                    }
                }
            }

            tests.Sort((a, b) => string.Compare(a.TestName, b.TestName, StringComparison.OrdinalIgnoreCase));
            return tests;
        }

        private static LabResultData LoadLabResults(SqlConnection connection, string prescid)
        {
            const string query = @"
                SELECT TOP 1 *
                FROM lab_results
                WHERE prescid = @prescid
                ORDER BY date_taken DESC";

            var excludedColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
            {
                "lab_result_id", "prescid", "date_taken", "date_added", "last_updated"
            };

            using (SqlCommand cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@prescid", prescid);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        return null;
                    }

                    DateTime? sampleDate = null;
                    int dateTakenOrdinal = reader.GetOrdinal("date_taken");
                    if (!reader.IsDBNull(dateTakenOrdinal))
                    {
                        sampleDate = reader.GetDateTime(dateTakenOrdinal);
                    }

                    var results = new List<LabResultEntry>();

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
                        if (string.IsNullOrWhiteSpace(stringValue) || 
                            string.Equals(stringValue, "not checked", StringComparison.OrdinalIgnoreCase))
                        {
                            continue;
                        }

                        results.Add(new LabResultEntry
                        {
                            TestName = FormatLabel(columnName),
                            Result = stringValue
                        });
                    }

                    results.Sort((a, b) => string.Compare(a.TestName, b.TestName, StringComparison.OrdinalIgnoreCase));

                    return new LabResultData
                    {
                        SampleDate = sampleDate,
                        Results = results
                    };
                }
            }
        }

        private static string FormatLabel(string columnName)
        {
            string label = columnName.Replace("_", " ");
            return CultureInfo.CurrentCulture.TextInfo.ToTitleCase(label.ToLowerInvariant());
        }

        private void BindPatientInfo(PatientInfo patient)
        {
            PatientNameLiteral.Text = string.IsNullOrWhiteSpace(patient.FullName) ? "—" : patient.FullName;
            PatientIdLiteral.Text = string.IsNullOrWhiteSpace(patient.PatientId) ? "—" : patient.PatientId;
            DoctorLiteral.Text = patient.Doctor;
        }

        private void BindOrderedTests(List<LabTestEntry> tests)
        {
            OrderedTestsRepeater.DataSource = tests;
            OrderedTestsRepeater.DataBind();
        }

        private void BindResults(LabResultData resultData)
        {
            if (resultData != null)
            {
                SampleDateLiteral.Text = resultData.SampleDate?.ToString("dd MMM yyyy HH:mm") ?? "—";
                ResultsRepeater.DataSource = resultData.Results;
                ResultsRepeater.DataBind();
            }
        }

        private void ShowError(string message)
        {
            ErrorLiteral.Text = message;
            ErrorPanel.Visible = true;
            ContentPanel.Visible = false;
        }

        private sealed class PatientInfo
        {
            public string PatientId { get; set; }
            public string FullName { get; set; }
            public string Doctor { get; set; }
        }

        private sealed class LabTestEntry
        {
            public string TestName { get; set; }
            public string Status { get; set; }
        }

        private sealed class LabResultEntry
        {
            public string TestName { get; set; }
            public string Result { get; set; }
        }

        private sealed class LabResultData
        {
            public DateTime? SampleDate { get; set; }
            public List<LabResultEntry> Results { get; set; }
        }
    }
}
