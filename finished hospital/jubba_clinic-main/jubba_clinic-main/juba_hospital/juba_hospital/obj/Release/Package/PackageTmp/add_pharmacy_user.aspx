<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="add_pharmacy_user.aspx.cs" Inherits="juba_hospital.add_pharmacy_user" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        .dataTables_wrapper .dataTables_filter { float: right; text-align: right; }
        .dataTables_wrapper .dataTables_length { float: left; }
        #datatable { width: 100%; margin: 20px 0; font-size: 14px; }
        #datatable th, #datatable td { text-align: center; vertical-align: middle; }
        #datatable th { background-color: #007bff; color: white; font-weight: bold; }
        #datatable td { background-color: #f8f9fa; }

        /* ============================================
           MOBILE RESPONSIVE STYLES
           ============================================ */
        
        /* Mobile: Small screens (up to 576px) */
        @media (max-width: 576px) {
            /* Page layout adjustments */
            .container-fluid {
                padding: 10px 5px;
            }

            .row {
                margin: 0 5px;
            }

            .col-md-12 {
                padding: 0 5px;
            }

            /* Card adjustments */
            .card {
                margin: 10px 5px;
                border-radius: 8px;
            }

            .card-header {
                padding: 12px 15px;
            }

            .card-header h4 {
                font-size: 1.1rem;
                margin-bottom: 10px;
            }

            .card-body {
                padding: 10px;
            }

            /* Form adjustments */
            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                font-size: 0.9rem;
                font-weight: 600;
            }

            .form-control {
                font-size: 14px;
                padding: 10px;
                min-height: 44px;
            }

            /* Button layout - full width on mobile */
            .btn {
                width: 100%;
                margin-top: 10px;
                min-height: 44px;
                padding: 10px 16px;
                font-size: 14px;
            }

            /* DataTable responsive */
            .dataTables_wrapper {
                padding: 0;
            }

            .dataTables_wrapper .dataTables_length,
            .dataTables_wrapper .dataTables_filter {
                float: none;
                text-align: left;
                margin-bottom: 10px;
            }

            .dataTables_wrapper .dataTables_filter input {
                width: 100%;
                margin-left: 0;
            }

            .dataTables_wrapper .dataTables_length select {
                width: 100%;
            }

            /* Table wrapper with horizontal scroll */
            .table-responsive {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }

            table {
                font-size: 12px;
                margin: 10px 0;
            }

            table th,
            table td {
                padding: 8px 4px;
                white-space: nowrap;
            }

            table .btn {
                padding: 4px 8px;
                font-size: 12px;
                width: auto;
            }

            /* Pagination */
            .dataTables_wrapper .dataTables_paginate {
                float: none;
                text-align: center;
                margin-top: 10px;
            }

            .dataTables_wrapper .dataTables_info {
                float: none;
                text-align: center;
                padding-top: 10px;
            }

            /* Modal adjustments */
            .modal-dialog {
                margin: 10px;
                max-width: calc(100% - 20px);
            }

            .modal-body {
                padding: 15px;
            }

            .modal-footer .btn {
                flex: 1 1 auto;
                min-width: 80px;
            }
        }

        /* Tablet: Medium screens (577px to 768px) */
        @media (min-width: 577px) and (max-width: 768px) {
            .card {
                margin: 15px 10px;
            }

            .btn {
                width: auto;
                min-width: 150px;
            }

            table {
                font-size: 13px;
            }

            .modal-dialog {
                max-width: 90%;
            }
        }

        /* Touch-friendly improvements for all mobile devices */
        @media (max-width: 768px) {
            /* Better form controls */
            input[type="text"],
            input[type="number"],
            input[type="password"],
            select {
                min-height: 44px;
                font-size: 16px; /* Prevents zoom on iOS */
            }

            /* Prevent text selection issues on mobile */
            .card-header {
                -webkit-user-select: none;
                user-select: none;
            }
        }

        /* Landscape phone optimization */
        @media (max-width: 768px) and (orientation: landscape) {
            .card-body {
                max-height: 60vh;
                overflow-y: auto;
            }

            .modal-body {
                max-height: 60vh;
                overflow-y: auto;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="modal fade" id="medmodal" data-bs-backdrop="static" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Add Pharmacy User</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <input style="display:none" id="id11" />
            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <input type="text" class="form-control" id="fullname" placeholder="Enter Full Name">
                <small id="nameError" class="text-danger"></small>
            </div>
            <div class="mb-3">
                <label class="form-label">Phone</label>
                <input type="text" class="form-control" id="phone" placeholder="Enter Phone">
                <small id="phoneError" class="text-danger"></small>
            </div>
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" class="form-control" id="username" placeholder="Enter Username">
                <small id="usernameError" class="text-danger"></small>
            </div>
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="text" class="form-control" id="password" placeholder="Enter Password">
                <small id="passwordError" class="text-danger"></small>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="button" onclick="submitInfo()" class="btn btn-primary">Submit</button>
          </div>
        </div>
      </div>
    </div>
    
    <div class="modal fade" id="medmodal1" data-bs-backdrop="static" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Update Pharmacy User</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <input style="display:none" id="id111" />
            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <input type="text" class="form-control" id="fullname1" placeholder="Enter Full Name">
                <small id="nameError1" class="text-danger"></small>
            </div>
            <div class="mb-3">
                <label class="form-label">Phone</label>
                <input type="text" class="form-control" id="phone1" placeholder="Enter Phone">
                <small id="phoneError1" class="text-danger"></small>
            </div>
            <div class="mb-3">
                <label class="form-label">Username</label>
                <input type="text" class="form-control" id="username1" placeholder="Enter Username">
                <small id="usernameError1" class="text-danger"></small>
            </div>
            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="text" class="form-control" id="password1" placeholder="Enter Password">
                <small id="passwordError1" class="text-danger"></small>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="button" onclick="deletejob()" class="btn btn-danger">Delete</button>
            <button type="button" onclick="update()" class="btn btn-primary">Update</button>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title">Pharmacy User Management</h4>
                    <div class="row">
                        <div class="col-9"></div>
                        <div class="col-3">
                            <button type="button" id="add" class="btn btn-primary">Add User</button>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="display nowrap" style="width:100%" id="datatable">
                            <thead>
                                <tr>
                                    <th>Full Name</th>
                                    <th>Phone</th>
                                    <th>Username</th>
                                    <th>Password</th>
                                    <th>Operation</th>
                                </tr>
                            </thead>
                            <tfoot>
                                <tr>
                                    <th>Full Name</th>
                                    <th>Phone</th>
                                    <th>Username</th>
                                    <th>Password</th>
                                    <th>Operation</th>
                                </tr>
                            </tfoot>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="assets/js/core/jquery-3.7.1.min.js"></script>
    <script src="datatables/datatables.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#datatable').DataTable({
                responsive: true,
                autoWidth: false,
                scrollX: true,
                dom: 'Bfrtip',
                buttons: ['excelHtml5'],
                columnDefs: [
                    { responsivePriority: 1, targets: 0 },  // Full Name - Always visible
                    { responsivePriority: 2, targets: -1 }, // Operation - Always visible
                    { responsivePriority: 3, targets: 1 },  // Phone
                    { responsivePriority: 4, targets: 2 },  // Username
                    { responsivePriority: 5, targets: 3 }   // Password
                ],
                language: {
                    emptyTable: "No pharmacy users registered yet",
                    zeroRecords: "No matching pharmacy users found"
                }
            });
        });

        $("#datatable").on("click", ".edit1-btn", function (event) {
            event.preventDefault();
            var row = $(this).closest("tr");
            var userid = $(this).data("id");
            $("#id111").val(userid);
            $("#fullname1").val(row.find("td:nth-child(1)").text());
            $("#phone1").val(row.find("td:nth-child(2)").text());
            $("#username1").val(row.find("td:nth-child(3)").text());
            $("#password1").val(row.find("td:nth-child(4)").text());
            $('#medmodal1').modal('show');
        });

        function update() {
            var id = $("#id111").val();
            var fullname = $("#fullname1").val();
            var phone = $("#phone1").val();
            var username = $("#username1").val();
            var password = $("#password1").val();

            if (fullname.trim() === "" || phone.trim() === "" || username.trim() === "" || password.trim() === "") {
                Swal.fire('Error', 'Please fill all fields', 'error');
                return;
            }

            $.ajax({
                url: 'add_pharmacy_user.aspx/updateUser',
                data: "{'id':'" + id + "', 'fullname':'" + fullname + "', 'phone':'" + phone + "', 'username':'" + username + "', 'password':'" + password + "'}",
                dataType: "json",
                type: 'POST',
                contentType: "application/json",
                success: function (response) {
                    $('#medmodal1').modal('hide');
                    Swal.fire('Successfully Updated!', 'User updated successfully!', 'success');
                    datadisplay();
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }

        function deletejob() {
            var id = $("#id111").val();
            $.ajax({
                type: "POST",
                url: "add_pharmacy_user.aspx/deleteUser",
                data: JSON.stringify({ id: id }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $('#medmodal1').modal('hide');
                    if (response.d === 'true') {
                        Swal.fire('Successfully Deleted!', 'User deleted successfully!', 'success');
                        datadisplay();
                    }
                },
                error: function (xhr, status, error) {
                    alert("Error: " + xhr.responseText);
                }
            });
        }

        datadisplay();
        function datadisplay() {
            $.ajax({
                url: 'add_pharmacy_user.aspx/datadisplay',
                dataType: "json",
                type: 'POST',
                contentType: "application/json",
                success: function (response) {
                    $("#datatable tbody").empty();
                    for (var i = 0; i < response.d.length; i++) {
                        $("#datatable tbody").append(
                            "<tr>"
                            + "<td>" + response.d[i].fullname + "</td>"
                            + "<td>" + response.d[i].phone + "</td>"
                            + "<td>" + response.d[i].username + "</td>"
                            + "<td>" + response.d[i].password + "</td>"
                            + "<td><button class='edit1-btn btn btn-success' data-id='" + response.d[i].userid + "'>Edit</button></td>"
                            + "</tr>");
                    }
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }

        function submitInfo() {
            var fullname = $("#fullname").val();
            var phone = $("#phone").val();
            var username = $("#username").val();
            var password = $("#password").val();

            if (fullname.trim() === "" || phone.trim() === "" || username.trim() === "" || password.trim() === "") {
                Swal.fire('Error', 'Please fill all fields', 'error');
                return;
            }

            $.ajax({
                url: 'add_pharmacy_user.aspx/submitdata',
                data: "{'fullname':'" + fullname + "', 'phone':'" + phone + "', 'username':'" + username + "', 'password':'" + password + "'}",
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                type: 'POST',
                success: function (response) {
                    $('#medmodal').modal('hide');
                    if (response.d === 'true') {
                        Swal.fire('Successfully Saved!', 'Pharmacy user added successfully!', 'success');
                        datadisplay();
                        $("#fullname").val('');
                        $("#phone").val('');
                        $("#username").val('');
                        $("#password").val('');
                    }
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }

        document.getElementById('add').addEventListener('click', function () {
            $('#medmodal').modal('show');
        });
    </script>
</asp:Content>

