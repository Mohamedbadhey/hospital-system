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
    public partial class pharmacy_pos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        public class medicine_info
        {
            public string medicineid;
            public string inventoryid;
            public string medicine_name;
            public string generic_name;
            public string manufacturer;
            public string barcode;
            public string unit_id;
            public string unit_name;
            public string unit_abbreviation;
            public string selling_method;
            public string base_unit_name;
            public string subdivision_unit;
            public string allows_subdivision;
            public string unit_size_label;
            public string price_per_tablet;
            public string price_per_strip;
            public string price_per_box;
            public string cost_per_tablet;
            public string cost_per_strip;
            public string cost_per_box;
            public string tablets_per_strip;
            public string total_strips;
            public string loose_tablets;
            public string primary_quantity;
            public string secondary_quantity;
            public string unit_size;
            public string purchase_price;
        }

        [WebMethod]
        public static medicine_info[] getAvailableMedicines()
        {
            List<medicine_info> list = new List<medicine_info>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT DISTINCT
                        m.medicineid,
                        mi.inventoryid,
                        m.medicine_name,
                        m.generic_name,
                        m.manufacturer,
                        m.barcode,
                        u.unit_id,
                        u.unit_name,
                        u.unit_abbreviation,
                        u.selling_method,
                        u.base_unit_name,
                        u.subdivision_unit,
                        u.allows_subdivision,
                        u.unit_size_label,
                        m.price_per_tablet,
                        m.price_per_strip,
                        m.price_per_box,
                        m.cost_per_tablet,
                        m.cost_per_strip,
                        m.cost_per_box,
                        m.tablets_per_strip,
                        mi.total_strips,
                        mi.loose_tablets,
                        mi.primary_quantity,
                        mi.secondary_quantity,
                        mi.unit_size,
                        mi.purchase_price
                    FROM medicine m
                    INNER JOIN medicine_inventory mi ON m.medicineid = mi.medicineid
                    LEFT JOIN medicine_units u ON m.unit_id = u.unit_id
                    WHERE (mi.primary_quantity > 0 OR mi.secondary_quantity > 0 OR mi.total_strips > 0 OR mi.loose_tablets > 0)
                    AND (mi.expiry_date IS NULL OR mi.expiry_date > GETDATE())
                ", con);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    medicine_info med = new medicine_info();
                    med.medicineid = dr["medicineid"].ToString();
                    med.inventoryid = dr["inventoryid"].ToString();
                    med.medicine_name = dr["medicine_name"].ToString();
                    med.generic_name = dr["generic_name"].ToString();
                    med.manufacturer = dr["manufacturer"].ToString();
                    med.unit_id = dr["unit_id"] == DBNull.Value ? "" : dr["unit_id"].ToString();
                    med.unit_name = dr["unit_name"] == DBNull.Value ? "Unit" : dr["unit_name"].ToString();
                    med.unit_abbreviation = dr["unit_abbreviation"] == DBNull.Value ? "" : dr["unit_abbreviation"].ToString();
                    med.selling_method = dr["selling_method"] == DBNull.Value ? "countable" : dr["selling_method"].ToString();
                    med.base_unit_name = dr["base_unit_name"] == DBNull.Value ? "piece" : dr["base_unit_name"].ToString();
                    med.subdivision_unit = dr["subdivision_unit"] == DBNull.Value ? "" : dr["subdivision_unit"].ToString();
                    med.allows_subdivision = dr["allows_subdivision"] == DBNull.Value ? "False" : dr["allows_subdivision"].ToString();
                    med.unit_size_label = dr["unit_size_label"] == DBNull.Value ? "" : dr["unit_size_label"].ToString();
                    med.price_per_tablet = dr["price_per_tablet"] == DBNull.Value ? "0" : dr["price_per_tablet"].ToString();
                    med.price_per_strip = dr["price_per_strip"] == DBNull.Value ? "0" : dr["price_per_strip"].ToString();
                    med.price_per_box = dr["price_per_box"] == DBNull.Value ? "0" : dr["price_per_box"].ToString();
                    med.cost_per_tablet = dr["cost_per_tablet"] == DBNull.Value ? "0" : dr["cost_per_tablet"].ToString();
                    med.cost_per_strip = dr["cost_per_strip"] == DBNull.Value ? "0" : dr["cost_per_strip"].ToString();
                    med.cost_per_box = dr["cost_per_box"] == DBNull.Value ? "0" : dr["cost_per_box"].ToString();
                    med.tablets_per_strip = dr["tablets_per_strip"] == DBNull.Value ? "10" : dr["tablets_per_strip"].ToString();
                    med.total_strips = dr["total_strips"] == DBNull.Value ? "0" : dr["total_strips"].ToString();
                    med.loose_tablets = dr["loose_tablets"] == DBNull.Value ? "0" : dr["loose_tablets"].ToString();
                    med.primary_quantity = dr["primary_quantity"] == DBNull.Value ? "0" : dr["primary_quantity"].ToString();
                    med.secondary_quantity = dr["secondary_quantity"] == DBNull.Value ? "0" : dr["secondary_quantity"].ToString();
                    med.unit_size = dr["unit_size"] == DBNull.Value ? "1" : dr["unit_size"].ToString();
                    med.purchase_price = dr["purchase_price"] == DBNull.Value ? "0" : dr["purchase_price"].ToString();
                    list.Add(med);
                }
            }
            return list.ToArray();
        }

        [WebMethod]
        public static medicine_info[] searchMedicines(string searchTerm)
        {
            List<medicine_info> list = new List<medicine_info>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                
                // Check if barcode column exists
                bool barcodeExists = false;
                try
                {
                    SqlCommand checkCmd = new SqlCommand("SELECT TOP 1 barcode FROM medicine", con);
                    checkCmd.ExecuteScalar();
                    barcodeExists = true;
                }
                catch
                {
                    barcodeExists = false;
                }

                string query;
                if (barcodeExists)
                {
                    query = @"
                        SELECT DISTINCT
                            m.medicineid,
                            mi.inventoryid,
                            m.medicine_name,
                            m.generic_name,
                            m.manufacturer,
                            m.barcode,
                            u.unit_id,
                            u.unit_name,
                            u.unit_abbreviation,
                            u.selling_method,
                            u.base_unit_name,
                            u.subdivision_unit,
                            u.allows_subdivision,
                            u.unit_size_label,
                            m.price_per_tablet,
                            m.price_per_strip,
                            m.price_per_box,
                            m.cost_per_tablet,
                            m.cost_per_strip,
                            m.cost_per_box,
                            m.tablets_per_strip,
                            m.strips_per_box,
                            mi.total_strips,
                            mi.loose_tablets,
                            mi.primary_quantity,
                            mi.secondary_quantity,
                            mi.unit_size,
                            mi.purchase_price
                        FROM medicine m
                        INNER JOIN medicine_inventory mi ON m.medicineid = mi.medicineid
                        LEFT JOIN medicine_units u ON m.unit_id = u.unit_id
                        WHERE (mi.primary_quantity > 0 OR mi.secondary_quantity > 0 OR mi.total_strips > 0 OR mi.loose_tablets > 0)
                        AND (mi.expiry_date IS NULL OR mi.expiry_date > GETDATE())
                        AND (
                            m.barcode = @searchTerm
                            OR m.barcode LIKE '%' + @searchTerm + '%'
                            OR @searchTerm LIKE '%' + m.barcode + '%'
                            OR m.medicine_name LIKE '%' + @searchTerm + '%'
                            OR m.generic_name LIKE '%' + @searchTerm + '%'
                            OR m.manufacturer LIKE '%' + @searchTerm + '%'
                        )
                        ORDER BY 
                            m.medicine_name";
                }
                else
                {
                    query = @"
                        SELECT DISTINCT
                            m.medicineid,
                            mi.inventoryid,
                            m.medicine_name,
                            m.generic_name,
                            m.manufacturer,
                            '' as barcode,
                            u.unit_id,
                            u.unit_name,
                            u.unit_abbreviation,
                            u.selling_method,
                            u.base_unit_name,
                            u.subdivision_unit,
                            u.allows_subdivision,
                            u.unit_size_label,
                            m.price_per_tablet,
                            m.price_per_strip,
                            m.price_per_box,
                            m.cost_per_tablet,
                            m.cost_per_strip,
                            m.cost_per_box,
                            m.tablets_per_strip,
                            m.strips_per_box,
                            mi.total_strips,
                            mi.loose_tablets,
                            mi.primary_quantity,
                            mi.secondary_quantity,
                            mi.unit_size,
                            mi.purchase_price
                        FROM medicine m
                        INNER JOIN medicine_inventory mi ON m.medicineid = mi.medicineid
                        LEFT JOIN medicine_units u ON m.unit_id = u.unit_id
                        WHERE (mi.primary_quantity > 0 OR mi.secondary_quantity > 0 OR mi.total_strips > 0 OR mi.loose_tablets > 0)
                        AND (mi.expiry_date IS NULL OR mi.expiry_date > GETDATE())
                        AND (
                            m.medicine_name LIKE '%' + @searchTerm + '%'
                            OR m.generic_name LIKE '%' + @searchTerm + '%'
                            OR m.manufacturer LIKE '%' + @searchTerm + '%'
                        )
                        ORDER BY m.medicine_name";
                }

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@searchTerm", searchTerm ?? "");
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    medicine_info med = new medicine_info();
                    med.medicineid = dr["medicineid"].ToString();
                    med.inventoryid = dr["inventoryid"].ToString();
                    med.medicine_name = dr["medicine_name"].ToString();
                    med.generic_name = dr["generic_name"].ToString();
                    med.manufacturer = dr["manufacturer"].ToString();
                    med.barcode = dr["barcode"] == DBNull.Value ? "" : dr["barcode"].ToString();
                    med.unit_id = dr["unit_id"] == DBNull.Value ? "" : dr["unit_id"].ToString();
                    med.unit_name = dr["unit_name"] == DBNull.Value ? "Unit" : dr["unit_name"].ToString();
                    med.unit_abbreviation = dr["unit_abbreviation"] == DBNull.Value ? "" : dr["unit_abbreviation"].ToString();
                    med.selling_method = dr["selling_method"] == DBNull.Value ? "countable" : dr["selling_method"].ToString();
                    med.base_unit_name = dr["base_unit_name"] == DBNull.Value ? "piece" : dr["base_unit_name"].ToString();
                    med.subdivision_unit = dr["subdivision_unit"] == DBNull.Value ? "" : dr["subdivision_unit"].ToString();
                    med.allows_subdivision = dr["allows_subdivision"] == DBNull.Value ? "False" : dr["allows_subdivision"].ToString();
                    med.unit_size_label = dr["unit_size_label"] == DBNull.Value ? "" : dr["unit_size_label"].ToString();
                    med.price_per_tablet = dr["price_per_tablet"] == DBNull.Value ? "0" : dr["price_per_tablet"].ToString();
                    med.price_per_strip = dr["price_per_strip"] == DBNull.Value ? "0" : dr["price_per_strip"].ToString();
                    med.price_per_box = dr["price_per_box"] == DBNull.Value ? "0" : dr["price_per_box"].ToString();
                    med.cost_per_tablet = dr["cost_per_tablet"] == DBNull.Value ? "0" : dr["cost_per_tablet"].ToString();
                    med.cost_per_strip = dr["cost_per_strip"] == DBNull.Value ? "0" : dr["cost_per_strip"].ToString();
                    med.cost_per_box = dr["cost_per_box"] == DBNull.Value ? "0" : dr["cost_per_box"].ToString();
                    med.tablets_per_strip = dr["tablets_per_strip"] == DBNull.Value ? "10" : dr["tablets_per_strip"].ToString();
                    med.total_strips = dr["total_strips"] == DBNull.Value ? "0" : dr["total_strips"].ToString();
                    med.loose_tablets = dr["loose_tablets"] == DBNull.Value ? "0" : dr["loose_tablets"].ToString();
                    med.primary_quantity = dr["primary_quantity"] == DBNull.Value ? "0" : dr["primary_quantity"].ToString();
                    med.secondary_quantity = dr["secondary_quantity"] == DBNull.Value ? "0" : dr["secondary_quantity"].ToString();
                    med.unit_size = dr["unit_size"] == DBNull.Value ? "1" : dr["unit_size"].ToString();
                    med.purchase_price = dr["purchase_price"] == DBNull.Value ? "0" : dr["purchase_price"].ToString();
                    list.Add(med);
                }
            }
            return list.ToArray();
        }

        [WebMethod]
        public static medicine_info[] getMedicineDetails(string medicineid)
        {
            List<medicine_info> list = new List<medicine_info>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            using (SqlConnection con = new SqlConnection(cs))
            {
                con.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT TOP 1
                        m.medicineid,
                        mi.inventoryid,
                        m.medicine_name,
                        m.generic_name,
                        m.manufacturer,
                        u.unit_id,
                        u.unit_name,
                        u.unit_abbreviation,
                        u.selling_method,
                        u.base_unit_name,
                        u.subdivision_unit,
                        u.allows_subdivision,
                        u.unit_size_label,
                        m.price_per_tablet,
                        m.price_per_strip,
                        m.price_per_box,
                        m.cost_per_tablet,
                        m.cost_per_strip,
                        m.cost_per_box,
                        m.tablets_per_strip,
                        mi.total_strips,
                        mi.loose_tablets,
                        mi.primary_quantity,
                        mi.secondary_quantity,
                        mi.unit_size,
                        mi.purchase_price
                    FROM medicine m
                    INNER JOIN medicine_inventory mi ON m.medicineid = mi.medicineid
                    LEFT JOIN medicine_units u ON m.unit_id = u.unit_id
                    WHERE m.medicineid = @medicineid
                    AND (mi.primary_quantity > 0 OR mi.secondary_quantity > 0 OR mi.total_strips > 0 OR mi.loose_tablets > 0)
                    AND (mi.expiry_date IS NULL OR mi.expiry_date > GETDATE())
                    ORDER BY mi.expiry_date ASC
                ", con);
                cmd.Parameters.AddWithValue("@medicineid", medicineid);
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    medicine_info med = new medicine_info();
                    med.medicineid = dr["medicineid"].ToString();
                    med.inventoryid = dr["inventoryid"].ToString();
                    med.medicine_name = dr["medicine_name"].ToString();
                    med.generic_name = dr["generic_name"].ToString();
                    med.manufacturer = dr["manufacturer"].ToString();
                    med.unit_id = dr["unit_id"] == DBNull.Value ? "" : dr["unit_id"].ToString();
                    med.unit_name = dr["unit_name"] == DBNull.Value ? "Unit" : dr["unit_name"].ToString();
                    med.unit_abbreviation = dr["unit_abbreviation"] == DBNull.Value ? "" : dr["unit_abbreviation"].ToString();
                    med.selling_method = dr["selling_method"] == DBNull.Value ? "countable" : dr["selling_method"].ToString();
                    med.base_unit_name = dr["base_unit_name"] == DBNull.Value ? "piece" : dr["base_unit_name"].ToString();
                    med.subdivision_unit = dr["subdivision_unit"] == DBNull.Value ? "" : dr["subdivision_unit"].ToString();
                    med.allows_subdivision = dr["allows_subdivision"] == DBNull.Value ? "False" : dr["allows_subdivision"].ToString();
                    med.unit_size_label = dr["unit_size_label"] == DBNull.Value ? "" : dr["unit_size_label"].ToString();
                    med.price_per_tablet = dr["price_per_tablet"] == DBNull.Value ? "0" : dr["price_per_tablet"].ToString();
                    med.price_per_strip = dr["price_per_strip"] == DBNull.Value ? "0" : dr["price_per_strip"].ToString();
                    med.price_per_box = dr["price_per_box"] == DBNull.Value ? "0" : dr["price_per_box"].ToString();
                    med.cost_per_tablet = dr["cost_per_tablet"] == DBNull.Value ? "0" : dr["cost_per_tablet"].ToString();
                    med.cost_per_strip = dr["cost_per_strip"] == DBNull.Value ? "0" : dr["cost_per_strip"].ToString();
                    med.cost_per_box = dr["cost_per_box"] == DBNull.Value ? "0" : dr["cost_per_box"].ToString();
                    med.tablets_per_strip = dr["tablets_per_strip"] == DBNull.Value ? "10" : dr["tablets_per_strip"].ToString();
                    med.total_strips = dr["total_strips"] == DBNull.Value ? "0" : dr["total_strips"].ToString();
                    med.loose_tablets = dr["loose_tablets"] == DBNull.Value ? "0" : dr["loose_tablets"].ToString();
                    med.primary_quantity = dr["primary_quantity"] == DBNull.Value ? "0" : dr["primary_quantity"].ToString();
                    med.secondary_quantity = dr["secondary_quantity"] == DBNull.Value ? "0" : dr["secondary_quantity"].ToString();
                    med.unit_size = dr["unit_size"] == DBNull.Value ? "1" : dr["unit_size"].ToString();
                    med.purchase_price = dr["purchase_price"] == DBNull.Value ? "0" : dr["purchase_price"].ToString();
                    list.Add(med);
                }
            }
            return list.ToArray();
        }

        [WebMethod]
        public static sale_result processSale(sale_request request)
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
                            // Generate invoice number
                            string invoiceNumber = "INV-" + DateTimeHelper.Now.ToString("yyyyMMdd") + "-" + DateTimeHelper.Now.ToString("HHmmss");
                            
                            // Calculate subtotal
                            double subtotal = request.items.Sum(x => x.total_price);
                            
                            // Insert sale
                            SqlCommand cmdSale = new SqlCommand(@"
                                INSERT INTO pharmacy_sales 
                                (invoice_number, customer_name, sale_date, total_amount, discount, final_amount, sold_by, payment_method, status)
                                VALUES 
                                (@invoice, @customer, @sale_date, @subtotal, @discount, @final, @userid, @payment, 1);
                                SELECT SCOPE_IDENTITY();
                            ", con, trans);
                            cmdSale.Parameters.AddWithValue("@invoice", invoiceNumber);
                            cmdSale.Parameters.AddWithValue("@customer", request.customerName);
                            cmdSale.Parameters.AddWithValue("@sale_date", DateTimeHelper.Now);
                            cmdSale.Parameters.AddWithValue("@subtotal", subtotal);
                            cmdSale.Parameters.AddWithValue("@discount", request.discount);
                            cmdSale.Parameters.AddWithValue("@final", request.finalAmount);
                            cmdSale.Parameters.AddWithValue("@userid", userId);
                            cmdSale.Parameters.AddWithValue("@payment", request.paymentMethod);
                            int saleid = Convert.ToInt32(cmdSale.ExecuteScalar());

                            // Insert sale items and update inventory
                            decimal totalCost = 0m;
                            decimal totalProfit = 0m;
                            foreach (var item in request.items)
                            {
                                // Compute cost price per unit for this line based on medicine cost prices
                                string qType = item.quantity_type ?? string.Empty;
                                decimal costPerUnit = 0m;

                                System.Diagnostics.Debug.WriteLine($"=== Getting cost for medicine {item.medicineid} ===");
                                System.Diagnostics.Debug.WriteLine($"Quantity Type: {qType}");

                                // Get cost prices from medicine table
                                using (var cmdCost = new SqlCommand(@"
                                    SELECT cost_per_tablet, cost_per_strip, cost_per_box, 
                                           tablets_per_strip, strips_per_box
                                    FROM medicine WHERE medicineid = @medid", con, trans))
                                {
                                    cmdCost.Parameters.AddWithValue("@medid", item.medicineid);
                                    using (var dr = cmdCost.ExecuteReader())
                                    {
                                        if (dr.Read())
                                        {
                                            decimal costPerTablet = dr["cost_per_tablet"] == DBNull.Value ? 0m : Convert.ToDecimal(dr["cost_per_tablet"]);
                                            decimal costPerStrip = dr["cost_per_strip"] == DBNull.Value ? 0m : Convert.ToDecimal(dr["cost_per_strip"]);
                                            decimal costPerBox = dr["cost_per_box"] == DBNull.Value ? 0m : Convert.ToDecimal(dr["cost_per_box"]);
                                            
                                            System.Diagnostics.Debug.WriteLine($"Cost Per Tablet: {costPerTablet}");
                                            System.Diagnostics.Debug.WriteLine($"Cost Per Strip: {costPerStrip}");
                                            System.Diagnostics.Debug.WriteLine($"Cost Per Box: {costPerBox}");

                                            // Determine cost per unit based on quantity type
                                            if (qType == "boxes" || qType == "box")
                                            {
                                                costPerUnit = costPerBox;
                                            }
                                            else if (qType == "strip" || qType == "strips" || qType == "bottle" || qType == "bottles" || qType == "vial" || qType == "vials" || qType == "tube" || qType == "tubes" || qType == "inhaler" || qType == "sachet")
                                            {
                                                costPerUnit = costPerStrip;
                                            }
                                            else // Loose items (tablets, ml, grams, pieces)
                                            {
                                                costPerUnit = costPerTablet; // Base unit cost
                                            }
                                            
                                            System.Diagnostics.Debug.WriteLine($"Selected Cost Per Unit: {costPerUnit}");
                                        }
                                        else
                                        {
                                            System.Diagnostics.Debug.WriteLine("WARNING: No cost data found in medicine table!");
                                        }
                                    }
                                }

                                decimal lineCost = costPerUnit * Convert.ToDecimal(item.quantity);
                                decimal lineProfit = Convert.ToDecimal(item.total_price) - lineCost;

                                totalCost += lineCost;
                                totalProfit += lineProfit;

                                // Insert sale item with cost and profit
                                SqlCommand cmdItem = new SqlCommand(@"
                                    INSERT INTO pharmacy_sales_items (saleid, medicineid, inventoryid, sale_id, medicine_id, inventory_id, quantity_type, quantity, unit_price, total_price, cost_price, profit)
                                    VALUES (@saleid, @medid, @invid, @saleid, @medid, @invid, @qtype, @qty, @uprice, @tprice, @cprice, @profit)
                                ", con, trans);
                                cmdItem.Parameters.AddWithValue("@saleid", saleid);
                                cmdItem.Parameters.AddWithValue("@medid", item.medicineid);
                                cmdItem.Parameters.AddWithValue("@invid", item.inventoryid);
                                cmdItem.Parameters.AddWithValue("@qtype", item.quantity_type);
                                cmdItem.Parameters.AddWithValue("@qty", item.quantity);
                                cmdItem.Parameters.AddWithValue("@uprice", item.unit_price);
                                cmdItem.Parameters.AddWithValue("@tprice", item.total_price);
                                cmdItem.Parameters.AddWithValue("@cprice", costPerUnit); // Cost per unit from medicine table
                                cmdItem.Parameters.AddWithValue("@profit", lineProfit);
                                cmdItem.ExecuteNonQuery();

                                // Update inventory using flexible columns
                                // 1. Get tablets_per_strip (unit size) from medicine table for accurate conversion
                                SqlCommand cmdSize = new SqlCommand(@"
                                    SELECT m.tablets_per_strip 
                                    FROM medicine m 
                                    INNER JOIN medicine_inventory mi ON m.medicineid = mi.medicineid 
                                    WHERE mi.inventoryid = @invid", con, trans);
                                cmdSize.Parameters.AddWithValue("@invid", item.inventoryid);
                                object unitSizeObj = cmdSize.ExecuteScalar();
                                double unitSize = unitSizeObj != null && unitSizeObj != DBNull.Value ? Convert.ToDouble(unitSizeObj) : 10;

                                if (item.quantity_type == "boxes")
                                {
                                    // Deduct boxes (assumed to be primary quantity for now, or handled separately)
                                    // For simplicity, if selling boxes, we deduct from total_boxes and adjust primary_quantity (strips)
                                    // But primary_quantity IS strips for tablets.
                                    // Let's assume boxes are just a multiplier of strips.
                                    SqlCommand cmdMed = new SqlCommand("SELECT strips_per_box FROM medicine WHERE medicineid = @medid", con, trans);
                                    cmdMed.Parameters.AddWithValue("@medid", item.medicineid);
                                    int stripsPerBox = Convert.ToInt32(cmdMed.ExecuteScalar() ?? 10);
                                    int stripsToDeduct = item.quantity * stripsPerBox;

                                    SqlCommand cmdInv = new SqlCommand(@"
                                        UPDATE medicine_inventory 
                                        SET total_boxes = ISNULL(total_boxes, 0) - @qty,
                                            primary_quantity = primary_quantity - @strips,
                                            total_strips = ISNULL(total_strips, 0) - @strips,
                                            last_updated = @last_updated
                                        WHERE inventoryid = @invid
                                    ", con, trans);
                                    cmdInv.Parameters.AddWithValue("@qty", item.quantity);
                                    cmdInv.Parameters.AddWithValue("@strips", stripsToDeduct);
                                    cmdInv.Parameters.AddWithValue("@last_updated", DateTimeHelper.Now);
                                    cmdInv.Parameters.AddWithValue("@invid", item.inventoryid);
                                    cmdInv.ExecuteNonQuery();
                                }
                                else if (item.quantity_type == "strip" || item.quantity_type == "strips" || 
                                         item.quantity_type == "bottle" || item.quantity_type == "bottles" || 
                                         item.quantity_type == "vial" || item.quantity_type == "vials" || 
                                         item.quantity_type == "tube" || item.quantity_type == "tubes" ||
                                         item.quantity_type == "sachet" || item.quantity_type == "sachets" ||
                                         item.quantity_type == "inhaler" || item.quantity_type == "inhalers")
                                {
                                    // Selling by subdivision units (strips, bottles, etc.) - deduct from primary quantity
                                    SqlCommand cmdInv = new SqlCommand(@"
                                        UPDATE medicine_inventory 
                                        SET primary_quantity = primary_quantity - @qty,
                                            total_strips = ISNULL(total_strips, 0) - @qty,
                                            last_updated = @last_updated
                                        WHERE inventoryid = @invid
                                    ", con, trans);
                                    cmdInv.Parameters.AddWithValue("@qty", item.quantity);
                                    cmdInv.Parameters.AddWithValue("@last_updated", DateTimeHelper.Now);
                                    cmdInv.Parameters.AddWithValue("@invid", item.inventoryid);
                                    cmdInv.ExecuteNonQuery();
                                }
                                else // Loose items (tablets, ml, etc.)
                                {
                                    // Sell pieces - need to deduct from loose stock and break strips if needed
                                    int piecesToSell = item.quantity;
                                    
                                    SqlCommand cmdInv = new SqlCommand(@"
                                        DECLARE @currentLoose INT = (SELECT ISNULL(secondary_quantity, 0) FROM medicine_inventory WHERE inventoryid = @invid);
                                        DECLARE @currentStrips INT = (SELECT ISNULL(primary_quantity, 0) FROM medicine_inventory WHERE inventoryid = @invid);
                                        DECLARE @piecesNeeded INT = @piecesToSell;
                                        DECLARE @newLoose INT;
                                        DECLARE @newStrips INT;
                                        
                                        -- Check if we have enough loose pieces
                                        IF @currentLoose >= @piecesNeeded
                                        BEGIN
                                            -- Enough loose pieces, just deduct
                                            SET @newLoose = @currentLoose - @piecesNeeded;
                                            SET @newStrips = @currentStrips;
                                        END
                                        ELSE
                                        BEGIN
                                            -- Not enough loose, need to break strips
                                            DECLARE @remainingPieces INT = @piecesNeeded - @currentLoose;
                                            DECLARE @stripsToBreak INT = CEILING(CAST(@remainingPieces AS FLOAT) / @unitSize);
                                            
                                            SET @newStrips = @currentStrips - @stripsToBreak;
                                            DECLARE @piecesFromBrokenStrips INT = @stripsToBreak * @unitSize;
                                            SET @newLoose = (@currentLoose + @piecesFromBrokenStrips) - @piecesNeeded;
                                        END
                                        
                                        -- Update inventory
                                        UPDATE medicine_inventory 
                                        SET primary_quantity = @newStrips,
                                            total_strips = @newStrips,
                                            secondary_quantity = @newLoose,
                                            loose_tablets = @newLoose,
                                            last_updated = @last_updated
                                        WHERE inventoryid = @invid;
                                    ", con, trans);
                                    cmdInv.Parameters.AddWithValue("@piecesToSell", piecesToSell);
                                    cmdInv.Parameters.AddWithValue("@unitSize", unitSize);
                                    cmdInv.Parameters.AddWithValue("@last_updated", DateTimeHelper.Now);
                                    cmdInv.Parameters.AddWithValue("@invid", item.inventoryid);
                                    cmdInv.ExecuteNonQuery();
                                }
                            }

                            // Update sale header with totals
SqlCommand cmdUpd = new SqlCommand("UPDATE pharmacy_sales SET total_cost = @tc, total_profit = @tp WHERE saleid = @sid", con, trans);
cmdUpd.Parameters.AddWithValue("@tc", totalCost);
cmdUpd.Parameters.AddWithValue("@tp", totalProfit);
cmdUpd.Parameters.AddWithValue("@sid", saleid);
cmdUpd.ExecuteNonQuery();

trans.Commit();
return new sale_result { invoice_number = invoiceNumber, success = true, total_revenue = request.finalAmount, total_cost = (double)totalCost, total_profit = (double)totalProfit };
                        }
                        catch (Exception ex)
                        {
                            trans.Rollback();
                            throw new Exception("Error processing sale: " + ex.Message, ex);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                return new sale_result { success = false, error = ex.Message };
            }
        }

        public class cart_item
        {
            public int medicineid { get; set; }
            public int inventoryid { get; set; }
            public string quantity_type { get; set; }
            public int quantity { get; set; }
            public double unit_price { get; set; }
            public double total_price { get; set; }
        }

        public class sale_request
        {
            public string customerName { get; set; }
            public string paymentMethod { get; set; }
            public double discount { get; set; }
            public double finalAmount { get; set; }
            public List<cart_item> items { get; set; }
        }

        public class sale_result
        {
            public string invoice_number { get; set; }
            public bool success { get; set; }
            public string error { get; set; }
            public double total_revenue { get; set; }
            public double total_cost { get; set; }
            public double total_profit { get; set; }
        }
    }
}

