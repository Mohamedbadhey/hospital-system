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
    public partial class assignmed : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Bed charges are now calculated automatically via SQL Server Agent Job
            // See AUTOMATE_BED_CHARGES.sql for setup instructions
            
            // Get doctor ID from session and store in hidden field for JavaScript access
            //if (Session["id"] != null)
            //{
            //    hdnDoctorId.Value = Session["id"].ToString();
            //}
        }

        [WebMethod]
        public static xrydes[] xrydata(string prescid)
        {
            List<xrydes> details = new List<xrydes>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
  	select * from xray where prescid = @search;

 ", con);
                cmd.Parameters.AddWithValue("@search", prescid);


                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        xrydes field = new xrydes();


                        field.xryname = dr["xryname"].ToString();
                        field.xrydescribtion = dr["xrydescribtion"].ToString();
                        field.type = dr["type"].ToString();
                   

                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }

        public class xrydes
        {
            public string xryname;
            public string xrydescribtion;
            public string type;
        }
        [WebMethod]
        public static string deleteJob(string medid)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Delete job from jobs table
                    string jobQuery = "DELETE FROM [medication] WHERE [medid] = @medid";

                    using (SqlCommand cmd = new SqlCommand(jobQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@medid", medid);

                        cmd.ExecuteNonQuery();
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                // Handle exceptions
                throw new Exception("Error deleting job", ex);
            }
        }


        [WebMethod]
        public static string updateJob(string medid, string med_name, string dosage, string frequency, string duration, string special_inst)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Update jobs table
                    string jobQuery = "UPDATE [medication] SET " +
                          "[med_name] = @med_name," +
                            "[dosage] = @dosage," +
                            "[frequency] = @frequency," +
                        "[duration] = @duration," +
                           "[special_inst] = @special_inst" +
                        " WHERE [medid] = @medid";

                    using (SqlCommand cmd = new SqlCommand(jobQuery, con))
                    {

                        cmd.Parameters.AddWithValue("@med_name", med_name);
                        cmd.Parameters.AddWithValue("@dosage", dosage);
                        cmd.Parameters.AddWithValue("@frequency", frequency);
                        cmd.Parameters.AddWithValue("@duration", duration);
                        cmd.Parameters.AddWithValue("@special_inst", special_inst);
                        cmd.Parameters.AddWithValue("@medid", medid);

                        cmd.ExecuteNonQuery();
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                // Handle exceptions
                throw new Exception("Error updating job information", ex);
            }
        }






        [WebMethod]
        public static string realxryupdate( string xryid, string xrayname, string inst, string typeimg)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Update jobs table
                    string jobQuery = "UPDATE [xray] SET " +
                          "[xryname] = @xryname," +
                               "[type] = @typeimg," +
                            "[xrydescribtion] = @xrydescribtion" +
                              " WHERE [xrayid] = @xrayid";

                    using (SqlCommand cmd = new SqlCommand(jobQuery, con))
                    {

                        cmd.Parameters.AddWithValue("@xryname", xrayname);
                        cmd.Parameters.AddWithValue("@xrydescribtion", inst);
                        cmd.Parameters.AddWithValue("@xrayid", xryid);
                        cmd.Parameters.AddWithValue("@typeimg", typeimg);
                        


                        cmd.ExecuteNonQuery();
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                // Handle exceptions
                throw new Exception("Error updating job information", ex);
                Console.WriteLine(ex.Message);
            }
        }

















        [WebMethod]
        public static string submitdata(string status, string id, string med_name, string dosage, string frequency, string duration, string special_inst, string prescid)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Insert medication
                    string patientquery = "INSERT INTO medication (med_name, dosage, frequency, duration, special_inst, prescid) VALUES (@med_name, @dosage, @frequency, @duration, @special_inst, @prescid);";

                    using (SqlCommand cmd = new SqlCommand(patientquery, con))
                    {
                        cmd.Parameters.AddWithValue("@med_name", med_name);
                        cmd.Parameters.AddWithValue("@dosage", dosage);
                        cmd.Parameters.AddWithValue("@frequency", frequency);
                        cmd.Parameters.AddWithValue("@duration", duration);
                        cmd.Parameters.AddWithValue("@special_inst", special_inst);
                        cmd.Parameters.AddWithValue("@prescid", prescid);
                        cmd.ExecuteNonQuery();
                    }

                    // Get current patient type
                    string currentPatientType = "";
                    string checkQuery = "SELECT patient_type FROM patient WHERE patientid = @id";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                    {
                        checkCmd.Parameters.AddWithValue("@id", id);
                        object result = checkCmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            currentPatientType = result.ToString();
                        }
                    }

                    // Determine new patient type based on status
                    string newPatientType = status == "1" ? "inpatient" : "outpatient";

                    // Update patient status and type
                    string patientUpdateQuery = @"UPDATE [patient] SET 
                                                [patient_status] = @status,
                                                [patient_type] = @patientType,
                                                [bed_admission_date] = @bedAdmissionDate
                                              WHERE [patientid] = @id";

                    using (SqlCommand cmd1 = new SqlCommand(patientUpdateQuery, con))
                    {
                        cmd1.Parameters.AddWithValue("@id", id);
                        cmd1.Parameters.AddWithValue("@status", status);
                        cmd1.Parameters.AddWithValue("@patientType", newPatientType);

                        // Set bed admission date if changing to inpatient
                        if (newPatientType == "inpatient" && currentPatientType != "inpatient")
                        {
                            cmd1.Parameters.AddWithValue("@bedAdmissionDate", DateTimeHelper.Now);
                        }
                        else if (newPatientType == "outpatient")
                        {
                            cmd1.Parameters.AddWithValue("@bedAdmissionDate", DBNull.Value);
                        }
                        else
                        {
                            cmd1.Parameters.AddWithValue("@bedAdmissionDate", DBNull.Value);
                        }

                        cmd1.ExecuteNonQuery();
                    }

                    // If changing from inpatient to outpatient, calculate final bed charges
                    if (currentPatientType == "inpatient" && newPatientType == "outpatient")
                    {
                        int patientId = Convert.ToInt32(id);
                        int? prescriptionId = string.IsNullOrEmpty(prescid) ? (int?)null : Convert.ToInt32(prescid);
                        BedChargeCalculator.StopBedCharges(patientId, prescriptionId);
                    }
                    // If changing to inpatient, start bed charge tracking
                    else if (newPatientType == "inpatient")
                    {
                        int patientId = Convert.ToInt32(id);
                        int? prescriptionId = string.IsNullOrEmpty(prescid) ? (int?)null : Convert.ToInt32(prescid);
                        BedChargeCalculator.CalculatePatientBedCharges(patientId, prescriptionId);
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                return "Error in submitdata method: " + ex.Message;
            }
        }

        public class labresukt
        {
            public string TestName { get; set; }
            public string TestValue { get; set; }
        }

        [WebMethod]
        public static labresukt[] lab_test(string prescid)
        {
            List<labresukt> details = new List<labresukt>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
    


SELECT lab_result_id, TestName, TestValue
FROM
(
    SELECT [lab_result_id]
          ,[Biochemistry]
          ,[Lipid_profile]
          ,[Low_density_lipoprotein_LDL]
          ,[High_density_lipoprotein_HDL]
          ,[Total_cholesterol]
          ,[Triglycerides]
          ,[Liver_function_test]
          ,[SGPT_ALT]
          ,[SGOT_AST]
          ,[Alkaline_phosphates_ALP]
          ,[Total_bilirubin]
          ,[Direct_bilirubin]
          ,[Albumin]
          ,[JGlobulin]
          ,[Renal_profile]
          ,[Urea]
          ,[Creatinine]
          ,[Uric_acid]
          ,[Electrolytes]
          ,[Sodium]
          ,[Potassium]
          ,[Chloride]
          ,[Calcium]
          ,[Phosphorous]
          ,[Magnesium]
          ,[Pancreases]
          ,[Amylase]
          ,[Hematology]
          ,[Hemoglobin]
          ,[Malaria]
          ,[ESR]
          ,[Blood_grouping]
          ,[Blood_sugar]
          ,[CBC]
          ,[Cross_matching]
          ,[Immunology_Virology]
          ,[TPHA]
          ,[Human_immune_deficiency_HIV]
          ,[Hepatitis_B_virus_HBV]
          ,[Hepatitis_C_virus_HCV]
          ,[Brucella_melitensis]
          ,[Brucella_abortus]
          ,[C_reactive_protein_CRP]
          ,[Rheumatoid_factor_RF]
          ,[Antistreptolysin_O_ASO]
          ,[Toxoplasmosis]
          ,[Typhoid_hCG]
          ,[Hpylori_antibody]
          ,[Parasitology]
          ,[Stool_occult_blood]
          ,[General_stool_examination]
          ,[Hormones]
          ,[Thyroid_profile]
          ,[Triiodothyronine_T3]
          ,[Thyroxine_T4]
          ,[Thyroid_stimulating_hormone_TSH]
          ,[Fertility_profile]
          ,[Progesterone_Female]
          ,[Follicle_stimulating_hormone_FSH]
          ,[Estradiol]
          ,[Luteinizing_hormone_LH]
          ,[Testosterone_Male]
          ,[Prolactin]
          ,[Seminal_Fluid_Analysis_Male_B_HCG]
          ,[Clinical_path]
          ,[Urine_examination]
          ,[Stool_examination]
          ,[Sperm_examination]
          ,[Virginal_swab_trichomonas_virginals]
          ,[Human_chorionic_gonadotropin_hCG]
          ,[Hpylori_Ag_stool]
          ,[Diabetes]
          ,[Fasting_blood_sugar]
          ,[Hemoglobin_A1c]
          ,[General_urine_examination]
          ,[Troponin_I]
          ,[CK_MB]
          ,[aPTT]
          ,[INR]
          ,[D_Dimer]
          ,[Vitamin_D]
          ,[Vitamin_B12]
          ,[Ferritin]
          ,[VDRL]
          ,[Dengue_Fever_IgG_IgM]
          ,[Gonorrhea_Ag]
          ,[AFP]
          ,[Total_PSA]
          ,[AMH]
          ,[Electrolyte_Test]
          ,[CRP_Titer]
          ,[Ultra]
          ,[Typhoid_IgG]
          ,[Typhoid_Ag]
    FROM [lab_results]
    WHERE prescid = @search
) src
UNPIVOT
(
    TestValue FOR TestName IN 
    ([Biochemistry]
    ,[Lipid_profile]
    ,[Low_density_lipoprotein_LDL]
    ,[High_density_lipoprotein_HDL]
    ,[Total_cholesterol]
    ,[Triglycerides]
    ,[Liver_function_test]
    ,[SGPT_ALT]
    ,[SGOT_AST]
    ,[Alkaline_phosphates_ALP]
    ,[Total_bilirubin]
    ,[Direct_bilirubin]
    ,[Albumin]
    ,[JGlobulin]
    ,[Renal_profile]
    ,[Urea]
    ,[Creatinine]
    ,[Uric_acid]
    ,[Electrolytes]
    ,[Sodium]
    ,[Potassium]
    ,[Chloride]
    ,[Calcium]
    ,[Phosphorous]
    ,[Magnesium]
    ,[Pancreases]
    ,[Amylase]
    ,[Hematology]
    ,[Hemoglobin]
    ,[Malaria]
    ,[ESR]
    ,[Blood_grouping]
    ,[Blood_sugar]
    ,[CBC]
    ,[Cross_matching]
    ,[Immunology_Virology]
    ,[TPHA]
    ,[Human_immune_deficiency_HIV]
    ,[Hepatitis_B_virus_HBV]
    ,[Hepatitis_C_virus_HCV]
    ,[Brucella_melitensis]
    ,[Brucella_abortus]
    ,[C_reactive_protein_CRP]
    ,[Rheumatoid_factor_RF]
    ,[Antistreptolysin_O_ASO]
    ,[Toxoplasmosis]
    ,[Typhoid_hCG]
    ,[Hpylori_antibody]
    ,[Parasitology]
    ,[Stool_occult_blood]
    ,[General_stool_examination]
    ,[Hormones]
    ,[Thyroid_profile]
    ,[Triiodothyronine_T3]
    ,[Thyroxine_T4]
    ,[Thyroid_stimulating_hormone_TSH]
    ,[Fertility_profile]
    ,[Progesterone_Female]
    ,[Follicle_stimulating_hormone_FSH]
    ,[Estradiol]
    ,[Luteinizing_hormone_LH]
    ,[Testosterone_Male]
    ,[Prolactin]
    ,[Seminal_Fluid_Analysis_Male_B_HCG]
    ,[Clinical_path]
    ,[Urine_examination]
    ,[Stool_examination]
    ,[Sperm_examination]
    ,[Virginal_swab_trichomonas_virginals]
    ,[Human_chorionic_gonadotropin_hCG]
    ,[Hpylori_Ag_stool]
    ,[Diabetes]
    ,[Fasting_blood_sugar]
    ,[Hemoglobin_A1c]
    ,[General_urine_examination]
    ,[Troponin_I]
    ,[CK_MB]
    ,[aPTT]
    ,[INR]
    ,[D_Dimer]
    ,[Vitamin_D]
    ,[Vitamin_B12]
    ,[Ferritin]
    ,[VDRL]
    ,[Dengue_Fever_IgG_IgM]
    ,[Gonorrhea_Ag]
    ,[AFP]
    ,[Total_PSA]
    ,[AMH]
    ,[Electrolyte_Test]
    ,[CRP_Titer]
    ,[Ultra]
    ,[Typhoid_IgG]
    ,[Typhoid_Ag])
) unpvt
WHERE TestValue IS NOT NULL AND TestValue != '';


 ", con);
                cmd.Parameters.AddWithValue("@search", prescid);


                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        labresukt field = new labresukt();


                        field.TestName = dr["TestName"].ToString();
                        field.TestValue = dr["TestValue"].ToString();
                     

                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }

        [WebMethod]
        public static ptclass[] medic(string search, string doctorId)
        {
            List<ptclass> details = new List<ptclass>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
	SELECT 
    patient.patientid,
    patient.full_name, 
    patient.sex,
    patient.location,
    patient.phone,
    date_registered,
    doctor.doctortitle,
    patient.patientid,
    prescribtion.prescid,
    doctor.doctorid,
    doctor.doctortitle,
    patient.amount,
    xray.xrayid,
    CONVERT(date, patient.dob) AS dob,
    CASE 
        WHEN prescribtion.status = 0 THEN 'waiting'
        WHEN prescribtion.status = 1 THEN 'processed'
        WHEN prescribtion.status = 2 THEN 'pending-xray'
        WHEN prescribtion.status = 3 THEN 'xray-processed'
        WHEN prescribtion.status = 4 THEN 'pending-lab'
        WHEN prescribtion.status = 5 THEN 'lab-processed'
    END AS status,
    CASE 
        WHEN prescribtion.xray_status = 0 THEN 'waiting'
        WHEN prescribtion.xray_status = 1 THEN 'pending_image'
        WHEN prescribtion.xray_status = 2 THEN 'image_processed'
    END AS status_xray,
    ISNULL(prescribtion.transaction_status, 'pending') AS transaction_status
FROM 
    patient
INNER JOIN 
    prescribtion ON patient.patientid = prescribtion.patientid
INNER JOIN 
    doctor ON prescribtion.doctorid = doctor.doctorid
LEFT JOIN 
    xray ON prescribtion.prescid = xray.prescid
WHERE 
    doctor.doctorid = @search
    AND (patient.patient_type = 'outpatient' OR patient.patient_type IS NULL)
    AND ISNULL(prescribtion.transaction_status, 'pending') <> 'completed'
ORDER BY 
    patient.date_registered DESC;
 ", con);
                cmd.Parameters.AddWithValue("@search", search);
                cmd.Parameters.AddWithValue("@doctorId", doctorId);


                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        ptclass field = new ptclass();


                        field.full_name = dr["full_name"].ToString();
                        field.sex = dr["sex"].ToString();
                        field.location = dr["location"].ToString();
                        field.phone = dr["phone"].ToString();
                        field.date_registered = dr["date_registered"].ToString();
                        
                        field.doctortitle = dr["doctortitle"].ToString();
                        field.doctorid = dr["doctorid"].ToString();
                        field.patientid = dr["patientid"].ToString();
                        field.doctortitle = dr["doctortitle"].ToString();
                        field.prescid = dr["prescid"].ToString();
                        field.amount = dr["amount"].ToString();
                        field.dob = Convert.ToDateTime(dr["dob"]).ToString("yyyy-MM-dd");
                        field.status = dr["status"].ToString();
                        field.xray_status = dr["status_xray"].ToString();
                        field.xrayid = dr["xrayid"].ToString();
                        field.transaction_status = dr["transaction_status"].ToString();
                        
                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }






        public class xrimg
        {
            public string image;
            public string type;
            
        }

        [WebMethod]
        public static xrimg[] xryimage(string prescid)
        {
            List<xrimg> details = new List<xrimg>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
            SELECT xryimage , type FROM xray_results WHERE prescid = @search;
        ", con);
                cmd.Parameters.AddWithValue("@search", prescid);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        xrimg field = new xrimg();

                        // Retrieve binary data as byte array
                        byte[] imageData = (byte[])dr["xryimage"];

                        // Convert byte array to base64 string
                        field.image = Convert.ToBase64String(imageData);
                        field.type = dr["type"].ToString();
                        details.Add(field);
                    }
                }
            }

            return details.ToArray();
        }

        [WebMethod]
        public static List<ListItem> GetBedChargeRates()
        {
            string query = "SELECT charge_config_id, charge_name, amount FROM charges_config WHERE charge_type = 'Bed' AND is_active = 1";
            string constr = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand(query))
                {
                    List<ListItem> bedCharges = new List<ListItem>();
                    cmd.CommandType = System.Data.CommandType.Text;
                    cmd.Connection = con;
                    con.Open();
                    
                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            string displayText = sdr["charge_name"].ToString() + " - $" + Convert.ToDecimal(sdr["amount"]).ToString("0.00");
                            bedCharges.Add(new ListItem
                            {
                                Value = sdr["charge_config_id"].ToString(),
                                Text = displayText
                            });
                        }
                    }
                    con.Close();
                    return bedCharges;
                }
            }
        }

        [WebMethod]
        public static string UpdatePatientType(string patientId, string prescid, string status, string admissionDate)
        {
            // Debug: Log received parameters
            string debugInfo = $"DEBUG - Received: patientId={patientId}, prescid={prescid}, status={status}, admissionDate={admissionDate}";
            
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    
                    // Always try to get patientId from prescid (in case frontend sent prescid instead)
                    if (!string.IsNullOrEmpty(prescid))
                    {
                        string getPatientQuery = "SELECT patientid FROM prescribtion WHERE prescid = @prescid";
                        using (SqlCommand getCmd = new SqlCommand(getPatientQuery, con))
                        {
                            getCmd.Parameters.AddWithValue("@prescid", prescid);
                            object result = getCmd.ExecuteScalar();
                            if (result != null)
                            {
                                string actualPatientId = result.ToString();
                                if (patientId != actualPatientId)
                                {
                                    debugInfo += $" | Frontend sent: {patientId}, Looked up correct patientId from prescid: {actualPatientId}";
                                    patientId = actualPatientId;
                                }
                            }
                        }
                    }

                    // Get current patient type
                    string currentPatientType = "";
                    string checkQuery = "SELECT patient_type FROM patient WHERE patientid = @id";
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                    {
                        checkCmd.Parameters.AddWithValue("@id", patientId);
                        object result = checkCmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            currentPatientType = result.ToString();
                        }
                    }

                    // Determine new patient type based on status
                    string newPatientType = status == "1" ? "inpatient" : "outpatient";

                    // Update patient status and type
                    string patientUpdateQuery = @"UPDATE [patient] SET 
                                                [patient_status] = @status,
                                                [patient_type] = @patientType,
                                                [bed_admission_date] = @bedAdmissionDate
                                              WHERE [patientid] = @id";

                    using (SqlCommand cmd1 = new SqlCommand(patientUpdateQuery, con))
                    {
                        cmd1.Parameters.AddWithValue("@id", patientId);
                        cmd1.Parameters.AddWithValue("@status", status);
                        cmd1.Parameters.AddWithValue("@patientType", newPatientType);

                        // Set bed admission date if changing to inpatient
                        if (newPatientType == "inpatient" && !string.IsNullOrEmpty(admissionDate))
                        {
                            cmd1.Parameters.AddWithValue("@bedAdmissionDate", DateTime.Parse(admissionDate));
                        }
                        else if (newPatientType == "inpatient" && currentPatientType != "inpatient")
                        {
                            cmd1.Parameters.AddWithValue("@bedAdmissionDate", DateTimeHelper.Now);
                        }
                        else if (newPatientType == "outpatient")
                        {
                            cmd1.Parameters.AddWithValue("@bedAdmissionDate", DBNull.Value);
                        }
                        else
                        {
                            cmd1.Parameters.AddWithValue("@bedAdmissionDate", DBNull.Value);
                        }

                        int rowsAffected = cmd1.ExecuteNonQuery();
                        
                        // Debug: Check if update actually happened
                        if (rowsAffected == 0)
                        {
                            return debugInfo + " | Error: No patient found with ID " + patientId + ". Update affected 0 rows.";
                        }
                    }

                    // If changing from inpatient to outpatient, calculate final bed charges
                    if (currentPatientType == "inpatient" && newPatientType == "outpatient")
                    {
                        int patId = Convert.ToInt32(patientId);
                        int? prescriptionId = string.IsNullOrEmpty(prescid) ? (int?)null : Convert.ToInt32(prescid);
                        BedChargeCalculator.StopBedCharges(patId, prescriptionId);
                    }
                    // If changing to inpatient, start bed charge tracking
                    else if (newPatientType == "inpatient")
                    {
                        int patId = Convert.ToInt32(patientId);
                        int? prescriptionId = string.IsNullOrEmpty(prescid) ? (int?)null : Convert.ToInt32(prescid);
                        BedChargeCalculator.CalculatePatientBedCharges(patId, prescriptionId);
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                return debugInfo + " | Error in UpdatePatientType method: " + ex.Message + " | Stack: " + ex.StackTrace + " | Inner: " + (ex.InnerException?.Message ?? "none");
            }
        }

        [WebMethod]
        public static PatientTypeInfo GetPatientType(string patientId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            PatientTypeInfo info = new PatientTypeInfo();

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = "SELECT patient_type, bed_admission_date FROM patient WHERE patientid = @id";
                    
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@id", patientId);
                        
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                info.patient_type = reader["patient_type"] != DBNull.Value ? reader["patient_type"].ToString() : "outpatient";
                                
                                if (reader["bed_admission_date"] != DBNull.Value)
                                {
                                    DateTime admissionDate = Convert.ToDateTime(reader["bed_admission_date"]);
                                    info.bed_admission_date = admissionDate.ToString("yyyy-MM-ddTHH:mm");
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                info.patient_type = "error: " + ex.Message;
            }

            return info;
        }

        public class PatientTypeInfo
        {
            public string patient_type { get; set; }
            public string bed_admission_date { get; set; }
        }

        [WebMethod]
        public static string UpdateTransactionStatus(string prescid, string transactionStatus)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    
                    string query;
                    
                    // If marking as completed, set completed_date
                    // If marking as pending, clear completed_date
                    if (transactionStatus == "completed")
                    {
                        query = "UPDATE prescribtion SET transaction_status = @transactionStatus, completed_date = @completedDate WHERE prescid = @prescid";
                    }
                    else
                    {
                        query = "UPDATE prescribtion SET transaction_status = @transactionStatus, completed_date = NULL WHERE prescid = @prescid";
                    }
                    
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (transactionStatus == "completed")
                        {
                            cmd.Parameters.AddWithValue("@completedDate", DateTimeHelper.Now);
                        }
                        cmd.Parameters.AddWithValue("@prescid", prescid);
                        cmd.Parameters.AddWithValue("@transactionStatus", transactionStatus);
                        
                        int rowsAffected = cmd.ExecuteNonQuery();
                        
                        if (rowsAffected > 0)
                        {
                            return "success";
                        }
                        else
                        {
                            return "error: No prescription found with ID " + prescid;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "error: " + ex.Message;
            }
        }

        /// <summary>
        /// Get all lab orders for a prescription
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

                    // Get all lab test orders with their charge status
                    SqlCommand cmdOrders = new SqlCommand(@"
                        SELECT 
                            lt.med_id,
                            ISNULL(lt.is_reorder, 0) as is_reorder,
                            lt.reorder_reason,
                            lt.date_taken,
                            CASE WHEN MIN(CAST(ISNULL(pc.is_paid, 0) AS INT)) = 1 THEN 1 ELSE 0 END as charge_paid,
                            ISNULL(SUM(pc.amount), 0) as charge_amount
                        FROM lab_test lt
                        LEFT JOIN patient_charges pc ON pc.reference_id = lt.med_id AND pc.charge_type = 'Lab'
                        WHERE lt.prescid = @prescid
                        GROUP BY lt.med_id, lt.is_reorder, lt.reorder_reason, lt.date_taken
                        ORDER BY lt.date_taken DESC
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
                                IsPaid = isPaid,
                                ChargeAmount = chargeAmount,
                                ChargeStatus = isPaid ? "Paid" : "Unpaid"
                            };

                            orders.Add(order);
                        }
                    }

                    // For each order, get the ordered tests
                    foreach (var order in orders)
                    {
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
                                    Troponin_I, CK_MB, aPTT, INR, D_Dimer, Vitamin_D, Vitamin_B12, 
                                    Ferritin, VDRL, Dengue_Fever_IgG_IgM, Gonorrhea_Ag, AFP, Total_PSA, AMH,
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
                                    Troponin_I, CK_MB, aPTT, INR, D_Dimer, Vitamin_D, Vitamin_B12,
                                    Ferritin, VDRL, Dengue_Fever_IgG_IgM, Gonorrhea_Ag, AFP, Total_PSA, AMH,
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
                    }
                }

                return orders.ToArray();
            }
            catch (Exception ex)
            {
                throw new Exception("GetLabOrders Error: " + ex.Message);
            }
        }

        public class LabOrder
        {
            public string OrderId { get; set; }
            public string OrderDate { get; set; }
            public bool IsReorder { get; set; }
            public string Notes { get; set; }
            public List<string> OrderedTests { get; set; }
            public bool IsPaid { get; set; }
            public decimal ChargeAmount { get; set; }
            public string ChargeStatus { get; set; }
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
                            int remainingOrders = Convert.ToInt32(cmd.ExecuteScalar());
                            
                            // If no lab orders remain, set status back to pending
                            if (remainingOrders == 0)
                            {
                                string updateStatusQuery = @"
                                    UPDATE prescribtion 
                                    SET status = CASE 
                                        WHEN status = 4 THEN 0  -- pending-lab becomes waiting
                                        WHEN status = 5 THEN 0  -- lab-processed becomes waiting  
                                        ELSE status 
                                    END
                                    WHERE prescid = @prescid";
                                
                                using (SqlCommand updateCmd = new SqlCommand(updateStatusQuery, con))
                                {
                                    updateCmd.Parameters.AddWithValue("@prescid", prescriptionId);
                                    updateCmd.ExecuteNonQuery();
                                }
                            }
                        }
                    }

                    return new
                    {
                        success = true,
                        message = "Lab order deleted successfully"
                    };
                }
            }
            catch (Exception ex)
            {
                return new
                {
                    success = false,
                    message = "Error deleting lab order: " + ex.Message
                };
            }
        }

        private static string FormatTestName(string columnName)
        {
            // Convert column names to readable format - same as lab_orders_print.aspx.cs
            return columnName
                .Replace("_", " ")
                .Replace("  ", " - ");
        }

        /// <summary>
        /// Get lab results for a specific lab order
        /// </summary>
        [WebMethod]
        public static labresukt[] GetLabResults(string orderId)
        {
            List<labresukt> results = new List<labresukt>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(@"
                        SELECT TestName, TestValue
                        FROM (
                            SELECT 
                                [Biochemistry], [Lipid_profile], [Low_density_lipoprotein_LDL], [High_density_lipoprotein_HDL],
                                [Total_cholesterol], [Triglycerides], [Liver_function_test], [SGPT_ALT], [SGOT_AST],
                                [Alkaline_phosphates_ALP], [Total_bilirubin], [Direct_bilirubin], [Albumin], [JGlobulin],
                                [Renal_profile], [Urea], [Creatinine], [Uric_acid], [Electrolytes], [Sodium], [Potassium],
                                [Chloride], [Calcium], [Phosphorous], [Magnesium], [Pancreases], [Amylase], [Hematology],
                                [Hemoglobin], [Malaria], [ESR], [Blood_grouping], [Blood_sugar], [CBC], [Cross_matching],
                                [Immunology_Virology], [TPHA], [Human_immune_deficiency_HIV], [Hepatitis_B_virus_HBV],
                                [Hepatitis_C_virus_HCV], [Brucella_melitensis], [Brucella_abortus], [C_reactive_protein_CRP],
                                [Rheumatoid_factor_RF], [Antistreptolysin_O_ASO], [Toxoplasmosis], [Typhoid_hCG],
                                [Hpylori_antibody], [Parasitology], [Stool_occult_blood], [General_stool_examination],
                                [Hormones], [Thyroid_profile], [Triiodothyronine_T3], [Thyroxine_T4], [Thyroid_stimulating_hormone_TSH],
                                [Fertility_profile], [Progesterone_Female], [Follicle_stimulating_hormone_FSH], [Estradiol],
                                [Luteinizing_hormone_LH], [Testosterone_Male], [Prolactin], [Seminal_Fluid_Analysis_Male_B_HCG],
                                [Clinical_path], [Urine_examination], [Stool_examination], [Sperm_examination],
                                [Virginal_swab_trichomonas_virginals], [Human_chorionic_gonadotropin_hCG], [Hpylori_Ag_stool],
                                [Diabetes], [Fasting_blood_sugar], [Hemoglobin_A1c], [General_urine_examination],
                                [Troponin_I], [CK_MB], [aPTT], [INR], [D_Dimer], [Vitamin_D], [Vitamin_B12],
                                [Ferritin], [VDRL], [Dengue_Fever_IgG_IgM], [Gonorrhea_Ag], [AFP], [Total_PSA], [AMH],
                                [Electrolyte_Test], [CRP_Titer], [Ultra], [Typhoid_IgG], [Typhoid_Ag]
                            FROM lab_results
                            WHERE lab_test_id = @orderId
                        ) src
                        UNPIVOT (
                            TestValue FOR TestName IN (
                                [Biochemistry], [Lipid_profile], [Low_density_lipoprotein_LDL], [High_density_lipoprotein_HDL],
                                [Total_cholesterol], [Triglycerides], [Liver_function_test], [SGPT_ALT], [SGOT_AST],
                                [Alkaline_phosphates_ALP], [Total_bilirubin], [Direct_bilirubin], [Albumin], [JGlobulin],
                                [Renal_profile], [Urea], [Creatinine], [Uric_acid], [Electrolytes], [Sodium], [Potassium],
                                [Chloride], [Calcium], [Phosphorous], [Magnesium], [Pancreases], [Amylase], [Hematology],
                                [Hemoglobin], [Malaria], [ESR], [Blood_grouping], [Blood_sugar], [CBC], [Cross_matching],
                                [Immunology_Virology], [TPHA], [Human_immune_deficiency_HIV], [Hepatitis_B_virus_HBV],
                                [Hepatitis_C_virus_HCV], [Brucella_melitensis], [Brucella_abortus], [C_reactive_protein_CRP],
                                [Rheumatoid_factor_RF], [Antistreptolysin_O_ASO], [Toxoplasmosis], [Typhoid_hCG],
                                [Hpylori_antibody], [Parasitology], [Stool_occult_blood], [General_stool_examination],
                                [Hormones], [Thyroid_profile], [Triiodothyronine_T3], [Thyroxine_T4], [Thyroid_stimulating_hormone_TSH],
                                [Fertility_profile], [Progesterone_Female], [Follicle_stimulating_hormone_FSH], [Estradiol],
                                [Luteinizing_hormone_LH], [Testosterone_Male], [Prolactin], [Seminal_Fluid_Analysis_Male_B_HCG],
                                [Clinical_path], [Urine_examination], [Stool_examination], [Sperm_examination],
                                [Virginal_swab_trichomonas_virginals], [Human_chorionic_gonadotropin_hCG], [Hpylori_Ag_stool],
                                [Diabetes], [Fasting_blood_sugar], [Hemoglobin_A1c], [General_urine_examination],
                                [Troponin_I], [CK_MB], [aPTT], [INR], [D_Dimer], [Vitamin_D], [Vitamin_B12],
                                [Ferritin], [VDRL], [Dengue_Fever_IgG_IgM], [Gonorrhea_Ag], [AFP], [Total_PSA], [AMH],
                                [Electrolyte_Test], [CRP_Titer], [Ultra], [Typhoid_IgG], [Typhoid_Ag]
                            )
                        ) unpvt
                        WHERE TestValue IS NOT NULL AND TestValue != '' AND TestValue != '0'
                        ORDER BY TestName
                    ", con);

                    cmd.Parameters.AddWithValue("@orderId", orderId);

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            labresukt result = new labresukt();
                            result.TestName = dr["TestName"].ToString();
                            result.TestValue = dr["TestValue"].ToString();
                            results.Add(result);
                        }
                    }
                }

                return results.ToArray();
            }
            catch (Exception ex)
            {
                throw new Exception("GetLabResults Error: " + ex.Message);
            }
        }

        #region Patient History Methods

        /// <summary>
        /// Get all history records for a patient
        /// </summary>
        [WebMethod]
        public static PatientHistory[] GetPatientHistory(string patientId, string prescid)
        {
            List<PatientHistory> histories = new List<PatientHistory>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = @"
                        SELECT 
                            history_id,
                            patientid,
                            prescid,
                            history_text,
                            created_by,
                            created_date,
                            last_updated,
                            updated_by
                        FROM patient_history
                        WHERE patientid = @patientId
                        ORDER BY created_date DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                PatientHistory history = new PatientHistory
                                {
                                    HistoryId = dr["history_id"].ToString(),
                                    PatientId = dr["patientid"].ToString(),
                                    PrescId = dr["prescid"] != DBNull.Value ? dr["prescid"].ToString() : "",
                                    HistoryText = dr["history_text"].ToString(),
                                    CreatedBy = dr["created_by"] != DBNull.Value ? dr["created_by"].ToString() : "",
                                    CreatedDate = dr["created_date"] != DBNull.Value ? Convert.ToDateTime(dr["created_date"]).ToString("yyyy-MM-dd HH:mm") : "",
                                    LastUpdated = dr["last_updated"] != DBNull.Value ? Convert.ToDateTime(dr["last_updated"]).ToString("yyyy-MM-dd HH:mm") : "",
                                    UpdatedBy = dr["updated_by"] != DBNull.Value ? dr["updated_by"].ToString() : ""
                                };
                                histories.Add(history);
                            }
                        }
                    }
                }

                return histories.ToArray();
            }
            catch (Exception ex)
            {
                throw new Exception("GetPatientHistory Error: " + ex.Message);
            }
        }

        /// <summary>
        /// Save new patient history record
        /// </summary>
        [WebMethod]
        public static string SavePatientHistory(string patientId, string prescid, string historyText, string createdBy)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = @"
                        INSERT INTO patient_history 
                        (patientid, prescid, history_text, created_by, created_date)
                        VALUES 
                        (@patientId, @prescid, @historyText, @createdBy, @createdDate)";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        cmd.Parameters.AddWithValue("@prescid", string.IsNullOrEmpty(prescid) ? (object)DBNull.Value : prescid);
                        cmd.Parameters.AddWithValue("@historyText", historyText);
                        cmd.Parameters.AddWithValue("@createdBy", string.IsNullOrEmpty(createdBy) ? (object)DBNull.Value : createdBy);
                        cmd.Parameters.AddWithValue("@createdDate", DateTimeHelper.Now);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            return "success";
                        }
                        else
                        {
                            return "error: Failed to save history record";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "error: " + ex.Message;
            }
        }

        /// <summary>
        /// Update existing patient history record
        /// </summary>
        [WebMethod]
        public static string UpdatePatientHistory(string historyId, string historyText, string updatedBy)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = @"
                        UPDATE patient_history 
                        SET 
                            history_text = @historyText,
                            last_updated = @lastUpdated,
                            updated_by = @updatedBy
                        WHERE history_id = @historyId";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@historyId", historyId);
                        cmd.Parameters.AddWithValue("@historyText", historyText);
                        cmd.Parameters.AddWithValue("@lastUpdated", DateTimeHelper.Now);
                        cmd.Parameters.AddWithValue("@updatedBy", string.IsNullOrEmpty(updatedBy) ? (object)DBNull.Value : updatedBy);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            return "success";
                        }
                        else
                        {
                            return "error: History record not found";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "error: " + ex.Message;
            }
        }

        /// <summary>
        /// Delete patient history record
        /// </summary>
        [WebMethod]
        public static string DeletePatientHistory(string historyId)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = "DELETE FROM patient_history WHERE history_id = @historyId";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@historyId", historyId);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            return "success";
                        }
                        else
                        {
                            return "error: History record not found";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "error: " + ex.Message;
            }
        }

        public class PatientHistory
        {
            public string HistoryId { get; set; }
            public string PatientId { get; set; }
            public string PrescId { get; set; }
            public string HistoryText { get; set; }
            public string CreatedBy { get; set; }
            public string CreatedDate { get; set; }
            public string LastUpdated { get; set; }
            public string UpdatedBy { get; set; }
        }

        #endregion
    }
}