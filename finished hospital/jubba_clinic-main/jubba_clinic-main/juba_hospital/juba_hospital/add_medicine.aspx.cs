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
    public partial class add_medicine : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static Unit[] getUnits()
        {
            List<Unit> units = new List<Unit>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand("SELECT unit_id, unit_name FROM medicine_units ORDER BY unit_name", con);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    Unit unit = new Unit();
                    unit.unit_id = dr["unit_id"].ToString();
                    unit.unit_name = dr["unit_name"].ToString();
                    units.Add(unit);
                }
            }
            return units.ToArray();
        }

        [WebMethod]
        public static string deleteMedicine(string id)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = "DELETE FROM [medicine] WHERE [medicineid] = @id";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@id", id);
                        cmd.ExecuteNonQuery();
                    }
                }
                return "true";
            }
            catch (Exception ex)
            {
                throw new Exception("Error deleting medicine", ex);
            }
        }

        [WebMethod]
        public static string updateMedicine(string id, string medname, string generic, string manufacturer, string barcode, string unitId, string tabletsPerStrip, string stripsPerBox, string costPerTablet, string costPerStrip, string costPerBox, string pricePerTablet, string pricePerStrip, string pricePerBox)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = "UPDATE [medicine] SET " +
                          "[medicine_name] = @medname," +
                          "[generic_name] = @generic," +
                          "[manufacturer] = @manufacturer," +
                          "[barcode] = @barcode," +
                          "[unit_id] = @unitId," +
                          "[tablets_per_strip] = @tabletsPerStrip," +
                          "[strips_per_box] = @stripsPerBox," +
                          "[cost_per_tablet] = @costPerTablet," +
                          "[cost_per_strip] = @costPerStrip," +
                          "[cost_per_box] = @costPerBox," +
                          "[price_per_tablet] = @pricePerTablet," +
                          "[price_per_strip] = @pricePerStrip," +
                          "[price_per_box] = @pricePerBox" +
                          " WHERE [medicineid] = @id";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@id", id);
                        cmd.Parameters.AddWithValue("@medname", medname);
                        cmd.Parameters.AddWithValue("@generic", generic);
                        cmd.Parameters.AddWithValue("@manufacturer", manufacturer);
                        cmd.Parameters.AddWithValue("@barcode", string.IsNullOrEmpty(barcode) ? (object)DBNull.Value : barcode);
                        cmd.Parameters.AddWithValue("@unitId", unitId);
                        cmd.Parameters.AddWithValue("@tabletsPerStrip", tabletsPerStrip);
                        cmd.Parameters.AddWithValue("@stripsPerBox", stripsPerBox);
                        cmd.Parameters.AddWithValue("@costPerTablet", string.IsNullOrEmpty(costPerTablet) ? (object)DBNull.Value : costPerTablet);
                        cmd.Parameters.AddWithValue("@costPerStrip", string.IsNullOrEmpty(costPerStrip) ? (object)DBNull.Value : costPerStrip);
                        cmd.Parameters.AddWithValue("@costPerBox", string.IsNullOrEmpty(costPerBox) ? (object)DBNull.Value : costPerBox);
                        cmd.Parameters.AddWithValue("@pricePerTablet", string.IsNullOrEmpty(pricePerTablet) ? (object)DBNull.Value : pricePerTablet);
                        cmd.Parameters.AddWithValue("@pricePerStrip", string.IsNullOrEmpty(pricePerStrip) ? (object)DBNull.Value : pricePerStrip);
                        cmd.Parameters.AddWithValue("@pricePerBox", string.IsNullOrEmpty(pricePerBox) ? (object)DBNull.Value : pricePerBox);

                        cmd.ExecuteNonQuery();
                    }
                }
                return "true";
            }
            catch (Exception ex)
            {
                throw new Exception("Error updating medicine", ex);
            }
        }

        [WebMethod]
        public static med[] datadisplay()
        {
            List<med> details = new List<med>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"  
                    SELECT m.medicineid, m.medicine_name, m.generic_name, m.manufacturer, 
                           u.unit_name, m.unit_id,
                           m.cost_per_strip, m.price_per_tablet, m.price_per_strip, m.price_per_box
                    FROM medicine m
                    LEFT JOIN medicine_units u ON m.unit_id = u.unit_id
                ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    med field = new med();
                    field.medicineid = dr["medicineid"].ToString();
                    field.medicine_name = dr["medicine_name"].ToString();
                    field.generic_name = dr["generic_name"].ToString();
                    field.manufacturer = dr["manufacturer"].ToString();
                    field.unit_name = dr["unit_name"] == DBNull.Value ? "N/A" : dr["unit_name"].ToString();
                    field.unit_id = dr["unit_id"] == DBNull.Value ? "" : dr["unit_id"].ToString();
                    field.cost_per_strip = dr["cost_per_strip"] == DBNull.Value ? "0.00" : dr["cost_per_strip"].ToString();
                    field.price_per_tablet = dr["price_per_tablet"] == DBNull.Value ? "0.00" : dr["price_per_tablet"].ToString();
                    field.price_per_strip = dr["price_per_strip"] == DBNull.Value ? "0.00" : dr["price_per_strip"].ToString();
                    field.price_per_box = dr["price_per_box"] == DBNull.Value ? "0.00" : dr["price_per_box"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }

        [WebMethod]
        public static med[] getMedicineById(string id)
        {
            List<med> details = new List<med>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"  
                    SELECT m.medicineid, m.medicine_name, m.generic_name, m.manufacturer, m.barcode,
                           m.unit_id, u.unit_name,
                           m.tablets_per_strip, m.strips_per_box,
                           m.cost_per_tablet, m.cost_per_strip, m.cost_per_box,
                           m.price_per_tablet, m.price_per_strip, m.price_per_box
                    FROM medicine m
                    LEFT JOIN medicine_units u ON m.unit_id = u.unit_id
                    WHERE m.medicineid = @id
                ", con);
                cmd.Parameters.AddWithValue("@id", id);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    med field = new med();
                    field.medicineid = dr["medicineid"].ToString();
                    field.medicine_name = dr["medicine_name"].ToString();
                    field.generic_name = dr["generic_name"].ToString();
                    field.manufacturer = dr["manufacturer"].ToString();
                    field.barcode = dr["barcode"] == DBNull.Value ? "" : dr["barcode"].ToString();
                    field.unit_id = dr["unit_id"] == DBNull.Value ? "" : dr["unit_id"].ToString();
                    field.unit_name = dr["unit_name"] == DBNull.Value ? "N/A" : dr["unit_name"].ToString();
                    field.tablets_per_strip = dr["tablets_per_strip"] == DBNull.Value ? "1" : dr["tablets_per_strip"].ToString();
                    field.strips_per_box = dr["strips_per_box"] == DBNull.Value ? "10" : dr["strips_per_box"].ToString();
                    field.cost_per_tablet = dr["cost_per_tablet"] == DBNull.Value ? "0.00" : dr["cost_per_tablet"].ToString();
                    field.cost_per_strip = dr["cost_per_strip"] == DBNull.Value ? "0.00" : dr["cost_per_strip"].ToString();
                    field.cost_per_box = dr["cost_per_box"] == DBNull.Value ? "0.00" : dr["cost_per_box"].ToString();
                    field.price_per_tablet = dr["price_per_tablet"] == DBNull.Value ? "0.00" : dr["price_per_tablet"].ToString();
                    field.price_per_strip = dr["price_per_strip"] == DBNull.Value ? "0.00" : dr["price_per_strip"].ToString();
                    field.price_per_box = dr["price_per_box"] == DBNull.Value ? "0.00" : dr["price_per_box"].ToString();
                    details.Add(field);
                }
            }
            return details.ToArray();
        }

        [WebMethod]
        public static string submitdata(string medname, string generic, string manufacturer, string barcode, string unitId, string tabletsPerStrip, string stripsPerBox, string costPerTablet, string costPerStrip, string costPerBox, string pricePerTablet, string pricePerStrip, string pricePerBox)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = "INSERT INTO medicine (medicine_name, generic_name, manufacturer, barcode, unit_id, tablets_per_strip, strips_per_box, cost_per_tablet, cost_per_strip, cost_per_box, price_per_tablet, price_per_strip, price_per_box) VALUES (@medname, @generic, @manufacturer, @barcode, @unitId, @tabletsPerStrip, @stripsPerBox, @costPerTablet, @costPerStrip, @costPerBox, @pricePerTablet, @pricePerStrip, @pricePerBox);";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@medname", medname);
                        cmd.Parameters.AddWithValue("@generic", generic);
                        cmd.Parameters.AddWithValue("@manufacturer", manufacturer);
                        cmd.Parameters.AddWithValue("@barcode", string.IsNullOrEmpty(barcode) ? (object)DBNull.Value : barcode);
                        cmd.Parameters.AddWithValue("@unitId", unitId);
                        cmd.Parameters.AddWithValue("@tabletsPerStrip", tabletsPerStrip);
                        cmd.Parameters.AddWithValue("@stripsPerBox", stripsPerBox);
                        cmd.Parameters.AddWithValue("@costPerTablet", string.IsNullOrEmpty(costPerTablet) ? (object)DBNull.Value : costPerTablet);
                        cmd.Parameters.AddWithValue("@costPerStrip", string.IsNullOrEmpty(costPerStrip) ? (object)DBNull.Value : costPerStrip);
                        cmd.Parameters.AddWithValue("@costPerBox", string.IsNullOrEmpty(costPerBox) ? (object)DBNull.Value : costPerBox);
                        cmd.Parameters.AddWithValue("@pricePerTablet", string.IsNullOrEmpty(pricePerTablet) ? (object)DBNull.Value : pricePerTablet);
                        cmd.Parameters.AddWithValue("@pricePerStrip", string.IsNullOrEmpty(pricePerStrip) ? (object)DBNull.Value : pricePerStrip);
                        cmd.Parameters.AddWithValue("@pricePerBox", string.IsNullOrEmpty(pricePerBox) ? (object)DBNull.Value : pricePerBox);
                        cmd.ExecuteNonQuery();
                    }
                }
                return "true";
            }
            catch (Exception ex)
            {
                return "Error in submitdata method: " + ex.Message;
            }
        }

        [WebMethod]
        public static UnitConfig getUnitDetails(string unitId)
        {
            UnitConfig config = new UnitConfig();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label
                    FROM medicine_units
                    WHERE unit_id = @unitId
                ", con);
                cmd.Parameters.AddWithValue("@unitId", unitId);

                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    config.selling_method = dr["selling_method"] == DBNull.Value ? "" : dr["selling_method"].ToString();
                    config.base_unit_name = dr["base_unit_name"] == DBNull.Value ? "" : dr["base_unit_name"].ToString();
                    config.subdivision_unit = dr["subdivision_unit"] == DBNull.Value ? "" : dr["subdivision_unit"].ToString();
                    config.allows_subdivision = dr["allows_subdivision"] == DBNull.Value ? "False" : dr["allows_subdivision"].ToString();
                    config.unit_size_label = dr["unit_size_label"] == DBNull.Value ? "" : dr["unit_size_label"].ToString();
                }
            }
            return config;
        }

        public class Unit
        {
            public string unit_id;
            public string unit_name;
        }

        public class med
        {
            public string medicineid;
            public string medicine_name;
            public string generic_name;
            public string manufacturer;
            public string barcode;
            public string unit_id;
            public string unit_name;
            public string tablets_per_strip;
            public string strips_per_box;
            public string cost_per_tablet;
            public string cost_per_strip;
            public string cost_per_box;
            public string price_per_tablet;
            public string price_per_strip;
            public string price_per_box;
        }

        public class UnitConfig
        {
            public string selling_method;
            public string base_unit_name;
            public string subdivision_unit;
            public string allows_subdivision;
            public string unit_size_label;
        }
    }
}