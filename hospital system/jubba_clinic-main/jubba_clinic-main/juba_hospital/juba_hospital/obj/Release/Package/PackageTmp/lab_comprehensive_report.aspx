<%@ Page Title="Lab Report" Language="C#" MasterPageFile="~/labtest.Master" AutoEventWireup="true"
    CodeBehind="lab_comprehensive_report.aspx.cs" Inherits="juba_hospital.lab_comprehensive_report" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="Content/print-header.css" />
        <style>
            /* Report specific styles */
            .report-card {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 12px 40px rgba(15, 23, 42, 0.08);
                padding: 40px;
                max-width: 1000px;
                margin: 0 auto;
            }

            .report-header {
                text-align: center;
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 2px solid #e2e8f0;
            }

            .report-header h2 {
                color: #0f172a;
                margin: 10px 0;
                font-size: 1.75rem;
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
                color: #64748b;
                margin-bottom: 4px;
            }

            .meta-value {
                font-size: 1.05rem;
                font-weight: 600;
                color: #0f172a;
            }

            .section {
                margin-bottom: 35px;
            }

            .section-title {
                font-size: 1.25rem;
                font-weight: 600;
                color: #0f172a;
                margin-bottom: 15px;
                padding-bottom: 8px;
                border-bottom: 2px solid #3b82f6;
            }

            .results-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 15px;
            }

            .results-table th,
            .results-table td {
                padding: 12px 16px;
                border-bottom: 1px solid #e2e8f0;
                text-align: left;
            }

            .results-table th {
                background: #f8fafc;
                text-transform: uppercase;
                font-size: 0.75rem;
                color: #64748b;
                letter-spacing: 0.08em;
                font-weight: 600;
            }

            .results-table td {
                font-size: 0.95rem;
                color: #0f172a;
            }

            .results-table tbody tr:hover {
                background: #f8fafc;
            }

            .print-actions {
                margin-top: 30px;
                text-align: right;
                padding-top: 20px;
                border-top: 1px solid #e2e8f0;
            }

            .btn-print-primary {
                background: #3b82f6;
                color: #fff;
                padding: 10px 20px;
                border-radius: 8px;
                border: none;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.2s;
            }

            .btn-print-primary:hover {
                background: #2563eb;
            }

            .btn-print-secondary {
                background: #e2e8f0;
                color: #475569;
                margin-right: 10px;
                padding: 10px 20px;
                border-radius: 8px;
                border: none;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.2s;
            }

            .btn-print-secondary:hover {
                background: #cbd5e1;
            }

            .alert-error {
                border-radius: 8px;
                padding: 16px 20px;
                background: #fee2e2;
                color: #991b1b;
                margin-bottom: 20px;
            }

            .no-data {
                text-align: center;
                padding: 30px;
                color: #94a3b8;
                font-style: italic;
            }

            @media print {
                body {
                    background: #fff;
                    padding: 0;
                }

                /* Hide Master Page Elements */
                .sidebar,
                .main-header,
                .footer,
                .mobile-header,
                .mobile-menu-toggle,
                .nav-toggle,
                .topbar-toggler {
                    display: none !important;
                }

                .main-panel {
                    width: 100% !important;
                    margin-top: 0 !important;
                    padding-top: 0 !important;
                }

                .page-inner {
                    padding: 0 !important;
                }

                .print-actions {
                    display: none;
                }

                .report-card {
                    box-shadow: none;
                    padding: 0;
                    margin: 0;
                    max-width: 100%;
                }

                .results-table tbody tr:hover {
                    background: transparent;
                }
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="report-card">
            <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="alert-error">
                <asp:Literal ID="ErrorLiteral" runat="server"></asp:Literal>
            </asp:Panel>

            <asp:Panel ID="ContentPanel" runat="server" Visible="false">
                <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>

                <div class="report-header">
                    <h2>
                        <asp:Literal ID="ReportTypeLiteral" runat="server"></asp:Literal>
                    </h2>
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
                </div>

                <asp:Panel ID="OrderedTestsPanel" runat="server" CssClass="section" Visible="false">
                    <h3 class="section-title">Ordered Lab Tests</h3>
                    <asp:Repeater ID="OrderedTestsRepeater" runat="server">
                        <HeaderTemplate>
                            <table class="results-table">
                                <thead>
                                    <tr>
                                        <th style="width: 50%;">Test Name</th>
                                        <th style="width: 50%;">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <%# Eval("TestName") %>
                                </td>
                                <td>
                                    <%# Eval("Status") %>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                    <asp:PlaceHolder ID="NoOrderedTestsPlaceholder" runat="server" Visible="false">
                        <div class="no-data">No lab tests were ordered for this visit.</div>
                    </asp:PlaceHolder>
                </asp:Panel>

                <asp:Panel ID="ResultsPanel" runat="server" CssClass="section" Visible="false">
                    <h3 class="section-title">
                        Lab Test Results
                        <small style="font-size: 0.85rem; font-weight: normal; color: #64748b; margin-left: 10px;">
                            Sample Date: <asp:Literal ID="SampleDateLiteral" runat="server"></asp:Literal>
                        </small>
                    </h3>
                    <asp:Repeater ID="ResultsRepeater" runat="server">
                        <HeaderTemplate>
                            <table class="results-table">
                                <thead>
                                    <tr>
                                        <th style="width: 50%;">Test</th>
                                        <th style="width: 50%;">Result</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td>
                                    <%# Eval("TestName") %>
                                </td>
                                <td>
                                    <%# Eval("Result") %>
                                </td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate>
                            </tbody>
                            </table>
                        </FooterTemplate>
                    </asp:Repeater>
                    <asp:PlaceHolder ID="NoResultsPlaceholder" runat="server" Visible="false">
                        <div class="no-data">Lab results are not yet available for this visit.</div>
                    </asp:PlaceHolder>
                </asp:Panel>

                <div class="print-actions">
                    <button type="button" class="btn-print-secondary" onclick="window.history.back()">Back</button>
                    <button type="button" class="btn-print-primary" onclick="window.print()">
                        <i class="fas fa-print"></i> Print Report
                    </button>
                </div>
            </asp:Panel>
        </div>
        
        <!-- Watermark -->
        <div class="print-watermark">
            <img src="assets/vafmadow.png" alt="Hospital Logo Watermark" />
        </div>
    </asp:Content>