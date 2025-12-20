// DEBUG VERSION of GetLabOrders method with comprehensive logging
// Replace the entire GetLabOrders method with this:

[WebMethod]
public static LabOrder[] GetLabOrders(string prescid)
{
    List<LabOrder> orders = new List<LabOrder>();
    string cs = ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;

    try
    {
        // DEBUG: Log the prescid being requested
        System.Diagnostics.Debug.WriteLine($"DEBUG: GetLabOrders called with prescid: {prescid}");

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
                    
                    // DEBUG: Log each order found
                    System.Diagnostics.Debug.WriteLine($"DEBUG: Found lab order - ID: {order.OrderId}, Date: {order.OrderDate}");
                }
            }

            System.Diagnostics.Debug.WriteLine($"DEBUG: Total orders found: {orders.Count}");

            // Get ordered tests with DEBUG logging
            foreach (var order in orders)
            {
                List<string> orderedTests = new List<string>();

                System.Diagnostics.Debug.WriteLine($"DEBUG: Processing order {order.OrderId}");

                string orderedQuery = "SELECT * FROM lab_test WHERE med_id = @orderId";
                
                using (SqlCommand cmd2 = new SqlCommand(orderedQuery, con))
                {
                    cmd2.Parameters.AddWithValue("@orderId", order.OrderId);
                    using (SqlDataReader reader = cmd2.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            System.Diagnostics.Debug.WriteLine($"DEBUG: Found lab_test record for order {order.OrderId}");
                            
                            // Check each test column with DEBUG logging
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
                                {
                                    continue;
                                }

                                if (reader[columnName] != DBNull.Value)
                                {
                                    string value = reader[columnName].ToString().Trim();
                                    
                                    // DEBUG: Log every column and its value
                                    System.Diagnostics.Debug.WriteLine($"DEBUG: Column: {columnName} = '{value}'");
                                    
                                    // Check if this should be included
                                    if (!string.IsNullOrWhiteSpace(value) && 
                                        !value.Equals("not checked", StringComparison.OrdinalIgnoreCase))
                                    {
                                        orderedTests.Add(FormatTestName(columnName));
                                        System.Diagnostics.Debug.WriteLine($"DEBUG: ADDED TEST: {columnName} -> {FormatTestName(columnName)}");
                                    }
                                    else
                                    {
                                        System.Diagnostics.Debug.WriteLine($"DEBUG: SKIPPED TEST: {columnName} (value: '{value}')");
                                    }
                                }
                                else
                                {
                                    System.Diagnostics.Debug.WriteLine($"DEBUG: SKIPPED TEST: {columnName} (DBNull)");
                                }
                            }
                        }
                        else
                        {
                            System.Diagnostics.Debug.WriteLine($"DEBUG: No lab_test record found for order {order.OrderId}");
                        }
                    }
                }

                order.OrderedTests = orderedTests.ToArray();
                System.Diagnostics.Debug.WriteLine($"DEBUG: Order {order.OrderId} final test count: {orderedTests.Count}");
                foreach(var test in orderedTests)
                {
                    System.Diagnostics.Debug.WriteLine($"DEBUG: Final test: {test}");
                }
            }
        }

        System.Diagnostics.Debug.WriteLine($"DEBUG: Returning {orders.Count} orders");
        return orders.ToArray();
    }
    catch (Exception ex)
    {
        System.Diagnostics.Debug.WriteLine($"DEBUG: ERROR in GetLabOrders: {ex.Message}");
        throw new Exception("GetLabOrders Error: " + ex.Message);
    }
}