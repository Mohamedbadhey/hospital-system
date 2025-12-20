<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="pharmacy_invoice.aspx.cs" Inherits="juba_hospital.pharmacy_invoice" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pharmacy Invoice</title>
    <link rel="stylesheet" href="Content/print-header.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        @media print {
            .no-print { display: none !important; }
            body { margin: 0; }
        }
        
        body {
            background: white;
            font-family: Arial, sans-serif;
        }
        
        .invoice-container { 
            max-width: 800px; 
            margin: 0 auto; 
            padding: 20px; 
        }
        
        .invoice-header { 
            border-bottom: 2px solid #000; 
            padding-bottom: 20px; 
            margin-bottom: 20px; 
        }
        
        .invoice-items { 
            margin: 20px 0; 
        }
        
        .invoice-total { 
            border-top: 2px solid #000; 
            padding-top: 20px; 
            margin-top: 20px; 
        }
        
        .invoice-customer {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="invoice-container">
        <div class="no-print mb-3">
            <button onclick="window.print()" class="btn btn-primary">Print Invoice</button>
            <a href="pharmacy_sales_history.aspx" class="btn btn-secondary">Back to Sales</a>
        </div>
        
        <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>
        
        <div class="invoice-header">
            <div class="row">
                <div class="col-md-12">
                    <h2 class="text-center mb-3">PHARMACY INVOICE</h2>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <p><strong>Invoice #:</strong> <span id="invoiceNumber"></span></p>
                    <p><strong>Date:</strong> <span id="invoiceDate"></span></p>
                </div>
                <div class="col-md-6 text-end">
                    <p><strong>Payment Method:</strong> <span id="paymentMethodHeader"></span></p>
                    <p><strong>Status:</strong> <span class="badge bg-success">Paid</span></p>
                </div>
            </div>
        </div>

        <div class="invoice-customer mb-4">
            <h5>Bill To:</h5>
            <p><strong id="customerName"></strong><br>
            <span id="customerDetails"></span></p>
        </div>

        <div class="invoice-items">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Medicine</th>
                        <th>Quantity</th>
                        <th>Unit Price</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody id="invoiceItems">
                </tbody>
            </table>
        </div>

        <div class="invoice-total">
            <div class="row">
                <div class="col-md-8"></div>
                <div class="col-md-4">
                    <table class="table">
                        <tr>
                            <td><strong>Subtotal:</strong></td>
                            <td class="text-end" id="subtotal">0.00</td>
                        </tr>
                        <tr>
                            <td><strong>Discount:</strong></td>
                            <td class="text-end" id="discount">0.00</td>
                        </tr>
                        <tr class="table-primary">
                            <td><strong>Total:</strong></td>
                            <td class="text-end" id="total"><strong>0.00</strong></td>
                        </tr>
   
                    </table>
                </div>
            </div>
        </div>

        <div class="mt-4 text-center">
            <p>Thank you for your purchase!</p>
        </div>
    </div>

    </form>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        $(document).ready(function () {
            var urlParams = new URLSearchParams(window.location.search);
            var invoiceNumber = urlParams.get('invoice');
            if (invoiceNumber) {
                loadInvoice(invoiceNumber);
            }
        });

        function loadInvoice(invoiceNumber) {
            $.ajax({
                url: 'pharmacy_invoice.aspx/getInvoiceData',
                data: JSON.stringify({ invoiceNumber: invoiceNumber }),
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    if (r.d && r.d.length > 0) {
                        var invoice = r.d[0];
                        $('#invoiceNumber').text(invoice.invoice_number);
                        $('#invoiceDate').text(invoice.sale_date);
                        $('#customerName').text(invoice.customer_name || 'Walk-in Customer');
                        $('#customerDetails').text(invoice.customer_phone || 'N/A');
                        $('#paymentMethodHeader').text(invoice.payment_method || 'Cash');
                        var totalAmount = parseFloat(invoice.total_amount) || 0;
                        var discount = parseFloat(invoice.discount) || 0;
                        var finalAmount = parseFloat(invoice.final_amount) || 0;
                        
                        $('#subtotal').text('$' + totalAmount.toFixed(2));
                        $('#discount').text('$' + discount.toFixed(2));
                        $('#total').html('<strong>$' + finalAmount.toFixed(2) + '</strong>');

                        // Load items
                        loadInvoiceItems(invoice.saleid);
                    }
                }
            });
        }

        function loadInvoiceItems(saleid) {
            $.ajax({
                url: 'pharmacy_invoice.aspx/getInvoiceItems',
                data: JSON.stringify({ saleid: saleid }),
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    $('#invoiceItems').empty();
                    if (r.d && r.d.length > 0) {
                        var itemNum = 1;
                        for (var i = 0; i < r.d.length; i++) {
                            var item = r.d[i];
                            var unitPrice = parseFloat(item.unit_price) || 0;
                            var totalPrice = parseFloat(item.total_price) || 0;
                            var quantity = item.quantity || '0';
                            var quantityType = item.quantity_type || 'piece';
                            
                            $('#invoiceItems').append(
                                '<tr>' +
                                '<td>' + itemNum++ + '</td>' +
                                '<td>' + item.medicine_name + '</td>' +
                                '<td>' + quantity + ' ' + quantityType + '</td>' +
                                '<td>$' + unitPrice.toFixed(2) + '</td>' +
                                '<td>$' + totalPrice.toFixed(2) + '</td>' +
                                '</tr>'
                            );
                        }
                    } else {
                        $('#invoiceItems').append(
                            '<tr><td colspan="5" class="text-center">No items found</td></tr>'
                        );
                    }
                },
                error: function() {
                    $('#invoiceItems').append(
                        '<tr><td colspan="5" class="text-center text-danger">Error loading items</td></tr>'
                    );
                }
            });
        }
    </script>
    
    <!-- Watermark -->
    <div class="print-watermark">
        <img src="assets/vafmadow.png" alt="Hospital Logo Watermark" />
    </div>
</body>
</html>
