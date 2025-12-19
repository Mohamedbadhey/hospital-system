<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="juba_hospital.login" %>

  <!DOCTYPE html>

  <html xmlns="http://www.w3.org/1999/xhtml">

  <head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Hospital Management System - Login</title>

    <!-- Favicon will be added dynamically from code-behind -->
    <link href="assets/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 5px;
        flex-direction: column;
      }
      
      /* Prevent horizontal scroll on mobile */
      html, body {
        overflow-x: hidden;
        width: 100%;
      }

      .login-container {
        background: white;
        border-radius: 15px;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
        overflow: hidden;
        max-width: 600px;
        width: 90%;
        margin: 5px auto;
      }
      
      .login-footer {
        text-align: center;
        padding: 10px 15px;
        background: #f8f9fa;
        border-top: 1px solid #e9ecef;
      }
      
      .login-footer p {
        margin: 0;
        color: #6c757d;
        font-size: 11px;
        line-height: 1.3;
      }

      .hospital-logo {
        width: 60px;
        height: 60px;
        margin: 0 auto;
        display: block;
        border-radius: 50%;
        object-fit: contain;
        background: white;
        padding: 6px;
        border: 2px solid #667eea;
      }

      .login-right {
        padding: 20px 50px;
      }

      .login-header {
        margin-bottom: 15px;
      }

      .login-header h2 {
        font-size: 20px;
        font-weight: bold;
        color: #333;
        margin-bottom: 5px;
      }

      .login-header p {
        color: #666;
        font-size: 12px;
        margin: 0;
      }

      .form-group {
        margin-bottom: 10px;
      }

      .form-group label {
        display: block;
        margin-bottom: 4px;
        color: #555;
        font-weight: 500;
        font-size: 13px;
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

      .form-select-custom {
        width: 100%;
        padding: 12px 15px;
        border: 2px solid #e0e0e0;
        border-radius: 8px;
        font-size: 14px;
        background: white;
        cursor: pointer;
        transition: all 0.3s;
      }

      .form-select-custom:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
      }

      .btn-login {
        width: 100%;
        padding: 11px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: transform 0.3s, box-shadow 0.3s;
        margin-top: 8px;
      }

      .btn-login:hover {
        transform: translateY(-2px);
        box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
      }

      .error-message {
        background: #fee;
        color: #c33;
        padding: 10px 15px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-size: 14px;
        display: none;
      }

      .error-message.show {
        display: block;
      }

      .input-icon {
        position: relative;
      }

      .input-icon i {
        position: absolute;
        left: 15px;
        top: 50%;
        transform: translateY(-50%);
        color: #999;
      }

      .input-icon .form-control-custom {
        padding-left: 45px;
      }

      .features {
        margin-top: 40px;
      }

      .feature-item {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
      }

      .feature-item i {
        font-size: 24px;
        margin-right: 15px;
        opacity: 0.9;
      }

      .feature-item div h4 {
        font-size: 16px;
        margin-bottom: 5px;
      }

      .feature-item div p {
        font-size: 13px;
        opacity: 0.8;
        margin: 0;
      }

      /* Tablet and smaller desktops */
      @media (max-width: 768px) {
        .login-container {
          max-width: 450px;
          width: 85%;
        }
        
        .login-right {
          padding: 25px 30px;
        }
        
        .form-group {
          margin-bottom: 12px;
        }
      }
      
      /* Mobile landscape */
      @media (max-width: 576px) {
        .login-container {
          max-width: 380px;
          width: 90%;
          border-radius: 15px;
        }
        
        .login-right {
          padding: 20px 18px;
        }
        
        .hospital-logo {
          width: 70px;
          height: 70px;
        }
        
        .form-group {
          margin-bottom: 12px;
        }
      }
      
      /* Mobile portrait */
      @media (max-width: 480px) {
        body {
          padding: 5px;
        }
        
        .login-container {
          max-width: 100%;
          width: 95%;
          margin: 5px auto;
          border-radius: 12px;
        }
        
        .login-right {
          padding: 20px 15px;
        }
        
        .hospital-logo {
          width: 65px;
          height: 65px;
        }
        
        .form-group {
          margin-bottom: 10px;
        }
        
        .form-control-custom, .form-select-custom {
          font-size: 14px;
          padding: 9px 12px;
        }
        
        .btn-login {
          padding: 11px;
          font-size: 15px;
        }
        
        label {
          font-size: 13px;
          margin-bottom: 5px;
        }
        
        .login-footer {
          padding: 12px 15px;
        }
      }
      
      /* Very small phones */
      @media (max-width: 360px) {
        .login-container {
          width: 96%;
          border-radius: 10px;
        }
        
        .login-right {
          padding: 18px 12px;
        }
        
        .hospital-logo {
          width: 60px;
          height: 60px;
        }
        
        .form-group {
          margin-bottom: 10px;
        }
        
        .form-control-custom, .form-select-custom {
          font-size: 13px;
          padding: 8px 10px;
        }
        
        .btn-login {
          padding: 10px;
          font-size: 14px;
        }
        
        .login-footer {
          padding: 10px 12px;
        }
      }
    </style>
  </head>

  <body>
    <form id="form1" runat="server">
      <div class="login-container">
        <!-- Login Form -->
        <div class="login-right">
          <!-- Logo and Hospital Name -->
          <div style="text-align: center; margin-bottom: 15px;">
            <asp:Image ID="HospitalLogo" runat="server" AlternateText="Hospital Logo" CssClass="hospital-logo" />
            <h1 style="font-size: 18px; color: #333; margin: 8px 0 2px 0; font-weight: 600;">VIA-AFMADOW HOSPITAL</h1>
            <p style="color: #666; font-size: 12px; margin: 0;">Hospital Management System</p>
          </div>
          
          <div class="login-header">
            <h2>Welcome Back</h2>
            <p>Please login to your account</p>
          </div>

          <!-- Error Messages -->
          <div class="error-message" id="errorDiv">
            <asp:Label ID="LabelMessage" runat="server" Text=""></asp:Label>
            <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
          </div>

          <!-- Username -->
          <div class="form-group">
            <label for="TextBoxUsername">
              <i class="fas fa-user"></i> Username
            </label>
            <div class="input-icon">
              <i class="fas fa-user"></i>
              <asp:TextBox ID="TextBoxUsername" runat="server" CssClass="form-control-custom" 
                           placeholder="Enter your username" autocomplete="off"></asp:TextBox>
            </div>
            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="TextBoxUsername"
              ErrorMessage="Username is required" CssClass="text-danger" Display="Dynamic" />
          </div>

          <!-- Password -->
          <div class="form-group">
            <label for="TextBoxPassword">
              <i class="fas fa-lock"></i> Password
            </label>
            <div class="input-icon">
              <i class="fas fa-lock"></i>
              <asp:TextBox ID="TextBoxPassword" runat="server" TextMode="Password" 
                           CssClass="form-control-custom" placeholder="Enter your password"></asp:TextBox>
            </div>
            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="TextBoxPassword"
              ErrorMessage="Password is required" CssClass="text-danger" Display="Dynamic" />
          </div>

          <!-- User Type -->
          <div class="form-group">
            <label for="DropDownList1">
              <i class="fas fa-user-tag"></i> Login As
            </label>
            <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-select-custom"></asp:DropDownList>
          </div>

          <!-- Login Button -->
          <asp:Button ID="lognbtn" runat="server" Text="Login" CssClass="btn-login" 
                      OnClick="lognbtn_Click" />

          <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="text-danger" 
                                 DisplayMode="BulletList" style="margin-top: 15px;" />
        </div>
        
        <!-- Footer -->
        <div class="login-footer">
          <p>Powered by <a href="https://kismayoict.com" target="_blank" style="color: #667eea; text-decoration: none; font-weight: bold;">KismayoICT Solutions</a></p>
          <p style="font-size: 12px; margin-top: 5px;">© 2024 VIA-AFMADOW HOSPITAL. All rights reserved.</p>
        </div>
      </div>

      <script>
        // Show error message div if there's content
        window.onload = function() {
          var errorDiv = document.getElementById('errorDiv');
          var labelMessage = document.getElementById('<%= LabelMessage.ClientID %>');
          var label1 = document.getElementById('<%= Label1.ClientID %>');
          
          if ((labelMessage && labelMessage.innerHTML.trim() !== '') || 
              (label1 && label1.innerHTML.trim() !== '')) {
            errorDiv.classList.add('show');
          }
        };
      </script>
    </form>
  </body>

  </html>