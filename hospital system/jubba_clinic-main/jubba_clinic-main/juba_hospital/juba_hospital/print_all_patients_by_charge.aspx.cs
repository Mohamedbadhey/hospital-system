using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class print_all_patients_by_charge : System.Web.UI.Page
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
            string chargeType = Request.QueryString["type"];
            string startDateStr = Request.QueryString["startDate"];
            string endDateStr = Request.QueryString["endDate"];

            if (string.IsNullOrEmpty(chargeType))
            {
                litTotalPatients.Text = "0";
                litChargeType.Text = "Not specified";
                return;
            }

            litChargeType.Text = chargeType == "All" ? "All Charge Types" : chargeType;
            
            // Parse date range if provided
            DateTime? startDate = null;
            DateTime? endDate = null;
            
            if (!string.IsNullOrEmpty(startDateStr) && DateTime.TryParse(startDateStr, out DateTime parsedStart))
            {
                startDate = parsedStart;
            }
            
            if (!string.IsNullOrEmpty(endDateStr) && DateTime.TryParse(endDateStr, out DateTime parsedEnd))
            {
                endDate = parsedEnd.AddHours(23).AddMinutes(59).AddSeconds(59); // End of day
            }
            
            // Display date range if filtered
            if (startDate.HasValue && endDate.HasValue)
            {
                dateRangeContainer.Visible = true;
                litDateRange.Text = $"{startDate.Value:MMM dd, yyyy} - {endDate.Value:MMM dd, yyyy}";
            }
            else
            {
                dateRangeContainer.Visible = false;
                litDateRange.Text = "All Time";
            }

            using (SqlConnection con = new SqlConnection(cs))
            {
                // Build query based on whether "All" is selected or specific type
                string query;
                // Build WHERE clause for date filtering
                // Filter by date_added (when charge was created)
                string dateFilter = "";
                if (startDate.HasValue && endDate.HasValue)
                {
                    dateFilter = " AND pc.date_added >= @startDate AND pc.date_added <= @endDate";
                }

                if (chargeType == "All")
                {
                    // Get all patients who have ANY charges (including bed charges)
                    query = @"
                        SELECT 
                            p.patientid,
                            p.full_name,
                            p.dob,
                            DATEDIFF(YEAR, p.dob, GETDATE()) as age,
                            p.sex,
                            p.phone,
                            p.location,
                            p.date_registered,
                            ISNULL(SUM(charges.amount), 0) as total_charges,
                            ISNULL(SUM(CASE WHEN charges.is_paid = 1 THEN charges.amount ELSE 0 END), 0) as paid_amount,
                            ISNULL(SUM(CASE WHEN charges.is_paid = 0 OR charges.is_paid IS NULL THEN charges.amount ELSE 0 END), 0) as unpaid_amount
                        FROM patient p
                        INNER JOIN (
                            -- Regular charges
                            SELECT patientid, amount, is_paid, date_added
                            FROM patient_charges
                            WHERE 1=1" + dateFilter.Replace("pc.", "") + @"
                            
                            UNION ALL
                            
                            -- Bed charges
                            SELECT patientid, bed_charge_amount as amount, is_paid, created_at as date_added
                            FROM patient_bed_charges
                            WHERE 1=1" + dateFilter.Replace("pc.date_added", "created_at") + @"
                        ) charges ON p.patientid = charges.patientid
                        GROUP BY p.patientid, p.full_name, p.dob, p.sex, p.phone, p.location, p.date_registered
                        ORDER BY p.date_registered DESC";
                }
                else if (chargeType == "Bed")
                {
                    // Get patients with Bed charges (from patient_bed_charges table)
                    query = @"
                        SELECT 
                            p.patientid,
                            p.full_name,
                            p.dob,
                            DATEDIFF(YEAR, p.dob, GETDATE()) as age,
                            p.sex,
                            p.phone,
                            p.location,
                            p.date_registered,
                            ISNULL(SUM(pbc.bed_charge_amount), 0) as total_charges,
                            ISNULL(SUM(CASE WHEN pbc.is_paid = 1 THEN pbc.bed_charge_amount ELSE 0 END), 0) as paid_amount,
                            ISNULL(SUM(CASE WHEN pbc.is_paid = 0 OR pbc.is_paid IS NULL THEN pbc.bed_charge_amount ELSE 0 END), 0) as unpaid_amount
                        FROM patient p
                        INNER JOIN patient_bed_charges pbc ON p.patientid = pbc.patientid
                        WHERE 1=1" + dateFilter.Replace("pc.date_added", "pbc.created_at") + @"
                        GROUP BY p.patientid, p.full_name, p.dob, p.sex, p.phone, p.location, p.date_registered
                        ORDER BY p.date_registered DESC";
                }
                else
                {
                    // Get patients with specific charge type (non-bed charges)
                    query = @"
                        SELECT DISTINCT
                            p.patientid,
                            p.full_name,
                            p.dob,
                            DATEDIFF(YEAR, p.dob, GETDATE()) as age,
                            p.sex,
                            p.phone,
                            p.location,
                            p.date_registered,
                            ISNULL(SUM(pc.amount), 0) as total_charges,
                            ISNULL(SUM(CASE WHEN pc.is_paid = 1 THEN pc.amount ELSE 0 END), 0) as paid_amount,
                            ISNULL(SUM(CASE WHEN pc.is_paid = 0 THEN pc.amount ELSE 0 END), 0) as unpaid_amount
                        FROM patient p
                        INNER JOIN patient_charges pc ON p.patientid = pc.patientid
                        WHERE pc.charge_type = @chargeType" + dateFilter + @"
                        GROUP BY p.patientid, p.full_name, p.dob, p.sex, p.phone, p.location, p.date_registered
                        ORDER BY p.date_registered DESC";
                }

                SqlCommand cmd = new SqlCommand(query, con);
                
                // Only add parameter if not "All" and not "Bed"
                if (chargeType != "All" && chargeType != "Bed")
                {
                    cmd.Parameters.AddWithValue("@chargeType", chargeType);
                }
                
                // Add date parameters if provided
                if (startDate.HasValue && endDate.HasValue)
                {
                    cmd.Parameters.AddWithValue("@startDate", startDate.Value);
                    cmd.Parameters.AddWithValue("@endDate", endDate.Value);
                }

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
