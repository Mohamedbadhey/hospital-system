using System;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace juba_hospital
{
    public partial class admin_profile : System.Web.UI.Page
    {
        private string connectionString = WebConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
        private int roleId;
        private string userId;
        private string primaryId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["role_id"] == null || Session["UserId"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            roleId = Convert.ToInt32(Session["role_id"]);
            userId = Session["UserId"].ToString();
            primaryId = Session["id"].ToString();

            if (!IsPostBack)
            {
                LoadUserProfile();
            }
        }

        private void LoadUserProfile()
        {
            string tableName = GetTableName();
            string idColumn = GetIdColumn();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = $"SELECT username FROM {tableName} WHERE {idColumn} = @id";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", primaryId);
                    con.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        string username = dr["username"].ToString();
                        lblDisplayName.Text = username;
                        lblCurrentUsername.Text = username;
                        lblUserId.Text = primaryId;
                        lblUserRole.Text = GetRoleName();
                        lblAccountType.Text = GetRoleName();
                    }
                }
            }
        }

        protected void btnUpdateUsername_Click(object sender, EventArgs e)
        {
            string newUsername = txtNewUsername.Text.Trim();

            if (string.IsNullOrEmpty(newUsername))
            {
                ShowError("Please enter a new username");
                return;
            }

            if (UsernameExists(newUsername))
            {
                ShowError("Username already exists. Please choose a different username.");
                return;
            }

            string tableName = GetTableName();
            string idColumn = GetIdColumn();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = $"UPDATE {tableName} SET username = @username WHERE {idColumn} = @id";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@username", newUsername);
                    cmd.Parameters.AddWithValue("@id", primaryId);
                    
                    con.Open();
                    int result = cmd.ExecuteNonQuery();
                    
                    if (result > 0)
                    {
                        Session["UserId"] = newUsername;
                        Session["UserName"] = newUsername;
                        txtNewUsername.Text = "";
                        LoadUserProfile();
                        ShowSuccess("Username updated successfully!");
                    }
                    else
                    {
                        ShowError("Failed to update username. Please try again.");
                    }
                }
            }
        }

        protected void btnUpdatePassword_Click(object sender, EventArgs e)
        {
            string currentPassword = txtCurrentPassword.Text;
            string newPassword = txtNewPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            if (string.IsNullOrEmpty(currentPassword) || string.IsNullOrEmpty(newPassword))
            {
                ShowError("Please fill in all password fields");
                return;
            }

            if (newPassword != confirmPassword)
            {
                ShowError("New passwords do not match");
                return;
            }

            if (newPassword.Length < 6)
            {
                ShowError("Password must be at least 6 characters long");
                return;
            }

            if (!VerifyCurrentPassword(currentPassword))
            {
                ShowError("Current password is incorrect");
                return;
            }

            string tableName = GetTableName();
            string idColumn = GetIdColumn();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = $"UPDATE {tableName} SET password = @password WHERE {idColumn} = @id";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@password", newPassword);
                    cmd.Parameters.AddWithValue("@id", primaryId);
                    
                    con.Open();
                    int result = cmd.ExecuteNonQuery();
                    
                    if (result > 0)
                    {
                        txtCurrentPassword.Text = "";
                        txtNewPassword.Text = "";
                        txtConfirmPassword.Text = "";
                        ShowSuccess("Password updated successfully!");
                    }
                    else
                    {
                        ShowError("Failed to update password. Please try again.");
                    }
                }
            }
        }

        private bool VerifyCurrentPassword(string password)
        {
            string tableName = GetTableName();
            string idColumn = GetIdColumn();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = $"SELECT COUNT(*) FROM {tableName} WHERE {idColumn} = @id AND password = @password";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@id", primaryId);
                    cmd.Parameters.AddWithValue("@password", password);
                    
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
            }
        }

        private bool UsernameExists(string username)
        {
            string tableName = GetTableName();
            string idColumn = GetIdColumn();

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                string query = $"SELECT COUNT(*) FROM {tableName} WHERE username = @username AND {idColumn} != @id";
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@username", username);
                    cmd.Parameters.AddWithValue("@id", primaryId);
                    
                    con.Open();
                    int count = (int)cmd.ExecuteScalar();
                    return count > 0;
                }
            }
        }

        private string GetTableName()
        {
            // This page is for admin profile specifically
            return "admin";
        }

        private string GetIdColumn()
        {
            // Primary key column for admin table
            return "userid";
        }

        private string GetRoleName()
        {
            switch (roleId)
            {
                case 1: return "Doctor";
                case 2: return "Lab User";
                case 3: return "Registration Staff";
                case 4: return "Administrator";
                case 5: return "X-Ray User";
                case 6: return "Pharmacy User";
                default: return "Unknown";
            }
        }

        private void ShowSuccess(string message)
        {
            lblSuccess.Text = message;
            lblSuccess.Visible = true;
            lblError.Visible = false;
        }

        private void ShowError(string message)
        {
            lblError.Text = message;
            lblError.Visible = true;
            lblSuccess.Visible = false;
        }
    }
}
