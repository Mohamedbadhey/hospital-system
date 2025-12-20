using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class medication_print : Page
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

            string prescidValue = Request.QueryString["prescid"];
            if (!int.TryParse(prescidValue, out int prescid))
            {
                ShowError("Invalid or missing prescription ID. Please access this page from a valid patient record.");
                return;
            }

            try
            {
                using (var connection = new SqlConnection(ConnectionString))
                {
                    connection.Open();

                    // Load patient information
                    LoadPatientInfo(connection, prescid);

                    // Load medications
                    LoadMedications(connection, prescid);
                }

                ContentPanel.Visible = true;
                ErrorPanel.Visible = false;
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while loading the medication report: " + ex.Message);
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

                        DateLiteral.Text = DateTimeHelper.Now.ToString("dd MMM yyyy");
                    }
                    else
                    {
                        ShowError("Patient information not found for the given prescription ID.");
                    }
                }
            }
        }

        private void LoadMedications(SqlConnection connection, int prescid)
        {
            string query = @"
                SELECT 
                    medid,
                    med_name,
                    dosage,
                    frequency,
                    duration,
                    special_inst,
                    date_taken
                FROM medication
                WHERE prescid = @prescid
                ORDER BY date_taken DESC, medid DESC";

            using (var cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@prescid", prescid);
                
                DataTable dt = new DataTable();
                using (var adapter = new SqlDataAdapter(cmd))
                {
                    adapter.Fill(dt);
                }

                if (dt.Rows.Count > 0)
                {
                    MedicationsRepeater.DataSource = dt;
                    MedicationsRepeater.DataBind();
                    MedicationsPanel.Visible = true;
                    NoMedicationsPanel.Visible = false;
                }
                else
                {
                    MedicationsPanel.Visible = false;
                    NoMedicationsPanel.Visible = true;
                }
            }
        }

        private void ShowError(string message)
        {
            ErrorLiteral.Text = message;
            ErrorPanel.Visible = true;
            ContentPanel.Visible = false;
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
