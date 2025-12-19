<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="medicine_sales_report.aspx.cs" Inherits="juba_hospital.medicine_sales_report" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

        <link href="datatables/datatables.min.css" rel="stylesheet" />
        <style>
            .stats-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 20px;
            }

            .stats-card.success {
                background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            }

            .stats-card.warning {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            }

            .stats-card.info {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            }

            .stats-value {
                font-size: 2.5rem;
                font-weight: bold;
                margin: 10px 0;
            }

            .stats-label {
                font-size: 0.9rem;
                opacity: 0.9;
            }

            .filter-section {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 20px;
            }

            .profit-positive {
                color: #28a745;
                font-weight: bold;
            }

            .profit-negative {
                color: #dc3545;
                font-weight: bold;
            }

            .top-medicine {
                background: #fff3cd;
            }
            
            /* Fix DataTable header styling */
            #medicineReportTable thead th {
                background-color: #343a40 !important;
                color: white !important;
                font-weight: bold;
            }
            
            .dataTables_wrapper .dataTables_paginate .paginate_button {
                color: #333 !important;
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <div class="row">
            <div class="col-md-12">
                <h3><i class="fa fa-pills"></i> Medicine Sales & Profit Reports</h3>
                <p class="text-muted">Detailed sales and profit analysis for each medicine</p>
            </div>
        </div>

        <!-- Summary Cards -->
        <div class="row">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-label">Total Revenue</div>
                    <div class="stats-value" id="totalRevenue">$0.00</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card success">
                    <div class="stats-label">Total Profit</div>
                    <div class="stats-value" id="totalProfit">$0.00</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card warning">
                    <div class="stats-label">Total Cost</div>
                    <div class="stats-value" id="totalCost">$0.00</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card info">
                    <div class="stats-label">Medicines Sold</div>
                    <div class="stats-value" id="medicineCount">0</div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="filter-section">
            <div class="row">
                <div class="col-md-3">
                    <label>Start Date:</label>
                    <input type="date" id="startDate" class="form-control" />
                </div>
                <div class="col-md-3">
                    <label>End Date:</label>
                    <input type="date" id="endDate" class="form-control" />
                </div>
                <div class="col-md-3">
                    <label>Medicine:</label>
                    <input type="text" id="medicineFilter" class="form-control" placeholder="Filter by medicine name..." />
                </div>
                <div class="col-md-3">
                    <label>&nbsp;</label>
                    <div>
                        <button type="button" class="btn btn-primary btn-block" onclick="loadReport()">
                            <i class="fa fa-search"></i> Load Report
                        </button>
                    </div>
                </div>
            </div>
            <div class="row mt-2">
                <div class="col-md-3">
                    <button type="button" class="btn btn-secondary btn-sm" onclick="setToday()">Today</button>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="setThisWeek()">This Week</button>
                    <button type="button" class="btn btn-secondary btn-sm" onclick="setThisMonth()">This Month</button>
                </div>
                <div class="col-md-3">
                    <button type="button" class="btn btn-success btn-sm" onclick="exportToExcel()">
                        <i class="fa fa-file-excel"></i> Export to Excel
                    </button>
                    <button type="button" class="btn btn-info btn-sm" onclick="printReport()">
                        <i class="fa fa-print"></i> Print Report
                    </button>
                </div>
            </div>
        </div>

        <!-- Report Table -->
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Medicine-wise Sales Report</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table id="medicineReportTable" class="table table-striped table-bordered table-hover">
                                <thead class="thead-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Medicine Name</th>
                                        <th>Generic Name</th>
                                        <th>Total Qty Sold</th>
                                        <th>Unit Types</th>
                                        <th>Total Revenue</th>
                                        <th>Total Cost</th>
                                        <th>Total Profit</th>
                                        <th>Profit Margin %</th>
                                        <th>Avg. Selling Price</th>
                                        <th>Times Sold</th>
                                    </tr>
                                </thead>
                                <tbody id="reportTableBody">
                                    <tr>
                                        <td colspan="11" class="text-center">
                                            <i class="fa fa-spinner fa-spin"></i> Loading data...
                                        </td>
                                    </tr>
                                </tbody>
                                <tfoot>
                                    <tr class="table-primary font-weight-bold">
                                        <th colspan="5" class="text-right">TOTALS:</th>
                                        <th id="footerRevenue">$0.00</th>
                                        <th id="footerCost">$0.00</th>
                                        <th id="footerProfit">$0.00</th>
                                        <th id="footerMargin">0%</th>
                                        <th colspan="2"></th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Detailed View Modal -->
        <div class="modal fade" id="detailsModal" tabindex="-1">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">Medicine Details: <span id="modalMedicineName"></span></h5>
                        <button type="button" class="close text-white" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-3">
                                <div class="card text-center">
                                    <div class="card-body">
                                        <h6>Total Revenue</h6>
                                        <h4 id="detailRevenue">$0.00</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card text-center">
                                    <div class="card-body">
                                        <h6>Total Profit</h6>
                                        <h4 id="detailProfit" class="text-success">$0.00</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card text-center">
                                    <div class="card-body">
                                        <h6>Quantity Sold</h6>
                                        <h4 id="detailQuantity">0</h4>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="card text-center">
                                    <div class="card-body">
                                        <h6>Profit Margin</h6>
                                        <h4 id="detailMargin">0%</h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <h5>Sales Breakdown by Unit Type</h5>
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Unit Type</th>
                                    <th>Quantity Sold</th>
                                    <th>Revenue</th>
                                    <th>Cost</th>
                                    <th>Profit</th>
                                </tr>
                            </thead>
                            <tbody id="detailBreakdownBody">
                            </tbody>
                        </table>
                        <h5 class="mt-4">Recent Transactions</h5>
                        <table class="table table-sm table-striped">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Invoice #</th>
                                    <th>Quantity</th>
                                    <th>Unit Type</th>
                                    <th>Unit Price</th>
                                    <th>Total</th>
                                    <th>Profit</th>
                                </tr>
                            </thead>
                            <tbody id="detailTransactionsBody">
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="Scripts/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

        <script>
            var dataTable;
            var dataTablesLoaded = false;

            $(document).ready(function () {
                console.log('jQuery loaded:', $.fn.jquery);
                console.log('XLSX loaded:', typeof XLSX !== 'undefined');
                
                // Load DataTables dynamically
                loadDataTablesLibrary();
            });
            
            function loadDataTablesLibrary() {
                console.log('Loading DataTables library...');
                var script = document.createElement('script');
                script.src = 'datatables/datatables.min.js';
                script.onload = function() {
                    console.log('DataTables loaded successfully');
                    dataTablesLoaded = true;
                    // Set default dates and load report after DataTables is ready
                    setToday();
                    loadReport();
                };
                script.onerror = function() {
                    console.error('Failed to load DataTables library');
                    Swal.fire('Error', 'Failed to load DataTables library. Please refresh the page.', 'error');
                };
                document.head.appendChild(script);
            }

            // Helper function to format date as YYYY-MM-DD in local timezone
            function formatLocalDate(date) {
                var year = date.getFullYear();
                var month = String(date.getMonth() + 1).padStart(2, '0');
                var day = String(date.getDate()).padStart(2, '0');
                return year + '-' + month + '-' + day;
            }

            function setToday() {
                var today = formatLocalDate(new Date());
                $('#startDate').val(today);
                $('#endDate').val(today);
            }

            function setThisWeek() {
                var today = new Date();
                var dayOfWeek = today.getDay();
                var firstDay = new Date(today);
                firstDay.setDate(today.getDate() - dayOfWeek);
                var lastDay = new Date(today);
                lastDay.setDate(today.getDate() + (6 - dayOfWeek));
                
                $('#startDate').val(formatLocalDate(firstDay));
                $('#endDate').val(formatLocalDate(lastDay));
            }

            function setThisMonth() {
                var today = new Date();
                var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
                var lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
                $('#startDate').val(formatLocalDate(firstDay));
                $('#endDate').val(formatLocalDate(lastDay));
            }

            function loadReport() {
                var startDate = $('#startDate').val();
                var endDate = $('#endDate').val();

                if (!startDate || !endDate) {
                    Swal.fire('Error', 'Please select both start and end dates', 'error');
                    return;
                }

                // Show loading
                $('#reportTableBody').html('<tr><td colspan="11" class="text-center"><i class="fa fa-spinner fa-spin"></i> Loading data...</td></tr>');

                $.ajax({
                    type: "POST",
                    url: "medicine_sales_report.aspx/GetMedicineSalesReport",
                    data: JSON.stringify({
                        startDate: startDate,
                        endDate: endDate
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d) {
                            displayReport(response.d);
                        }
                    },
                    error: function (error) {
                        console.error('Error loading report:', error);
                        Swal.fire('Error', 'Failed to load report data', 'error');
                        $('#reportTableBody').html('<tr><td colspan="11" class="text-center text-danger">Error loading data</td></tr>');
                    }
                });
            }

            function displayReport(data) {
                // Update summary cards
                $('#totalRevenue').text('$' + (data.summary.total_revenue || 0).toFixed(2));
                $('#totalProfit').text('$' + (data.summary.total_profit || 0).toFixed(2));
                $('#totalCost').text('$' + (data.summary.total_cost || 0).toFixed(2));
                $('#medicineCount').text(data.medicines.length);

                // Clear existing table
                if (dataTable) {
                    dataTable.destroy();
                }

                var tbody = $('#reportTableBody');
                tbody.empty();

                if (data.medicines.length === 0) {
                    tbody.html('<tr><td colspan="11" class="text-center">No sales data found for the selected period</td></tr>');
                    return;
                }

                // Populate table
                $.each(data.medicines, function (index, medicine) {
                    var profitMargin = medicine.total_revenue > 0 ? ((medicine.total_profit / medicine.total_revenue) * 100).toFixed(2) : 0;
                    var avgPrice = medicine.transaction_count > 0 ? (medicine.total_revenue / medicine.total_quantity_sold).toFixed(2) : 0;
                    var profitClass = medicine.total_profit >= 0 ? 'profit-positive' : 'profit-negative';
                    var rowClass = index < 3 ? 'top-medicine' : ''; // Highlight top 3 medicines

                    var row = '<tr class="' + rowClass + '" onclick="viewMedicineDetails(' + medicine.medicineid + ', \'' + medicine.medicine_name.replace(/'/g, "\\'") + '\')" style="cursor: pointer;">' +
                        '<td>' + (index + 1) + '</td>' +
                        '<td><strong>' + medicine.medicine_name + '</strong></td>' +
                        '<td>' + (medicine.generic_name || '-') + '</td>' +
                        '<td>' + medicine.total_quantity_sold + '</td>' +
                        '<td>' + medicine.unit_types + '</td>' +
                        '<td>$' + medicine.total_revenue.toFixed(2) + '</td>' +
                        '<td>$' + medicine.total_cost.toFixed(2) + '</td>' +
                        '<td class="' + profitClass + '">$' + medicine.total_profit.toFixed(2) + '</td>' +
                        '<td>' + profitMargin + '%</td>' +
                        '<td>$' + avgPrice + '</td>' +
                        '<td>' + medicine.transaction_count + '</td>' +
                        '</tr>';
                    tbody.append(row);
                });

                // Check if DataTables is loaded
                if (typeof $.fn.DataTable === 'undefined') {
                    console.error('DataTables not loaded yet!');
                    Swal.fire('Error', 'DataTables library not loaded. Please refresh the page.', 'error');
                    return;
                }

                // Initialize DataTable with sorting FIRST
                dataTable = $('#medicineReportTable').DataTable({
                    "order": [[5, "desc"]], // Sort by revenue descending
                    "pageLength": 25,
                    "dom": 'Bfrtip',
                    "buttons": [],
                    "footerCallback": function () {
                        // Update footer AFTER DataTable initialization
                        var totalMargin = data.summary.total_revenue > 0 ? ((data.summary.total_profit / data.summary.total_revenue) * 100).toFixed(2) : 0;
                        $('#footerRevenue').text('$' + data.summary.total_revenue.toFixed(2));
                        $('#footerCost').text('$' + data.summary.total_cost.toFixed(2));
                        $('#footerProfit').text('$' + data.summary.total_profit.toFixed(2));
                        $('#footerMargin').text(totalMargin + '%');
                    }
                });

                // Apply medicine name filter if exists
                var filter = $('#medicineFilter').val();
                if (filter) {
                    dataTable.column(1).search(filter).draw();
                }
            }

            function viewMedicineDetails(medicineid, medicineName) {
                $('#modalMedicineName').text(medicineName);

                var startDate = $('#startDate').val();
                var endDate = $('#endDate').val();

                $.ajax({
                    type: "POST",
                    url: "medicine_sales_report.aspx/GetMedicineDetails",
                    data: JSON.stringify({
                        medicineid: medicineid,
                        startDate: startDate,
                        endDate: endDate
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (response.d) {
                            displayMedicineDetails(response.d);
                            $('#detailsModal').modal('show');
                        }
                    },
                    error: function (error) {
                        console.error('Error loading details:', error);
                        Swal.fire('Error', 'Failed to load medicine details', 'error');
                    }
                });
            }

            function displayMedicineDetails(data) {
                // Update summary
                $('#detailRevenue').text('$' + data.total_revenue.toFixed(2));
                $('#detailProfit').text('$' + data.total_profit.toFixed(2));
                $('#detailQuantity').text(data.total_quantity_sold);
                var margin = data.total_revenue > 0 ? ((data.total_profit / data.total_revenue) * 100).toFixed(2) : 0;
                $('#detailMargin').text(margin + '%');

                // Breakdown by unit type
                var breakdownBody = $('#detailBreakdownBody');
                breakdownBody.empty();
                $.each(data.breakdown, function (index, item) {
                    var row = '<tr>' +
                        '<td>' + item.quantity_type + '</td>' +
                        '<td>' + item.quantity_sold + '</td>' +
                        '<td>$' + item.revenue.toFixed(2) + '</td>' +
                        '<td>$' + item.cost.toFixed(2) + '</td>' +
                        '<td>$' + item.profit.toFixed(2) + '</td>' +
                        '</tr>';
                    breakdownBody.append(row);
                });

                // Recent transactions
                var transBody = $('#detailTransactionsBody');
                transBody.empty();
                $.each(data.transactions, function (index, trans) {
                    // Format date properly - handle Microsoft JSON date format /Date(timestamp)/
                    var dateStr = trans.sale_date;
                    var formattedDate = '';
                    try {
                        if (dateStr) {
                            var date;
                            // Check if it's Microsoft JSON date format: /Date(timestamp)/
                            if (typeof dateStr === 'string' && dateStr.indexOf('/Date(') === 0) {
                                var timestamp = parseInt(dateStr.match(/\d+/)[0]);
                                date = new Date(timestamp);
                            } else {
                                // Regular date string
                                date = new Date(dateStr);
                            }
                            
                            if (!isNaN(date.getTime())) {
                                formattedDate = date.toLocaleDateString();
                            } else {
                                formattedDate = dateStr; // Use original string if parsing fails
                            }
                        } else {
                            formattedDate = 'N/A';
                        }
                    } catch (e) {
                        formattedDate = dateStr || 'N/A';
                    }
                    
                    var row = '<tr>' +
                        '<td>' + formattedDate + '</td>' +
                        '<td>' + trans.invoice_number + '</td>' +
                        '<td>' + trans.quantity + '</td>' +
                        '<td>' + trans.quantity_type + '</td>' +
                        '<td>$' + trans.unit_price.toFixed(2) + '</td>' +
                        '<td>$' + trans.total_price.toFixed(2) + '</td>' +
                        '<td>$' + trans.profit.toFixed(2) + '</td>' +
                        '</tr>';
                    transBody.append(row);
                });
            }

            function exportToExcel() {
                if (!dataTable) {
                    Swal.fire('Error', 'No data to export', 'error');
                    return;
                }

                // Check if XLSX is loaded
                if (typeof XLSX === 'undefined') {
                    Swal.fire('Error', 'Excel library not loaded. Please refresh the page.', 'error');
                    return;
                }

                try {
                    var startDate = $('#startDate').val();
                    var endDate = $('#endDate').val();
                    
                    // Create a workbook
                    var wb = XLSX.utils.book_new();
                    
                    // Get table data
                    var table = document.getElementById('medicineReportTable');
                    var ws = XLSX.utils.table_to_sheet(table);
                    
                    // Add worksheet to workbook
                    XLSX.utils.book_append_sheet(wb, ws, 'Medicine Sales');
                    
                    // Generate filename
                    var filename = 'Medicine_Sales_Report_' + startDate + '_to_' + endDate + '.xlsx';
                    
                    // Save file
                    XLSX.writeFile(wb, filename);
                    
                    Swal.fire('Success', 'Report exported successfully', 'success');
                } catch (error) {
                    console.error('Export error:', error);
                    Swal.fire('Error', 'Failed to export: ' + error.message, 'error');
                }
            }

            function printReport() {
                // Create a print-friendly version
                var printWindow = window.open('', '_blank');
                var startDate = $('#startDate').val();
                var endDate = $('#endDate').val();
                
                var printContent = `
                    <!DOCTYPE html>
                    <html>
                    <head>
                        <title>Medicine Sales Report</title>
                        <style>
                            body { font-family: Arial, sans-serif; margin: 20px; }
                            h1 { text-align: center; color: #333; }
                            .header-info { text-align: center; margin-bottom: 20px; }
                            .summary { display: flex; justify-content: space-around; margin: 20px 0; }
                            .summary-card { border: 1px solid #ddd; padding: 15px; border-radius: 5px; text-align: center; }
                            .summary-card h3 { margin: 0; color: #666; font-size: 14px; }
                            .summary-card .value { font-size: 24px; font-weight: bold; color: #333; margin-top: 5px; }
                            table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                            th, td { border: 1px solid #ddd; padding: 8px; text-align: left; font-size: 12px; }
                            th { background-color: #4CAF50 !important; color: white !important; }
                            tr:nth-child(even) { background-color: #f2f2f2; }
                            .profit-positive { color: green; font-weight: bold; }
                            .profit-negative { color: red; font-weight: bold; }
                            .footer { margin-top: 30px; text-align: center; font-size: 10px; color: #666; }
                            @media print {
                                button { display: none; }
                            }
                        </style>
                    </head>
                    <body>
                        <h1>Medicine Sales & Profit Report</h1>
                        <div class="header-info">
                            <p><strong>Report Period:</strong> ${startDate} to ${endDate}</p>
                            <p><strong>Generated:</strong> ${new Date().toLocaleString()}</p>
                        </div>
                        
                        <div class="summary">
                            <div class="summary-card">
                                <h3>Total Revenue</h3>
                                <div class="value">${$('#totalRevenue').text()}</div>
                            </div>
                            <div class="summary-card">
                                <h3>Total Profit</h3>
                                <div class="value">${$('#totalProfit').text()}</div>
                            </div>
                            <div class="summary-card">
                                <h3>Total Cost</h3>
                                <div class="value">${$('#totalCost').text()}</div>
                            </div>
                            <div class="summary-card">
                                <h3>Medicines Sold</h3>
                                <div class="value">${$('#medicineCount').text()}</div>
                            </div>
                        </div>
                        
                        <table>
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Medicine Name</th>
                                    <th>Generic Name</th>
                                    <th>Qty Sold</th>
                                    <th>Unit Types</th>
                                    <th>Revenue</th>
                                    <th>Cost</th>
                                    <th>Profit</th>
                                    <th>Margin %</th>
                                    <th>Avg Price</th>
                                    <th>Sales Count</th>
                                </tr>
                            </thead>
                            <tbody>
                `;
                
                // Add table rows
                $('#reportTableBody tr').each(function(index) {
                    var cells = $(this).find('td');
                    if (cells.length > 0) {
                        printContent += '<tr>';
                        cells.each(function() {
                            var text = $(this).text().trim();
                            var className = $(this).hasClass('profit-positive') ? 'profit-positive' : 
                                          $(this).hasClass('profit-negative') ? 'profit-negative' : '';
                            printContent += '<td class="' + className + '">' + text + '</td>';
                        });
                        printContent += '</tr>';
                    }
                });
                
                printContent += `
                            </tbody>
                            <tfoot>
                                <tr style="background-color: #e3f2fd; font-weight: bold;">
                                    <td colspan="5" style="text-align: right;">TOTALS:</td>
                                    <td>${$('#footerRevenue').text()}</td>
                                    <td>${$('#footerCost').text()}</td>
                                    <td>${$('#footerProfit').text()}</td>
                                    <td>${$('#footerMargin').text()}</td>
                                    <td colspan="2"></td>
                                </tr>
                            </tfoot>
                        </table>
                        
                        <div class="footer">
                            <p>This report was generated from the Hospital Management System</p>
                        </div>
                    </body>
                    </html>
                `;
                
                // Add script separately to avoid nesting issues
                printContent += '<script>';
                printContent += 'window.onload = function() {';
                printContent += '    window.print();';
                printContent += '    window.onafterprint = function() {';
                printContent += '        window.close();';
                printContent += '    }';
                printContent += '}';
                printContent += '<' + '/script>';
                
                printWindow.document.write(printContent);
                printWindow.document.close();
            }

            // Apply filter on keyup
            $('#medicineFilter').on('keyup', function () {
                var searchValue = this.value;
                console.log('Searching for:', searchValue);
                
                if (dataTable && dataTablesLoaded) {
                    dataTable.column(1).search(searchValue).draw();
                    console.log('Filter applied. Rows shown:', dataTable.rows({search: 'applied'}).count());
                } else {
                    console.warn('DataTable not initialized yet. Please wait for report to load.');
                }
            });
            
            // Also trigger search on paste
            $('#medicineFilter').on('paste', function () {
                var input = this;
                setTimeout(function() {
                    $(input).trigger('keyup');
                }, 10);
            });
        </script>

    </asp:Content>
