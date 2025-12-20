<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="completed_patient_full_report.aspx.cs" Inherits="juba_hospital.completed_patient_full_report" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Completed Patient Full Report</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="Content/print-header.css" />
    <style>
        @media print {
            .no-print { display: none !important; }
            .page-break { page-break-after: always; }
        }
        
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }
        
        .report-header {
            text-align: center;
            border-bottom: 3px solid #28a745;
            padding-bottom: 15px;
            margin-bottom: 30px;
        }
        
        .report-title {
            font-size: 28px;
            font-weight: bold;
            color: #28a745;
            margin-bottom: 10px;
        }
        
        .report-subtitle {
            font-size: 16px;
            color: #7f8c8d;
        }
        
        .completed-badge {
            display: inline-block;
            background: #28a745;
            color: white;
            padding: 8px 20px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
            margin-top: 10px;
        }
        
        .section {
            margin-bottom: 30px;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
        }
        
        .section-title {
            background: #28a745;
            color: white;
            padding: 10px 15px;
            margin: -15px -15px 15px -15px;
            border-radius: 5px 5px 0 0;
            font-size: 18px;
            font-weight: bold;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 10px;
            border-bottom: 1px solid #f0f0f0;
            padding-bottom: 8px;
        }
        
        .info-label {
            font-weight: bold;
            width: 200px;
            color: #555;
        }
        
        .info-value {
            flex: 1;
            color: #333;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        
        table th {
            background: #ecf0f1;
            padding: 10px;
            text-align: left;
            border: 1px solid #bdc3c7;
            font-weight: bold;
        }
        
        table td {
            padding: 8px;
            border: 1px solid #ddd;
        }
        
        .total-row {
            background: #d4edda;
            font-weight: bold;
        }
        
        .badge {
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 12px;
        }
        
        .badge-success {
            background: #27ae60;
            color: white;
        }
        
        .badge-danger {
            background: #e74c3c;
            color: white;
        }
        
        .badge-warning {
            background: #f39c12;
            color: white;
        }
        
        .print-button {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }
        
        .summary-box {
            background: #d4edda;
            border-left: 4px solid #28a745;
            padding: 15px;
            margin: 15px 0;
        }
        
        .highlight {
            background: #d4edda;
            padding: 2px 5px;
            border-radius: 3px;
        }
        
        .completion-info {
            background: #d4edda;
            padding: 15px;
            border-radius: 5px;
            border: 2px solid #28a745;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <button type="button" class="btn btn-success no-print print-button" onclick="window.print()">
            <i class="fa fa-print"></i> Print Report
        </button>
        
        <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>
        
        <div class="report-header">
            <div class="report-title">✓ COMPLETED PATIENT REPORT</div>
            <div class="completed-badge">TREATMENT COMPLETED</div>
            <div class="report-subtitle" style="margin-top: 10px;">Complete Patient Visit Summary</div>
            <div class="report-subtitle">Report Date: <%= DateTime.Now.ToString("MMMM dd, yyyy hh:mm tt") %></div>
        </div>

        <div id="reportContent" runat="server">
            <!-- Content will be loaded here -->
        </div>
    </form>
    
    <!-- Watermark -->
    <div class="print-watermark">
        <img src="assets/vafmadow.png" alt="Hospital Logo Watermark" />
    </div>

    <script src="Scripts/jquery-3.4.1.min.js"></script>
    <script src="Content/bootstrap.min.js"></script>
</body>
</html>
