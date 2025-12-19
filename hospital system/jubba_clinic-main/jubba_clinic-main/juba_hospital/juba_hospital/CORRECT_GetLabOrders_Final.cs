// FINAL CORRECT GetLabOrders method based on actual data structure
// Replace the entire GetLabOrders method with this:

[WebMethod]
public static LabOrder[] GetLabOrders(string prescid)
{
    List<LabOrder> orders = new List<LabOrder>();
    string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

    try
    {
        using (SqlConnection con = new SqlConnection(cs))
        {
            con.Open();
            SqlCommand cmd = new SqlCommand(@"
                SELECT DISTINCT
                    lt.med_id as OrderId,
                    FORMAT(lt.date_taken, 'yyyy-MM-dd HH:mm') as OrderDate,
                    ISNULL(pc.amount, 15) as ChargeAmount,
                    ISNULL(pc.is_paid, 0) as IsPaid
                FROM lab_test lt
                LEFT JOIN patient_charges pc ON pc.reference_id = lt.med_id AND pc.charge_type = 'Lab'
                WHERE lt.prescid = @prescid
                ORDER BY lt.date_taken DESC
            ", con);

            cmd.Parameters.AddWithValue("@prescid", prescid);

            using (SqlDataReader dr = cmd.ExecuteReader())
            {
                while (dr.Read())
                {
                    LabOrder order = new LabOrder();
                    order.OrderId = dr["OrderId"].ToString();
                    order.OrderDate = dr["OrderDate"].ToString();
                    order.ChargeAmount = Convert.ToDecimal(dr["ChargeAmount"]);
                    order.IsPaid = Convert.ToBoolean(dr["IsPaid"]);

                    orders.Add(order);
                }
            }

            // Get ordered tests - EXACT filtering based on actual data
            foreach (var order in orders)
            {
                List<string> orderedTests = new List<string>();

                string orderedQuery = "SELECT * FROM lab_test WHERE med_id = @orderId";
                
                using (SqlCommand cmd2 = new SqlCommand(orderedQuery, con))
                {
                    cmd2.Parameters.AddWithValue("@orderId", order.OrderId);
                    using (SqlDataReader reader = cmd2.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            // Check each test column for ACTUAL ordered tests
                            for (int i = 0; i < reader.FieldCount; i++)
                            {
                                string columnName = reader.GetName(i);
                                
                                // Skip system columns
                                if (columnName.ToLower().Contains("id") || 
                                    columnName.ToLower().Contains("date") || 
                                    columnName.ToLower().Contains("prescid") ||
                                    columnName.ToLower() == "type" ||
                                    columnName == "is_reorder" ||
                                    columnName == "reorder_reason" ||
                                    columnName == "original_order_id")
                                    continue;

                                if (reader[columnName] != DBNull.Value)
                                {
                                    string value = reader[columnName].ToString().Trim();
                                    
                                    // EXACT RULE: Only add if it's NOT "not checked" and not empty
                                    if (!string.IsNullOrWhiteSpace(value) && 
                                        !value.Equals("not checked", StringComparison.OrdinalIgnoreCase))
                                    {
                                        orderedTests.Add(FormatTestName(columnName));
                                    }
                                }
                            }
                        }
                    }
                }

                order.OrderedTests = orderedTests.ToArray();
            }
        }

        return orders.ToArray();
    }
    catch (Exception ex)
    {
        throw new Exception("GetLabOrders Error: " + ex.Message);
    }
}