using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace juba_hospital
{
    public partial class print_lab_revenue : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string startDate = Request.QueryString["startDate"];
                string endDate = Request.QueryString["endDate"];

                System.Diagnostics.Debug.WriteLine("Print Lab Revenue - Start Date: " + startDate);
                System.Diagnostics.Debug.WriteLine("Print Lab Revenue - End Date: " + endDate);

                if (!string.IsNullOrEmpty(startDate) && !string.IsNullOrEmpty(endDate))
                {
                    LoadLabRevenue(startDate, endDate);
                }
                else
                {
                    System.Diagnostics.Debug.WriteLine("ERROR: Dates are empty!");
                    litDateRange.Text = "No dates provided";
                    litTotalRevenue.Text = "0.00";
                    litTotalPaid.Text = "0.00";
                    litTotalUnpaid.Text = "0.00";
                    litTotalCharges.Text = "0";
                    litFooterTotal.Text = "0.00";
                }
            }
        }

        private void LoadLabRevenue(string startDate, string endDate)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Set report info
                    litDateRange.Text = DateTime.Parse(startDate).ToString("MMM dd, yyyy") + " - " + DateTime.Parse(endDate).ToString("MMM dd, yyyy");
                    litGeneratedDate.Text = DateTime.Now.ToString("MMMM dd, yyyy hh:mm tt");
                    litGeneratedBy.Text = Session["username"] != null ? Session["username"].ToString() : "Admin";

                    // Get lab charges data from patient_charges table
                    string query = @"
                        SELECT 
                            pc.charge_id,
                            p.full_name as patient_name,
                            pc.invoice_number,
                            pc.charge_name as test_name,
                            pc.date_added as charge_date,
                            pc.amount,
                            pc.is_paid as payment_status
                        FROM patient_charges pc
                        INNER JOIN patient p ON pc.patientid = p.patientid
                        WHERE pc.charge_type = 'Lab'
                        AND CAST(pc.date_added AS DATE) BETWEEN @startDate AND @endDate
                        ORDER BY pc.date_added DESC, pc.charge_id DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@startDate", startDate);
                        cmd.Parameters.AddWithValue("@endDate", endDate);

                        using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);

                            // Calculate totals
                            double totalRevenue = 0;
                            double totalPaid = 0;
                            double totalUnpaid = 0;
                            int totalCharges = dt.Rows.Count;

                            foreach (DataRow row in dt.Rows)
                            {
                                double amount = Convert.ToDouble(row["amount"]);
                                bool isPaid = Convert.ToBoolean(row["payment_status"]);

                                totalRevenue += amount;
                                if (isPaid)
                                {
                                    totalPaid += amount;
                                }
                                else
                                {
                                    totalUnpaid += amount;
                                }
                            }

                            // Set summary values
                            litTotalRevenue.Text = totalRevenue.ToString("N2");
                            litTotalPaid.Text = totalPaid.ToString("N2");
                            litTotalUnpaid.Text = totalUnpaid.ToString("N2");
                            litTotalCharges.Text = totalCharges.ToString();
                            litFooterTotal.Text = totalRevenue.ToString("N2");

                            // Bind data to repeater
                            rptLabCharges.DataSource = dt;
                            rptLabCharges.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading lab revenue: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Stack trace: " + ex.StackTrace);
                litDateRange.Text = "Error: " + ex.Message;
                litTotalRevenue.Text = "0.00";
                litTotalPaid.Text = "0.00";
                litTotalUnpaid.Text = "0.00";
                litTotalCharges.Text = "0";
                litFooterTotal.Text = "0.00";
            }
        }
    }
}
