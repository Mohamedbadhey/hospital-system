<%@ Page Title="" Language="C#" MasterPageFile="~/doctor.Master" AutoEventWireup="true" CodeBehind="medication_report.aspx.cs" Inherits="juba_hospital.medication_report" %>
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

<style>
body, html {
  height: 100%;
  margin: 0;
  font-size: 16px; /* Base font size */
}

.report-content {
  display: flex;
  flex-direction: column;
  height: 100%;
  border: 3px solid black;
  box-shadow: 10px 10px 10px #888888;
  margin: 5px;
  font-size: 1rem; /* Base font size for screen display */
}

.report-header {
  border: 0px solid black;
  height: 150px;
  width: 100%; /* Ensure the div takes the full width of its container */
  overflow: hidden; /* Ensures the image doesn't overflow the div */
  display: flex; /* Center the image horizontally */
  justify-content: center;
  align-items: center; /* Center the image vertically */
}

.report-header img {
  max-height: 100%;
  width: auto; /* Maintain aspect ratio */
}


.patient-details hr {
  border: 1px solid black;
}

.report-body {
  flex: 1; /* Grow to fill available space */
  border: 0px solid black;
  font-size: 16px;
  overflow: auto; /* Allow scrolling if content overflows */
  padding: 0; /* Remove padding to make full use of the space */
  display: flex;
  justify-content: center;
  align-items: center;
}

table {
  width: 100%;
  max-height: 100%;
  border-collapse: collapse;
  table-layout: auto; /* Allows the table to adjust column widths */
}

th, td {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px; /* Adjust padding for better fit */
  box-sizing: border-box; /* Include border and padding in the element's width and height */
}

th {
  background-color: #f2f2f2;
  text-transform: uppercase; /* Ensure headers are uppercase */
}

.report-sign {
  border: 0px solid black;
  height: 100px;
  margin: 30px 30px;
  margin-top: auto; /* Push to bottom */
}

img {
  height: 100%;
  width: 100%;
}

.lab-doctor-sign {
  float: right;
}

.report-sign img {
  height: 50px;
  width: 100px;
  display: inline-block;
}

.lab-incharge-sign {
  display: inline-block;
}

.align-left {
  text-align: left;
  padding: 10px;
}

/* Print styles */
@media print {
  body * {
    visibility: hidden;
  }
  .report-content, .report-content * {
    visibility: visible;
  }
  .report-content {
    position: relative; /* Normal flow for printing */
    width: 100%;
    overflow: visible;
    font-size: 1.5rem; /* Increase font size for print */
  }
  .report-body {
    margin-top: 1rem; /* Margin to separate from header */
    overflow: visible;
  }
  table {
    width: 100%;
    margin-bottom: 1rem; /* Add space between tables */
  }
  th, td {
    padding: 1rem; /* Padding for readability */
  }
  .report-sign {
  border: 0px solid black;
  height: 100px;
  margin: 30px 30px;
  margin-top: auto; /* Push to bottom */
}
.report-header {
  border: 0px solid black;
  height: 150px;
  width: 100%; /* Ensure the div takes the full width of its container */
  overflow: hidden; /* Ensures the image doesn't overflow the div */
  display: flex; /* Center the image horizontally */
  justify-content: center;
  align-items: center; /* Center the image vertically */
}

.report-header img {
  max-height: 100%;
  width: auto; /* Maintain aspect ratio */
}

  #print-button {
    display: none; /* Hide print button when printing */
  }
}

</style>
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
                <h1> Medication Report</h1>
          <div class="row">
      
              
              <div class="col-12">
   
       
             <div class="report-content">
  <div class="report-header">
      <img src="assets/zfsdfg.png" />
  </div>
  <div class="patient-details ">
    <hr>
    <table border="0">
      <tr>
        <td>Patient Name:  <span class="h5" id="ptname"></span></td>
        <td class="align-left">Referred By:</td>
      </tr>
      <tr>
        <td>Sex: <span class="h5" id="sex"></span></td>
        <td class="align-left">Date: <span id="date" class="h5"></span></td>
      </tr>
      <tr>
        <td>Age: <span class="h5" id="DOB"></span>years</td>
        <td class="align-left">Doctor: <span class="h5" id="doctor"></span> </td>
      </tr>
            <tr>
      <td>Phone:  <span class="h5" id="phone"></span></td>
      <td class="align-left">Location:  <span class="h5" id="location"></span></td>
    </tr>
    </table>
    <hr>
  </div>
  <div class="report-body p-0">
    <table id="datatable1" class="patient-details  table-bordered">
      <thead>
        <tr>
          <th>Medication Name</th>
          <th>Dosage</th>
              <th>Frequency</th>
  <th>Duration</th>
              <th>Special Instrcution</th>

        </tr>
      </thead>
      <tbody>
        <!-- Table rows will be dynamically added here -->
      </tbody>
    </table>
  </div>
       <br />
                     <br />
                     <br />
                     <br />
                     <br />
                     <br />
                     <br />
                     <br />
<%--  <div class="report-sign">
    <div class="lab-incharge-sign">

      <figcaption>Mr. Sachin Sharma</figcaption>
    </div>
    <div class="lab-doctor-sign">
 
      <figcaption>Dr. A.K. Asthana</figcaption>
    </div>
  </div>--%>
</div>
<button id="print-button">Print Report</button>
    </div>

          </div>

 
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        <button type="button" onclick="submitInfo()" class ="btn btn-primary">Submit</button>
      </div>
    </div>
  </div>
</div>
        
    
  
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
        <button type="button" onclick="submitInfo()" class="btn btn-primary">Submot</button>
      </div>
    </div>
  </div>
</div>
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







    document.getElementById('print-button').addEventListener('click', function () {
        window.print();
    });
















    function submitInfo() {
        // Clear previous error messages
        document.getElementById('nameError').textContent = "";
        document.getElementById('dosageError').textContent = "";
        document.getElementById('frequencyError').textContent = "";
        document.getElementById('durationError').textContent = "";
        document.getElementById('instError').textContent = "";

        // Get the form values
        var prescid = $("#id11").val();
        var med_name = $("#name").val();
        var dosage = $("#dosage").val();
        var frequency = $("#frequency").val();
        var duration = $("#duration").val();
        var special_inst = $("#inst").val();

        // Validate the form values
        let isValid = true;

        if (med_name.trim() === "") {
            document.getElementById('nameError').textContent = "Please enter the medication name.";
            isValid = false;
        }

        if (dosage.trim() === "") {
            document.getElementById('dosageError').textContent = "Please enter the dosage.";
            isValid = false;
        }

        if (frequency.trim() === "") {
            document.getElementById('frequencyError').textContent = "Please enter the frequency.";
            isValid = false;
        }

        if (duration.trim() === "") {
            document.getElementById('durationError').textContent = "Please enter the duration.";
            isValid = false;
        }

        if (special_inst.trim() === "") {
            document.getElementById('instError').textContent = "Please enter the special instruction.";
            isValid = false;
        }



        // If all validations pass, proceed with AJAX call
        if (isValid) {

            $.ajax({
                url: 'assignmed.aspx/submitdata',
                data: "{ 'med_name':'" + med_name + "', 'dosage':'" + dosage + "', 'frequency':'" + frequency + "', 'duration':'" + duration + "', 'prescid':'" + prescid + "' , 'special_inst':'" + special_inst + "'  }",
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
            $("#dosage").val('');
            $("#inst").val('');
            $("#frequency").val('');
            $("#duration").val('');

        }
    }

    // Delegate click events for edit and delete buttons to the table
    $("#datatable").on("click", ".edit-btn", function (event) {
        event.preventDefault(); // Prevent default behavior
        var row = $(this).closest("tr");
        var prescid = $(this).data("id");


        var name = row.find("td:nth-child(2)").text(); // Assuming jobname is in the second column
        var gender = row.find("td:nth-child(3)").text();
        var name = row.find("td:nth-child(2)").text();
        var phone = row.find("td:nth-child(5)").text();
        var location = row.find("td:nth-child(4)").text();
        var sex = row.find("td:nth-child(3)").text();
        var dobText = row.find("td:nth-child(7)").text();

        var doctor = row.find("td:nth-child(9)").text();


        $("#doctor").text(doctor);
        // Parse the DOB into a Date object
        var dob = new Date(dobText);
        var today = new Date();

        // Calculate the age
        var age = today.getFullYear() - dob.getFullYear();
        var monthDiff = today.getMonth() - dob.getMonth();
        var dayDiff = today.getDate() - dob.getDate();

        // Adjust the age if the current date hasn't yet reached the birthday in the current year
        if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
            age--;
        }


        // Display the current date in the element with ID "date"
        var options = { year: 'numeric', month: 'long', day: 'numeric' };
        var formattedToday = today.toLocaleDateString('en-US', options);
        $("#date").text(formattedToday);
        // Display the age in the input field
        $("#DOB").text(age);


        $("#ptname").text(name);

        $("#phone").text(phone);
        $("#location").text(location);
        $("#sex").text(sex);
        $("#id11").val(prescid);




        $.ajax({
            url: 'medication_report.aspx/medicdata',
            data: "{'prescid':'" + prescid + "'}",
            dataType: "json",
            type: 'POST',
            contentType: "application/json",
            success: function (response) {
                console.log(response);

                $("#datatable1 tbody").empty();

                for (var i = 0; i < response.d.length; i++) {
                    $("#datatable1 tbody").append(
                        "<tr>"

                        + "<td>" + response.d[i].med_name + "</td>"
                        + "<td>" + response.d[i].dosage + "</td>"
                        + "<td>" + response.d[i].frequency + "</td>"
                        + "<td>" + response.d[i].duration + "</td>"
                        + "<td>" + response.d[i].special_inst + "</td>"


                        + "</tr>"
                    );
                }




            },
            error: function (response) {
                alert(response.responseText);
            }
        });


        // Show the modal
        $('#staticBackdrop').modal('show');
    });


    $(document).ready(function () {






        var search = parseInt($("#label2").html());

        $.ajax({
            url: 'assignmed.aspx/medic',
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
                        + "<td style='display:none'>" + response.d[i].doctortitle + "</td>"
                        + "<td style='display:none'>" + response.d[i].prescid + "</td>"
                        + "<td><button style='background-color:red; curser:off;   color:white; border:none; padding:5px 10px;  border-radius:30%;' disabled>" + response.d[i].status + "</button></td>"
                        + "<td><button class='edit-btn btn btn-success' data-id='" + response.d[i].prescid + "'>View Report</button></td>"

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

    <!-- Watermark -->
    <div class="print-watermark">
        <img src="assets/vafmadow.png" alt="Hospital Logo Watermark" />
    </div>

</asp:Content>
