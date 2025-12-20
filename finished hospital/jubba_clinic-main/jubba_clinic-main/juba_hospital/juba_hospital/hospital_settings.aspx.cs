using System;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class hospital_settings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSettings();
            }
        }

        /// <summary>
        /// Load current hospital settings
        /// </summary>
        private void LoadSettings()
        {
            try
            {
                HospitalSettings settings = HospitalSettingsHelper.GetHospitalSettings();

                // Populate form fields
                txtHospitalName.Text = settings.HospitalName;
                txtHospitalAddress.Text = settings.HospitalAddress;
                txtHospitalPhone.Text = settings.HospitalPhone;
                txtHospitalEmail.Text = settings.HospitalEmail;
                txtHospitalWebsite.Text = settings.HospitalWebsite;
                txtPrintHeaderText.Text = settings.PrintHeaderText;

                // Display current logos
                if (!string.IsNullOrEmpty(settings.SidebarLogoPath))
                {
                    imgCurrentSidebarLogo.ImageUrl = ResolveUrl("~/" + settings.SidebarLogoPath);
                }

                if (!string.IsNullOrEmpty(settings.PrintHeaderLogoPath))
                {
                    imgCurrentPrintLogo.ImageUrl = ResolveUrl("~/" + settings.PrintHeaderLogoPath);
                }

                // Store settings ID in ViewState
                ViewState["SettingsId"] = settings.Id;
            }
            catch (Exception ex)
            {
                ShowError("Error loading settings: " + ex.Message);
            }
        }

        /// <summary>
        /// Save button click handler
        /// </summary>
        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                // Get current settings or create new
                HospitalSettings settings = HospitalSettingsHelper.GetHospitalSettings();
                
                // Update settings from form
                settings.HospitalName = txtHospitalName.Text.Trim();
                settings.HospitalAddress = txtHospitalAddress.Text.Trim();
                settings.HospitalPhone = txtHospitalPhone.Text.Trim();
                settings.HospitalEmail = txtHospitalEmail.Text.Trim();
                settings.HospitalWebsite = txtHospitalWebsite.Text.Trim();
                settings.PrintHeaderText = txtPrintHeaderText.Text.Trim();

                // Handle sidebar logo upload
                if (fuSidebarLogo.HasFile)
                {
                    string sidebarLogoPath = UploadLogo(fuSidebarLogo, "sidebar");
                    if (!string.IsNullOrEmpty(sidebarLogoPath))
                    {
                        settings.SidebarLogoPath = sidebarLogoPath;
                    }
                }

                // Handle print header logo upload
                if (fuPrintLogo.HasFile)
                {
                    string printLogoPath = UploadLogo(fuPrintLogo, "print");
                    if (!string.IsNullOrEmpty(printLogoPath))
                    {
                        settings.PrintHeaderLogoPath = printLogoPath;
                    }
                }

                // Save to database
                bool success = HospitalSettingsHelper.SaveHospitalSettings(settings);

                if (success)
                {
                    ShowSuccess("Settings saved successfully!");
                    LoadSettings(); // Reload to show updated data
                }
                else
                {
                    ShowError("Failed to save settings. Please try again.");
                }
            }
            catch (Exception ex)
            {
                ShowError("Error saving settings: " + ex.Message);
            }
        }

        /// <summary>
        /// Upload logo file
        /// </summary>
        private string UploadLogo(FileUpload fileUpload, string prefix)
        {
            try
            {
                // Validate file
                if (!fileUpload.HasFile)
                    return null;

                // Check file size (2MB max)
                if (fileUpload.PostedFile.ContentLength > 2 * 1024 * 1024)
                {
                    ShowError($"{prefix} logo file size must be less than 2MB");
                    return null;
                }

                // Check file extension
                string extension = Path.GetExtension(fileUpload.FileName).ToLower();
                string[] allowedExtensions = { ".png", ".jpg", ".jpeg", ".svg" };
                
                if (Array.IndexOf(allowedExtensions, extension) == -1)
                {
                    ShowError($"{prefix} logo must be PNG, JPG, JPEG, or SVG format");
                    return null;
                }

                // Create upload directory if it doesn't exist
                string uploadDir = Server.MapPath("~/assets/img/hospital/");
                if (!Directory.Exists(uploadDir))
                {
                    Directory.CreateDirectory(uploadDir);
                }

                // Generate unique filename
                string fileName = $"{prefix}-logo-{DateTimeHelper.Now:yyyyMMddHHmmss}{extension}";
                string filePath = Path.Combine(uploadDir, fileName);

                // Save file
                fileUpload.SaveAs(filePath);

                // Return relative path
                return $"assets/img/hospital/{fileName}";
            }
            catch (Exception ex)
            {
                ShowError($"Error uploading {prefix} logo: " + ex.Message);
                return null;
            }
        }

        /// <summary>
        /// Show success message
        /// </summary>
        private void ShowSuccess(string message)
        {
            SuccessPanel.Visible = true;
            ErrorPanel.Visible = false;
            SuccessMessage.Text = message;
        }

        /// <summary>
        /// Show error message
        /// </summary>
        private void ShowError(string message)
        {
            ErrorPanel.Visible = true;
            SuccessPanel.Visible = false;
            ErrorMessage.Text = message;
        }
    }
}
