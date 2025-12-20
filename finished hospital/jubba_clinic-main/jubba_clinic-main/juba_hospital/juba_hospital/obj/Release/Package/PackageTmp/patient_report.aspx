<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="patient_report.aspx.cs" Inherits="juba_hospital.patient_report" %>
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
        .ht{
            text-align:center;
        }
    </style>
<%--<%--<style>
  .report-content {
    border: 3px solid black;
    padding: 0;
    box-shadow: 10px 10px 10px #888888;
    margin: 5px;
    width: 100%;
  }

  .report-header {
    border: 0;
    height: 150px;
    width: 100%;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .report-header img {
    max-height: 100%;
    width: auto;
  }

  .patient-details hr {
    border: 1px solid black;
  }

  .report-body {
    border: 0;
    font-size: 16px;
    overflow: auto;
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    table-layout: auto;
  }

  th, td {
    border: 1px solid #dddddd;
    text-align: left;
    padding: 8px;
    box-sizing: border-box;
  }

  th {
    background-color: #f2f2f2;
    text-transform: uppercase;
  }

  .report-sign {
    border: 0;
    height: 100px;
    margin: 30px 30px;
  }

  .report-footer {
    border: 0;
    height: 150px;
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

  /* Global styles */
  body {
    font-size: 16px;
  }

  .report-content {
    width: 100%;
    padding: 1rem;
    font-size: 1rem;
  }

  @media print {
    @page {
      size: A4;
      margin: 10mm;
    }
    
    body * {
      visibility: hidden;
    }

    .report-content, .report-content * {
      visibility: visible;
    }

    .report-content {
      position: absolute;
      left: 0;
      top: 0;
      width: 100%;
      padding: 1rem;
      font-size: 1.2rem;
    }

    .report-body {
      margin-top: 1rem;
    }

    table {
      width: 100%;
      margin-bottom: 1rem;
    }

    th, td {
      padding: 0.5rem;
    }

    .report-header img, .report-sign img {
      display: block;
      width: 100%;
      max-width: 100%;
      height: auto;
    }

    #print-button1 {
      display: none;
    }
  }
</style>--%>

<%--<style>
    .report-content {
  border: 3px solid black;
  padding: 0px;
  box-shadow: 10px 10px 10px #888888;
  margin: 5px;
}

.report-header {
  border: 0px solid black;
  height: 100%;
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




.patient-details table {
        font-size: 12px; /* Adjust the font size */
    }
 .patient-details table td {
        padding: 2px 5px; /* Adjust the padding */
        margin: 0; /* Remove margins */
    }

.patient-details hr {
  border: 1px solid black;
}

.report-body {
  border: 0px solid black;
  height: 100%;
  font-size: 16px;
  overflow: auto; /* Allow scrolling if content overflows */
  padding: 0; /* Remove padding to make full use of the space */
  display: flex;
  justify-content: center;
  align-items: center;
}

table {
  width: 100%;
      margin: 0; /* Remove margins */
  max-height: 100%;
      
  border-collapse: collapse;
  table-layout: auto; /* Allows the table to adjust column widths */
/*   font-size: 5px;*/
}

th, td {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 2px; /* Adjust padding for better fit */
 /* Include border and padding in the element's width and height */
   font-size: 9px;
       margin: 0; /* Remove margins */
         padding: 0;
}

th {
  background-color: #f2f2f2;
  text-transform: uppercase; /* Ensure headers are uppercase */
}

.report-sign {
  border: 0px solid black;
  height: 100px;
  margin: 30px 30px;
}

.report-footer {
  border: 0px solid black;
  height: 150px;
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



/*@media print {
  body * {
    visibility: hidden;
  }
  .report-content, .report-content * {
    visibility: visible;
  }
  .report-content {
    position: relative;
    left: 0;
    top: 0;
    width: 100%;
    height: auto;
    margin: 0;
    padding: 0;
    border: none;
    box-shadow: none;
  }

  img {
    width: auto;
    max-width: 100%;

    height: auto;

  }
  .report-header , .report-sign img {
    width: auto;
    max-width: 100%;
    height: auto;
  }
  .report-body {
    height: auto;
    max-height: 100%;
    overflow: visible;
  }
  .col-4 {
    width: 100%;
  }
  #print-button {
    display: none;
  }
}*/



/* Global print styles */
/*@media print {
  body * {
    visibility: hidden;
  }
  .report-content, .report-content * {
    visibility: visible;
  }
  .report-content {
    position: relative;*/ /* Change to relative to allow normal flow */
    /*width: 100%;
    padding: 1rem;*/ /* Add padding for better appearance */
    /*font-size: 1.5rem;*/ /* Increase font size for all elements */
  /*}
  .report-header img, .report-sign img {
    display: block;
    width: 100%;
    max-width: 100%;
    height: auto;
  }
  .report-body {
    margin-top: 1rem;*/ /* Add margin-top to separate from header */
  /*}
  table {
    width: 100%;
    margin-bottom: 1rem;*/ /* Add some space between tables */
    /*font-size: 1.5rem;*/ /* Increase font size for tables */
  /*}
  th, td {
    padding: 1rem;*/ /* Increase padding for better readability */
  /*}
  #print-button {
    display: none;
  }
}*/







  /* Global styles */
body {
  font-size: 16px; /* Base font size */
}

.report-content {
  width: 100%; /* Full width */
  padding: 1rem; /* Add padding for spacing */
  font-size: 1rem; /* Base font size for screen display */
}

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
    padding: 1rem; /* Padding for better appearance */
    font-size: 1.5rem; /* Increase font size for print */
  }
  .report-body {
    margin-top: 1rem; /* Margin to separate from header */
  }
  table {
    width: 100%;
    margin-bottom: 1rem; /* Add space between tables */
  }
  th, td {
    padding: 1rem; /* Padding for readability */
  }
  .report-header img, .report-sign img {
    display: block;
    width: 100%;
    max-width: 100%;
    height: auto;
  }
  #print-button {
    display: none; /* Hide print button when printing */
  }
}

</style>--%>
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
               <input style="display:none" id="pid" />
                <h1>Patient Report</h1>
          <button class="btn btn-success" onclick="showmedic()"> show medication report</button>
          <div class="row justify-content-between">
     
              
              <div class="col-8">
                  
    <div class="form-check form-switch">
    <input class="form-check-input" type="checkbox" id="radio2" value="0" onchange="toggleRow()">
    <label class="form-check-label" for="radio2">Show Lab Tests</label>
</div>
<h1>Lab Test Results</h1>
<div class="row" id="lab-test-row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header"></div>
            <div class="card-body p-0">
             <div class="report-content" style="font-family: Arial, sans-serif; width: 100%; margin: 0 auto; padding: 0;">
    <div class="report-header" style="text-align: center; margin-bottom: 20px;">
        <img src="assets/zfsdfg.png" style="max-width: 100%; height: auto;" />
    </div>
    <div class="patient-details" style="margin-bottom: 10px;">
        <hr style="border: 0; border-top: 1px solid #000;" />
        <table border="0" style="width: 100%; table-layout: fixed;">
            <tr>
                <td style="padding: 5px;">Patient Name: <span class="h5" id="ptname"></span></td>
                <td style="padding: 5px; text-align: left;">Referred By:</td>
            </tr>
            <tr>
                <td style="padding: 5px;">Sex: <span class="h5" id="sex"></span></td>
                <td style="padding: 5px; text-align: left;">Date: <span id="date" class="h5"></span></td>
            </tr>
            <tr>
                <td style="padding: 5px;">Age: <span class="h5" id="DOB"></span> years</td>
                <td style="padding: 5px; text-align: left;">Doctor: <span class="h5" id="doctor"></span></td>
            </tr>
            <tr>
                <td style="padding: 5px;">Phone: <span class="h5" id="phone"></span></td>
                <td style="padding: 5px; text-align: left;">Location: <span class="h5" id="location"></span></td>
            </tr>
        </table>
        <hr style="border: 0; border-top: 1px solid #000;" />
    </div>
    <div class="report-body" style="margin: 0;">
        <table id="datatable1" class="patient-details" style="width: 100%; border-collapse: collapse; border: 1px solid #000;">
            <thead>
                <tr>
                    <th style="border: 1px solid #000; padding: 5px;">Name</th>
                    <th style="border: 1px solid #000; padding: 5px;">Result</th>
                </tr>
            </thead>
            <tbody>
                <!-- Table rows will be dynamically added here -->
            </tbody>
        </table>
    </div>
</div>
<button id="print-button" class="btn btn-success"  style="display: none;" onclick="printReport()">Print Report</button>

            </div>
        </div>
    </div>
</div>
    </div>
    <div class="col-4">
        <h1> Image Results</h1>
    <%--    <img src="assets/img/lab.png" alt="X-ray Results"/>--%>
               <img src="" id="img"/>
    </div>
          </div>

 
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
    <input style="display:none" id="id1111" />

    <div class="mb-3">
        <label for="name" class="form-label">Medication Name</label>
        <input type="text" class="form-control" id="name1" placeholder="Enter Name">
        <small id="nameError1" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="dosage" class="form-label">Dosage</label>
        <input type="text" class="form-control" id="dosage1" placeholder="Enter Dosage">
        <small id="dosageError1" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="frequency" class="form-label">Frequency</label>
        <input type="text" class="form-control" id="frequency1" placeholder="Enter Frequency">
        <small id="frequencyError1" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="duration" class="form-label">Duration</label>
        <input type="text" class="form-control" id="duration1" placeholder="Enter Duration">
        <small id="durationError11" class="text-danger"></small>
    </div>

    <div class="mb-3">
        <label for="inst" class="form-label">Special Instruction</label>
        <textarea class="form-control" id="inst1" rows="3"></textarea>
        <small id="instError1" class="text-danger"></small>
    </div>
</div>





      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
             <button type="button" onclick="deletejob()" class="btn btn-danger">delete</button>
        <button type="button" onclick="update()" class="btn btn-primary">update</button>
          
      </div>
    </div>
  </div>
</div>
       <div class="row">
              <div class="col-md-12">
                <div class="card">
                  <div class="card-header">
                    <h4 class="card-title">Patient Report</h4>
                  </div>
                  <div class="card-body">
                    <div>
                      <table  class="display nowrap" style="width:100%"
                        id="datatable"  >
                        <thead>
                          <tr>
              
                            <th>Name</th>
                            <th>Sex</th>
                            <th>Location</th>
                            <th>Phone</th>
                                <th>Amount</th>
  <th>D.O.B</th>
                            <th>Date Registered</th>
                            <th>lab</th>
                                   <th>image</th>
                                    <th>operation</th>
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
     <th>lab</th>
            <th>image</th>
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


        
<!-- Modal -->
<div class="modal fade" id="staticBackdrop1" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog modal-fullscreen">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="staticBackdropLabel11">Modal title</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
            <input style="display:none" id="id111" />
                <h1> Medication Report</h1>
          <div class="row">
      
              
              <div class="col-12">
   
  <div class="report-content col-12" id="report" style="font-family: Arial, sans-serif; width: 100%; margin: 0 auto; padding: 0;">
  <div class="report-header" style="text-align: center; margin-bottom: 20px;">
      <img src="assets/zfsdfg.png" style="max-width: 100%; height: auto;" />
  </div>
  <div class="patient-details" style="margin-bottom: 4px;">
      <h3 id="ht" style="text-align: center;">Medication Report</h3>
    <hr style="border: 0; border-top: 1px solid #000;" />
    <table border="0" style="width: 100%; table-layout: fixed;">
      <tr>
        <td>Patient Name: <span class="h5" id="ptname1"></span></td>
        <td>Referred By:</td>
      </tr>
      <tr>
        <td >Sex: <span class="h5" id="sex1"></span></td>
        <td>Date: <span id="date1" class="h5"></span></td>
      </tr>
      <tr>
        <td>Age: <span class="h5" id="DOB1"></span> years</td>
        <td>Doctor: <span class="h5" id="doctor1"></span></td>
      </tr>
      <tr>
        <td>Phone: <span class="h5" id="phone1"></span></td>
        <td>Location: <span class="h5" id="location1"></span></td>
      </tr>
    </table>
    <hr style="border: 0; border-top: 1px solid #000;" />
  </div>
  <div class="report-body" style="margin: 0;">
    <table id="datatable11" class="patient-details" style="width: 100%; border-collapse: collapse; border: 1px solid #000;">
      <thead>
        <tr>
          <th style="border: 1px solid #000; padding: 5px;">Medication Name</th>
          <th style="border: 1px solid #000; padding: 5px;">Dosage</th>
          <th style="border: 1px solid #000; padding: 5px;">Frequency</th>
          <th style="border: 1px solid #000; padding: 5px;">Duration</th>
          <th style="border: 1px solid #000; padding: 5px;">Special Instruction</th>
        </tr>
      </thead>
      <tbody>
        <!-- Table rows will be dynamically added here -->
      </tbody>
    </table>
  </div>
  <br /><br /><br /><br /><br /><br /><br /><br />
  <%-- 
  <div class="report-sign">
    <div class="lab-incharge-sign">
      <figcaption>Mr. Sachin Sharma</figcaption>
    </div>
    <div class="lab-doctor-sign">
      <figcaption>Dr. A.K. Asthana</figcaption>
    </div>
  </div>
  --%>
</div>
<button id="print-button1" class="btn btn-success" style="display: none;" onclick="printReport1()">Print Report</button>

    </div>

          </div>

 
      </div>
   
    </div>
  </div>
</div>
                        <script src="assets/js/core/jquery-3.7.1.min.js"></script>


 


    <script src="datatables/datatables.min.js"></script>

<script>





    function toggleRow() {
        var checkbox = document.getElementById("radio2");
        var row = document.getElementById("lab-test-row");
        if (checkbox.checked) {
            row.style.display = "block";
        } else {
            row.style.display = "none";
        }
    }

    // Initialize the row visibility based on the checkbox state
    document.addEventListener("DOMContentLoaded", function () {
        toggleRow();
    });


    //document.getElementById('print-button1').addEventListener('click', function (event) {
    //    event.preventDefault(); // Prevent the default button behavior

    //    var reportContent = document.getElementById('report').innerHTML;
    //    var printWindow = window.open('', '_blank', 'height=600,width=800');
    //    printWindow.document.write('<html><head><title>Print Report</title>');
    //    // Add styles here if needed
    //    printWindow.document.write('<style>body{font-family: Arial, sans-serif;} .report-content{width: 100%;} .patient-details{width: 100%;} table{width: 100%; border-collapse: collapse;} table, th, td{border: 1px solid black;} th, td{padding: 8px; text-align: left;} @media print {body, html {width: 100%; margin: 0; padding: 0; overflow: hidden;} .report-content{width: 100%; margin: 0; padding: 0;} .report-header, .patient-details, .report-body{width: 100%;}} </style>');
    //    printWindow.document.write('</head><body>');
    //    printWindow.document.write(reportContent);
    //    printWindow.document.write('</body></html>');
    //    printWindow.document.close();
    //    printWindow.focus();
    //    printWindow.onload = function () {
    //        printWindow.print();
    //        printWindow.close();
    //    };
    //});

    function printReport() {
        const printContents = document.querySelector('.report-content').innerHTML;
        const originalContents = document.body.innerHTML;

        document.body.innerHTML = printContents;
        window.print();
        document.body.innerHTML = originalContents;
    }

    document.getElementById('print-button').style.display = 'block';



    function printReport1() {
        const printContents = document.querySelector('#report').innerHTML;
        const originalContents = document.body.innerHTML;

        document.body.innerHTML = printContents;
        window.print();
        document.body.innerHTML = originalContents;
    }

    document.getElementById('print-button1').style.display = 'block';




    function deletejob() {
        var medid = $("#id1111").val();
        $.ajax({
            type: "POST",
            url: "assignmed.aspx/deleteJob",
            data: JSON.stringify({ medid: medid }),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (response) {
                $('#medmodal').modal('hide');
                if (response.d === 'true') {
                    Swal.fire(
                        'Successfully updated !',
                        'You Added a new job title!',
                        'success'
                    )

        
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


    function update() {
        var medid = $("#id1111").val();
    var med_name = $("#name1").val();
        var dosage = $("#dosage1").val();
        var frequency = $("#frequency1").val();
        var duration = $("#duration1").val();
        var special_inst = $("#inst1").val();
    
    




        $.ajax({
            url: 'assignmed.aspx/updateJob',
            data: "{  'medid':'" + medid + "','med_name':'" + med_name + "', 'dosage':'" + dosage + "', 'frequency':'" + frequency + "', 'duration':'" + duration + "' , 'special_inst':'" + special_inst + "'  }",

            dataType: "json",
            type: 'POST',
            contentType: "application/json",
            success: function (response) {
                console.log(response);
                $('#medmodal').modal('hide');
                Swal.fire(
                    'Successfully Updated !',
                    'You Updated a new Customer!',
                    'success'
                )
                DataBind();
            },
            error: function (response) {
                alert(response.responseText);
            }
        });
    }



    // Delegate click events for edit and delete buttons to the table
    $("#datatable11").on("click", ".edit1-btn", function (event) {
        event.preventDefault(); // Prevent default behavior
        var row = $(this).closest("tr");
        var medid = $(this).data("id");

        var med_name = row.find("td:nth-child(1)").text(); 
        var dosage = row.find("td:nth-child(2)").text(); 
        var frequency = row.find("td:nth-child(3)").text();
   
        var duration = row.find("td:nth-child(5)").text();
        var special_inst = row.find("td:nth-child(4)").text();
  

        

        $("#id1111").val(medid);
        $("#name1").val(med_name);

        $("#dosage1").val(dosage);
        $("#frequency1").val(frequency);
        $("#duration1").val(duration);
        $("#inst1").val(special_inst);

        $('#staticBackdrop1').modal('hide');
        $('#medmodal').modal('show');
        $('#staticBackdrop1').modal('show');
   
    });





    function showmedic() {

        var prescid = $("#id111").val();

        event.preventDefault()

        $.ajax({
            url: 'medication_report.aspx/medicdata',
            data: "{'prescid':'" + prescid + "'}",
            dataType: "json",
            type: 'POST',
            contentType: "application/json",
            success: function (response) {
                console.log(response);

                $("#datatable11 tbody").empty();

                for (var i = 0; i < response.d.length; i++) {
                    $("#datatable11 tbody").append(
                        "<tr>"
                        + "<td style='border: 1px solid #000; padding: 5px;'>" + response.d[i].med_name + "</td>"
                        + "<td style='border: 1px solid #000; padding: 5px;'>" + response.d[i].dosage + "</td>"
                        + "<td style='border: 1px solid #000; padding: 5px;'>" + response.d[i].frequency + "</td>"
                        + "<td style='border: 1px solid #000; padding: 5px;'>" + response.d[i].duration + "</td>"
                        + "<td style='border: 1px solid #000; padding: 5px;'>" + response.d[i].special_inst + "</td>"
                        + "</tr>"
                    );
                }




            },
            error: function (response) {
                alert(response.responseText);
            }
        });

        // Show the modal
        $('#staticBackdrop1').modal('show');

    }





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
        var id = $("#pid").val();
        var status = $("#status").val();


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
     
        if (status === "2") {
            isValid = false;
            Swal.fire({
                icon: 'error',
                title: 'Doctor Not Selected',
                text: 'Please select a doctor.',
            });
            return; // Exit the function to prevent the AJAX request
        }



        // If all validations pass, proceed with AJAX call
        if (isValid) {

            $.ajax({
                url: 'assignmed.aspx/submitdata',
                data: "{ 'status':'" + status + "','id':'" + id + "', 'med_name':'" + med_name + "', 'dosage':'" + dosage + "', 'frequency':'" + frequency + "', 'duration':'" + duration + "', 'prescid':'" + prescid + "' , 'special_inst':'" + special_inst + "'  }",
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

        var id = row.find("td:nth-child(10)").text();


        $("#doctor1").text(doctor);
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
        $("#date1").text(formattedToday);
        // Display the age in the input field
        $("#DOB").text(age);


        $("#pid").val(id);

        $("#ptname").text(name);
     
        $("#phone").text(phone);
        $("#location").text(location);
        $("#sex").text(sex);
        $("#ptname1").text(name);

        $("#phone1").text(phone);
        $("#location1").text(location);
        $("#sex1").text(sex);
        $("#id111").val(prescid);
        $("#DOB1").text(age);
    
        $.ajax({
            url: 'assignmed.aspx/xryimage',
            data: JSON.stringify({ 'prescid': prescid }),
            dataType: "json",
            type: 'POST',
            contentType: "application/json",
            success: function (response) {
                console.log(response);

                if (response.d && response.d.length > 0) {
                    var base64Data = response.d[0].image; // Assuming imageData is base64-encoded

                    // Update image source directly
                    $("#img").attr('src', 'data:image/jpeg;base64,' + base64Data);
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

        $.ajax({
            url: 'assignmed.aspx/lab_test',
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

                        + "<td style='border: 1px solid #000; padding: 5px;'>" + response.d[i].TestName + "</td>"
                        + "<td style='border: 1px solid #000; padding: 5px;'>" + response.d[i].TestValue + "</td>"


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
   
     


          

  
        $.ajax({
            url: 'patient_report.aspx/medic',
            dataType: "json",
            type: 'POST',
            contentType: "application/json",
            success: function (response) {
                console.log(response);

                $("#datatable tbody").empty();



                for (var i = 0; i < response.d.length; i++) {


                    $("#datatable tbody").append(
                        "<tr style='cursor:pointer' onclick='passValue(this)'>" +
                        "<td style='display:none'>" + response.d[i].doctorid + "</td>" +
                        "<td>" + response.d[i].full_name + "</td>" +
                        "<td>" + response.d[i].sex + "</td>" +
                        "<td>" + response.d[i].location + "</td>" +
                        "<td>" + response.d[i].phone + "</td>" +
                        "<td>" + response.d[i].amount + "</td>" +
                        "<td>" + response.d[i].dob + "</td>" +
                        "<td>" + response.d[i].date_registered + "</td>" +
                        "<td style='display:none'>" + response.d[i].doctortitle + "</td>" +
                        "<td style='display:none'>" + response.d[i].prescid + "</td>" +
                        "<td style='display:none'>" + response.d[i].patientid + "</td>" +
                        "<td>" + response.d[i].status + "</td>" +
                        "<td>" + response.d[i].xray_status + "</td>" +
                        "<td style='display:none'>" + response.d[i].xrayid + "</td>" +


                        "<td><button class='edit-btn btn btn-success' data-id='" + response.d[i].prescid + "'>View Report</button></td>" +
                        "</tr>"
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
