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
    public partial class pharmacy_return_transaction : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("login.aspx");
            }
        }

        [WebMethod]
        public static SaleInfo SearchSale(string invoiceNumber, string customerName)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SaleInfo saleInfo = null;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    string query = @"
                        SELECT TOP 1
                            ps.saleid,
                            ps.invoice_number,
                            ps.customer_name,
                            ps.sale_date,
                            ps.total_amount,
                            ps.final_amount,
                            ps.discount
                        FROM pharmacy_sales ps
                        WHERE ps.status = 1
                        AND (ps.invoice_number = @invoiceNumber OR ps.customer_name LIKE '%' + @customerName + '%')
                        ORDER BY ps.sale_date DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@invoiceNumber", string.IsNullOrEmpty(invoiceNumber) ? "" : invoiceNumber);
                        cmd.Parameters.AddWithValue("@customerName", string.IsNullOrEmpty(customerName) ? "" : customerName);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                saleInfo = new SaleInfo
                                {
                                    saleid = Convert.ToInt32(dr["saleid"]),
                                    invoice_number = dr["invoice_number"].ToString(),
                                    customer_name = dr["customer_name"].ToString(),
                                    sale_date = Convert.ToDateTime(dr["sale_date"]),
                                    total_amount = Convert.ToDouble(dr["total_amount"]),
                                    final_amount = Convert.ToDouble(dr["final_amount"]),
                                    discount = Convert.ToDouble(dr["discount"])
                                };
                            }
                        }
                    }

                    // Get sale items
                    if (saleInfo != null)
                    {
                        saleInfo.items = GetSaleItems(con, saleInfo.saleid);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in SearchSale: " + ex.Message);
                throw;
            }

            return saleInfo;
        }

        [WebMethod]
        public static List<SaleInfo> GetRecentSales()
        {
            List<SaleInfo> sales = new List<SaleInfo>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    string query = @"
                        SELECT TOP 50
                            ps.saleid,
                            ps.invoice_number,
                            ps.customer_name,
                            ps.sale_date,
                            ps.total_amount,
                            ps.final_amount,
                            ps.discount,
                            COUNT(DISTINCT psi.sale_item_id) as item_count,
                            STUFF((SELECT DISTINCT ', ' + m2.medicine_name
                                   FROM pharmacy_sales_items psi2
                                   INNER JOIN medicine m2 ON psi2.medicineid = m2.medicineid
                                   WHERE psi2.saleid = ps.saleid
                                   ORDER BY ', ' + m2.medicine_name
                                   FOR XML PATH('')), 1, 2, '') as medicines
                        FROM pharmacy_sales ps
                        LEFT JOIN pharmacy_sales_items psi ON ps.saleid = psi.saleid
                        WHERE ps.status = 1
                        AND ps.sale_date >= DATEADD(day, -30, GETDATE())
                        AND ps.saleid NOT IN (SELECT ISNULL(original_saleid, 0) FROM pharmacy_returns WHERE status = 1)
                        GROUP BY ps.saleid, ps.invoice_number, ps.customer_name, ps.sale_date, 
                                 ps.total_amount, ps.final_amount, ps.discount
                        ORDER BY ps.sale_date DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                SaleInfo sale = new SaleInfo
                                {
                                    saleid = Convert.ToInt32(dr["saleid"]),
                                    invoice_number = dr["invoice_number"].ToString(),
                                    customer_name = dr["customer_name"].ToString(),
                                    sale_date = Convert.ToDateTime(dr["sale_date"]),
                                    total_amount = Convert.ToDouble(dr["total_amount"]),
                                    final_amount = Convert.ToDouble(dr["final_amount"]),
                                    discount = Convert.ToDouble(dr["discount"]),
                                    item_count = Convert.ToInt32(dr["item_count"]),
                                    medicines = dr["medicines"] == DBNull.Value ? "" : dr["medicines"].ToString()
                                };
                                sales.Add(sale);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in GetRecentSales: " + ex.Message);
                throw;
            }

            return sales;
        }

        [WebMethod]
        public static SaleInfo GetSaleById(int saleid)
        {
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
            SaleInfo saleInfo = null;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    string query = @"
                        SELECT 
                            saleid,
                            invoice_number,
                            customer_name,
                            sale_date,
                            total_amount,
                            final_amount,
                            discount
                        FROM pharmacy_sales
                        WHERE saleid = @saleid AND status = 1";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        cmd.Parameters.AddWithValue("@saleid", saleid);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                saleInfo = new SaleInfo
                                {
                                    saleid = Convert.ToInt32(dr["saleid"]),
                                    invoice_number = dr["invoice_number"].ToString(),
                                    customer_name = dr["customer_name"].ToString(),
                                    sale_date = Convert.ToDateTime(dr["sale_date"]),
                                    total_amount = Convert.ToDouble(dr["total_amount"]),
                                    final_amount = Convert.ToDouble(dr["final_amount"]),
                                    discount = Convert.ToDouble(dr["discount"])
                                };
                            }
                        }
                    }

                    if (saleInfo != null)
                    {
                        saleInfo.items = GetSaleItems(con, saleid);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in GetSaleById: " + ex.Message);
                throw;
            }

            return saleInfo;
        }

        private static List<SaleItemInfo> GetSaleItems(SqlConnection con, int saleid)
        {
            List<SaleItemInfo> items = new List<SaleItemInfo>();

            string query = @"
                SELECT 
                    psi.sale_item_id,
                    psi.medicineid,
                    psi.inventoryid,
                    m.medicine_name,
                    psi.quantity_type,
                    psi.quantity,
                    psi.unit_price,
                    psi.total_price,
                    psi.cost_price,
                    psi.profit
                FROM pharmacy_sales_items psi
                INNER JOIN medicine m ON psi.medicineid = m.medicineid
                WHERE psi.saleid = @saleid";

            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@saleid", saleid);

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    while (dr.Read())
                    {
                        SaleItemInfo item = new SaleItemInfo
                        {
                            sale_item_id = Convert.ToInt32(dr["sale_item_id"]),
                            medicineid = Convert.ToInt32(dr["medicineid"]),
                            inventoryid = Convert.ToInt32(dr["inventoryid"]),
                            medicine_name = dr["medicine_name"].ToString(),
                            quantity_type = dr["quantity_type"].ToString(),
                            quantity = Convert.ToDouble(dr["quantity"]),
                            unit_price = Convert.ToDouble(dr["unit_price"]),
                            total_price = Convert.ToDouble(dr["total_price"]),
                            cost_price = Convert.ToDouble(dr["cost_price"]),
                            profit = Convert.ToDouble(dr["profit"])
                        };
                        items.Add(item);
                    }
                }
            }

            return items;
        }

        [WebMethod]
        public static ReturnResult ProcessReturn(int saleid, string returnReason, string refundMethod, List<ReturnItem> items)
        {
            ReturnResult result = new ReturnResult();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();
                    SqlTransaction transaction = con.BeginTransaction();

                    try
                    {
                        // Get user ID from session
                        int userId = 0;
                        try
                        {
                            if (HttpContext.Current.Session["UserId"] != null)
                            {
                                userId = Convert.ToInt32(HttpContext.Current.Session["UserId"]);
                            }
                        }
                        catch (Exception ex)
                        {
                            System.Diagnostics.Debug.WriteLine("Error getting UserId: " + ex.Message);
                            userId = 0;
                        }

                        // Generate return invoice
                        int nextId = GetNextReturnId(con, transaction);
                        string returnInvoice = "RET-" + DateTime.Now.ToString("yyyyMMdd") + "-" + 
                                             (nextId + 1).ToString("D5");

                        // Get original sale info
                        string originalInvoice = "";
                        string customerName = "";
                        string getSaleQuery = "SELECT invoice_number, customer_name FROM pharmacy_sales WHERE saleid = @saleid";
                        using (SqlCommand cmd = new SqlCommand(getSaleQuery, con, transaction))
                        {
                            cmd.Parameters.AddWithValue("@saleid", saleid);
                            using (SqlDataReader dr = cmd.ExecuteReader())
                            {
                                if (dr.Read())
                                {
                                    originalInvoice = dr["invoice_number"].ToString();
                                    customerName = dr["customer_name"].ToString();
                                }
                            }
                        }

                        // Calculate total return amount
                        double totalReturnAmount = items.Sum(i => i.return_amount);

                        // Insert return header
                        string insertReturnQuery = @"
                            INSERT INTO pharmacy_returns 
                            (return_invoice, original_saleid, original_invoice, customer_name, 
                             return_reason, processed_by, refund_method, total_return_amount)
                            VALUES 
                            (@return_invoice, @original_saleid, @original_invoice, @customer_name,
                             @return_reason, @processed_by, @refund_method, @total_return_amount);
                            SELECT SCOPE_IDENTITY()";

                        int returnId = 0;
                        using (SqlCommand cmd = new SqlCommand(insertReturnQuery, con, transaction))
                        {
                            cmd.Parameters.AddWithValue("@return_invoice", returnInvoice);
                            cmd.Parameters.AddWithValue("@original_saleid", saleid);
                            cmd.Parameters.AddWithValue("@original_invoice", originalInvoice);
                            cmd.Parameters.AddWithValue("@customer_name", customerName);
                            cmd.Parameters.AddWithValue("@return_reason", returnReason);
                            cmd.Parameters.AddWithValue("@processed_by", userId);
                            cmd.Parameters.AddWithValue("@refund_method", refundMethod);
                            cmd.Parameters.AddWithValue("@total_return_amount", totalReturnAmount);

                            returnId = Convert.ToInt32(cmd.ExecuteScalar());
                        }

                        // Process each return item
                        foreach (var item in items)
                        {
                            // Insert return item
                            string insertItemQuery = @"
                                INSERT INTO pharmacy_return_items
                                (returnid, original_sale_item_id, medicineid, inventoryid, quantity_type,
                                 quantity_returned, original_unit_price, return_amount, original_cost_price, profit_reversed)
                                VALUES
                                (@returnid, @sale_item_id, @medicineid, @inventoryid, @quantity_type,
                                 @quantity_returned, @unit_price, @return_amount, @cost_price, @profit_reversed)";

                            double profitReversed = item.return_amount - (item.return_quantity * item.cost_price);

                            using (SqlCommand cmd = new SqlCommand(insertItemQuery, con, transaction))
                            {
                                cmd.Parameters.AddWithValue("@returnid", returnId);
                                cmd.Parameters.AddWithValue("@sale_item_id", item.sale_item_id);
                                cmd.Parameters.AddWithValue("@medicineid", item.medicineid);
                                cmd.Parameters.AddWithValue("@inventoryid", item.inventoryid);
                                cmd.Parameters.AddWithValue("@quantity_type", item.quantity_type);
                                cmd.Parameters.AddWithValue("@quantity_returned", item.return_quantity);
                                cmd.Parameters.AddWithValue("@unit_price", item.unit_price);
                                cmd.Parameters.AddWithValue("@return_amount", item.return_amount);
                                cmd.Parameters.AddWithValue("@cost_price", item.cost_price);
                                cmd.Parameters.AddWithValue("@profit_reversed", profitReversed);

                                cmd.ExecuteNonQuery();
                            }

                            // Restore inventory based on quantity type
                            RestoreInventory(con, transaction, item);
                        }

                        // Update original sale amounts
                        double totalReturned = items.Sum(i => i.return_amount);
                        string updateSaleQuery = @"
                            UPDATE pharmacy_sales 
                            SET final_amount = final_amount - @return_amount,
                                total_profit = total_profit - @profit_reversed
                            WHERE saleid = @saleid";

                        double totalProfitReversed = items.Sum(i => i.return_amount - (i.return_quantity * i.cost_price));

                        using (SqlCommand cmd = new SqlCommand(updateSaleQuery, con, transaction))
                        {
                            cmd.Parameters.AddWithValue("@return_amount", totalReturned);
                            cmd.Parameters.AddWithValue("@profit_reversed", totalProfitReversed);
                            cmd.Parameters.AddWithValue("@saleid", saleid);
                            cmd.ExecuteNonQuery();
                        }

                        transaction.Commit();

                        result.success = true;
                        result.return_invoice = returnInvoice;
                        result.message = "Return processed successfully";
                    }
                    catch (Exception ex)
                    {
                        transaction.Rollback();
                        result.success = false;
                        result.message = "Transaction failed: " + ex.Message;
                        System.Diagnostics.Debug.WriteLine("Error in ProcessReturn transaction: " + ex.Message);
                        System.Diagnostics.Debug.WriteLine("Stack trace: " + ex.StackTrace);
                        
                        // Check for specific errors
                        if (ex.Message.Contains("Invalid column name") || ex.Message.Contains("Invalid object name"))
                        {
                            result.message = "Database tables not found. Please run pharmacy_return_system.sql script first.";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                result.success = false;
                result.message = "Error: " + ex.Message;
                System.Diagnostics.Debug.WriteLine("Error in ProcessReturn: " + ex.Message);
            }

            return result;
        }

        private static int GetNextReturnId(SqlConnection con, SqlTransaction transaction)
        {
            try
            {
                // Check if table exists first
                string checkTableQuery = @"
                    IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pharmacy_returns]') AND type in (N'U'))
                        SELECT 1
                    ELSE
                        SELECT 0";
                
                using (SqlCommand checkCmd = new SqlCommand(checkTableQuery, con, transaction))
                {
                    int tableExists = Convert.ToInt32(checkCmd.ExecuteScalar());
                    if (tableExists == 0)
                    {
                        throw new Exception("pharmacy_returns table does not exist. Please run pharmacy_return_system.sql script first.");
                    }
                }

                // Get next ID
                string query = "SELECT ISNULL(MAX(returnid), 0) FROM pharmacy_returns";
                using (SqlCommand cmd = new SqlCommand(query, con, transaction))
                {
                    object result = cmd.ExecuteScalar();
                    return result == null || result == DBNull.Value ? 0 : Convert.ToInt32(result);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in GetNextReturnId: " + ex.Message);
                throw new Exception("Database error: " + ex.Message);
            }
        }

        private static void RestoreInventory(SqlConnection con, SqlTransaction transaction, ReturnItem item)
        {
            string qType = item.quantity_type.ToLower();
            double quantity = item.return_quantity;

            // Get medicine configuration
            string configQuery = "SELECT tablets_per_strip, strips_per_box FROM medicine WHERE medicineid = @medicineid";
            int tabletsPerStrip = 0;
            int stripsPerBox = 0;
            
            using (SqlCommand cmd = new SqlCommand(configQuery, con, transaction))
            {
                cmd.Parameters.AddWithValue("@medicineid", item.medicineid);
                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        tabletsPerStrip = dr["tablets_per_strip"] == DBNull.Value ? 0 : Convert.ToInt32(dr["tablets_per_strip"]);
                        stripsPerBox = dr["strips_per_box"] == DBNull.Value ? 0 : Convert.ToInt32(dr["strips_per_box"]);
                    }
                }
            }

            // Restore inventory - EXACT REVERSE of POS deduction logic
            
            if (qType == "box" || qType == "boxes")
            {
                // REVERSE OF: Deduct from primary_quantity (strips) and total_boxes
                // POS deducts: strips = qty * strips_per_box from primary_quantity
                int stripsToAdd = (int)(quantity * stripsPerBox);
                
                string updateQuery = @"
                    UPDATE medicine_inventory 
                    SET total_boxes = ISNULL(total_boxes, 0) + @qty,
                        primary_quantity = primary_quantity + @strips,
                        total_strips = ISNULL(total_strips, 0) + @strips,
                        last_updated = GETDATE()
                    WHERE inventoryid = @inventoryid";

                using (SqlCommand cmd = new SqlCommand(updateQuery, con, transaction))
                {
                    cmd.Parameters.AddWithValue("@qty", quantity);
                    cmd.Parameters.AddWithValue("@strips", stripsToAdd);
                    cmd.Parameters.AddWithValue("@inventoryid", item.inventoryid);
                    cmd.ExecuteNonQuery();
                }
            }
            else if (qType == "strip" || qType == "strips" || 
                     qType == "bottle" || qType == "bottles" || 
                     qType == "vial" || qType == "vials" || 
                     qType == "tube" || qType == "tubes" ||
                     qType == "sachet" || qType == "sachets" ||
                     qType == "inhaler" || qType == "inhalers")
            {
                // REVERSE OF: Deduct from primary_quantity and total_strips
                // POS deducts: primary_quantity - qty, total_strips - qty
                // Return adds: primary_quantity + qty, total_strips + qty
                
                string updateQuery = @"
                    UPDATE medicine_inventory 
                    SET primary_quantity = primary_quantity + @qty,
                        total_strips = ISNULL(total_strips, 0) + @qty,
                        last_updated = GETDATE()
                    WHERE inventoryid = @inventoryid";

                using (SqlCommand cmd = new SqlCommand(updateQuery, con, transaction))
                {
                    cmd.Parameters.AddWithValue("@qty", quantity);
                    cmd.Parameters.AddWithValue("@inventoryid", item.inventoryid);
                    cmd.ExecuteNonQuery();
                }
            }
            else // Loose items (pieces, tablets, ml, etc.)
            {
                // REVERSE OF: Complex piece deduction with strip breaking
                // POS: Deducts from secondary_quantity, breaks strips from primary_quantity if needed
                // Return: Adds to secondary_quantity, may form new strips if enough pieces
                
                if (tabletsPerStrip > 0)
                {
                    // Smart restoration with conversion
                    string updateQuery = @"
                        DECLARE @currentLoose INT = (SELECT ISNULL(secondary_quantity, 0) FROM medicine_inventory WHERE inventoryid = @invid);
                        DECLARE @currentStrips INT = (SELECT ISNULL(primary_quantity, 0) FROM medicine_inventory WHERE inventoryid = @invid);
                        DECLARE @piecesToAdd INT = @piecesToReturn;
                        DECLARE @tabletsPerStrip INT = @unitSize;
                        
                        -- Add pieces to current loose
                        DECLARE @totalLoose INT = @currentLoose + @piecesToAdd;
                        
                        -- Calculate how many strips can be formed
                        DECLARE @newStrips INT = @totalLoose / @tabletsPerStrip;
                        DECLARE @remainingLoose INT = @totalLoose % @tabletsPerStrip;
                        
                        -- Update inventory
                        UPDATE medicine_inventory 
                        SET primary_quantity = @currentStrips + @newStrips,
                            total_strips = ISNULL(total_strips, 0) + @newStrips,
                            secondary_quantity = @remainingLoose,
                            loose_tablets = @remainingLoose,
                            last_updated = GETDATE()
                        WHERE inventoryid = @invid";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con, transaction))
                    {
                        cmd.Parameters.AddWithValue("@piecesToReturn", (int)quantity);
                        cmd.Parameters.AddWithValue("@unitSize", tabletsPerStrip);
                        cmd.Parameters.AddWithValue("@invid", item.inventoryid);
                        cmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    // No conversion, just add to secondary_quantity
                    string updateQuery = @"
                        UPDATE medicine_inventory 
                        SET secondary_quantity = secondary_quantity + @qty,
                            loose_tablets = loose_tablets + @qty,
                            last_updated = GETDATE()
                        WHERE inventoryid = @inventoryid";

                    using (SqlCommand cmd = new SqlCommand(updateQuery, con, transaction))
                    {
                        cmd.Parameters.AddWithValue("@qty", quantity);
                        cmd.Parameters.AddWithValue("@inventoryid", item.inventoryid);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        [WebMethod]
        public static List<ReturnHistoryInfo> GetReturnHistory()
        {
            List<ReturnHistoryInfo> history = new List<ReturnHistoryInfo>();
            string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

            try
            {
                using (SqlConnection con = new SqlConnection(cs))
                {
                    con.Open();

                    string query = @"
                        SELECT TOP 50
                            pr.returnid,
                            pr.return_invoice,
                            pr.original_invoice,
                            pr.customer_name,
                            pr.return_date,
                            pr.total_return_amount,
                            pr.return_reason,
                            pr.refund_method,
                            COUNT(pri.return_item_id) as items_returned
                        FROM pharmacy_returns pr
                        LEFT JOIN pharmacy_return_items pri ON pr.returnid = pri.returnid
                        GROUP BY pr.returnid, pr.return_invoice, pr.original_invoice, pr.customer_name,
                                 pr.return_date, pr.total_return_amount, pr.return_reason, pr.refund_method
                        ORDER BY pr.return_date DESC";

                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            while (dr.Read())
                            {
                                ReturnHistoryInfo info = new ReturnHistoryInfo
                                {
                                    returnid = Convert.ToInt32(dr["returnid"]),
                                    return_invoice = dr["return_invoice"].ToString(),
                                    original_invoice = dr["original_invoice"].ToString(),
                                    customer_name = dr["customer_name"].ToString(),
                                    return_date = Convert.ToDateTime(dr["return_date"]),
                                    total_return_amount = Convert.ToDouble(dr["total_return_amount"]),
                                    return_reason = dr["return_reason"].ToString(),
                                    refund_method = dr["refund_method"].ToString(),
                                    items_returned = Convert.ToInt32(dr["items_returned"])
                                };
                                history.Add(info);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error in GetReturnHistory: " + ex.Message);
            }

            return history;
        }

        // Data classes
        public class SaleInfo
        {
            public int saleid { get; set; }
            public string invoice_number { get; set; }
            public string customer_name { get; set; }
            public DateTime sale_date { get; set; }
            public double total_amount { get; set; }
            public double final_amount { get; set; }
            public double discount { get; set; }
            public int item_count { get; set; }
            public string medicines { get; set; }
            public List<SaleItemInfo> items { get; set; }
        }

        public class SaleItemInfo
        {
            public int sale_item_id { get; set; }
            public int medicineid { get; set; }
            public int inventoryid { get; set; }
            public string medicine_name { get; set; }
            public string quantity_type { get; set; }
            public double quantity { get; set; }
            public double unit_price { get; set; }
            public double total_price { get; set; }
            public double cost_price { get; set; }
            public double profit { get; set; }
        }

        public class ReturnItem
        {
            public int sale_item_id { get; set; }
            public int medicineid { get; set; }
            public int inventoryid { get; set; }
            public string quantity_type { get; set; }
            public double return_quantity { get; set; }
            public double unit_price { get; set; }
            public double return_amount { get; set; }
            public double cost_price { get; set; }
        }

        public class ReturnResult
        {
            public bool success { get; set; }
            public string message { get; set; }
            public string return_invoice { get; set; }
        }

        public class ReturnHistoryInfo
        {
            public int returnid { get; set; }
            public string return_invoice { get; set; }
            public string original_invoice { get; set; }
            public string customer_name { get; set; }
            public DateTime return_date { get; set; }
            public double total_return_amount { get; set; }
            public string return_reason { get; set; }
            public string refund_method { get; set; }
            public int items_returned { get; set; }
        }
    }
}
