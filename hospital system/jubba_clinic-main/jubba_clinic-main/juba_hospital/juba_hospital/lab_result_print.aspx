<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="lab_result_print.aspx.cs" Inherits="juba_hospital.lab_result_print" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>Lab Result Summary</title>
    <link rel="stylesheet" href="Content/bootstrap.min.css" />
    <link rel="stylesheet" href="Content/print-header.css" />
    <style>
        body {
            background: #f7f9fc;
            font-family: "Segoe UI", Arial, sans-serif;
            padding: 30px;
        }

        .result-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 12px 40px rgba(15, 23, 42, 0.08);
            padding: 40px;
            max-width: 960px;
            margin: 0 auto;
        }

        .meta-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 12px;
            margin-bottom: 25px;
        }

        .meta-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: #94a3b8;
        }

        .meta-value {
            font-size: 1.05rem;
            font-weight: 600;
            color: #0f172a;
        }

        .results-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }

        .results-table th,
        .results-table td {
            padding: 12px 16px;
            border-bottom: 1px solid #e2e8f0;
        }

        .results-table th {
            background: #f8fafc;
            text-transform: uppercase;
            font-size: 0.75rem;
            color: #64748b;
            letter-spacing: 0.08em;
        }

        .results-table td {
            font-size: 0.95rem;
            color: #0f172a;
        }

        .print-actions {
            margin-top: 30px;
            text-align: right;
        }

        @media print {
            body {
                background: #fff;
                padding: 0;
            }

            .print-actions {
                display: none;
            }

            .result-card {
                box-shadow: none;
                padding: 0;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="result-card">
            <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger">
                <asp:Literal ID="ErrorLiteral" runat="server"></asp:Literal>
            </asp:Panel>

            <asp:Panel ID="ContentPanel" runat="server" Visible="false">
                <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>

                <h3 style="text-align: center; color: #1e40af; margin: 20px 0;">Laboratory Report</h3>

                <!-- Patient Demographics Section -->
                <div style="background: #f1f5f9; padding: 20px; border-radius: 8px; margin-bottom: 25px;">
                    <h5 style="color: #334155; margin-bottom: 15px; border-bottom: 2px solid #cbd5e1; padding-bottom: 8px;">
                        <i class="fas fa-user-circle"></i> Patient Information
                    </h5>
                    <div class="meta-grid">
                        <div>
                            <span class="meta-label">Patient Name</span>
                            <div class="meta-value">
                                <asp:Literal ID="PatientNameLiteral" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div>
                            <span class="meta-label">Patient ID</span>
                            <div class="meta-value">
                                <asp:Literal ID="PatientIdLiteral" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div>
                            <span class="meta-label">Age</span>
                            <div class="meta-value">
                                <asp:Literal ID="AgeLiteral" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div>
                            <span class="meta-label">Sex</span>
                            <div class="meta-value">
                                <asp:Literal ID="SexLiteral" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div>
                            <span class="meta-label">Phone</span>
                            <div class="meta-value">
                                <asp:Literal ID="PhoneLiteral" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div>
                            <span class="meta-label">Location</span>
                            <div class="meta-value">
                                <asp:Literal ID="LocationLiteral" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div>
                            <span class="meta-label">Doctor</span>
                            <div class="meta-value">
                                <asp:Literal ID="DoctorLiteral" runat="server"></asp:Literal>
                            </div>
                        </div>
                        <div>
                            <span class="meta-label">Date</span>
                            <div class="meta-value">
                                <asp:Literal ID="SampleDateLiteral" runat="server"></asp:Literal>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Ordered Tests Section -->
                <asp:Panel ID="OrderedTestsPanel" runat="server" Visible="false">
                    <div style="margin-bottom: 25px;">
                        <h5 style="color: #334155; margin-bottom: 15px; border-bottom: 2px solid #cbd5e1; padding-bottom: 8px;">
                            <i class="fas fa-flask"></i> Ordered Tests
                        </h5>
                        <div style="background: #fef3c7; padding: 15px; border-radius: 6px; border-left: 4px solid #f59e0b;">
                            <asp:Repeater ID="OrderedTestsRepeater" runat="server">
                                <ItemTemplate>
                                    <div style="display: inline-block; background: #fff; padding: 8px 12px; margin: 4px; border-radius: 4px; font-size: 0.9rem;">
                                        <i class="fas fa-check-circle" style="color: #f59e0b;"></i> <%# Eval("Label") %>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </asp:Panel>

                <!-- Test Results Section -->
                <asp:Panel ID="ResultsPanel" runat="server" Visible="false">
                    <div style="margin-bottom: 25px;">
                        <h5 style="color: #334155; margin-bottom: 15px; border-bottom: 2px solid #cbd5e1; padding-bottom: 8px;">
                            <i class="fas fa-file-medical-alt"></i> Test Results
                        </h5>
                        <table class="results-table">
                            <thead>
                                <tr>
                                    <th style="width: 40%;">Test Name</th>
                                    <th style="width: 30%;">Result</th>
                                    <th style="width: 30%;">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="ResultsRepeater" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><strong><%# Eval("Label") %></strong></td>
                                            <td><%# Eval("Value") %></td>
                                            <td>
                                                <span style="background: #dcfce7; color: #166534; padding: 4px 12px; border-radius: 12px; font-size: 0.85rem; font-weight: 600;">
                                                    <i class="fas fa-check-circle"></i> Completed
                                                </span>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>
                </asp:Panel>

                <!-- No Data Message -->
                <asp:Panel ID="NoDataPanel" runat="server" Visible="false">
                    <div style="background: #fee2e2; padding: 20px; border-radius: 8px; text-align: center; border-left: 4px solid #dc2626;">
                        <i class="fas fa-exclamation-triangle" style="color: #dc2626; font-size: 2rem; margin-bottom: 10px;"></i>
                        <p style="color: #991b1b; font-weight: 600; margin: 0;">No lab tests have been ordered or processed for this visit yet.</p>
                    </div>
                </asp:Panel>

                <!-- Report Footer -->
                <div style="margin-top: 40px; padding-top: 20px; border-top: 2px solid #e2e8f0; text-align: center; color: #64748b; font-size: 0.85rem;">
                    <p style="margin: 0;">Report generated on <asp:Literal ID="ReportDateLiteral" runat="server"></asp:Literal></p>
                </div>

                <div class="print-actions">
                    <button type="button" class="btn btn-secondary me-2" onclick="window.close()">Close</button>
                    <button type="button" class="btn btn-primary" onclick="window.print()">
                        <i class="fas fa-print"></i> Print Report
                    </button>
                </div>
            </asp:Panel>
        </div>
    </form>
    
    <!-- Watermark -->
    <div class="print-watermark">
        <img src="assets/vafmadow.png" alt="Hospital Logo Watermark" />
    </div>
    
    <script src="https://kit.fontawesome.com/4ad8d1a657.js" crossorigin="anonymous"></script>
</body>
</html>

