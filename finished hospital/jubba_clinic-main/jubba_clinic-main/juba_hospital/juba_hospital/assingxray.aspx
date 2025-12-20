<%@ Page Title="" Language="C#" MasterPageFile="~/doctor.Master" AutoEventWireup="true" CodeBehind="assingxray.aspx.cs" Inherits="juba_hospital.assingxray" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .hidden {
            display: none;
        }


    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">




    <!-- Modal -->
<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="staticBackdropLabel1">Lab Tests</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
            <input style="display:none" id="id111" />
          <div class="row">

         
                  
             
       
              <div class="col-12"> 
                  <h1>X-ray Details</h1>
       <div class="form-check form-switch">
        <input class="form-check-input" type="checkbox" id="radio" required>
        <label class="form-check-label" for="radio">Show X-Ray Details</label>
    </div>

    <div class="mb-3 hidden" id="xrayDetails">
        <label for="name" class="form-label">X-Ray Name</label>
        <input type="text" class="form-control" id="xrayname" placeholder="Enter X-Ray name" required>
        <small id="xrayerror" class="text-danger"></small>
    </div>
              
     <div class="mb-3 hidden" id="xraySpecial">
     <label for="inst" class="form-label">Special Instruction</label>
     <textarea class="form-control" id="inst" rows="3"></textarea>
     <small id="instError" class="text-danger"></small>
 </div>




              </div>
          </div>

 
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" id="submitButton" class="btn btn-primary">Submit</button>
      </div>
    </div>
  </div>
</div>
        
       <div class="row">
              <div class="col-md-12">
                <div class="card">
                  <div class="card-header">
                    <h4 class="card-title">Assign Lab Tests</h4>
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

   


    document.addEventListener('DOMContentLoaded', function () {
        const radio = document.getElementById('radio');
        const xrayDetails = document.getElementById('xrayDetails');
        const xraySpecial = document.getElementById('xraySpecial');

        function toggleXrayDetails() {
            if (radio.checked) {
                radio.value = "1";
                xrayDetails.classList.remove('hidden');
                xraySpecial.classList.remove('hidden');
            } else {
                radio.value = "0";
                xrayDetails.classList.add('hidden');
                xraySpecial.classList.add('hidden');
            }
        }

        radio.addEventListener('change', toggleXrayDetails);

        function callxray() {
            if (!radio.checked) {
                alert("Please ensure radio");
                return;
            }

            const xrname = document.getElementById('xrayname').value;
            const xrydescribtion = document.getElementById('inst').value;

            var id = parseInt($("#label2").html());



    $.ajax({
        url: 'assingxray.aspx/submitxray',
        data: "{'xrname':'" + xrname + "','xrydescribtion':'" + xrydescribtion + "','id':'" + id + "'}",
        contentType: 'application/json; charset=utf-8',
       dataType: 'json',
        type: 'POST',
        success: function (response) {
            console.log(response);
            if (response.d === 'true') {
                Swal.fire(
                    'Successfully Saved!',
                    'You added a new Patient!',
                    'success'
                );
                // Uncheck radio2 and other checkboxes
                radio.checked = false;
                xrayDetails.classList.add('hidden');
                xraySpecial.classList.add('hidden');
                // Uncheck all checkboxes with the class 'custom-checkbox'
               
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
  

        radio.addEventListener('change', toggleXrayDetails);
    submitButton.addEventListener('click', function (event) {
        event.preventDefault(); // Prevent form submission if inside a form
        callxray();
    });

        toggleXrayDetails();

});














    //document.addEventListener('DOMContentLoaded', function () {
    //    const radio2 = document.getElementById('radio2');
    //    const additionalTests = document.getElementById('additionalTests');

    //    function toggleAdditionalTests() {
    //        if (radio2.checked) {
    //            radio2.value = "1";


           

    //            additionalTests.classList.remove('hidden');
    //        } else {
    //            radio2.value = "0";
    //            additionalTests.classList.add('hidden');
    //        }
    //    }

    //    radio2.addEventListener('change', toggleAdditionalTests);

    //    // Initially set the controls to hidden and value to 0
    //    toggleAdditionalTests();
    //});
    document.addEventListener('DOMContentLoaded', function () {
        const radio = document.getElementById('radio');
        const xrayDetails = document.getElementById('xrayDetails');
        const xraySpecial = document.getElementById('xraySpecial');

        function toggleXrayDetails() {
            if (radio.checked) {
                radio.value = "1";
                xrayDetails.classList.remove('hidden');
                xraySpecial.classList.remove('hidden');
            } else {
                radio.value = "0";
                xrayDetails.classList.add('hidden');
                xraySpecial.classList.add('hidden');
            }
        }

        radio.addEventListener('change', toggleXrayDetails);

        // Initially set the controls to hidden and value to 0
        toggleXrayDetails();
    });




 








    function updateinfp() {
 

        // Get the form values
        var id = $("#radio2").val();
        var radio = $("#radio").val();
        
      

            $.ajax({
                url: 'assingxray.aspx/updatepatient',
                data: "{ 'id':'" + id + "' }",
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                type: 'POST',
                success: function (response) {
                    console.log(response);
                    $("#staticBackdrop").modal("hide");
                    Swal.fire(
                        'Successfully Updated !',
                        'You updated a new Patient!',
                        'success'
                    )
                    datadisplay();
             
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
      
     

    }

    // Delegate click events for edit and delete buttons to the table
    $("#datatable").on("click", ".edit-btn", function (event) {
        event.preventDefault(); // Prevent default behavior
        var row = $(this).closest("tr");
        var prescid = $(this).data("id");


  

   
    
       
        $("#id111").val(prescid);


   
        // Show the modal
        $('#staticBackdrop').modal('show');
    });


    $(document).ready(function () {
   
     


          

        var search = parseInt($("#label2").html());
  
            $.ajax({
                url: 'waitingpatients.aspx/patientwait',
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
                            + "<td><button class='edit-btn btn btn-success' data-id='" + response.d[i].prescid + "'>Send To Lab</button></td>"

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
