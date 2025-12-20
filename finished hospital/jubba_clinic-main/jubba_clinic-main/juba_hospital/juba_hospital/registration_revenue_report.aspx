<%@ Page Title="Registration Revenue Report" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="registration_revenue_report.aspx.cs" Inherits="juba_hospital.registration_revenue_report" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <style>
        .stat-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
            color: #667eea;
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
                            <h4 class="card-title"><i class="fas fa-user-plus"></i> Registration Revenue Report</h4>
                            <p class="card-category">Detailed analysis of registration charges and revenue</p>
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
                                    <p class="mb-0"><strong>Total Registrations</strong></p>
                                    <h3><span id="totalCount">0</span></h3>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="revenue-stat">
                                    <p class="mb-0"><strong>Average Fee</strong></p>
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
                                <label>Search Patient</label>
                                <input type="text" class="form-control" id="patientSearch" placeholder="Enter patient name...">
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
                            <button class="btn btn-success" onclick="printProfessionalReport()">
                                <i class="fas fa-print"></i> Print Professional Report
                            </button>
                        </div>
                    </div>

                    <!-- Data Table -->
                    <div class="print-section">
                        <div class="table-responsive">
                            <table id="registrationTable" class="display table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Invoice #</th>
                                        <th>Patient Name</th>
                                        <th>Phone</th>
                                        <th>Charge Name</th>
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

                    <!-- Daily Breakdown Chart -->
                    <div class="row mt-4 no-print">
                        <div class="col-md-12">
                            <div class="card">
                                <div class="card-header">
                                    <h5><i class="fas fa-chart-bar"></i> Daily Revenue Breakdown</h5>
                                </div>
                                <div class="card-body">
                                    <canvas id="revenueChart" height="100"></canvas>
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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        var table;
        var revenueChart;

        $(document).ready(function () {
            // Don't use DataTables - just use simple table
            table = null;
            console.log('Using simple table mode (no DataTables)');

            // Handle date range change
            $('#dateRange').change(function() {
                if ($(this).val() === 'custom') {
                    $('#startDateDiv, #endDateDiv').show();
                } else {
                    $('#startDateDiv, #endDateDiv').hide();
                }
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
                url: "registration_revenue_report.aspx/GetRegistrationReport",
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
                    console.log('Report data received:', response);
                    if (response.d) {
                        updateStatistics(response.d.statistics);
                        updateTable(response.d.details);
                        updateChart(response.d.dailyBreakdown);
                    } else {
                        console.error('No data received');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error loading report:', xhr.responseText);
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
            // Clear table body
            var tbody = $('#registrationTable tbody');
            tbody.empty();
            var total = 0;

            if (data && data.length > 0) {
                data.forEach(function(item) {
                    console.log('Item is_paid value:', item.is_paid, 'Type:', typeof item.is_paid);
                    
                    // Handle both string "1"/"0" and boolean true/false and string "True"/"False"
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

        function updateChart(dailyData) {
            if (revenueChart) {
                revenueChart.destroy();
            }

            var ctx = document.getElementById('revenueChart').getContext('2d');
            var labels = dailyData.map(d => d.date);
            var values = dailyData.map(d => parseFloat(d.revenue));

            revenueChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Daily Revenue',
                        data: values,
                        backgroundColor: 'rgba(102, 126, 234, 0.8)',
                        borderColor: 'rgba(102, 126, 234, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return '$' + value;
                                }
                            }
                        }
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
                        url: "registration_revenue_report.aspx/MarkAsPaid",
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

        function printProfessionalReport() {
            // Get current filter values
            var dateRange = $('#dateRange').val() || 'today';
            var startDate = $('#startDate').val() || '';
            var endDate = $('#endDate').val() || '';
            var paymentStatus = $('#paymentStatus').val() || 'all';
            var patientSearch = $('#patientSearch').val() || '';

            // Build URL with query parameters
            var url = 'print_registration_revenue.aspx?';
            url += 'dateRange=' + encodeURIComponent(dateRange);
            url += '&startDate=' + encodeURIComponent(startDate);
            url += '&endDate=' + encodeURIComponent(endDate);
            url += '&paymentStatus=' + encodeURIComponent(paymentStatus);
            url += '&patientSearch=' + encodeURIComponent(patientSearch);

            // Open in new window
            window.open(url, '_blank');
        }
    </script>
    
    <!-- Watermark -->
    <div class="print-watermark">
        <img src="assets/vafmadow.png" alt="Hospital Logo Watermark" />
    </div>
</asp:Content>
