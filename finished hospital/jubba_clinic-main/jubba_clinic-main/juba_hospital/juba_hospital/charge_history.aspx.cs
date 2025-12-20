using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace juba_hospital
{
    public partial class charge_history : Page
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static List<ChargeHistoryRow> GetChargeHistory(string chargeType, string startDate, string endDate)
        {
            var list = new List<ChargeHistoryRow>();
            string filter = string.IsNullOrWhiteSpace(chargeType) || chargeType == "All" ? null : chargeType;
            
            // Parse date parameters
            DateTime? startDateTime = null;
            DateTime? endDateTime = null;
            
            if (!string.IsNullOrEmpty(startDate) && DateTime.TryParse(startDate, out DateTime parsedStart))
            {
                startDateTime = parsedStart;
            }
            
            if (!string.IsNullOrEmpty(endDate) && DateTime.TryParse(endDate, out DateTime parsedEnd))
            {
                endDateTime = parsedEnd.AddHours(23).AddMinutes(59).AddSeconds(59); // End of day
            }

            string query;
            string dateFilter = "";
            
            // Build date filter if dates are provided
            // Filter by date_added (when charge was created)
            if (startDateTime.HasValue && endDateTime.HasValue)
            {
                dateFilter = " AND date_added >= @startDate AND date_added <= @endDate";
            }
            
            if (filter == "Bed")
            {
                // For bed charges, use created_at column for date filtering
                string bedDateFilter = "";
                if (startDateTime.HasValue && endDateTime.HasValue)
                {
                    bedDateFilter = " AND pbc.created_at >= @startDate AND pbc.created_at <= @endDate";
                }
                
                // Only bed charges from patient_bed_charges
                query = @"
                    SELECT 
                        pbc.bed_charge_id as charge_id,
                        pbc.patientid,
                        pbc.prescid,
                        'Bed' as charge_type,
                        'Daily Bed Charge' as charge_name,
                        pbc.bed_charge_amount as amount,
                        NULL as payment_method,
                        'BED-' + CAST(pbc.patientid AS VARCHAR) + '-' + CAST(pbc.bed_charge_id AS VARCHAR) as invoice_number,
                        CAST(pbc.charge_date AS datetime) as paid_date,
                        pbc.is_paid,
                        pbc.created_at as date_added,
                        p.full_name,
                        NULL AS cashier_name
                    FROM patient_bed_charges pbc
                    INNER JOIN patient p ON pbc.patientid = p.patientid
                    WHERE 1=1" + bedDateFilter + @"
                    ORDER BY pbc.charge_date DESC, pbc.bed_charge_id DESC";
            }
            else if (filter == null)
            {
                // All charges - combine both tables
                string bedDateFilterForAll = "";
                if (startDateTime.HasValue && endDateTime.HasValue)
                {
                    bedDateFilterForAll = " AND pbc.created_at >= @startDate AND pbc.created_at <= @endDate";
                }
                
                query = @"
                    SELECT 
                        pc.charge_id,
                        pc.patientid,
                        pc.prescid,
                        pc.charge_type,
                        pc.charge_name,
                        pc.amount,
                        pc.payment_method,
                        pc.invoice_number,
                        pc.paid_date,
                        pc.is_paid,
                        pc.date_added,
                        p.full_name,
                        r.fullname AS cashier_name
                    FROM patient_charges pc
                    INNER JOIN patient p ON pc.patientid = p.patientid
                    LEFT JOIN registre r ON pc.paid_by = r.userid
                    WHERE 1=1" + dateFilter + @"
                    
                    UNION ALL
                    
                    SELECT 
                        pbc.bed_charge_id as charge_id,
                        pbc.patientid,
                        pbc.prescid,
                        'Bed' as charge_type,
                        'Daily Bed Charge' as charge_name,
                        pbc.bed_charge_amount as amount,
                        NULL as payment_method,
                        'BED-' + CAST(pbc.patientid AS VARCHAR) + '-' + CAST(pbc.bed_charge_id AS VARCHAR) as invoice_number,
                        CAST(pbc.charge_date AS datetime) as paid_date,
                        pbc.is_paid,
                        pbc.created_at as date_added,
                        p.full_name,
                        NULL AS cashier_name
                    FROM patient_bed_charges pbc
                    INNER JOIN patient p ON pbc.patientid = p.patientid
                    WHERE 1=1" + bedDateFilterForAll + @"
                    
                    ORDER BY date_added DESC, charge_id DESC";
            }
            else
            {
                // Specific charge type from patient_charges
                query = @"
                    SELECT 
                        pc.charge_id,
                        pc.patientid,
                        pc.prescid,
                        pc.charge_type,
                        pc.charge_name,
                        pc.amount,
                        pc.payment_method,
                        pc.invoice_number,
                        pc.paid_date,
                        pc.is_paid,
                        pc.date_added,
                        p.full_name,
                        r.fullname AS cashier_name
                    FROM patient_charges pc
                    INNER JOIN patient p ON pc.patientid = p.patientid
                    LEFT JOIN registre r ON pc.paid_by = r.userid
                    WHERE pc.charge_type = @chargeType" + dateFilter + @"
                    ORDER BY ISNULL(pc.paid_date, pc.date_added) DESC, pc.charge_id DESC";
            }

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                // Only add parameter if not "Bed" and not "All"
                if (filter != null && filter != "Bed")
                {
                    cmd.Parameters.AddWithValue("@chargeType", filter);
                }
                
                // Add date parameters if provided
                if (startDateTime.HasValue && endDateTime.HasValue)
                {
                    cmd.Parameters.AddWithValue("@startDate", startDateTime.Value);
                    cmd.Parameters.AddWithValue("@endDate", endDateTime.Value);
                }
                
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new ChargeHistoryRow
                        {
                            ChargeId = reader["charge_id"].ToString(),
                            PatientId = reader["patientid"].ToString(),
                            Prescid = reader["prescid"] == DBNull.Value ? string.Empty : reader["prescid"].ToString(),
                            PatientName = reader["full_name"].ToString(),
                            ChargeType = reader["charge_type"].ToString(),
                            Amount = reader["amount"] == DBNull.Value ? "0" : Convert.ToDecimal(reader["amount"]).ToString("0.00"),
                            PaymentMethod = reader["payment_method"] == DBNull.Value ? null : reader["payment_method"].ToString(),
                            InvoiceNumber = reader["invoice_number"] == DBNull.Value ? null : reader["invoice_number"].ToString(),
                            PaidDate = reader["paid_date"] == DBNull.Value ? null : Convert.ToDateTime(reader["paid_date"]).ToString("dd MMM yyyy HH:mm"),
                            IsPaid = reader["is_paid"] != DBNull.Value && Convert.ToBoolean(reader["is_paid"])
                        });
                    }
                }
            }

            return list;
        }

        [WebMethod]
        public static List<ChargeHistoryRow> GetAllChargesByPatient(string patientId, string chargeType)
        {
            var list = new List<ChargeHistoryRow>();
            string filter = string.IsNullOrWhiteSpace(chargeType) || chargeType == "All" ? null : chargeType;

            string query;
            
            if (filter == "Bed")
            {
                // Only bed charges
                query = @"
                    SELECT 
                        pbc.bed_charge_id as charge_id,
                        pbc.patientid,
                        pbc.prescid,
                        'Bed' as charge_type,
                        'Daily Bed Charge' as charge_name,
                        pbc.bed_charge_amount as amount,
                        NULL as payment_method,
                        'BED-' + CAST(pbc.patientid AS VARCHAR) + '-' + CAST(pbc.bed_charge_id AS VARCHAR) as invoice_number,
                        CAST(pbc.charge_date AS datetime) as paid_date,
                        pbc.is_paid,
                        pbc.created_at as date_added,
                        p.full_name,
                        NULL AS cashier_name
                    FROM patient_bed_charges pbc
                    INNER JOIN patient p ON pbc.patientid = p.patientid
                    WHERE pbc.patientid = @patientId AND pbc.is_paid = 1
                    ORDER BY pbc.charge_date DESC";
            }
            else if (filter == null)
            {
                // All charges - combine both tables
                query = @"
                    SELECT 
                        pc.charge_id,
                        pc.patientid,
                        pc.prescid,
                        pc.charge_type,
                        pc.charge_name,
                        pc.amount,
                        pc.payment_method,
                        pc.invoice_number,
                        pc.paid_date,
                        pc.is_paid,
                        pc.date_added,
                        p.full_name,
                        r.fullname AS cashier_name
                    FROM patient_charges pc
                    INNER JOIN patient p ON pc.patientid = p.patientid
                    LEFT JOIN registre r ON pc.paid_by = r.userid
                    WHERE pc.patientid = @patientId AND pc.is_paid = 1
                    
                    UNION ALL
                    
                    SELECT 
                        pbc.bed_charge_id as charge_id,
                        pbc.patientid,
                        pbc.prescid,
                        'Bed' as charge_type,
                        'Daily Bed Charge' as charge_name,
                        pbc.bed_charge_amount as amount,
                        NULL as payment_method,
                        'BED-' + CAST(pbc.patientid AS VARCHAR) + '-' + CAST(pbc.bed_charge_id AS VARCHAR) as invoice_number,
                        CAST(pbc.charge_date AS datetime) as paid_date,
                        pbc.is_paid,
                        pbc.created_at as date_added,
                        p.full_name,
                        NULL AS cashier_name
                    FROM patient_bed_charges pbc
                    INNER JOIN patient p ON pbc.patientid = p.patientid
                    WHERE pbc.patientid = @patientId AND pbc.is_paid = 1
                    
                    ORDER BY paid_date DESC, charge_id DESC";
            }
            else
            {
                // Specific charge type from patient_charges
                query = @"
                    SELECT 
                        pc.charge_id,
                        pc.patientid,
                        pc.prescid,
                        pc.charge_type,
                        pc.charge_name,
                        pc.amount,
                        pc.payment_method,
                        pc.invoice_number,
                        pc.paid_date,
                        pc.is_paid,
                        pc.date_added,
                        p.full_name,
                        r.fullname AS cashier_name
                    FROM patient_charges pc
                    INNER JOIN patient p ON pc.patientid = p.patientid
                    LEFT JOIN registre r ON pc.paid_by = r.userid
                    WHERE pc.patientid = @patientId 
                        AND pc.is_paid = 1
                        AND pc.charge_type = @chargeType
                    ORDER BY pc.paid_date DESC, pc.charge_id DESC";
            }

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@patientId", patientId);
                
                // Only add chargeType parameter if needed
                if (filter != null && filter != "Bed")
                {
                    cmd.Parameters.AddWithValue("@chargeType", filter);
                }
                
                con.Open();

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        list.Add(new ChargeHistoryRow
                        {
                            ChargeId = reader["charge_id"].ToString(),
                            PatientId = reader["patientid"].ToString(),
                            Prescid = reader["prescid"] == DBNull.Value ? string.Empty : reader["prescid"].ToString(),
                            PatientName = reader["full_name"].ToString(),
                            ChargeType = reader["charge_type"].ToString(),
                            ChargeName = reader["charge_name"] == DBNull.Value ? null : reader["charge_name"].ToString(),
                            Amount = reader["amount"] == DBNull.Value ? "0" : Convert.ToDecimal(reader["amount"]).ToString("0.00"),
                            PaymentMethod = reader["payment_method"] == DBNull.Value ? null : reader["payment_method"].ToString(),
                            InvoiceNumber = reader["invoice_number"] == DBNull.Value ? null : reader["invoice_number"].ToString(),
                            PaidDate = reader["paid_date"] == DBNull.Value ? null : Convert.ToDateTime(reader["paid_date"]).ToString("dd MMM yyyy HH:mm"),
                            IsPaid = reader["is_paid"] != DBNull.Value && Convert.ToBoolean(reader["is_paid"]),
                            CashierName = reader["cashier_name"] == DBNull.Value ? null : reader["cashier_name"].ToString()
                        });
                    }
                }
            }

            return list;
        }

        [WebMethod]
        public static string UpdateCharge(string chargeId, string amount, string paymentMethod, string chargeType, string chargeName)
        {
            if (!int.TryParse(chargeId, out int id))
            {
                return "Invalid charge identifier.";
            }

            if (!decimal.TryParse(amount, out decimal parsedAmount) || parsedAmount < 0)
            {
                return "Invalid amount. Please provide a valid number.";
            }

            if (string.IsNullOrWhiteSpace(chargeType))
            {
                return "Charge type is required.";
            }

            const string query = @"
                UPDATE patient_charges
                SET amount = @amount,
                    payment_method = @paymentMethod,
                    charge_type = @chargeType,
                    charge_name = @chargeName,
                    last_updated = @last_updated
                WHERE charge_id = @chargeId";

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@amount", parsedAmount);
                cmd.Parameters.AddWithValue("@paymentMethod", paymentMethod ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@chargeType", chargeType);
                cmd.Parameters.AddWithValue("@last_updated", DateTimeHelper.Now);
                cmd.Parameters.AddWithValue("@chargeName", chargeName ?? (object)DBNull.Value);
                cmd.Parameters.AddWithValue("@chargeId", id);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            return "Charge updated successfully.";
        }

        [WebMethod]
        public static string RevertCharge(string chargeId)
        {
            if (!int.TryParse(chargeId, out int id))
            {
                return "Invalid charge identifier.";
            }

            const string query = @"
                DECLARE @prescid INT, @chargeType NVARCHAR(50);
                SELECT @prescid = prescid, @chargeType = charge_type FROM patient_charges WHERE charge_id = @chargeId;

                UPDATE patient_charges
                SET is_paid = 0,
                    paid_date = NULL,
                    payment_method = NULL,
                    invoice_number = NULL,
                    last_updated = GETDATE()
                WHERE charge_id = @chargeId;

                IF (@chargeType = 'Lab' AND @prescid IS NOT NULL)
                BEGIN
                    UPDATE prescribtion SET lab_charge_paid = 0 WHERE prescid = @prescid;
                END

                IF (@chargeType = 'Xray' AND @prescid IS NOT NULL)
                BEGIN
                    UPDATE prescribtion SET xray_charge_paid = 0 WHERE prescid = @prescid;
                END;";

            using (SqlConnection con = new SqlConnection(ConnectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@chargeId", id);
                con.Open();
                cmd.ExecuteNonQuery();
            }

            return "Charge reverted successfully.";
        }

        public class ChargeHistoryRow
        {
            public string ChargeId { get; set; }
            public string PatientId { get; set; }
            public string Prescid { get; set; }
            public string PatientName { get; set; }
            public string ChargeType { get; set; }
            public string ChargeName { get; set; }
            public string Amount { get; set; }
            public string PaymentMethod { get; set; }
            public string InvoiceNumber { get; set; }
            public string PaidDate { get; set; }
            public bool IsPaid { get; set; }
            public string CashierName { get; set; }
        }
    }
}