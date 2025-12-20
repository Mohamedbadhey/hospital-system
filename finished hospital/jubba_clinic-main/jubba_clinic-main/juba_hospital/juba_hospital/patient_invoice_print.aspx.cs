using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace juba_hospital
{
    public partial class patient_invoice_print : Page
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Add dynamic favicon
            AddFavicon();
            
            if (IsPostBack)
            {
                return;
            }

            PrintHeaderLiteral.Text = HospitalSettingsHelper.GetPrintHeaderHTML();
            InvoiceGeneratedLiteral.Text = DateTimeHelper.Now.ToString("dd MMM yyyy HH:mm");

            string patientIdValue = Request.QueryString["patientid"];
            if (!int.TryParse(patientIdValue, out int patientId))
            {
                ShowInvoiceError("Invalid or missing patient id. Please open the invoice from a valid patient record.");
                return;
            }

            string invoiceNumber = Request.QueryString["invoice"];
            string chargeType = Request.QueryString["type"]; // Get charge type filter

            try
            {
                using (var connection = new SqlConnection(ConnectionString))
                {
                    connection.Open();

                    PatientRecord patient = LoadPatient(connection, patientId);
                    if (patient == null)
                    {
                        ShowInvoiceError("Patient not found. Please confirm the patient still exists in the system.");
                        return;
                    }

                    BindPatient(patient);

                    List<ChargeRecord> charges = LoadCharges(connection, patientId, invoiceNumber, chargeType);
                    BindCharges(charges);
                }

                InvoicePanel.Visible = true;
                InvoiceErrorPanel.Visible = false;
            }
            catch (Exception ex)
            {
                ShowInvoiceError("Unable to load invoice summary. Details: " + ex.Message);
            }
        }

        private static PatientRecord LoadPatient(SqlConnection connection, int patientId)
        {
            const string query = @"
                SELECT TOP 1 patientid, full_name, phone, location, date_registered
                FROM patient
                WHERE patientid = @patientid";

            using (var cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@patientid", patientId);
                using (var reader = cmd.ExecuteReader())
                {
                    if (!reader.Read())
                    {
                        return null;
                    }

                    return new PatientRecord
                    {
                        PatientId = reader["patientid"].ToString(),
                        FullName = reader["full_name"].ToString(),
                        Phone = reader["phone"].ToString(),
                        Location = reader["location"].ToString(),
                        DateRegistered = reader["date_registered"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["date_registered"])
                    };
                }
            }
        }

        private static List<ChargeRecord> LoadCharges(SqlConnection connection, int patientId, string invoiceNumber, string chargeType)
        {
            string query;
            
            if (chargeType == "Bed")
            {
                // Only bed charges
                query = @"
                    SELECT 
                        'Bed' as charge_type, 
                        'Daily Bed Charge' as charge_name, 
                        bed_charge_amount as amount, 
                        is_paid, 
                        CAST(charge_date AS datetime) as paid_date, 
                        'BED-' + CAST(patientid AS VARCHAR) + '-' + CAST(bed_charge_id AS VARCHAR) as invoice_number, 
                        created_at as date_added
                    FROM patient_bed_charges
                    WHERE patientid = @patientid
                    ORDER BY charge_date DESC";
            }
            else if (string.IsNullOrWhiteSpace(chargeType) || chargeType == "all" || chargeType == "All")
            {
                // All charges - combine both tables
                query = @"
                    SELECT charge_type, charge_name, amount, is_paid, paid_date, invoice_number, date_added
                    FROM patient_charges
                    WHERE patientid = @patientid
                      AND (@invoiceNumber IS NULL OR invoice_number = @invoiceNumber)
                    
                    UNION ALL
                    
                    SELECT 
                        'Bed' as charge_type, 
                        'Daily Bed Charge' as charge_name, 
                        bed_charge_amount as amount, 
                        is_paid, 
                        CAST(charge_date AS datetime) as paid_date, 
                        'BED-' + CAST(patientid AS VARCHAR) + '-' + CAST(bed_charge_id AS VARCHAR) as invoice_number, 
                        created_at as date_added
                    FROM patient_bed_charges
                    WHERE patientid = @patientid
                    
                    ORDER BY date_added DESC";
            }
            else
            {
                // Specific charge type from patient_charges
                query = @"
                    SELECT charge_type, charge_name, amount, is_paid, paid_date, invoice_number, date_added
                    FROM patient_charges
                    WHERE patientid = @patientid
                      AND (@invoiceNumber IS NULL OR invoice_number = @invoiceNumber)
                      AND charge_type = @chargeType
                    ORDER BY ISNULL(paid_date, date_added) DESC, charge_id DESC";
            }

            var list = new List<ChargeRecord>();

            using (var cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@patientid", patientId);
                
                if (string.IsNullOrWhiteSpace(invoiceNumber))
                {
                    cmd.Parameters.AddWithValue("@invoiceNumber", DBNull.Value);
                }
                else
                {
                    cmd.Parameters.AddWithValue("@invoiceNumber", invoiceNumber);
                }
                
                if (!string.IsNullOrWhiteSpace(chargeType) && chargeType != "all" && chargeType != "All" && chargeType != "Bed")
                {
                    cmd.Parameters.AddWithValue("@chargeType", chargeType);
                }
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        DateTime? paidDate = reader["paid_date"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["paid_date"]);
                        DateTime recordedOn = paidDate ?? (reader["date_added"] == DBNull.Value
                            ? DateTime.MinValue
                            : Convert.ToDateTime(reader["date_added"]));

                        list.Add(new ChargeRecord
                        {
                            ChargeType = reader["charge_type"].ToString(),
                            ChargeName = reader["charge_name"].ToString(),
                            Amount = reader["amount"] == DBNull.Value ? 0 : Convert.ToDecimal(reader["amount"]),
                            Paid = reader["is_paid"] != DBNull.Value && Convert.ToBoolean(reader["is_paid"]),
                            PaidDate = paidDate,
                            InvoiceNumber = reader["invoice_number"].ToString(),
                            RecordedOn = recordedOn
                        });
                    }
                }
            }

            return list;
        }

        private void BindPatient(PatientRecord patient)
        {
            InvoicePatientLiteral.Text = string.IsNullOrWhiteSpace(patient.FullName) ? "—" : patient.FullName;
            InvoicePatientIdLiteral.Text = patient.PatientId;
            InvoicePhoneLiteral.Text = string.IsNullOrWhiteSpace(patient.Phone) ? "—" : patient.Phone;
            InvoiceLocationLiteral.Text = string.IsNullOrWhiteSpace(patient.Location) ? "—" : patient.Location;
            InvoiceDateRegisteredLiteral.Text = patient.DateRegistered?.ToString("dd MMM yyyy") ?? "—";

            if (int.TryParse(patient.PatientId, out int pid))
            {
                InvoiceVisitCountLiteral.Text = CountVisits(pid);
            }
            else
            {
                InvoiceVisitCountLiteral.Text = "—";
            }
        }

        private string CountVisits(int patientId)
        {
            const string query = "SELECT COUNT(*) FROM prescribtion WHERE patientid = @patientid";
            using (var connection = new SqlConnection(ConnectionString))
            using (var cmd = new SqlCommand(query, connection))
            {
                connection.Open();
                cmd.Parameters.AddWithValue("@patientid", patientId);
                object result = cmd.ExecuteScalar();
                return Convert.ToInt32(result).ToString(CultureInfo.InvariantCulture);
            }
        }

        private void BindCharges(List<ChargeRecord> charges)
        {
            if (charges == null || charges.Count == 0)
            {
                NoChargesPlaceholder.Visible = true;
                ChargesTablePanel.Visible = false;
                SummaryPanel.Visible = false;
                GrandTotalLiteral.Text = FormatCurrency(0);
                return;
            }

            var tableSource = charges.Select(c => new
            {
                RecordedOn = c.RecordedOn == DateTime.MinValue ? "—" : c.RecordedOn.ToString("dd MMM yyyy"),
                Invoice = string.IsNullOrWhiteSpace(c.InvoiceNumber) ? "—" : c.InvoiceNumber,
                Type = string.IsNullOrWhiteSpace(c.ChargeType) ? "—" : c.ChargeType,
                Name = string.IsNullOrWhiteSpace(c.ChargeName) ? "—" : c.ChargeName,
                Status = c.Paid ? "Paid" : "Pending",
                Amount = FormatCurrency(c.Amount)
            }).ToList();

            ChargesRepeater.DataSource = tableSource;
            ChargesRepeater.DataBind();

            NoChargesPlaceholder.Visible = false;
            ChargesTablePanel.Visible = true;

            decimal grandTotal = charges.Sum(c => c.Amount);
            GrandTotalLiteral.Text = FormatCurrency(grandTotal);

            var summaryData = charges
                .GroupBy(c => string.IsNullOrWhiteSpace(c.ChargeType) ? "Uncategorized" : c.ChargeType)
                .Select(g => new
                {
                    Label = $"{g.Key} ({g.Count()} items)",
                    TotalAmount = g.Sum(x => x.Amount)
                })
                .OrderByDescending(s => s.TotalAmount)
                .ToList();

            SummaryRepeater.DataSource = summaryData
                .Select(s => new
                {
                    s.Label,
                    Total = FormatCurrency(s.TotalAmount)
                });
            SummaryRepeater.DataBind();
            SummaryPanel.Visible = true;
        }

        private void ShowInvoiceError(string message)
        {
            InvoicePanel.Visible = false;
            InvoiceErrorPanel.Visible = true;
            InvoiceErrorLiteral.Text = message;
        }

        private static string FormatCurrency(decimal amount)
        {
            return string.Format(CultureInfo.CurrentCulture, "{0:C2}", amount);
        }

        private sealed class PatientRecord
        {
            public string PatientId { get; set; }
            public string FullName { get; set; }
            public string Phone { get; set; }
            public string Location { get; set; }
            public DateTime? DateRegistered { get; set; }
        }

        private sealed class ChargeRecord
        {
            public string ChargeType { get; set; }
            public string ChargeName { get; set; }
            public decimal Amount { get; set; }
            public bool Paid { get; set; }
            public DateTime? PaidDate { get; set; }
            public string InvoiceNumber { get; set; }
            public DateTime RecordedOn { get; set; }
        }
    
        /// <summary>
        /// Add dynamic favicon to page head
        /// </summary>
        private void AddFavicon()
        {
            string faviconUrl = HospitalSettingsHelper.GetFaviconUrl();
            HtmlLink favicon = new HtmlLink();
            favicon.Href = faviconUrl;
            favicon.Attributes["rel"] = "shortcut icon";
            favicon.Attributes["type"] = "image/x-icon";
            Page.Header.Controls.Add(favicon);
        }

        }
}

