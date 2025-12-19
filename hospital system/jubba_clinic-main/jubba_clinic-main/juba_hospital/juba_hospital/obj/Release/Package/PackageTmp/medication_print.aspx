<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="medication_print.aspx.cs" Inherits="juba_hospital.medication_print" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>Medication Report</title>
    <link rel="stylesheet" href="Content/bootstrap.min.css" />
    <link rel="stylesheet" href="Content/print-header.css" />
    <style>
        body {
            background: #f7f9fc;
            font-family: "Segoe UI", Arial, sans-serif;
            padding: 30px;
        }

        .report-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 12px 40px rgba(15, 23, 42, 0.08);
            padding: 40px;
            max-width: 960px;
            margin: 0 auto;
        }

        .report-title {
            font-size: 24px;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 20px;
            border-bottom: 3px solid #3b82f6;
            padding-bottom: 10px;
        }

        .meta-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
            padding: 20px;
            background: #f8fafc;
            border-radius: 8px;
        }

        .meta-item {
            display: flex;
            flex-direction: column;
        }

        .meta-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: #94a3b8;
            margin-bottom: 4px;
        }

        .meta-value {
            font-size: 1.05rem;
            font-weight: 600;
            color: #0f172a;
        }

        .medications-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }

        .medications-table th,
        .medications-table td {
            padding: 14px 16px;
            border: 1px solid #e2e8f0;
            text-align: left;
        }

        .medications-table th {
            background: #3b82f6;
            color: white;
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.05em;
            font-weight: 600;
        }

        .medications-table td {
            font-size: 0.95rem;
            color: #0f172a;
        }

        .medications-table tr:nth-child(even) {
            background: #f8fafc;
        }

        .med-name {
            font-weight: 600;
            color: #1e40af;
        }

        .print-actions {
            margin-top: 30px;
            text-align: right;
        }

        .no-medications {
            padding: 30px;
            text-align: center;
            color: #64748b;
            background: #f1f5f9;
            border-radius: 8px;
        }

        @media print {
            body {
                background: #fff;
                padding: 0;
            }

            .print-actions {
                display: none;
            }

            .report-card {
                box-shadow: none;
                padding: 0;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="report-card">
            <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert alert-danger">
                <asp:Literal ID="ErrorLiteral" runat="server"></asp:Literal>
            </asp:Panel>

            <asp:Panel ID="ContentPanel" runat="server" Visible="false">
                <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>

                <div class="report-title">
                    <i class="fas fa-pills"></i> Medication Report
                </div>

                <div class="meta-grid">
                    <div class="meta-item">
                        <span class="meta-label">Patient Name</span>
                        <div class="meta-value">
                            <asp:Literal ID="PatientNameLiteral" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Patient ID</span>
                        <div class="meta-value">
                            <asp:Literal ID="PatientIdLiteral" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Doctor</span>
                        <div class="meta-value">
                            <asp:Literal ID="DoctorLiteral" runat="server"></asp:Literal>
                        </div>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">Date</span>
                        <div class="meta-value">
                            <asp:Literal ID="DateLiteral" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>

                <asp:Panel ID="MedicationsPanel" runat="server" Visible="false">
                    <table class="medications-table">
                        <thead>
                            <tr>
                                <th style="width: 25%;">Medication</th>
                                <th style="width: 15%;">Dosage</th>
                                <th style="width: 15%;">Frequency</th>
                                <th style="width: 15%;">Duration</th>
                                <th style="width: 30%;">Special Instructions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="MedicationsRepeater" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td class="med-name"><%# Eval("med_name") %></td>
                                        <td><%# Eval("dosage") %></td>
                                        <td><%# Eval("frequency") %></td>
                                        <td><%# Eval("duration") %></td>
                                        <td><%# Eval("special_inst") != DBNull.Value && !string.IsNullOrEmpty(Eval("special_inst").ToString()) ? Eval("special_inst") : "-" %></td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </asp:Panel>

                <asp:Panel ID="NoMedicationsPanel" runat="server" Visible="false" CssClass="no-medications">
                    <i class="fas fa-info-circle fa-2x mb-3"></i>
                    <p>No medications have been prescribed for this patient yet.</p>
                </asp:Panel>

                <div class="print-actions">
                    <button type="button" class="btn btn-secondary me-2" onclick="window.close()">Close</button>
                    <button type="button" class="btn btn-primary" onclick="window.print()">
                        <i class="fas fa-print"></i> Print
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
