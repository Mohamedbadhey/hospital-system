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
    public partial class add_lab_charges : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static ptclass[] GetPendingLabCharges()
        {
            List<ptclass> patients = new List<ptclass>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();

                // Show ALL lab orders (each med_id is a separate lab order)
                // One prescription can have multiple lab orders (multiple med_id)
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
                lt.med_id as lab_order_id,
                lt.date_taken as lab_order_date,
                d.doctorid, 
                CONVERT(date, p.dob) AS dob,
                CASE 
                    WHEN NOT EXISTS (
                        SELECT 1 FROM patient_charges pc
                        WHERE pc.prescid = pr.prescid 
                        AND pc.charge_type = 'Lab' 
                        AND pc.reference_id = lt.med_id
                        AND ISNULL(pc.is_paid, 0) = 0
                    ) THEN 'Paid' 
                    ELSE 'Pending Payment' 
                END AS status
            FROM patient p
            INNER JOIN prescribtion pr ON p.patientid = pr.patientid
            INNER JOIN doctor d ON pr.doctorid = d.doctorid
            INNER JOIN lab_test lt ON pr.prescid = lt.prescid
            ORDER BY status ASC, lt.date_taken DESC, lt.med_id DESC
        ", con);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        ptclass patient = new ptclass
                        {
                            patientid = dr["patientid"].ToString(),
                            full_name = dr["full_name"].ToString(),
                            sex = dr["sex"].ToString(),
                            location = dr["location"].ToString(),
                            phone = dr["phone"].ToString(),
                            date_registered = Convert.ToDateTime(dr["date_registered"]).ToString("yyyy-MM-dd"),
                            doctortitle = dr["doctortitle"].ToString(),
                            prescid = dr["prescid"].ToString(),
                            doctorid = dr["doctorid"].ToString(),
                            dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd"),
                            status = dr["status"].ToString(),
                            lab_order_id = dr["lab_order_id"].ToString(),
                            lab_order_date = dr["lab_order_date"] != DBNull.Value ? 
                                Convert.ToDateTime(dr["lab_order_date"]).ToString("yyyy-MM-dd HH:mm") : ""
                        };

                        patients.Add(patient);
                    }
                }
            }

            return patients.ToArray();
        }
        [WebMethod]
        public static double GetLabChargeAmount()
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            double amount = 0;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                string query = "SELECT TOP 1 amount FROM charges_config WHERE charge_type = 'Lab' AND is_active = 1 ORDER BY charge_config_id DESC";
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
        public static LabChargeResponse GetLabChargeBreakdown(string prescid)
        {
            LabChargeResponse response = new LabChargeResponse();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Get all unpaid lab charges for this prescription
                    string getChargesQuery = @"
                        SELECT charge_id, charge_name, amount, reference_id
                        FROM patient_charges 
                        WHERE prescid = @prescid AND charge_type = 'Lab' AND is_paid = 0
                        ORDER BY charge_id";

                    response.tests = new List<TestChargeInfo>();
                    decimal total = 0;

                    using (SqlCommand cmd = new SqlCommand(getChargesQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@prescid", prescid);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                decimal amount = Convert.ToDecimal(dr["amount"]);
                                total += amount;

                                response.tests.Add(new TestChargeInfo
                                {
                                    chargeId = Convert.ToInt32(dr["charge_id"]),
                                    testName = "", // Not needed for display
                                    testDisplayName = dr["charge_name"].ToString(),
                                    price = amount
                                });
                            }
                        }
                    }

                    response.success = true;
                    response.totalAmount = total;
                    response.testCount = response.tests.Count;
                }
            }
            catch (Exception ex)
            {
                response.success = false;
                response.message = "Error: " + ex.Message;
            }

            return response;
        }

        [WebMethod]
        public static string ProcessLabChargeWithAmounts(string prescid, string patientid, List<ChargePayment> chargePayments, string paymentMethod)
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
                            // Generate invoice number
                            string invoiceNumber = "LAB-" + DateTimeHelper.Now.ToString("yyyyMMdd") + "-" + prescid.PadLeft(4, '0');

                            // Get registrar userid from session (default to 1)
                            int registrarId = 1;

                            // Update each charge with its actual amount received
                            foreach (var payment in chargePayments)
                            {
                                string updateCharge = @"
                                    UPDATE patient_charges 
                                    SET amount = @actualAmount,
                                        is_paid = 1, 
                                        paid_date = @paid_date, 
                                        paid_by = @paid_by, 
                                        invoice_number = @invoice_number, 
                                        payment_method = @payment_method
                                    WHERE charge_id = @charge_id";

                                using (SqlCommand cmd = new SqlCommand(updateCharge, con, trans))
                                {
                                    cmd.Parameters.AddWithValue("@charge_id", payment.chargeId);
                                    cmd.Parameters.AddWithValue("@actualAmount", payment.actualAmount);
                                    cmd.Parameters.AddWithValue("@paid_date", DateTimeHelper.Now);
                                    cmd.Parameters.AddWithValue("@paid_by", registrarId);
                                    cmd.Parameters.AddWithValue("@invoice_number", invoiceNumber);
                                    cmd.Parameters.AddWithValue("@payment_method", paymentMethod);
                                    cmd.ExecuteNonQuery();
                                }
                            }

                            // Update prescribtion to mark lab charge as paid
                            string updatePrescription = @"
                                UPDATE prescribtion 
                                SET lab_charge_paid = 1, 
                                    status = CASE WHEN status < 4 THEN 4 ELSE status END 
                                WHERE prescid = @prescid";

                            using (SqlCommand cmd = new SqlCommand(updatePrescription, con, trans))
                            {
                                cmd.Parameters.AddWithValue("@prescid", prescid);
                                cmd.ExecuteNonQuery();
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
        public static string ProcessLabCharge(string prescid, string patientid, string amount, string paymentMethod)
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
                            // Get lab order ID
                            int labOrderId = 0;
                            string getOrderQuery = "SELECT TOP 1 med_id FROM lab_test WHERE prescid = @prescid ORDER BY date_taken DESC";
                            using (SqlCommand cmd = new SqlCommand(getOrderQuery, con, trans))
                            {
                                cmd.Parameters.AddWithValue("@prescid", prescid);
                                object result = cmd.ExecuteScalar();
                                if (result != null)
                                {
                                    labOrderId = Convert.ToInt32(result);
                                }
                            }

                            if (labOrderId == 0)
                            {
                                trans.Rollback();
                                return "Error: No lab order found";
                            }

                            // Calculate breakdown
                            LabOrderChargeBreakdown breakdown = LabTestPriceCalculator.CalculateLabOrderTotal(labOrderId);

                            if (breakdown.TestCharges.Count == 0)
                            {
                                trans.Rollback();
                                return "Error: No tests found in order";
                            }

                            // Generate invoice number
                            string invoiceNumber = "LAB-" + DateTimeHelper.Now.ToString("yyyyMMdd") + "-" + prescid.PadLeft(4, '0');

                            // Get registrar userid from session
                            int registrarId = 1; // Default, should be passed from session

                            // Mark all UNPAID lab charges for this prescription as paid
                            string updateCharges = @"
                                UPDATE patient_charges 
                                SET is_paid = 1, 
                                    paid_date = @paid_date, 
                                    paid_by = @paid_by, 
                                    invoice_number = @invoice_number, 
                                    payment_method = @payment_method
                                WHERE prescid = @prescid 
                                AND charge_type = 'Lab' 
                                AND is_paid = 0";

                            using (SqlCommand cmd = new SqlCommand(updateCharges, con, trans))
                            {
                                cmd.Parameters.AddWithValue("@prescid", prescid);
                                cmd.Parameters.AddWithValue("@paid_date", DateTimeHelper.Now);
                                cmd.Parameters.AddWithValue("@paid_by", registrarId);
                                cmd.Parameters.AddWithValue("@invoice_number", invoiceNumber);
                                cmd.Parameters.AddWithValue("@payment_method", paymentMethod);
                                cmd.ExecuteNonQuery();
                            }

                            // Update prescribtion to mark lab charge as paid
                            string updatePrescription = @"
                                UPDATE prescribtion 
                                SET lab_charge_paid = 1, 
                                    status = CASE WHEN status < 4 THEN 4 ELSE status END 
                                WHERE prescid = @prescid";

                            using (SqlCommand cmd = new SqlCommand(updatePrescription, con, trans))
                            {
                                cmd.Parameters.AddWithValue("@prescid", prescid);
                                cmd.ExecuteNonQuery();
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

        public class LabChargeResponse
        {
            public bool success { get; set; }
            public string message { get; set; }
            public decimal totalAmount { get; set; }
            public int testCount { get; set; }
            public List<TestChargeInfo> tests { get; set; }
        }

        public class TestChargeInfo
        {
            public int chargeId { get; set; }
            public string testName { get; set; }
            public string testDisplayName { get; set; }
            public decimal price { get; set; }
        }

        public class ChargePayment
        {
            public int chargeId { get; set; }
            public decimal actualAmount { get; set; }
        }

        [WebMethod]
        public static PaidChargesResponse GetPaidLabCharges(string prescid)
        {
            PaidChargesResponse response = new PaidChargesResponse();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Get all PAID lab charges for this prescription
                    string getChargesQuery = @"
                        SELECT charge_id, charge_name, amount, invoice_number, payment_method
                        FROM patient_charges 
                        WHERE prescid = @prescid AND charge_type = 'Lab' AND is_paid = 1
                        ORDER BY charge_id";

                    response.tests = new List<PaidChargeInfo>();
                    decimal total = 0;

                    using (SqlCommand cmd = new SqlCommand(getChargesQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@prescid", prescid);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                decimal amount = Convert.ToDecimal(dr["amount"]);
                                total += amount;

                                response.tests.Add(new PaidChargeInfo
                                {
                                    chargeId = Convert.ToInt32(dr["charge_id"]),
                                    chargeName = dr["charge_name"].ToString(),
                                    amount = amount,
                                    invoiceNumber = dr["invoice_number"].ToString(),
                                    paymentMethod = dr["payment_method"] != DBNull.Value ? dr["payment_method"].ToString() : "Cash"
                                });
                            }
                        }
                    }

                    response.success = true;
                    response.totalAmount = total;
                }
            }
            catch (Exception ex)
            {
                response.success = false;
                response.message = "Error: " + ex.Message;
            }

            return response;
        }

        [WebMethod]
        public static PaidChargesResponse GetPaidLabChargesForOrder(string prescid, string labOrderId)
        {
            PaidChargesResponse response = new PaidChargesResponse();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Get PAID lab charges for this specific lab order (med_id)
                    // Lab charges are linked to lab orders via reference_id which stores the med_id
                    string getChargesQuery = @"
                        SELECT charge_id, charge_name, amount, invoice_number, payment_method, reference_id
                        FROM patient_charges 
                        WHERE prescid = @prescid 
                        AND charge_type = 'Lab' 
                        AND is_paid = 1
                        AND reference_id = @labOrderId
                        ORDER BY charge_id";

                    response.tests = new List<PaidChargeInfo>();
                    decimal total = 0;

                    using (SqlCommand cmd = new SqlCommand(getChargesQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@prescid", prescid);
                        cmd.Parameters.AddWithValue("@labOrderId", labOrderId);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                decimal amount = Convert.ToDecimal(dr["amount"]);
                                total += amount;

                                response.tests.Add(new PaidChargeInfo
                                {
                                    chargeId = Convert.ToInt32(dr["charge_id"]),
                                    chargeName = dr["charge_name"].ToString(),
                                    amount = amount,
                                    invoiceNumber = dr["invoice_number"].ToString(),
                                    paymentMethod = dr["payment_method"] != DBNull.Value ? dr["payment_method"].ToString() : "Cash"
                                });
                            }
                        }
                    }

                    response.success = true;
                    response.totalAmount = total;
                    
                    if (response.tests.Count == 0)
                    {
                        response.message = "No paid charges found for this lab order";
                    }
                }
            }
            catch (Exception ex)
            {
                response.success = false;
                response.message = "Error: " + ex.Message;
            }

            return response;
        }

        [WebMethod]
        public static UpdatePaymentResponse UpdateLabChargePayment(string prescid, List<ChargeUpdate> chargeUpdates, string paymentMethod)
        {
            UpdatePaymentResponse response = new UpdatePaymentResponse();
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
                            // Update each charge with its new amount
                            foreach (var update in chargeUpdates)
                            {
                                string updateCharge = @"
                                    UPDATE patient_charges 
                                    SET amount = @newAmount,
                                        payment_method = @payment_method,
                                        last_updated = @last_updated
                                    WHERE charge_id = @charge_id";

                                using (SqlCommand cmd = new SqlCommand(updateCharge, con, trans))
                                {
                                    cmd.Parameters.AddWithValue("@charge_id", update.chargeId);
                                    cmd.Parameters.AddWithValue("@newAmount", update.newAmount);
                                    cmd.Parameters.AddWithValue("@payment_method", paymentMethod);
                                    cmd.Parameters.AddWithValue("@last_updated", DateTimeHelper.Now);
                                    cmd.ExecuteNonQuery();
                                }
                            }

                            trans.Commit();
                            response.success = true;
                            response.message = "Payment updated successfully";
                        }
                        catch (Exception ex)
                        {
                            trans.Rollback();
                            response.success = false;
                            response.message = "Error updating payment: " + ex.Message;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                response.success = false;
                response.message = "Error: " + ex.Message;
            }

            return response;
        }

        public class PaidChargesResponse
        {
            public bool success { get; set; }
            public string message { get; set; }
            public decimal totalAmount { get; set; }
            public List<PaidChargeInfo> tests { get; set; }
        }

        public class PaidChargeInfo
        {
            public int chargeId { get; set; }
            public string chargeName { get; set; }
            public decimal amount { get; set; }
            public string invoiceNumber { get; set; }
            public string paymentMethod { get; set; }
        }

        public class ChargeUpdate
        {
            public int chargeId { get; set; }
            public decimal newAmount { get; set; }
        }

        public class UpdatePaymentResponse
        {
            public bool success { get; set; }
            public string message { get; set; }
        }

        [WebMethod]
        public static InvoiceResponse GetInvoiceByPrescid(string prescid)
        {
            InvoiceResponse response = new InvoiceResponse();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Get the invoice number for paid lab charges for this prescription
                    string query = @"
                        SELECT TOP 1 invoice_number
                        FROM patient_charges
                        WHERE prescid = @prescid 
                        AND charge_type = 'Lab' 
                        AND is_paid = 1
                        AND invoice_number IS NOT NULL
                        ORDER BY paid_date DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@prescid", prescid);
                        object result = cmd.ExecuteScalar();

                        if (result != null && result != DBNull.Value)
                        {
                            response.success = true;
                            response.invoiceNumber = result.ToString();
                        }
                        else
                        {
                            response.success = false;
                            response.message = "No invoice found for this prescription";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                response.success = false;
                response.message = "Error: " + ex.Message;
            }

            return response;
        }

        public class InvoiceResponse
        {
            public bool success { get; set; }
            public string message { get; set; }
            public string invoiceNumber { get; set; }
        }
    }
}

