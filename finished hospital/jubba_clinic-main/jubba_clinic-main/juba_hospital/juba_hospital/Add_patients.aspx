<%@ Page Title="" Language="C#" MasterPageFile="~/register.Master" AutoEventWireup="true"
    CodeBehind="Add_patients.aspx.cs" Inherits="juba_hospital.Add_patients" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">Patient Registration</div>
                    </div>
                    <div class="card-body">
                        <div class="row justify-content-center ">
                            <div class="col-md-12 col-lg-10">
                                <div class="form-group">
                                    <label for="email2">Patient Name</label>
                                    <input type="text" class="form-control" id="name"
                                        placeholder="Enter Patient Name" />
                                    <small id="nameError" class="text-danger"></small>
                                </div>
                                <div class="form-group">
                                    <label for="password">Phone</label>
                                    <input type="number" class="form-control" id="number" placeholder="Number" />
                                    <small id="numberError" class="text-danger"></small>
                                </div>
                                <div class="form-group form-inline">
                                    <label for="inlineinput" class="col-md-3 col-form-label">DOB</label>
                                    <div class="col-md-9 p-0">
                                        <input type="date" class="form-control input-full" id="date" />
                                    </div>
                                    <small id="dateError" class="text-danger"></small>
                                </div>
                                <div class="form-group">
                                    <label for="successInput">Select Sex</label>
                                    <select class="form-control" id="gender">
                                        <option value="0">Please Select Sex</option>
                                        <option value="male">Male</option>
                                        <option value="female">Female</option>
                                    </select>
                                    <small id="genderError" class="text-danger"></small>
                                </div>
                                <div class="form-group">
                                    <label for="successInput">Select Doctor</label>
                                    <select class="form-control" id="doctor">
                                        <option value="0">PLEASE SELECT DOCTOR</option>
                                        <!-- Dynamic options populated from the database will be here -->
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="registrationCharge">Registration Charge</label>
                                    <select class="form-control" id="registrationCharge">
                                        <option value="0">Select Registration Charge</option>
                                        <!-- Dynamic options populated from the database will be here -->
                                    </select>
                                    <small id="registrationChargeError" class="text-danger"></small>
                                </div>

                                <div class="form-group">
                                    <label for="deliveryCharge">Delivery Charge (Optional)</label>
                                    <select class="form-control" id="deliveryCharge">
                                        <option value="0">No Delivery Charge</option>
                                        <!-- Dynamic options populated from the database will be here -->
                                    </select>
                                    <small id="deliveryChargeError" class="text-danger"></small>
                                </div>

                                <div class="form-group">
                                    <label for="Amount">Location</label>
                                    <input type="text" class="form-control" id="location" placeholder="Location" />
                                    <small id="locationError" class="text-danger"></small>
                                </div>
                            </div>

                            <div class="card-action d-flex justify-content-around">
                                <button class="btn btn-danger">Cancel</button>
                                <button type="button" class="btn btn-success" onclick="submitInfo()">Save</button>
                            </div>
                        </div>

                    </div>

                </div>
            </div>
        </div>
        <script src="assets/js/core/jquery-3.7.1.min.js"></script>
        <script>
            function loadRegistrationCharges() {
                $.ajax({
                    type: "POST",
                    url: "Add_patients.aspx/GetRegistrationCharges",
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
                    url: "Add_patients.aspx/GetDeliveryCharges",
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

            function submitInfo() {
                // Clear previous error messages
                document.getElementById('nameError').textContent = "";
                document.getElementById('numberError').textContent = "";
                document.getElementById('dateError').textContent = "";
                document.getElementById('genderError').textContent = "";
                document.getElementById('locationError').textContent = "";
                document.getElementById('registrationChargeError').textContent = "";

                // Get the form values
                const name = document.getElementById('name').value;
                const phone = document.getElementById('number').value;
                const dob = document.getElementById('date').value;
                const gender = document.getElementById('gender').value;
                const doctor = document.getElementById('doctor').value;
                const location = document.getElementById('location').value;
                const registrationChargeId = document.getElementById('registrationCharge').value;
                const deliveryChargeId = document.getElementById('deliveryCharge').value;

                // Validate the form values
                let isValid = true;

                if (name.trim() === "") {
                    document.getElementById('nameError').textContent = "Please enter the patient name.";
                    isValid = false;
                }

                if (phone.trim() === "" || isNaN(phone)) {
                    document.getElementById('numberError').textContent = "Please enter a valid phone number.";
                    isValid = false;
                }

                if (dob.trim() === "") {
                    document.getElementById('dateError').textContent = "Please select a date of birth.";
                    isValid = false;
                }

                if (gender === "0") {
                    document.getElementById('genderError').textContent = "Please select a gender.";
                    isValid = false;
                }

                if (location.trim() === "") {
                    document.getElementById('locationError').textContent = "Please enter a location.";
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

                if (registrationChargeId === "0") {
                    document.getElementById('registrationChargeError').textContent = "Please select a registration charge.";
                    isValid = false;
                }

                // If all validations pass, proceed with AJAX call
                if (isValid) {
                    $.ajax({
                        url: 'Add_patients.aspx/CheckIdExists',
                        data: "{ 'phone':'" + phone + "' }",
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        type: 'POST',
                        success: function (response) {
                            if (response.d === true) {
                                // ID already exists, display an error message
                                Swal.fire({
                                    icon: 'error',
                                    title: 'This person Already Exists',
                                    text: 'The selected Patient already exists in the database.',
                                });
                            } else {
                                // ID does not exist, proceed with the data insertion
                                $.ajax({
                                    url: 'Add_patients.aspx/submitdata',
                                    data: "{ 'name':'" + name + "', 'number':'" + phone + "', 'date':'" + dob + "', 'gender':'" + gender + "', 'doctor':'" + doctor + "', 'location':'" + location + "', 'registrationChargeId':'" + registrationChargeId + "', 'deliveryChargeId':'" + deliveryChargeId + "' }",
                                    contentType: 'application/json; charset=utf-8',
                                    dataType: 'json',
                                    type: 'POST',
                                    success: function (response) {
                                        if (response.d === 'true') {
                                            Swal.fire(
                                                'Successfully Saved!',
                                                'You added a new Patient!',
                                                'success'
                                            );

                                            clearInputFields();
                                        } else {
                                            // Handle errors in the response
                                            Swal.fire({
                                                icon: 'error',
                                                title: 'Data Insertion Failed',
                                                text: response.d,
                                            });
                                        }
                                    },
                                    error: function (response) {
                                        alert(response.responseText);
                                    }
                                });
                            }
                        },
                        error: function (response) {
                            console.log(response);
                        }
                    });
                }

                function clearInputFields() {
                    $("#name").val('');
                    $("#location").val('');
                    $("#number").val('');
                    $("#date").val('');
                    $("#gender").val('0');
                    $("#doctor").val('0');
                    $("#registrationCharge").val('0');
                    $("#deliveryCharge").val('0');
                }
            }

            $(document).ready(function () {
                // Load charges
                loadRegistrationCharges();
                loadDeliveryCharges();

                // Load doctors
                $(function () {
                    $.ajax({
                        type: "POST",
                        url: "Add_patients.aspx/getdoctor",
                        data: '{}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (r) {
                            var doctor = $("[id*=doctor]");
                            doctor.empty().append('<option selected="selected" value="0">Please select</option>');
                            $.each(r.d, function () {
                                doctor.append($("<option></option>").val(this['Value']).html(this['Text']));
                            });
                        }
                    });
                });
            });
        </script>

    </asp:Content>