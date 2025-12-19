<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="inpatient_full_report.aspx.cs" Inherits="juba_hospital.inpatient_full_report" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Inpatient Comprehensive Report</title>
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
            border-bottom: 3px solid #333;
            padding-bottom: 15px;
            margin-bottom: 30px;
        }
        
        .hospital-logo {
            max-width: 150px;
            margin-bottom: 10px;
        }
        
        .report-title {
            font-size: 28px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .report-subtitle {
            font-size: 16px;
            color: #7f8c8d;
            margin-bottom: 5px;
        }
        
        .section {
            margin-bottom: 25px;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 15px;
        }
        
        .section-title {
            background: #e74c3c;
            color: white;
            padding: 10px 15px;
            margin: -15px -15px 15px -15px;
            border-radius: 5px 5px 0 0;
            font-size: 18px;
            font-weight: bold;
        }
        
        .section-title.inpatient {
            background: #e74c3c;
        }
        
        .section-title.lab {
            background: #9b59b6;
        }
        
        .section-title.medication {
            background: #3498db;
        }
        
        .section-title.xray {
            background: #16a085;
        }
        
        .section-title.charges {
            background: #f39c12;
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
            font-size: 13px;
        }
        
        table td {
            padding: 8px;
            border: 1px solid #ddd;
            font-size: 12px;
        }
        
        .total-row {
            background: #f8f9fa;
            font-weight: bold;
        }
        
        .badge {
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 12px;
            display: inline-block;
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
        
        .badge-info {
            background: #3498db;
            color: white;
        }
        
        .print-button {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
        }
        
        .summary-box {
            background: #fff3cd;
            border-left: 4px solid #f39c12;
            padding: 15px;
            margin: 15px 0;
        }
        
        .highlight {
            background: #fff3cd;
            padding: 2px 5px;
            border-radius: 3px;
            font-weight: bold;
        }
        
        .admission-info {
            background: #e8f5e9;
            border-left: 4px solid #4caf50;
            padding: 15px;
            margin: 15px 0;
        }
        
        .lab-test-order {
            background: #f5f5f5;
            border: 2px solid #9b59b6;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .lab-test-header {
            background: #9b59b6;
            color: white;
            padding: 10px;
            margin: -15px -15px 15px -15px;
            border-radius: 3px 3px 0 0;
            font-weight: bold;
        }
        
        .test-result-table {
            margin-top: 10px;
        }
        
        .test-result-table td {
            vertical-align: top;
        }
        
        .test-name-col {
            width: 40%;
            font-weight: bold;
            background: #fafafa;
        }
        
        .test-result-col {
            width: 30%;
            text-align: center;
        }
        
        .test-status-col {
            width: 30%;
            text-align: center;
        }
        
        .ordered-test {
            background: #fff9e6;
        }
        
        .completed-test {
            background: #e8f5e9;
        }
        
        .no-data {
            text-align: center;
            color: #999;
            font-style: italic;
            padding: 20px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <button type="button" class="btn btn-primary no-print print-button" onclick="window.print()">
            <i class="fa fa-print"></i> Print Report
        </button>
        
        <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>
        
        <div class="report-header">
            <div class="report-title">INPATIENT COMPREHENSIVE REPORT</div>
            <div class="report-subtitle">Complete Admission & Medical Summary</div>
            <div class="report-subtitle">Report Date: <%= DateTime.Now.ToString("MMMM dd, yyyy hh:mm tt") %></div>
        </div>

        <div id="reportContent" runat="server">
            <!-- Content will be loaded here from code-behind -->
        </div>
    </form>
    
    <!-- Watermark -->
    <% var __logoUrl = juba_hospital.HospitalSettingsHelper.GetPrintLogoUrl(); %>
    <div class="print-watermark">
        <img src="<%= __logoUrl %>" alt="Hospital Logo Watermark" />
    </div>

    <script src="Scripts/jquery-3.4.1.min.js"></script>
    <script src="Content/bootstrap.min.js"></script>
</body>
</html>
