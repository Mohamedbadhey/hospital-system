using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace juba_hospital
{
    public partial class register_inpatient : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["role_id"] == null || Session["role_id"].ToString() != "3")
            {
                Response.Redirect("login.aspx");
            }
        }

        [WebMethod]
        public static InpatientDetail[] GetInpatientsForPayment()
        {
            List<InpatientDetail> details = new List<InpatientDetail>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        p.patientid, p.full_name, p.sex, p.phone,
                        CONVERT(date, p.date_registered) AS date_registered,
                        p.bed_admission_date,
                        DATEDIFF(DAY, p.bed_admission_date, GETDATE()) AS days_admitted,
                        pr.prescid,
                        d.doctortitle, d.fullname as doctor_name,
                        (SELECT ISNULL(SUM(amount), 0) FROM patient_charges pc 
                         WHERE pc.patientid = p.patientid AND pc.is_paid = 0) AS unpaid_charges,
                        (SELECT ISNULL(SUM(amount), 0) FROM patient_charges pc 
                         WHERE pc.patientid = p.patientid AND pc.is_paid = 1) AS paid_charges,
                        (SELECT ISNULL(SUM(amount), 0) FROM patient_charges pc 
                         WHERE pc.patientid = p.patientid) AS total_charges
                    FROM patient p
                    INNER JOIN prescribtion pr ON p.patientid = pr.patientid
                    INNER JOIN doctor d ON pr.doctorid = d.doctorid
                    WHERE p.patient_status = 1
                    ORDER BY p.bed_admission_date DESC
                ", con);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        InpatientDetail field = new InpatientDetail
                        {
                            patientid = dr["patientid"].ToString(),
                            full_name = dr["full_name"].ToString(),
                            sex = dr["sex"].ToString(),
                            phone = dr["phone"].ToString(),
                            date_registered = dr["date_registered"] != DBNull.Value ? Convert.ToDateTime(dr["date_registered"]).ToString("yyyy-MM-dd") : "",
                            bed_admission_date = dr["bed_admission_date"] != DBNull.Value ? Convert.ToDateTime(dr["bed_admission_date"]).ToString("yyyy-MM-dd HH:mm") : "",
                            days_admitted = dr["days_admitted"].ToString(),
                            prescid = dr["prescid"].ToString(),
                            doctortitle = dr["doctortitle"].ToString(),
                            doctor_name = dr["doctor_name"].ToString(),
                            unpaid_charges = dr["unpaid_charges"].ToString(),
                            paid_charges = dr["paid_charges"].ToString(),
                            total_charges = dr["total_charges"].ToString()
                        };
                        details.Add(field);
                    }
                }
            }
            return details.ToArray();
        }

        [WebMethod]
        public static PatientCharge[] GetPatientCharges(string patientId)
        {
            List<PatientCharge> charges = new List<PatientCharge>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT charge_id, charge_type, charge_name, amount, is_paid, paid_date, payment_method, invoice_number, date_added
                    FROM patient_charges
                    WHERE patientid = @patientId
                    
                    UNION ALL
                    
                    SELECT 
                        bed_charge_id as charge_id,
                        'Bed' as charge_type,
                        'Daily Bed Charge - ' + CONVERT(VARCHAR, charge_date, 107) as charge_name,
                        bed_charge_amount as amount,
                        is_paid,
                        charge_date as paid_date,
                        payment_method,
                        'BED-' + CAST(patientid AS VARCHAR) + '-' + CAST(bed_charge_id AS VARCHAR) as invoice_number,
                        charge_date as date_added
                    FROM patient_bed_charges
                    WHERE patientid = @patientId
                    
                    ORDER BY date_added DESC
                ", con);
                
                cmd.Parameters.AddWithValue("@patientId", patientId);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        charges.Add(new PatientCharge
                        {
                            charge_id = dr["charge_id"].ToString(),
                            charge_type = dr["charge_type"].ToString(),
                            charge_name = dr["charge_name"].ToString(),
                            amount = dr["amount"].ToString(),
                            is_paid = dr["is_paid"].ToString(),
                            paid_date = dr["paid_date"] != DBNull.Value ? Convert.ToDateTime(dr["paid_date"]).ToString("yyyy-MM-dd HH:mm") : "",
                            payment_method = dr["payment_method"]?.ToString() ?? "",
                            invoice_number = dr["invoice_number"]?.ToString() ?? "",
                            date_added = Convert.ToDateTime(dr["date_added"]).ToString("yyyy-MM-dd HH:mm")
                        });
                    }
                }
            }

            return charges.ToArray();
        }

        [WebMethod]
        public static string ProcessPayment(string chargeId, string paymentMethod)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string updateQuery = @"
                        UPDATE patient_charges 
                        SET is_paid = 1,
                            paid_date = @paid_date,
                            payment_method = @paymentMethod
                        WHERE charge_id = @chargeId";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@chargeId", chargeId);
                        cmd.Parameters.AddWithValue("@paid_date", DateTimeHelper.Now);
                        cmd.Parameters.AddWithValue("@paymentMethod", paymentMethod);
                        cmd.ExecuteNonQuery();
                    }
                }
                return "success";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        public class InpatientDetail
        {
            public string patientid { get; set; }
            public string full_name { get; set; }
            public string sex { get; set; }
            public string phone { get; set; }
            public string date_registered { get; set; }
            public string bed_admission_date { get; set; }
            public string days_admitted { get; set; }
            public string prescid { get; set; }
            public string doctortitle { get; set; }
            public string doctor_name { get; set; }
            public string unpaid_charges { get; set; }
            public string paid_charges { get; set; }
            public string total_charges { get; set; }
        }

        public class PatientCharge
        {
            public string charge_id { get; set; }
            public string charge_type { get; set; }
            public string charge_name { get; set; }
            public string amount { get; set; }
            public string is_paid { get; set; }
            public string paid_date { get; set; }
            public string payment_method { get; set; }
            public string invoice_number { get; set; }
            public string date_added { get; set; }
        }
    }
}
