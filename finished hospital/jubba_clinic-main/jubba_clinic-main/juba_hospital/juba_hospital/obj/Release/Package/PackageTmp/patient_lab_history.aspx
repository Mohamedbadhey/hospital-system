<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="patient_lab_history.aspx.cs" Inherits="juba_hospital.patient_lab_history" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>Patient Lab History - Complete Report</title>
    <link rel="stylesheet" href="Content/bootstrap.min.css" />
    <link rel="stylesheet" href="Content/print-header.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <style>
        body {
            background: #f7f9fc;
            font-family: "Segoe UI", Arial, sans-serif;
            padding: 20px;
        }

        .report-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 12px 40px rgba(15, 23, 42, 0.08);
            padding: 40px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .patient-info {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .info-item {
            display: flex;
            flex-direction: column;
        }

        .info-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: #94a3b8;
            margin-bottom: 5px;
        }

        .info-value {
            font-size: 1.05rem;
            font-weight: 600;
            color: #0f172a;
        }

        .test-order-section {
            margin-bottom: 40px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            padding: 20px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #e2e8f0;
        }

        .order-title {
            font-size: 1.2rem;
            font-weight: bold;
            color: #1e40af;
        }

        .order-meta {
            display: flex;
            gap: 15px;
            font-size: 0.9rem;
            color: #64748b;
        }

        .status-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .status-completed {
            background: #dcfce7;
            color: #166534;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .results-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .results-table th,
        .results-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        .results-table th {
            background: #f8fafc;
            font-weight: 600;
            color: #475569;
            font-size: 0.9rem;
        }

        .results-table td {
            font-size: 0.95rem;
            color: #0f172a;
        }

        .no-results {
            text-align: center;
            padding: 30px;
            color: #94a3b8;
            font-style: italic;
        }

        .print-actions {
            margin-top: 30px;
            text-align: right;
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        .summary-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }

        .stat-card.completed {
            background: linear-gradient(135deg, #84fab0 0%, #8fd3f4 100%);
        }

        .stat-card.pending {
            background: linear-gradient(135deg, #ffd89b 0%, #19547b 100%);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .stat-label {
            font-size: 0.85rem;
            opacity: 0.9;
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
                <!-- Print Header -->
                <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>

                <h2 class="text-center mb-4" style="color: #1e40af;">Complete Laboratory History Report</h2>

                <!-- Patient Information -->
                <div class="patient-info">
                    <h4 style="margin-bottom: 15px;">Patient Information</h4>
                    <div class="info-grid">
                        <div class="info-item">
                            <span class="info-label">Patient Name</span>
                            <span class="info-value">
                                <asp:Literal ID="PatientNameLiteral" runat="server"></asp:Literal>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Patient ID</span>
                            <span class="info-value">
                                <asp:Literal ID="PatientIdLiteral" runat="server"></asp:Literal>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Sex</span>
                            <span class="info-value">
                                <asp:Literal ID="PatientSexLiteral" runat="server"></asp:Literal>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Date of Birth</span>
                            <span class="info-value">
                                <asp:Literal ID="PatientDOBLiteral" runat="server"></asp:Literal>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Phone</span>
                            <span class="info-value">
                                <asp:Literal ID="PatientPhoneLiteral" runat="server"></asp:Literal>
                            </span>
                        </div>
                        <div class="info-item">
                            <span class="info-label">Location</span>
                            <span class="info-value">
                                <asp:Literal ID="PatientLocationLiteral" runat="server"></asp:Literal>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Summary Statistics -->
                <div class="summary-stats">
                    <div class="stat-card">
                        <div class="stat-number">
                            <asp:Literal ID="TotalOrdersLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="stat-label">Total Lab Orders</div>
                    </div>
                    <div class="stat-card completed">
                        <div class="stat-number">
                            <asp:Literal ID="CompletedOrdersLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="stat-label">Completed Orders</div>
                    </div>
                    <div class="stat-card pending">
                        <div class="stat-number">
                            <asp:Literal ID="PendingOrdersLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="stat-label">Pending Orders</div>
                    </div>
                </div>

                <!-- Lab Orders and Results -->
                <h4 style="margin-bottom: 20px;">Laboratory Test History</h4>
                <asp:Literal ID="LabHistoryLiteral" runat="server"></asp:Literal>

                <!-- Print Actions -->
                <div class="print-actions">
                    <button type="button" class="btn btn-secondary" onclick="window.close()">
                        <i class="fas fa-times"></i> Close
                    </button>
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
</body>
</html>
