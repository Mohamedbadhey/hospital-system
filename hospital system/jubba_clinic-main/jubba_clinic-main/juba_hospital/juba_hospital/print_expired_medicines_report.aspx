<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="print_expired_medicines_report.aspx.cs" Inherits="juba_hospital.print_expired_medicines_report" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expired & Expiring Medicines Report</title>
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
        
        .table-header {
            background-color: #343a40;
            color: white;
        }
        
        .expired-row {
            background-color: #ffebee;
        }
        
        .expiring-row {
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

        .badge {
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }

        .badge-expired {
            background-color: #dc3545;
            color: white;
        }

        .badge-expiring {
            background-color: #ffc107;
            color: #000;
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
            <div class="report-title" style="font-size: 22px; color: #666; margin: 10px 0;">EXPIRED & EXPIRING MEDICINES REPORT</div>
            <div class="report-date" style="font-size: 14px; color: #999;">Generated on: <span id="reportDate"></span></div>
        </div>

        <!-- Summary Section -->
        <div class="summary-box">
            <div class="row">
                <div class="col-md-3">
                    <strong>Total Items:</strong> <span id="totalItems">0</span>
                </div>
                <div class="col-md-3">
                    <strong>Expired:</strong> <span id="expiredCount" class="text-danger">0</span>
                </div>
                <div class="col-md-3">
                    <strong>Expiring Soon:</strong> <span id="expiringCount" class="text-warning">0</span>
                </div>
                <div class="col-md-3">
                    <strong>Report Date:</strong> <span id="reportDateShort"></span>
                </div>
            </div>
        </div>

        <!-- Alert Message -->
        <div class="alert alert-danger" role="alert">
            <strong><i class="fas fa-exclamation-triangle"></i> Immediate Attention Required!</strong>
            The following medicines are either expired or expiring within 30 days. Please take appropriate action to prevent usage of expired medication and arrange for disposal/replacement.
        </div>

        <!-- Expired Medicines Table -->
        <table class="table table-bordered">
            <thead class="table-header">
                <tr>
                    <th style="width: 5%">#</th>
                    <th style="width: 25%">Medicine Name</th>
                    <th style="width: 12%">Batch Number</th>
                    <th style="width: 10%">Expiry Date</th>
                    <th style="width: 10%">Days Remaining</th>
                    <th style="width: 8%">Primary Qty</th>
                    <th style="width: 8%">Secondary Qty</th>
                    <th style="width: 10%">Unit Size</th>
                    <th style="width: 12%">Status</th>
                </tr>
            </thead>
            <tbody id="expiredTableBody">
                <!-- Data will be loaded here -->
            </tbody>
        </table>

        <!-- Footer Section -->
        <div class="footer-section">
            <div class="row">
                <div class="col-12 mb-3">
                    <p><strong>Disposal Instructions:</strong></p>
                    <ul>
                        <li>All expired medicines must be segregated immediately and marked as "EXPIRED - DO NOT USE"</li>
                        <li>Follow proper pharmaceutical waste disposal protocols</li>
                        <li>Document all disposed items with batch numbers and quantities</li>
                        <li>Update inventory system after disposal</li>
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
            var today = new Date();
            $('#reportDate').text(today.toLocaleString());
            $('#reportDateShort').text(today.toLocaleDateString());
            
            loadHospitalSettings();
            loadExpiredData();
        });

        function loadHospitalSettings() {
            // Hospital header is already loaded server-side via PrintHeaderLiteral
            // No additional loading needed
        }

        function loadExpiredData() {
            $.ajax({
                url: 'print_expired_medicines_report.aspx/getExpiredMedicines',
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function(response) {
                    if (response.d && response.d.length > 0) {
                        var tbody = $('#expiredTableBody');
                        tbody.empty();
                        
                        var expiredCount = 0;
                        var expiringCount = 0;
                        
                        response.d.forEach(function(item, index) {
                            var daysRemaining = parseInt(item.days_remaining);
                            var status = '';
                            var rowClass = '';
                            var daysText = '';
                            
                            if (daysRemaining < 0) {
                                status = '<span class="badge badge-expired">EXPIRED</span>';
                                rowClass = 'expired-row';
                                daysText = '<strong class="text-danger">Expired ' + Math.abs(daysRemaining) + ' days ago</strong>';
                                expiredCount++;
                            } else {
                                status = '<span class="badge badge-expiring">EXPIRING SOON</span>';
                                rowClass = 'expiring-row';
                                daysText = daysRemaining + ' days';
                                expiringCount++;
                            }
                            
                            var row = '<tr class="' + rowClass + '">' +
                                     '<td>' + (index + 1) + '</td>' +
                                     '<td><strong>' + item.medicine_name + '</strong></td>' +
                                     '<td>' + (item.batch_number || 'N/A') + '</td>' +
                                     '<td>' + item.expiry_date + '</td>' +
                                     '<td>' + daysText + '</td>' +
                                     '<td class="text-center">' + item.primary_quantity + '</td>' +
                                     '<td class="text-center">' + item.secondary_quantity + '</td>' +
                                     '<td class="text-center">' + item.unit_size + '</td>' +
                                     '<td class="text-center">' + status + '</td>' +
                                     '</tr>';
                            tbody.append(row);
                        });
                        
                        $('#totalItems').text(response.d.length);
                        $('#expiredCount').text(expiredCount);
                        $('#expiringCount').text(expiringCount);
                    } else {
                        $('#expiredTableBody').html('<tr><td colspan="9" class="text-center">No expired or expiring medicines found</td></tr>');
                        $('#totalItems').text('0');
                        $('#expiredCount').text('0');
                        $('#expiringCount').text('0');
                    }
                },
                error: function() {
                    $('#expiredTableBody').html('<tr><td colspan="9" class="text-center text-danger">Error loading data</td></tr>');
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
