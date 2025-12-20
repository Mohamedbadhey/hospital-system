<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/register.Master" AutoEventWireup="true" CodeBehind="register_profile.aspx.cs" Inherits="juba_hospital.register_profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .profile-container {
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
        }

        .info-item {
            padding: 15px 0;
            border-bottom: 1px solid #f0f0f0;
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

        .strength-weak { color: #dc3545; }
        .strength-medium { color: #ffc107; }
        .strength-strong { color: #28a745; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="profile-container">
        <div class="row">
            <div class="col-md-12">
                <div class="profile-card">
                    <div class="profile-header">
                        <div class="profile-avatar">
                            <i class="fas fa-user-plus"></i>
                        </div>
                        <h2><asp:Label ID="lblDisplayName" runat="server"></asp:Label></h2>
                        <p><asp:Label ID="lblUserRole" runat="server"></asp:Label></p>
                    </div>

                    <div class="profile-body">
                        <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success" Visible="false"></asp:Label>
                        <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger" Visible="false"></asp:Label>

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
                                <asp:TextBox ID="txtNewUsername" runat="server" CssClass="form-control form-control-custom" 
                                             placeholder="Enter new username"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvNewUsername" runat="server" 
                                                            ControlToValidate="txtNewUsername" 
                                                            ErrorMessage="New username is required" 
                                                            CssClass="text-danger" Display="Dynamic" 
                                                            ValidationGroup="Username" />
                            </div>
                            <asp:Button ID="btnUpdateUsername" runat="server" Text="Update Username" 
                                        CssClass="btn btn-custom btn-primary-custom" 
                                        OnClick="btnUpdateUsername_Click" ValidationGroup="Username" />
                        </div>

                        <!-- Change Password -->
                        <div class="form-section">
                            <h3><i class="fas fa-lock"></i> Change Password</h3>
                            <div class="form-group">
                                <label>Current Password</label>
                                <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" 
                                             CssClass="form-control form-control-custom" placeholder="Enter current password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCurrentPassword" runat="server" 
                                                            ControlToValidate="txtCurrentPassword" 
                                                            ErrorMessage="Current password is required" 
                                                            CssClass="text-danger" Display="Dynamic" 
                                                            ValidationGroup="Password" />
                            </div>
                            <div class="form-group">
                                <label>New Password</label>
                                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" 
                                             CssClass="form-control form-control-custom" placeholder="Enter new password"
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
                                             CssClass="form-control form-control-custom" placeholder="Confirm new password"></asp:TextBox>
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
                                        CssClass="btn btn-custom btn-primary-custom" 
                                        OnClick="btnUpdatePassword_Click" ValidationGroup="Password" />
                            <button type="button" class="btn btn-custom btn-secondary-custom" onclick="clearPasswordFields()">Cancel</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
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

