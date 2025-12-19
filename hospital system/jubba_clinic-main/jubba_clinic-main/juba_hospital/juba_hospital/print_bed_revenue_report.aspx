<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="print_bed_revenue_report.aspx.cs" Inherits="juba_hospital.print_bed_revenue_report" %>

<!DOCTYPE html>
<html>
<head>
    <title>Bed Charges Revenue Report - Print</title>
    <link rel="stylesheet" href="Content/print-header.css" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 20mm;
            background: white;
            color: #000;
        }

        .report-title-section {
            text-align: center;
            margin: 20px 0 30px 0;
            padding: 15px 0;
            border-bottom: 3px solid #fd7e14;
        }

        .report-title {
            font-size: 22px;
            color: #fd7e14;
            font-weight: bold;
            margin: 0;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .report-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            border: 1px solid #dee2e6;
        }

        .report-info p {
            margin: 5px 0;
            font-size: 14px;
        }

        .summary-boxes {
            display: flex;
            justify-content: space-between;
            margin: 30px 0;
            gap: 15px;
        }

        .summary-box {
            flex: 1;
            border: 2px solid #fd7e14;
            padding: 20px;
            text-align: center;
            border-radius: 8px;
            background: linear-gradient(135deg, #fff5e6 0%, #ffe8cc 100%);
        }

        .summary-box h4 {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
            text-transform: uppercase;
        }

        .summary-box .value {
            font-size: 28px;
            font-weight: bold;
            color: #fd7e14;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 30px 0;
        }

        thead {
            background: linear-gradient(135deg, #fd7e14 0%, #e8590c 100%);
            color: white;
        }

        th {
            padding: 12px;
            text-align: left;
            font-weight: bold;
            border: 1px solid #e8590c;
            font-size: 13px;
        }

        td {
            padding: 10px 12px;
            border: 1px solid #ddd;
            font-size: 12px;
        }

        tbody tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tbody tr:hover {
            background-color: #fff5e6;
        }

        tfoot td {
            font-weight: bold;
            background: linear-gradient(135deg, #ffe8cc 0%, #fff5e6 100%);
            font-size: 14px;
            padding: 15px 12px;
            border: 2px solid #fd7e14;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
        }

        .status-paid {
            background: #d4edda;
            color: #155724;
        }

        .status-unpaid {
            background: #fff3cd;
            color: #856404;
        }

        .footer {
            margin-top: 50px;
            text-align: center;
            padding-top: 20px;
            border-top: 2px solid #ddd;
            color: #999;
            font-size: 11px;
        }

        .watermark {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            opacity: 0.05;
            z-index: -1;
        }

        .watermark img {
            width: 500px;
            height: auto;
        }

        .daily-breakdown {
            margin: 40px 0;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }

        .daily-breakdown h3 {
            color: #fd7e14;
            margin-bottom: 15px;
            font-size: 18px;
        }

        .daily-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #ddd;
        }

        .daily-item:last-child {
            border-bottom: none;
        }

        .daily-item .date {
            font-weight: bold;
            color: #2c3e50;
        }

        .daily-item .amount {
            color: #fd7e14;
            font-weight: bold;
        }

        @media print {
            body {
                padding: 10mm;
            }
            
            table {
                page-break-inside: auto;
            }
            
            tr {
                page-break-inside: avoid;
                page-break-after: auto;
            }
            
            thead {
                display: table-header-group;
            }
            
            tfoot {
                display: table-footer-group;
            }

            .summary-boxes {
                page-break-inside: avoid;
            }

            .daily-breakdown {
                page-break-inside: avoid;
            }
        }

        @page {
            margin: 15mm;
        }
    </style>
</head>
<body>
    <!-- Watermark -->
    <% var __logoUrl = juba_hospital.HospitalSettingsHelper.GetPrintLogoUrl(); %>
    <div class="watermark">
        <img src="<%= __logoUrl %>" alt="Hospital Watermark" />
    </div>

    <!-- Hospital Header from Settings -->
    <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>
    
    <!-- Report Title -->
    <div class="report-title-section">
        <h2 class="report-title">Bed Charges Revenue Report</h2>
    </div>

    <!-- Report Information -->
    <div class="report-info">
        <p><strong>Report Period:</strong> <asp:Literal ID="litDateRange" runat="server"></asp:Literal></p>
        <p><strong>Filter Applied:</strong> <asp:Literal ID="litFilter" runat="server">All Bed Charges</asp:Literal></p>
        <p><strong>Generated On:</strong> <asp:Literal ID="litGeneratedDate" runat="server"></asp:Literal></p>
        <p><strong>Generated By:</strong> <asp:Literal ID="litGeneratedBy" runat="server"></asp:Literal></p>
    </div>

    <!-- Summary Boxes -->
    <div class="summary-boxes">
        <div class="summary-box">
            <h4>Total Revenue</h4>
            <div class="value">$<asp:Literal ID="litTotalRevenue" runat="server">0.00</asp:Literal></div>
        </div>
        <div class="summary-box">
            <h4>Total Charges</h4>
            <div class="value"><asp:Literal ID="litTotalCount" runat="server">0</asp:Literal></div>
        </div>
        <div class="summary-box">
            <h4>Average Charge</h4>
            <div class="value">$<asp:Literal ID="litAvgFee" runat="server">0.00</asp:Literal></div>
        </div>
        <div class="summary-box">
            <h4>Pending Payments</h4>
            <div class="value"><asp:Literal ID="litPendingCount" runat="server">0</asp:Literal></div>
        </div>
    </div>

    <!-- Bed Charges Table -->
    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Patient Name</th>
                <th>Phone</th>
                <th>Charge Date</th>
                <th>Amount</th>
                <th>Status</th>
            </tr>
        </thead>
        <tbody>
            <asp:Repeater ID="rptBedCharges" runat="server">
                <ItemTemplate>
                    <tr>
                        <td><%# Container.ItemIndex + 1 %></td>
                        <td><%# Eval("patient_name") %></td>
                        <td><%# Eval("phone") %></td>
                        <td><%# Eval("charge_date", "{0:MMM dd, yyyy hh:mm tt}") %></td>
                        <td>$<%# Eval("amount", "{0:N2}") %></td>
                        <td>
                            <span class='status-badge <%# Convert.ToBoolean(Eval("is_paid")) ? "status-paid" : "status-unpaid" %>'>
                                <%# Convert.ToBoolean(Eval("is_paid")) ? "Paid" : "Unpaid" %>
                            </span>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:Repeater>
        </tbody>
        <tfoot>
            <tr>
                <td colspan="4" style="text-align: right;"><strong>TOTAL REVENUE:</strong></td>
                <td><strong>$<asp:Literal ID="litFooterTotal" runat="server">0.00</asp:Literal></strong></td>
                <td></td>
            </tr>
        </tfoot>
    </table>

    <!-- Daily Breakdown -->
    <asp:Panel ID="pnlDailyBreakdown" runat="server" CssClass="daily-breakdown">
        <h3>🛏️ Daily Revenue Breakdown</h3>
        <asp:Repeater ID="rptDailyBreakdown" runat="server">
            <ItemTemplate>
                <div class="daily-item">
                    <span class="date"><%# Eval("date", "{0:MMMM dd, yyyy}") %></span>
                    <span class="amount">$<%# Eval("revenue", "{0:N2}") %></span>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </asp:Panel>

    <!-- Footer -->
    <div class="footer">
        <p>This is a computer-generated report from <asp:Literal ID="litFooterHospital" runat="server"></asp:Literal> Hospital Management System</p>
        <p>Printed on: <%= DateTime.Now.ToString("MMMM dd, yyyy hh:mm tt") %></p>
        <p>© <%= DateTime.Now.Year %> <asp:Literal ID="litFooterHospitalCopyright" runat="server"></asp:Literal>. All rights reserved.</p>
    </div>
    
    <script>
        // Auto-print after page loads
        window.onload = function() {
            setTimeout(function() {
                window.print();
            }, 500);
        };
    </script>
</body>
</html>
