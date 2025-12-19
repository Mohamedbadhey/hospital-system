using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace juba_hospital
{
    public partial class admin_inpatient : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["admin_id"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        [WebMethod]
        public static InpatientDetail[] GetAllInpatients(string filterType)
        {
            List<InpatientDetail> details = new List<InpatientDetail>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                
                string whereClause = filterType == "all" ? "" : "AND p.patient_status = 1";
                
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        p.patientid, p.full_name, p.sex, p.location, p.phone,
                        CONVERT(date, p.dob) AS dob,
                        CONVERT(date, p.date_registered) AS date_registered,
                        p.bed_admission_date,
                        DATEDIFF(DAY, p.bed_admission_date, GETDATE()) AS days_admitted,
                        pr.prescid, pr.status, pr.xray_status,
                        d.doctorid, d.doctortitle, d.fullname as doctor_name,
                        p.patient_status,
                        CASE WHEN EXISTS(SELECT 1 FROM lab_test lt WHERE lt.prescid = pr.prescid) 
                            THEN 'Ordered' ELSE 'Not Ordered' END AS lab_test_status,
                        CASE WHEN EXISTS(SELECT 1 FROM lab_results lr WHERE lr.prescid = pr.prescid) 
                            THEN 'Available' ELSE 'Pending' END AS lab_result_status,
                        CASE WHEN EXISTS(SELECT 1 FROM xray x WHERE x.prescid = pr.prescid) 
                            THEN 'Ordered' ELSE 'Not Ordered' END AS xray_order_status,
                        CASE WHEN EXISTS(SELECT 1 FROM xray_results xr WHERE xr.prescid = pr.prescid) 
                            THEN 'Available' ELSE 'Pending' END AS xray_result_status,
                        (SELECT COUNT(*) FROM medication m WHERE m.prescid = pr.prescid) AS medication_count,
                        (SELECT ISNULL(SUM(amount), 0) FROM patient_charges pc 
                         WHERE pc.patientid = p.patientid AND pc.is_paid = 0) AS unpaid_charges,
                        (SELECT ISNULL(SUM(amount), 0) FROM patient_charges pc 
                         WHERE pc.patientid = p.patientid AND pc.is_paid = 1) AS paid_charges,
                        (SELECT ISNULL(SUM(amount), 0) FROM patient_charges pc 
                         WHERE pc.patientid = p.patientid AND pc.charge_type = 'Bed') AS total_bed_charges
                    FROM patient p
                    INNER JOIN prescribtion pr ON p.patientid = pr.patientid
                    INNER JOIN doctor d ON pr.doctorid = d.doctorid
                    WHERE 1=1 " + whereClause + @"
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
                            location = dr["location"].ToString(),
                            phone = dr["phone"].ToString(),
                            dob = dr["dob"] != DBNull.Value ? Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd") : "",
                            date_registered = dr["date_registered"] != DBNull.Value ? Convert.ToDateTime(dr["date_registered"]).ToString("yyyy-MM-dd") : "",
                            bed_admission_date = dr["bed_admission_date"] != DBNull.Value ? Convert.ToDateTime(dr["bed_admission_date"]).ToString("yyyy-MM-dd HH:mm") : "",
                            days_admitted = dr["days_admitted"].ToString(),
                            prescid = dr["prescid"].ToString(),
                            status = dr["status"].ToString(),
                            xray_status = dr["xray_status"].ToString(),
                            doctorid = dr["doctorid"].ToString(),
                            doctortitle = dr["doctortitle"].ToString(),
                            doctor_name = dr["doctor_name"].ToString(),
                            patient_status = dr["patient_status"].ToString(),
                            lab_test_status = dr["lab_test_status"].ToString(),
                            lab_result_status = dr["lab_result_status"].ToString(),
                            xray_order_status = dr["xray_order_status"].ToString(),
                            xray_result_status = dr["xray_result_status"].ToString(),
                            medication_count = dr["medication_count"].ToString(),
                            unpaid_charges = dr["unpaid_charges"].ToString(),
                            paid_charges = dr["paid_charges"].ToString(),
                            total_bed_charges = dr["total_bed_charges"].ToString()
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
        public static LabResult[] GetLabResults(string prescid)
        {
            List<LabResult> results = new List<LabResult>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT lab_result_id, TestName, TestValue
                    FROM (
                        SELECT 
                            lab_result_id,
                            Hemoglobin, Malaria, ESR, Blood_grouping, Blood_sugar, CBC, 
                            Cross_matching, TPHA, Human_immune_deficiency_HIV, 
                            Hepatitis_B_virus_HBV, Hepatitis_C_virus_HCV,
                            Low_density_lipoprotein_LDL, High_density_lipoprotein_HDL,
                            Total_cholesterol, Triglycerides, SGPT_ALT, SGOT_AST,
                            Alkaline_phosphates_ALP, Total_bilirubin, Direct_bilirubin,
                            Albumin, Urea, Creatinine, Uric_acid, Sodium, Potassium,
                            Chloride, Calcium, Phosphorous, Magnesium
                        FROM lab_results
                        WHERE prescid = @prescid
                    ) src
                    UNPIVOT (
                        TestValue FOR TestName IN (
                            Hemoglobin, Malaria, ESR, Blood_grouping, Blood_sugar, CBC,
                            Cross_matching, TPHA, Human_immune_deficiency_HIV,
                            Hepatitis_B_virus_HBV, Hepatitis_C_virus_HCV,
                            Low_density_lipoprotein_LDL, High_density_lipoprotein_HDL,
                            Total_cholesterol, Triglycerides, SGPT_ALT, SGOT_AST,
                            Alkaline_phosphates_ALP, Total_bilirubin, Direct_bilirubin,
                            Albumin, Urea, Creatinine, Uric_acid, Sodium, Potassium,
                            Chloride, Calcium, Phosphorous, Magnesium
                        )
                    ) unpvt
                    WHERE TestValue IS NOT NULL AND TestValue != ''
                ", con);
                
                cmd.Parameters.AddWithValue("@prescid", prescid);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        results.Add(new LabResult
                        {
                            TestName = dr["TestName"].ToString().Replace("_", " "),
                            TestValue = dr["TestValue"].ToString()
                        });
                    }
                }
            }

            return results.ToArray();
        }

        [WebMethod]
        public static Medication[] GetMedications(string prescid)
        {
            List<Medication> meds = new List<Medication>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT medid, med_name, dosage, frequency, duration, special_inst, date_taken
                    FROM medication
                    WHERE prescid = @prescid
                    ORDER BY date_taken DESC
                ", con);
                
                cmd.Parameters.AddWithValue("@prescid", prescid);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        meds.Add(new Medication
                        {
                            medid = dr["medid"].ToString(),
                            med_name = dr["med_name"].ToString(),
                            dosage = dr["dosage"].ToString(),
                            frequency = dr["frequency"].ToString(),
                            duration = dr["duration"].ToString(),
                            special_inst = dr["special_inst"].ToString(),
                            date_taken = dr["date_taken"] != DBNull.Value ? Convert.ToDateTime(dr["date_taken"]).ToString("yyyy-MM-dd") : ""
                        });
                    }
                }
            }

            return meds.ToArray();
        }

        public class InpatientDetail
        {
            public string patientid { get; set; }
            public string full_name { get; set; }
            public string sex { get; set; }
            public string location { get; set; }
            public string phone { get; set; }
            public string dob { get; set; }
            public string date_registered { get; set; }
            public string bed_admission_date { get; set; }
            public string days_admitted { get; set; }
            public string prescid { get; set; }
            public string status { get; set; }
            public string xray_status { get; set; }
            public string doctorid { get; set; }
            public string doctortitle { get; set; }
            public string doctor_name { get; set; }
            public string patient_status { get; set; }
            public string lab_test_status { get; set; }
            public string lab_result_status { get; set; }
            public string xray_order_status { get; set; }
            public string xray_result_status { get; set; }
            public string medication_count { get; set; }
            public string unpaid_charges { get; set; }
            public string paid_charges { get; set; }
            public string total_bed_charges { get; set; }
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

        public class LabResult
        {
            public string TestName { get; set; }
            public string TestValue { get; set; }
        }

        public class Medication
        {
            public string medid { get; set; }
            public string med_name { get; set; }
            public string dosage { get; set; }
            public string frequency { get; set; }
            public string duration { get; set; }
            public string special_inst { get; set; }
            public string date_taken { get; set; }
        }
    }
}
