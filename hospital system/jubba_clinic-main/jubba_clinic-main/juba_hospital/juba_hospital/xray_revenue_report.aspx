<%@ Page Title="X-Ray Revenue Report" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="xray_revenue_report.aspx.cs" Inherits="juba_hospital.xray_revenue_report" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <style>
        .stat-box {
            background: linear-gradient(135deg, #31CE36 0%, #28a745 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .filter-card { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .revenue-stat { text-align: center; padding: 20px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .revenue-stat p { color: #000; font-weight: 600; }
        .revenue-stat h3 { color: #31CE36; font-size: 2rem; margin: 10px 0; }
        .print-section { background: white; padding: 30px; margin-top: 20px; }
        @media print { .no-print { display: none !important; } .print-section { box-shadow: none !important; } }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <div>
                            <h4 class="card-title"><i class="fas fa-x-ray"></i> X-Ray Revenue Report</h4>
                            <p class="card-category">Detailed analysis of X-ray imaging charges and revenue</p>
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
                                    <p class="mb-0"><strong>Total X-Rays</strong></p>
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
                                <label>Search Patient/Type</label>
                                <input type="text" class="form-control" id="patientSearch" placeholder="Enter patient or X-ray type...">
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
                            <button class="btn btn-success" onclick="window.print()"><i class="fas fa-print"></i> Print Report</button>
                            <button class="btn btn-info" onclick="exportToExcel()"><i class="fas fa-file-excel"></i> Export to Excel</button>
                        </div>
                    </div>

                    <!-- Data Table -->
                    <div class="print-section">
                        <div class="table-responsive">
                            <table id="xrayTable" class="display table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Invoice #</th>
                                        <th>Patient Name</th>
                                        <th>Phone</th>
                                        <th>X-Ray Type</th>
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

                    <!-- Charts -->
                    <div class="row mt-4 no-print">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header"><h5><i class="fas fa-chart-pie"></i> Top X-Ray Types by Revenue</h5></div>
                                <div class="card-body"><canvas id="xrayDistributionChart" height="200"></canvas></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-header"><h5><i class="fas fa-chart-bar"></i> Daily Revenue Breakdown</h5></div>
                                <div class="card-body"><canvas id="revenueChart" height="200"></canvas></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="assets/js/core/jquery-3.7.1.min.js"></script>
    <script src="datatables/datatables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        var table, revenueChart, xrayDistributionChart;

        $(document).ready(function () {
            table = $('#xrayTable').DataTable({
                dom: 'Bfrtip',
                buttons: [{ extend: 'excelHtml5', title: 'X-Ray Revenue Report', exportOptions: { columns: ':not(.no-print)' } }],
                pageLength: 25,
                order: [[6, 'desc']]
            });

            $('#dateRange').change(function() {
                $('#startDateDiv, #endDateDiv').toggle($(this).val() === 'custom');
            });

            // Load today's report automatically on page load
            loadReport();
        });

        function loadReport() {
            var dateRange = $('#dateRange').val() || 'today';
            var startDate = $('#startDate').val() || '';
            var endDate = $('#endDate').val() || '';
            var paymentStatus = $('#paymentStatus').val() || 'all';
            var patientSearch = $('#patientSearch').val() || '';

            $.ajax({
                type: "POST",
                url: "xray_revenue_report.aspx/GetXrayReport",
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
                    console.log('X-ray report data received:', response);
                    if (response.d) {
                        updateStatistics(response.d.statistics);
                        updateTable(response.d.details);
                        updateCharts(response.d);
                    } else {
                        console.error('No data received');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error loading X-ray report:', xhr.responseText);
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
            table.clear();
            var total = 0;
            if (data) {
                data.forEach(function(item) {
                    console.log('X-ray item is_paid value:', item.is_paid, 'Type:', typeof item.is_paid);
                    
                    // Handle both string "1"/"0" and boolean true/false
                    var isPaid = item.is_paid === '1' || item.is_paid === 1 || item.is_paid === true || 
                                 item.is_paid === 'True' || item.is_paid === 'true';
                    
                    var statusBadge = isPaid ? '<span class="badge bg-success">Paid</span>' : '<span class="badge bg-warning">Unpaid</span>';
                    var actions = isPaid ? '<button class="btn btn-sm btn-info" onclick="viewInvoice(' + item.patientid + ', \'' + item.invoice_number + '\')">View Invoice</button>' : '<button class="btn btn-sm btn-primary" onclick="markAsPaid(' + item.charge_id + ')">Mark as Paid</button>';
                    
                    // Split date and time from paid_date (format: yyyy-MM-dd HH:mm)
                    var dateTimeParts = (item.paid_date || '').split(' ');
                    var dateOnly = dateTimeParts[0] || item.date_registered;
                    var timeOnly = dateTimeParts[1] || '';
                    
                    table.row.add([item.invoice_number, item.patient_name, item.phone, item.charge_name, '$' + parseFloat(item.amount).toFixed(2), statusBadge, dateOnly, timeOnly, actions]);
                    if (isPaid) total += parseFloat(item.amount);
                });
            }
            table.draw();
            $('#tableTotal').text(total.toFixed(2));
        }

        function updateCharts(data) {
            if (revenueChart) revenueChart.destroy();
            if (xrayDistributionChart) xrayDistributionChart.destroy();

            var ctx1 = document.getElementById('revenueChart').getContext('2d');
            revenueChart = new Chart(ctx1, {
                type: 'bar',
                data: {
                    labels: data.dailyBreakdown.map(d => d.date),
                    datasets: [{ label: 'Daily Revenue', data: data.dailyBreakdown.map(d => parseFloat(d.revenue)), backgroundColor: 'rgba(49, 206, 54, 0.8)' }]
                },
                options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, ticks: { callback: function(value) { return '$' + value; } } } } }
            });

            var ctx2 = document.getElementById('xrayDistributionChart').getContext('2d');
            xrayDistributionChart = new Chart(ctx2, {
                type: 'doughnut',
                data: {
                    labels: data.xrayDistribution.map(d => d.xray_type),
                    datasets: [{ data: data.xrayDistribution.map(d => parseFloat(d.revenue)), backgroundColor: ['rgba(49, 206, 54, 0.8)', 'rgba(61, 178, 233, 0.8)', 'rgba(255, 185, 0, 0.8)', 'rgba(255, 87, 34, 0.8)', 'rgba(102, 126, 234, 0.8)'] }]
                },
                options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
            });
        }

        function exportToExcel() { table.button('.buttons-excel').trigger(); }

        function markAsPaid(chargeId) {
            Swal.fire({ title: 'Mark as Paid?', icon: 'question', showCancelButton: true, confirmButtonText: 'Yes, mark as paid!' }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        type: "POST", url: "xray_revenue_report.aspx/MarkAsPaid",
                        data: JSON.stringify({ chargeId: chargeId }), contentType: "application/json; charset=utf-8", dataType: "json",
                        success: function (response) { if (response.d === "true") { Swal.fire('Success!', 'Charge marked as paid.', 'success'); loadReport(); } }
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
