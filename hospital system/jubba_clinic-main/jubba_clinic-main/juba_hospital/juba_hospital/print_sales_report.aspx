<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="print_sales_report.aspx.cs" Inherits="juba_hospital.print_sales_report" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pharmacy Sales Report</title>
    <link rel="stylesheet" href="Content/print-header.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        @media print {
            .no-print {
                display: none !important;
            }
            
            body {
                margin: 0;
                padding: 20px;
            }
            
            .page-break {
                page-break-after: always;
            }
        }
        
        body {
            background: white;
            font-family: Arial, sans-serif;
            font-size: 12px;
        }
        
        .report-header {
            text-align: center;
            border-bottom: 3px solid #333;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        
        .hospital-name {
            font-size: 28px;
            font-weight: bold;
            color: #333;
            margin-bottom: 5px;
        }
        
        .report-title {
            font-size: 22px;
            color: #666;
            margin: 10px 0;
        }
        
        .report-date {
            font-size: 14px;
            color: #999;
        }
        
        .summary-box {
            background: #f8f9fa;
            border: 2px solid #667eea;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .summary-label {
            font-weight: bold;
            color: #333;
        }
        
        .summary-value {
            color: #667eea;
            font-weight: bold;
        }
        
        .summary-large {
            font-size: 20px;
            padding: 15px;
            background: #667eea;
            color: white;
            border-radius: 8px;
            text-align: center;
            margin: 10px 0;
        }
        
        .table-header {
            background-color: #343a40;
            color: white;
        }
        
        .footer-section {
            margin-top: 50px;
            padding-top: 20px;
            border-top: 2px solid #ddd;
        }
        
        .signature-line {
            border-top: 1px solid #333;
            width: 200px;
            margin-top: 50px;
            display: inline-block;
        }

        .section-title {
            background: #667eea;
            color: white;
            padding: 10px 15px;
            margin: 20px 0 10px 0;
            border-radius: 5px;
            font-weight: bold;
        }

        .highlight-profit {
            background-color: #d4edda;
            font-weight: bold;
        }

        .highlight-loss {
            background-color: #f8d7da;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Print Button -->
        <div class="no-print text-center mb-3">
            <button type="button" class="btn btn-primary btn-lg" onclick="window.print()">
                <i class="fas fa-print"></i> Print Report
            </button>
            <button type="button" class="btn btn-secondary btn-lg" onclick="window.close()">
                <i class="fas fa-times"></i> Close
            </button>
        </div>

        <!-- Hospital Print Header -->
        <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>
        
        <!-- Report Title -->
        <div class="report-header" style="text-align: center; margin-bottom: 30px;">
            <div class="report-title" style="font-size: 22px; color: #666; margin: 10px 0;">PHARMACY SALES & PROFIT REPORT</div>
            <div class="report-date" style="font-size: 14px; color: #999;">Period: <span id="reportPeriod"></span> | Generated on: <span id="reportDate"></span></div>
        </div>

        <!-- Executive Summary -->
        <div class="summary-box">
            <h5 style="color: #667eea; margin-bottom: 20px;">📊 EXECUTIVE SUMMARY</h5>
            <div class="row">
                <div class="col-md-6">
                    <div class="summary-row">
                        <span class="summary-label">Total Sales Revenue:</span>
                        <span class="summary-value" id="summaryTotalSales">$0.00</span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Total Cost of Goods:</span>
                        <span class="summary-value" id="summaryTotalCost">$0.00</span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Gross Profit:</span>
                        <span class="summary-value" id="summaryTotalProfit">$0.00</span>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="summary-row">
                        <span class="summary-label">Profit Margin:</span>
                        <span class="summary-value" id="summaryProfitMargin">0%</span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Total Transactions:</span>
                        <span class="summary-value" id="summaryTransactions">0</span>
                    </div>
                    <div class="summary-row">
                        <span class="summary-label">Average Sale Value:</span>
                        <span class="summary-value" id="summaryAvgSale">$0.00</span>
                    </div>
                </div>
            </div>
            <div class="summary-large">
                NET PROFIT: <span id="summaryNetProfit">$0.00</span>
            </div>
        </div>

        <!-- Sales Transactions Detail -->
        <div class="section-title">DETAILED SALES TRANSACTIONS</div>
        <table class="table table-bordered table-sm">
            <thead class="table-header">
                <tr>
                    <th style="width: 5%">#</th>
                    <th style="width: 20%">Medicine(s)</th>
                    <th style="width: 10%">Date</th>
                    <th style="width: 15%">Customer</th>
                    <th style="width: 8%">Items</th>
                    <th style="width: 12%">Total Sale</th>
                    <th style="width: 12%">Total Cost</th>
                    <th style="width: 12%">Profit</th>
                    <th style="width: 10%">Margin %</th>
                </tr>
            </thead>
            <tbody id="salesTableBody">
                <!-- Data will be loaded here -->
            </tbody>
            <tfoot class="table-info">
                <tr style="font-weight: bold; background-color: #e9ecef;">
                    <td colspan="5" class="text-end">TOTALS:</td>
                    <td id="footerTotalSales">$0.00</td>
                    <td id="footerTotalCost">$0.00</td>
                    <td id="footerTotalProfit">$0.00</td>
                    <td id="footerAvgMargin">0%</td>
                </tr>
            </tfoot>
        </table>

        <!-- Top Selling Medicines -->
        <div class="section-title">TOP 10 SELLING MEDICINES</div>
        <table class="table table-bordered table-sm">
            <thead class="table-header">
                <tr>
                    <th style="width: 5%">#</th>
                    <th style="width: 40%">Medicine Name</th>
                    <th style="width: 15%">Quantity Sold</th>
                    <th style="width: 20%">Total Revenue</th>
                    <th style="width: 20%">Total Profit</th>
                </tr>
            </thead>
            <tbody id="topMedicinesBody">
                <!-- Data will be loaded here -->
            </tbody>
        </table>

        <!-- Performance Indicators -->
        <div class="section-title">PERFORMANCE INDICATORS</div>
        <div class="row">
            <div class="col-md-6">
                <table class="table table-bordered table-sm">
                    <tr>
                        <td><strong>Best Performing Day:</strong></td>
                        <td id="bestDay">-</td>
                    </tr>
                    <tr>
                        <td><strong>Highest Single Sale:</strong></td>
                        <td id="highestSale">$0.00</td>
                    </tr>
                    <tr>
                        <td><strong>Total Items Sold:</strong></td>
                        <td id="totalItemsSold">0</td>
                    </tr>
                </table>
            </div>
            <div class="col-md-6">
                <table class="table table-bordered table-sm">
                    <tr>
                        <td><strong>Average Items per Sale:</strong></td>
                        <td id="avgItemsPerSale">0</td>
                    </tr>
                    <tr>
                        <td><strong>Sales Frequency:</strong></td>
                        <td id="salesFrequency">0 per day</td>
                    </tr>
                    <tr>
                        <td><strong>Cost-to-Sale Ratio:</strong></td>
                        <td id="costRatio">0%</td>
                    </tr>
                </table>
            </div>
        </div>

        <!-- Footer Section -->
        <div class="footer-section">
            <div class="row">
                <div class="col-12 mb-3">
                    <p><strong>Report Notes:</strong></p>
                    <ul>
                        <li>All amounts are in USD ($)</li>
                        <li>Profit Margin = (Profit / Total Sales) × 100</li>
                        <li>This report includes only completed transactions</li>
                        <li>Data is accurate as of report generation time</li>
                    </ul>
                </div>
            </div>
            <div class="row">
                <div class="col-6">
                    <p><strong>Prepared By:</strong></p>
                    <p class="signature-line text-center">Pharmacy Staff</p>
                </div>
                <div class="col-6">
                    <p><strong>Approved By:</strong></p>
                    <p class="signature-line text-center">Pharmacy Manager</p>
                </div>
            </div>
            <div class="row mt-4">
                <div class="col-12">
                    <p class="text-muted text-center">
                        <small>This is a computer-generated report from Juba Hospital Management System</small>
                    </p>
                </div>
            </div>
        </div>
    </form>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Get URL parameters
            var urlParams = new URLSearchParams(window.location.search);
            var fromDate = urlParams.get('fromDate');
            var toDate = urlParams.get('toDate');
            
            // Set report date
            var today = new Date();
            $('#reportDate').text(today.toLocaleString());
            $('#reportPeriod').text(formatDate(fromDate) + ' to ' + formatDate(toDate));
            
            loadHospitalSettings();
            loadSalesData(fromDate, toDate);
            loadTopMedicines(fromDate, toDate);
        });

        function formatDate(dateStr) {
            if (!dateStr) return '';
            var date = new Date(dateStr);
            var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            return months[date.getMonth()] + ' ' + date.getDate() + ', ' + date.getFullYear();
        }

        function loadHospitalSettings() {
            // Hospital header is already loaded server-side via PrintHeaderLiteral
            // No additional loading needed
        }

        function loadSalesData(fromDate, toDate) {
            $.ajax({
                url: 'print_sales_report.aspx/getSalesReport',
                type: 'POST',
                data: JSON.stringify({ fromDate: fromDate, toDate: toDate }),
                contentType: 'application/json',
                dataType: 'json',
                success: function(response) {
                    if (response.d && response.d.length > 0) {
                        var tbody = $('#salesTableBody');
                        tbody.empty();
                        
                        var totalSales = 0;
                        var totalCost = 0;
                        var totalProfit = 0;
                        var totalItems = 0;
                        var highestSale = 0;
                        var bestDay = '';
                        var dailySales = {};
                        
                        response.d.forEach(function(sale, index) {
                            var saleAmount = parseFloat(sale.total_amount || 0);
                            var saleCost = parseFloat(sale.total_cost || 0);
                            var profit = parseFloat(sale.profit || 0);
                            var items = parseInt(sale.total_items || 0);
                            var margin = saleAmount > 0 ? ((profit / saleAmount) * 100).toFixed(2) : 0;
                            
                            totalSales += saleAmount;
                            totalCost += saleCost;
                            totalProfit += profit;
                            totalItems += items;
                            
                            if (saleAmount > highestSale) {
                                highestSale = saleAmount;
                            }
                            
                            // Track daily sales
                            var saleDate = sale.sale_date;
                            if (!dailySales[saleDate]) {
                                dailySales[saleDate] = 0;
                            }
                            dailySales[saleDate] += saleAmount;
                            
                            var profitClass = profit > 0 ? 'highlight-profit' : 'highlight-loss';
                            
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
                                    medicineDisplay = '<strong>' + names[0] + '</strong><br/><small style="color: #666;">+ ' + (medicineCount - 1) + ' more</small>';
                                }
                            } else {
                                medicineDisplay = '<em style="color: #999;">No items</em>';
                            }
                            
                            var row = '<tr>' +
                                     '<td>' + (index + 1) + '</td>' +
                                     '<td>' + medicineDisplay + '</td>' +
                                     '<td>' + sale.sale_date + '</td>' +
                                     '<td>' + (sale.customer_name || 'Walk-in') + '</td>' +
                                     '<td class="text-center">' + items + '</td>' +
                                     '<td class="text-end">$' + saleAmount.toFixed(2) + '</td>' +
                                     '<td class="text-end">$' + saleCost.toFixed(2) + '</td>' +
                                     '<td class="text-end ' + profitClass + '">$' + profit.toFixed(2) + '</td>' +
                                     '<td class="text-center">' + margin + '%</td>' +
                                     '</tr>';
                            tbody.append(row);
                        });
                        
                        // Find best day
                        var maxDailySale = 0;
                        for (var date in dailySales) {
                            if (dailySales[date] > maxDailySale) {
                                maxDailySale = dailySales[date];
                                bestDay = date;
                            }
                        }
                        
                        // Calculate metrics
                        var profitMargin = totalSales > 0 ? ((totalProfit / totalSales) * 100).toFixed(2) : 0;
                        var avgSale = response.d.length > 0 ? (totalSales / response.d.length) : 0;
                        var avgMargin = totalSales > 0 ? ((totalProfit / totalSales) * 100).toFixed(2) : 0;
                        var avgItemsPerSale = response.d.length > 0 ? (totalItems / response.d.length).toFixed(1) : 0;
                        var costRatio = totalSales > 0 ? ((totalCost / totalSales) * 100).toFixed(2) : 0;
                        
                        // Calculate days in period
                        var from = new Date(fromDate);
                        var to = new Date(toDate);
                        var daysDiff = Math.ceil((to - from) / (1000 * 60 * 60 * 24)) + 1;
                        var salesPerDay = (response.d.length / daysDiff).toFixed(1);
                        
                        // Update summary
                        $('#summaryTotalSales').text('$' + totalSales.toFixed(2));
                        $('#summaryTotalCost').text('$' + totalCost.toFixed(2));
                        $('#summaryTotalProfit').text('$' + totalProfit.toFixed(2));
                        $('#summaryProfitMargin').text(profitMargin + '%');
                        $('#summaryTransactions').text(response.d.length);
                        $('#summaryAvgSale').text('$' + avgSale.toFixed(2));
                        $('#summaryNetProfit').text('$' + totalProfit.toFixed(2));
                        
                        // Update footer
                        $('#footerTotalSales').text('$' + totalSales.toFixed(2));
                        $('#footerTotalCost').text('$' + totalCost.toFixed(2));
                        $('#footerTotalProfit').text('$' + totalProfit.toFixed(2));
                        $('#footerAvgMargin').text(avgMargin + '%');
                        
                        // Update performance indicators
                        $('#bestDay').text(bestDay + ' ($' + maxDailySale.toFixed(2) + ')');
                        $('#highestSale').text('$' + highestSale.toFixed(2));
                        $('#totalItemsSold').text(totalItems);
                        $('#avgItemsPerSale').text(avgItemsPerSale);
                        $('#salesFrequency').text(salesPerDay + ' per day');
                        $('#costRatio').text(costRatio + '%');
                        
                    } else {
                        $('#salesTableBody').html('<tr><td colspan="9" class="text-center">No sales data found for this period</td></tr>');
                    }
                },
                error: function() {
                    $('#salesTableBody').html('<tr><td colspan="9" class="text-center text-danger">Error loading sales data</td></tr>');
                }
            });
        }

        function loadTopMedicines(fromDate, toDate) {
            $.ajax({
                url: 'print_sales_report.aspx/getTopMedicines',
                type: 'POST',
                data: JSON.stringify({ fromDate: fromDate, toDate: toDate }),
                contentType: 'application/json',
                dataType: 'json',
                success: function(response) {
                    if (response.d && response.d.length > 0) {
                        var tbody = $('#topMedicinesBody');
                        tbody.empty();
                        
                        response.d.forEach(function(med, index) {
                            var row = '<tr>' +
                                     '<td>' + (index + 1) + '</td>' +
                                     '<td><strong>' + med.medicine_name + '</strong></td>' +
                                     '<td class="text-center">' + med.total_quantity + '</td>' +
                                     '<td class="text-end">$' + parseFloat(med.total_revenue || 0).toFixed(2) + '</td>' +
                                     '<td class="text-end">$' + parseFloat(med.total_profit || 0).toFixed(2) + '</td>' +
                                     '</tr>';
                            tbody.append(row);
                        });
                    } else {
                        $('#topMedicinesBody').html('<tr><td colspan="5" class="text-center">No top medicines data available</td></tr>');
                    }
                },
                error: function() {
                    $('#topMedicinesBody').html('<tr><td colspan="5" class="text-center text-danger">Error loading top medicines</td></tr>');
                }
            });
        }
    </script>
    
    <!-- Watermark -->
    <% var __logoUrl = juba_hospital.HospitalSettingsHelper.GetPrintLogoUrl(); %>
    <div class="print-watermark">
        <img src="<%= __logoUrl %>" alt="Hospital Logo Watermark" />
    </div>
</body>
</html>
