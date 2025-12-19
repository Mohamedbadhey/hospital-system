<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="print_all_patients_by_charge.aspx.cs" Inherits="juba_hospital.print_all_patients_by_charge" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Patients by Charge Type - Print</title>
    <link rel="stylesheet" href="Content/bootstrap.min.css" />
    <link rel="stylesheet" href="Content/print-header.css" />
    <style>
        body {
            background: #f8f9fa;
            font-family: "Segoe UI", Arial, sans-serif;
            color: #1e293b;
            margin: 0;
            padding: 20px;
        }

        .report-container {
            max-width: 1200px;
            margin: 20px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.1);
            padding: 40px;
        }

        .report-title {
            font-size: 24px;
            font-weight: 700;
            margin: 25px 0;
            text-align: center;
            color: #0f172a;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .report-metadata {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin: 25px 0;
            padding: 20px;
            background: #f1f5f9;
            border-radius: 8px;
            border-left: 4px solid #007bff;
        }

        .metadata-item {
            display: flex;
            flex-direction: column;
        }

        .metadata-label {
            font-size: 11px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #64748b;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .metadata-value {
            font-size: 15px;
            font-weight: 600;
            color: #0f172a;
        }

        .patient-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
            font-size: 12px;
        }

        .patient-table thead {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
        }

        .patient-table th {
            padding: 12px 10px;
            text-align: left;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 11px;
            letter-spacing: 0.5px;
            border: none;
        }

        .patient-table td {
            padding: 10px;
            border-bottom: 1px solid #e2e8f0;
            color: #334155;
        }

        .patient-table tbody tr {
            transition: background-color 0.2s;
        }

        .patient-table tbody tr:hover {
            background-color: #f8fafc;
        }

        .patient-table tbody tr:nth-child(even) {
            background-color: #f9fafb;
        }

        .row-number {
            font-weight: 600;
            color: #64748b;
        }

        .patient-name {
            font-weight: 600;
            color: #0f172a;
        }

        .summary-section {
            margin-top: 40px;
            padding: 25px;
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            border-radius: 10px;
            border: 1px solid #cbd5e1;
        }

        .summary-title {
            font-size: 18px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #007bff;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .summary-item {
            display: flex;
            justify-content: space-between;
            padding: 12px;
            background: white;
            border-radius: 6px;
            border-left: 3px solid #007bff;
        }

        .summary-label {
            font-weight: 600;
            color: #475569;
        }

        .summary-value {
            font-weight: 700;
            font-size: 16px;
            color: #0f172a;
        }

        .paid-status {
            color: #059669;
            font-weight: 700;
        }

        .unpaid-status {
            color: #dc2626;
            font-weight: 700;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
        }

        .badge-paid {
            background: #d1fae5;
            color: #059669;
        }

        .badge-unpaid {
            background: #fee2e2;
            color: #dc2626;
        }

        .footer {
            margin-top: 50px;
            padding-top: 25px;
            border-top: 2px solid #e2e8f0;
            text-align: center;
            color: #64748b;
            font-size: 11px;
        }

        .print-actions {
            margin-bottom: 25px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn {
            padding: 10px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #007bff;
            color: white;
        }

        .btn-primary:hover {
            background: #0056b3;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        @media print {
            body {
                background: #fff;
                padding: 0;
            }

            .no-print {
                display: none !important;
            }

            .report-container {
                box-shadow: none;
                padding: 20px;
            }

            .patient-table {
                font-size: 10px;
            }

            .patient-table th,
            .patient-table td {
                padding: 6px 8px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Print Actions -->
        <div class="print-actions no-print">
            <button type="button" onclick="window.print()" class="btn btn-primary">
                🖨️ Print Report
            </button>
            <button type="button" onclick="window.close()" class="btn btn-secondary">
                ✖ Close
            </button>
        </div>

        <!-- Hospital Header from Settings -->
        <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>

        <div class="report-container">
            <!-- Report Title -->
            <div class="report-title">💰 Patients by Charge Type Report</div>

            <!-- Report Metadata -->
            <div class="report-metadata">
                <div class="metadata-item">
                    <span class="metadata-label">Report Generated</span>
                    <span class="metadata-value"><asp:Literal ID="litReportDate" runat="server"></asp:Literal></span>
                </div>
                <div class="metadata-item">
                    <span class="metadata-label">Charge Type</span>
                    <span class="metadata-value"><asp:Literal ID="litChargeType" runat="server"></asp:Literal></span>
                </div>
                <div class="metadata-item">
                    <span class="metadata-label">Total Patients</span>
                    <span class="metadata-value"><asp:Literal ID="litTotalPatients" runat="server"></asp:Literal></span>
                </div>
                <div class="metadata-item">
                    <span class="metadata-label">Generated By</span>
                    <span class="metadata-value"><asp:Literal ID="litGeneratedBy" runat="server"></asp:Literal></span>
                </div>
                <div class="metadata-item" id="dateRangeContainer" runat="server" visible="false">
                    <span class="metadata-label">Date Range</span>
                    <span class="metadata-value"><asp:Literal ID="litDateRange" runat="server"></asp:Literal></span>
                </div>
            </div>

            <!-- Patients Table -->
            <table class="patient-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Patient ID</th>
                        <th>Name</th>
                        <th>Age/Sex</th>
                        <th>Phone</th>
                        <th>Location</th>
                        <th>Registered</th>
                        <th>Total</th>
                        <th>Paid</th>
                        <th>Unpaid</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptPatients" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td class="row-number"><%# Container.ItemIndex + 1 %></td>
                                <td><strong>#<%# Eval("patientid") %></strong></td>
                                <td class="patient-name"><%# Eval("full_name") %></td>
                                <td><%# Eval("age") %>Y / <%# Eval("sex") %></td>
                                <td><%# Eval("phone") %></td>
                                <td><%# Eval("location") %></td>
                                <td><%# Eval("date_registered", "{0:MMM dd, yyyy}") %></td>
                                <td><strong>$<%# Eval("total_charges", "{0:N2}") %></strong></td>
                                <td class="paid-status">$<%# Eval("paid_amount", "{0:N2}") %></td>
                                <td class="unpaid-status">$<%# Eval("unpaid_amount", "{0:N2}") %></td>
                                <td>
                                    <%# Convert.ToDecimal(Eval("unpaid_amount")) > 0 ? 
                                        "<span class='status-badge badge-unpaid'>Has Unpaid</span>" : 
                                        "<span class='status-badge badge-paid'>Fully Paid</span>" %>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>

            <!-- Financial Summary -->
            <div class="summary-section">
                <div class="summary-title">💰 Financial Summary</div>
                <div class="summary-grid">
                    <div class="summary-item">
                        <span class="summary-label">Total Charges</span>
                        <span class="summary-value">$<asp:Literal ID="litTotalCharges" runat="server"></asp:Literal></span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">Total Paid</span>
                        <span class="summary-value paid-status">$<asp:Literal ID="litTotalPaid" runat="server"></asp:Literal></span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">Total Unpaid</span>
                        <span class="summary-value unpaid-status">$<asp:Literal ID="litTotalUnpaid" runat="server"></asp:Literal></span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">Collection Rate</span>
                        <span class="summary-value">
                            <asp:Literal ID="litCollectionRate" runat="server"></asp:Literal>%
                        </span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">Patients Fully Paid</span>
                        <span class="summary-value paid-status">
                            <asp:Literal ID="litFullyPaidCount" runat="server"></asp:Literal>
                        </span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">Patients with Unpaid</span>
                        <span class="summary-value unpaid-status">
                            <asp:Literal ID="litUnpaidCount" runat="server"></asp:Literal>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Footer -->
            <div class="footer">
                <p><strong><asp:Literal ID="litFooterHospital" runat="server"></asp:Literal></strong></p>
                <p>This is a computer-generated report | Printed on <%= DateTime.Now.ToString("MMMM dd, yyyy hh:mm tt") %></p>
                <p>Confidential - For Internal Use Only</p>
            </div>
        </div>
    </form>
    
    <!-- Watermark -->
    <div class="print-watermark">
        <img src="assets/vafmadow.png" alt="Hospital Logo Watermark" />
    </div>
</body>
</html>
