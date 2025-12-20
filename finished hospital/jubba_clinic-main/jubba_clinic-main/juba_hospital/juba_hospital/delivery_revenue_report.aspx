<%@ Page Title="Delivery Charges Revenue Report" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="delivery_revenue_report.aspx.cs" Inherits="juba_hospital.delivery_revenue_report" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <style>
        .stat-box {
            background: linear-gradient(135deg, #6C757D 0%, #5A6268 100%);
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
            color: #6C757D;
            font-size: 2rem;
            margin: 10px 0;
        }
        .print-section {
            background: white;
            padding: 30px;
            margin-top: 20px;
        }
        @media print {
            .no-print { display: none !important; }
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
                            <h4 class="card-title"><i class="fas fa-baby"></i> Delivery Charges Revenue Report</h4>
                            <p class="card-category">Detailed analysis of delivery service charges and revenue</p>
                        </div>
                        <button type="button" class="btn btn-secondary btn-round ms-auto no-print" onclick="window.location.href='admin_dashbourd.aspx'">
                            <i class="fa fa-arrow-left"></i> Back to Dashboard
                        </button>
                    </div>
                </div>
                <div class="card-body">
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
                                    <p class="mb-0"><strong>Total Deliveries</strong></p>
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
                            <div class="col-md-3" id="customDateRange" style="display: none;">
                                <label>Start Date</label>
                                <input type="date" class="form-control" id="startDate" />
                            </div>
                            <div class="col-md-3" id="customDateRange2" style="display: none;">
                                <label>End Date</label>
                                <input type="date" class="form-control" id="endDate" />
                            </div>
                            <div class="col-md-3">
                                <label>Payment Status</label>
                                <select class="form-control" id="paymentStatus">
                                    <option value="all">All</option>
                                    <option value="paid">Paid</option>
                                    <option value="unpaid">Unpaid</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label>Search Patient</label>
                                <input type="text" class="form-control" id="patientSearch" placeholder="Patient name..." />
                            </div>
                            <div class="col-md-3">
                                <label>&nbsp;</label>
                                <button class="btn btn-primary btn-block" onclick="loadReport()">
                                    <i class="fas fa-search"></i> Apply Filter
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="row mb-3 no-print">
                        <div class="col-md-12 text-end">
                            <button class="btn btn-success" onclick="printProfessionalReport()">
                                <i class="fas fa-print"></i> Print Professional Report
                            </button>
                        </div>
                    </div>

                    <!-- Details Table -->
                    <div class="table-responsive">
                        <table class="table table-striped table-hover" id="deliveryChargesTable">
                            <thead>
                                <tr>
                                    <th>Invoice #</th>
                                    <th>Patient ID</th>
                                    <th>Patient Name</th>
                                    <th>Phone</th>
                                    <th>Charge Name</th>
                                    <th>Amount</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th class="no-print">Action</th>
                                </tr>
                            </thead>
                            <tbody id="deliveryChargesTableBody">
                                <tr>
                                    <td colspan="9" class="text-center">Loading...</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- Charts Section -->
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5>Daily Revenue Breakdown</h5>
                                </div>
                                <div class="card-body">
                                    <canvas id="dailyChart" height="200"></canvas>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header">
                                    <h5>Top Charge Types</h5>
                                </div>
                                <div class="card-body">
                                    <canvas id="distributionChart" height="200"></canvas>
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
    <script src="assets/js/plugin/chart.js/chart.min.js"></script>
    <script>
        var dataTable;
        var dailyChart, distributionChart;

        $(document).ready(function () {
            loadReport();

            $('#dateRange').change(function () {
                if ($(this).val() === 'custom') {
                    $('#customDateRange, #customDateRange2').show();
                } else {
                    $('#customDateRange, #customDateRange2').hide();
                    loadReport();
                }
            });
        });

        function loadReport() {
            var filters = {
                dateRange: $('#dateRange').val(),
                startDate: $('#startDate').val(),
                endDate: $('#endDate').val(),
                paymentStatus: $('#paymentStatus').val(),
                patientSearch: $('#patientSearch').val()
            };

            $.ajax({
                type: "POST",
                url: "delivery_revenue_report.aspx/GetDeliveryReport",
                data: JSON.stringify(filters),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var data = response.d;
                    updateStatistics(data.statistics);
                    updateTable(data.details);
                    updateCharts(data.dailyBreakdown, data.chargeDistribution);
                },
                error: function (xhr, status, error) {
                    console.error(xhr.responseText);
                    alert('Error loading report: ' + error);
                }
            });
        }

        function updateStatistics(stats) {
            $('#totalRevenue').text(parseFloat(stats.total_revenue || 0).toFixed(2));
            $('#totalCount').text(stats.total_count || 0);
            $('#avgFee').text(parseFloat(stats.average_fee || 0).toFixed(2));
            $('#pendingCount').text(stats.pending_count || 0);
        }

        function updateTable(details) {
            if (dataTable) {
                dataTable.destroy();
            }

            var tbody = $('#deliveryChargesTableBody');
            tbody.empty();

            if (details.length === 0) {
                tbody.append('<tr><td colspan="9" class="text-center">No records found</td></tr>');
                return;
            }

            $.each(details, function (i, item) {
                var statusBadge = item.is_paid === '1' 
                    ? '<span class="badge bg-success">Paid</span>' 
                    : '<span class="badge bg-warning">Unpaid</span>';
                
                var actionBtn = item.is_paid === '0' 
                    ? '<button class="btn btn-sm btn-primary no-print" onclick="markAsPaid(' + item.charge_id + ')">Mark as Paid</button>' 
                    : '<span class="text-muted">-</span>';

                var row = '<tr>' +
                    '<td>' + item.invoice_number + '</td>' +
                    '<td>' + item.patientid + '</td>' +
                    '<td>' + item.patient_name + '</td>' +
                    '<td>' + item.phone + '</td>' +
                    '<td>' + item.charge_name + '</td>' +
                    '<td>$' + parseFloat(item.amount).toFixed(2) + '</td>' +
                    '<td>' + statusBadge + '</td>' +
                    '<td>' + item.date_registered + '</td>' +
                    '<td class="no-print">' + actionBtn + '</td>' +
                    '</tr>';
                tbody.append(row);
            });

            dataTable = $('#deliveryChargesTable').DataTable({
                dom: 'Bfrtip',
                buttons: ['copy', 'csv', 'excel', 'pdf', 'print'],
                order: [[7, 'desc']]
            });
        }

        function updateCharts(dailyData, distributionData) {
            // Daily Revenue Chart
            var dailyCtx = document.getElementById('dailyChart').getContext('2d');
            if (dailyChart) dailyChart.destroy();
            
            dailyChart = new Chart(dailyCtx, {
                type: 'line',
                data: {
                    labels: dailyData.map(d => d.date),
                    datasets: [{
                        label: 'Revenue ($)',
                        data: dailyData.map(d => parseFloat(d.revenue)),
                        borderColor: '#6C757D',
                        backgroundColor: 'rgba(108, 117, 125, 0.1)',
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: true } }
                }
            });

            // Distribution Chart
            var distCtx = document.getElementById('distributionChart').getContext('2d');
            if (distributionChart) distributionChart.destroy();
            
            distributionChart = new Chart(distCtx, {
                type: 'bar',
                data: {
                    labels: distributionData.map(d => d.charge_name),
                    datasets: [{
                        label: 'Revenue ($)',
                        data: distributionData.map(d => parseFloat(d.revenue)),
                        backgroundColor: '#6C757D'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } }
                }
            });
        }

        function markAsPaid(chargeId) {
            if (!confirm('Mark this charge as paid?')) return;

            $.ajax({
                type: "POST",
                url: "delivery_revenue_report.aspx/MarkAsPaid",
                data: JSON.stringify({ chargeId: chargeId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "true") {
                        alert('Payment recorded successfully!');
                        loadReport();
                    } else {
                        alert('Error recording payment');
                    }
                },
                error: function () {
                    alert('Error recording payment');
                }
            });
        }

        function printProfessionalReport() {
            var dateRange = $('#dateRange').val() || 'today';
            var startDate = $('#startDate').val() || '';
            var endDate = $('#endDate').val() || '';
            var paymentStatus = $('#paymentStatus').val() || 'all';
            var patientSearch = $('#patientSearch').val() || '';

            var url = 'print_delivery_revenue_report.aspx?';
            url += 'dateRange=' + encodeURIComponent(dateRange);
            url += '&startDate=' + encodeURIComponent(startDate);
            url += '&endDate=' + encodeURIComponent(endDate);
            url += '&paymentStatus=' + encodeURIComponent(paymentStatus);
            url += '&patientSearch=' + encodeURIComponent(patientSearch);

            window.open(url, '_blank');
        }

        function exportToExcel() {
            dataTable.button('.buttons-excel').trigger();
        }
    </script>
    
    <!-- Watermark -->
    <div class="print-watermark">
        <img src="assets/vafmadow.png" alt="Hospital Logo Watermark" />
    </div>
</asp:Content>
