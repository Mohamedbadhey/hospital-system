<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="user_profile.aspx.cs" Inherits="juba_hospital.user_profile" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        .profile-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
        }

        .profile-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 48px;
            color: #667eea;
        }

        .profile-body {
            padding: 40px 30px;
        }

        .form-section {
            margin-bottom: 30px;
        }

        .form-section h3 {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
            font-size: 14px;
        }

        .form-control-custom {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }

        .form-control-custom:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-control-custom:disabled {
            background-color: #f5f5f5;
            cursor: not-allowed;
        }

        .btn-custom {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-primary-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }

        .btn-secondary-custom {
            background: #6c757d;
            color: white;
            margin-left: 10px;
        }

        .btn-secondary-custom:hover {
            background: #5a6268;
        }

        .alert-custom {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .alert-custom.show {
            display: block;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .info-label {
            font-weight: 600;
            color: #666;
        }

        .info-value {
            color: #333;
        }

        .password-strength {
            margin-top: 5px;
            font-size: 12px;
        }

        .strength-weak {
            color: #dc3545;
        }

        .strength-medium {
            color: #ffc107;
        }

        .strength-strong {
            color: #28a745;
        }
    </style>

    <div class="profile-container">
        <div class="profile-card">
            <!-- Profile Header -->
            <div class="profile-header">
                <div class="profile-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <h2><asp:Label ID="lblDisplayName" runat="server"></asp:Label></h2>
                <p><asp:Label ID="lblUserRole" runat="server"></asp:Label></p>
            </div>

            <!-- Profile Body -->
            <div class="profile-body">
                <!-- Alert Messages -->
                <div class="alert-custom alert-success" id="successAlert">
                    <i class="fas fa-check-circle"></i>
                    <asp:Label ID="lblSuccess" runat="server"></asp:Label>
                </div>
                <div class="alert-custom alert-danger" id="errorAlert">
                    <i class="fas fa-exclamation-circle"></i>
                    <asp:Label ID="lblError" runat="server"></asp:Label>
                </div>

                <!-- Account Information -->
                <div class="form-section">
                    <h3><i class="fas fa-info-circle"></i> Account Information</h3>
                    <div class="info-item">
                        <span class="info-label">User ID:</span>
                        <span class="info-value"><asp:Label ID="lblUserId" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Account Type:</span>
                        <span class="info-value"><asp:Label ID="lblAccountType" runat="server"></asp:Label></span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Current Username:</span>
                        <span class="info-value"><asp:Label ID="lblCurrentUsername" runat="server"></asp:Label></span>
                    </div>
                </div>

                <!-- Change Username -->
                <div class="form-section">
                    <h3><i class="fas fa-user-edit"></i> Change Username</h3>
                    <div class="form-group">
                        <label>New Username</label>
                        <asp:TextBox ID="txtNewUsername" runat="server" CssClass="form-control-custom" 
                                     placeholder="Enter new username"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNewUsername" runat="server" 
                                                    ControlToValidate="txtNewUsername" 
                                                    ErrorMessage="New username is required" 
                                                    CssClass="text-danger" Display="Dynamic" 
                                                    ValidationGroup="Username" />
                    </div>
                    <asp:Button ID="btnUpdateUsername" runat="server" Text="Update Username" 
                                CssClass="btn-custom btn-primary-custom" 
                                OnClick="btnUpdateUsername_Click" ValidationGroup="Username" />
                </div>

                <!-- Change Password -->
                <div class="form-section">
                    <h3><i class="fas fa-lock"></i> Change Password</h3>
                    <div class="form-group">
                        <label>Current Password</label>
                        <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" 
                                     CssClass="form-control-custom" placeholder="Enter current password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvCurrentPassword" runat="server" 
                                                    ControlToValidate="txtCurrentPassword" 
                                                    ErrorMessage="Current password is required" 
                                                    CssClass="text-danger" Display="Dynamic" 
                                                    ValidationGroup="Password" />
                    </div>
                    <div class="form-group">
                        <label>New Password</label>
                        <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" 
                                     CssClass="form-control-custom" placeholder="Enter new password"
                                     onkeyup="checkPasswordStrength(this.value)"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server" 
                                                    ControlToValidate="txtNewPassword" 
                                                    ErrorMessage="New password is required" 
                                                    CssClass="text-danger" Display="Dynamic" 
                                                    ValidationGroup="Password" />
                        <div id="passwordStrength" class="password-strength"></div>
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" 
                                     CssClass="form-control-custom" placeholder="Confirm new password"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                                                    ControlToValidate="txtConfirmPassword" 
                                                    ErrorMessage="Please confirm your password" 
                                                    CssClass="text-danger" Display="Dynamic" 
                                                    ValidationGroup="Password" />
                        <asp:CompareValidator ID="cvConfirmPassword" runat="server" 
                                              ControlToValidate="txtConfirmPassword" 
                                              ControlToCompare="txtNewPassword" 
                                              ErrorMessage="Passwords do not match" 
                                              CssClass="text-danger" Display="Dynamic" 
                                              ValidationGroup="Password" />
                    </div>
                    <asp:Button ID="btnUpdatePassword" runat="server" Text="Update Password" 
                                CssClass="btn-custom btn-primary-custom" 
                                OnClick="btnUpdatePassword_Click" ValidationGroup="Password" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" 
                                CssClass="btn-custom btn-secondary-custom" 
                                OnClientClick="clearPasswordFields(); return false;" />
                </div>
            </div>
        </div>
    </div>

    <script>
        // Show alert messages if they have content
        window.onload = function () {
            var successLabel = document.getElementById('<%= lblSuccess.ClientID %>');
            var errorLabel = document.getElementById('<%= lblError.ClientID %>');

            if (successLabel && successLabel.innerHTML.trim() !== '') {
                document.getElementById('successAlert').classList.add('show');
                setTimeout(function () {
                    document.getElementById('successAlert').classList.remove('show');
                }, 5000);
            }

            if (errorLabel && errorLabel.innerHTML.trim() !== '') {
                document.getElementById('errorAlert').classList.add('show');
            }
        };

        function checkPasswordStrength(password) {
            var strengthDiv = document.getElementById('passwordStrength');
            var strength = 0;

            if (password.length >= 8) strength++;
            if (password.match(/[a-z]+/)) strength++;
            if (password.match(/[A-Z]+/)) strength++;
            if (password.match(/[0-9]+/)) strength++;
            if (password.match(/[$@#&!]+/)) strength++;

            if (password.length === 0) {
                strengthDiv.innerHTML = '';
            } else if (strength <= 2) {
                strengthDiv.innerHTML = '<span class="strength-weak"><i class="fas fa-circle"></i> Weak password</span>';
            } else if (strength === 3) {
                strengthDiv.innerHTML = '<span class="strength-medium"><i class="fas fa-circle"></i> Medium strength</span>';
            } else {
                strengthDiv.innerHTML = '<span class="strength-strong"><i class="fas fa-circle"></i> Strong password</span>';
            }
        }

        function clearPasswordFields() {
            document.getElementById('<%= txtCurrentPassword.ClientID %>').value = '';
            document.getElementById('<%= txtNewPassword.ClientID %>').value = '';
            document.getElementById('<%= txtConfirmPassword.ClientID %>').value = '';
            document.getElementById('passwordStrength').innerHTML = '';
        }
    </script>
</asp:Content>
