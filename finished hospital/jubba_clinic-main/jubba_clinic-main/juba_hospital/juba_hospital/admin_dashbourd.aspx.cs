using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using static juba_hospital.admin_dashbourd;

namespace juba_hospital
{
    public partial class admin_dashbourd : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        public class cust
        {
            public string inpatient { get; set; }

        }

        public class ip
        {
            public string in_patients { get; set; }

        }
        public class op
        {
            public string op_patients { get; set; }

        }
        public class RevenueData
        {
            public string total_revenue { get; set; }
            public string registration_revenue { get; set; }
            public string lab_revenue { get; set; }
            public string xray_revenue { get; set; }
            public string pharmacy_revenue { get; set; }
            public string bed_revenue { get; set; }
            public string delivery_revenue { get; set; }
        }

        [WebMethod]
        public static RevenueData[] GetTodayRevenue()
        {
            List<RevenueData> details = new List<RevenueData>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    -- Get today's revenue from all sources
                    DECLARE @RegistrationRevenue FLOAT = 0;
                    DECLARE @LabRevenue FLOAT = 0;
                    DECLARE @XrayRevenue FLOAT = 0;
                    DECLARE @PharmacyRevenue FLOAT = 0;
                    DECLARE @BedRevenue FLOAT = 0;
                    DECLARE @DeliveryRevenue FLOAT = 0;

                    -- Registration, Lab, X-ray, and Delivery charges from patient_charges table
                    SELECT 
                        @RegistrationRevenue = ISNULL(SUM(CASE WHEN charge_type = 'Registration' AND is_paid = 1 THEN amount ELSE 0 END), 0),
                        @LabRevenue = ISNULL(SUM(CASE WHEN charge_type = 'Lab' AND is_paid = 1 THEN amount ELSE 0 END), 0),
                        @XrayRevenue = ISNULL(SUM(CASE WHEN charge_type = 'Xray' AND is_paid = 1 THEN amount ELSE 0 END), 0),
                        @DeliveryRevenue = ISNULL(SUM(CASE WHEN charge_type = 'Delivery' AND is_paid = 1 THEN amount ELSE 0 END), 0)
                    FROM patient_charges
                    WHERE CAST(date_added AS DATE) = CAST(GETDATE() AS DATE);

                    -- Bed revenue from patient_bed_charges table
                    SELECT @BedRevenue = ISNULL(SUM(bed_charge_amount), 0)
                    FROM patient_bed_charges
                    WHERE is_paid = 1 
                    AND CAST(created_at AS DATE) = CAST(GETDATE() AS DATE);

                    -- Pharmacy revenue from pharmacy_sales table
                    SELECT @PharmacyRevenue = ISNULL(SUM(total_amount), 0)
                    FROM pharmacy_sales
                    WHERE CAST(sale_date AS DATE) = CAST(GETDATE() AS DATE);

                    -- Return combined results
                    SELECT 
                        (@RegistrationRevenue + @LabRevenue + @XrayRevenue + @PharmacyRevenue + @BedRevenue + @DeliveryRevenue) AS total_revenue,
                        @RegistrationRevenue AS registration_revenue,
                        @LabRevenue AS lab_revenue,
                        @XrayRevenue AS xray_revenue,
                        @PharmacyRevenue AS pharmacy_revenue,
                        @BedRevenue AS bed_revenue,
                        @DeliveryRevenue AS delivery_revenue
                ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    RevenueData field = new RevenueData();
                    field.total_revenue = dr["total_revenue"].ToString();
                    field.registration_revenue = dr["registration_revenue"].ToString();
                    field.lab_revenue = dr["lab_revenue"].ToString();
                    field.xray_revenue = dr["xray_revenue"].ToString();
                    field.pharmacy_revenue = dr["pharmacy_revenue"].ToString();
                    field.bed_revenue = dr["bed_revenue"].ToString();
                    field.delivery_revenue = dr["delivery_revenue"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }
        [WebMethod]
        public static op[] op_patients()
        {
            List<op> details = new List<op>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
   


	               SELECT 
  count(*) as   op_patients
   FROM 
       patient
   INNER JOIN 
       prescribtion ON patient.patientid = prescribtion.patientid
   INNER JOIN 
       doctor ON prescribtion.doctorid = doctor.doctorid
where patient.patient_status = 0 OR patient.patient_status = 1;
        ", con);


                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    op field = new op();
                    field.op_patients = dr["op_patients"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }
        [WebMethod]
        public static ip[] inpatient()
        {
            List<ip> details = new List<ip>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
   


	               SELECT 
  count(*) as   in_patients
   FROM 
       patient
   INNER JOIN 
       prescribtion ON patient.patientid = prescribtion.patientid
   INNER JOIN 
       doctor ON prescribtion.doctorid = doctor.doctorid
where patient.patient_status = 1;
        ", con);


                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    ip field = new ip();
                    field.in_patients = dr["in_patients"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }

        [WebMethod]
        public static cust[] doctors()
        {
            List<cust> details = new List<cust>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
   

select count(*) as doctortotal from doctor

        ", con);


                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    cust field = new cust();
                    field.inpatient = dr["doctortotal"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }


    }
}