using System;
using System.Web.UI;

namespace juba_hospital
{
    public partial class lab_reference_guide : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Authentication is handled by the master page (labtest.Master)
            // No need for additional checks here
            
            if (!IsPostBack)
            {
                // Page initialization if needed
                // All functionality is handled by JavaScript in the ASPX page
            }
        }
    }
}
