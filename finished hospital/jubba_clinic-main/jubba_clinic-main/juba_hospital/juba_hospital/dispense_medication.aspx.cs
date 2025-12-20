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
    public partial class dispense_medication : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static pending_med[] getPendingMedications()
        {
            List<pending_med> list = new List<pending_med>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT m.medid, m.med_name, m.dosage, m.frequency, m.duration, m.date_taken,
                           p.full_name as patient_name
                    FROM medication m
                    INNER JOIN prescribtion pr ON m.prescid = pr.prescid
                    INNER JOIN patient p ON pr.patientid = p.patientid
                    WHERE m.medid NOT IN (SELECT medid FROM medicine_dispensing WHERE status = 1)
                ", con);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    pending_med pm = new pending_med();
                    pm.medid = dr["medid"].ToString();
                    pm.med_name = dr["med_name"].ToString();
                    pm.dosage = dr["dosage"].ToString();
                    pm.frequency = dr["frequency"].ToString();
                    pm.duration = dr["duration"].ToString();
                    pm.date_taken = dr["date_taken"] == DBNull.Value ? "" : Convert.ToDateTime(dr["date_taken"]).ToString("yyyy-MM-dd");
                    pm.patient_name = dr["patient_name"].ToString();
                    list.Add(pm);
                }
            }
            return list.ToArray();
        }

        [WebMethod]
        public static available_med[] getAvailableMedicines()
        {
            List<available_med> list = new List<available_med>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT mi.inventoryid, mi.medicineid, mi.quantity, m.medicine_name
                    FROM medicine_inventory mi
                    INNER JOIN medicine m ON mi.medicineid = m.medicineid
                    WHERE mi.quantity > 0
                ", con);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    available_med am = new available_med();
                    am.inventoryid = dr["inventoryid"].ToString();
                    am.medicineid = dr["medicineid"].ToString();
                    am.quantity = dr["quantity"].ToString();
                    am.medicine_name = dr["medicine_name"].ToString();
                    list.Add(am);
                }
            }
            return list.ToArray();
        }

        [WebMethod]
        public static string dispense(string medid, string inventoryid, string quantity)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            string userId = HttpContext.Current.Session["id"]?.ToString() ?? "0";
            
            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    using (SqlTransaction trans = con.BeginTransaction())
                    {
                        try
                        {
                            // Get medicineid from inventory
                            SqlCommand cmd1 = new SqlCommand("SELECT medicineid FROM medicine_inventory WHERE inventoryid = @inventoryid", con, trans);
                            cmd1.Parameters.AddWithValue("@inventoryid", inventoryid);
                            string medicineid = cmd1.ExecuteScalar()?.ToString();

                            // Insert into medicine_dispensing
                            SqlCommand cmd2 = new SqlCommand(@"
                                INSERT INTO medicine_dispensing (medid, medicineid, quantity_dispensed, dispensed_by, status)
                                VALUES (@medid, @medicineid, @quantity, @userid, 1)
                            ", con, trans);
                            cmd2.Parameters.AddWithValue("@medid", medid);
                            cmd2.Parameters.AddWithValue("@medicineid", medicineid);
                            cmd2.Parameters.AddWithValue("@quantity", quantity);
                            cmd2.Parameters.AddWithValue("@userid", userId);
                            cmd2.ExecuteNonQuery();

                            // Update inventory quantity
                            SqlCommand cmd3 = new SqlCommand(@"
                                UPDATE medicine_inventory 
                                SET quantity = quantity - @quantity
                                WHERE inventoryid = @inventoryid
                            ", con, trans);
                            cmd3.Parameters.AddWithValue("@quantity", quantity);
                            cmd3.Parameters.AddWithValue("@inventoryid", inventoryid);
                            cmd3.ExecuteNonQuery();

                            trans.Commit();
                            return "true";
                        }
                        catch
                        {
                            trans.Rollback();
                            throw;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return "Error: " + ex.Message;
            }
        }

        public class pending_med
        {
            public string medid;
            public string med_name;
            public string dosage;
            public string frequency;
            public string duration;
            public string date_taken;
            public string patient_name;
        }

        public class available_med
        {
            public string inventoryid;
            public string medicineid;
            public string quantity;
            public string medicine_name;
        }
    }
}

