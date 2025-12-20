<%@ Page Title="Hospital Settings" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="hospital_settings.aspx.cs" Inherits="juba_hospital.hospital_settings" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="Content/responsive.css" />
        <style>
            /* Fix scrolling issue - AGGRESSIVE */
            html, body {
                overflow-y: auto !important;
                height: auto !important;
                min-height: 100vh !important;
            }
            
            body {
                overflow-x: hidden !important;
            }
            
            .wrapper {
                height: auto !important;
                min-height: 100vh !important;
            }
            
            .main-panel {
                overflow-y: auto !important;
                overflow-x: hidden !important;
                height: auto !important;
                max-height: none !important;
                min-height: 100vh !important;
            }
            
            .page-inner {
                overflow: visible !important;
                height: auto !important;
                min-height: calc(100vh - 100px) !important;
                padding-bottom: 100px !important;
            }
            
            .main-panel .container,
            .main-panel .container-fluid {
                overflow: visible !important;
            }
            
            .settings-container {
                max-width: 1200px;
                margin: 0 auto;
                padding-bottom: 100px;
                overflow: visible !important;
            }
            
            /* Ensure all form sections are visible */
            .form-section {
                position: relative;
                z-index: 1;
            }

            .preview-image {
                max-width: 200px;
                max-height: 200px;
                border: 2px dashed #ddd;
                border-radius: 8px;
                padding: 10px;
                margin-top: 10px;
                display: none;
            }

            .preview-image.show {
                display: block;
            }

            .upload-area {
                border: 2px dashed #6a11cb;
                border-radius: 8px;
                padding: 20px;
                text-align: center;
                background: #f8f9fa;
                cursor: pointer;
                transition: all 0.3s;
            }

            .upload-area:hover {
                background: #e9ecef;
                border-color: #2575fc;
            }

            .upload-area i {
                font-size: 48px;
                color: #6a11cb;
                margin-bottom: 10px;
            }

            .current-logo {
                max-width: 150px;
                max-height: 150px;
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 10px;
            }

            .form-section {
                background: white;
                padding: 25px;
                border-radius: 12px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                margin-bottom: 25px;
            }

            .form-section h3 {
                color: #1e293b;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #e2e8f0;
            }

            .btn-save {
                background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
                color: white;
                padding: 12px 40px;
                border: none;
                border-radius: 8px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
            }

            .btn-save:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(106, 17, 203, 0.3);
            }

            .alert-success {
                background: #d4edda;
                color: #155724;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                border-left: 4px solid #28a745;
            }

            .alert-danger {
                background: #f8d7da;
                color: #721c24;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                border-left: 4px solid #dc3545;
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="settings-container">
            <div class="row">
                <div class="col-md-12">
                    <h2 class="mb-4">
                        <i class="fas fa-cog"></i> Hospital Settings
                    </h2>

                    <!-- Success/Error Messages -->
                    <asp:Panel ID="SuccessPanel" runat="server" CssClass="alert-success" Visible="false">
                        <i class="fas fa-check-circle"></i>
                        <asp:Label ID="SuccessMessage" runat="server"></asp:Label>
                    </asp:Panel>

                    <asp:Panel ID="ErrorPanel" runat="server" CssClass="alert-danger" Visible="false">
                        <i class="fas fa-exclamation-circle"></i>
                        <asp:Label ID="ErrorMessage" runat="server"></asp:Label>
                    </asp:Panel>

                    <!-- Hospital Information Section -->
                    <div class="form-section">
                        <h3><i class="fas fa-hospital"></i> Hospital Information</h3>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="txtHospitalName">Hospital Name <span
                                            class="text-danger">*</span></label>
                                    <asp:TextBox ID="txtHospitalName" runat="server" CssClass="form-control"
                                        placeholder="Enter hospital name" required></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvHospitalName" runat="server"
                                        ControlToValidate="txtHospitalName" ErrorMessage="Hospital name is required"
                                        CssClass="text-danger" Display="Dynamic"></asp:RequiredFieldValidator>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="txtHospitalPhone">Phone Number</label>
                                    <asp:TextBox ID="txtHospitalPhone" runat="server" CssClass="form-control"
                                        placeholder="+252-XXX-XXXX"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="txtHospitalAddress">Address</label>
                                    <asp:TextBox ID="txtHospitalAddress" runat="server" CssClass="form-control"
                                        TextMode="MultiLine" Rows="2" placeholder="Enter hospital address">
                                    </asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="txtHospitalEmail">Email</label>
                                    <asp:TextBox ID="txtHospitalEmail" runat="server" CssClass="form-control"
                                        TextMode="Email" placeholder="info@hospital.com"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="txtHospitalWebsite">Website</label>
                                    <asp:TextBox ID="txtHospitalWebsite" runat="server" CssClass="form-control"
                                        placeholder="www.hospital.com"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label for="txtPrintHeaderText">Print Header Tagline</label>
                                    <asp:TextBox ID="txtPrintHeaderText" runat="server" CssClass="form-control"
                                        placeholder="e.g., Quality Healthcare Services"></asp:TextBox>
                                    <small class="text-muted">This text will appear on all printed reports</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Logo Upload Section -->
                    <div class="form-section">
                        <h3><i class="fas fa-image"></i> Logo Management</h3>
                        <div class="row">
                            <!-- Sidebar Logo -->
                            <div class="col-md-6">
                                <h5>Sidebar Logo</h5>
                                <p class="text-muted">This logo appears in the navigation sidebar</p>

                                <div class="upload-area" onclick="document.getElementById('<%= fuSidebarLogo.ClientID %>').click()">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <p>Click to upload sidebar logo</p>
                                    <small class="text-muted">PNG, JPG, JPEG, SVG (Max 2MB)</small>
                                </div>

                                <asp:FileUpload ID="fuSidebarLogo" runat="server" CssClass="d-none"
                                    onchange="previewImage(this, 'imgSidebarPreview')" accept="image/*" />

                                <div class="mt-3">
                                    <strong>Current Logo:</strong><br />
                                    <asp:Image ID="imgCurrentSidebarLogo" runat="server" CssClass="current-logo mt-2" />
                                </div>

                                <img id="imgSidebarPreview" class="preview-image" alt="Preview" />
                            </div>

                            <!-- Print Header Logo -->
                            <div class="col-md-6">
                                <h5>Print Header Logo</h5>
                                <p class="text-muted">This logo appears on all printed reports</p>

                                <div class="upload-area" onclick="document.getElementById('<%= fuPrintLogo.ClientID %>').click()">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    <p>Click to upload print header logo</p>
                                    <small class="text-muted">PNG, JPG, JPEG, SVG (Max 2MB)</small>
                                </div>

                                <asp:FileUpload ID="fuPrintLogo" runat="server" CssClass="d-none"
                                    onchange="previewImage(this, 'imgPrintPreview')" accept="image/*" />

                                <div class="mt-3">
                                    <strong>Current Logo:</strong><br />
                                    <asp:Image ID="imgCurrentPrintLogo" runat="server" CssClass="current-logo mt-2" />
                                </div>

                                <img id="imgPrintPreview" class="preview-image" alt="Preview" />
                            </div>
                        </div>
                    </div>

                    <!-- Save Button -->
                    <div class="text-center mt-4">
                        <asp:Button ID="btnSave" runat="server" Text="Save Settings" CssClass="btn btn-save"
                            OnClick="btnSave_Click" />
                    </div>
                </div>
            </div>
        </div>

        <script>
            function previewImage(input, previewId) {
                const preview = document.getElementById(previewId);

                if (input.files && input.files[0]) {
                    const reader = new FileReader();

                    reader.onload = function (e) {
                        preview.src = e.target.result;
                        preview.classList.add('show');
                    }

                    reader.readAsDataURL(input.files[0]);
                }
            }
        </script>
    </asp:Content>