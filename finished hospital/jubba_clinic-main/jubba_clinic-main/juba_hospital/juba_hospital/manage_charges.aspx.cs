using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace juba_hospital
{
    public partial class manage_charges : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static ChargeConfig[] GetCharges()
        {
            List<ChargeConfig> charges = new List<ChargeConfig>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT charge_config_id, charge_type, charge_name, amount, is_active, date_added
                    FROM charges_config
                    ORDER BY charge_type, date_added
                ", con);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        ChargeConfig charge = new ChargeConfig();
                        charge.charge_config_id = dr["charge_config_id"].ToString();
                        charge.charge_type = dr["charge_type"].ToString();
                        charge.charge_name = dr["charge_name"].ToString();
                        charge.amount = dr["amount"].ToString();
                        charge.is_active = dr["is_active"].ToString() == "True" ? "1" : "0";
                        charge.date_added = Convert.ToDateTime(dr["date_added"]).ToString("yyyy-MM-dd");
                        charges.Add(charge);
                    }
                }
            }

            return charges.ToArray();
        }

        [WebMethod]
        public static string SaveCharge(string id, string charge_type, string charge_name, string amount, string is_active)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    if (string.IsNullOrEmpty(id) || id == "0")
                    {
                        // Insert new charge
                        string insertQuery = @"INSERT INTO charges_config (charge_type, charge_name, amount, is_active) 
                                             VALUES (@charge_type, @charge_name, @amount, @is_active)";
                        using (SqlCommand cmd = new SqlCommand(insertQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@charge_type", charge_type);
                            cmd.Parameters.AddWithValue("@charge_name", charge_name);
                            cmd.Parameters.AddWithValue("@amount", Convert.ToDouble(amount));
                            cmd.Parameters.AddWithValue("@is_active", is_active == "1" ? true : false);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        // Update existing charge
                        string updateQuery = @"UPDATE charges_config 
                                             SET charge_type = @charge_type,
                                                 charge_name = @charge_name,
                                                 amount = @amount,
                                                 is_active = @is_active,
                                                 last_updated = @last_updated
                                             WHERE charge_config_id = @id";
                        using (SqlCommand cmd = new SqlCommand(updateQuery, con))
                        {
                            cmd.Parameters.AddWithValue("@id", id);
                            cmd.Parameters.AddWithValue("@charge_type", charge_type);
                            cmd.Parameters.AddWithValue("@charge_name", charge_name);
                            cmd.Parameters.AddWithValue("@amount", Convert.ToDouble(amount));
                            cmd.Parameters.AddWithValue("@is_active", is_active == "1" ? true : false);
                            cmd.Parameters.AddWithValue("@last_updated", DateTimeHelper.Now);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        [WebMethod]
        public static string DeleteCharge(string id)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string deleteQuery = "DELETE FROM charges_config WHERE charge_config_id = @id";
                    using (SqlCommand cmd = new SqlCommand(deleteQuery, con))
                    {
                        cmd.Parameters.AddWithValue("@id", id);
                        cmd.ExecuteNonQuery();
                    }
                }

                return "true";
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        public class ChargeConfig
        {
            public string charge_config_id;
            public string charge_type;
            public string charge_name;
            public string amount;
            public string is_active;
            public string date_added;
        }
    }
}

