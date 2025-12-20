<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="visit_summary_print.aspx.cs" Inherits="juba_hospital.visit_summary_print" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>Patient Visit Summary</title>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="Content/print-header.css" />
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background: #f5f7fb;
            margin: 0;
            padding: 20px;
            color: #1f2a37;
        }

        .container {
            max-width: 960px;
            margin: 0 auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.1);
            padding: 32px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 2px solid #e2e8f0;
            padding-bottom: 16px;
            margin-bottom: 24px;
        }

        .header h1 {
            margin: 0;
            font-size: 28px;
        }

        .header p {
            margin: 4px 0 0;
            color: #64748b;
        }

        .section {
            margin-bottom: 32px;
        }

        .section h3 {
            margin: 0 0 12px;
            font-size: 20px;
            color: #0f172a;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px 12px;
            border: 1px solid #e2e8f0;
            text-align: left;
        }

        th {
            background: #f8fafc;
            font-weight: 600;
        }

        .muted {
            color: #94a3b8;
        }

        .tag {
            display: inline-block;
            padding: 2px 10px;
            border-radius: 999px;
            background: #e0f2fe;
            color: #0369a1;
            font-size: 12px;
            margin-left: 8px;
        }

        .no-print {
            margin-left: auto;
        }

        .btn {
            padding: 10px 18px;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            background: #2563eb;
            color: #fff;
            font-weight: 600;
        }

        .alert {
            border-radius: 8px;
            padding: 14px 18px;
            background: #fee2e2;
            color: #991b1b;
            margin-bottom: 16px;
        }

        @media print {
            body {
                background: #fff;
            }
            .container {
                box-shadow: none;
                margin: 0;
                width: 100%;
                padding: 0;
            }
            .no-print {
                display: none !important;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <asp:Panel ID="ErrorPanel" runat="server" CssClass="alert" Visible="false">
                <asp:Literal ID="ErrorMessageLiteral" runat="server" />
            </asp:Panel>

            <asp:Panel ID="ReportPanel" runat="server" Visible="false">
                <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>
                
                <div class="header">
                    <div>
                        <h1>Patient Visit Summary</h1>
                        <p>
                            Visit #: <asp:Literal ID="VisitNumberLiteral" runat="server" />
                            <span class="tag">Generated on <asp:Literal ID="GeneratedOnLiteral" runat="server" /></span>
                        </p>
                    </div>
                    <button type="button" class="btn no-print" onclick="window.print()">Print</button>
                </div>

                <div class="section">
                    <h3>Patient Information</h3>
                    <table>
                        <tbody>
                            <tr>
                                <th>Patient</th>
                                <td><asp:Literal ID="PatientNameLiteral" runat="server" /></td>
                                <th>Patient ID</th>
                                <td><asp:Literal ID="PatientIdLiteral" runat="server" /></td>
                            </tr>
                            <tr>
                                <th>Gender</th>
                                <td><asp:Literal ID="GenderLiteral" runat="server" /></td>
                                <th>Age</th>
                                <td><asp:Literal ID="AgeLiteral" runat="server" /></td>
                            </tr>
                            <tr>
                                <th>Phone</th>
                                <td><asp:Literal ID="PhoneLiteral" runat="server" /></td>
                                <th>Location</th>
                                <td><asp:Literal ID="LocationLiteral" runat="server" /></td>
                            </tr>
                            <tr>
                                <th>Doctor</th>
                                <td><asp:Literal ID="DoctorLiteral" runat="server" /></td>
                                <th>Date Registered</th>
                                <td><asp:Literal ID="DateRegisteredLiteral" runat="server" /></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <asp:Panel ID="LabTestsPanel" runat="server" CssClass="section" Visible="false">
                    <h3>Ordered Lab Tests
                        <span class="tag">
                            <asp:Literal ID="LabTestsTimestampLiteral" runat="server" />
                        </span>
                    </h3>
                    <asp:PlaceHolder ID="NoLabTestsPlaceholder" runat="server" Visible="false">
                        <p class="muted">No lab tests were recorded for this visit.</p>
                    </asp:PlaceHolder>
                    <asp:Panel ID="LabTestsTablePanel" runat="server" Visible="false">
                        <table>
                            <thead>
                                <tr>
                                    <th>Test</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="LabTestsRepeater" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("Label") %></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </asp:Panel>
                </asp:Panel>

                <asp:Panel ID="LabResultsPanel" runat="server" CssClass="section" Visible="false">
                    <h3>Lab Results
                        <span class="tag">
                            <asp:Literal ID="LabResultsTimestampLiteral" runat="server" />
                        </span>
                    </h3>
                    <asp:PlaceHolder ID="NoLabResultsPlaceholder" runat="server" Visible="false">
                        <p class="muted">Lab results are not yet available for this visit.</p>
                    </asp:PlaceHolder>
                    <asp:Panel ID="LabResultsTablePanel" runat="server" Visible="false">
                        <table>
                            <thead>
                                <tr>
                                    <th>Result</th>
                                    <th>Value</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="LabResultsRepeater" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("Label") %></td>
                                            <td><%# Eval("Value") %></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </asp:Panel>
                </asp:Panel>

                <asp:Panel ID="MedicationPanel" runat="server" CssClass="section" Visible="false">
                    <h3>Prescribed Medication</h3>
                    <asp:PlaceHolder ID="NoMedicationPlaceholder" runat="server" Visible="false">
                        <p class="muted">No medication has been prescribed for this visit.</p>
                    </asp:PlaceHolder>
                    <asp:Panel ID="MedicationTablePanel" runat="server" Visible="false">
                        <table>
                            <thead>
                                <tr>
                                    <th>Medication</th>
                                    <th>Dosage</th>
                                    <th>Frequency</th>
                                    <th>Duration</th>
                                    <th>Instructions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="MedicationRepeater" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("Name") %></td>
                                            <td><%# Eval("Dosage") %></td>
                                            <td><%# Eval("Frequency") %></td>
                                            <td><%# Eval("Duration") %></td>
                                            <td><%# Eval("Instructions") %></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </asp:Panel>
                </asp:Panel>
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

