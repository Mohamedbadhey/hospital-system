using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

namespace juba_hospital
{
    /// <summary>
    /// Helper class for managing hospital settings and print headers
    /// </summary>
    public class HospitalSettingsHelper
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

        /// <summary>
        /// Get hospital settings from database
        /// </summary>
        public static HospitalSettings GetHospitalSettings()
        {
            HospitalSettings settings = GetDefaultSettings();

            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string query = "SELECT TOP 1 * FROM hospital_settings ORDER BY id DESC";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        con.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                settings.Id = Convert.ToInt32(reader["id"]);
                                settings.HospitalName = reader["hospital_name"].ToString();
                                settings.HospitalAddress = reader["hospital_address"].ToString();
                                settings.HospitalPhone = reader["hospital_phone"].ToString();
                                settings.HospitalEmail = reader["hospital_email"].ToString();
                                settings.HospitalWebsite = reader["hospital_website"].ToString();
                                settings.SidebarLogoPath = reader["sidebar_logo_path"].ToString();
                                settings.PrintHeaderLogoPath = reader["print_header_logo_path"].ToString();
                                settings.PrintHeaderText = reader["print_header_text"].ToString();
                                settings.CreatedDate = reader["created_date"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(reader["created_date"]);
                                settings.UpdatedDate = reader["updated_date"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(reader["updated_date"]);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log error and return default settings
                System.Diagnostics.Debug.WriteLine("Error getting hospital settings: " + ex.Message);
                settings = GetDefaultSettings();
            }

            return settings;
        }

        /// <summary>
        /// Get default hospital settings
        /// </summary>
        private static HospitalSettings GetDefaultSettings()
        {
            return new HospitalSettings
            {
                Id = 0,
                HospitalName = "Jubba Hospital",
                HospitalAddress = "Kismayo, Somalia",
                HospitalPhone = "+252-XXX-XXXX",
                HospitalEmail = "info@jubbahospital.com",
                HospitalWebsite = "www.jubbahospital.com",
                SidebarLogoPath = "assets/img/j.png",
                PrintHeaderLogoPath = "assets/img/j.png",
                PrintHeaderText = "Quality Healthcare Services",
                CreatedDate = DateTime.UtcNow,
                UpdatedDate = DateTime.UtcNow
            };
        }

        /// <summary>
        /// Save or update hospital settings
        /// </summary>
        public static bool SaveHospitalSettings(HospitalSettings settings)
        {
            try
            {
                using (SqlConnection con = new SqlConnection(ConnectionString))
                {
                    string query = @"
                        IF EXISTS (SELECT 1 FROM hospital_settings WHERE id = @Id)
                        BEGIN
                            UPDATE hospital_settings 
                            SET hospital_name = @HospitalName,
                                hospital_address = @HospitalAddress,
                                hospital_phone = @HospitalPhone,
                                hospital_email = @HospitalEmail,
                                hospital_website = @HospitalWebsite,
                                sidebar_logo_path = @SidebarLogoPath,
                                print_header_logo_path = @PrintHeaderLogoPath,
                                print_header_text = @PrintHeaderText,
                                updated_date = GETDATE()
                            WHERE id = @Id
                        END
                        ELSE
                        BEGIN
                            INSERT INTO hospital_settings 
                            (hospital_name, hospital_address, hospital_phone, hospital_email, 
                             hospital_website, sidebar_logo_path, print_header_logo_path, 
                             print_header_text, created_date, updated_date)
                            VALUES 
                            (@HospitalName, @HospitalAddress, @HospitalPhone, @HospitalEmail,
                             @HospitalWebsite, @SidebarLogoPath, @PrintHeaderLogoPath,
                             @PrintHeaderText, GETDATE(), GETDATE())
                        END";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@Id", settings.Id > 0 ? settings.Id : (object)DBNull.Value);
                        cmd.Parameters.AddWithValue("@HospitalName", settings.HospitalName ?? "");
                        cmd.Parameters.AddWithValue("@HospitalAddress", settings.HospitalAddress ?? "");
                        cmd.Parameters.AddWithValue("@HospitalPhone", settings.HospitalPhone ?? "");
                        cmd.Parameters.AddWithValue("@HospitalEmail", settings.HospitalEmail ?? "");
                        cmd.Parameters.AddWithValue("@HospitalWebsite", settings.HospitalWebsite ?? "");
                        cmd.Parameters.AddWithValue("@SidebarLogoPath", settings.SidebarLogoPath ?? "");
                        cmd.Parameters.AddWithValue("@PrintHeaderLogoPath", settings.PrintHeaderLogoPath ?? "");
                        cmd.Parameters.AddWithValue("@PrintHeaderText", settings.PrintHeaderText ?? "");

                        con.Open();
                        cmd.ExecuteNonQuery();
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error saving hospital settings: " + ex.Message);
                return false;
            }
        }

        /// <summary>
        /// Get print header HTML
        /// </summary>
        public static string GetPrintHeaderHTML()
        {
            HospitalSettings settings = GetHospitalSettings();

            string logoPath = string.IsNullOrWhiteSpace(settings.PrintHeaderLogoPath)
                ? "assets/vafmadow.png"
                : settings.PrintHeaderLogoPath;

            string logoUrl = VirtualPathUtility.ToAbsolute("~/" + logoPath.TrimStart('~', '/'));
            string hospitalName = string.IsNullOrWhiteSpace(settings.HospitalName) ? "Jubba Hospital" : settings.HospitalName;
            string hospitalAddress = string.IsNullOrWhiteSpace(settings.HospitalAddress) ? "Kismayo, Somalia" : settings.HospitalAddress;
            string hospitalPhone = string.IsNullOrWhiteSpace(settings.HospitalPhone) ? "+252-XXX-XXXX" : settings.HospitalPhone;
            string hospitalEmail = string.IsNullOrWhiteSpace(settings.HospitalEmail) ? "info@jubbahospital.com" : settings.HospitalEmail;
            string hospitalWebsite = settings.HospitalWebsite ?? string.Empty;
            string tagline = settings.PrintHeaderText ?? string.Empty;

            string html = $@"
                <div class='print-header'>
                    <div class='print-header-container'>
                        <div class='print-logo'>
                           <img src='{logoUrl}' alt='Hospital Logo' />
                        </div>
                        <div class='print-info'>
                            <h1>{hospitalName}</h1>
                            <p>{hospitalAddress}</p>
                            <p>Phone: {hospitalPhone} | Email: {hospitalEmail}</p>
                            {(!string.IsNullOrEmpty(hospitalWebsite) ? $"<p>Website: {hospitalWebsite}</p>" : "")}
                            {(!string.IsNullOrEmpty(tagline) ? $"<p class='tagline'>{tagline}</p>" : "")}
                        </div>
                    </div>
                </div>";

            return html;
        }

        /// <summary>
        /// Get sidebar logo path
        /// </summary>
        public static string GetSidebarLogoPath()
        {
            HospitalSettings settings = GetHospitalSettings();
            return !string.IsNullOrEmpty(settings.SidebarLogoPath)
                ? settings.SidebarLogoPath
                : "assets/img/j.png";
        }

        /// <summary>
        /// Get absolute URL for the print header logo to use in watermark and headers
        /// Falls back to assets/vafmadow.png if not configured
        /// </summary>
        public static string GetPrintLogoUrl()
        {
            try
            {
                HospitalSettings settings = GetHospitalSettings();
                string path = !string.IsNullOrEmpty(settings.PrintHeaderLogoPath)
                    ? settings.PrintHeaderLogoPath
                    : "assets/vafmadow.png";
                string url = VirtualPathUtility.ToAbsolute("~/" + path.TrimStart('~', '/'));
                return url;
            }
            catch
            {
                return VirtualPathUtility.ToAbsolute("~/assets/vafmadow.png");
            }
        }

        /// <summary>
        /// Get favicon URL from hospital settings (uses sidebar logo)
        /// Falls back to favicon.ico if not configured
        /// </summary>
        public static string GetFaviconUrl()
        {
            try
            {
                HospitalSettings settings = GetHospitalSettings();
                string path = !string.IsNullOrEmpty(settings.SidebarLogoPath)
                    ? settings.SidebarLogoPath
                    : "favicon.ico";
                string url = VirtualPathUtility.ToAbsolute("~/" + path.TrimStart('~', '/'));
                return url;
            }
            catch
            {
                return VirtualPathUtility.ToAbsolute("~/favicon.ico");
            }
        }
    }

    /// <summary>
    /// Hospital settings model
    /// </summary>
    public class HospitalSettings
    {
        public int Id { get; set; }
        public string HospitalName { get; set; }
        public string HospitalAddress { get; set; }
        public string HospitalPhone { get; set; }
        public string HospitalEmail { get; set; }
        public string HospitalWebsite { get; set; }
        public string SidebarLogoPath { get; set; }
        public string PrintHeaderLogoPath { get; set; }
        public string PrintHeaderText { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime UpdatedDate { get; set; }
    }
}
