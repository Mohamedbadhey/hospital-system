<%@ Page Title="" Language="C#" MasterPageFile="~/doctor.Master" AutoEventWireup="true" CodeBehind="xray_processed.aspx.cs" Inherits="juba_hospital.xray_processed" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- Modal -->
<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog modal-fullscreen">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="staticBackdropLabel">Modal title</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
            <input style="display:none" id="id11" />
                <h1>Assign Medication</h1>
          <div class="row justify-content-between">
              <div class="col-4">
                     <div class="mb-3">
       <label for="name" class="form-label">Medication Name</label>
       <input type="text" class="form-control" id="name" placeholder="Enter Name">
       <small id="nameError" class="text-danger"></small>
   </div>

   <div class="mb-3">
       <label for="dosage" class="form-label">Dosage</label>
       <input type="text" class="form-control" id="dosage" placeholder="Enter Dosage">
       <small id="dosageError" class="text-danger"></small>
   </div>

   <div class="mb-3">
       <label for="frequency" class="form-label">Frequency</label>
       <input type="text" class="form-control" id="frequency" placeholder="Enter Frequency">
       <small id="frequencyError" class="text-danger"></small>
   </div>

   <div class="mb-3">
       <label for="duration" class="form-label">Duration</label>
       <input type="text" class="form-control" id="duration" placeholder="Enter Duration">
       <small id="durationError" class="text-danger"></small>
   </div>

   <div class="mb-3">
       <label for="inst" class="form-label">Special Instruction</label>
       <textarea class="form-control" id="inst" rows="3"></textarea>
       <small id="instError" class="text-danger"></small>
   </div>
              </div>
              
              <div class="col-4">
        <h1>Lab Test Results</h1>
        <img src="assets/img/lab.png" alt="Lab Test Results"/>
    </div>
    <div class="col-4">
        <h1>X-ray Results</h1>
        <img src="assets/img/lab.png" alt="X-ray Results"/>
    </div>
          </div>

 
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Understood</button>
      </div>
    </div>
  </div>
</div>
        
    
    <label id="label2">1</label>
    <!-- Modal -->
<div class="modal fade" id="medmodal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="staticBackdropLabel1">Add Medication </h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
<div class="modal-body">
<%--    <input style="display:none" id="id11" />

    <div class="mb-3">
        <label for="name" class="form-label">Medication Name</label>
        <input type="text" class="form-control" id="name" placeholder="Enter Name">
        <small id="nameError" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="dosage" class="form-label">Dosage</label>
        <input type="text" class="form-control" id="dosage" placeholder="Enter Dosage">
        <small id="dosageError" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="frequency" class="form-label">Frequency</label>
        <input type="text" class="form-control" id="frequency" placeholder="Enter Frequency">
        <small id="frequencyError" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="duration" class="form-label">Duration</label>
        <input type="text" class="form-control" id="duration" placeholder="Enter Duration">
        <small id="durationError" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="inst" class="form-label">Special Instruction</label>
        <textarea class="form-control" id="inst" rows="3"></textarea>
        <small id="instError" class="text-danger"></small>
    </div>--%>
</div>





      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" onclick="updateinfo()" class="btn btn-primary">Update</button>
      </div>
    </div>
  </div>
</div>
       <div class="row">
              <div class="col-md-12">
                <div class="card">
                  <div class="card-header">
                    <h4 class="card-title">X-ray Test Results Patients</h4>
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






            var search = parseInt($("#label2").html());

            $.ajax({
                url: 'xray_processed.aspx/xrayprocess',
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
                            + "<td><button style='background-color:red; curser:off;   color:white; border:none; padding:5px 10px;  border-radius:30%;' disabled>" + response.d[i].status + "</button></td>"
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
