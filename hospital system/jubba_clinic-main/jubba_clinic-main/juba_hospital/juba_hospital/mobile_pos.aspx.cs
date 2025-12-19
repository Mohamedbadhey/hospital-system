using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace juba_hospital
{
    public partial class mobile_pos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in
            if (Session["pharmacy_userid"] == null && Session["admin_userid"] == null)
            {
                Response.Redirect("pharmacy_login.aspx");
            }
        }
    }
}