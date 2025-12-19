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
    public partial class medicine_inventory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static med_list[] getMedicines()
        {
            List<med_list> list = new List<med_list>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT medicineid, medicine_name FROM medicine", con);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    med_list m = new med_list();
                    m.medicineid = dr["medicineid"].ToString();
                    m.medicine_name = dr["medicine_name"].ToString();
                    list.Add(m);
                }
            }
            return list.ToArray();
        }

        [WebMethod]
        public static inventory_list[] getInventory()
        {
            List<inventory_list> list = new List<inventory_list>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT mi.inventoryid, mi.medicineid, mi.primary_quantity, mi.secondary_quantity, mi.unit_size,
                           mi.reorder_level_strips, mi.expiry_date, mi.batch_number, mi.purchase_price, m.medicine_name,
                           '' as selling_method, 'Unit' as base_unit_name, 'units' as subdivision_unit
                    FROM medicine_inventory mi
                    INNER JOIN medicine m ON mi.medicineid = m.medicineid
                ", con);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    inventory_list inv = new inventory_list();
                    inv.inventoryid = dr["inventoryid"].ToString();
                    inv.medicineid = dr["medicineid"].ToString();
                    inv.primary_quantity = dr["primary_quantity"] == DBNull.Value ? "0" : dr["primary_quantity"].ToString();
                    inv.secondary_quantity = dr["secondary_quantity"] == DBNull.Value ? "0" : dr["secondary_quantity"].ToString();
                    inv.unit_size = dr["unit_size"] == DBNull.Value ? "1" : dr["unit_size"].ToString();
                    inv.reorder_level_strips = dr["reorder_level_strips"] == DBNull.Value ? "10" : dr["reorder_level_strips"].ToString();
                    inv.expiry_date = dr["expiry_date"] == DBNull.Value ? "" : Convert.ToDateTime(dr["expiry_date"]).ToString("yyyy-MM-dd");
                    inv.batch_number = dr["batch_number"].ToString();
                    inv.purchase_price = dr["purchase_price"] == DBNull.Value ? "0" : dr["purchase_price"].ToString();
                    inv.medicine_name = dr["medicine_name"].ToString();
                    
                    // Unit info for display
                    inv.selling_method = dr["selling_method"] == DBNull.Value ? "" : dr["selling_method"].ToString();
                    inv.base_unit_name = dr["base_unit_name"] == DBNull.Value ? "Unit" : dr["base_unit_name"].ToString();
                    inv.subdivision_unit = dr["subdivision_unit"] == DBNull.Value ? "" : dr["subdivision_unit"].ToString();
                    
                    list.Add(inv);
                }
            }
            return list.ToArray();
        }

        [WebMethod]
        public static inventory_list[] getInventoryById(string id)
        {
            List<inventory_list> list = new List<inventory_list>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT mi.inventoryid, mi.medicineid, mi.primary_quantity, mi.secondary_quantity, mi.unit_size,
                           mi.reorder_level_strips, mi.expiry_date, mi.batch_number, mi.purchase_price, m.medicine_name,
                           '' as selling_method, 'Unit' as base_unit_name, 'units' as subdivision_unit
                    FROM medicine_inventory mi
                    INNER JOIN medicine m ON mi.medicineid = m.medicineid
                    WHERE mi.inventoryid = @id
                ", con);
                cmd.Parameters.AddWithValue("@id", id);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    inventory_list inv = new inventory_list();
                    inv.inventoryid = dr["inventoryid"].ToString();
                    inv.medicineid = dr["medicineid"].ToString();
                    inv.primary_quantity = dr["primary_quantity"] == DBNull.Value ? "0" : dr["primary_quantity"].ToString();
                    inv.secondary_quantity = dr["secondary_quantity"] == DBNull.Value ? "0" : dr["secondary_quantity"].ToString();
                    inv.unit_size = dr["unit_size"] == DBNull.Value ? "1" : dr["unit_size"].ToString();
                    inv.reorder_level_strips = dr["reorder_level_strips"] == DBNull.Value ? "10" : dr["reorder_level_strips"].ToString();
                    inv.expiry_date = dr["expiry_date"] == DBNull.Value ? "" : Convert.ToDateTime(dr["expiry_date"]).ToString("yyyy-MM-dd");
                    inv.batch_number = dr["batch_number"].ToString();
                    inv.purchase_price = dr["purchase_price"] == DBNull.Value ? "0" : dr["purchase_price"].ToString();
                    inv.medicine_name = dr["medicine_name"].ToString();
                    
                    inv.selling_method = dr["selling_method"] == DBNull.Value ? "" : dr["selling_method"].ToString();
                    inv.base_unit_name = dr["base_unit_name"] == DBNull.Value ? "Unit" : dr["base_unit_name"].ToString();
                    inv.subdivision_unit = dr["subdivision_unit"] == DBNull.Value ? "" : dr["subdivision_unit"].ToString();
                    
                    list.Add(inv);
                }
            }
            return list.ToArray();
        }

        [WebMethod]
        public static inventory_list getMedicineUnitDetails(string medicineid)
        {
            inventory_list inv = new inventory_list();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT m.medicineid, m.medicine_name,
                           '' as selling_method, 'Unit' as base_unit_name, 'units' as subdivision_unit
                    FROM medicine m
                    WHERE m.medicineid = @medicineid
                ", con);
                cmd.Parameters.AddWithValue("@medicineid", medicineid);
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    inv.medicineid = dr["medicineid"].ToString();
                    inv.medicine_name = dr["medicine_name"].ToString();
                    inv.selling_method = dr["selling_method"] == DBNull.Value ? "" : dr["selling_method"].ToString();
                    inv.base_unit_name = dr["base_unit_name"] == DBNull.Value ? "Unit" : dr["base_unit_name"].ToString();
                    inv.subdivision_unit = dr["subdivision_unit"] == DBNull.Value ? "" : dr["subdivision_unit"].ToString();
                }
            }
            return inv;
        }

        [WebMethod]
        public static string saveStock(string inventoryid, string medicineid, string primary_quantity, string secondary_quantity, string unit_size, string reorder_level_strips, string expiry_date, string batch_number)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            try
            {
                // Validation: prevent negative quantities
                if (int.TryParse(primary_quantity, out int pq) && pq < 0)
                    return "Error: Primary quantity cannot be negative";
                if (int.TryParse(secondary_quantity, out int sq) && sq < 0)
                    return "Error: Secondary quantity cannot be negative";

                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    if (inventoryid == "0" || string.IsNullOrEmpty(inventoryid))
                    {
                        // Insert
                        SqlCommand cmd = new SqlCommand(@"
                            INSERT INTO medicine_inventory (medicineid, primary_quantity, secondary_quantity, unit_size, reorder_level_strips, expiry_date, batch_number, last_updated)
                            VALUES (@medicineid, @primary_quantity, @secondary_quantity, @unit_size, @reorder_level_strips, @expiry_date, @batch_number, @last_updated)
                        ", con);
                        cmd.Parameters.AddWithValue("@medicineid", medicineid);
                        cmd.Parameters.AddWithValue("@primary_quantity", primary_quantity);
                        cmd.Parameters.AddWithValue("@secondary_quantity", secondary_quantity);
                        cmd.Parameters.AddWithValue("@unit_size", unit_size);
                        cmd.Parameters.AddWithValue("@reorder_level_strips", reorder_level_strips);
                        cmd.Parameters.AddWithValue("@expiry_date", string.IsNullOrEmpty(expiry_date) ? DBNull.Value : (object)expiry_date);
                        cmd.Parameters.AddWithValue("@batch_number", batch_number);
                        cmd.Parameters.AddWithValue("@last_updated", DateTimeHelper.Now);
                        // Purchase price removed - cost is managed in medicine master data
                        cmd.ExecuteNonQuery();
                    }
                    else
                    {
                        // Update
                        SqlCommand cmd = new SqlCommand(@"
                            UPDATE medicine_inventory 
                            SET medicineid = @medicineid, primary_quantity = @primary_quantity, 
                                secondary_quantity = @secondary_quantity, unit_size = @unit_size,
                                reorder_level_strips = @reorder_level_strips, expiry_date = @expiry_date, 
                                batch_number = @batch_number, last_updated = @last_updated
                            WHERE inventoryid = @inventoryid
                        ", con);
                        cmd.Parameters.AddWithValue("@inventoryid", inventoryid);
                        cmd.Parameters.AddWithValue("@medicineid", medicineid);
                        cmd.Parameters.AddWithValue("@primary_quantity", primary_quantity);
                        cmd.Parameters.AddWithValue("@secondary_quantity", secondary_quantity);
                        cmd.Parameters.AddWithValue("@unit_size", unit_size);
                        cmd.Parameters.AddWithValue("@reorder_level_strips", reorder_level_strips);
                        cmd.Parameters.AddWithValue("@expiry_date", string.IsNullOrEmpty(expiry_date) ? DBNull.Value : (object)expiry_date);
                        cmd.Parameters.AddWithValue("@batch_number", batch_number);
                        cmd.Parameters.AddWithValue("@last_updated", DateTimeHelper.Now);
                        // Purchase price removed - cost is managed in medicine master data
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

        public class med_list
        {
            public string medicineid;
            public string medicine_name;
        }

        public class inventory_list
        {
            public string inventoryid;
            public string medicineid;
            public string primary_quantity;
            public string secondary_quantity;
            public string unit_size;
            public string reorder_level_strips;
            public string expiry_date;
            public string batch_number;
            public string purchase_price;
            public string medicine_name;
            public string selling_method;
            public string base_unit_name;
            public string subdivision_unit;
        }
    }
}

