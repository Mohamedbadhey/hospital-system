<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="delete_xray_images.aspx.cs" Inherits="juba_hospital.delete_xray_images" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .xray-image {
            width: 100px; /* Set the desired width */
            height: auto; /* Maintain the aspect ratio */
        }

    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    
         <div class="row">
             <div class="col-3">
                              <select class="form-control" id="weeks">
    <option value="0"> Please Select a Week</option>
     
                    <option value="2"> 2 weeks</option>
                    <option value="5"> 5 weeks</option>
                    <option value="6"> 6 weeks</option>
                   
</select>
             </div>
   <br />
             <input  id="btn" style="display:none"/>
             <button  type="button"  id="delete" style="display:none" onclick="deletejob()" class ="btn btn-danger"> Delete </button>
            <div class="col-md-12">
              <div class="card">
                <div class="card-header">
                  <h4 class="card-title">Delete Xray Info</h4>
                </div>
                <div class="card-body">
          <div id="imageContainer"></div>

                </div>
              </div>
            </div>

      
          </div>

          <script src="assets/js/plugin/datatables/datatables.min.js"></script>
<script src="Scripts/jquery-3.4.1.min.js"></script>

    <script>




        function deletejob() {

            var id = $("#btn").val();
            $.ajax({
                type: "POST",
                url: "delete_xray_images.aspx/deleteJob",
                data: JSON.stringify({ id: id }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    $('#medmodal1').modal('hide');
                    if (response.d === 'true') {
                        Swal.fire(
                            'Successfully updated !',
                            'You Added a new job title!',
                            'success'
                        )

                        datadisplay();
                    } else {
                        // Handle errors in the response
                        Swal.fire({
                            icon: 'error',
                            title: 'Data Insertion Failed',
                            text: 'There was an error while inserting the data.',
                        });
                    }
                },
                error: function (xhr, status, error) {
                    alert("Error: " + xhr.responseText);
                }
            });

        }


















        $(document).ready(function () {
            // When the first dropdown changes
            $('#weeks').change(function () {
                var prescid = $(this).val();
                $("#btn").val(prescid);

                
                $.ajax({
                    url: 'delete_xray_images.aspx/xryimage1',
                    data: JSON.stringify({ 'prescid': prescid }),
                    dataType: "json",
                    type: 'POST',
                    contentType: "application/json",
                    success: function (response) {
                        console.log(response);

                        if (response.d && response.d.length > 0) {
                            var tableHtml = '<table class="table table-bordered"><thead><tr><th>Image</th></tr></thead><tbody>';

                            response.d.forEach(function (item) {
                                var base64Data = item.image; // Assuming imageData is base64-encoded
                                tableHtml += '<tr><td><img src="data:image/jpeg;base64,' + base64Data + '" alt="X-ray Image" class="xray-image img-thumbnail" /></td></tr>';
                            });

                            tableHtml += '</tbody></table>';
                            $("#imageContainer").html(tableHtml); // Assuming there is a div with id="imageContainer" to hold the table
                        } else {
                            console.log("No image data found for the given prescid.");
                            // Optionally handle the case where no image data is returned
                            $("#imageContainer").html('<p>No image data found.</p>');
                        }
                        // Show the delete button
                        $('#delete').show();
                    },
                    error: function (xhr, status, error) {
                        console.error("Error fetching image data:", error);
                        // Handle errors more gracefully, e.g., display an error message to the user
                        $("#imageContainer").html('<p>Error fetching image data.</p>');
                    }
                });


            });
        });





        // Delegate click events for edit and delete buttons to the table
        $("#datatable").on("click", ".edit-btn", function (event) {
            event.preventDefault(); // Prevent default behavior
            var row = $(this).closest("tr");
            var prescid = $(this).data("id");





            $("#id11").val(prescid);



            // Show the modal
            $('#staticBackdrop').modal('show');
        });



        $(document).ready(function () {


            $.ajax({
                url: 'delete_xray_images.aspx/xryimage',
                dataType: "json",
                type: 'POST',
                contentType: "application/json",
                success: function (response) {
                    console.log(response);

                    if (response.d && response.d.length > 0) {
                        var tableHtml = '<table class="table table-bordered"><thead><tr><th>Image</th></tr></thead><tbody>';

                        response.d.forEach(function (item) {
                            var base64Data = item.image; // Assuming imageData is base64-encoded
                            tableHtml += '<tr><td><img src="data:image/jpeg;base64,' + base64Data + '" alt="X-ray Image" class="xray-image img-thumbnail" /></td></tr>';
                        });

                        tableHtml += '</tbody></table>';
                        $("#imageContainer").html(tableHtml); // Assuming there is a div with id="imageContainer" to hold the table
                    } else {
                        console.log("No image data found for the given prescid.");
                        // Optionally handle the case where no image data is returned
                        $("#imageContainer").html('<p>No image data found.</p>');
                    }
                },
                error: function (xhr, status, error) {
                    console.error("Error fetching image data:", error);
                    // Handle errors more gracefully, e.g., display an error message to the user
                    $("#imageContainer").html('<p>Error fetching image data.</p>');
                }
            });

        });



    </script>
</asp:Content>
