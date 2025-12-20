<%@ Page Title="Financial Reports" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="financial_reports.aspx.cs" Inherits="juba_hospital.financial_reports" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <style>
        .revenue-card {
            transition: transform 0.2s;
        }
        .revenue-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .filter-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        .stat-card {
            border-left: 4px solid;
            padding: 15px;
            margin-bottom: 15px;
        }
        .stat-card.primary { border-left-color: #1572E8; }
        .stat-card.info { border-left-color: #3DB2E9; }
        .stat-card.success { border-left-color: #31CE36; }
        .stat-card.warning { border-left-color: #FFB900; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title">Financial Reports</h4>
                    <p class="card-category">Comprehensive revenue analysis and reporting</p>
                </div>
                <div class="card-body">
                    <!-- Filter Section -->
                    <div class="filter-section">
                        <div class="row">
                            <div class="col-md-3">
                                <label>Report Type</label>
                                <select class="form-control" id="reportType">
                                    <option value="today">Today</option>
                                    <option value="yesterday">Yesterday</option>
                                    <option value="thisweek">This Week</option>
                                    <option value="thismonth">This Month</option>
                                    <option value="custom">Custom Range</option>
                                </select>
                            </div>
                            <div class="col-md-3" id="startDateDiv" style="display:none;">
                                <label>Start Date</label>
                                <input type="date" class="form-control" id="startDate">
                            </div>
                            <div class="col-md-3" id="endDateDiv" style="display:none;">
                                <label>End Date</label>
                                <input type="date" class="form-control" id="endDate">
                            </div>
                            <div class="col-md-3">
                                <label>&nbsp;</label>
                                <button type="button" class="btn btn-primary btn-block" onclick="loadReport()">
                                    <i class="fa fa-search"></i> Generate Report
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Summary Cards -->
                    <div class="row mt-3">
                        <div class="col-md-3">
                            <div class="card revenue-card card-stats card-round">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-3">
                                            <div class="icon-big text-center icon-primary bubble-shadow-small">
                                                <i class="fas fa-dollar-sign"></i>
                                            </div>
                                        </div>
                                        <div class="col-9 col-stats">
                                            <div class="numbers">
                                                <p class="card-category">Total Revenue</p>
                                                <h4 class="card-title">$<span id="summaryTotal">0.00</span></h4>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card revenue-card card-stats card-round">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-3">
                                            <div class="icon-big text-center icon-info bubble-shadow-small">
                                                <i class="fas fa-user-plus"></i>
                                            </div>
                                        </div>
                                        <div class="col-9 col-stats">
                                            <div class="numbers">
                                                <p class="card-category">Registration</p>
                                                <h4 class="card-title">$<span id="summaryReg">0.00</span></h4>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card revenue-card card-stats card-round">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-3">
                                            <div class="icon-big text-center icon-success bubble-shadow-small">
                                                <i class="fas fa-flask"></i>
                                            </div>
                                        </div>
                                        <div class="col-9 col-stats">
                                            <div class="numbers">
                                                <p class="card-category">Lab Tests</p>
                                                <h4 class="card-title">$<span id="summaryLab">0.00</span></h4>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card revenue-card card-stats card-round">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-3">
                                            <div class="icon-big text-center icon-warning bubble-shadow-small">
                                                <i class="fas fa-x-ray"></i>
                                            </div>
                                        </div>
                                        <div class="col-9 col-stats">
                                            <div class="numbers">
                                                <p class="card-category">X-Ray</p>
                                                <h4 class="card-title">$<span id="summaryXray">0.00</span></h4>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Additional Revenue Cards -->
                    <div class="row mt-3">
                        <div class="col-md-4">
                            <div class="card revenue-card card-stats card-round">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-3">
                                            <div class="icon-big text-center icon-danger bubble-shadow-small">
                                                <i class="fas fa-bed"></i>
                                            </div>
                                        </div>
                                        <div class="col-9 col-stats">
                                            <div class="numbers">
                                                <p class="card-category">Bed Charges</p>
                                                <h4 class="card-title">$<span id="summaryBed">0.00</span></h4>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card revenue-card card-stats card-round">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-3">
                                            <div class="icon-big text-center icon-secondary bubble-shadow-small">
                                                <i class="fas fa-baby"></i>
                                            </div>
                                        </div>
                                        <div class="col-9 col-stats">
                                            <div class="numbers">
                                                <p class="card-category">Delivery Charges</p>
                                                <h4 class="card-title">$<span id="summaryDelivery">0.00</span></h4>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card revenue-card card-stats card-round">
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-3">
                                            <div class="icon-big text-center icon-warning bubble-shadow-small">
                                                <i class="fas fa-capsules"></i>
                                            </div>
                                        </div>
                                        <div class="col-9 col-stats">
                                            <div class="numbers">
                                                <p class="card-category">Pharmacy Sales</p>
                                                <h4 class="card-title">$<span id="summaryPharmacy">0.00</span></h4>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Detailed Breakdown -->
                    <div class="row mt-3">
                        <div class="col-md-12">
                            <ul class="nav nav-pills nav-secondary" id="pills-tab" role="tablist">
                                <li class="nav-item">
                                    <a class="nav-link active" id="pills-registration-tab" data-bs-toggle="pill" href="#pills-registration" role="tab">
                                        <i class="fas fa-user-plus"></i> Registration
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="pills-lab-tab" data-bs-toggle="pill" href="#pills-lab" role="tab">
                                        <i class="fas fa-flask"></i> Lab Tests
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="pills-xray-tab" data-bs-toggle="pill" href="#pills-xray" role="tab">
                                        <i class="fas fa-x-ray"></i> X-Ray
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="pills-bed-tab" data-bs-toggle="pill" href="#pills-bed" role="tab">
                                        <i class="fas fa-bed"></i> Bed Charges
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="pills-delivery-tab" data-bs-toggle="pill" href="#pills-delivery" role="tab">
                                        <i class="fas fa-baby"></i> Delivery
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="pills-pharmacy-tab" data-bs-toggle="pill" href="#pills-pharmacy" role="tab">
                                        <i class="fas fa-capsules"></i> Pharmacy
                                    </a>
                                </li>
                            </ul>
                            <div class="tab-content mt-2 mb-3" id="pills-tabContent">
                                <!-- Registration Tab -->
                                <div class="tab-pane fade show active" id="pills-registration" role="tabpanel">
                                    <div class="table-responsive">
                                        <table id="registrationTable" class="display table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Patient Name</th>
                                                    <th>Charge Name</th>
                                                    <th>Amount</th>
                                                    <th>Paid Date</th>
                                                    <th>Invoice #</th>
                                                </tr>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- Lab Tab -->
                                <div class="tab-pane fade" id="pills-lab" role="tabpanel">
                                    <div class="table-responsive">
                                        <table id="labTable" class="display table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Patient Name</th>
                                                    <th>Charge Name</th>
                                                    <th>Amount</th>
                                                    <th>Paid Date</th>
                                                    <th>Invoice #</th>
                                                </tr>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- X-Ray Tab -->
                                <div class="tab-pane fade" id="pills-xray" role="tabpanel">
                                    <div class="table-responsive">
                                        <table id="xrayTable" class="display table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Patient Name</th>
                                                    <th>Charge Name</th>
                                                    <th>Amount</th>
                                                    <th>Paid Date</th>
                                                    <th>Invoice #</th>
                                                </tr>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- Bed Charges Tab -->
                                <div class="tab-pane fade" id="pills-bed" role="tabpanel">
                                    <div class="table-responsive">
                                        <table id="bedTable" class="display table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Patient Name</th>
                                                    <th>Charge Name</th>
                                                    <th>Amount</th>
                                                    <th>Paid Date</th>
                                                    <th>Invoice #</th>
                                                </tr>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- Delivery Charges Tab -->
                                <div class="tab-pane fade" id="pills-delivery" role="tabpanel">
                                    <div class="table-responsive">
                                        <table id="deliveryTable" class="display table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Patient Name</th>
                                                    <th>Charge Name</th>
                                                    <th>Amount</th>
                                                    <th>Paid Date</th>
                                                    <th>Invoice #</th>
                                                </tr>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </div>

                                <!-- Pharmacy Tab -->
                                <div class="tab-pane fade" id="pills-pharmacy" role="tabpanel">
                                    <div class="table-responsive">
                                        <table id="pharmacyTable" class="display table table-striped table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Customer Name</th>
                                                    <th>Total Amount</th>
                                                    <th>Payment Method</th>
                                                    <th>Sale Date</th>
                                                    <th>Sale ID</th>
                                                </tr>
                                            </thead>
                                            <tbody></tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="assets/js/core/jquery-3.7.1.min.js"></script>
    <script src="datatables/datatables.min.js"></script>
    <script src="assets/sweetalert2.min.js"></script>

    <script>
        // Global variables
        var tablesInitialized = false;

        // Function to load financial report
        function loadReport() {
            var startDate = $('#startDate').val();
            var endDate = $('#endDate').val();

            if (!startDate || !endDate) {
                alert('Please select both start and end dates');
                return;
            }

            if (new Date(startDate) > new Date(endDate)) {
                alert('Start date must be before end date');
                return;
            }

            console.log('Loading financial report for date range:', startDate, 'to', endDate);

            $.ajax({
                type: "POST",
                url: "financial_reports.aspx/GetRevenueReport",
                data: JSON.stringify({ startDate: startDate, endDate: endDate }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log("Revenue report response:", response);
                    
                    if (response.d && response.d.length > 0) {
                        displayReportData(response.d);
                        alert('Report generated successfully with ' + response.d.length + ' records');
                    } else {
                        alert('No data found for selected date range');
                        clearReportData();
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Error loading revenue report:", error);
                    alert('Error loading report: ' + error);
                }
            });
        }

        // Function to display report data
        function displayReportData(data) {
            clearReportData();
            
            data.forEach(function(item) {
                var rowData = [
                    item.revenue_date || new Date().toLocaleDateString(),
                    item.patient_name || 'N/A',
                    item.service_name || item.description || 'N/A',
                    '$' + parseFloat(item.amount || 0).toFixed(2),
                    item.payment_status || 'Completed'
                ];

                // Add to appropriate table based on revenue type
                var revenueType = (item.revenue_type || 'registration').toLowerCase();
                
                if (revenueType.includes('lab')) {
                    window.labTable.row.add(rowData);
                } else if (revenueType.includes('xray') || revenueType.includes('x-ray')) {
                    window.xrayTable.row.add(rowData);
                } else if (revenueType.includes('bed')) {
                    window.bedTable.row.add(rowData);
                } else if (revenueType.includes('delivery')) {
                    window.deliveryTable.row.add(rowData);
                } else if (revenueType.includes('pharmacy')) {
                    window.pharmacyTable.row.add(rowData);
                } else {
                    window.registrationTable.row.add(rowData);
                }
            });

            // Redraw all tables
            window.registrationTable.draw();
            window.labTable.draw();
            window.xrayTable.draw();
            window.bedTable.draw();
            window.deliveryTable.draw();
            window.pharmacyTable.draw();
        }

        // Function to clear report data
        function clearReportData() {
            if (tablesInitialized) {
                window.registrationTable.clear();
                window.labTable.clear();
                window.xrayTable.clear();
                window.bedTable.clear();
                window.deliveryTable.clear();
                window.pharmacyTable.clear();
            }
        }
    </script>
    <script>
        var regTable, labTable, xrayTable, bedTable, deliveryTable, pharmacyTable;

        $(document).ready(function () {
            // Don't use DataTables - just use simple tables
            regTable = null;
            labTable = null;
            xrayTable = null;
            bedTable = null;
            deliveryTable = null;
            pharmacyTable = null;
            console.log('Using simple table mode (no DataTables)');

            // Load today's report by default
            loadReport();

            // Handle report type change
            $('#reportType').change(function() {
                if ($(this).val() === 'custom') {
                    $('#startDateDiv, #endDateDiv').show();
                } else {
                    $('#startDateDiv, #endDateDiv').hide();
                }
            });
        });

        function loadReport() {
            var reportType = $('#reportType').val();
            var startDate = $('#startDate').val();
            var endDate = $('#endDate').val();

            $.ajax({
                type: "POST",
                url: "financial_reports.aspx/GetRevenueReport",
                data: JSON.stringify({ reportType: reportType, startDate: startDate, endDate: endDate }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d) {
                        updateSummary(response.d.summary);
                        updateTables(response.d);
                    }
                },
                error: function (xhr, status, error) {
                    console.error(xhr.responseText);
                    Swal.fire('Error', 'Failed to load report', 'error');
                }
            });
        }

        function updateSummary(summary) {
            $('#summaryTotal').text(parseFloat(summary.total_revenue || 0).toFixed(2));
            $('#summaryReg').text(parseFloat(summary.registration_revenue || 0).toFixed(2));
            $('#summaryLab').text(parseFloat(summary.lab_revenue || 0).toFixed(2));
            $('#summaryXray').text(parseFloat(summary.xray_revenue || 0).toFixed(2));
            $('#summaryBed').text(parseFloat(summary.bed_revenue || 0).toFixed(2));
            $('#summaryDelivery').text(parseFloat(summary.delivery_revenue || 0).toFixed(2));
            $('#summaryPharmacy').text(parseFloat(summary.pharmacy_revenue || 0).toFixed(2));
        }

        function updateTables(data) {
            // Clear all table bodies
            $('#registrationTable tbody').empty();
            $('#labTable tbody').empty();
            $('#xrayTable tbody').empty();
            $('#bedTable tbody').empty();
            $('#deliveryTable tbody').empty();
            $('#pharmacyTable tbody').empty();

            // Registration charges
            if (data.registration_details) {
                data.registration_details.forEach(function(item) {
                    var row = '<tr>' +
                        '<td>' + item.patient_name + '</td>' +
                        '<td>' + item.charge_name + '</td>' +
                        '<td>$' + parseFloat(item.amount).toFixed(2) + '</td>' +
                        '<td>' + item.paid_date + '</td>' +
                        '<td>' + (item.invoice_number || '') + '</td>' +
                        '</tr>';
                    $('#registrationTable tbody').append(row);
                });
            }

            // Lab charges
            if (data.lab_details) {
                data.lab_details.forEach(function(item) {
                    var row = '<tr>' +
                        '<td>' + item.patient_name + '</td>' +
                        '<td>' + item.charge_name + '</td>' +
                        '<td>$' + parseFloat(item.amount).toFixed(2) + '</td>' +
                        '<td>' + item.paid_date + '</td>' +
                        '<td>' + (item.invoice_number || '') + '</td>' +
                        '</tr>';
                    $('#labTable tbody').append(row);
                });
            }

            // X-Ray charges
            if (data.xray_details) {
                data.xray_details.forEach(function(item) {
                    var row = '<tr>' +
                        '<td>' + item.patient_name + '</td>' +
                        '<td>' + item.charge_name + '</td>' +
                        '<td>$' + parseFloat(item.amount).toFixed(2) + '</td>' +
                        '<td>' + item.paid_date + '</td>' +
                        '<td>' + (item.invoice_number || '') + '</td>' +
                        '</tr>';
                    $('#xrayTable tbody').append(row);
                });
            }

            // Bed charges
            if (data.bed_details) {
                data.bed_details.forEach(function(item) {
                    var row = '<tr>' +
                        '<td>' + item.patient_name + '</td>' +
                        '<td>' + item.charge_name + '</td>' +
                        '<td>$' + parseFloat(item.amount).toFixed(2) + '</td>' +
                        '<td>' + item.paid_date + '</td>' +
                        '<td>' + (item.invoice_number || '') + '</td>' +
                        '</tr>';
                    $('#bedTable tbody').append(row);
                });
            }

            // Delivery charges
            if (data.delivery_details) {
                data.delivery_details.forEach(function(item) {
                    var row = '<tr>' +
                        '<td>' + item.patient_name + '</td>' +
                        '<td>' + item.charge_name + '</td>' +
                        '<td>$' + parseFloat(item.amount).toFixed(2) + '</td>' +
                        '<td>' + item.paid_date + '</td>' +
                        '<td>' + (item.invoice_number || '') + '</td>' +
                        '</tr>';
                    $('#deliveryTable tbody').append(row);
                });
            }

            // Pharmacy sales
            if (data.pharmacy_details) {
                data.pharmacy_details.forEach(function(item) {
                    var row = '<tr>' +
                        '<td>' + item.customer_name + '</td>' +
                        '<td>$' + parseFloat(item.total_amount).toFixed(2) + '</td>' +
                        '<td>' + item.payment_method + '</td>' +
                        '<td>' + item.sale_date + '</td>' +
                        '<td>' + item.sale_id + '</td>' +
                        '</tr>';
                    $('#pharmacyTable tbody').append(row);
                });
            }
        }
    </script>
</asp:Content>
