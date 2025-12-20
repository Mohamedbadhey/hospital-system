<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="pharmacy_sales_reports.aspx.cs" Inherits="juba_hospital.pharmacy_sales_reports" %>

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
        </style>
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <div class="row">
            <div class="col-md-12">
                <h3>Pharmacy Sales & Profit Reports</h3>
            </div>
        </div>

        <!-- Summary Cards -->
        <div class="row">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-label">Selected Period Sales</div>
                    <div class="stats-value" id="todaySales">$0.00</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card success">
                    <div class="stats-label">Selected Period Profit</div>
                    <div class="stats-value" id="todayProfit">$0.00</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card warning">
                    <div class="stats-label">This Month's Sales</div>
                    <div class="stats-value" id="monthSales">$0.00</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card info">
                    <div class="stats-label">This Month's Profit</div>
                    <div class="stats-value" id="monthProfit">$0.00</div>
                </div>
            </div>
        </div>

        <!-- Period Summary Cards (Based on Date Range) -->
        <div class="row" id="periodSummary" style="display: none;">
            <div class="col-md-12">
                <div class="card" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                    <div class="card-body">
                        <h5 class="text-white mb-3">Selected Period Summary (<span id="periodRange"></span>)</h5>
                        <div class="row">
                            <div class="col-md-2">
                                <div class="mb-2">
                                    <small class="d-block" style="opacity: 0.9;">Total Sales</small>
                                    <h4 class="mb-0" id="periodTotalSales">$0.00</h4>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="mb-2">
                                    <small class="d-block" style="opacity: 0.9;">Total Cost</small>
                                    <h4 class="mb-0" id="periodTotalCost">$0.00</h4>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="mb-2">
                                    <small class="d-block" style="opacity: 0.9;">Total Profit</small>
                                    <h4 class="mb-0" id="periodTotalProfit">$0.00</h4>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="mb-2">
                                    <small class="d-block" style="opacity: 0.9;">Profit Margin</small>
                                    <h4 class="mb-0" id="periodProfitMargin">0%</h4>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="mb-2">
                                    <small class="d-block" style="opacity: 0.9;">Total Transactions</small>
                                    <h4 class="mb-0" id="periodTransactions">0</h4>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="mb-2">
                                    <small class="d-block" style="opacity: 0.9;">Avg. Sale Value</small>
                                    <h4 class="mb-0" id="periodAvgSale">$0.00</h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Date Range Filter -->
        <div class="row">
            <div class="col-md-12">
                <div class="filter-section">
                    <div class="row">
                        <div class="col-md-3">
                            <label>From Date</label>
                            <input type="date" class="form-control" id="fromDate" />
                        </div>
                        <div class="col-md-3">
                            <label>To Date</label>
                            <input type="date" class="form-control" id="toDate" />
                        </div>
                        <div class="col-md-2">
                            <label>&nbsp;</label>
                            <button type="button" class="btn btn-primary form-control" onclick="generatePeriodReport(); return false;">
                                <i class="fas fa-chart-line"></i> Generate Report
                            </button>
                        </div>
                        <div class="col-md-2">
                            <label>&nbsp;</label>
                            <button class="btn btn-secondary form-control" onclick="resetFilters()">
                                <i class="fas fa-redo"></i> Reset
                            </button>
                        </div>
                        <div class="col-md-2">
                            <label>&nbsp;</label>
                            <button type="button" class="btn btn-success form-control" onclick="printSalesReport()">
                                <i class="fas fa-print"></i> Print Report
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sales Report Table -->
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h4 class="card-title">Sales Report</h4>
                    </div>
                    <div class="card-body">
                        <table class="display nowrap" style="width:100%" id="salesTable">
                            <thead>
                                <tr>
                                    <th>Medicine(s)</th>
                                    <th>Date & Time</th>
                                    <th>Customer</th>
                                    <th>Qty Sold</th>
                                    <th>Details</th>
                                    <th>Total Amount</th>
                                    <th>Cost</th>
                                    <th>Profit</th>
                                    <th>Profit %</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Top Selling Medicines -->
        <div class="row mt-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h4 class="card-title">Top Selling Medicines</h4>
                    </div>
                    <div class="card-body">
                        <table class="display nowrap" style="width:100%" id="topMedicinesTable">
                            <thead>
                                <tr>
                                    <th>Medicine Name</th>
                                    <th>Total Quantity Sold</th>
                                    <th>Total Revenue</th>
                                    <th>Total Profit</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Load jQuery -->
        <script src="Scripts/jquery-3.4.1.min.js"></script>
        
        <!-- Load SweetAlert2 -->
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <script>
            // Function to initialize everything after jQuery is loaded
            function initSalesReportsPage() {
                if (typeof jQuery === 'undefined' || typeof $ === 'undefined') {
                    // jQuery not ready yet, try again
                    setTimeout(initSalesReportsPage, 100);
                    return;
                }

                // jQuery is available, proceed with initialization
                $(document).ready(function () {
                    console.log('jQuery confirmed available, loading DataTables...');
                    loadDataTablesLibrary();
                });
            }

            // Start the initialization process immediately
            initSalesReportsPage();

            function loadDataTablesLibrary() {
                // Dynamically load DataTables after jQuery is confirmed loaded
                var script = document.createElement('script');
                script.src = 'datatables/datatables.min.js';
                script.onload = function() {
                    console.log('DataTables library loaded successfully');
                    initializeDataTables();
                };
                script.onerror = function() {
                    console.error('Failed to load DataTables library');
                };
                document.head.appendChild(script);
            }

            function initializeDataTables() {
                try {
                    // Set default dates - using local time, not UTC
                    var now = new Date();
                    var year = now.getFullYear();
                    var month = String(now.getMonth() + 1).padStart(2, '0');
                    var day = String(now.getDate()).padStart(2, '0');
                    var today = year + '-' + month + '-' + day;
                    
                    // Set default date range to TODAY
                    $('#toDate').val(today);
                    $('#fromDate').val(today);
                    
                    console.log('Initial dates set - From:', today, 'To:', today);

                    // Initialize DataTables with responsive design and export buttons
                    $('#salesTable').DataTable({
                        responsive: true,
                        dom: 'Bfrtip',
                        buttons: [
                            {
                                extend: 'excelHtml5',
                                text: '<i class="fas fa-file-excel"></i> Excel',
                                className: 'btn btn-success btn-sm'
                            },
                            {
                                extend: 'pdfHtml5',
                                text: '<i class="fas fa-file-pdf"></i> PDF',
                                className: 'btn btn-danger btn-sm'
                            },
                            {
                                extend: 'print',
                                text: '<i class="fas fa-print"></i> Print',
                                className: 'btn btn-info btn-sm'
                            }
                        ],
                        columnDefs: [
                            {
                                targets: 1, // Date column
                                type: 'date',
                                render: function(data, type, row) {
                                    if (type === 'sort' || type === 'type') {
                                        // For sorting, return the raw datetime string
                                        return data;
                                    }
                                    // For display, format the datetime
                                    if (data) {
                                        var date = new Date(data);
                                        var year = date.getFullYear();
                                        var month = String(date.getMonth() + 1).padStart(2, '0');
                                        var day = String(date.getDate()).padStart(2, '0');
                                        var hours = String(date.getHours()).padStart(2, '0');
                                        var minutes = String(date.getMinutes()).padStart(2, '0');
                                        var seconds = String(date.getSeconds()).padStart(2, '0');
                                        return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
                                    }
                                    return data;
                                }
                            }
                        ],
                        order: [[1, 'desc']], // Order by Date column (index 1) in descending order (newest first)
                        pageLength: 25,
                        language: {
                            search: "🔍 Search sales reports:",
                            lengthMenu: "Show _MENU_ reports per page",
                            info: "Showing _START_ to _END_ of _TOTAL_ reports"
                        }
                    });

                    $('#topMedicinesTable').DataTable({
                        responsive: true,
                        dom: 'Bfrtip',
                        buttons: [
                            {
                                extend: 'excelHtml5',
                                text: '<i class="fas fa-file-excel"></i> Excel',
                                className: 'btn btn-success btn-sm'
                            },
                            {
                                extend: 'pdfHtml5',
                                text: '<i class="fas fa-file-pdf"></i> PDF',
                                className: 'btn btn-danger btn-sm'
                            }
                        ],
                        pageLength: 15,
                        language: {
                            search: "🔍 Search medicines:",
                            info: "Showing _START_ to _END_ of _TOTAL_ medicines"
                        }
                    });

                    console.log('DataTables initialized successfully');

                    // Auto-load today's data on page load
                    console.log('Auto-loading today\'s sales...');
                    loadSummaryStats();
                    loadSalesReport();
                    loadTopMedicines();
                    
                    // Attach view button click handler after DataTables is initialized
                    $(document).on('click', '.view-items-btn', function (e) {
                        e.preventDefault();
                        e.stopPropagation();
                        var saleId = $(this).data('saleid');
                        console.log('View items clicked for sale ID:', saleId);
                        loadSaleItems(saleId);
                        return false;
                    });
                } catch (error) {
                    console.error('Error initializing DataTables:', error);
                }
            }

            function loadSummaryStats() {
                var fromDate = $('#fromDate').val();
                var toDate = $('#toDate').val();
                
                console.log('=== SUMMARY STATS DEBUG ===');
                console.log('From Date:', fromDate);
                console.log('To Date:', toDate);
                
                $.ajax({
                    type: "POST",
                    url: "pharmacy_sales_reports.aspx/getSummaryStats",
                    data: JSON.stringify({ fromDate: fromDate, toDate: toDate }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                        console.log('Summary Stats Response:', r);
                        
                        if (r.d) {
                            console.log('Period Sales:', r.d.todaySales);
                            console.log('Period Profit:', r.d.todayProfit);
                            console.log('Month Sales:', r.d.monthSales);
                            console.log('Month Profit:', r.d.monthProfit);
                            
                            $('#todaySales').text('$' + parseFloat(r.d.todaySales || 0).toFixed(2));
                            $('#todayProfit').text('$' + parseFloat(r.d.todayProfit || 0).toFixed(2));
                            $('#monthSales').text('$' + parseFloat(r.d.monthSales || 0).toFixed(2));
                            $('#monthProfit').text('$' + parseFloat(r.d.monthProfit || 0).toFixed(2));
                        } else {
                            console.warn('No summary stats data returned!');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error("=== SUMMARY STATS ERROR ===");
                        console.error("Status:", status);
                        console.error("Error:", error);
                        console.error("Response:", xhr.responseText);
                        try {
                            var errorObj = JSON.parse(xhr.responseText);
                            console.error("Parsed Error:", errorObj);
                        } catch (e) {
                            console.error("Could not parse error response");
                        }
                    }
                });
            }

            function generatePeriodReport() {
                loadSummaryStats();
                loadSalesReport();
                loadTopMedicines();
                calculatePeriodSummary();
            }

            function loadSalesReport() {
                var fromDate = $('#fromDate').val();
                var toDate = $('#toDate').val();

                console.log('=== SALES REPORT DEBUG ===');
                console.log('From Date:', fromDate);
                console.log('To Date:', toDate);

                $.ajax({
                    type: "POST",
                    url: "pharmacy_sales_reports.aspx/getSalesReport",
                    data: JSON.stringify({ fromDate: fromDate, toDate: toDate }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                        console.log('Sales Report Response:', r);
                        console.log('Number of sales returned:', r.d ? r.d.length : 0);
                        
                        if (r.d && r.d.length > 0) {
                            console.log('First sale data:', r.d[0]);
                        } else {
                            console.warn('No sales data returned from backend!');
                        }

                        var table = $('#salesTable').DataTable({
                            responsive: true,
                            autoWidth: false,
                            destroy: true,
                            columnDefs: [
                                { responsivePriority: 1, targets: 0 }, // Medicine Names
                                { responsivePriority: 2, targets: -1 }, // Status
                                {
                                    targets: 1, // Date column
                                    type: 'date',
                                    render: function(data, type, row) {
                                        if (type === 'sort' || type === 'type') {
                                            // For sorting, return the raw datetime string
                                            return data;
                                        }
                                        // For display, format the datetime
                                        if (data) {
                                            var date = new Date(data);
                                            var year = date.getFullYear();
                                            var month = String(date.getMonth() + 1).padStart(2, '0');
                                            var day = String(date.getDate()).padStart(2, '0');
                                            var hours = String(date.getHours()).padStart(2, '0');
                                            var minutes = String(date.getMinutes()).padStart(2, '0');
                                            var seconds = String(date.getSeconds()).padStart(2, '0');
                                            return year + '-' + month + '-' + day + ' ' + hours + ':' + minutes + ':' + seconds;
                                        }
                                        return data;
                                    }
                                }
                            ],
                            order: [[1, 'desc']] // Order by Date column (index 1) in descending order (newest first)
                        });
                        table.clear();

                        var totalSales = 0;
                        var totalCost = 0;
                        var totalProfit = 0;

                        for (var i = 0; i < r.d.length; i++) {
                            var sale = r.d[i];
                            console.log('Processing sale ' + (i+1) + ':', sale);
                            
                            var totalAmount = parseFloat(sale.total_amount) || 0;
                            var saleCost = parseFloat(sale.total_cost) || 0;
                            var profit = parseFloat(sale.profit) || 0;
                            var profitPercent = totalAmount > 0 ? ((profit / totalAmount) * 100).toFixed(2) : 0;

                            totalSales += totalAmount;
                            totalCost += saleCost;
                            totalProfit += profit;

                            console.log('  Total Amount:', totalAmount);
                            console.log('  Total Cost:', saleCost);
                            console.log('  Profit:', profit);
                            console.log('  Profit %:', profitPercent);

                            // Format medicine names display
                            var medicineDisplay = '';
                            if (sale.medicine_names) {
                                var medicineCount = parseInt(sale.medicine_count) || 0;
                                var names = sale.medicine_names.split(', ');
                                
                                if (medicineCount === 1) {
                                    // Single medicine - show full name
                                    medicineDisplay = '<strong>' + sale.medicine_names + '</strong>';
                                } else if (medicineCount <= 3) {
                                    // 2-3 medicines - show all names
                                    medicineDisplay = '<strong>' + sale.medicine_names + '</strong>';
                                } else {
                                    // More than 3 - show first medicine + count
                                    medicineDisplay = '<strong>' + names[0] + '</strong><br/><small class="text-muted">+ ' + (medicineCount - 1) + ' more</small>';
                                }
                            } else {
                                medicineDisplay = '<em class="text-muted">No items</em>';
                            }
                            
                            table.row.add([
                                medicineDisplay,
                                sale.sale_date || '',
                                sale.customer_name || 'Walk-in',
                                '<span class="badge badge-secondary">' + (sale.total_items || '0') + '</span>',
                                '<button type="button" class="btn btn-sm btn-info view-items-btn" data-saleid="' + sale.sale_id + '"><i class="fas fa-eye"></i> View</button>',
                                '$' + totalAmount.toFixed(2),
                                '$' + saleCost.toFixed(2),
                                '$' + profit.toFixed(2),
                                profitPercent + '%',
                                '<span class="badge bg-success">Completed</span>'
                            ]);
                        }
                        table.draw();
                        console.log('Sales table drawn successfully');

                        // Update period summary
                        updatePeriodSummary(totalSales, totalCost, totalProfit, r.d.length);
                    },
                    error: function (xhr, status, error) {
                        console.error("=== SALES REPORT ERROR ===");
                        console.error("Status:", status);
                        console.error("Error:", error);
                        console.error("Response:", xhr.responseText);
                        try {
                            var errorObj = JSON.parse(xhr.responseText);
                            console.error("Parsed Error:", errorObj);
                        } catch (e) {
                            console.error("Could not parse error response");
                        }
                    }
                });
            }

            function calculatePeriodSummary() {
                // This is now handled in loadSalesReport
            }

            function updatePeriodSummary(totalSales, totalCost, totalProfit, transactionCount) {
                var fromDate = $('#fromDate').val();
                var toDate = $('#toDate').val();
                
                // Format date range
                var dateRange = formatDate(fromDate) + ' to ' + formatDate(toDate);
                $('#periodRange').text(dateRange);

                // Calculate metrics
                var profitMargin = totalSales > 0 ? ((totalProfit / totalSales) * 100).toFixed(2) : 0;
                var avgSale = transactionCount > 0 ? (totalSales / transactionCount) : 0;

                // Update display
                $('#periodTotalSales').text('$' + totalSales.toFixed(2));
                $('#periodTotalCost').text('$' + totalCost.toFixed(2));
                $('#periodTotalProfit').text('$' + totalProfit.toFixed(2));
                $('#periodProfitMargin').text(profitMargin + '%');
                $('#periodTransactions').text(transactionCount);
                $('#periodAvgSale').text('$' + avgSale.toFixed(2));

                // Show the summary section
                $('#periodSummary').slideDown();
            }

            function formatDate(dateStr) {
                if (!dateStr) return '';
                var date = new Date(dateStr);
                var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                return months[date.getMonth()] + ' ' + date.getDate() + ', ' + date.getFullYear();
            }

            function printSalesReport() {
                var fromDate = $('#fromDate').val();
                var toDate = $('#toDate').val();
                
                if (!fromDate || !toDate) {
                    Swal.fire('Error', 'Please select date range first', 'error');
                    return;
                }
                
                window.open('print_sales_report.aspx?fromDate=' + fromDate + '&toDate=' + toDate, '_blank', 'width=1000,height=800');
            }

            function loadTopMedicines() {
                var fromDate = $('#fromDate').val();
                var toDate = $('#toDate').val();

                console.log('=== TOP MEDICINES DEBUG ===');
                console.log('From Date:', fromDate);
                console.log('To Date:', toDate);

                $.ajax({
                    type: "POST",
                    url: "pharmacy_sales_reports.aspx/getTopMedicines",
                    data: JSON.stringify({ fromDate: fromDate, toDate: toDate }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                        console.log('Top Medicines Response:', r);
                        console.log('Number of medicines returned:', r.d ? r.d.length : 0);
                        
                        if (r.d && r.d.length > 0) {
                            console.log('First medicine data:', r.d[0]);
                        } else {
                            console.warn('No top medicines data returned from backend!');
                        }

                        var table = $('#topMedicinesTable').DataTable();
                        table.clear();

                        for (var i = 0; i < r.d.length; i++) {
                            var med = r.d[i];
                            console.log('Processing medicine ' + (i+1) + ':', med);
                            
                            table.row.add([
                                med.medicine_name || 'Unknown',
                                med.total_quantity || '0',
                                '$' + parseFloat(med.total_revenue || 0).toFixed(2),
                                '$' + parseFloat(med.total_profit || 0).toFixed(2)
                            ]);
                        }
                        table.draw();
                        console.log('Top medicines table drawn successfully');
                    },
                    error: function (xhr, status, error) {
                        console.error("=== TOP MEDICINES ERROR ===");
                        console.error("Status:", status);
                        console.error("Error:", error);
                        console.error("Response:", xhr.responseText);
                        try {
                            var errorObj = JSON.parse(xhr.responseText);
                            console.error("Parsed Error:", errorObj);
                        } catch (e) {
                            console.error("Could not parse error response");
                        }
                    }
                });
            }

            function resetFilters() {
                var now = new Date();
                var year = now.getFullYear();
                var month = String(now.getMonth() + 1).padStart(2, '0');
                var day = String(now.getDate()).padStart(2, '0');
                var today = year + '-' + month + '-' + day;
                
                $('#toDate').val(today);
                $('#fromDate').val(today);

                console.log('Filters reset - From:', today, 'To:', today);
                loadSummaryStats();
                loadSalesReport();
                loadTopMedicines();
            }

            function loadSaleItems(saleId) {
                console.log('=== loadSaleItems called ===');
                console.log('Sale ID:', saleId);
                
                $.ajax({
                    type: 'POST',
                    url: 'pharmacy_sales_reports.aspx/getSalesItems',
                    data: JSON.stringify({ saleId: saleId }),
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (response) {
                        console.log('Sale items response:', response);
                        var items = response.d;
                        var tbody = $('#saleItemsBody');
                        tbody.empty();

                        var totalPrice = 0;
                        var totalCost = 0;
                        var totalProfit = 0;

                        if (items && items.length > 0) {
                            items.forEach(function (item) {
                                // Build quantity display
                                var quantityDisplay = item.quantity + ' ';
                                
                                // Capitalize first letter of quantity_type
                                if (item.quantity_type) {
                                    quantityDisplay += item.quantity_type.charAt(0).toUpperCase() + item.quantity_type.slice(1);
                                } else {
                                    quantityDisplay += 'Units';
                                }

                                // Build unit type display
                                var unitDisplay = item.unit_name || 'N/A';
                                if (item.unit_abbreviation) {
                                    unitDisplay += ' (' + item.unit_abbreviation + ')';
                                }

                                var price = parseFloat(item.total_price || 0);
                                var cost = parseFloat(item.cost_price || 0) * parseFloat(item.quantity || 0);
                                var profit = parseFloat(item.profit || 0);

                                totalPrice += price;
                                totalCost += cost;
                                totalProfit += profit;

                                var row = '<tr>' +
                                    '<td><strong>' + item.medicine_name + '</strong><br/><small class="text-muted">' + (item.manufacturer || '') + '</small></td>' +
                                    '<td>' + (item.generic_name || '-') + '</td>' +
                                    '<td>' + unitDisplay + '</td>' +
                                    '<td><span class="badge badge-primary">' + quantityDisplay + '</span></td>' +
                                    '<td>$' + parseFloat(item.unit_price || 0).toFixed(2) + '</td>' +
                                    '<td>$' + price.toFixed(2) + '</td>' +
                                    '<td>$' + cost.toFixed(2) + '</td>' +
                                    '<td><span class="badge badge-success">$' + profit.toFixed(2) + '</span></td>' +
                                    '</tr>';
                                tbody.append(row);
                            });

                            // Update totals
                            $('#totalPrice').text('$' + totalPrice.toFixed(2));
                            $('#totalCost').text('$' + totalCost.toFixed(2));
                            $('#totalProfit').text('$' + totalProfit.toFixed(2));

                            console.log('Opening modal...');
                            try {
                                var modalElement = document.getElementById('saleItemsModal');
                                console.log('Modal element:', modalElement);
                                
                                if (typeof bootstrap !== 'undefined') {
                                    console.log('Bootstrap 5 detected');
                                    var modal = new bootstrap.Modal(modalElement);
                                    modal.show();
                                } else if (typeof $.fn.modal !== 'undefined') {
                                    console.log('Bootstrap 4 modal detected, using jQuery method');
                                    $('#saleItemsModal').modal('show');
                                } else {
                                    console.error('Bootstrap not loaded!');
                                    alert('Error: Bootstrap library not loaded. Cannot open modal.');
                                }
                            } catch (ex) {
                                console.error('Error opening modal:', ex);
                                alert('Error opening modal: ' + ex.message);
                            }
                        } else {
                            Swal.fire('No Items', 'No items found for this sale', 'info');
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error('=== ERROR loading sale items ===');
                        console.error('Status:', status);
                        console.error('Error:', error);
                        console.error('Response:', xhr.responseText);
                        Swal.fire('Error', 'Failed to load sale items: ' + error, 'error');
                    }
                });
            }
            
        </script>

        <!-- Sale Items Detail Modal -->
        <div class="modal fade" id="saleItemsModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Sale Items Detail</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="saleItemsTable">
                                <thead>
                                    <tr>
                                        <th>Medicine Name</th>
                                        <th>Generic Name</th>
                                        <th>Unit Type</th>
                                        <th>Quantity Sold</th>
                                        <th>Unit Price</th>
                                        <th>Total Price</th>
                                        <th>Cost</th>
                                        <th>Profit</th>
                                    </tr>
                                </thead>
                                <tbody id="saleItemsBody">
                                    <!-- Items will be loaded here -->
                                </tbody>
                                <tfoot>
                                    <tr class="table-info">
                                        <th colspan="5" class="text-right">Total:</th>
                                        <th id="totalPrice">$0.00</th>
                                        <th id="totalCost">$0.00</th>
                                        <th id="totalProfit">$0.00</th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </asp:Content>