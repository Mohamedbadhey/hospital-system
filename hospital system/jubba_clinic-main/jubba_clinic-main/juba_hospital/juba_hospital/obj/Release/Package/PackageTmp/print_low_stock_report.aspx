<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="print_low_stock_report.aspx.cs" Inherits="juba_hospital.print_low_stock_report" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Low Stock Alert Report</title>
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
            border-left: 4px solid #dc3545;
            padding: 15px;
            margin: 20px 0;
        }
        
        .alert-high {
            background-color: #f8d7da;
            border-left: 4px solid #dc3545;
        }
        
        .alert-medium {
            background-color: #fff3cd;
            border-left: 4px solid #ffc107;
        }
        
        .table-header {
            background-color: #343a40;
            color: white;
        }
        
        .urgent-row {
            background-color: #ffebee;
        }
        
        .warning-row {
            background-color: #fff9e6;
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
            <div class="report-title" style="font-size: 22px; color: #666; margin: 10px 0;">LOW STOCK ALERT REPORT</div>
            <div class="report-date" style="font-size: 14px; color: #999;">Generated on: <span id="reportDate"></span></div>
        </div>

        <!-- Summary Section -->
        <div class="summary-box">
            <div class="row">
                <div class="col-md-4">
                    <strong>Total Items Below Reorder Level:</strong> <span id="totalLowStock">0</span>
                </div>
                <div class="col-md-4">
                    <strong>Critical (0 stock):</strong> <span id="criticalCount" class="text-danger">0</span>
                </div>
                <div class="col-md-4">
                    <strong>Report Date:</strong> <span id="reportDateShort"></span>
                </div>
            </div>
        </div>

        <!-- Alert Message -->
        <div class="alert alert-danger" role="alert">
            <strong><i class="fas fa-exclamation-triangle"></i> Immediate Action Required!</strong>
            The following medicines are below their reorder levels. Please arrange for restocking immediately.
        </div>

        <!-- Low Stock Table -->
        <table class="table table-bordered">
            <thead class="table-header">
                <tr>
                    <th style="width: 5%">#</th>
                    <th style="width: 30%">Medicine Name</th>
                    <th style="width: 20%">Generic Name</th>
                    <th style="width: 10%">Unit Type</th>
                    <th style="width: 10%">Current Stock</th>
                    <th style="width: 10%">Reorder Level</th>
                    <th style="width: 15%">Status</th>
                </tr>
            </thead>
            <tbody id="lowStockTableBody">
                <!-- Data will be loaded here -->
            </tbody>
        </table>

        <!-- Footer Section -->
        <div class="footer-section">
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
            var today = new Date();
            $('#reportDate').text(today.toLocaleString());
            $('#reportDateShort').text(today.toLocaleDateString());
            
            loadHospitalSettings();
            loadLowStockData();
        });

        function loadHospitalSettings() {
            // Hospital header is already loaded server-side via PrintHeaderLiteral
            // No additional loading needed
        }

        function loadLowStockData() {
            $.ajax({
                url: 'print_low_stock_report.aspx/getLowStockMedicines',
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function(response) {
                    if (response.d && response.d.length > 0) {
                        var tbody = $('#lowStockTableBody');
                        tbody.empty();
                        
                        var criticalCount = 0;
                        
                        response.d.forEach(function(item, index) {
                            var currentStock = parseInt(item.primary_quantity || 0);
                            var reorderLevel = parseInt(item.reorder_level_strips || 0);
                            var stockUnit = item.subdivision_unit || 'units';
                            
                            var status = '';
                            var rowClass = '';
                            
                            if (currentStock === 0) {
                                status = '<span class="badge bg-danger">OUT OF STOCK</span>';
                                rowClass = 'urgent-row';
                                criticalCount++;
                            } else if (currentStock <= reorderLevel / 2) {
                                status = '<span class="badge bg-danger">CRITICAL</span>';
                                rowClass = 'urgent-row';
                                criticalCount++;
                            } else {
                                status = '<span class="badge bg-warning">LOW</span>';
                                rowClass = 'warning-row';
                            }
                            
                            var row = '<tr class="' + rowClass + '">' +
                                     '<td>' + (index + 1) + '</td>' +
                                     '<td><strong>' + item.medicine_name + '</strong><br>' +
                                     '<small class="text-muted">' + (item.manufacturer || '') + '</small></td>' +
                                     '<td>' + (item.generic_name || '-') + '</td>' +
                                     '<td>' + (item.unit_name || 'N/A') + '</td>' +
                                     '<td class="text-center"><strong>' + currentStock + ' ' + stockUnit + '</strong></td>' +
                                     '<td class="text-center">' + reorderLevel + ' ' + stockUnit + '</td>' +
                                     '<td class="text-center">' + status + '</td>' +
                                     '</tr>';
                            tbody.append(row);
                        });
                        
                        $('#totalLowStock').text(response.d.length);
                        $('#criticalCount').text(criticalCount);
                    } else {
                        $('#lowStockTableBody').html('<tr><td colspan="7" class="text-center">No low stock items found</td></tr>');
                        $('#totalLowStock').text('0');
                        $('#criticalCount').text('0');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error loading low stock data:', error);
                    console.error('Response:', xhr.responseText);
                    var errorMsg = 'Error loading data';
                    try {
                        var errorObj = JSON.parse(xhr.responseText);
                        if (errorObj.Message) {
                            errorMsg = errorObj.Message;
                        }
                    } catch(e) {
                        errorMsg = xhr.responseText || error;
                    }
                    $('#lowStockTableBody').html('<tr><td colspan="7" class="text-center text-danger">' + errorMsg + '</td></tr>');
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