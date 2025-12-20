<%@ Page Title="Return Transaction" Language="C#" MasterPageFile="~/pharmacy.Master" AutoEventWireup="true"
    CodeBehind="pharmacy_return_transaction.aspx.cs" Inherits="juba_hospital.pharmacy_return_transaction" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <style>
        .return-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .search-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        .sale-info-card {
            background: white;
            border: 2px solid #667eea;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .item-card {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 5px;
        }

        .return-input {
            width: 80px;
            text-align: center;
        }

        .btn-return {
            background: #dc3545;
            color: white;
        }

        .btn-return:hover {
            background: #c82333;
            color: white;
        }

        .refund-summary {
            background: #d4edda;
            border: 2px solid #28a745;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }

        .warning-text {
            color: #dc3545;
            font-weight: bold;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="return-header">
        <h3><i class="fa fa-undo"></i> Medicine Return / Revert Transaction</h3>
        <p class="mb-0">Process medicine returns and restore inventory</p>
    </div>

    <!-- Search Section -->
    <div class="search-section">
        <h5>Search Sale Transaction</h5>
        <div class="row">
            <div class="col-md-4">
                <label>Invoice Number:</label>
                <input type="text" id="txtInvoiceNumber" class="form-control" placeholder="INV-20251211-001" />
            </div>
            <div class="col-md-4">
                <label>Customer Name:</label>
                <input type="text" id="txtCustomerName" class="form-control" placeholder="Customer name" />
            </div>
            <div class="col-md-4">
                <label>&nbsp;</label>
                <button type="button" class="btn btn-primary btn-block" onclick="searchSale()">
                    <i class="fa fa-search"></i> Search Sale
                </button>
            </div>
        </div>
        <div class="row mt-3">
            <div class="col-md-12">
                <label>Or search recent sales (Last 30 days):</label>
                <button type="button" class="btn btn-sm btn-info" onclick="loadRecentSales()">
                    <i class="fa fa-list"></i> Show Recent Sales
                </button>
            </div>
        </div>
    </div>

    <!-- Recent Sales Table (Hidden by default) -->
    <div id="recentSalesSection" style="display: none;" class="mb-4">
        <div class="card">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">Recent Sales</h5>
            </div>
            <div class="card-body">
                <table id="recentSalesTable" class="table table-striped table-bordered">
                    <thead class="thead-dark">
                        <tr>
                            <th>Invoice #</th>
                            <th>Customer</th>
                            <th>Medicines</th>
                            <th>Date</th>
                            <th>Amount</th>
                            <th>Items</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody id="recentSalesBody">
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Sale Details Section -->
    <div id="saleDetailsSection" style="display: none;">
        <div class="sale-info-card">
            <h5>Original Sale Information</h5>
            <div class="row">
                <div class="col-md-3">
                    <strong>Invoice #:</strong>
                    <p id="lblInvoice">-</p>
                </div>
                <div class="col-md-3">
                    <strong>Customer:</strong>
                    <p id="lblCustomer">-</p>
                </div>
                <div class="col-md-3">
                    <strong>Sale Date:</strong>
                    <p id="lblSaleDate">-</p>
                </div>
                <div class="col-md-3">
                    <strong>Total Amount:</strong>
                    <p id="lblTotalAmount">-</p>
                </div>
            </div>
        </div>

        <!-- Items to Return -->
        <div class="card">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Select Items to Return</h5>
            </div>
            <div class="card-body">
                <div id="itemsList"></div>
            </div>
        </div>

        <!-- Return Summary -->
        <div class="refund-summary" id="returnSummary" style="display: none;">
            <h5>Return Summary</h5>
            <div class="row">
                <div class="col-md-4">
                    <strong>Total Items to Return:</strong>
                    <h4 id="summaryItemCount">0</h4>
                </div>
                <div class="col-md-4">
                    <strong>Total Quantity:</strong>
                    <h4 id="summaryQuantity">0</h4>
                </div>
                <div class="col-md-4">
                    <strong>Refund Amount:</strong>
                    <h4 class="text-success" id="summaryRefund">$0.00</h4>
                </div>
            </div>
            <hr />
            <div class="row">
                <div class="col-md-6">
                    <label>Return Reason: <span class="warning-text">*</span></label>
                    <textarea id="txtReturnReason" class="form-control" rows="3" placeholder="Enter reason for return (required)"></textarea>
                </div>
                <div class="col-md-6">
                    <label>Refund Method: <span class="warning-text">*</span></label>
                    <select id="ddlRefundMethod" class="form-control">
                        <option value="">-- Select Method --</option>
                        <option value="Cash">Cash Refund</option>
                        <option value="Credit">Store Credit</option>
                        <option value="Exchange">Exchange for Other Items</option>
                    </select>
                </div>
            </div>
            <div class="row mt-3">
                <div class="col-md-12 text-right">
                    <button type="button" class="btn btn-secondary" onclick="cancelReturn()">
                        <i class="fa fa-times"></i> Cancel
                    </button>
                    <button type="button" class="btn btn-return btn-lg" onclick="processReturn()">
                        <i class="fa fa-undo"></i> Process Return
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Return History Section -->
    <div class="card mt-4">
        <div class="card-header bg-success text-white">
            <h5 class="mb-0">Return History</h5>
        </div>
        <div class="card-body">
            <table id="returnHistoryTable" class="table table-striped table-bordered">
                <thead class="thead-dark">
                    <tr>
                        <th>Return Invoice</th>
                        <th>Original Invoice</th>
                        <th>Customer</th>
                        <th>Return Date</th>
                        <th>Items</th>
                        <th>Refund Amount</th>
                        <th>Reason</th>
                        <th>Method</th>
                    </tr>
                </thead>
                <tbody id="returnHistoryBody">
                </tbody>
            </table>
        </div>
    </div>

    <script src="Scripts/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="datatables/datatables.min.js"></script>

    <script>
        var currentSaleId = 0;
        var currentSaleItems = [];
        var selectedItems = [];

        $(document).ready(function () {
            loadReturnHistory();
        });

        // Helper function to parse .NET JSON dates
        function parseJsonDate(dateString) {
            if (!dateString) return 'N/A';
            
            try {
                // Check if it's .NET JSON date format /Date(timestamp)/
                if (dateString.indexOf('/Date(') === 0) {
                    var timestamp = parseInt(dateString.replace(/\/Date\((-?\d+)\)\//, '$1'));
                    return new Date(timestamp).toLocaleString();
                }
                
                // Try parsing as regular date string
                var date = new Date(dateString);
                if (!isNaN(date.getTime())) {
                    return date.toLocaleString();
                }
                
                return dateString; // Return as-is if can't parse
            } catch (e) {
                console.error('Date parse error:', e);
                return 'Invalid Date';
            }
        }

        function searchSale() {
            var invoice = $('#txtInvoiceNumber').val().trim();
            var customer = $('#txtCustomerName').val().trim();

            if (!invoice && !customer) {
                Swal.fire('Error', 'Please enter Invoice Number or Customer Name', 'error');
                return;
            }

            $.ajax({
                type: "POST",
                url: "pharmacy_return_transaction.aspx/SearchSale",
                data: JSON.stringify({ invoiceNumber: invoice, customerName: customer }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d && response.d.saleid > 0) {
                        displaySaleDetails(response.d);
                    } else {
                        Swal.fire('Not Found', 'No sale found with the provided information', 'warning');
                    }
                },
                error: function (error) {
                    console.error('Search error:', error);
                    Swal.fire('Error', 'Failed to search sale', 'error');
                }
            });
        }

        function loadRecentSales() {
            $.ajax({
                type: "POST",
                url: "pharmacy_return_transaction.aspx/GetRecentSales",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d && response.d.length > 0) {
                        displayRecentSales(response.d);
                        $('#recentSalesSection').show();
                    } else {
                        Swal.fire('Info', 'No recent sales found', 'info');
                    }
                },
                error: function (error) {
                    console.error('Load recent sales error:', error);
                    Swal.fire('Error', 'Failed to load recent sales', 'error');
                }
            });
        }

        function displayRecentSales(sales) {
            var tbody = $('#recentSalesBody');
            tbody.empty();

            if (sales.length === 0) {
                tbody.html('<tr><td colspan="7" class="text-center text-info">No sales available for return. All recent sales have already been returned.</td></tr>');
                return;
            }

            $.each(sales, function (index, sale) {
                var row = $('<tr>');
                row.append('<td>' + sale.invoice_number + '</td>');
                row.append('<td>' + sale.customer_name + '</td>');
                
                // Display medicines (truncate if too long)
                var medicines = sale.medicines || 'N/A';
                if (medicines.length > 50) {
                    medicines = medicines.substring(0, 50) + '...';
                }
                row.append('<td><small>' + medicines + '</small></td>');
                
                row.append('<td>' + parseJsonDate(sale.sale_date) + '</td>');
                row.append('<td>$' + sale.final_amount.toFixed(2) + '</td>');
                row.append('<td>' + sale.item_count + '</td>');
                
                var selectBtn = $('<button type="button" class="btn btn-sm btn-primary">Select</button>');
                selectBtn.click(function(e) {
                    e.preventDefault();
                    selectSale(sale.saleid);
                    return false;
                });
                
                var actionCell = $('<td>').append(selectBtn);
                row.append(actionCell);
                
                tbody.append(row);
            });
        }

        function selectSale(saleid) {
            $.ajax({
                type: "POST",
                url: "pharmacy_return_transaction.aspx/GetSaleById",
                data: JSON.stringify({ saleid: saleid }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d) {
                        displaySaleDetails(response.d);
                        $('#recentSalesSection').hide();
                    }
                },
                error: function (error) {
                    console.error('Get sale error:', error);
                    Swal.fire('Error', 'Failed to load sale details', 'error');
                }
            });
        }

        function displaySaleDetails(sale) {
            currentSaleId = sale.saleid;
            currentSaleItems = sale.items;
            selectedItems = [];

            $('#lblInvoice').text(sale.invoice_number);
            $('#lblCustomer').text(sale.customer_name);
            $('#lblSaleDate').text(parseJsonDate(sale.sale_date));
            $('#lblTotalAmount').text('$' + sale.final_amount.toFixed(2));

            var itemsHtml = '';
            $.each(sale.items, function (index, item) {
                itemsHtml += '<div class="item-card">' +
                    '<div class="row align-items-center">' +
                    '<div class="col-md-1">' +
                    '<input type="checkbox" class="form-check-input" id="chk' + item.sale_item_id + '" ' +
                    'onchange="toggleItem(' + item.sale_item_id + ')" />' +
                    '</div>' +
                    '<div class="col-md-4">' +
                    '<strong>' + item.medicine_name + '</strong><br/>' +
                    '<small class="text-muted">' + item.quantity_type + '</small>' +
                    '</div>' +
                    '<div class="col-md-2">' +
                    '<strong>Sold:</strong> ' + item.quantity + '<br/>' +
                    '<strong>Price:</strong> $' + item.unit_price.toFixed(2) +
                    '</div>' +
                    '<div class="col-md-2">' +
                    '<strong>Total:</strong> $' + item.total_price.toFixed(2) +
                    '</div>' +
                    '<div class="col-md-3">' +
                    '<label>Return Qty:</label>' +
                    '<input type="number" class="form-control return-input" id="qty' + item.sale_item_id + '" ' +
                    'min="0" max="' + item.quantity + '" value="0" step="0.1" disabled ' +
                    'onchange="updateReturnQuantity(' + item.sale_item_id + ')" />' +
                    '<small class="text-muted">Max: ' + item.quantity + '</small>' +
                    '</div>' +
                    '</div>' +
                    '</div>';
            });

            $('#itemsList').html(itemsHtml);
            $('#saleDetailsSection').show();
            updateReturnSummary();
        }

        function toggleItem(saleItemId) {
            var checkbox = $('#chk' + saleItemId);
            var qtyInput = $('#qty' + saleItemId);

            if (checkbox.is(':checked')) {
                qtyInput.prop('disabled', false);
                var item = currentSaleItems.find(i => i.sale_item_id === saleItemId);
                qtyInput.val(item.quantity); // Default to full quantity
                updateReturnQuantity(saleItemId);
            } else {
                qtyInput.prop('disabled', true);
                qtyInput.val(0);
                removeFromSelected(saleItemId);
            }
            updateReturnSummary();
        }

        function updateReturnQuantity(saleItemId) {
            var qty = parseFloat($('#qty' + saleItemId).val()) || 0;
            var item = currentSaleItems.find(i => i.sale_item_id === saleItemId);

            if (qty > item.quantity) {
                Swal.fire('Error', 'Return quantity cannot exceed sold quantity', 'error');
                $('#qty' + saleItemId).val(item.quantity);
                qty = item.quantity;
            }

            if (qty > 0) {
                addToSelected(saleItemId, qty);
            } else {
                removeFromSelected(saleItemId);
                $('#chk' + saleItemId).prop('checked', false);
            }
            updateReturnSummary();
        }

        function addToSelected(saleItemId, quantity) {
            var existing = selectedItems.find(s => s.sale_item_id === saleItemId);
            var item = currentSaleItems.find(i => i.sale_item_id === saleItemId);

            if (existing) {
                existing.return_quantity = quantity;
                existing.return_amount = quantity * item.unit_price;
            } else {
                selectedItems.push({
                    sale_item_id: saleItemId,
                    medicineid: item.medicineid,
                    inventoryid: item.inventoryid,
                    quantity_type: item.quantity_type,
                    return_quantity: quantity,
                    unit_price: item.unit_price,
                    return_amount: quantity * item.unit_price,
                    cost_price: item.cost_price
                });
            }
        }

        function removeFromSelected(saleItemId) {
            selectedItems = selectedItems.filter(s => s.sale_item_id !== saleItemId);
        }

        function updateReturnSummary() {
            if (selectedItems.length === 0) {
                $('#returnSummary').hide();
                return;
            }

            var totalQty = 0;
            var totalRefund = 0;

            $.each(selectedItems, function (index, item) {
                totalQty += item.return_quantity;
                totalRefund += item.return_amount;
            });

            $('#summaryItemCount').text(selectedItems.length);
            $('#summaryQuantity').text(totalQty.toFixed(2));
            $('#summaryRefund').text('$' + totalRefund.toFixed(2));
            $('#returnSummary').show();
        }

        function processReturn() {
            if (selectedItems.length === 0) {
                Swal.fire('Error', 'Please select at least one item to return', 'error');
                return;
            }

            var reason = $('#txtReturnReason').val().trim();
            var method = $('#ddlRefundMethod').val();

            if (!reason) {
                Swal.fire('Error', 'Please enter a return reason', 'error');
                return;
            }

            if (!method) {
                Swal.fire('Error', 'Please select a refund method', 'error');
                return;
            }

            Swal.fire({
                title: 'Confirm Return',
                text: 'Are you sure you want to process this return? This will restore inventory and adjust sales records.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, Process Return'
            }).then((result) => {
                if (result.isConfirmed) {
                    executeReturn(reason, method);
                }
            });
        }

        function executeReturn(reason, method) {
            var returnData = {
                saleid: currentSaleId,
                returnReason: reason,
                refundMethod: method,
                items: selectedItems
            };

            $.ajax({
                type: "POST",
                url: "pharmacy_return_transaction.aspx/ProcessReturn",
                data: JSON.stringify(returnData),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d && response.d.success) {
                        Swal.fire({
                            title: 'Success!',
                            html: 'Return processed successfully<br/>Return Invoice: <strong>' + response.d.return_invoice + '</strong>',
                            icon: 'success'
                        }).then(() => {
                            cancelReturn();
                            loadReturnHistory();
                        });
                    } else {
                        Swal.fire('Error', response.d.message || 'Failed to process return', 'error');
                    }
                },
                error: function (error) {
                    console.error('Process return error:', error);
                    Swal.fire('Error', 'Failed to process return: ' + (error.responseJSON ? error.responseJSON.Message : 'Unknown error'), 'error');
                }
            });
        }

        function cancelReturn() {
            currentSaleId = 0;
            currentSaleItems = [];
            selectedItems = [];
            $('#saleDetailsSection').hide();
            $('#txtInvoiceNumber').val('');
            $('#txtCustomerName').val('');
            $('#txtReturnReason').val('');
            $('#ddlRefundMethod').val('');
        }

        function loadReturnHistory() {
            $.ajax({
                type: "POST",
                url: "pharmacy_return_transaction.aspx/GetReturnHistory",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d) {
                        displayReturnHistory(response.d);
                    }
                },
                error: function (error) {
                    console.error('Load history error:', error);
                }
            });
        }

        function displayReturnHistory(returns) {
            var tbody = $('#returnHistoryBody');
            tbody.empty();

            if (returns.length === 0) {
                tbody.html('<tr><td colspan="8" class="text-center">No return history found</td></tr>');
                return;
            }

            $.each(returns, function (index, ret) {
                var row = '<tr>' +
                    '<td>' + ret.return_invoice + '</td>' +
                    '<td>' + ret.original_invoice + '</td>' +
                    '<td>' + ret.customer_name + '</td>' +
                    '<td>' + parseJsonDate(ret.return_date) + '</td>' +
                    '<td>' + ret.items_returned + '</td>' +
                    '<td>$' + ret.total_return_amount.toFixed(2) + '</td>' +
                    '<td>' + ret.return_reason + '</td>' +
                    '<td>' + ret.refund_method + '</td>' +
                    '</tr>';
                tbody.append(row);
            });
        }
    </script>
</asp:Content>
