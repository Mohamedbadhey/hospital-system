<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="lab_orders_print.aspx.cs" Inherits="juba_hospital.lab_orders_print" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>Lab Orders & Results</title>
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

        .order-card {
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            margin-bottom: 25px;
            overflow: hidden;
        }

        .order-header {
            background: #3b82f6;
            color: white;
            padding: 15px 20px;
            font-weight: 600;
            font-size: 16px;
        }

        .order-header.reorder {
            background: #f59e0b;
        }

        .order-body {
            padding: 20px;
        }

        .order-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e2e8f0;
        }

        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 8px;
        }

        .badge-primary {
            background: #dbeafe;
            color: #1e40af;
        }

        .badge-warning {
            background: #fef3c7;
            color: #92400e;
        }

        .badge-success {
            background: #d1fae5;
            color: #065f46;
        }

        .badge-danger {
            background: #fee2e2;
            color: #991b1b;
        }

        .section-title {
            font-weight: 600;
            color: #1e40af;
            margin-top: 15px;
            margin-bottom: 10px;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .tests-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 8px;
            margin-bottom: 15px;
        }

        .test-badge {
            padding: 8px 12px;
            background: #f1f5f9;
            border: 1px solid #cbd5e1;
            border-radius: 6px;
            font-size: 0.85rem;
            color: #475569;
        }

        .results-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        .results-table th,
        .results-table td {
            padding: 12px;
            border: 1px solid #e2e8f0;
            text-align: left;
        }

        .results-table th {
            background: #f8fafc;
            font-weight: 600;
            color: #475569;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
        }

        .results-table td {
            font-size: 0.9rem;
            color: #0f172a;
        }

        .result-value {
            font-weight: 600;
            color: #059669;
        }

        .no-results {
            padding: 20px;
            text-align: center;
            background: #fff7ed;
            border: 1px dashed #fb923c;
            border-radius: 6px;
            color: #9a3412;
        }

        .no-orders {
            padding: 30px;
            text-align: center;
            color: #64748b;
            background: #f1f5f9;
            border-radius: 8px;
        }

        .print-actions {
            margin-top: 30px;
            text-align: right;
        }

        .notes-box {
            background: #fefce8;
            border-left: 4px solid #eab308;
            padding: 12px 15px;
            margin-top: 10px;
            border-radius: 4px;
            font-size: 0.9rem;
            color: #713f12;
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

            .order-card {
                page-break-inside: avoid;
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
                    <i class="fas fa-flask"></i> Lab Orders & Results Report
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
                        <span class="meta-label">Report Date</span>
                        <div class="meta-value">
                            <asp:Literal ID="DateLiteral" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>

                <asp:PlaceHolder ID="OrdersPlaceHolder" runat="server"></asp:PlaceHolder>

                <asp:Panel ID="NoOrdersPanel" runat="server" Visible="false" CssClass="no-orders">
                    <i class="fas fa-info-circle fa-2x mb-3"></i>
                    <p>No lab tests have been ordered for this patient yet.</p>
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
