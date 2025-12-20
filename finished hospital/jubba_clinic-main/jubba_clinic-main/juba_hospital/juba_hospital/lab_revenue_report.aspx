<%@ Page Title="Lab Revenue Report" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="lab_revenue_report.aspx.cs" Inherits="juba_hospital.lab_revenue_report" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Use CDN for DataTables CSS -->
    <link href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="<%: ResolveUrl("~/assets/sweetalert2.css") %>" rel="stylesheet" />
    <style>
        .stat-box {
            background: linear-gradient(135deg, #3DB2E9 0%, #1572E8 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .filter-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .revenue-stat {
            text-align: center;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .revenue-stat p {
            color: #000;
            font-weight: 600;
        }
        .revenue-stat h3 {
            color: #3DB2E9;
            font-size: 2rem;
            margin: 10px 0;
        }
        .print-section {
            background: white;
            padding: 30px;
            margin-top: 20px;
        }
        .print-only-header {
            display: none;
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 3px solid #333;
        }
        .print-only-header h1 {
            margin: 10px 0;
            font-size: 28px;
            color: #2c3e50;
        }
        .print-only-header h3 {
            margin: 15px 0 5px;
            font-size: 20px;
            color: #e74c3c;
        }
        .print-only-header p {
            margin: 5px 0;
            color: #666;
        }
        @media print {
            .no-print { display: none !important; }
            .print-only-header { display: block !important; }
            body { padding: 20px; }
            table { page-break-inside: auto; }
            tr { page-break-inside: avoid; page-break-after: auto; }
            thead { display: table-header-group; }
            tfoot { display: table-footer-group; }
            .print-section { box-shadow: none !important; }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <div>
                            <h4 class="card-title"><i class="fas fa-flask"></i> Lab Tests Revenue Report</h4>
                            <p class="card-category">Detailed analysis of laboratory test charges and revenue</p>
                        </div>
                        <button type="button" class="btn btn-secondary btn-round ms-auto no-print" onclick="window.location.href='admin_dashbourd.aspx'">
                            <i class="fa fa-arrow-left"></i> Back to Dashboard
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <!-- Print-Only Header -->
                    <div class="print-only-header">
                        <h1>JUBA CLINIC</h1>
                        <p>Mogadishu, Somalia | Tel: +252 XXX XXX XXX</p>
                        <h3>LAB REVENUE REPORT</h3>
                        <p>Report Period: <span id="printStartDate"></span> to <span id="printEndDate"></span></p>
                        <p>Generated: <span id="printGeneratedDate"></span></p>
                    </div>
                    
                    <!-- Summary Statistics -->
                    <div class="stat-box">
                        <div class="row">
                            <div class="col-md-3">
                                <div class="revenue-stat">
                                    <p class="mb-0"><strong>Total Revenue</strong></p>
                                    <h3>$<span id="totalRevenue">0.00</span></h3>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="revenue-stat">
                                    <p class="mb-0"><strong>Total Tests</strong></p>
                                    <h3><span id="totalCount">0</span></h3>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="revenue-stat">
                                    <p class="mb-0"><strong>Average Cost</strong></p>
                                    <h3>$<span id="avgFee">0.00</span></h3>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="revenue-stat">
                                    <p class="mb-0"><strong>Pending Payments</strong></p>
                                    <h3><span id="pendingCount">0</span></h3>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-card no-print">
                        <h5><i class="fas fa-filter"></i> Filter Options</h5>
                        <div class="row">
                            <div class="col-md-3">
                                <label>Date Range</label>
                                <select class="form-control" id="dateRange">
                                    <option value="today">Today</option>
                                    <option value="yesterday">Yesterday</option>
                                    <option value="thisweek">This Week</option>
                                    <option value="thismonth">This Month</option>
                                    <option value="lastmonth">Last Month</option>
                                    <option value="custom">Custom Range</option>
                                </select>
                            </div>
                            <div class="col-md-2" id="startDateDiv" style="display:none;">
                                <label>Start Date</label>
                                <input type="date" class="form-control" id="startDate">
                            </div>
                            <div class="col-md-2" id="endDateDiv" style="display:none;">
                                <label>End Date</label>
                                <input type="date" class="form-control" id="endDate">
                            </div>
                            <div class="col-md-2">
                                <label>Payment Status</label>
                                <select class="form-control" id="paymentStatus">
                                    <option value="all">All</option>
                                    <option value="paid">Paid Only</option>
                                    <option value="unpaid">Unpaid Only</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label>Search Patient/Test</label>
                                <input type="text" class="form-control" id="patientSearch" placeholder="Enter patient or test name...">
                            </div>
                            <div class="col-md-2">
                                <label>&nbsp;</label>
                                <button type="button" class="btn btn-primary btn-block" onclick="loadReport(); return false;">
                                    <i class="fa fa-search"></i> Apply Filter
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="row mb-3 no-print">
                        <div class="col-md-12 text-end">
                            <button type="button" class="btn btn-success" onclick="printReport()">
                                <i class="fas fa-print"></i> Print Professional Report
                            </button>
                        </div>
                    </div>

                    <!-- Data Table -->
                    <div class="print-section">
                        <div class="table-responsive">
                            <table id="labTable" class="display table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Invoice #</th>
                                        <th>Patient Name</th>
                                        <th>Phone</th>
                                        <th>Test Name</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th class="no-print">Actions</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                                <tfoot>
                                    <tr>
                                        <th colspan="4" class="text-end"><strong>Total:</strong></th>
                                        <th><strong>$<span id="tableTotal">0.00</span></strong></th>
                                        <th colspan="4"></th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>

                    <!-- Test Type Distribution Chart -->
                    <div class="row mt-4 no-print">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5><i class="fas fa-chart-pie"></i> Top Lab Tests by Revenue</h5>
                                </div>
                                <div class="card-body">
                                    <canvas id="testDistributionChart" height="200"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5><i class="fas fa-chart-bar"></i> Daily Revenue Breakdown</h5>
                                </div>
                                <div class="card-body">
                                    <canvas id="revenueChart" height="200"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Wait for jQuery to be available before loading DataTables
        function loadDataTablesWhenReady() {
            if (typeof jQuery !== 'undefined') {
                console.log('jQuery found, loading DataTables...');
                var script = document.createElement('script');
                script.src = 'https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js';
                script.onload = function() {
                    console.log('DataTables loaded from CDN');
                    checkAndInitialize();
                };
                script.onerror = function() {
                    console.error('Failed to load DataTables from CDN, trying local...');
                    loadLocalDataTables();
                };
                document.head.appendChild(script);
            } else {
                console.log('jQuery not yet available, retrying...');
                setTimeout(loadDataTablesWhenReady, 100);
            }
        }
        
        // Start loading DataTables
        loadDataTablesWhenReady();
        
        // Fallback to local DataTables if CDN fails
        function loadLocalDataTables() {
            console.log('Attempting to load local DataTables...');
            var script = document.createElement('script');
            script.src = '<%: ResolveUrl("~/datatables/datatables.min.js") %>';
            script.onload = function() {
                console.log('Local DataTables loaded successfully');
                checkAndInitialize();
            };
            script.onerror = function() {
                console.error('Local DataTables also failed to load');
            };
            document.head.appendChild(script);
        }
        
        function checkAndInitialize() {
            console.log('Checking DataTables availability...');
            console.log('jQuery version:', $.fn.jquery);
            console.log('jQuery.fn.DataTable:', typeof $.fn.DataTable);
            console.log('jQuery.fn.dataTable:', typeof $.fn.dataTable);
            
            if (typeof $.fn.DataTable !== 'undefined' || typeof $.fn.dataTable !== 'undefined') {
                console.log('DataTables found! Initializing...');
                initializePage();
            } else {
                console.error('DataTables still not available after load attempts');
                alert('Failed to load DataTables library. Please check your internet connection and refresh.');
            }
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="<%: ResolveUrl("~/assets/sweetalert2.min.js") %>"></script>
    <script>
        var table;
        var revenueChart;
        var testDistributionChart;

        // Multiple attempts to initialize
        var initAttempts = 0;
        var maxAttempts = 10;
        
        function tryInitialize() {
            initAttempts++;
            console.log('Initialization attempt #' + initAttempts);
            
            if (typeof $.fn.DataTable !== 'undefined' || typeof $.fn.dataTable !== 'undefined') {
                console.log('DataTables found on attempt #' + initAttempts);
                checkAndInitialize();
            } else if (initAttempts < maxAttempts) {
                console.log('DataTables not found, retrying in 500ms...');
                setTimeout(tryInitialize, 500);
            } else {
                console.error('Failed to load DataTables after ' + maxAttempts + ' attempts');
                alert('DataTables failed to load. Please refresh the page.');
            }
        }
        
        // Start trying after DOM ready - wait for jQuery
        function startWhenReady() {
            if (typeof jQuery !== 'undefined') {
                $(document).ready(function() {
                    console.log('DOM ready, starting DataTables initialization attempts...');
                    tryInitialize();
                });
            } else {
                setTimeout(startWhenReady, 100);
            }
        }
        startWhenReady();

        function initializePage() {
            console.log('Initializing page without DataTables...');
            
            // Don't use DataTables - just use simple table
            table = null; // Set to null so updateTable knows not to use DataTables

            // Setup date range change handler
            $('#dateRange').off('change').on('change', function() {
                if ($(this).val() === 'custom') {
                    $('#startDateDiv, #endDateDiv').show();
                } else {
                    $('#startDateDiv, #endDateDiv').hide();
                }
            });

            // Load today's report automatically on page load
            loadReport();
            
            console.log('Page initialized successfully (simple table mode)');
        }
        
        // Handle date range change (for inline onchange attribute)
        function handleDateRangeChange() {
            var val = document.getElementById('dateRange').value;
            if (val === 'custom') {
                document.getElementById('startDateDiv').style.display = 'block';
                document.getElementById('endDateDiv').style.display = 'block';
            } else {
                document.getElementById('startDateDiv').style.display = 'none';
                document.getElementById('endDateDiv').style.display = 'none';
            }
        }

        function loadReport() {
            var dateRange = $('#dateRange').val() || 'today';
            var startDate = $('#startDate').val() || '';
            var endDate = $('#endDate').val() || '';
            var paymentStatus = $('#paymentStatus').val() || 'all';
            var patientSearch = $('#patientSearch').val() || '';

            $.ajax({
                type: "POST",
                url: "lab_revenue_report.aspx/GetLabReport",
                data: JSON.stringify({ 
                    dateRange: dateRange, 
                    startDate: startDate, 
                    endDate: endDate,
                    paymentStatus: paymentStatus,
                    patientSearch: patientSearch
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log('Lab report data received:', response);
                    if (response.d) {
                        updateStatistics(response.d.statistics);
                        updateTable(response.d.details);
                        updateRevenueChart(response.d.dailyBreakdown);
                        updateTestDistribution(response.d.testDistribution);
                    } else {
                        console.error('No data received');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error loading lab report:', xhr.responseText);
                    Swal.fire('Error', 'Failed to load report: ' + error, 'error');
                }
            });
        }

        function updateStatistics(stats) {
            $('#totalRevenue').text(parseFloat(stats.total_revenue || 0).toFixed(2));
            $('#totalCount').text(stats.total_count || 0);
            $('#avgFee').text(parseFloat(stats.average_fee || 0).toFixed(2));
            $('#pendingCount').text(stats.pending_count || 0);
        }

        function updateTable(data) {
            console.log('Updating table with data:', data);
            
            // Clear existing table body
            var tbody = $('#labTable tbody');
            tbody.empty();
            
            var total = 0;

            if (data && data.length > 0) {
                data.forEach(function(item) {
                    console.log('Lab item is_paid value:', item.is_paid, 'Type:', typeof item.is_paid);
                    
                    // Handle both string "1"/"0" and boolean true/false
                    var isPaid = item.is_paid === '1' || item.is_paid === 1 || item.is_paid === true || 
                                 item.is_paid === 'True' || item.is_paid === 'true';
                    
                    var statusBadge = isPaid
                        ? '<span class="badge bg-success">Paid</span>' 
                        : '<span class="badge bg-warning">Unpaid</span>';
                    
                    var actions = isPaid
                        ? '<button class="btn btn-sm btn-info" onclick="viewInvoice(' + item.patientid + ', \'' + item.invoice_number + '\')">View Invoice</button>'
                        : '<button class="btn btn-sm btn-primary" onclick="markAsPaid(' + item.charge_id + ')">Mark as Paid</button>';

                    // Split date and time from paid_date (format: yyyy-MM-dd HH:mm)
                    var dateTimeParts = (item.paid_date || '').split(' ');
                    var dateOnly = dateTimeParts[0] || item.date_registered;
                    var timeOnly = dateTimeParts[1] || '';
                    
                    var row = '<tr>' +
                        '<td>' + (item.invoice_number || '') + '</td>' +
                        '<td>' + item.patient_name + '</td>' +
                        '<td>' + item.phone + '</td>' +
                        '<td>' + item.charge_name + '</td>' +
                        '<td>$' + parseFloat(item.amount).toFixed(2) + '</td>' +
                        '<td>' + statusBadge + '</td>' +
                        '<td>' + dateOnly + '</td>' +
                        '<td>' + timeOnly + '</td>' +
                        '<td>' + actions + '</td>' +
                        '</tr>';
                    
                    tbody.append(row);

                    if (isPaid) {
                        total += parseFloat(item.amount);
                    }
                });
            }

            $('#tableTotal').text(total.toFixed(2));
        }

        function updateRevenueChart(dailyData) {
            if (revenueChart) {
                revenueChart.destroy();
            }

            var ctx = document.getElementById('revenueChart').getContext('2d');
            revenueChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: dailyData.map(d => d.date),
                    datasets: [{
                        label: 'Daily Revenue',
                        data: dailyData.map(d => parseFloat(d.revenue)),
                        backgroundColor: 'rgba(61, 178, 233, 0.8)',
                        borderColor: 'rgba(61, 178, 233, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: { callback: function(value) { return '$' + value; } }
                        }
                    }
                }
            });
        }

        function updateTestDistribution(testData) {
            if (testDistributionChart) {
                testDistributionChart.destroy();
            }

            var ctx = document.getElementById('testDistributionChart').getContext('2d');
            testDistributionChart = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: testData.map(d => d.test_name),
                    datasets: [{
                        data: testData.map(d => parseFloat(d.revenue)),
                        backgroundColor: [
                            'rgba(61, 178, 233, 0.8)',
                            'rgba(21, 114, 232, 0.8)',
                            'rgba(49, 206, 54, 0.8)',
                            'rgba(255, 185, 0, 0.8)',
                            'rgba(255, 87, 34, 0.8)'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom' }
                    }
                }
            });
        }

        function exportToExcel() {
            table.button('.buttons-excel').trigger();
        }

        function exportToPDF() {
            window.print();
        }
        
        function printReport() {
            var dateRange = $('#dateRange').val() || 'today';
            var startDate = $('#startDate').val() || '';
            var endDate = $('#endDate').val() || '';
            var paymentStatus = $('#paymentStatus').val() || 'all';
            var patientSearch = $('#patientSearch').val() || '';

            // Build URL with query parameters
            var url = 'print_lab_revenue_report.aspx?';
            url += 'dateRange=' + encodeURIComponent(dateRange);
            url += '&startDate=' + encodeURIComponent(startDate);
            url += '&endDate=' + encodeURIComponent(endDate);
            url += '&paymentStatus=' + encodeURIComponent(paymentStatus);
            url += '&patientSearch=' + encodeURIComponent(patientSearch);

            // Open in new window
            window.open(url, '_blank');
        }

        function markAsPaid(chargeId) {
            Swal.fire({
                title: 'Mark as Paid?',
                text: "Are you sure you want to mark this charge as paid?",
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, mark as paid!'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        type: "POST",
                        url: "lab_revenue_report.aspx/MarkAsPaid",
                        data: JSON.stringify({ chargeId: chargeId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === "true") {
                                Swal.fire('Success!', 'Charge marked as paid.', 'success');
                                loadReport();
                            }
                        },
                        error: function (xhr, status, error) {
                            Swal.fire('Error', 'Failed to update payment status', 'error');
                        }
                    });
                }
            });
        }

        function viewInvoice(patientId, invoiceNumber) {
            let url = 'patient_invoice_print.aspx?patientid=' + encodeURIComponent(patientId);
            if (invoiceNumber) {
                url += '&invoice=' + encodeURIComponent(invoiceNumber);
            }
            window.open(url, '_blank');
        }
    </script>
    
    <!-- Watermark -->
    <div class="print-watermark">
        <img src="assets/vafmadow.png" alt="Hospital Logo Watermark" />
    </div>
</asp:Content>
