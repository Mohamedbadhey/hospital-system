using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class manage_lab_test_prices : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check if user is logged in as admin
            if (Session["admin_id"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        [WebMethod]
        public static TestPrice[] GetTestPrices()
        {
            List<TestPrice> prices = new List<TestPrice>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                string query = @"
                    SELECT 
                        test_price_id,
                        test_name,
                        test_display_name,
                        test_category,
                        test_price,
                        is_active,
                        date_added,
                        last_updated
                    FROM lab_test_prices
                    ORDER BY test_category, test_display_name";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            TestPrice price = new TestPrice
                            {
                                test_price_id = Convert.ToInt32(dr["test_price_id"]),
                                test_name = dr["test_name"].ToString(),
                                test_display_name = dr["test_display_name"].ToString(),
                                test_category = dr["test_category"].ToString(),
                                test_price = Convert.ToDecimal(dr["test_price"]),
                                is_active = Convert.ToBoolean(dr["is_active"]),
                                date_added = Convert.ToDateTime(dr["date_added"]).ToString("yyyy-MM-dd"),
                                last_updated = Convert.ToDateTime(dr["last_updated"]).ToString("yyyy-MM-dd")
                            };
                            prices.Add(price);
                        }
                    }
                }
            }

            return prices.ToArray();
        }

        [WebMethod]
        public static string UpdateTestPrice(int testPriceId, decimal newPrice)
        {
            try
            {
                string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = @"
                        UPDATE lab_test_prices 
                        SET test_price = @price,
                            last_updated = GETDATE()
                        WHERE test_price_id = @id";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@price", newPrice);
                        cmd.Parameters.AddWithValue("@id", testPriceId);

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            return "success";
                        }
                        else
                        {
                            return "No rows updated";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        public class TestPrice
        {
            public int test_price_id { get; set; }
            public string test_name { get; set; }
            public string test_display_name { get; set; }
            public string test_category { get; set; }
            public decimal test_price { get; set; }
            public bool is_active { get; set; }
            public string date_added { get; set; }
            public string last_updated { get; set; }
        }
    }
}
