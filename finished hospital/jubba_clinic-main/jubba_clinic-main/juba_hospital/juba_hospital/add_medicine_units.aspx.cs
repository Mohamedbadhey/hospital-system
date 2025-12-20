using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Services;
using System.Web.UI;

namespace juba_hospital
{
    public partial class add_medicine_units : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        [WebMethod]
        public static UnitInfo[] getUnits()
        {
            List<UnitInfo> units = new List<UnitInfo>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT unit_id, unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label, is_active, created_date
                    FROM medicine_units
                    ORDER BY unit_name
                ", con);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    UnitInfo unit = new UnitInfo();
                    unit.unit_id = dr["unit_id"].ToString();
                    unit.unit_name = dr["unit_name"].ToString();
                    unit.unit_abbreviation = dr["unit_abbreviation"] == DBNull.Value ? "" : dr["unit_abbreviation"].ToString();
                    unit.selling_method = dr["selling_method"] == DBNull.Value ? "" : dr["selling_method"].ToString();
                    unit.base_unit_name = dr["base_unit_name"] == DBNull.Value ? "" : dr["base_unit_name"].ToString();
                    unit.subdivision_unit = dr["subdivision_unit"] == DBNull.Value ? "" : dr["subdivision_unit"].ToString();
                    unit.allows_subdivision = dr["allows_subdivision"] == DBNull.Value ? "False" : dr["allows_subdivision"].ToString();
                    unit.unit_size_label = dr["unit_size_label"] == DBNull.Value ? "" : dr["unit_size_label"].ToString();
                    unit.is_active = dr["is_active"].ToString();
                    unit.created_date = dr["created_date"].ToString();
                    units.Add(unit);
                }
            }
            return units.ToArray();
        }

        [WebMethod]
        public static UnitInfo[] getUnitById(string id)
        {
            List<UnitInfo> units = new List<UnitInfo>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT unit_id, unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label, is_active, created_date
                    FROM medicine_units
                    WHERE unit_id = @id
                ", con);
                cmd.Parameters.AddWithValue("@id", id);

                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    UnitInfo unit = new UnitInfo();
                    unit.unit_id = dr["unit_id"].ToString();
                    unit.unit_name = dr["unit_name"].ToString();
                    unit.unit_abbreviation = dr["unit_abbreviation"] == DBNull.Value ? "" : dr["unit_abbreviation"].ToString();
                    unit.selling_method = dr["selling_method"] == DBNull.Value ? "" : dr["selling_method"].ToString();
                    unit.base_unit_name = dr["base_unit_name"] == DBNull.Value ? "" : dr["base_unit_name"].ToString();
                    unit.subdivision_unit = dr["subdivision_unit"] == DBNull.Value ? "" : dr["subdivision_unit"].ToString();
                    unit.allows_subdivision = dr["allows_subdivision"] == DBNull.Value ? "False" : dr["allows_subdivision"].ToString();
                    unit.unit_size_label = dr["unit_size_label"] == DBNull.Value ? "" : dr["unit_size_label"].ToString();
                    unit.is_active = dr["is_active"].ToString();
                    unit.created_date = dr["created_date"].ToString();
                    units.Add(unit);
                }
            }
            return units.ToArray();
        }

        [WebMethod]
        public static string addUnit(string unitName, string unitAbbreviation, string sellingMethod, string baseUnitName, string subdivisionUnit, bool allowsSubdivision, string unitSizeLabel, bool isActive)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = @"INSERT INTO medicine_units (unit_name, unit_abbreviation, selling_method, base_unit_name, subdivision_unit, allows_subdivision, unit_size_label, is_active) 
                                   VALUES (@unitName, @unitAbbreviation, @sellingMethod, @baseUnitName, @subdivisionUnit, @allowsSubdivision, @unitSizeLabel, @isActive)";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@unitName", unitName);
                        cmd.Parameters.AddWithValue("@unitAbbreviation", string.IsNullOrEmpty(unitAbbreviation) ? (object)DBNull.Value : unitAbbreviation);
                        cmd.Parameters.AddWithValue("@sellingMethod", string.IsNullOrEmpty(sellingMethod) ? (object)DBNull.Value : sellingMethod);
                        cmd.Parameters.AddWithValue("@baseUnitName", string.IsNullOrEmpty(baseUnitName) ? (object)DBNull.Value : baseUnitName);
                        cmd.Parameters.AddWithValue("@subdivisionUnit", string.IsNullOrEmpty(subdivisionUnit) ? (object)DBNull.Value : subdivisionUnit);
                        cmd.Parameters.AddWithValue("@allowsSubdivision", allowsSubdivision);
                        cmd.Parameters.AddWithValue("@unitSizeLabel", string.IsNullOrEmpty(unitSizeLabel) ? (object)DBNull.Value : unitSizeLabel);
                        cmd.Parameters.AddWithValue("@isActive", isActive);
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

        [WebMethod]
        public static string updateUnit(string id, string unitName, string unitAbbreviation, string sellingMethod, string baseUnitName, string subdivisionUnit, bool allowsSubdivision, string unitSizeLabel, bool isActive)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    string query = @"UPDATE medicine_units 
                                   SET unit_name = @unitName, 
                                       unit_abbreviation = @unitAbbreviation, 
                                       selling_method = @sellingMethod,
                                       base_unit_name = @baseUnitName,
                                       subdivision_unit = @subdivisionUnit,
                                       allows_subdivision = @allowsSubdivision,
                                       unit_size_label = @unitSizeLabel,
                                       is_active = @isActive
                                   WHERE unit_id = @id";
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@id", id);
                        cmd.Parameters.AddWithValue("@unitName", unitName);
                        cmd.Parameters.AddWithValue("@unitAbbreviation", string.IsNullOrEmpty(unitAbbreviation) ? (object)DBNull.Value : unitAbbreviation);
                        cmd.Parameters.AddWithValue("@sellingMethod", string.IsNullOrEmpty(sellingMethod) ? (object)DBNull.Value : sellingMethod);
                        cmd.Parameters.AddWithValue("@baseUnitName", string.IsNullOrEmpty(baseUnitName) ? (object)DBNull.Value : baseUnitName);
                        cmd.Parameters.AddWithValue("@subdivisionUnit", string.IsNullOrEmpty(subdivisionUnit) ? (object)DBNull.Value : subdivisionUnit);
                        cmd.Parameters.AddWithValue("@allowsSubdivision", allowsSubdivision);
                        cmd.Parameters.AddWithValue("@unitSizeLabel", string.IsNullOrEmpty(unitSizeLabel) ? (object)DBNull.Value : unitSizeLabel);
                        cmd.Parameters.AddWithValue("@isActive", isActive);
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

        [WebMethod]
        public static string deleteUnit(string id)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    
                    // Check if unit is being used by any medicine
                    SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM medicine WHERE unit_id = @id", con);
                    checkCmd.Parameters.AddWithValue("@id", id);
                    int count = (int)checkCmd.ExecuteScalar();

                    if (count > 0)
                    {
                        return "Error: Cannot delete unit. It is being used by " + count + " medicine(s).";
                    }

                    // Delete the unit
                    string query = "DELETE FROM medicine_units WHERE unit_id = @id";
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
                return "Error: " + ex.Message;
            }
        }

        public class UnitInfo
        {
            public string unit_id;
            public string unit_name;
            public string unit_abbreviation;
            public string selling_method;
            public string base_unit_name;
            public string subdivision_unit;
            public string allows_subdivision;
            public string unit_size_label;
            public string is_active;
            public string created_date;
        }
    }
}
