<%@ Page Title="" Language="C#" MasterPageFile="~/xray.Master" AutoEventWireup="true" CodeBehind="take_xray.aspx.cs" Inherits="juba_hospital.take_xray" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

            <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/2.0.8/css/dataTables.dataTables.min.css">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/buttons/2.2.3/css/buttons.dataTables.min.css">
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
         font-size: 19px;
   font-weight:bold;
    }

    #datatable th,
    #datatable td {
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


    /* Custom hover styles for pagination buttons */
    .dataTables_wrapper .dataTables_paginate .paginate_button {
        padding: 0.5em 1em;
        margin-left: 0.5em;
        color: #007bff;
        background-color: white;
        border: 1px solid #ddd;
    }


    .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
        color: white;
        background-color: #007bff;
        border: 1px solid #007bff;
        cursor: pointer;
    }


    .dataTables_wrapper .dataTables_paginate .paginate_button.current {
        color: white;
        background-color: #007bff;
        border: 1px solid #007bff;
    }

</style>
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
    <div class="row">
              <div class="col-5">
   
    <h1>Upload Lab Image</h1>
           
     <input type="file" id="FileUpload1" accept="image/*">

 <img id="selectedImage22" src="" alt="Selected Image" />
</div>
        
    <div class="col-7">
                  <button class="btn btn-success" id="editpic1" onclick="editpic()"> edit Pic</button>
         <h1>Patient Details</h1>
             <div class="table-responsive">
                         <table id="datatable11" class="display table table-striped table-hover">
  <thead>
    <tr>
            <th> Type</th>
      <th> Name</th>
      <th>describtion</th>
   

    </tr>
  </thead>
  <tbody>
    <!-- Table rows will be dynamically added here -->
  </tbody>
</table>
                 </div>
    
   
    </div>
    </div>


    

  

</div>





      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" id="btnSave" class="btn btn-primary">Submit</button>
      </div>
    </div>
  </div>
</div>






    <div class="modal fade" id="medmodal1" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="staticBackdropLabel11">Upload Lab Image Test </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
<div class="modal-body">
    <input style="display:none" id="id111" />
    <div class="row">
              <div class="col-5">
            
                
    <h1>Upload New Image</h1>
     <input type="file" id="FileUpload11" accept="image/*">

 <img id="selectedImage221" src="" alt="Selected Image" />
</div>
        
    <div class="col-7">
             
         <h1>Old Image</h1>
           <img src="" id="img1" />
   
    </div>
    </div>


    

  

</div>





      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" id="btnupdate" class="btn btn-primary">Submit</button>
      </div>
    </div>
  </div>
</div>

      
             <div class="row">
            <div class="col-md-12">
              <div class="card">
                <div class="card-header">
                  <h4 class="card-title">Assign Image</h4>
                </div>
                <div class="card-body">
                  <div class="table-responsive">
                    <table class="display nowrap" style="width:100%" 
                      id="datatable">
                      <thead>
                        <tr>
                          <th>Name</th>
                          <th>Sex</th>
                          <th>Location</th>
                          <th>Phone</th>
                              <th>Amount</th>
<th>D.O.B</th>
                          <th>Date Registered</th>
                                  <th>Doctor Title</th>
<th>Status</th>
                            <th>operation</th>  </tr>
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
                             <th>Doctor Title</th>
 <th>Status</th>
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
    <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.2.3/js/dataTables.buttons.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.2.3/js/buttons.html5.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.70/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.70/vfs_fonts.js"></script>

    <script>
        //$(document).ready(function () {
        //    // Initialize DataTable
        //    var table = $('#datatable').DataTable({
        //        dom: 'Bfrtip',
        //        buttons: ['excelHtml5'],
        //        paging: true,
        //        pageLength: 10,
        //        lengthMenu: [10, 25, 50, 100],
        //        responsive: true
        //    });

        //});

        $(document).ready(function () {
            var reader = new FileReader();
            var fileName;
            var contentType;

            $('[id*=FileUpload1]').change(function () {
                if (typeof (FileReader) != "undefined") {
                    var input = this;
                    if (input.files.length > 0) {
                        var file = input.files[0];

                        var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.jpg|.jpeg|.gif|.png|.bmp)$/;
                        if (regex.test(file.name.toLowerCase())) {
                            fileName = file.name;
                            contentType = file.type;

                            reader.onload = function (e) {
                                $('#selectedImage22').attr('src', e.target.result);
                            }

                            reader.readAsDataURL(file);
                        } else {
                            alert(file.name + " is not a valid image file.");
                        }
                    }
                } else {
                    alert("This browser does not support HTML5 FileReader.");
                }
            });

            $("[id*=btnSave]").click(function () {
                var prescid = $("#id11").val();

                
                var im = $("#FileUpload1").val();
           

                if (!im) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'No Image Selected',
                        text: 'Please select an image before saving.'
                    });
                    return false; // Prevent further execution
                }

                var byteData = reader.result.split(';')[1].replace("base64,", "");

                var obj = {
                    Data: byteData,
                    Name: fileName,
                    ContentType: contentType,
                    PrescID: prescid, // Add the prescid to the object
                 
                };

                $.ajax({
                    type: "POST",
                    url: "take_xray.aspx/SaveImage",
                    data: JSON.stringify({ data: obj }), // Update the data field to include the prescid
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                        // Clear the file input
                        $("#FileUpload1").val(''); // Replace #fileInput with the actual ID of your file input element
                        // Optionally, reset reader.result to ensure it doesn't hold old data
                        reader.result = null;

                        Swal.fire({
                            icon: 'success',
                            title: 'Success',
                            text: r.d
                        });
                    },
                    error: function (r) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: r.responseText
                        });
                        console.log(r.responseText);
                    },
                    failure: function (r) {
                        alert(r.responseText);
                        console.log(r);
                    }
                });
                return false;
            });
        });

        function editpic() {
            var prescid = $("#id11").val();
           
         
            event.preventDefault();
            $.ajax({
                url: 'assignmed.aspx/xryimage',
                data: JSON.stringify({ 'prescid': prescid }),
                dataType: "json",
                type: 'POST',
                contentType: "application/json",
                success: function (response) {
                    console.log(response);
                    // Show the modal
                    if (response.d && response.d.length > 0) {
                        var base64Data = response.d[0].image; // Assuming imageData is base64-encoded

                        // Update image source directly
                        $("#img1").attr('src', 'data:image/jpeg;base64,' + base64Data);
                    } else {
                        console.log("No image data found for the given prescid.");
                        // Optionally handle the case where no image data is returned
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Error fetching image data:", error);
                    // Handle errors more gracefully, e.g., display an error message to the user
                }
            });
            $('#medmodal1').modal('show');

            var reader = new FileReader();
            var fileName;
            var contentType;

            $('[id*=FileUpload11]').change(function () {
                if (typeof (FileReader) != "undefined") {
                    var input = this;
                    if (input.files.length > 0) {
                        var file = input.files[0];

                        var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.jpg|.jpeg|.gif|.png|.bmp)$/;
                        if (regex.test(file.name.toLowerCase())) {
                            fileName = file.name;
                            contentType = file.type;

                            reader.onload = function (e) {
                                $('#selectedImage221').attr('src', e.target.result);
                            }

                            reader.readAsDataURL(file);
                        } else {
                            alert(file.name + " is not a valid image file.");
                        }
                    }
                } else {
                    alert("This browser does not support HTML5 FileReader.");
                }
            });
            $("[id*=btnupdate]").click(function () {
                var id = $("#id111").val(); // Fetch book ID from the span
     
                // Check if a file is selected and create a FileReader to read the file
                var fileInput = document.getElementById('FileUpload11'); // Replace 'fileInput' with your actual file input ID
    
          
             
                var file = fileInput.files[0];
                var byteData = "";
                var fileName = file ? file.name : "";

                if (file) {
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        byteData = e.target.result.split(';base64,')[1];

                        // Create a JSON object
                        var jsonData = {
                            id: id, // Include the book ID in the data
                            Data: byteData,
                            Name: fileName,
               
                        };

                        // Send data to server using AJAX
                        $.ajax({
                            type: "POST",
                            url: "take_xray.aspx/UpdateBook", // Change the URL to your update endpoint
                            data: JSON.stringify({ data1: jsonData }),
                            contentType: "application/json; charset=utf-8",
                            dataType: "json",
                            success: function (r) {
                                console.log(r.d);
                                // Clear the file input
                                $("#FileUpload11").val(''); // Replace #fileInput with the actual ID of your file input element
                                // Optionally, reset reader.result to ensure it doesn't hold old data
                                reader.result = null;

                                Swal.fire({
                                    icon: 'success',
                                    title: 'Success',
                                    text: r.d
                                });
                            },
                            error: function (r) {
                                alert(r.responseText);
                            },
                            failure: function (r) {
                                alert(r.responseText);
                            }
                        });
                    };
                    reader.readAsDataURL(file);
                } else {
                    Swal.fire({
                        icon: 'warning',
                        title: 'No Image Selected',
                        text: 'Please select an image before saving.'
                    });

                }

                return false;
            });
    
        }








        // Delegate click events for edit and delete buttons to the table
        $("#datatable").on("click", ".edit-btn", function (event) {
            event.preventDefault(); // Prevent default behavior
            var row = $(this).closest("tr");
            var prescid = $(this).data("id");

            var xryid = row.find("td:nth-child(2)").text();
            var xrystatus = row.find("td:nth-child(12)").text();
        
            $("#id111").val(xryid);
           

            $("#id11").val(prescid);
     
            

            if (xrystatus === 'pending_image') {
           
                document.getElementById('editpic1').disabled = true;
            
            } else   if (xrystatus === 'image_processed') {
                document.getElementById('editpic1').disabled = false;
                document.getElementById('btnSave').disabled = true;
             
            } 







            $.ajax({
                url: 'take_xray.aspx/xrayresults',
                data: "{'prescid':'" + prescid + "'}",
                dataType: "json",
                type: 'POST',
                contentType: "application/json",
                success: function (response) {
                    console.log(response);

                    $("#datatable11 tbody").empty();

                    for (var i = 0; i < response.d.length; i++) {
                        $("#datatable11 tbody").append(
                            "<tr style='cursor:pointer' onclick='passValue(this)'>"
                            + "<td>" + response.d[i].type + "</td>"
                            + "<td>" + response.d[i].xryname + "</td>"
                            + "<td>" + response.d[i].xrydescribtion + "</td>"
              
                  

                            + "</tr>"
                        );
                    }




                },
                error: function (response) {
                    alert(response.responseText);
                }
            });

            // Show the modal
            $('#medmodal').modal('show');
        });


        $(document).ready(function () {






            var search = parseInt($("#label2").html());

            $.ajax({
                url: 'take_xray.aspx/pendlap',
                data: "{'search':'" + search + "'}",
                dataType: "json",
                type: 'POST',
                contentType: "application/json",
                success: function (response) {
                    console.log(response);

                    $("#datatable tbody").empty();
                    // Function to determine button style based on status
                    function getStatusButton(status) {
                        var color;
                        switch (status) {
                            case 'waiting':
                                color = 'red';
                                break;
                            case 'pending-lap':
                                color = 'orange';
                                break;
                            case 'lap_processed':
                                color = 'green';
                                break;
                            case 'pending_image':
                                color = 'orange';
                                break;
                            case 'image_processed':
                                color = 'green';
                                break;
                            default:
                                color = 'initial';
                        }
                        return "<button style='background-color:" + color + "; cursor:default; color:white; border:none; padding:5px 10px; border-radius:30%;' disabled>" + status + "</button>";
                    }

                    for (var i = 0; i < response.d.length; i++) {
                        var statusButton = getStatusButton(response.d[i].status);
                        var xrayStatusButton = getStatusButton(response.d[i].xray_status);
                        $("#datatable tbody").append(
                            "<tr style='cursor:pointer' onclick='passValue(this)'>"
                            + "<td style='display:none'>" + response.d[i].doctorid + "</td>"
                            + "<td style='display:none'>" + response.d[i].xray_result_id + "</td>"
                            + "<td>" + response.d[i].full_name + "</td>"
                            + "<td>" + response.d[i].sex + "</td>"
                            + "<td>" + response.d[i].location + "</td>"
                            + "<td>" + response.d[i].phone + "</td>"
                            + "<td>" + response.d[i].amount + "</td>"
                            + "<td>" + response.d[i].dob + "</td>"
                            + "<td>" + response.d[i].date_registered + "</td>"
                            + "<td>" + response.d[i].doctortitle + "</td>"
                            
                            + "<td style='display:none'>" + response.d[i].prescid + "</td>"
                           + "<td>" + statusButton + "</td>" 
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
