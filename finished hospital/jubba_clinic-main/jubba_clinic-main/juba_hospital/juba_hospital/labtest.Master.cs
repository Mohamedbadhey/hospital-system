using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection.Emit;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class labtest : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Add dynamic favicon
            AddFavicon();
            
            if (Session["UserId"] == null)
            {
                // Redirect to the login page (assuming the login page URL is "login.aspx")
                Response.Redirect("login.aspx");
            }
            else
            {
                var displayName = Convert.ToString(Session["UserName"]);
                if (string.IsNullOrWhiteSpace(displayName))
                {
                    displayName = Convert.ToString(Session["UserId"]);
                }

                Label1.Text = displayName;
                Label1Display.Text = displayName;
                Label1Mobile.Text = displayName;
                Label1MobileDisplay.Text = displayName;
                if (MobileUserLabel != null)
                {
                    MobileUserLabel.Text = displayName;
                }
            }
        }

        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            // Clear the session
            Session.Clear();
            Session.Abandon();
            // Redirect to login page
            Response.Redirect("login.aspx");
        }

        protected string GetSidebarLogo()
        {
            return HospitalSettingsHelper.GetSidebarLogoPath();
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