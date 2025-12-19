using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Services;

namespace juba_hospital
{
    public partial class add_bed_charges : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        [WebMethod]
        public static decimal GetBedChargeAmount()
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            decimal amount = 0;

            try
            {
                using (SqlConnection conn = new SqlConnection(cs))
                {
                    conn.Open();
                    string query = @"SELECT TOP 1 amount FROM bed_charges ORDER BY bed_charge_id DESC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            amount = Convert.ToDecimal(result);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error getting bed charge amount: " + ex.Message);
            }

            return amount;
        }

        [WebMethod]
        public static List<PatientCharge> GetPendingBedCharges()
        {
            List<PatientCharge> charges = new List<PatientCharge>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(cs))
                {
                    conn.Open();
                    
                    // Get bed charges from patient_bed_charges table - simple query like charge_history
                    string query = @"
                        SELECT 
                            pbc.bed_charge_id,
                            pbc.patientid,
                            pbc.prescid,
                            p.full_name,
                            ISNULL(p.phone, 'N/A') as phone,
                            ISNULL(p.location, 'N/A') as location,
                            pbc.charge_date,
                            CONVERT(VARCHAR(10), pbc.charge_date, 120) as charge_date_formatted,
                            pbc.bed_charge_amount,
                            pbc.is_paid,
                            CASE 
                                WHEN pbc.is_paid = 1 THEN 'Paid'
                                ELSE 'Unpaid'
                            END as status,
                            ISNULL(d.doctortitle, 'N/A') as doctortitle,
                            ISNULL(p.bed_admission_date, pbc.charge_date) as bed_admission_date,
                            DATEDIFF(DAY, ISNULL(p.bed_admission_date, pbc.charge_date), pbc.charge_date) + 1 as day_number
                        FROM patient_bed_charges pbc
                        INNER JOIN patient p ON pbc.patientid = p.patientid
                        LEFT JOIN prescribtion pr ON pbc.prescid = pr.prescid
                        LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                        WHERE pbc.is_paid = 0
                        ORDER BY p.patientid, pbc.charge_date ASC";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                PatientCharge charge = new PatientCharge
                                {
                                    bed_charge_id = reader["bed_charge_id"].ToString(),
                                    patientid = reader["patientid"].ToString(),
                                    prescid = reader["prescid"] == DBNull.Value ? "" : reader["prescid"].ToString(),
                                    full_name = reader["full_name"].ToString(),
                                    phone = reader["phone"].ToString(),
                                    location = reader["location"].ToString(),
                                    doctortitle = reader["doctortitle"].ToString(),
                                    charge_date_formatted = reader["charge_date_formatted"].ToString(),
                                    bed_charge_amount = reader["bed_charge_amount"].ToString(),
                                    day_number = reader["day_number"].ToString(),
                                    status = reader["status"].ToString()
                                };
                                charges.Add(charge);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error getting pending bed charges: " + ex.Message);
            }

            return charges;
        }

        [WebMethod]
        public static string ProcessBedPayment(string bedChargeId, string patientid, decimal amount, string paymentMethod)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(cs))
                {
                    conn.Open();

                    // Check if bed charge exists and is not already paid
                    string checkQuery = "SELECT is_paid FROM patient_bed_charges WHERE bed_charge_id = @bedChargeId";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@bedChargeId", bedChargeId);
                        object result = checkCmd.ExecuteScalar();
                        
                        if (result == null)
                        {
                            return "Bed charge not found.";
                        }
                        
                        if (Convert.ToBoolean(result))
                        {
                            return "Bed charge has already been paid.";
                        }
                    }

                    // Update patient_bed_charges to mark as paid
                    string updateQuery = @"
                        UPDATE patient_bed_charges 
                        SET is_paid = 1
                        WHERE bed_charge_id = @bedChargeId";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                    {
                        cmd.Parameters.AddWithValue("@bedChargeId", bedChargeId);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            return "Success";
                        }
                        else
                        {
                            return "Failed to process payment";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error processing bed payment: " + ex.Message);
                return "Error: " + ex.Message;
            }
        }

        public class PatientCharge
        {
            public string bed_charge_id { get; set; }
            public string patientid { get; set; }
            public string prescid { get; set; }
            public string full_name { get; set; }
            public string phone { get; set; }
            public string location { get; set; }
            public string doctortitle { get; set; }
            public string charge_date_formatted { get; set; }
            public string bed_charge_amount { get; set; }
            public string day_number { get; set; }
            public string status { get; set; }
        }
    }
}
