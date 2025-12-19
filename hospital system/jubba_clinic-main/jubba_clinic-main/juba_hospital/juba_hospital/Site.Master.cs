using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Add dynamic favicon
            AddFavicon();
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