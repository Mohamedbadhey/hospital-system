<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="patient_invoice_print.aspx.cs" Inherits="juba_hospital.patient_invoice_print" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>Patient Invoice</title>
    <link rel="stylesheet" href="Content/bootstrap.min.css" />
    <link rel="stylesheet" href="Content/print-header.css" />
    <style type="text/css">
        body {
            background: #f8f9fa;
            font-family: "Segoe UI", Arial, sans-serif;
            color: #1e293b;
        }

        .invoice-shell {
            max-width: 900px;
            margin: 30px auto;
        }

        .invoice-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.1);
            padding: 40px;
        }

        .metadata {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 25px;
        }

        .metadata .meta {
            flex: 1;
            min-width: 200px;
        }

        .meta-label {
            display: block;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #64748b;
        }

        .meta-value {
            font-size: 18px;
            font-weight: 600;
        }

        .table {
            margin-bottom: 0;
        }

        .summary-card {
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 12px;
        }

        .summary-label {
            font-weight: 600;
            color: #334155;
        }

        .summary-total {
            font-size: 18px;
            font-weight: 700;
            color: #0f172a;
        }

        .grand-total {
            font-size: 24px;
            font-weight: 700;
            color: #0f172a;
        }

        .print-actions {
            margin-top: 25px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .no-charges {
            padding: 30px;
            text-align: center;
            border: 2px dashed #cbd5f5;
            border-radius: 10px;
            color: #475569;
        }

        @media print {
            body {
                background: #fff;
            }

            .invoice-shell {
                margin: 0;
            }

            .print-actions {
                display: none;
            }

            .invoice-card {
                box-shadow: none;
                padding: 0;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="invoice-shell">
            <asp:Panel ID="InvoiceErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger">
                <asp:Literal ID="InvoiceErrorLiteral" runat="server"></asp:Literal>
            </asp:Panel>

            <asp:Panel ID="InvoicePanel" runat="server" Visible="false" CssClass="invoice-card">
                <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>

                <div class="metadata">
                    <div class="meta">
                        <span class="meta-label">Invoice Generated</span>
                        <span class="meta-value">
                            <asp:Literal ID="InvoiceGeneratedLiteral" runat="server"></asp:Literal>
                        </span>
                    </div>
                    <div class="meta">
                        <span class="meta-label">Patient Name</span>
                        <span class="meta-value">
                            <asp:Literal ID="InvoicePatientLiteral" runat="server"></asp:Literal>
                        </span>
                    </div>
                    <div class="meta">
                        <span class="meta-label">Patient ID</span>
                        <span class="meta-value">
                            <asp:Literal ID="InvoicePatientIdLiteral" runat="server"></asp:Literal>
                        </span>
                    </div>
                    <div class="meta">
                        <span class="meta-label">Phone</span>
                        <span class="meta-value">
                            <asp:Literal ID="InvoicePhoneLiteral" runat="server"></asp:Literal>
                        </span>
                    </div>
                </div>

                <div class="metadata">
                    <div class="meta">
                        <span class="meta-label">Location</span>
                        <span class="meta-value">
                            <asp:Literal ID="InvoiceLocationLiteral" runat="server"></asp:Literal>
                        </span>
                    </div>
                    <div class="meta">
                        <span class="meta-label">Date Registered</span>
                        <span class="meta-value">
                            <asp:Literal ID="InvoiceDateRegisteredLiteral" runat="server"></asp:Literal>
                        </span>
                    </div>
                    <div class="meta">
                        <span class="meta-label">Visit Count</span>
                        <span class="meta-value">
                            <asp:Literal ID="InvoiceVisitCountLiteral" runat="server"></asp:Literal>
                        </span>
                    </div>
                </div>

                <asp:PlaceHolder ID="NoChargesPlaceholder" runat="server" Visible="false">
                    <div class="no-charges">
                        No billable charges were found for this patient.
                    </div>
                </asp:PlaceHolder>

                <asp:Panel ID="ChargesTablePanel" runat="server" Visible="false">
                    <h4 class="mt-4 mb-3">Charge Breakdown</h4>
                    <div class="table-responsive">
                        <table class="table table-striped table-bordered">
                            <thead class="table-light">
                                <tr>
                                    <th>Date</th>
                                    <th>Invoice #</th>
                                    <th>Type</th>
                                    <th>Charge</th>
                                    <th>Status</th>
                                    <th class="text-end">Amount</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="ChargesRepeater" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("RecordedOn") %></td>
                                            <td><%# Eval("Invoice") %></td>
                                            <td><%# Eval("Type") %></td>
                                            <td><%# Eval("Name") %></td>
                                            <td><%# Eval("Status") %></td>
                                            <td class="text-end"><%# Eval("Amount") %></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </asp:Panel>

                <asp:Panel ID="SummaryPanel" runat="server" Visible="false">
                    <h4 class="mt-4 mb-3">Summary</h4>
                    <asp:Repeater ID="SummaryRepeater" runat="server">
                        <ItemTemplate>
                            <div class="summary-card d-flex justify-content-between align-items-center">
                                <span class="summary-label"><%# Eval("Label") %></span>
                                <span class="summary-total"><%# Eval("Total") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <div class="d-flex justify-content-between align-items-center mt-4">
                        <span class="h5 mb-0">Grand Total</span>
                        <span class="grand-total">
                            <asp:Literal ID="GrandTotalLiteral" runat="server"></asp:Literal>
                        </span>
                    </div>
                </asp:Panel>

                <div class="print-actions">
                    <asp:Button ID="BackButton" runat="server" Text="Back" CssClass="btn btn-outline-secondary"
                        OnClientClick="window.history.back(); return false;" />
                    <asp:Button ID="PrintButton" runat="server" Text="Print Invoice" CssClass="btn btn-primary"
                        OnClientClick="window.print(); return false;" />
                </div>
            </asp:Panel>
        </div>
    </form>
    
    <!-- Watermark -->
    <% var __logoUrl = juba_hospital.HospitalSettingsHelper.GetPrintLogoUrl(); %>
    <div class="print-watermark">
        <img src="<%= __logoUrl %>" alt="Hospital Logo Watermark" />
    </div>
</body>
</html>

