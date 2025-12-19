using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class doctor_inpatient : System.Web.UI.Page
    {
      

        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if doctor is logged in - Master page already handles basic auth
            // Just verify the session exists
            if (Session["id"] == null || Session["UserId"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        /// <summary>
        /// Get comprehensive inpatient list for logged-in doctor
        /// </summary>
        [WebMethod]
        public static InpatientDetail[] GetInpatients(string doctorId)
        {
            DateTime eatNow = DateTimeHelper.Now;
            List<InpatientDetail> details = new List<InpatientDetail>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(@"
                        SELECT 
                            p.patientid,
                            p.full_name, 
                            ISNULL(p.sex, '') AS sex,
                            ISNULL(p.location, '') AS location,
                            ISNULL(p.phone, '') AS phone,
                            p.dob,
                            p.date_registered,
                            p.bed_admission_date,
                           CASE 
    WHEN p.bed_admission_date IS NULL THEN 0
    WHEN CAST(@EatNow AS DATE) < CAST(p.bed_admission_date AS DATE) THEN 1
    ELSE DATEDIFF(
            DAY,
            CAST(p.bed_admission_date AS DATE),
            CAST(@EatNow AS DATE)
         ) + 1
END AS days_admitted
,
                            pr.prescid,
                            ISNULL(pr.status, 0) AS status,
                            ISNULL(pr.xray_status, 0) AS xray_status,
                            ISNULL(pr.lab_charge_paid, 0) AS lab_charge_paid,
                            ISNULL(pr.xray_charge_paid, 0) AS xray_charge_paid,
                            d.doctorid,
                            ISNULL(d.doctortitle, '') AS doctortitle,
                            ISNULL(d.doctorname, '') AS doctor_name,
                            -- Lab test status: Check if ordered AND if results are pending
                            CASE WHEN EXISTS(SELECT 1 FROM lab_test lt WHERE lt.prescid = pr.prescid) 
                                THEN 'Ordered' ELSE 'Not Ordered' END AS lab_test_status,
                            CASE WHEN EXISTS(SELECT 1 FROM lab_test lt WHERE lt.prescid = pr.prescid)
                                     AND EXISTS(SELECT 1 FROM lab_results lr WHERE lr.prescid = pr.prescid AND lr.lab_test_id IN (SELECT med_id FROM lab_test WHERE prescid = pr.prescid))
                                THEN 'Available' 
                                WHEN EXISTS(SELECT 1 FROM lab_test lt WHERE lt.prescid = pr.prescid)
                                THEN 'Pending'
                                ELSE 'Not Ordered' END AS lab_result_status,
                            -- X-ray status: Check if ordered AND if results are pending
                            CASE WHEN EXISTS(SELECT 1 FROM presxray px WHERE px.prescid = pr.prescid) 
                                THEN 'Ordered' ELSE 'Not Ordered' END AS xray_order_status,
                            CASE WHEN EXISTS(SELECT 1 FROM presxray px WHERE px.prescid = pr.prescid)
                                     AND EXISTS(SELECT 1 FROM xray_results xr WHERE xr.prescid = pr.prescid)
                                THEN 'Available'
                                WHEN EXISTS(SELECT 1 FROM presxray px WHERE px.prescid = pr.prescid)
                                THEN 'Pending'
                                ELSE 'Not Ordered' END AS xray_result_status,
                            -- Medication count
                            (SELECT COUNT(*) FROM medication m WHERE m.prescid = pr.prescid) AS medication_count,
                            -- Charges summary from patient_charges table + bed charges
                            (SELECT ISNULL(SUM(amount), 0) FROM patient_charges pc 
                             WHERE pc.patientid = p.patientid AND ISNULL(pc.is_paid, 0) = 0) 
                             + (SELECT ISNULL(SUM(bed_charge_amount), 0) FROM patient_bed_charges pbc
                                WHERE pbc.patientid = p.patientid AND ISNULL(pbc.is_paid, 0) = 0) AS unpaid_charges,
                            (SELECT ISNULL(SUM(amount), 0) FROM patient_charges pc 
                             WHERE pc.patientid = p.patientid AND pc.is_paid = 1)
                             + (SELECT ISNULL(SUM(bed_charge_amount), 0) FROM patient_bed_charges pbc
                                WHERE pbc.patientid = p.patientid AND pbc.is_paid = 1) AS paid_charges,
                            (SELECT ISNULL(SUM(bed_charge_amount), 0) FROM patient_bed_charges pbc 
                             WHERE pbc.patientid = p.patientid) AS total_bed_charges
                        FROM 
                            patient p
                        INNER JOIN 
                            prescribtion pr ON p.patientid = pr.patientid
                        INNER JOIN 
                            doctor d ON pr.doctorid = d.doctorid
                        WHERE 
                            d.doctorid = @doctorId 
                            AND p.patient_status = 1
                        ORDER BY 
                            p.bed_admission_date DESC;
                    ", con);
                    
                    cmd.Parameters.AddWithValue("@doctorId", doctorId);
                    cmd.Parameters.Add("@EatNow", SqlDbType.DateTime).Value = eatNow;


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
                                bed_admission_date = dr["bed_admission_date"] != DBNull.Value ? Convert.ToDateTime(dr["bed_admission_date"]).ToString("yyyy-MM-dd HH:mm") : DateTimeHelper.Now.ToString("yyyy-MM-dd HH:mm"),
                                days_admitted = dr["days_admitted"].ToString(),
                                prescid = dr["prescid"].ToString(),
                                status = dr["status"].ToString(),
                                xray_status = dr["xray_status"].ToString(),
                                lab_charge_paid = dr["lab_charge_paid"].ToString(),
                                xray_charge_paid = dr["xray_charge_paid"].ToString(),
                                doctorid = dr["doctorid"].ToString(),
                                doctortitle = dr["doctortitle"].ToString(),
                                doctor_name = dr["doctor_name"].ToString(),
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
            catch (Exception ex)
            {
                // Log the detailed error
                System.Diagnostics.Debug.WriteLine("GetInpatients Error: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Stack Trace: " + ex.StackTrace);
                
                // Return detailed error to client
                throw new Exception("GetInpatients Error: " + ex.Message + 
                    (ex.InnerException != null ? " | Inner: " + ex.InnerException.Message : ""));
            }
        }

        /// <summary>
        /// Get patient charges breakdown - includes both regular charges and bed charges
        /// </summary>
        [WebMethod]
        public static PatientCharge[] GetPatientCharges(string patientId)
        {
            List<PatientCharge> charges = new List<PatientCharge>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                
                // Combine charges from both patient_charges and patient_bed_charges tables
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        charge_id,
                        charge_type,
                        charge_name,
                        amount,
                        is_paid,
                        paid_date,
                        payment_method,
                        invoice_number,
                        date_added
                    FROM patient_charges
                    WHERE patientid = @patientId
                    
                    UNION ALL
                    
                    SELECT 
                        pbc.bed_charge_id as charge_id,
                        'Bed' as charge_type,
                        'Daily Bed Charge' as charge_name,
                        pbc.bed_charge_amount as amount,
                        pbc.is_paid,
                        CAST(pbc.charge_date AS datetime) as paid_date,
                        NULL as payment_method,
                        'BED-' + CAST(pbc.patientid AS VARCHAR) + '-' + CAST(pbc.bed_charge_id AS VARCHAR) as invoice_number,
                        pbc.created_at as date_added
                    FROM patient_bed_charges pbc
                    WHERE pbc.patientid = @patientId
                    
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

        /// <summary>
        /// Get all lab orders for patient - simplified version showing all orders
        /// </summary>
        [WebMethod]
        public static LabOrder[] GetLabOrders(string prescid)
        {
            List<LabOrder> orders = new List<LabOrder>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Get all lab test orders with their charge status (aggregated to avoid duplicates)
                    SqlCommand cmdOrders = new SqlCommand(@"
                        SELECT 
                            lt.med_id,
                            ISNULL(lt.is_reorder, 0) as is_reorder,
                            lt.reorder_reason,
                            lt.date_taken,
                            CASE 
                                WHEN MIN(CAST(ISNULL(pc.is_paid, 0) AS INT)) = 1 THEN 1 
                                ELSE 0 
                            END as charge_paid,
                            ISNULL(SUM(pc.amount), 0) as charge_amount
                        FROM lab_test lt
                        LEFT JOIN patient_charges pc ON pc.reference_id = lt.med_id AND pc.charge_type = 'Lab'
                        WHERE lt.prescid = @prescid
                        GROUP BY lt.med_id, lt.is_reorder, lt.reorder_reason, lt.date_taken
                        ORDER BY lt.date_taken ASC
                    ", con);
                    
                    cmdOrders.Parameters.AddWithValue("@prescid", prescid);

                    using (SqlDataReader dr = cmdOrders.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            bool isPaid = dr["charge_paid"] != DBNull.Value && Convert.ToBoolean(dr["charge_paid"]);
                            decimal chargeAmount = dr["charge_amount"] != DBNull.Value ? Convert.ToDecimal(dr["charge_amount"]) : 0;
                            
                            LabOrder order = new LabOrder
                            {
                                OrderId = dr["med_id"].ToString(),
                                OrderDate = dr["date_taken"] != DBNull.Value ? Convert.ToDateTime(dr["date_taken"]).ToString("yyyy-MM-dd HH:mm") : "",
                                IsReorder = dr["is_reorder"] != DBNull.Value && Convert.ToBoolean(dr["is_reorder"]),
                                Notes = dr["reorder_reason"]?.ToString() ?? "",
                                OrderedTests = new List<string>(),
                                Results = new List<LabResult>(),
                                IsPaid = isPaid,
                                ChargeAmount = chargeAmount,
                                ChargeStatus = isPaid ? "Paid" : "Unpaid"
                            };

                            orders.Add(order);
                        }
                    }

                    // For each order, get the ordered tests and results
                    foreach (var order in orders)
                    {
                        // Get ordered tests for this specific order
                        SqlCommand cmdTests = new SqlCommand(@"
                            SELECT TestName
                            FROM (
                                SELECT
                                    Hemoglobin, Malaria, ESR, Blood_grouping, Blood_sugar, CBC, 
                                    Cross_matching, TPHA, Human_immune_deficiency_HIV, 
                                    Hepatitis_B_virus_HBV, Hepatitis_C_virus_HCV,
                                    Low_density_lipoprotein_LDL, High_density_lipoprotein_HDL,
                                    Total_cholesterol, Triglycerides, SGPT_ALT, SGOT_AST,
                                    Alkaline_phosphates_ALP, Total_bilirubin, Direct_bilirubin,
                                    Albumin, Urea, Creatinine, Uric_acid, Sodium, Potassium,
                                    Chloride, Calcium, Phosphorous, Magnesium,
                                    General_urine_examination, Progesterone_Female, Amylase,
                                    JGlobulin, Follicle_stimulating_hormone_FSH, Estradiol, 
                                    Luteinizing_hormone_LH, Testosterone_Male, Prolactin, 
                                    Seminal_Fluid_Analysis_Male_B_HCG, Urine_examination, 
                                    Stool_examination, Brucella_melitensis, Brucella_abortus, 
                                    C_reactive_protein_CRP, Rheumatoid_factor_RF, 
                                    Antistreptolysin_O_ASO, Toxoplasmosis, Typhoid_hCG, 
                                    Hpylori_antibody, Stool_occult_blood, General_stool_examination,
                                    Thyroid_profile, Triiodothyronine_T3, Thyroxine_T4, 
                                    Thyroid_stimulating_hormone_TSH, Sperm_examination, 
                                    Virginal_swab_trichomonas_virginals, Human_chorionic_gonadotropin_hCG, 
                                    Hpylori_Ag_stool, Fasting_blood_sugar, Hemoglobin_A1c,
                                    Troponin_I, CK_MB, aPTT, INR, D_Dimer, Vitamin_D, Vitamin_B12, Ferritin, VDRL,
                                    Dengue_Fever_IgG_IgM, Gonorrhea_Ag, AFP, Total_PSA, AMH,
                                    Electrolyte_Test, CRP_Titer, Ultra, Typhoid_IgG, Typhoid_Ag
                                FROM lab_test
                                WHERE med_id = @orderId
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
                                    Chloride, Calcium, Phosphorous, Magnesium,
                                    General_urine_examination, Progesterone_Female, Amylase,
                                    JGlobulin, Follicle_stimulating_hormone_FSH, Estradiol,
                                    Luteinizing_hormone_LH, Testosterone_Male, Prolactin,
                                    Seminal_Fluid_Analysis_Male_B_HCG, Urine_examination,
                                    Stool_examination, Brucella_melitensis, Brucella_abortus,
                                    C_reactive_protein_CRP, Rheumatoid_factor_RF,
                                    Antistreptolysin_O_ASO, Toxoplasmosis, Typhoid_hCG,
                                    Hpylori_antibody, Stool_occult_blood, General_stool_examination,
                                    Thyroid_profile, Triiodothyronine_T3, Thyroxine_T4,
                                    Thyroid_stimulating_hormone_TSH, Sperm_examination,
                                    Virginal_swab_trichomonas_virginals, Human_chorionic_gonadotropin_hCG,
                                    Hpylori_Ag_stool, Fasting_blood_sugar, Hemoglobin_A1c,
                                    Troponin_I, CK_MB, aPTT, INR, D_Dimer, Vitamin_D, Vitamin_B12, Ferritin, VDRL,
                                    Dengue_Fever_IgG_IgM, Gonorrhea_Ag, AFP, Total_PSA, AMH,
                                    Electrolyte_Test, CRP_Titer, Ultra, Typhoid_IgG, Typhoid_Ag
                                )
                            ) unpvt
                            WHERE (TestValue = 'on' OR TestValue = '1' OR TestValue = 'true' OR (TestValue != 'not checked' AND TestValue IS NOT NULL AND TestValue != ''))
                        ", con);
                        
                        cmdTests.Parameters.AddWithValue("@orderId", order.OrderId);

                        using (SqlDataReader drTests = cmdTests.ExecuteReader())
                        {
                            while (drTests.Read())
                            {
                                order.OrderedTests.Add(drTests["TestName"].ToString().Replace("_", " "));
                            }
                        }

                        // Get results linked to this specific order only
                        SqlCommand cmdResults = new SqlCommand(@"
                            SELECT TestName, TestValue
                            FROM (
                                SELECT
                                    Hemoglobin, Malaria, ESR, Blood_grouping, Blood_sugar, CBC, 
                                    Cross_matching, TPHA, Human_immune_deficiency_HIV, 
                                    Hepatitis_B_virus_HBV, Hepatitis_C_virus_HCV,
                                    Low_density_lipoprotein_LDL, High_density_lipoprotein_HDL,
                                    Total_cholesterol, Triglycerides, SGPT_ALT, SGOT_AST,
                                    Alkaline_phosphates_ALP, Total_bilirubin, Direct_bilirubin,
                                    Albumin, Urea, Creatinine, Uric_acid, Sodium, Potassium,
                                    Chloride, Calcium, Phosphorous, Magnesium,
                                    General_urine_examination, Progesterone_Female, Amylase,
                                    JGlobulin, Follicle_stimulating_hormone_FSH, Estradiol, 
                                    Luteinizing_hormone_LH, Testosterone_Male, Prolactin, 
                                    Seminal_Fluid_Analysis_Male_B_HCG, Urine_examination, 
                                    Stool_examination, Brucella_melitensis, Brucella_abortus, 
                                    C_reactive_protein_CRP, Rheumatoid_factor_RF, 
                                    Antistreptolysin_O_ASO, Toxoplasmosis, Typhoid_hCG, 
                                    Hpylori_antibody, Stool_occult_blood, General_stool_examination,
                                    Thyroid_profile, Triiodothyronine_T3, Thyroxine_T4, 
                                    Thyroid_stimulating_hormone_TSH, Sperm_examination, 
                                    Virginal_swab_trichomonas_virginals, Human_chorionic_gonadotropin_hCG, 
                                    Hpylori_Ag_stool, Fasting_blood_sugar, Hemoglobin_A1c,
                                    Troponin_I, CK_MB, aPTT, INR, D_Dimer, Vitamin_D, Vitamin_B12, Ferritin, VDRL,
                                    Dengue_Fever_IgG_IgM, Gonorrhea_Ag, AFP, Total_PSA, AMH,
                                    Electrolyte_Test, CRP_Titer, Ultra, Typhoid_IgG, Typhoid_Ag
                                FROM lab_results
                                WHERE prescid = @prescid 
                                AND lab_test_id = @orderId
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
                                    Chloride, Calcium, Phosphorous, Magnesium,
                                    General_urine_examination, Progesterone_Female, Amylase,
                                    JGlobulin, Follicle_stimulating_hormone_FSH, Estradiol,
                                    Luteinizing_hormone_LH, Testosterone_Male, Prolactin,
                                    Seminal_Fluid_Analysis_Male_B_HCG, Urine_examination,
                                    Stool_examination, Brucella_melitensis, Brucella_abortus,
                                    C_reactive_protein_CRP, Rheumatoid_factor_RF,
                                    Antistreptolysin_O_ASO, Toxoplasmosis, Typhoid_hCG,
                                    Hpylori_antibody, Stool_occult_blood, General_stool_examination,
                                    Thyroid_profile, Triiodothyronine_T3, Thyroxine_T4,
                                    Thyroid_stimulating_hormone_TSH, Sperm_examination,
                                    Virginal_swab_trichomonas_virginals, Human_chorionic_gonadotropin_hCG,
                                    Hpylori_Ag_stool, Fasting_blood_sugar, Hemoglobin_A1c,
                                    Troponin_I, CK_MB, aPTT, INR, D_Dimer, Vitamin_D, Vitamin_B12, Ferritin, VDRL,
                                    Dengue_Fever_IgG_IgM, Gonorrhea_Ag, AFP, Total_PSA, AMH,
                                    Electrolyte_Test, CRP_Titer, Ultra, Typhoid_IgG, Typhoid_Ag
                                )
                            ) unpvt
                            WHERE TestValue IS NOT NULL AND TestValue != ''
                        ", con);
                        
                        cmdResults.Parameters.AddWithValue("@prescid", prescid);
                        cmdResults.Parameters.AddWithValue("@orderId", order.OrderId);

                        using (SqlDataReader drResults = cmdResults.ExecuteReader())
                        {
                            while (drResults.Read())
                            {
                                order.Results.Add(new LabResult
                                {
                                    TestName = drResults["TestName"].ToString().Replace("_", " "),
                                    TestValue = drResults["TestValue"].ToString()
                                });
                            }
                        }
                    }
                }

                return orders.ToArray();
            }
            catch (Exception ex)
            {
                throw new Exception("GetLabOrders Error: " + ex.Message);
            }
        }

        /// <summary>
        /// Get medications for patient
        /// </summary>
        [WebMethod]
        public static Medication[] GetMedications(string prescid)
        {
            List<Medication> meds = new List<Medication>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT 
                        medid,
                        med_name,
                        dosage,
                        frequency,
                        duration,
                        special_inst,
                        date_taken
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

        /// <summary>
        /// Check if patient has unpaid lab or bed charges, and validate conversion eligibility
        /// </summary>
        [WebMethod]
        public static object CheckUnpaidCharges(string patientId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Check unpaid lab charges from patient_charges
                    string labQuery = @"
                        SELECT ISNULL(SUM(amount), 0) as unpaid_lab
                        FROM patient_charges
                        WHERE patientid = @patientId 
                        AND charge_type = 'Lab' 
                        AND ISNULL(is_paid, 0) = 0";

                    decimal unpaidLabCharges = 0;
                    using (SqlCommand cmd = new SqlCommand(labQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            unpaidLabCharges = Convert.ToDecimal(result);
                        }
                    }

                    // Check unpaid bed charges from patient_bed_charges
                    string bedQuery = @"
                        SELECT ISNULL(SUM(bed_charge_amount), 0) as unpaid_bed
                        FROM patient_bed_charges
                        WHERE patientid = @patientId 
                        AND ISNULL(is_paid, 0) = 0";

                    decimal unpaidBedCharges = 0;
                    using (SqlCommand cmd = new SqlCommand(bedQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            unpaidBedCharges = Convert.ToDecimal(result);
                        }
                    }

                    // Check total bed charge count (paid + unpaid)
                    string bedCountQuery = @"
                        SELECT COUNT(*) 
                        FROM patient_bed_charges
                        WHERE patientid = @patientId";

                    int totalBedCharges = 0;
                    using (SqlCommand cmd = new SqlCommand(bedCountQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            totalBedCharges = Convert.ToInt32(result);
                        }
                    }

                    bool hasUnpaidCharges = (unpaidLabCharges > 0 || unpaidBedCharges > 0);
                    bool tooManyBedCharges = totalBedCharges > 1;

                    return new
                    {
                        hasUnpaidCharges = hasUnpaidCharges,
                        unpaidLabCharges = unpaidLabCharges,
                        unpaidBedCharges = unpaidBedCharges,
                        totalUnpaid = unpaidLabCharges + unpaidBedCharges,
                        totalBedCharges = totalBedCharges,
                        canConvert = !hasUnpaidCharges && !tooManyBedCharges
                    };
                }
            }
            catch (Exception ex)
            {
                return new
                {
                    hasUnpaidCharges = false,
                    unpaidLabCharges = 0,
                    unpaidBedCharges = 0,
                    totalUnpaid = 0,
                    totalBedCharges = 0,
                    canConvert = false,
                    error = ex.Message
                };
            }
        }

        /// <summary>
        /// Convert inpatient to outpatient (only if no unpaid lab/bed charges)
        /// </summary>
        [WebMethod]
        public static object ConvertToOutpatient(string patientId, string prescid)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Double-check for unpaid charges and bed charge count before converting
                    string checkQuery = @"
                        SELECT 
                            (SELECT ISNULL(SUM(amount), 0) FROM patient_charges 
                             WHERE patientid = @patientId AND charge_type = 'Lab' AND ISNULL(is_paid, 0) = 0) +
                            (SELECT ISNULL(SUM(bed_charge_amount), 0) FROM patient_bed_charges 
                             WHERE patientid = @patientId AND ISNULL(is_paid, 0) = 0) as total_unpaid,
                            (SELECT COUNT(*) FROM patient_bed_charges 
                             WHERE patientid = @patientId) as bed_charge_count";

                    using (SqlCommand cmd = new SqlCommand(checkQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                decimal totalUnpaid = dr["total_unpaid"] != DBNull.Value ? Convert.ToDecimal(dr["total_unpaid"]) : 0;
                                int bedChargeCount = dr["bed_charge_count"] != DBNull.Value ? Convert.ToInt32(dr["bed_charge_count"]) : 0;

                                if (totalUnpaid > 0)
                                {
                                    return new
                                    {
                                        success = false,
                                        message = $"Cannot convert: Patient has ${totalUnpaid:F2} in unpaid lab/bed charges."
                                    };
                                }

                                if (bedChargeCount > 1)
                                {
                                    return new
                                    {
                                        success = false,
                                        message = $"Cannot convert: Patient has {bedChargeCount} days of bed charges. This indicates they have actually stayed as an inpatient. Use Discharge function instead."
                                    };
                                }
                            }
                        }
                    }

                    // Update patient to outpatient
                    string updateQuery = @"
                        UPDATE patient 
                        SET patient_type = 'outpatient',
                            patient_status = 0,
                            bed_admission_date = NULL
                        WHERE patientid = @patientId";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        cmd.ExecuteNonQuery();
                    }

                    return new
                    {
                        success = true,
                        message = "Patient successfully converted to outpatient"
                    };
                }
            }
            catch (Exception ex)
            {
                return new
                {
                    success = false,
                    message = "Error: " + ex.Message
                };
            }
        }

        /// <summary>
        /// Discharge patient and calculate final charges
        /// </summary>
        [WebMethod]
        public static object DischargePatient(string patientId, string prescid)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // First, check for unpaid charges before allowing discharge
                    string checkUnpaidQuery = @"
                        SELECT 
                            charge_type,
                            charge_name,
                            amount,
                            date_added
                        FROM patient_charges
                        WHERE patientid = @patientId 
                        AND ISNULL(is_paid, 0) = 0
                        
                        UNION ALL
                        
                        SELECT 
                            'Bed' as charge_type,
                            'Daily Bed Charge' as charge_name,
                            bed_charge_amount as amount,
                            charge_date as date_added
                        FROM patient_bed_charges
                        WHERE patientid = @patientId 
                        AND ISNULL(is_paid, 0) = 0
                        
                        ORDER BY date_added DESC";

                    List<object> unpaidCharges = new List<object>();
                    decimal totalUnpaid = 0;

                    using (SqlCommand cmd = new SqlCommand(checkUnpaidQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                decimal amount = dr["amount"] != DBNull.Value ? Convert.ToDecimal(dr["amount"]) : 0;
                                totalUnpaid += amount;

                                unpaidCharges.Add(new
                                {
                                    chargeType = dr["charge_type"].ToString(),
                                    chargeName = dr["charge_name"].ToString(),
                                    amount = amount,
                                    dateAdded = dr["date_added"] != DBNull.Value ? 
                                        Convert.ToDateTime(dr["date_added"]).ToString("yyyy-MM-dd HH:mm") : ""
                                });
                            }
                        }
                    }

                    // If there are unpaid charges, return error with details
                    if (unpaidCharges.Count > 0)
                    {
                        return new
                        {
                            success = false,
                            message = "Cannot discharge: Patient has unpaid charges",
                            unpaidCharges = unpaidCharges,
                            totalUnpaid = totalUnpaid
                        };
                    }

                    // Calculate and record final bed charges BEFORE discharging
                    int patId = Convert.ToInt32(patientId);
                    int? prescriptionId = string.IsNullOrEmpty(prescid) ? (int?)null : Convert.ToInt32(prescid);
                    BedChargeCalculator.StopBedCharges(patId, prescriptionId);

                    // Check again for unpaid charges after calculating final bed charges
                    decimal finalUnpaid = 0;
                    List<object> finalUnpaidCharges = new List<object>();
                    
                    using (SqlCommand cmd = new SqlCommand(checkUnpaidQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                decimal amount = dr["amount"] != DBNull.Value ? Convert.ToDecimal(dr["amount"]) : 0;
                                finalUnpaid += amount;

                                finalUnpaidCharges.Add(new
                                {
                                    chargeType = dr["charge_type"].ToString(),
                                    chargeName = dr["charge_name"].ToString(),
                                    amount = amount,
                                    dateAdded = dr["date_added"] != DBNull.Value ? 
                                        Convert.ToDateTime(dr["date_added"]).ToString("yyyy-MM-dd HH:mm") : ""
                                });
                            }
                        }
                    }

                    // If there are STILL unpaid charges (including final bed charges), don't discharge
                    if (finalUnpaidCharges.Count > 0)
                    {
                        return new
                        {
                            success = false,
                            message = "Cannot discharge: Patient has unpaid charges (including final bed charges)",
                            unpaidCharges = finalUnpaidCharges,
                            totalUnpaid = finalUnpaid
                        };
                    }

                    // All charges paid - proceed with discharge
                    // Update patient status to discharged (2)
                    string updateQuery = @"
                        UPDATE patient 
                        SET patient_status = 2,
                            patient_type = 'discharged'
                        WHERE patientid = @patientId";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        cmd.ExecuteNonQuery();
                    }

                    return new
                    {
                        success = true,
                        message = "Patient successfully discharged"
                    };
                }
            }
            catch (Exception ex)
            {
                return new
                {
                    success = false,
                    message = "Error: " + ex.Message
                };
            }
        }

        /// <summary>
        /// Add additional notes or observations for inpatient
        /// </summary>
        [WebMethod]
        public static string AddMedicalNote(string patientId, string prescid, string note)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    string insertQuery = @"
                        INSERT INTO medication (med_name, dosage, frequency, duration, special_inst, prescid, date_taken)
                        VALUES (@medName, '', '', '', @note, @prescid, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@medName", "Clinical Note");
                        cmd.Parameters.AddWithValue("@note", note);
                        cmd.Parameters.AddWithValue("@prescid", prescid);
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

        /// <summary>
        /// Add new medication for inpatient
        /// </summary>
        [WebMethod]
        public static string AddMedication(string prescid, string medName, string dosage, string frequency, string duration, string specialInst)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    string insertQuery = @"
                        INSERT INTO medication (med_name, dosage, frequency, duration, special_inst, prescid, date_taken)
                        VALUES (@medName, @dosage, @frequency, @duration, @specialInst, @prescid, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@medName", medName);
                        cmd.Parameters.AddWithValue("@dosage", string.IsNullOrEmpty(dosage) ? "" : dosage);
                        cmd.Parameters.AddWithValue("@frequency", string.IsNullOrEmpty(frequency) ? "" : frequency);
                        cmd.Parameters.AddWithValue("@duration", string.IsNullOrEmpty(duration) ? "" : duration);
                        cmd.Parameters.AddWithValue("@specialInst", string.IsNullOrEmpty(specialInst) ? "" : specialInst);
                        cmd.Parameters.AddWithValue("@prescid", prescid);
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

        /// <summary>
        /// Update existing medication
        /// </summary>
        [WebMethod]
        public static string UpdateMedication(int medid, string med_name, string dosage, string frequency, string duration, string special_inst)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    string updateQuery = @"
                        UPDATE [medication] 
                        SET [med_name] = @med_name, 
                            [dosage] = @dosage, 
                            [frequency] = @frequency, 
                            [duration] = @duration, 
                            [special_inst] = @special_inst 
                        WHERE [medid] = @medid";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@medid", medid);
                        cmd.Parameters.AddWithValue("@med_name", med_name);
                        cmd.Parameters.AddWithValue("@dosage", string.IsNullOrEmpty(dosage) ? "" : dosage);
                        cmd.Parameters.AddWithValue("@frequency", string.IsNullOrEmpty(frequency) ? "" : frequency);
                        cmd.Parameters.AddWithValue("@duration", string.IsNullOrEmpty(duration) ? "" : duration);
                        cmd.Parameters.AddWithValue("@special_inst", string.IsNullOrEmpty(special_inst) ? "" : special_inst);

                        cmd.ExecuteNonQuery();
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        /// <summary>
        /// Delete medication
        /// </summary>
        [WebMethod]
        public static string DeleteMedication(int medid)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    string deleteQuery = "DELETE FROM [medication] WHERE [medid] = @medid";

                    using (SqlCommand cmd = new SqlCommand(deleteQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@medid", medid);
                        cmd.ExecuteNonQuery();
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        /// <summary>
        /// Delete a lab order (only if not paid)
        /// </summary>
        [WebMethod]
        public static object DeleteLabOrder(int orderId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // First, check if the order has been paid
                    string checkPaymentQuery = @"
                        SELECT is_paid 
                        FROM patient_charges 
                        WHERE reference_id = @orderId AND charge_type = 'Lab'";

                    bool isPaid = false;
                    using (SqlCommand cmd = new SqlCommand(checkPaymentQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@orderId", orderId);
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            isPaid = Convert.ToBoolean(result);
                        }
                    }

                    // Don't allow deletion if paid
                    if (isPaid)
                    {
                        return new
                        {
                            success = false,
                            message = "Cannot delete this order because payment has already been received."
                        };
                    }

                    // Delete the charge first
                    string deleteChargeQuery = @"
                        DELETE FROM patient_charges 
                        WHERE reference_id = @orderId AND charge_type = 'Lab'";

                    using (SqlCommand cmd = new SqlCommand(deleteChargeQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@orderId", orderId);
                        cmd.ExecuteNonQuery();
                    }

                    // Delete any results for this order
                    string deleteResultsQuery = "DELETE FROM lab_results WHERE lab_test_id = @orderId";
                    using (SqlCommand cmd = new SqlCommand(deleteResultsQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@orderId", orderId);
                        cmd.ExecuteNonQuery();
                    }

                    // Get the prescription ID before deleting the lab order
                    string prescriptionId = "";
                    string getPrescidQuery = "SELECT prescid FROM lab_test WHERE med_id = @orderId";
                    using (SqlCommand cmd = new SqlCommand(getPrescidQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@orderId", orderId);
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            prescriptionId = result.ToString();
                        }
                    }

                    // Delete the lab test order
                    string deleteOrderQuery = "DELETE FROM lab_test WHERE med_id = @orderId";
                    using (SqlCommand cmd = new SqlCommand(deleteOrderQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@orderId", orderId);
                        cmd.ExecuteNonQuery();
                    }

                    // Check if there are any remaining lab orders for this prescription
                    if (!string.IsNullOrEmpty(prescriptionId))
                    {
                        string checkRemainingQuery = "SELECT COUNT(*) FROM lab_test WHERE prescid = @prescid";
                        using (SqlCommand cmd = new SqlCommand(checkRemainingQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@prescid", prescriptionId);
                            int remaining = (int)cmd.ExecuteScalar();
                            
                            if (remaining == 0)
                            {
                                // No more lab orders, update prescription status if needed
                                // You can add logic here to update prescription lab status
                            }
                        }
                    }

                    return new
                    {
                        success = true,
                        message = "Lab order deleted successfully."
                    };
                }
            }
            catch (Exception ex)
            {
                return new
                {
                    success = false,
                    message = "Error: " + ex.Message
                };
            }
        }

        /// <summary>
        /// Get existing tests for a specific lab order
        /// </summary>
        [WebMethod]
        public static List<string> GetOrderTests(int orderId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            var tests = new List<string>();

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    string query = "SELECT * FROM lab_test WHERE med_id = @orderId";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@orderId", orderId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                // Loop through all columns to find ordered tests
                                for (int i = 0; i < reader.FieldCount; i++)
                                {
                                    string columnName = reader.GetName(i);

                                    // Skip system columns (but not test names that happen to contain these strings)
                                    if (columnName.ToLower() == "med_id" ||
                                        columnName.ToLower() == "prescid" ||
                                        columnName.ToLower() == "original_order_id" ||
                                        columnName.ToLower().Contains("date") ||
                                        columnName.ToLower() == "type" ||
                                        columnName.ToLower() == "is_reorder" ||
                                        columnName.ToLower() == "reorder_reason")
                                        continue;

                                    if (reader[columnName] != DBNull.Value)
                                    {
                                        string value = reader[columnName].ToString().Trim();

                                        if (!string.IsNullOrEmpty(value) &&
                                            !value.Equals("not checked", StringComparison.OrdinalIgnoreCase) &&
                                            !value.Equals("0", StringComparison.OrdinalIgnoreCase) &&
                                            !value.Equals("false", StringComparison.OrdinalIgnoreCase))
                                        {
                                            tests.Add(columnName);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                return tests;
            }
            catch (Exception ex)
            {
                throw new Exception("Error getting order tests: " + ex.Message, ex);
            }
        }

        /// <summary>
        /// Check if there's an existing unprocessed lab order that can be edited
        /// </summary>
        [WebMethod]
        public static object CheckExistingOrder(string prescid)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    
                    // Check for unpaid order (can edit) or paid but not processed order
                    SqlCommand cmd = new SqlCommand(@"
                        SELECT TOP 1 lt.med_id, pr.lab_charge_paid, 
                               CASE WHEN lr.lab_result_id IS NULL THEN 0 ELSE 1 END as has_results
                        FROM lab_test lt
                        INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
                        LEFT JOIN lab_results lr ON lt.prescid = lr.prescid AND lr.lab_test_id = lt.med_id
                        WHERE lt.prescid = @prescid
                        ORDER BY lt.date_taken DESC
                    ", con);
                    
                    cmd.Parameters.AddWithValue("@prescid", prescid);
                    
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            int orderId = Convert.ToInt32(dr["med_id"]);
                            int isPaid = dr["lab_charge_paid"] != DBNull.Value ? Convert.ToInt32(dr["lab_charge_paid"]) : 0;
                            int hasResults = Convert.ToInt32(dr["has_results"]);
                            
                            // Can only edit if unpaid - once payment is received, cannot edit or delete
                            bool canEdit = (isPaid == 0);
                            
                            return new { 
                                hasOrder = true, 
                                orderId = orderId,
                                canEdit = canEdit,
                                isPaid = isPaid == 1,
                                hasResults = hasResults == 1
                            };
                        }
                    }
                }
                
                return new { hasOrder = false, canEdit = false };
            }
            catch (Exception ex)
            {
                return new { hasOrder = false, canEdit = false, error = ex.Message };
            }
        }

        /// <summary>
        /// Update existing lab order (add/edit tests before lab processes)
        /// </summary>
        /// <summary>
        /// Update existing lab order with new test selection - COMPLETE REPLACEMENT
        /// </summary>
        [WebMethod]
        public static string UpdateLabOrder(string prescid, int orderId, List<string> tests, string notes)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            // DEBUG: Log received parameters
            System.Diagnostics.Debug.WriteLine("=== UPDATE LAB ORDER BACKEND DEBUG ===");
            System.Diagnostics.Debug.WriteLine($"Prescription ID: {prescid ?? "NULL"}");
            System.Diagnostics.Debug.WriteLine($"Order ID: {orderId}");
            System.Diagnostics.Debug.WriteLine($"Notes: {notes ?? "NULL"}");
            System.Diagnostics.Debug.WriteLine($"Tests Count: {(tests != null ? tests.Count : 0)}");
            if (tests != null)
            {
                for (int i = 0; i < tests.Count; i++)
                {
                    System.Diagnostics.Debug.WriteLine($"Test {i + 1}: {tests[i]}");
                }
            }
            System.Diagnostics.Debug.WriteLine("====================================");

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // First, reset all test columns to NULL for this order
                    string resetQuery = @"
                        UPDATE lab_test SET 
                            Hemoglobin = NULL, Malaria = NULL, ESR = NULL, Blood_grouping = NULL, Blood_sugar = NULL, CBC = NULL,
                            Cross_matching = NULL, TPHA = NULL, Human_immune_deficiency_HIV = NULL, Hepatitis_B_virus_HBV = NULL,
                            Hepatitis_C_virus_HCV = NULL, Low_density_lipoprotein_LDL = NULL, High_density_lipoprotein_HDL = NULL,
                            Total_cholesterol = NULL, Triglycerides = NULL, SGPT_ALT = NULL, SGOT_AST = NULL,
                            Alkaline_phosphates_ALP = NULL, Total_bilirubin = NULL, Direct_bilirubin = NULL, Albumin = NULL,
                            Urea = NULL, Creatinine = NULL, Uric_acid = NULL, Sodium = NULL, Potassium = NULL, Chloride = NULL,
                            Calcium = NULL, Phosphorous = NULL, Magnesium = NULL, General_urine_examination = NULL,
                            Progesterone_Female = NULL, Amylase = NULL, JGlobulin = NULL, Follicle_stimulating_hormone_FSH = NULL,
                            Estradiol = NULL, Luteinizing_hormone_LH = NULL, Testosterone_Male = NULL, Prolactin = NULL,
                            Seminal_Fluid_Analysis_Male_B_HCG = NULL, Urine_examination = NULL, Stool_examination = NULL,
                            Brucella_melitensis = NULL, Brucella_abortus = NULL, C_reactive_protein_CRP = NULL,
                            Rheumatoid_factor_RF = NULL, Antistreptolysin_O_ASO = NULL, Toxoplasmosis = NULL, Typhoid_hCG = NULL,
                            Hpylori_antibody = NULL, Stool_occult_blood = NULL, General_stool_examination = NULL,
                            Thyroid_profile = NULL, Triiodothyronine_T3 = NULL, Thyroxine_T4 = NULL,
                            Thyroid_stimulating_hormone_TSH = NULL, Sperm_examination = NULL,
                            Virginal_swab_trichomonas_virginals = NULL, Human_chorionic_gonadotropin_hCG = NULL,
                            Hpylori_Ag_stool = NULL, Fasting_blood_sugar = NULL, Hemoglobin_A1c = NULL,
                            Troponin_I = NULL, CK_MB = NULL, aPTT = NULL, INR = NULL, D_Dimer = NULL,
                            Vitamin_D = NULL, Vitamin_B12 = NULL, Ferritin = NULL, VDRL = NULL,
                            Dengue_Fever_IgG_IgM = NULL, Gonorrhea_Ag = NULL, AFP = NULL, Total_PSA = NULL, AMH = NULL,
                            Electrolyte_Test = NULL, CRP_Titer = NULL, Ultra = NULL, Typhoid_IgG = NULL, Typhoid_Ag = NULL,
                            reorder_reason = @notes
                        WHERE med_id = @orderId";

                    using (SqlCommand resetCmd = new SqlCommand(resetQuery, con))
                    {
                        resetCmd.Parameters.AddWithValue("@orderId", orderId);
                        resetCmd.Parameters.AddWithValue("@notes", notes ?? "");
                        resetCmd.ExecuteNonQuery();
                    }

                    // Get existing charges (with charge_id for deletion)
                    var existingCharges = new Dictionary<string, int>(); // charge_name -> charge_id
                    string getExistingChargesQuery = @"
                        SELECT charge_id, charge_name FROM patient_charges 
                        WHERE reference_id = @orderId AND charge_type = 'Lab' AND is_paid = 0";
                    
                    using (SqlCommand getChargesCmd = new SqlCommand(getExistingChargesQuery, con))
                    {
                        getChargesCmd.Parameters.AddWithValue("@orderId", orderId);
                        using (SqlDataReader dr = getChargesCmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                existingCharges.Add(dr["charge_name"].ToString(), Convert.ToInt32(dr["charge_id"]));
                            }
                        }
                    }

                    // Now set only the selected tests to 'on'
                    if (tests != null && tests.Count > 0)
                    {
                        string updateQuery = "UPDATE lab_test SET ";
                        var parameters = new List<SqlParameter>();
                        
                        for (int i = 0; i < tests.Count; i++)
                        {
                            if (i > 0) updateQuery += ", ";
                            updateQuery += $"[{tests[i]}] = @test{i}";
                            parameters.Add(new SqlParameter($"@test{i}", "on"));
                        }
                        
                        updateQuery += " WHERE med_id = @orderId";
                        parameters.Add(new SqlParameter("@orderId", orderId));

                        // DEBUG: Log the SQL query being executed
                        System.Diagnostics.Debug.WriteLine("=== SQL UPDATE QUERY ===");
                        System.Diagnostics.Debug.WriteLine($"SQL: {updateQuery}");
                        foreach (var param in parameters)
                        {
                            System.Diagnostics.Debug.WriteLine($"Parameter: {param.ParameterName} = {param.Value}");
                        }
                        System.Diagnostics.Debug.WriteLine("=======================");

                        using (SqlCommand updateCmd = new SqlCommand(updateQuery, con))
                        {
                            updateCmd.Parameters.AddRange(parameters.ToArray());
                            int rowsAffected = updateCmd.ExecuteNonQuery();
                            
                            System.Diagnostics.Debug.WriteLine($"Rows affected: {rowsAffected}");
                        }

                        // Create charges for NEWLY ADDED tests only
                        // Get patientid from prescription
                        int patientId = 0;
                        string getPatientQuery = "SELECT patientid FROM prescribtion WHERE prescid = (SELECT prescid FROM lab_test WHERE med_id = @orderId)";
                        using (SqlCommand getPatientCmd = new SqlCommand(getPatientQuery, con))
                        {
                            getPatientCmd.Parameters.AddWithValue("@orderId", orderId);
                            object result = getPatientCmd.ExecuteScalar();
                            if (result != null) patientId = Convert.ToInt32(result);
                        }

                        // Get prescid
                        int prescId = 0;
                        string getPrescQuery = "SELECT prescid FROM lab_test WHERE med_id = @orderId";
                        using (SqlCommand getPrescCmd = new SqlCommand(getPrescQuery, con))
                        {
                            getPrescCmd.Parameters.AddWithValue("@orderId", orderId);
                            object result = getPrescCmd.ExecuteScalar();
                            if (result != null) prescId = Convert.ToInt32(result);
                        }

                        // Track which tests are currently ordered (for deletion check)
                        var orderedTestDisplayNames = new HashSet<string>();

                        foreach (string testName in tests)
                        {
                            decimal testPrice = LabTestPriceCalculator.GetTestPrice(testName);
                            string testDisplayName = GetTestDisplayName(testName, con, null);

                            // Track this test as ordered
                            orderedTestDisplayNames.Add(testDisplayName);

                            // Only create charge if it doesn't already exist for this test
                            if (!existingCharges.ContainsKey(testDisplayName))
                            {
                                string insertChargeQuery = @"
                                    INSERT INTO patient_charges (patientid, prescid, charge_type, charge_name, amount, is_paid, date_added, reference_id)
                                    VALUES (@patientid, @prescid, 'Lab', @chargeName, @amount, 0, @date_added, @orderId)";

                                using (SqlCommand insertChargeCmd = new SqlCommand(insertChargeQuery, con))
                                {
                                    insertChargeCmd.Parameters.AddWithValue("@patientid", patientId);
                                    insertChargeCmd.Parameters.AddWithValue("@prescid", prescId);
                                    insertChargeCmd.Parameters.AddWithValue("@chargeName", testDisplayName);
                                    insertChargeCmd.Parameters.AddWithValue("@amount", testPrice);
                                    insertChargeCmd.Parameters.AddWithValue("@date_added", DateTimeHelper.Now);
                                    insertChargeCmd.Parameters.AddWithValue("@orderId", orderId);
                                    insertChargeCmd.ExecuteNonQuery();

                                    System.Diagnostics.Debug.WriteLine($"Created NEW charge for: {testDisplayName} = ${testPrice}");
                                }
                            }
                            else
                            {
                                System.Diagnostics.Debug.WriteLine($"Charge already exists for: {testDisplayName} - skipping");
                            }
                        }

                        // Delete charges for tests that were REMOVED (only unpaid charges)
                        foreach (var existingCharge in existingCharges)
                        {
                            string chargeName = existingCharge.Key;
                            int chargeId = existingCharge.Value;

                            // If this charge's test is NOT in the current ordered tests, delete it
                            if (!orderedTestDisplayNames.Contains(chargeName))
                            {
                                string deleteChargeQuery = @"
                                    DELETE FROM patient_charges 
                                    WHERE charge_id = @chargeId AND is_paid = 0";

                                using (SqlCommand deleteChargeCmd = new SqlCommand(deleteChargeQuery, con))
                                {
                                    deleteChargeCmd.Parameters.AddWithValue("@chargeId", chargeId);
                                    deleteChargeCmd.ExecuteNonQuery();

                                    System.Diagnostics.Debug.WriteLine($"Deleted charge for removed test: {chargeName}");
                                }
                            }
                        }
                    }
                }

                return "success";
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"UpdateLabOrder Error: {ex.Message}");
                return "Error: " + ex.Message;
            }
        }

        /// <summary>
        /// Order lab tests for inpatient (new order or follow-up)
        /// Creates UNPAID charge that must be paid before lab can see order
        /// </summary>
        [WebMethod]
        public static string OrderLabTests(string prescid, string patientId, List<string> tests, string notes)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    SqlTransaction transaction = con.BeginTransaction();

                    try
                    {
                        // Check if there's an editable order (unpaid or paid but no results)
                        SqlCommand checkCmd = new SqlCommand(@"
                            SELECT TOP 1 lt.med_id, pr.lab_charge_paid,
                                   CASE WHEN lr.lab_result_id IS NULL THEN 0 ELSE 1 END as has_results
                            FROM lab_test lt
                            INNER JOIN prescribtion pr ON lt.prescid = pr.prescid
                            LEFT JOIN lab_results lr ON lt.prescid = lr.prescid AND lr.lab_test_id = lt.med_id
                            WHERE lt.prescid = @prescid
                            ORDER BY lt.date_taken DESC
                        ", con, transaction);
                        checkCmd.Parameters.AddWithValue("@prescid", prescid);
                        
                        object existingOrderId = null;
                        bool canEdit = false;
                        
                        using (SqlDataReader dr = checkCmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                existingOrderId = dr["med_id"];
                                int isPaid = dr["lab_charge_paid"] != DBNull.Value ? Convert.ToInt32(dr["lab_charge_paid"]) : 0;
                                int hasResults = Convert.ToInt32(dr["has_results"]);
                                
                                // Can add to existing order if no results yet
                                canEdit = hasResults == 0;
                            }
                        }
                        
                        // If there's an editable order, use UpdateLabOrder instead
                        if (canEdit && existingOrderId != null)
                        {
                            transaction.Rollback();
                            return "existing_order:" + existingOrderId.ToString();
                        }
                        
                        bool isReorder = existingOrderId != null;

                        // Build dynamic SQL for inserting lab test order
                        string columns = "prescid, is_reorder, reorder_reason, date_taken";
                        string values = "@prescid, @isReorder, @notes, @date_taken";
                        
                        // Add each selected test
                        foreach (string test in tests)
                        {
                            columns += ", [" + test + "]";
                            values += ", 'on'";
                        }

                        string insertQuery = $"INSERT INTO lab_test ({columns}) OUTPUT INSERTED.med_id VALUES ({values})";

                        int newOrderId;
                        using (SqlCommand cmd = new SqlCommand(insertQuery, con, transaction))
                        {
                            cmd.Parameters.AddWithValue("@prescid", prescid);
                            cmd.Parameters.AddWithValue("@isReorder", isReorder ? 1 : 0);
                            cmd.Parameters.AddWithValue("@notes", string.IsNullOrEmpty(notes) ? "" : notes);
                            cmd.Parameters.AddWithValue("@date_taken", DateTimeHelper.Now);
                            newOrderId = (int)cmd.ExecuteScalar();
                        }

                        // Create INDIVIDUAL charges for each ordered test using the new pricing system
                        decimal totalCharges = 0;
                        foreach (string testName in tests)
                        {
                            // Get price for this specific test
                            decimal testPrice = LabTestPriceCalculator.GetTestPrice(testName);
                            totalCharges += testPrice;

                            // Get display name for the test
                            string testDisplayName = GetTestDisplayName(testName, con, transaction);
                            
                            string chargeDescription = isReorder ? 
                                $"{testDisplayName} - Follow-up" : 
                                testDisplayName;
                            
                            if (!string.IsNullOrEmpty(notes))
                            {
                                chargeDescription += $" ({notes})";
                            }

                            // Create individual charge entry for this test
                            SqlCommand insertChargeCmd = new SqlCommand(@"
                                INSERT INTO patient_charges (patientid, prescid, charge_type, charge_name, amount, is_paid, date_added, reference_id)
                                VALUES (@patientid, @prescid, 'Lab', @chargeName, @amount, 0, @date_added, @orderId)
                            ", con, transaction);
                            
                            insertChargeCmd.Parameters.AddWithValue("@patientid", patientId);
                            insertChargeCmd.Parameters.AddWithValue("@prescid", prescid);
                            insertChargeCmd.Parameters.AddWithValue("@chargeName", chargeDescription);
                            insertChargeCmd.Parameters.AddWithValue("@amount", testPrice);
                            insertChargeCmd.Parameters.AddWithValue("@date_added", DateTimeHelper.Now);
                            insertChargeCmd.Parameters.AddWithValue("@orderId", newOrderId);
                            insertChargeCmd.ExecuteNonQuery();
                        }

                        // Set lab_charge_paid = 0 (unpaid - lab won't see order yet)
                        SqlCommand updatePrescCmd = new SqlCommand(@"
                            UPDATE prescribtion 
                            SET lab_charge_paid = 0 
                            WHERE prescid = @prescid
                        ", con, transaction);
                        updatePrescCmd.Parameters.AddWithValue("@prescid", prescid);
                        updatePrescCmd.ExecuteNonQuery();

                        transaction.Commit();
                        return "success";
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        throw;
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        // Data Classes
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
            public string lab_charge_paid { get; set; }
            public string xray_charge_paid { get; set; }
            public string doctorid { get; set; }
            public string doctortitle { get; set; }
            public string doctor_name { get; set; }
            public string lab_test_status { get; set; }
            public string lab_result_status { get; set; }
            public string xray_order_status { get; set; }
            public string xray_result_status { get; set; }
            public string medication_count { get; set; }
            public string unpaid_charges { get; set; }
            public string paid_charges { get; set; }
            public string total_bed_charges { get; set; }
        }

        // Helper method to get test display name
        private static string GetTestDisplayName(string testName, SqlConnection con, SqlTransaction transaction)
        {
            try
            {
                string query = "SELECT test_display_name FROM lab_test_prices WHERE test_name = @testName";
                using (SqlCommand cmd = new SqlCommand(query, con, transaction))
                {
                    cmd.Parameters.AddWithValue("@testName", testName);
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        return result.ToString();
                    }
                }
            }
            catch { }
            
            return testName; // Return column name if display name not found
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

        public class LabOrder
        {
            public string OrderId { get; set; }
            public string OrderDate { get; set; }
            public bool IsReorder { get; set; }
            public string Notes { get; set; }
            public List<string> OrderedTests { get; set; }
            public List<LabResult> Results { get; set; }
            public bool IsPaid { get; set; }
            public decimal ChargeAmount { get; set; }
            public string ChargeStatus { get; set; }
        }

        public class LabTestInfo
        {
            public List<LabTest> OrderedTests { get; set; }
            public List<LabResult> Results { get; set; }
        }

        public class LabTest
        {
            public string TestName { get; set; }
            public bool IsReorder { get; set; }
            public string ReorderReason { get; set; }
            public string DateOrdered { get; set; }
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
