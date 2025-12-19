<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="operateadmin.aspx.cs" Inherits="juba_hospital.operateadmin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link href="datatables/datatables.min.css" rel="stylesheet" />
          <style>
    /* Custom table styling */
    .dataTables_wrapper .dataTables_filter {
        float: right;
        text-align: right;
    }
    
    .dataTables_wrapper .dataTables_length {
        float: left;
    }
    
    .dataTables_wrapper .dataTables_paginate {
        float: right;
        text-align: right;
    }

    .dataTables_wrapper .dataTables_info {
        float: left;
    }

    #datatable {
        width: 100%;
        margin: 20px 0;
        font-size: 14px;
    }

    #datatable th, #datatable td {
        text-align: center;
        vertical-align: middle;
    }


    #datatable th {
        background-color: #007bff;
        color: white;
        font-weight: bold;
    }



    #datatable td {
        background-color: #f8f9fa;
    }



    .btn-primary {
        background-color: #007bff;
        border-color: #007bff;
    }


    .btn-primary:hover {
        background-color: #0056b3;
        border-color: #004085;
    }



    .btn-success {
        background-color: #28a745;
        border-color: #28a745;
    }



    .btn-success:hover {
        background-color: #218838;
        border-color: #1e7e34;
    }


</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

            <div class="row">
        <div class="col-9"></div>
        <div class="col-3">
    <%--        <!-- Button trigger modal -->
<button type="button" id="add" class="btn btn-primary">
 Add
</button>--%>
        </div>
    </div>

        <!-- Modal -->
<div class="modal fade" id="medmodal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="staticBackdropLabel1">Add Registre </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
<div class="modal-body">
    <input style="display:none" id="id11" />

    <div class="mb-3">
        <label for="name" class="form-label"> FullName</label>
        <input type="text" class="form-control" id="name" placeholder="Enter Name">
        <small id="nameError" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="dosage" class="form-label">Phone</label>
        <input type="number" class="form-control" id="phone" placeholder="number ">
        <small id="phoneerror" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="frequency" class="form-label">Username</label>
        <input type="text" class="form-control" id="username" placeholder="Enter username">
        <small id="usererror" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="duration" class="form-label">Password</label>
        <input type="text" class="form-control" id="pass" placeholder="Enter Pasword">
        <small id="passerror" class="text-danger"></small>
    </div>

  
</div>





      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" onclick="submitInfo()" class="btn btn-primary">submit</button>
      </div>
    </div>
  </div>
</div>


            <!-- Modal -->
<div class="modal fade" id="medmodal1" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="staticBackdropLabel11">Update  Admin </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
<div class="modal-body">
    <input style="display:none" id="id111" />

<%--    <div class="mb-3">
        <label for="name" class="form-label"> FullName</label>
        <input type="text" class="form-control" id="name1" placeholder="Enter Name">
        <small id="nameError1" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="dosage" class="form-label">Phone</label>
        <input type="number" class="form-control" id="phone1" placeholder="number ">
        <small id="phonerror1" class="text-danger"></small>
    </div>--%>

    <div class="mb-3">
        <label for="frequency" class="form-label">Username</label>
        <input type="text" class="form-control" id="username1" placeholder="Enter username">
        <small id="usererror1" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="duration" class="form-label">Password</label>
        <input type="text" class="form-control" id="pass1" placeholder="Enter Pasword">
        <small id="passerror1" class="text-danger"></small>
    </div>

  
</div>





      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
     <%--       <button type="button" onclick="deletejob()" class="btn btn-danger">delete</button>--%>
        <button type="button" onclick="update()" class="btn btn-primary">update</button>
      </div>
    </div>
  </div>
</div>
       <div class="row">
              <div class="col-md-12">
                <div class="card">
                  <div class="card-header">
                    <h4 class="card-title"> Admin Section </h4>
                  </div>
                  <div class="card-body">
                    <div >
                      <table class="display nowrap" style="width:100%"
                        id="datatable" >
                        <thead>
                          <tr>
<th>Username</th>
    <th>Password</th>
                               <th>operation</th>
                          </tr>
                        </thead>
                        <tfoot>
                          <tr>
                                 
<th>Username</th>
    <th>Password</th>
                                 <th>operation</th>
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
                dom: 'Bfrtip',
                buttons: [
                    'excelHtml5'
                ]
            });
        });




        // Delegate click events for edit and delete buttons to the table
        $("#datatable").on("click", ".edit1-btn", function (event) {
            event.preventDefault(); // Prevent default behavior

            var row = $(this).closest("tr");
            var userid = $(this).data("id");


     
            var username = row.find("td:nth-child(1)").text();

            var password = row.find("td:nth-child(2)").text();
     







            $("#id111").val(userid);
         
            $("#username1").val(username);
            $("#pass1").val(password);

            $('#medmodal1').modal('show');

 

        });



        function update() {


            document.getElementById('usererror1').textContent = "";
            document.getElementById('passerror1').textContent = "";
          
            var id = $("#id111").val();
  
            var username = $("#username1").val();
            var pass = $("#pass1").val();


            // Validate the form values
            let isValid = true;


            if (username.trim() === "") {
                document.getElementById('usererror1').textContent = "Please enter the username.";
                isValid = false;
            }

            if (pass.trim() === "") {
                document.getElementById('passerror1').textContent = "Please enter the password.";
                isValid = false;
            }







            // If all validations pass, proceed with AJAX call
            if (isValid) {

                $.ajax({
                    url: 'operateadmin.aspx/updateJob',
                    data: "{'id':'" + id + "','pass':'" + pass + "', 'username':'" + username + "'  }",

                    dataType: "json",
                    type: 'POST',
                    contentType: "application/json",
                    success: function (response) {
                        console.log(response);
                        $('#medmodal1').modal('hide');
                        Swal.fire(
                            'Successfully Updated !',
                            'You Updated a new admin!',
                            'success'
                        )
                        datadisplay();
                        clearInputFields();
                    },
                    error: function (response) {
                        alert(response.responseText);
                    }
                });

            }


            function clearInputFields() {
                // Replace these lines with code to clear the input fields
                $("#name1").val('');
                $("#title1").val('');
                $("#phone1").val('');
                $("#username1").val('');
                $("#pass1").val('');
                $("#id111").val('');

            }


        }


        //function deletejob() {
        //    var id = $("#id111").val();
        //    $.ajax({
        //        type: "POST",
        //        url: "add_registre.aspx/deleteJob",
        //        data: JSON.stringify({ id: id }),
        //        contentType: "application/json; charset=utf-8",
        //        dataType: "json",
        //        success: function (response) {
        //            $('#medmodal1').modal('hide');
        //            if (response.d === 'true') {
        //                Swal.fire(
        //                    'Successfully Deleted !',
        //                    'You Deleted  registre!',
        //                    'success'
        //                )

        //                datadisplay();
        //            } else {
        //                // Handle errors in the response
        //                Swal.fire({
        //                    icon: 'error',
        //                    title: 'Data Insertion Failed',
        //                    text: 'There was an error while inserting the data.',
        //                });
        //            }
        //        },
        //        error: function (xhr, status, error) {
        //            alert("Error: " + xhr.responseText);
        //        }
        //    });

        //}






        datadisplay();
        function datadisplay() {
            $.ajax({
                url: 'operateadmin.aspx/datadisplay',
                dataType: "json",
                type: 'POST',
                contentType: "application/json",
                success: function (response) {
                    console.log(response)

                    /*         swal("Good job!", "You clicked the button!", "success");*/
                    $("#datatable tbody").empty();

                    for (var i = 0; i < response.d.length; i++) {
                        $("#datatable tbody").append(
                            "<tr>"
                            + "<td>" + response.d[i].username + "</td>"
                            + "<td>" + response.d[i].password + "</td>"
                            + "<td><button class='edit1-btn btn btn-success' data-id='" + response.d[i].userid + "'>edit</button></td>"









                            + "</tr>")
                    }
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }

        function submitInfo() {
            // Clear previous error messages
            document.getElementById('nameError').textContent = "";
            document.getElementById('phoneerror').textContent = "";
            document.getElementById('usererror').textContent = "";
            document.getElementById('passerror').textContent = "";
    

      
            var name = $("#name").val();

            var phone = $("#phone").val();
            var username = $("#username").val();
            var pass = $("#pass").val();

            // Validate the form values
            let isValid = true;

            if (name.trim() === "") {
                document.getElementById('nameError').textContent = "Please enter the  name.";
                isValid = false;
            }

        

            if (phone.trim() === "") {
                document.getElementById('phoneerror').textContent = "Please enter the phone.";
                isValid = false;
            }

            if (username.trim() === "") {
                document.getElementById('usererror').textContent = "Please enter the username.";
                isValid = false;
            }

            if (pass.trim() === "") {
                document.getElementById('passerror').textContent = "Please enter the special password.";
                isValid = false;
            }



            // If all validations pass, proceed with AJAX call
            if (isValid) {

                $.ajax({
                    url: 'add_registre.aspx/submitdata',
                    data: "{ 'name':'" + name + "', 'pass':'" + pass + "', 'username':'" + username + "', 'phone':'" + phone + "' }",
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    type: 'POST',
                    success: function (response) {
                        console.log(response);
                        if (response.d === 'true') {
                            Swal.fire(
                                'Successfully Saved!',
                                'You added a new registre!',
                                'success'
                            );

                            clearInputFields(); // Clear input fields
                        } else {
                            // Handle errors in the response
                            Swal.fire({
                                icon: 'error',
                                title: 'Data Insertion Failed',
                                text: 'There was an error while inserting the data.',
                            });
                        }
                    },
                    error: function (response) {
                        alert(response.responseText);
                    }
                });

            }

            function clearInputFields() {
                // Replace these lines with code to clear the input fields
                $("#name").val('');
                $("#title").val('');
                $("#phone").val('');
                $("#username").val('');
                $("#pass").val('');

            }
        }

        document.getElementById('add').addEventListener('click', function () {
            // Show the modal
            $('#medmodal').modal('show');
        });

    
    </script>
</asp:Content>
