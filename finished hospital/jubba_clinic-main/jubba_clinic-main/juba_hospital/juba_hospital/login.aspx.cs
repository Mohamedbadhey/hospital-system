using System;
using System.Data.SqlClient;
using System.Web.Configuration;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class login : System.Web.UI.Page
    {
        protected System.Web.UI.WebControls.Image HospitalLogo;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            // Add dynamic favicon
            AddFavicon();
            
            if (!IsPostBack)
            {
                LoadHospitalLogo();
                PopulateDropDownList();
            }
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

        private void LoadHospitalLogo()
        {
            try
            {
                var settings = HospitalSettingsHelper.GetHospitalSettings();
                
                // Load logo
                if (!string.IsNullOrEmpty(settings.SidebarLogoPath))
                {
                    HospitalLogo.ImageUrl = ResolveUrl("~/" + settings.SidebarLogoPath.TrimStart('~', '/'));
                }
                else
                {
                    HospitalLogo.ImageUrl = ResolveUrl("~/assets/vafmadow.png");
                }
                HospitalLogo.AlternateText = "VIA-AFMADOW Hospital Logo";
            }
            catch (Exception ex)
            {
                // Fallback to default logo
                HospitalLogo.ImageUrl = ResolveUrl("~/assets/vafmadow.png");
                HospitalLogo.AlternateText = "VIA-AFMADOW Hospital Logo";
            }
        }

        private void PopulateDropDownList()
        {
            string connectionString = WebConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            string query = "select usertypeid, usertype from usertype"; // Adjust the query to match your table and columns

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                using (SqlCommand command = new SqlCommand(query, connection))
                {
                    connection.Open();
                    SqlDataReader reader = command.ExecuteReader();

                    DropDownList1.DataSource = reader;
                    DropDownList1.DataValueField = "usertypeid"; // The value that will be stored
                    DropDownList1.DataTextField = "usertype"; // The text that will be displayed
                    DropDownList1.DataBind();
                }
            }

            // Optional: Add a default item
            DropDownList1.Items.Insert(0, new ListItem("Select a User", "0"));
        }

        protected void lognbtn_Click(object sender, EventArgs e)
        {
            LabelMessage.Text = string.Empty;
            Label1.Text = string.Empty;

            string username = TextBoxUsername.Text.Trim();
            string password = TextBoxPassword.Text;

            if (!int.TryParse(DropDownList1.SelectedValue, out int roleId) || roleId == 0)
            {
                LabelMessage.Text = "Please select a user type.";
                return;
            }

            string connectionString = WebConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                try
                {
                    con.Open();
                    string query = string.Empty;
                    string redirectUrl = string.Empty;

                    switch (roleId)
                    {
                        case 8: // Doctor
                            query = @"
                                SELECT username AS UserId, username AS DisplayName, doctorid AS PrimaryId
                                FROM doctor 
                                WHERE username = @username AND password = @password";
                            redirectUrl = "assignmed.aspx";
                            break;
                        case 10: // Lab
                            query = @"
                                SELECT username AS UserId, username AS DisplayName, userid AS PrimaryId
                                FROM lab_user 
                                WHERE username = @username AND password = @password";
                            redirectUrl = "lab_waiting_list.aspx";
                            break;
                        case 9: // Register
                            query = @"
                                SELECT username AS UserId, username AS DisplayName, userid AS PrimaryId
                                FROM registre 
                                WHERE username = @username AND password = @password";
                            redirectUrl = "Add_patients.aspx";
                            break;
                        case 7: // Admin
                            query = @"
                                SELECT username AS UserId, username AS DisplayName, userid AS PrimaryId
                                FROM admin 
                                WHERE username = @username AND password = @password";
                            redirectUrl = "admin_dashbourd.aspx";
                            break;
                        case 15: // Xray
                            query = @"
                                SELECT username AS UserId, username AS DisplayName, userid AS PrimaryId
                                FROM xrayuser 
                                WHERE username = @username AND password = @password";
                            redirectUrl = "take_xray.aspx";
                            break;
                        case 11: // Pharmacy
                            query = @"
                                SELECT username AS UserId, username AS DisplayName, userid AS PrimaryId
                                FROM pharmacy_user 
                                WHERE username = @username AND password = @password";
                            redirectUrl = "pharmacy_dashboard.aspx";
                            break;
                        default:
                            LabelMessage.Text = "Invalid role selected.";
                            return;
                    }

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@username", username);
                        cmd.Parameters.AddWithValue("@password", password);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                string userId = dr["UserId"].ToString();
                                string displayName = dr["DisplayName"].ToString();
                                string primaryId = dr["PrimaryId"].ToString();

                                Session["UserId"] = userId;
                                Session["UserName"] = displayName;
                                Session["id"] = primaryId;
                                Session["role_id"] = roleId;

                                if (roleId == 7)
                                {
                                    Session["admin_id"] = primaryId;
                                    Session["admin_name"] = displayName;
                                }

                                Response.Redirect(redirectUrl);
                            }
                            else
                            {
                                LabelMessage.Text = "Invalid username or password.";
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    Label1.Text = "An error occurred: " + ex.Message;
                }
            }
        }
        }
}