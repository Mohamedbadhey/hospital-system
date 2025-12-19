<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="delete_xray.aspx.cs" Inherits="juba_hospital.delete_xray" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
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
                  <h4 class="card-title">Delete image Info</h4>
                </div>
                <div class="card-body">
                  <div class="table-responsive">
                    <table
                      id="datatable11"
                      class="display table table-striped table-hover"
                    >
                      <thead>
                        <tr>
                                           <th> ID</th>
                                             <th> Type</th>
                                     <th> Name</th>
        <th>Describtion</th>


                        </tr>
                      </thead>
                      <tfoot>
                        <tr>
                                              <th> ID</th>
                              <th> Type</th>
                             <th> Name</th>
<th>Describtion</th>
                            <th>Date Taken</th>
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
            $("#datatable11").DataTable({});
        });



        function deletejob() {

            var id = $("#btn").val();
            $.ajax({
                type: "POST",
                url: "delete_xray.aspx/deleteJob",
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
                var search = $(this).val();
                $("#btn").val(search);

                
             
                $.ajax({
                    url: 'delete_xray.aspx/medicdata1',
                    data: "{  'search':'" + search + "'  }",
                    dataType: "json",
                    type: 'POST',
                    contentType: "application/json",
                    success: function (response) {
                        console.log(response);

                        $("#datatable11 tbody").empty();

                        for (var i = 0; i < response.d.length; i++) {
                            $("#datatable11 tbody").append(
                                "<tr>"


                                + "<td>" + response.d[i].xrayid + "</td>"
                                + "<td>" + response.d[i].type + "</td>"
                                + "<td>" + response.d[i].xryname + "</td>"
                                + "<td>" + response.d[i].xrydescribtion + "</td>"
                                + "<td>" + response.d[i].date_taken + "</td>"





                                + "</tr>"
                            );
                        }


                        // Show the delete button
                        $('#delete').show();

                    },
                    error: function (response) {
                        alert(response.responseText);
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
                url: 'delete_xray.aspx/medicdata',
                data: "{}",
                dataType: "json",
                type: 'POST',
                contentType: "application/json",
                success: function (response) {
                    console.log(response);

                    $("#datatable11 tbody").empty();

                    for (var i = 0; i < response.d.length; i++) {
                        $("#datatable11 tbody").append(
                            "<tr>"

                            + "<td>" + response.d[i].xrayid + "</td>"
                            + "<td>" + response.d[i].xryname + "</td>"
                            + "<td>" + response.d[i].xrydescribtion + "</td>"
                            + "<td>" + response.d[i].date_taken + "</td>"


             


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
