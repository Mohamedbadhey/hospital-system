using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace juba_hospital
{
    /// <summary>
    /// Utility class for calculating and managing bed charges for inpatients
    /// </summary>
    public class BedChargeCalculator
    {
        private static string ConnectionString
        {
            get { return ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString; }
        }

        /// <summary>
        /// Calculate bed charges for a specific patient from admission date to current date
        /// </summary>
        /// <param name="patientId">Patient ID</param>
        /// <param name="prescId">Prescription ID (optional)</param>
        /// <returns>Total bed charges accumulated</returns>
        public static decimal CalculatePatientBedCharges(int patientId, int? prescId = null)
        {
            decimal totalCharges = 0;

            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();

                    // Get patient details and bed admission date
                    string patientQuery = @"SELECT patient_type, bed_admission_date 
                                          FROM patient 
                                          WHERE patientid = @patientId AND patient_type = 'inpatient'";

                    DateTime? admissionDate = null;

                    using (SqlCommand cmd = new SqlCommand(patientQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read() && !reader.IsDBNull(1))
                            {
                                admissionDate = reader.GetDateTime(1);
                            }
                        }
                    }

                    if (!admissionDate.HasValue)
                    {
                        return 0; // Patient is not an inpatient or no admission date
                    }

                    // Get the bed charge rate
                    decimal bedChargeRate = GetBedChargeRate();

                    if (bedChargeRate <= 0)
                    {
                        return 0; // No bed charge configured
                    }

                    // Calculate number of days - matches doctor_inpatient.aspx.cs calculation
                    // DATEDIFF(DAY, admission_date, GETDATE()) + 1 for charging
                    // We add 1 because DATEDIFF returns 0 on admission day, but we need to charge for that day
                    int numberOfDays = (DateTimeHelper.Now.Date - admissionDate.Value.Date).Days + 1;
                    if (numberOfDays < 1) numberOfDays = 1; // Minimum 1 day charge

                    totalCharges = numberOfDays * bedChargeRate;

                    // Check how many days have already been charged
                    string chargedDaysQuery = @"SELECT COUNT(DISTINCT charge_date) 
                                               FROM patient_bed_charges 
                                               WHERE patientid = @patientId";

                    int chargedDays = 0;
                    using (SqlCommand cmd = new SqlCommand(chargedDaysQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            chargedDays = Convert.ToInt32(result);
                        }
                    }

                    // Calculate only uncharged days
                    int daysToCharge = numberOfDays - chargedDays;
                    if (daysToCharge > 0)
                    {
                        // Add new bed charges for uncharged days
                        for (int i = 0; i < daysToCharge; i++)
                        {
                            DateTime chargeDate = admissionDate.Value.AddDays(chargedDays + i);
                            AddBedChargeRecord(patientId, prescId, chargeDate, bedChargeRate);
                        }
                    }

                    // Return total accumulated charges
                    return numberOfDays * bedChargeRate;
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error calculating bed charges: " + ex.Message);
                throw;
            }
        }

        /// <summary>
        /// Get the current active bed charge rate from configuration
        /// </summary>
        /// <returns>Bed charge rate per night</returns>
        public static decimal GetBedChargeRate()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();
                    string query = @"SELECT TOP 1 amount 
                                   FROM charges_config 
                                   WHERE charge_type = 'Bed' AND is_active = 1 
                                   ORDER BY charge_config_id DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            return Convert.ToDecimal(result);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error getting bed charge rate: " + ex.Message);
            }

            return 0;
        }

        /// <summary>
        /// Add a bed charge record for a specific date
        /// </summary>
        private static void AddBedChargeRecord(int patientId, int? prescId, DateTime chargeDate, decimal amount)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();

                    // Check if charge already exists for this date
                    string checkQuery = @"SELECT COUNT(*) FROM patient_bed_charges 
                                        WHERE patientid = @patientId AND charge_date = @chargeDate";

                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, con))
                    {
                        checkCmd.Parameters.AddWithValue("@patientId", patientId);
                        checkCmd.Parameters.AddWithValue("@chargeDate", chargeDate.Date);

                        int count = Convert.ToInt32(checkCmd.ExecuteScalar());
                        if (count > 0)
                        {
                            return; // Already charged for this date
                        }
                    }

                    // Insert new bed charge
                    string insertQuery = @"INSERT INTO patient_bed_charges 
                                         (patientid, prescid, charge_date, bed_charge_amount, is_paid, created_at)
                                         VALUES (@patientId, @prescId, @chargeDate, @amount, 0, @created_at)";

                    using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        cmd.Parameters.AddWithValue("@prescId", prescId.HasValue ? (object)prescId.Value : DBNull.Value);
                        cmd.Parameters.AddWithValue("@chargeDate", chargeDate.Date);
                        cmd.Parameters.AddWithValue("@amount", amount);
                        cmd.Parameters.AddWithValue("@created_at", DateTimeHelper.Now);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error adding bed charge record: " + ex.Message);
                throw;
            }
        }

        /// <summary>
        /// Stop bed charges for a patient (when they become outpatient)
        /// </summary>
        /// <param name="patientId">Patient ID</param>
        /// <returns>Total bed charges accumulated</returns>
        public static decimal StopBedCharges(int patientId, int? prescId = null)
        {
            try
            {
                // Calculate all charges up to now
                decimal totalCharges = CalculatePatientBedCharges(patientId, prescId);

                // Update patient type to outpatient
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();
                    string updateQuery = @"UPDATE patient 
                                         SET patient_type = 'outpatient', 
                                             bed_admission_date = NULL 
                                         WHERE patientid = @patientId";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        cmd.ExecuteNonQuery();
                    }
                }

                return totalCharges;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error stopping bed charges: " + ex.Message);
                throw;
            }
        }

        /// <summary>
        /// Get total bed charges for a patient
        /// </summary>
        /// <param name="patientId">Patient ID</param>
        /// <returns>Total bed charges</returns>
        public static decimal GetTotalBedCharges(int patientId)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();
                    string query = @"SELECT ISNULL(SUM(bed_charge_amount), 0) 
                                   FROM patient_bed_charges 
                                   WHERE patientid = @patientId";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@patientId", patientId);
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            return Convert.ToDecimal(result);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error getting total bed charges: " + ex.Message);
            }

            return 0;
        }

        /// <summary>
        /// Calculate daily bed charges for all active inpatients
        /// This method can be called by a scheduled task
        /// </summary>
        public static void CalculateDailyBedCharges()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    con.Open();

                    // Get all active inpatients
                    string query = @"SELECT p.patientid, pr.prescid 
                                   FROM patient p
                                   LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
                                   WHERE p.patient_type = 'inpatient' 
                                   AND p.bed_admission_date IS NOT NULL";

                    DataTable inpatients = new DataTable();
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataAdapter adapter = new SqlDataAdapter(cmd))
                        {
                            adapter.Fill(inpatients);
                        }
                    }

                    // Calculate charges for each inpatient
                    foreach (DataRow row in inpatients.Rows)
                    {
                        int patientId = Convert.ToInt32(row["patientid"]);
                        int? prescId = row["prescid"] != DBNull.Value ? (int?)Convert.ToInt32(row["prescid"]) : null;

                        CalculatePatientBedCharges(patientId, prescId);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error calculating daily bed charges: " + ex.Message);
                throw;
            }
        }
    }
}
