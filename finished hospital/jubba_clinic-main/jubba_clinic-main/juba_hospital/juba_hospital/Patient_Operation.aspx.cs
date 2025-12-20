using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace juba_hospital
{
    public partial class Patient_Operation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static string deletepatient(string id, string pid)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Delete from patient table
                    string jobQuery = "DELETE FROM [patient] WHERE [patientid] = @id";

                    using (SqlCommand cmd = new SqlCommand(jobQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@id", pid);
                        cmd.ExecuteNonQuery();
                    }

                    // Delete from prescription table
                    string prescdelete = "DELETE FROM [prescribtion] WHERE [prescid] = @id";

                    using (SqlCommand cmd1 = new SqlCommand(prescdelete, con))
                    {
                        cmd1.Parameters.AddWithValue("@id", id);
                        cmd1.ExecuteNonQuery();
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                // Handle exceptions
                throw new Exception("Error deleting patient", ex);
            }
        }

        [WebMethod]
        public static string updatepatient(string name, string id, string phone, string location, string doctor, string sex, string dob, string did, string registrationChargeId, string deliveryChargeId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Update patient table
                    string patientUpdateQuery = "UPDATE [patient] SET " +
                                                "[full_name] = @name, " +
                                                "[sex] = @sex, " +
                                                "[dob] = @dob, " +
                                                "[location] = @location, " +
                                                "[phone] = @phone " +
                                                "WHERE [patientid] = @id";

                    using (SqlCommand cmd = new SqlCommand(patientUpdateQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@name", name);
                        cmd.Parameters.AddWithValue("@id", id);
                        cmd.Parameters.AddWithValue("@phone", phone);
                        cmd.Parameters.AddWithValue("@location", location);
                        cmd.Parameters.AddWithValue("@doctor", doctor);
                        cmd.Parameters.AddWithValue("@sex", sex);
                        cmd.Parameters.AddWithValue("@dob", dob);

                        cmd.ExecuteNonQuery();
                    }

                    // Update prescription table
                    string prescriptionUpdateQuery = "UPDATE [prescribtion] SET " +
                                                     "[doctorid] = @doctor " +
                                                     "WHERE [patientid] = @id";

                    using (SqlCommand cmd1 = new SqlCommand(prescriptionUpdateQuery, con))
                    {
                        cmd1.Parameters.AddWithValue("@doctor", doctor);
                        cmd1.Parameters.AddWithValue("@id", id);

                        cmd1.ExecuteNonQuery();
                    }

                    // Handle registration charge update/delete/insert
                    // First, delete existing registration charges for this patient
                    string deleteExistingReg = "DELETE FROM patient_charges WHERE patientid = @patientid AND charge_type = 'Registration'";
                    using (SqlCommand deleteCmd = new SqlCommand(deleteExistingReg, con))
                    {
                        deleteCmd.Parameters.AddWithValue("@patientid", id);
                        deleteCmd.ExecuteNonQuery();
                    }

                    // Then, insert new charge if selected (not "0" or "No charge")
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
                            string invoiceNumber = "REG-UPD-" + DateTimeHelper.Now.ToString("yyyyMMdd") + "-" + id.ToString().PadLeft(4, '0');

                            string chargeInsertQuery = @"INSERT INTO patient_charges 
                                (patientid, prescid, charge_type, charge_name, amount, is_paid, invoice_number, date_added) 
                                VALUES (@patientid, NULL, 'Registration', @charge_name, @amount, 1, @invoice_number, @date_added)";

                            using (SqlCommand chargeInsertCmd = new SqlCommand(chargeInsertQuery, con))
                            {
                                chargeInsertCmd.Parameters.AddWithValue("@patientid", id);
                                chargeInsertCmd.Parameters.AddWithValue("@charge_name", chargeName);
                                chargeInsertCmd.Parameters.AddWithValue("@amount", chargeAmount);
                                chargeInsertCmd.Parameters.AddWithValue("@invoice_number", invoiceNumber);
                                chargeInsertCmd.Parameters.AddWithValue("@date_added", DateTimeHelper.Now);
                                chargeInsertCmd.ExecuteNonQuery();
                            }
                        }
                    }
                    // If registrationChargeId is "0", charge is deleted and not re-inserted

                    // Handle delivery charge update/delete/insert
                    // First, delete existing delivery charges for this patient
                    string deleteExistingDel = "DELETE FROM patient_charges WHERE patientid = @patientid AND charge_type = 'Delivery'";
                    using (SqlCommand deleteCmd = new SqlCommand(deleteExistingDel, con))
                    {
                        deleteCmd.Parameters.AddWithValue("@patientid", id);
                        deleteCmd.ExecuteNonQuery();
                    }

                    // Then, insert new charge if selected (not "0" or "No charge")
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
                            string deliveryInvoiceNumber = "DEL-UPD-" + DateTimeHelper.Now.ToString("yyyyMMdd") + "-" + id.ToString().PadLeft(4, '0');

                            string deliveryChargeQuery = @"INSERT INTO patient_charges 
                                (patientid, prescid, charge_type, charge_name, amount, is_paid, invoice_number, date_added) 
                                VALUES (@patientid, NULL, 'Delivery', @charge_name, @amount, 1, @invoice_number, @date_added)";

                            using (SqlCommand deliveryCmd = new SqlCommand(deliveryChargeQuery, con))
                            {
                                deliveryCmd.Parameters.AddWithValue("@patientid", id);
                                deliveryCmd.Parameters.AddWithValue("@charge_name", chargeName);
                                deliveryCmd.Parameters.AddWithValue("@amount", chargeAmount);
                                deliveryCmd.Parameters.AddWithValue("@invoice_number", deliveryInvoiceNumber);
                                deliveryCmd.Parameters.AddWithValue("@date_added", DateTimeHelper.Now);
                                deliveryCmd.ExecuteNonQuery();
                            }
                        }
                    }
                    // If deliveryChargeId is "0", charge is deleted and not re-inserted
                }

                return "true";
            }
            catch (Exception ex)
            {
                // Handle exceptions
                throw new Exception("Error updating patient", ex);
            }
        }

        [WebMethod]
        public static object getdoctors(int doctorid, int patientid)
        {
            List<ListItem> doctorList = new List<ListItem>();

            string selectedDoctorId = null;
            string selectedDoctorTitle = null;

            string queryAllDoctors = "SELECT doctorid, doctortitle FROM doctor";
            string querySelectedDoctor = "SELECT doctorid, doctortitle FROM doctor WHERE doctorid = @doctorid";

            string constr = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(constr))
            {
                // Fetch all doctors
                using (SqlCommand cmd = new SqlCommand(queryAllDoctors, con))
                {
                    con.Open();
                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            doctorList.Add(new ListItem
                            {
                                Value = sdr["doctorid"].ToString(),
                                Text = sdr["doctortitle"].ToString()
                            });
                        }
                    }
                    con.Close();
                }

                // Fetch the selected doctor details
                using (SqlCommand cmd = new SqlCommand(querySelectedDoctor, con))
                {
                    cmd.Parameters.AddWithValue("@doctorid", doctorid);
                    con.Open();
                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        if (sdr.Read())
                        {
                            selectedDoctorId = sdr["doctorid"].ToString();
                            selectedDoctorTitle = sdr["doctortitle"].ToString();
                        }
                    }
                    con.Close();
                }
            }

            return new
            {
                doctorList = doctorList,
                selectedDoctorId = selectedDoctorId,
                selectedDoctorTitle = selectedDoctorTitle
            };
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