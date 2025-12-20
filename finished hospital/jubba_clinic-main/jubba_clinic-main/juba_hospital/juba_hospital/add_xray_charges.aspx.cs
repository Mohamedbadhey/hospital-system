using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using static juba_hospital.waitingpatients;

namespace juba_hospital
{
    public partial class add_xray_charges : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static ptclass[] GetPendingXrayCharges()
        {
            List<ptclass> patients = new List<ptclass>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                // Get patients with X-ray orders but charges not paid
                SqlCommand cmd = new SqlCommand(@"
                   SELECT
     p.patientid,
     p.full_name,
     p.sex,
     p.location,
     p.phone,
     CONVERT(date, p.date_registered) AS date_registered,
     d.doctortitle,
     pr.prescid,
     d.doctorid,
     CONVERT(date, p.dob) AS dob,
     CASE 
         WHEN pr.xray_charge_paid = 1 THEN 'Paid'
         ELSE 'Pending Payment'
     END AS status,
     x.xrayid
FROM patient p
INNER JOIN prescribtion pr ON p.patientid = pr.patientid
INNER JOIN doctor d ON pr.doctorid = d.doctorid
INNER JOIN xray x ON pr.prescid = x.prescid
WHERE (pr.xray_charge_paid IS NULL OR pr.xray_charge_paid = 0)
  AND EXISTS (SELECT 1 FROM xray WHERE prescid = pr.prescid)
ORDER BY p.date_registered DESC;

                ", con);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        ptclass patient = new ptclass();
                        patient.patientid = dr["patientid"].ToString();
                        patient.full_name = dr["full_name"].ToString();
                        patient.sex = dr["sex"].ToString();
                        patient.location = dr["location"].ToString();
                        patient.phone = dr["phone"].ToString();
                        patient.date_registered = Convert.ToDateTime(dr["date_registered"]).ToString("yyyy-MM-dd");
                        patient.doctortitle = dr["doctortitle"].ToString();
                        patient.prescid = dr["prescid"].ToString();
                        patient.doctorid = dr["doctorid"].ToString();
                        patient.dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd");
                        patient.status = dr["status"].ToString();
                        patients.Add(patient);
                    }
                }
            }

            return patients.ToArray();
        }

        [WebMethod]
        public static double GetXrayChargeAmount()
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            double amount = 0;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                string query = "SELECT TOP 1 amount FROM charges_config WHERE charge_type = 'Xray' AND is_active = 1 ORDER BY charge_config_id DESC";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        amount = Convert.ToDouble(result);
                    }
                }
            }

            return amount;
        }

        [WebMethod]
       
        public static string ProcessXrayCharge(string prescid, string patientid, string amount, string paymentMethod)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    using (SqlTransaction trans = con.BeginTransaction())
                    {
                        try
                        {
                            // Get charge name
                            string chargeName = "X-Ray Imaging Charges";
                            string chargeQuery = "SELECT TOP 1 charge_name FROM charges_config WHERE charge_type = 'Xray' AND is_active = 1";
                            using (SqlCommand chargeCmd = new SqlCommand(chargeQuery, con, trans))
                            {
                                object result = chargeCmd.ExecuteScalar();
                                if (result != null)
                                {
                                    chargeName = result.ToString();
                                }
                            }

                            // Generate invoice number
                            string invoiceNumber = "XRAY-" + DateTimeHelper.Now.ToString("yyyyMMdd") + "-" + prescid.PadLeft(4, '0');

                            // Get registrar userid from session (would need to pass from client)
                            int registrarId = 1; // Default, should be passed from session

                            // Create patient charge record
                            string insertCharge = @"INSERT INTO patient_charges 
                                (patientid, prescid, charge_type, charge_name, amount, is_paid, paid_date, paid_by, invoice_number, payment_method)
                                VALUES (@patientid, @prescid, 'Xray', @charge_name, @amount, 1, @paid_date, @paid_by, @invoice_number, @payment_method);
                                SELECT SCOPE_IDENTITY();";

                            int chargeId = 0;
                            using (SqlCommand cmd = new SqlCommand(insertCharge, con, trans))
                            {
                                cmd.Parameters.AddWithValue("@patientid", patientid);
                                cmd.Parameters.AddWithValue("@prescid", prescid);
                                cmd.Parameters.AddWithValue("@charge_name", chargeName);
                                cmd.Parameters.AddWithValue("@amount", Convert.ToDouble(amount));
                                cmd.Parameters.AddWithValue("@paid_date", DateTimeHelper.Now);
                                cmd.Parameters.AddWithValue("@paid_by", registrarId);
                                cmd.Parameters.AddWithValue("@invoice_number", invoiceNumber);
                                cmd.Parameters.AddWithValue("@payment_method", paymentMethod);
                                chargeId = Convert.ToInt32(cmd.ExecuteScalar());
                            }

                            // Update prescribtion to mark X-ray charge as paid and ensure status is Pending X-ray (2) if not already processed
                            string updatePrescription = @"UPDATE prescribtion 
                                                        SET xray_charge_paid = 1, 
                                                            status = CASE WHEN status < 2 THEN 2 ELSE status END 
                                                        WHERE prescid = @prescid";
                            using (SqlCommand updateCmd = new SqlCommand(updatePrescription, con, trans))
                            {
                                updateCmd.Parameters.AddWithValue("@prescid", prescid);
                                updateCmd.ExecuteNonQuery();
                            }

                            trans.Commit();
                            return invoiceNumber;
                        }
                        catch
                        {
                            trans.Rollback();
                            throw;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        [WebMethod]
        public static ChargeReceipt GetChargeReceipt(string invoiceNumber)
        {
            ChargeReceipt receipt = null;
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                string query = @"SELECT 
                    pc.invoice_number,
                    pc.amount,
                    pc.charge_name,
                    pc.paid_date,
                    p.full_name,
                    p.phone,
                    p.location,
                    CONVERT(date, p.dob) AS dob,
                    d.doctortitle,
                    r.fullname AS registrar_name
                FROM patient_charges pc
                INNER JOIN patient p ON pc.patientid = p.patientid
                LEFT JOIN prescribtion pr ON pc.prescid = pr.prescid
                LEFT JOIN doctor d ON pr.doctorid = d.doctorid
                LEFT JOIN registre r ON pc.paid_by = r.userid
                WHERE pc.invoice_number = @invoice_number";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@invoice_number", invoiceNumber);
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            receipt = new ChargeReceipt();
                            receipt.invoice_number = dr["invoice_number"].ToString();
                            receipt.amount = dr["amount"].ToString();
                            receipt.charge_name = dr["charge_name"].ToString();
                            receipt.paid_date = Convert.ToDateTime(dr["paid_date"]).ToString("yyyy-MM-dd HH:mm");
                            receipt.patient_name = dr["full_name"].ToString();
                            receipt.patient_phone = dr["phone"].ToString();
                            receipt.patient_location = dr["location"].ToString();
                            receipt.patient_dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd");
                            receipt.doctor_name = dr["doctortitle"] != DBNull.Value ? dr["doctortitle"].ToString() : "";
                            receipt.registrar_name = dr["registrar_name"] != DBNull.Value ? dr["registrar_name"].ToString() : "";
                        }
                    }
                }
            }

            return receipt;
        }

        public class ChargeReceipt
        {
            public string invoice_number;
            public string amount;
            public string charge_name;
            public string paid_date;
            public string patient_name;
            public string patient_phone;
            public string patient_location;
            public string patient_dob;
            public string doctor_name;
            public string registrar_name;
        }
    }
}

