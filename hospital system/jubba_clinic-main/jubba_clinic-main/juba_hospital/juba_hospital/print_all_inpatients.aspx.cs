using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class print_all_inpatients : System.Web.UI.Page
    {
        private string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Load hospital header using the standard helper
                PrintHeaderLiteral.Text = HospitalSettingsHelper.GetPrintHeaderHTML();
                
                // Load footer hospital name
                LoadFooterInfo();
                
                LoadPatients();
            }
        }

        private void LoadFooterInfo()
        {
            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = "SELECT TOP 1 hospital_name FROM hospital_settings";
                SqlCommand cmd = new SqlCommand(query, con);

                try
                {
                    con.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    if (reader.Read())
                    {
                        litFooterHospital.Text = reader["hospital_name"].ToString();
                    }
                    else
                    {
                        litFooterHospital.Text = "Juba Hospital";
                    }

                    reader.Close();
                }
                catch (Exception)
                {
                    litFooterHospital.Text = "Juba Hospital";
                }
            }
        }

        private void LoadPatients()
        {
            string patientIds = Request.QueryString["patientids"];

            if (string.IsNullOrEmpty(patientIds))
            {
                litTotalPatients.Text = "0";
                return;
            }

            // Convert comma-separated IDs to SQL IN clause format
            var ids = patientIds.Split(',').Select(id => id.Trim()).Where(id => !string.IsNullOrEmpty(id));
            string inClause = string.Join(",", ids);

            // Debug logging
            System.Diagnostics.Debug.WriteLine("Inpatients Print - Patient IDs: " + patientIds);
            System.Diagnostics.Debug.WriteLine("IN Clause: " + inClause);

            using (SqlConnection con = new SqlConnection(cs))
            {
                string query = $@"
                    SELECT 
                        p.patientid,
                        p.full_name,
                        p.dob,
                        DATEDIFF(YEAR, p.dob, GETDATE()) as age,
                        p.sex,
                        p.phone,
                        p.location,
                        p.date_registered,
                        p.bed_admission_date,
                        ISNULL(SUM(pc.amount), 0) as total_charges,
                        ISNULL(SUM(CASE WHEN pc.is_paid = 1 THEN pc.amount ELSE 0 END), 0) as paid_amount,
                        ISNULL(SUM(CASE WHEN pc.is_paid = 0 THEN pc.amount ELSE 0 END), 0) as unpaid_amount
                    FROM patient p
                    LEFT JOIN patient_charges pc ON p.patientid = pc.patientid
                    WHERE p.patientid IN ({inClause})
                    GROUP BY p.patientid, p.full_name, p.dob, p.sex, p.phone, p.location, p.date_registered, p.bed_admission_date
                    ORDER BY p.bed_admission_date DESC, p.date_registered DESC";

                SqlCommand cmd = new SqlCommand(query, con);

                try
                {
                    con.Open();
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptPatients.DataSource = dt;
                        rptPatients.DataBind();

                        // Calculate summary
                        decimal totalCharges = 0;
                        decimal totalPaid = 0;
                        decimal totalUnpaid = 0;
                        int fullyPaidCount = 0;
                        int unpaidCount = 0;

                        foreach (DataRow row in dt.Rows)
                        {
                            decimal charges = Convert.ToDecimal(row["total_charges"]);
                            decimal paid = Convert.ToDecimal(row["paid_amount"]);
                            decimal unpaid = Convert.ToDecimal(row["unpaid_amount"]);

                            totalCharges += charges;
                            totalPaid += paid;
                            totalUnpaid += unpaid;

                            if (unpaid > 0)
                                unpaidCount++;
                            else
                                fullyPaidCount++;
                        }

                        // Calculate collection rate
                        decimal collectionRate = 0;
                        if (totalCharges > 0)
                        {
                            collectionRate = (totalPaid / totalCharges) * 100;
                        }

                        litTotalPatients.Text = dt.Rows.Count.ToString();
                        litTotalCharges.Text = totalCharges.ToString("N2");
                        litTotalPaid.Text = totalPaid.ToString("N2");
                        litTotalUnpaid.Text = totalUnpaid.ToString("N2");
                        litFullyPaidCount.Text = fullyPaidCount.ToString();
                        litUnpaidCount.Text = unpaidCount.ToString();
                        litCollectionRate.Text = collectionRate.ToString("N1");
                    }
                    else
                    {
                        litTotalPatients.Text = "0";
                        litTotalCharges.Text = "0.00";
                        litTotalPaid.Text = "0.00";
                        litTotalUnpaid.Text = "0.00";
                        litFullyPaidCount.Text = "0";
                        litUnpaidCount.Text = "0";
                        litCollectionRate.Text = "0.0";
                    }
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("LoadPatients Error: " + ex.Message);
                    System.Diagnostics.Debug.WriteLine("LoadPatients Stack Trace: " + ex.StackTrace);
                    litTotalPatients.Text = "Error: " + ex.Message;
                }
            }

            // Set report metadata
            litReportDate.Text = DateTimeHelper.Now.ToString("MMMM dd, yyyy hh:mm tt");
            
            // Get logged in user
            if (Session["username"] != null)
            {
                litGeneratedBy.Text = Session["username"].ToString();
            }
            else
            {
                litGeneratedBy.Text = "System";
            }
        }
    }
}
