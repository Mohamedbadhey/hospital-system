<%@ Page Title="" Language="C#" MasterPageFile="~/xray.Master" AutoEventWireup="true" CodeBehind="take_xray_lab_test.aspx.cs" Inherits="juba_hospital.take_xray_lab_test" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

            <style>
        .col-4 {
            width: 33.33%; /* Assuming col-4 means 4 columns in a 12-column layout */
            float: left;
            padding: 10px; /* Optional padding for spacing */
        }



        img {
            width: 90%;
            height: 90%;
            object-fit: cover; /* Ensures the image covers the area without distortion */
        }



        h1 {
            text-align: center; /* Centers the heading */
        }



    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

            <!-- Modal -->
<div class="modal fade" id="medmodal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="staticBackdropLabel1">Upload Lab Image Test </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
<div class="modal-body">
    <input style="display:none" id="id11" />



              <div class="col-4">
    <h1>Upload Lab Image</h1>
    <asp:FileUpload ID="FileUpload1" runat="server" />

 <img id="selectedImage22" src="" alt="Selected Image" />
</div>

    <div class="col-4">
         <div class="mb-3">
 <h1>Patient Details</h1>
               <label for="name" class="form-label">Patient Name</label><br />
             <label class="form-label"> Mohmed</label>

 </div>
    </div>
  

</div>





      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" onclick="updateinfo()" class="btn btn-primary">Update</button>
      </div>
    </div>
  </div>
</div>

        <label id="label2">1</label>
             <div class="row">
            <div class="col-md-12">
              <div class="card">
                <div class="card-header">
                  <h4 class="card-title">Assign Medication</h4>
                </div>
                <div class="card-body">
                  <div class="table-responsive">
                    <table
                      id="datatable"
                      class="display table table-striped table-hover"
                    >
                      <thead>
                        <tr>
                          <th>Name</th>
                          <th>Sex</th>
                          <th>Location</th>
                          <th>Phone</th>
                              <th>Amount</th>
<th>D.O.B</th>
                          <th>Date Registered</th>
                          <th>Status</th>
                        </tr>
                      </thead>
                      <tfoot>
                        <tr>
                          <th>Name</th>
 <th>Sex</th>
 <th>Location</th>
 <th>Phone</th>
                              <th>Amount</th>
                              <th>D.O.B</th>
 <th>Date Registered</th>
 <th>Status</th>
                        </tr>
                      </tfoot>
             <tbody></tbody>
                    </table>
                  </div>
                </div>
              </div>
            </div>

      
          </div>

              <script src="assets/js/plugin/datatables/datatables.min.js"></script>
<script src="Scripts/jquery-3.4.1.min.js"></script>

    <script>


        $(document).ready(function () {
            var reader = new FileReader();
            var fileName;
            var contentType;

            $('[id*=FileUpload1]').change(function () {
                if (typeof (FileReader) != "undefined") {
                    var input = this;

                    reader.onload = function (e) {
                        $('#selectedImage22').attr('src', e.target.result);
                    }
                    reader.readAsDataURL(input.files[0]);

                    var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.jpg|.jpeg|.gif|.png|.bmp)$/;
                    $($(this)[0].files).each(function () {
                        var file = $(this);

                        if (regex.test(file[0].name.toLowerCase())) {
                            fileName = file[0].name;
                            contentType = file[0].type;
                            reader.readAsDataURL(file[0]);
                        } else {
                            alert(file[0].name + " is not a valid image file.");
                            return false;
                        }
                    });
                } else {
                    alert("This browser does not support HTML5 FileReader.");
                }
            });


        });















        // Delegate click events for edit and delete buttons to the table
        $("#datatable").on("click", ".edit-btn", function (event) {
            event.preventDefault(); // Prevent default behavior
            var row = $(this).closest("tr");
            var prescid = $(this).data("id");





            $("#id11").val(prescid);



            // Show the modal
            $('#medmodal').modal('show');
        });


        $(document).ready(function () {






            var search = parseInt($("#label2").html());

            $.ajax({
                url: 'lab_waiting_list.aspx/pendlap',
                data: "{'search':'" + search + "'}",
                dataType: "json",
                type: 'POST',
                contentType: "application/json",
                success: function (response) {
                    console.log(response);

                    $("#datatable tbody").empty();

                    for (var i = 0; i < response.d.length; i++) {
                        $("#datatable tbody").append(
                            "<tr style='cursor:pointer' onclick='passValue(this)'>"
                            + "<td style='display:none'>" + response.d[i].doctorid + "</td>"
                            + "<td>" + response.d[i].full_name + "</td>"
                            + "<td>" + response.d[i].sex + "</td>"
                            + "<td>" + response.d[i].location + "</td>"
                            + "<td>" + response.d[i].phone + "</td>"
                            + "<td>" + response.d[i].amount + "</td>"
                            + "<td>" + response.d[i].dob + "</td>"
                            + "<td>" + response.d[i].date_registered + "</td>"
                            + "<td style='display:none'>" + response.d[i].prescid + "</td>"
                            + "<td><button style='background-color:red; curser:off;   color:white; border:none; padding:5px 10px;  border-radius:30%;' disabled>" + response.d[i].status + "</button></td>"
                            + "<td><button class='edit-btn btn btn-success' data-id='" + response.d[i].prescid + "'>Take Test</button></td>"

                            + "</tr>"
                        );
                    }




                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        });



    </script>
</asp:Content>
