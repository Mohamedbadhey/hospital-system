using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;

namespace juba_hospital
{
    public class Global : HttpApplication
    {
        private static Timer bedChargeTimer;

        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            // Start automatic bed charge calculation
            StartBedChargeCalculation();
        }

        private void StartBedChargeCalculation()
        {
            // Calculate immediately on startup
            CalculateBedChargesForAllInpatients(null);

            // Calculate how long until next midnight (using hospital timezone)
            DateTime now = DateTimeHelper.Now;
            DateTime nextMidnight = now.Date.AddDays(1);
            TimeSpan timeUntilMidnight = nextMidnight - now;

            // Set timer to run at midnight, then every 24 hours
            bedChargeTimer = new Timer(
                CalculateBedChargesForAllInpatients,
                null,
                timeUntilMidnight,
                TimeSpan.FromHours(24)
            );

            System.Diagnostics.Debug.WriteLine($"Bed charge calculation scheduled. Next run at: {nextMidnight} (Hospital Time: {DateTimeHelper.GetTimezoneName()})");
        }

        private void CalculateBedChargesForAllInpatients(object state)
        {
            try
            {
                System.Diagnostics.Debug.WriteLine($"Starting automatic bed charge calculation at {DateTimeHelper.Now} (Hospital Timezone)");

                string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
                List<Tuple<int, int?>> inpatients = new List<Tuple<int, int?>>();

                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    // Get all active inpatients
                    string query = @"
                        SELECT DISTINCT p.patientid, pr.prescid 
                        FROM patient p
                        LEFT JOIN prescribtion pr ON p.patientid = pr.patientid
                        WHERE p.patient_type = 'inpatient' 
                        AND p.bed_admission_date IS NOT NULL
                        AND p.patient_status = 1";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                int patientId = dr.GetInt32(0);
                                int? prescId = dr.IsDBNull(1) ? (int?)null : dr.GetInt32(1);
                                inpatients.Add(new Tuple<int, int?>(patientId, prescId));
                            }
                        }
                    }
                }

                System.Diagnostics.Debug.WriteLine($"Found {inpatients.Count} active inpatients");

                // Calculate charges for each inpatient
                int successCount = 0;
                foreach (var inpatient in inpatients)
                {
                    try
                    {
                        BedChargeCalculator.CalculatePatientBedCharges(inpatient.Item1, inpatient.Item2);
                        successCount++;
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine($"Error calculating charges for patient {inpatient.Item1}: {ex.Message}");
                    }
                }

                System.Diagnostics.Debug.WriteLine($"Bed charge calculation completed. Processed {successCount} of {inpatients.Count} patients successfully");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"Error in automatic bed charge calculation: {ex.Message}");
            }
        }

        void Application_End(object sender, EventArgs e)
        {
            // Clean up timer
            if (bedChargeTimer != null)
            {
                bedChargeTimer.Dispose();
            }
        }
    }
}