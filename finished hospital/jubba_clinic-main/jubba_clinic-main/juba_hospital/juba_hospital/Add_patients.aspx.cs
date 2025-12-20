using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class Add_patients : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string submitdata(string name, string number, string date, string gender, string doctor, string location, string registrationChargeId, string deliveryChargeId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Insert into patient table - patient type will be set by doctor, default to outpatient
                    string patientquery = @"INSERT INTO patient (full_name, dob, sex, location, phone, patient_type, date_registered) 
                                           VALUES (@name, @date, @gender, @location, @number, 'outpatient', @date_registered); 
                                           SELECT SCOPE_IDENTITY();";
                    int patient_id = 0;
                    using (SqlCommand cmd = new SqlCommand(patientquery, con))
                    {
                        cmd.Parameters.AddWithValue("@name", name);
                        cmd.Parameters.AddWithValue("@number", number);
                        cmd.Parameters.AddWithValue("@date", date);
                        cmd.Parameters.AddWithValue("@gender", gender);
                        cmd.Parameters.AddWithValue("@location", location);
                        cmd.Parameters.AddWithValue("@date_registered", DateTimeHelper.Now);

                        patient_id = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    int prescid = 0;
                    // Insert into prescribtion table
                    string presquery = "INSERT INTO prescribtion (patientid, doctorid) VALUES (@patient_id, @doctor); SELECT SCOPE_IDENTITY();";
                    using (SqlCommand mtidCmd = new SqlCommand(presquery, con))
                    {
                        mtidCmd.Parameters.AddWithValue("@doctor", doctor);
                        mtidCmd.Parameters.AddWithValue("@patient_id", patient_id);
                        prescid = Convert.ToInt32(mtidCmd.ExecuteScalar());
                    }

                    // Apply registration charge if selected
                    if (!string.IsNullOrEmpty(registrationChargeId) && registrationChargeId != "0")
                    {
                        string chargeQuery = "SELECT charge_name, amount FROM charges_config WHERE charge_config_id = @chargeId";
                        string chargeName = "";
                        decimal chargeAmount = 0;

                        using (SqlCommand chargeCmd = new SqlCommand(chargeQuery, con))
                        {
                            chargeCmd.Parameters.AddWithValue("@chargeId", registrationChargeId);
                            using (SqlDataReader dr = chargeCmd.ExecuteReader())
                            {
                                if (dr.Read())
                                {
                                    chargeName = dr["charge_name"].ToString();
                                    chargeAmount = Convert.ToDecimal(dr["amount"]);
                                }
                            }
                        }

                        if (chargeAmount > 0)
                        {
                            string invoiceNumber = "REG-" + DateTimeHelper.Now.ToString("yyyyMMdd") + "-" + patient_id.ToString().PadLeft(4, '0');

                            string chargeInsertQuery = @"INSERT INTO patient_charges 
                                (patientid, prescid, charge_type, charge_name, amount, is_paid, invoice_number) 
                                VALUES (@patientid, NULL, 'Registration', @charge_name, @amount, 1, @invoice_number)";

                            using (SqlCommand chargeInsertCmd = new SqlCommand(chargeInsertQuery, con))
                            {
                                chargeInsertCmd.Parameters.AddWithValue("@patientid", patient_id);
                                chargeInsertCmd.Parameters.AddWithValue("@charge_name", chargeName);
                                chargeInsertCmd.Parameters.AddWithValue("@amount", chargeAmount);
                                chargeInsertCmd.Parameters.AddWithValue("@invoice_number", invoiceNumber);
                                chargeInsertCmd.ExecuteNonQuery();
                            }
                        }
                    }

                    // Apply delivery charge if selected
                    if (!string.IsNullOrEmpty(deliveryChargeId) && deliveryChargeId != "0")
                    {
                        string chargeQuery = "SELECT charge_name, amount FROM charges_config WHERE charge_config_id = @chargeId";
                        string chargeName = "";
                        decimal chargeAmount = 0;

                        using (SqlCommand chargeCmd = new SqlCommand(chargeQuery, con))
                        {
                            chargeCmd.Parameters.AddWithValue("@chargeId", deliveryChargeId);
                            using (SqlDataReader dr = chargeCmd.ExecuteReader())
                            {
                                if (dr.Read())
                                {
                                    chargeName = dr["charge_name"].ToString();
                                    chargeAmount = Convert.ToDecimal(dr["amount"]);
                                }
                            }
                        }

                        if (chargeAmount > 0)
                        {
                            string deliveryInvoiceNumber = "DEL-" + DateTimeHelper.Now.ToString("yyyyMMdd") + "-" + patient_id.ToString().PadLeft(4, '0');

                            string deliveryChargeQuery = @"INSERT INTO patient_charges 
                                (patientid, prescid, charge_type, charge_name, amount, is_paid, invoice_number) 
                                VALUES (@patientid, NULL, 'Delivery', @charge_name, @amount, 1, @invoice_number)";

                            using (SqlCommand deliveryCmd = new SqlCommand(deliveryChargeQuery, con))
                            {
                                deliveryCmd.Parameters.AddWithValue("@patientid", patient_id);
                                deliveryCmd.Parameters.AddWithValue("@charge_name", chargeName);
                                deliveryCmd.Parameters.AddWithValue("@amount", chargeAmount);
                                deliveryCmd.Parameters.AddWithValue("@invoice_number", deliveryInvoiceNumber);
                                deliveryCmd.ExecuteNonQuery();
                            }
                        }
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                return "Error in submitdata method: " + ex.Message;
            }
        }

        [WebMethod]
        public static bool CheckIdExists(int phone)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    string query = "SELECT COUNT(*) FROM patient WHERE phone = @number";

                    using (SqlCommand command = new SqlCommand(query, con))
                    {
                        command.Parameters.AddWithValue("@number", phone);

                        int count = Convert.ToInt32(command.ExecuteScalar());
                        return count > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Error in CheckIdExists method", ex);
            }
        }

        [WebMethod]
        public static List<ListItem> getdoctor()
        {
            string query = "select doctorid, doctortitle from doctor";
            string constr = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand(query))
                {
                    List<ListItem> customers = new List<ListItem>();
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = con;
                    con.Open();
                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            customers.Add(new ListItem
                            {
                                Value = sdr["doctorid"].ToString(),
                                Text = sdr["doctortitle"].ToString()
                            });
                        }
                    }
                    con.Close();
                    return customers;
                }
            }
        }

        [WebMethod]
        public static List<ListItem> GetRegistrationCharges()
        {
            string query = "SELECT charge_config_id, charge_name, amount FROM charges_config WHERE charge_type = 'Registration' AND is_active = 1";
            string constr = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand(query))
                {
                    List<ListItem> charges = new List<ListItem>();
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = con;
                    con.Open();

                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            string displayText = sdr["charge_name"].ToString() + " - $" + Convert.ToDecimal(sdr["amount"]).ToString("0.00");
                            charges.Add(new ListItem
                            {
                                Value = sdr["charge_config_id"].ToString(),
                                Text = displayText
                            });
                        }
                    }
                    con.Close();
                    return charges;
                }
            }
        }

        [WebMethod]
        public static List<ListItem> GetDeliveryCharges()
        {
            string query = "SELECT charge_config_id, charge_name, amount FROM charges_config WHERE charge_type = 'Delivery' AND is_active = 1";
            string constr = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand(query))
                {
                    List<ListItem> charges = new List<ListItem>();
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = con;
                    con.Open();

                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            string displayText = sdr["charge_name"].ToString() + " - $" + Convert.ToDecimal(sdr["amount"]).ToString("0.00");
                            charges.Add(new ListItem
                            {
                                Value = sdr["charge_config_id"].ToString(),
                                Text = displayText
                            });
                        }
                    }
                    con.Close();
                    return charges;
                }
            }
        }
    }
}