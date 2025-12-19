<%@ Page Title="" Language="C#" MasterPageFile="~/register.Master" AutoEventWireup="true"
    CodeBehind="Patient_Operation.aspx.cs" Inherits="juba_hospital.Patient_Operation" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link href="datatables/datatables.min.css" rel="stylesheet" />
        <style>
            /* Mobile Card Styles */
            .mobile-cards-container {
                display: none;
            }
            
            .patient-card {
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                margin-bottom: 10px;
                border-left: 4px solid #007bff;
                cursor: pointer;
                transition: all 0.3s ease;
                overflow: hidden;
            }
            
            .patient-card:hover {
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }
            
            .patient-card.expanded {
                box-shadow: 0 4px 16px rgba(0,0,0,0.2);
            }
            
            .patient-card-compact {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 12px 15px;
            }
            
            .patient-basic-info {
                flex: 1;
            }
            
            .patient-name {
                font-size: 16px;
                font-weight: bold;
                color: #333;
                margin: 0 0 2px 0;
            }
            
            .patient-date {
                font-size: 12px;
                color: #666;
                margin: 0;
            }
            
            .expand-indicator {
                color: #007bff;
                font-size: 14px;
                margin-left: 10px;
                transition: transform 0.3s ease;
            }
            
            .patient-card.expanded .expand-indicator {
                transform: rotate(180deg);
            }
            
            .patient-card-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
                border-bottom: 1px solid #eee;
                padding-bottom: 8px;
                padding: 0 15px 8px 15px;
            }
            
            .patient-actions {
                display: flex;
                gap: 5px;
            }
            
            .patient-info {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 8px;
                margin-top: 10px;
                padding: 0 15px 15px 15px;
                display: none;
            }
            
            .patient-card.expanded .patient-info {
                display: grid;
            }
            
            .info-item {
                padding: 5px 0;
            }
            
            .info-label {
                font-size: 12px;
                color: #666;
                text-transform: uppercase;
                margin-bottom: 2px;
                font-weight: 500;
            }
            
            .info-value {
                font-size: 14px;
                color: #333;
                word-wrap: break-word;
            }
            
            .full-width {
                grid-column: 1 / -1;
            }
            
            /* Search box for mobile */
            .mobile-search {
                display: none;
                margin-bottom: 15px;
            }
            
            .mobile-search input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 16px;
            }
            
            /* Show/Hide based on screen size */
            @media (max-width: 768px) {
                .table-responsive {
                    display: none !important;
                }
                
                .mobile-cards-container {
                    display: block;
                }
                
                .mobile-search {
                    display: block;
                }
                
                .patient-info {
                    grid-template-columns: 1fr;
                }
                
                .card-title {
                    font-size: 18px;
                }
                
                /* Make buttons more touch-friendly */
                .patient-actions .btn {
                    min-width: 40px;
                    min-height: 40px;
                    padding: 8px;
                }
            }
            
            @media (min-width: 769px) {
                .table-responsive {
                    display: block !important;
                }
                
                .mobile-cards-container {
                    display: none;
                }
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <!-- Modal -->
        <div class="modal fade" id="deletemodel" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="staticBackdropLabel1">Delet Patients
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">

                        <input style="display:none" id="id11" />
                        <input style="display:none" id="pid1" />


                        <div class="mb-3">
                            <label for="formGroupExampleInput" class="form-label">Full
                                Name</label>
                            <input type="text" readonly class="form-control" id="name1" placeholder="Enter Name">
                        </div>
                        <div class="mb-3">
                            <label for="formGroupExampleInput2" class="form-label">Sex</label>
                            <select class="form-control" required id="sex1">
                                <option value="0"> Please select sex</option>
                                <option value="male"> male</option>
                                <option value="female"> female</option>
                            </select>
                        </div>


                        <div class="mb-3">
                            <label for="formGroupExampleInput" class="form-label">Location</label>
                            <input type="text" readonly class="form-control" id="location1"
                                placeholder="Enter Location">
                        </div>
                        <div class="mb-3">
                            <label for="formGroupExampleInput" class="form-label">D.O.B</label>
                            <input type="date" readonly class="form-control" id="dob1" placeholder="Enter Amount">
                        </div>
                        <div class="mb-3">
                            <label for="formGroupExampleInput" class="form-label">Phone
                                Number</label>
                            <input type="number" readonly class="form-control" id="phone1"
                                placeholder="Enter Phone Number">
                        </div>
                        <div class="mb-3">
                            <label for="formGroupExampleInput2" class="form-label">Doctor
                                Title</label>
                            <select class="form-control" aria-readonly="true" id="doctor1">

                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" onclick="deletepatient()" class="btn btn-danger">Delete</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal -->
        <div class="modal fade" id="editmodal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="staticBackdropLabel">Update Patients
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input style="display:none" id="id1" />
                        <input style="display:none" id="pid" />

                        <div class="mb-3">
                            <label for="name" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="name" placeholder="Enter Name">
                            <small id="nameError" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label for="sex" class="form-label">Sex</label>
                            <select class="form-control" id="sex">
                                <option value="0">Please select sex</option>
                                <option value="male">Male</option>
                                <option value="female">Female</option>
                            </select>
                            <small id="sexError" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label for="location" class="form-label">Location</label>
                            <input type="text" class="form-control" id="location" placeholder="Enter Location">
                            <small id="locationError" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label for="dob" class="form-label">Date of Birth</label>
                            <input type="date" class="form-control" id="dob">
                            <small id="dobError" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label for="phone" class="form-label">Phone Number</label>
                            <input type="number" class="form-control" id="phone" placeholder="Enter Phone Number">
                            <small id="phoneError" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label for="doctor" class="form-label">Doctor Title</label>
                            <select class="form-control" id="doctor">
                                <!-- Options populated dynamically from database -->
                            </select>

                        </div>

                        <div class="mb-3">
                            <label for="registrationCharge">Registration Charge</label>
                            <select class="form-control" id="registrationCharge">
                                <option value="0">Select Registration Charge</option>
                                <!-- Dynamic options populated from the database will be here -->
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="deliveryCharge">Delivery Charge (Optional)</label>
                            <select class="form-control" id="deliveryCharge">
                                <option value="0">No Delivery Charge</option>
                                <!-- Dynamic options populated from the database will be here -->
                            </select>
                        </div>
                    </div>



                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" onclick="updateinfo()" class="btn btn-primary">Update</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title">Patient Operation</h4>

                    </div>
                </div>
                <div class="card-body">


                    <div class="table-responsive">
                        <table id="datatable" class="display nowrap" style="width:100%">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Sex</th>
                                    <th>Location</th>
                                    <th>Phone</th>
                                    <th>D.O.B</th>
                                    <th>Date Registered</th>
                                    <th>Doctor Title</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tfoot>
                                <tr>
                                    <th>Name</th>
                                    <th>Sex</th>
                                    <th>Location</th>
                                    <th>Phone</th>
                                    <th>D.O.B</th>
                                    <th>Date Registered</th>
                                    <th>Doctor Title</th>
                                    <th>Actions</th>
                                </tr>
                            </tfoot>
                            <tbody>

                            </tbody>
                        </table>
                    </div>

                    <!-- Mobile Cards Container -->
                    <div class="mobile-cards-container">
                        <div class="mobile-search">
                            <input type="text" id="mobileSearchInput" placeholder="Search patients..." />
                        </div>
                        <div id="mobileCardsContent">
                            <!-- Patient cards will be populated here -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
        </div>
        <script src="Scripts/jquery-3.4.1.min.js"></script>
        <script src="assets/js/plugin/datatables/datatables.min.js"></script>
        <script>
            var dataTable;
            
            $(document).ready(function () {
                // Initialize DataTable with mobile responsiveness
                dataTable = $("#datatable").DataTable({
                    responsive: true,
                    autoWidth: false,
                    order: [[5, 'desc']], // Order by Date Registered (column index 5), newest first
                    columnDefs: [
                        { responsivePriority: 1, targets: 0 }, // Name
                        { responsivePriority: 2, targets: 3 }, // Phone
                        { responsivePriority: 3, targets: -1 } // Actions
                    ]
                });
                loadRegistrationCharges();
                loadDeliveryCharges();
                datadisplay();
                setupMobileSearch();
                setupCardExpansion();
            });

            function loadRegistrationCharges() {
                $.ajax({
                    type: "POST",
                    url: "Patient_Operation.aspx/GetRegistrationCharges",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var regCharge = $("#registrationCharge");
                        regCharge.empty().append('<option value="0">Select Registration Charge</option>');

                        if (response.d && response.d.length > 0) {
                            $.each(response.d, function () {
                                regCharge.append($("<option></option>").val(this['Value']).html(this['Text']));
                            });
                        }
                    },
                    error: function (error) {
                        console.log("Error loading registration charges:", error);
                    }
                });
            }

            function loadDeliveryCharges() {
                $.ajax({
                    type: "POST",
                    url: "Patient_Operation.aspx/GetDeliveryCharges",
                    data: '{}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var delCharge = $("#deliveryCharge");
                        delCharge.empty().append('<option value="0">No Delivery Charge</option>');

                        if (response.d && response.d.length > 0) {
                            $.each(response.d, function () {
                                delCharge.append($("<option></option>").val(this['Value']).html(this['Text']));
                            });
                        }
                    },
                    error: function (error) {
                        console.log("Error loading delivery charges:", error);
                    }
                });
            }

            function deletepatient() {
                var pid = $("#pid1").val();
                var id = $("#id11").val();

                $.ajax({
                    type: "POST",
                    url: "Patient_Operation.aspx/deletepatient",
                    data: JSON.stringify({ id: id, pid: pid }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        $("#deletemodel").modal("hide");
                        if (response.d === 'true') {
                            Swal.fire(
                                'Successfully deleted!',
                                'The patient has been deleted.',
                                'success'
                            );

                            datadisplay();
                            clearInputFields();
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'Deletion Failed',
                                text: 'There was an error while deleting the patient.',
                            });
                        }
                    },
                    error: function (xhr, status, error) {
                        alert("Error: " + xhr.responseText);
                    }
                });
            }

            function updateinfo() {
                // Clear previous error messages
                document.getElementById('nameError').textContent = "";
                document.getElementById('sexError').textContent = "";
                document.getElementById('phoneError').textContent = "";
                document.getElementById('locationError').textContent = "";
                document.getElementById('dobError').textContent = "";

                // Get the form values
                var id = $("#pid").val();
                var did = $("#id1").val();
                var name = $("#name").val();
                var sex = $("#sex").val();
                var phone = $("#phone").val();
                var location = $("#location").val();
                var doctor = $("#doctor").val();
                var dob = $("#dob").val();
                var registrationChargeId = $("#registrationCharge").val();
                var deliveryChargeId = $("#deliveryCharge").val();

                // Validate the form values
                let isValid = true;

                if (name.trim() === "") {
                    document.getElementById('nameError').textContent = "Please enter the patient name.";
                    isValid = false;
                }

                if (sex === "0") {
                    document.getElementById('sexError').textContent = "Please select a sex.";
                    isValid = false;
                }

                if (phone.trim() === "" || isNaN(phone)) {
                    document.getElementById('phoneError').textContent = "Please enter a valid phone number.";
                    isValid = false;
                }

                if (location.trim() === "") {
                    document.getElementById('locationError').textContent = "Please enter a location.";
                    isValid = false;
                }

                if (dob.trim() === "") {
                    document.getElementById('dobError').textContent = "Please select a date of birth.";
                    isValid = false;
                }

                if (doctor === "0") {
                    isValid = false;
                    Swal.fire({
                        icon: 'error',
                        title: 'Doctor Not Selected',
                        text: 'Please select a doctor.',
                    });
                    return;
                }

                // If all validations pass, proceed with AJAX call
                if (isValid) {
                    $.ajax({
                        url: 'Patient_Operation.aspx/updatepatient',
                        data: JSON.stringify({
                            id: id,
                            name: name,
                            sex: sex,
                            phone: phone,
                            location: location,
                            doctor: doctor,
                            dob: dob,
                            did: did,
                            registrationChargeId: registrationChargeId,
                            deliveryChargeId: deliveryChargeId
                        }),
                        dataType: "json",
                        type: 'POST',
                        contentType: "application/json",
                        success: function (response) {
                            console.log(response);
                            $("#editmodal").modal("hide");
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
            }

            // Delegate click events for edit and delete buttons to both table and mobile cards
            $(document).on("click", ".delete-btn", function (event) {
                event.preventDefault();
                
                var $btn = $(this);
                var doctorid = $btn.data("id");
                var patientid = $btn.data("patientid");
                var prescid = $btn.data("prescid");
                
                // Check if this is from a table row or mobile card
                var isTableRow = $btn.closest("tr").length > 0;
                var name, sex, location, phone, dob;
                
                if (isTableRow) {
                    // Get data from table row
                    var row = $btn.closest("tr");
                    name = row.find("td:nth-child(1)").text();
                    sex = row.find("td:nth-child(2)").text();
                    location = row.find("td:nth-child(3)").text();
                    phone = row.find("td:nth-child(4)").text();
                    dob = row.find("td:nth-child(5)").text();
                } else {
                    // Get data from mobile card
                    var card = $btn.closest(".patient-card");
                    name = card.find(".patient-name").text();
                    sex = card.find(".info-item:nth-child(1) .info-value").text();
                    location = card.find(".info-item:nth-child(3) .info-value").text();
                    phone = card.find(".info-item:nth-child(2) .info-value").text();
                    dob = card.find(".info-item:nth-child(4) .info-value").text();
                }
                
                // Populate readonly fields
                $("#name1").val(name);
                $("#location1").val(location);
                $("#phone1").val(phone);
                $("#dob1").val(dob);
                $("#pid1").val(patientid);
                $("#id11").val(prescid);
                document.getElementById("id1").value = doctorid;

                // Set sex dropdown - use lowercase to match option values
                $("#sex1").val(sex.toLowerCase());

                // Load doctors and set selected doctor
                $.ajax({
                    type: "POST",
                    url: "Patient_Operation.aspx/getdoctors",
                    data: JSON.stringify({ doctorid: doctorid, patientid: patientid }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        var doctorSelect = $("#doctor1");
                        doctorSelect.empty();
                        $.each(response.d.doctorList, function () {
                            doctorSelect.append($("<option></option>").val(this.Value).html(this.Text));
                        });
                        if (response.d.selectedDoctorId) {
                            doctorSelect.val(response.d.selectedDoctorId);
                        }
                    },
                    error: function (response) {
                        alert(response.responseText);
                    }
                });

                $('#deletemodel').modal('show');
            });

            // Delegate click events for edit and delete buttons to both table and mobile cards
            $(document).on("click", ".edit-btn", function (event) {
                event.preventDefault();
                var $btn = $(this);
                var doctorid = $btn.data("id");
                var patientid = $btn.data("patientid");
                var registrationChargeId = $btn.data("regcharge");
                var deliveryChargeId = $btn.data("delcharge");
                
                document.getElementById("id1").value = doctorid;
                
                // Check if this is from a table row or mobile card
                var isTableRow = $btn.closest("tr").length > 0;
                var name, sex, location, phone, dob;
                
                if (isTableRow) {
                    // Get the row data from DataTable API
                    var row = dataTable.row($btn.closest("tr"));
                    var rowData = row.data();
                    
                    name = rowData[0]; // full_name
                    sex = rowData[1]; // sex
                    location = rowData[2]; // location
                    phone = rowData[3]; // phone
                    dob = rowData[4]; // dob
                } else {
                    // Get data from mobile card
                    var card = $btn.closest(".patient-card");
                    name = card.find(".patient-name").text();
                    sex = card.find(".info-item:nth-child(1) .info-value").text();
                    location = card.find(".info-item:nth-child(3) .info-value").text();
                    phone = card.find(".info-item:nth-child(2) .info-value").text();
                    dob = card.find(".info-item:nth-child(4) .info-value").text();
                }

                // Populate text fields
                $("#name").val(name);
                $("#location").val(location);
                $("#phone").val(phone);
                $("#dob").val(dob);
                $("#pid").val(patientid);

                // Set sex dropdown - use lowercase to match option values
                $("#sex").val(sex.toLowerCase());

                // Set charge dropdowns immediately from table data
                $("#registrationCharge").val(registrationChargeId || "0");
                $("#deliveryCharge").val(deliveryChargeId || "0");

                // Load doctors and set selected doctor
                $.ajax({
                    type: "POST",
                    url: "Patient_Operation.aspx/getdoctors",
                    data: JSON.stringify({ doctorid: doctorid, patientid: patientid }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        // Populate doctor dropdown
                        var doctorSelect = $("#doctor");
                        doctorSelect.empty();
                        $.each(response.d.doctorList, function () {
                            doctorSelect.append($("<option></option>").val(this.Value).html(this.Text));
                        });
                        if (response.d.selectedDoctorId) {
                            doctorSelect.val(response.d.selectedDoctorId);
                        }
                    },
                    error: function (response) {
                        alert(response.responseText);
                    }
                });

                $('#editmodal').modal('show');
            });

            // Store patient data globally for mobile search
            var allPatients = [];

            function datadisplay() {
                $.ajax({
                    url: 'Patient_details.aspx/datadisplay',
                    dataType: "json",
                    type: 'POST',
                    contentType: "application/json",
                    success: function (response) {
                        // Store data globally
                        allPatients = response.d;
                        
                        // Clear existing data
                        dataTable.clear();
                        
                        for (var i = 0; i < response.d.length; i++) {
                            // Add row data to DataTable with hidden data attributes
                            dataTable.row.add([
                                response.d[i].full_name,
                                response.d[i].sex,
                                response.d[i].location,
                                response.d[i].phone,
                                response.d[i].dob,
                                response.d[i].date_registered,
                                response.d[i].doctortitle,
                                "<button type='button' class='edit-btn btn btn-link btn-primary btn-lg' " +
                                "data-id='" + response.d[i].doctorid + "' " +
                                "data-patientid='" + response.d[i].patientid + "' " +
                                "data-prescid='" + response.d[i].prescid + "' " +
                                "data-regcharge='" + response.d[i].registrationChargeId + "' " +
                                "data-delcharge='" + response.d[i].deliveryChargeId + "' " +
                                "data-bs-toggle='tooltip' title='Edit patient'>" +
                                "<i class='fa fa-edit'></i></button>"
                            ]);
                        }
                        
                        // Redraw the table to apply changes and maintain responsiveness
                        dataTable.draw();
                        
                        // Populate mobile cards
                        populateMobileCards(response.d);
                    },
                    error: function (response) {
                        alert(response.responseText);
                    }
                });
            }

            function populateMobileCards(patients) {
                var cardsContainer = $('#mobileCardsContent');
                cardsContainer.empty();
                
                if (!patients || patients.length === 0) {
                    cardsContainer.html('<div class="text-center text-muted p-4">No patients found</div>');
                    return;
                }
                
                patients.forEach(function(patient) {
                    var cardHtml = createPatientCard(patient);
                    cardsContainer.append(cardHtml);
                });
            }

            function createPatientCard(patient) {
                return `
                    <div class="patient-card" data-patient-name="${patient.full_name.toLowerCase()}" data-patient-phone="${patient.phone}">
                        <div class="patient-card-compact">
                            <div class="patient-basic-info">
                                <h5 class="patient-name">${patient.full_name}</h5>
                                <p class="patient-date">${patient.date_registered}</p>
                            </div>
                            <div class="expand-indicator">
                                <i class="fa fa-chevron-down"></i>
                            </div>
                        </div>
                        <div class="patient-card-header">
                            <div class="patient-actions">
                                <button type="button" class="edit-btn btn btn-primary btn-sm" 
                                        data-id="${patient.doctorid}"
                                        data-patientid="${patient.patientid}"
                                        data-prescid="${patient.prescid}"
                                        data-regcharge="${patient.registrationChargeId}"
                                        data-delcharge="${patient.deliveryChargeId}"
                                        title="Edit patient"
                                        onclick="event.stopPropagation();">
                                    <i class="fa fa-edit"></i>
                                </button>
                                <button type="button" class="delete-btn btn btn-danger btn-sm"
                                        data-id="${patient.doctorid}"
                                        data-patientid="${patient.patientid}"
                                        data-prescid="${patient.prescid}"
                                        title="Delete patient"
                                        onclick="event.stopPropagation();">
                                    <i class="fa fa-trash"></i>
                                </button>
                            </div>
                        </div>
                        <div class="patient-info">
                            <div class="info-item">
                                <div class="info-label">Sex</div>
                                <div class="info-value">${patient.sex}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Phone</div>
                                <div class="info-value">${patient.phone}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Location</div>
                                <div class="info-value">${patient.location}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Date of Birth</div>
                                <div class="info-value">${patient.dob}</div>
                            </div>
                            <div class="info-item full-width">
                                <div class="info-label">Doctor</div>
                                <div class="info-value">${patient.doctortitle}</div>
                            </div>
                        </div>
                    </div>
                `;
            }

            // Mobile search functionality
            function setupMobileSearch() {
                $('#mobileSearchInput').on('keyup', function() {
                    var searchTerm = $(this).val().toLowerCase();
                    
                    if (searchTerm === '') {
                        populateMobileCards(allPatients);
                        return;
                    }
                    
                    var filteredPatients = allPatients.filter(function(patient) {
                        return patient.full_name.toLowerCase().includes(searchTerm) ||
                               patient.phone.includes(searchTerm) ||
                               patient.location.toLowerCase().includes(searchTerm) ||
                               patient.doctortitle.toLowerCase().includes(searchTerm);
                    });
                    
                    populateMobileCards(filteredPatients);
                });
            }

            // Card expand/collapse functionality
            function setupCardExpansion() {
                $(document).on('click', '.patient-card', function(e) {
                    // Don't expand if clicking on action buttons
                    if ($(e.target).closest('.patient-actions').length > 0) {
                        return;
                    }
                    
                    var $card = $(this);
                    $card.toggleClass('expanded');
                    
                    // Optional: Close other expanded cards (uncomment if you want accordion behavior)
                    // $('.patient-card').not($card).removeClass('expanded');
                });
            }
        </script>
    </asp:Content>