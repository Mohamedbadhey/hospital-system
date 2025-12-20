using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class pharmacy : System.Web.UI.MasterPage
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
                // Set the text of Label1 to the value of the UserId session variable
                string username = (string)Session["UserId"];
                Label1.Text = username;
                Label1Display.Text = username;
                Label1Mobile.Text = username;
                Label1MobileDisplay.Text = username;
            }
        }

        /// <summary>
        /// Get sidebar logo path from database settings
        /// </summary>
        protected string GetSidebarLogo()
        {
            return HospitalSettingsHelper.GetSidebarLogoPath();
        }

        protected void LogoutButton_Click(object sender, EventArgs e)
        {
            // Clear the session
            Session.Clear();
            Session.Abandon();
            // Redirect to login page
            Response.Redirect("login.aspx");
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

