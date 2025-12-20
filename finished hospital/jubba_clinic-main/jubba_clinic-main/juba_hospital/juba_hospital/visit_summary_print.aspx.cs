using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class visit_summary_print : Page
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected Panel ErrorPanel;
        protected Literal ErrorMessageLiteral;
        protected Panel ReportPanel;
        protected Literal PrintHeaderLiteral;
        protected Literal VisitNumberLiteral;
        protected Literal GeneratedOnLiteral;
        protected Literal PatientNameLiteral;
        protected Literal PatientIdLiteral;
        protected Literal GenderLiteral;
        protected Literal AgeLiteral;
        protected Literal PhoneLiteral;
        protected Literal LocationLiteral;
        protected Literal DoctorLiteral;
        protected Literal DateRegisteredLiteral;
        protected Panel LabTestsPanel;
        protected Literal LabTestsTimestampLiteral;
        protected PlaceHolder NoLabTestsPlaceholder;
        protected Panel LabTestsTablePanel;
        protected Repeater LabTestsRepeater;
        protected Panel LabResultsPanel;
        protected Literal LabResultsTimestampLiteral;
        protected PlaceHolder NoLabResultsPlaceholder;
        protected Panel LabResultsTablePanel;
        protected Repeater LabResultsRepeater;
        protected Panel MedicationPanel;
        protected PlaceHolder NoMedicationPlaceholder;
        protected Panel MedicationTablePanel;
        protected Repeater MedicationRepeater;

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

            GeneratedOnLiteral.Text = DateTimeHelper.Now.ToString("dd MMM yyyy HH:mm");

            string prescidValue = Request.QueryString["prescid"];
            if (!int.TryParse(prescidValue, out int prescid))
            {
                ShowError("Invalid or missing prescription id. Please open this report from a valid patient record.");
                return;
            }

            try
            {
                using (var connection = new SqlConnection(ConnectionString))
                {
                    connection.Open();

                    PatientInfo patient = LoadPatientInfo(connection, prescid);
                    if (patient == null)
                    {
                        ShowError("We could not locate the requested visit. Please ensure the patient has an active prescription.");
                        return;
                    }

                    BindPatientInfo(patient);
                    VisitNumberLiteral.Text = prescid.ToString(CultureInfo.InvariantCulture);

                    SectionData labTests = LoadSection(connection,
                        "SELECT TOP 1 * FROM lab_test WHERE prescid = @prescid ORDER BY date_taken DESC",
                        "date_taken",
                        new[] { "med_id", "prescid", "date_taken" },
                        prescid);
                    BindSection(labTests, LabTestsPanel, LabTestsTimestampLiteral, LabTestsRepeater, LabTestsTablePanel, NoLabTestsPlaceholder);

                    SectionData labResults = LoadSection(connection,
                        "SELECT TOP 1 * FROM lab_results WHERE prescid = @prescid ORDER BY date_taken DESC",
                        "date_taken",
                        new[] { "lab_result_id", "prescid", "date_taken" },
                        prescid);
                    BindSection(labResults, LabResultsPanel, LabResultsTimestampLiteral, LabResultsRepeater, LabResultsTablePanel, NoLabResultsPlaceholder);

                    List<MedicationInfo> medications = LoadMedication(connection, prescid);
                    BindMedications(medications);
                }

                ReportPanel.Visible = true;
                ErrorPanel.Visible = false;
            }
            catch (Exception ex)
            {
                ShowError("Something went wrong while preparing the report. Details: " + ex.Message);
            }
        }

        private static PatientInfo LoadPatientInfo(SqlConnection connection, int prescid)
        {
            const string query = @"
                SELECT TOP 1
                    p.patientid,
                    p.full_name,
                    p.sex,
                    p.dob,
                    p.phone,
                    p.location,
                    p.date_registered,
                    d.doctorname,
                    d.doctortitle
                FROM prescribtion pr
                INNER JOIN patient p ON pr.patientid = p.patientid
                LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                WHERE pr.prescid = @prescid";

            using (var cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@prescid", prescid);
                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        return null;
                    }

                    return new PatientInfo
                    {
                        PatientId = reader["patientid"].ToString(),
                        FullName = reader["full_name"].ToString(),
                        Gender = reader["sex"].ToString(),
                        Phone = reader["phone"].ToString(),
                        Location = reader["location"].ToString(),
                        Doctor = BuildDoctorName(reader["doctorname"], reader["doctortitle"]),
                        DateRegistered = SafeDate(reader["date_registered"]),
                        DateOfBirth = SafeDate(reader["dob"])
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

        private static DateTime? SafeDate(object value)
        {
            if (value == DBNull.Value || value == null)
            {
                return null;
            }

            if (DateTime.TryParse(value.ToString(), out DateTime parsed))
            {
                return parsed;
            }

            return null;
        }

        private void BindPatientInfo(PatientInfo patient)
        {
            PatientNameLiteral.Text = string.IsNullOrWhiteSpace(patient.FullName) ? "—" : patient.FullName;
            PatientIdLiteral.Text = string.IsNullOrWhiteSpace(patient.PatientId) ? "—" : patient.PatientId;
            GenderLiteral.Text = string.IsNullOrWhiteSpace(patient.Gender) ? "—" : patient.Gender;
            PhoneLiteral.Text = string.IsNullOrWhiteSpace(patient.Phone) ? "—" : patient.Phone;
            LocationLiteral.Text = string.IsNullOrWhiteSpace(patient.Location) ? "—" : patient.Location;
            DoctorLiteral.Text = patient.Doctor;
            DateRegisteredLiteral.Text = patient.DateRegistered?.ToString("dd MMM yyyy") ?? "—";

            if (patient.DateOfBirth.HasValue)
            {
                int age = DateTimeHelper.Today.Year - patient.DateOfBirth.Value.Year;
                if (patient.DateOfBirth.Value.Date > DateTimeHelper.Today.AddYears(-age)) age--;
                AgeLiteral.Text = age < 0 ? "—" : $"{age} yrs";
            }
            else
            {
                AgeLiteral.Text = "—";
            }
        }

        private static SectionData LoadSection(SqlConnection connection, string query, string timestampColumn, string[] skipColumns, int prescid)
        {
            using (var cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@prescid", prescid);
                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        return null;
                    }

                    DateTime? timestamp = null;
                    if (!string.IsNullOrWhiteSpace(timestampColumn) && !reader.IsDBNull(reader.GetOrdinal(timestampColumn)))
                    {
                        timestamp = reader.GetDateTime(reader.GetOrdinal(timestampColumn));
                    }

                    var skipSet = new HashSet<string>(skipColumns ?? Array.Empty<string>(), StringComparer.OrdinalIgnoreCase);
                    var items = new List<FieldValue>();

                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        string columnName = reader.GetName(i);
                        if (skipSet.Contains(columnName))
                        {
                            continue;
                        }

                        if (reader.IsDBNull(i))
                        {
                            continue;
                        }

                        string value = reader.GetValue(i).ToString();
                        
                        // Skip empty values and "not checked" values (for lab tests)
                        if (string.IsNullOrWhiteSpace(value) || 
                            string.Equals(value, "not checked", StringComparison.OrdinalIgnoreCase))
                        {
                            continue;
                        }

                        items.Add(new FieldValue
                        {
                            Label = Humanize(columnName),
                            Value = value
                        });
                    }

                    return new SectionData
                    {
                        Items = items.OrderBy(i => i.Label).ToList(),
                        Timestamp = timestamp
                    };
                }
            }
        }

        private void BindSection(SectionData data, Panel panel, Literal timestampLiteral, Repeater repeater, Panel tablePanel, PlaceHolder placeholder)
        {
            panel.Visible = true;

            if (data == null || data.Items.Count == 0)
            {
                placeholder.Visible = true;
                tablePanel.Visible = false;
                timestampLiteral.Text = "Not available";
                return;
            }

            placeholder.Visible = false;
            tablePanel.Visible = true;
            timestampLiteral.Text = data.Timestamp?.ToString("dd MMM yyyy HH:mm") ?? "Not timestamped";
            repeater.DataSource = data.Items;
            repeater.DataBind();
        }

        private static List<MedicationInfo> LoadMedication(SqlConnection connection, int prescid)
        {
            const string query = @"
                SELECT med_name, dosage, frequency, duration, special_inst
                FROM medication
                WHERE prescid = @prescid
                ORDER BY date_taken DESC, medid DESC";

            var meds = new List<MedicationInfo>();

            using (var cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@prescid", prescid);
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        meds.Add(new MedicationInfo
                        {
                            Name = reader["med_name"].ToString(),
                            Dosage = reader["dosage"].ToString(),
                            Frequency = reader["frequency"].ToString(),
                            Duration = reader["duration"].ToString(),
                            Instructions = reader["special_inst"].ToString()
                        });
                    }
                }
            }

            return meds;
        }

        private void BindMedications(List<MedicationInfo> meds)
        {
            if (meds == null || meds.Count == 0)
            {
                MedicationPanel.Visible = true;
                MedicationTablePanel.Visible = false;
                NoMedicationPlaceholder.Visible = true;
                return;
            }

            MedicationPanel.Visible = true;
            MedicationTablePanel.Visible = true;
            NoMedicationPlaceholder.Visible = false;
            MedicationRepeater.DataSource = meds;
            MedicationRepeater.DataBind();
        }

        private void ShowError(string message)
        {
            ReportPanel.Visible = false;
            ErrorPanel.Visible = true;
            ErrorMessageLiteral.Text = message;
        }

        private static string Humanize(string columnName)
        {
            if (string.IsNullOrWhiteSpace(columnName))
            {
                return string.Empty;
            }

            string withSpaces = Regex.Replace(columnName, "([a-z])([A-Z])", "$1 $2");
            withSpaces = withSpaces.Replace("_", " ");
            return CultureInfo.CurrentCulture.TextInfo.ToTitleCase(withSpaces.ToLowerInvariant());
        }

        private sealed class PatientInfo
        {
            public string PatientId { get; set; }
            public string FullName { get; set; }
            public string Gender { get; set; }
            public string Phone { get; set; }
            public string Location { get; set; }
            public string Doctor { get; set; }
            public DateTime? DateRegistered { get; set; }
            public DateTime? DateOfBirth { get; set; }
        }

        private sealed class SectionData
        {
            public List<FieldValue> Items { get; set; } = new List<FieldValue>();
            public DateTime? Timestamp { get; set; }
        }

        private sealed class FieldValue
        {
            public string Label { get; set; }
            public string Value { get; set; }
        }

        private sealed class MedicationInfo
        {
            public string Name { get; set; }
            public string Dosage { get; set; }
            public string Frequency { get; set; }
            public string Duration { get; set; }
            public string Instructions { get; set; }
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

