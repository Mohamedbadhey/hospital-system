<%@ Page Title="Pharmacy Revenue Report" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="pharmacy_revenue_report.aspx.cs" Inherits="juba_hospital.pharmacy_revenue_report" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <style>
        .stat-box {
            background: linear-gradient(135deg, #FFB900 0%, #ff9800 100%);
            color: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .filter-card { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .revenue-stat { text-align: center; padding: 20px; background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .revenue-stat p { color: #000; font-weight: 600; }
        .revenue-stat h3 { color: #FFB900; font-size: 2rem; margin: 10px 0; }
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
                            <h4 class="card-title"><i class="fas fa-capsules"></i> Pharmacy Revenue Report</h4>
                            <p class="card-category">Detailed analysis of pharmacy sales and revenue</p>
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
                                    <p class="mb-0"><strong>Total Sales</strong></p>
                                    <h3><span id="totalCount">0</span></h3>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="revenue-stat">
                                    <p class="mb-0"><strong>Average Sale</strong></p>
                                    <h3>$<span id="avgSale">0.00</span></h3>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="revenue-stat">
                                    <p class="mb-0"><strong>Total Items Sold</strong></p>
                                    <h3><span id="itemsCount">0</span></h3>
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
                                    <option value="all">All Dates</option>
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
                                <label>Payment Method</label>
                                <select class="form-control" id="paymentMethod">
                                    <option value="all">All</option>
                                    <option value="Cash">Cash</option>
                                    <option value="Card">Card</option>
                                    <option value="Mobile Money">Mobile Money</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label>Search Customer</label>
                                <input type="text" class="form-control" id="customerSearch" placeholder="Enter customer name...">
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
                            <button class="btn btn-success" onclick="printProfessionalReport()"><i class="fas fa-print"></i> Print Professional Report</button>
                        </div>
                    </div>

                    <!-- Data Table -->
                    <div class="print-section">
                        <div class="table-responsive">
                            <table id="pharmacyTable" class="display table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Sale ID</th>
                                        <th>Customer Name</th>
                                        <th>Phone</th>
                                        <th>Items</th>
                                        <th>Total Amount</th>
                                        <th>Payment Method</th>
                                        <th>Sale Date</th>
                                        <th class="no-print">Actions</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                                <tfoot>
                                    <tr>
                                        <th colspan="4" class="text-end"><strong>Total:</strong></th>
                                        <th><strong>$<span id="tableTotal">0.00</span></strong></th>
                                        <th colspan="3"></th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>

                    <!-- Charts -->
                    <div class="row mt-4 no-print">
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header"><h5><i class="fas fa-chart-pie"></i> Payment Methods</h5></div>
                                <div class="card-body"><canvas id="paymentMethodChart" height="200"></canvas></div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header"><h5><i class="fas fa-chart-bar"></i> Top Selling Medicines</h5></div>
                                <div class="card-body"><canvas id="topMedicinesChart" height="200"></canvas></div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header"><h5><i class="fas fa-chart-line"></i> Daily Revenue</h5></div>
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
    <script src="https://cdn.jsdelivr.net/npm/chart.js" async defer></script>
    <script>
        var table, revenueChart, paymentMethodChart, topMedicinesChart;

        $(document).ready(function () {
            // Default to 'All Dates' on first load
            $('#dateRange').val('all');
            // Don't use DataTables - just use simple table
            table = null;
            console.log('Using simple table mode (no DataTables)');

            $('#dateRange').change(function() { $('#startDateDiv, #endDateDiv').toggle($(this).val() === 'custom'); });

            // Load today's report automatically on page load
            loadReport();
        });

        function loadReport() {
            var dateRange = $('#dateRange').val() || 'today';
            var startDate = $('#startDate').val() || '';
            var endDate = $('#endDate').val() || '';
            var paymentMethod = $('#paymentMethod').val() || 'all';
            var customerSearch = $('#customerSearch').val() || '';

            $.ajax({
                type: "POST",
                url: "pharmacy_revenue_report.aspx/GetPharmacyReport",
                data: JSON.stringify({ 
                    dateRange: dateRange, 
                    startDate: startDate, 
                    endDate: endDate,
                    paymentMethod: paymentMethod,
                    customerSearch: customerSearch
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log('Pharmacy report data received:', response);
                    if (response.d) {
                        updateStatistics(response.d.statistics);
                        updateTable(response.d.details);
                        updateCharts(response.d);
                    } else {
                        console.error('No data received');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error loading pharmacy report:', xhr.responseText);
                    Swal.fire('Error', 'Failed to load report: ' + error, 'error');
                }
            });
        }

        function updateStatistics(stats) {
            $('#totalRevenue').text(parseFloat(stats.total_revenue || 0).toFixed(2));
            $('#totalCount').text(stats.total_sales || 0);
            $('#avgSale').text(parseFloat(stats.average_sale || 0).toFixed(2));
            $('#itemsCount').text(stats.total_items || 0);
        }

        function updateTable(data) {
            // Clear table body
            var tbody = $('#pharmacyTable tbody');
            tbody.empty();
            var total = 0;
            if (data) {
                data.forEach(function(item) {
                    var actions = '<button class="btn btn-sm btn-info" onclick="viewInvoice(' + item.sale_id + ')">View Invoice</button> <button class="btn btn-sm btn-primary" onclick="viewItems(' + item.sale_id + ')">View Items</button>';
                    var row = '<tr>' +
                        '<td>' + item.sale_id + '</td>' +
                        '<td>' + item.customer_name + '</td>' +
                        '<td>' + (item.customer_phone || 'N/A') + '</td>' +
                        '<td>' + item.item_count + '</td>' +
                        '<td>$' + parseFloat(item.total_amount).toFixed(2) + '</td>' +
                        '<td>' + item.payment_method + '</td>' +
                        '<td>' + item.sale_date + '</td>' +
                        '<td>' + actions + '</td>' +
                        '</tr>';
                    
                    tbody.append(row);
                    total += parseFloat(item.total_amount);
                });
            }
            $('#tableTotal').text(total.toFixed(2));
        }

        function updateCharts(data) {
            if (revenueChart) revenueChart.destroy();
            if (paymentMethodChart) paymentMethodChart.destroy();
            if (topMedicinesChart) topMedicinesChart.destroy();

            var ctx1 = document.getElementById('revenueChart').getContext('2d');
            revenueChart = new Chart(ctx1, {
                type: 'line',
                data: { labels: data.dailyBreakdown.map(d => d.date), datasets: [{ label: 'Daily Revenue', data: data.dailyBreakdown.map(d => parseFloat(d.revenue)), borderColor: 'rgba(255, 185, 0, 1)', backgroundColor: 'rgba(255, 185, 0, 0.2)', fill: true }] },
                options: { responsive: true, maintainAspectRatio: false, scales: { y: { beginAtZero: true, ticks: { callback: function(value) { return '$' + value; } } } } }
            });

            var ctx2 = document.getElementById('paymentMethodChart').getContext('2d');
            paymentMethodChart = new Chart(ctx2, {
                type: 'pie',
                data: { labels: data.paymentDistribution.map(d => d.payment_method), datasets: [{ data: data.paymentDistribution.map(d => parseFloat(d.amount)), backgroundColor: ['rgba(49, 206, 54, 0.8)', 'rgba(61, 178, 233, 0.8)', 'rgba(255, 185, 0, 0.8)'] }] },
                options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } }
            });

            var ctx3 = document.getElementById('topMedicinesChart').getContext('2d');
            topMedicinesChart = new Chart(ctx3, {
                type: 'bar',
                data: { labels: data.topMedicines.map(d => d.medicine_name), datasets: [{ label: 'Quantity Sold', data: data.topMedicines.map(d => parseInt(d.quantity)), backgroundColor: 'rgba(255, 185, 0, 0.8)' }] },
                options: { responsive: true, maintainAspectRatio: false, indexAxis: 'y', scales: { x: { beginAtZero: true } } }
            });
        }

        function printProfessionalReport() {
            var dateRange = $('#dateRange').val() || 'all';
            var startDate = $('#startDate').val() || '';
            var endDate = $('#endDate').val() || '';
            var paymentMethod = $('#paymentMethod').val() || 'all';
            var customerSearch = $('#customerSearch').val() || '';

            var url = 'print_pharmacy_revenue_report.aspx?';
            url += 'dateRange=' + encodeURIComponent(dateRange);
            url += '&startDate=' + encodeURIComponent(startDate);
            url += '&endDate=' + encodeURIComponent(endDate);
            url += '&paymentMethod=' + encodeURIComponent(paymentMethod);
            url += '&customerSearch=' + encodeURIComponent(customerSearch);

            window.open(url, '_blank');
        }

        function exportToExcel() { table.button('.buttons-excel').trigger(); }
        function viewInvoice(saleId) { window.open('pharmacy_invoice.aspx?sale_id=' + saleId, '_blank'); }
        function viewItems(saleId) { 
            Swal.fire({ title: 'Sale Items', html: '<div id="saleItems">Loading...</div>', width: '600px', showCloseButton: true });
            // Load sale items via AJAX here
        }
    </script>
    
    <!-- Watermark -->
    <div class="print-watermark">
        <img src="assets/vafmadow.png" alt="Hospital Logo Watermark" />
    </div>
</asp:Content>
