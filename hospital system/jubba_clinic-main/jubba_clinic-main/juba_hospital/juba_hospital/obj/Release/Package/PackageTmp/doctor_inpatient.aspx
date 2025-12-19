<%@ Page Title="Inpatient Management" Language="C#" MasterPageFile="~/doctor.Master" AutoEventWireup="true" CodeBehind="doctor_inpatient.aspx.cs" Inherits="juba_hospital.doctor_inpatient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        .inpatient-card { border-left: 4px solid #007bff; margin-bottom: 20px; transition: all 0.3s ease; }
        .inpatient-card:hover { box-shadow: 0 4px 15px rgba(0,0,0,0.15); transform: translateY(-2px); }
        .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .status-available { background-color: #28a745; color: white; }
        .status-pending { background-color: #ffc107; color: #333; }
        .status-ordered { background-color: #17a2b8; color: white; }
        .status-not-ordered { background-color: #6c757d; color: white; }
        .patient-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 15px; border-radius: 8px 8px 0 0; margin: -15px -15px 15px -15px; }
        .info-label { font-weight: 600; color: #495057; font-size: 13px; text-transform: uppercase; }
        .info-value { font-size: 16px; color: #212529; font-weight: 500; }
        .days-badge { background: #ff6b6b; color: white; padding: 8px 15px; border-radius: 25px; font-weight: bold; font-size: 16px; }
        .summary-card { border-radius: 10px; padding: 20px; margin-bottom: 15px; background: white; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .stat-box { text-align: center; padding: 15px; border-radius: 8px; background: #f8f9fa; }
        .stat-number { font-size: 28px; font-weight: bold; color: #007bff; }
        .stat-label { font-size: 12px; color: #6c757d; text-transform: uppercase; }
        .modal-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .charge-paid { color: #28a745; font-weight: 600; }
        .charge-unpaid { color: #dc3545; font-weight: 600; }
    </style>

    <style>
        .nav-tabs .nav-link {
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .nav-tabs .nav-link:hover {
            background-color: #f8f9fa;
        }
        .nav-tabs .nav-link.active {
            font-weight: bold;
        }
        .tab-pane {
            padding: 20px;
        }
    </style></asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-inner">
        <div class="page-header">
            <h4 class="page-title"><i class="fas fa-procedures"></i> Inpatient Management</h4>
            <div class="ml-md-auto py-2 py-md-0">
                <div class="input-group" style="width: 400px;">
                    <div class="input-group-prepend">
                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                    </div>
                    <input type="text" class="form-control" id="searchPatient" placeholder="Search by name, ID, location, or phone..." />
                    <div class="input-group-append">
                        <button class="btn btn-secondary" type="button" onclick="clearSearch()" title="Clear Search">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
            </div>
            <ul class="breadcrumbs">
                <li class="nav-home"><a href="Dashbourd.aspx"><i class="flaticon-home"></i></a></li>
                <li class="separator"><i class="flaticon-right-arrow"></i></li>
                <li class="nav-item">Doctor</li>
                <li class="separator"><i class="flaticon-right-arrow"></i></li>
                <li class="nav-item active">Inpatients</li>
            </ul>
        </div>

        <div class="row mb-4">
            <div class="col-md-3"><div class="summary-card"><div class="stat-box"><div class="stat-number" id="totalInpatients">0</div><div class="stat-label">Total Inpatients</div></div></div></div>
            <div class="col-md-3"><div class="summary-card"><div class="stat-box"><div class="stat-number text-warning" id="pendingLabs">0</div><div class="stat-label">Pending Lab Results</div></div></div></div>
            <div class="col-md-3"><div class="summary-card"><div class="stat-box"><div class="stat-number text-info" id="pendingXrays">0</div><div class="stat-label">Pending X-rays</div></div></div></div>
            <div class="col-md-3"><div class="summary-card"><div class="stat-box"><div class="stat-number text-danger" id="unpaidCharges">$0</div><div class="stat-label">Total Unpaid Charges</div></div></div></div>
        </div>

        <div class="row" id="inpatientsContainer">
            <div class="col-md-12"><div class="card"><div class="card-body"><div class="text-center py-5"><i class="fas fa-spinner fa-spin fa-3x text-primary"></i><p class="mt-3">Loading inpatients...</p></div></div></div></div>
        </div>
    </div>
    <div class="modal fade" id="patientDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-user-injured"></i> Patient Details</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <ul class="nav nav-tabs" id="patientTabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" id="overview-tab" data-bs-toggle="tab" href="#overviewTab" role="tab" aria-controls="overviewTab" aria-selected="true">
                                <i class="fas fa-info-circle"></i> Overview
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="lab-tab" data-bs-toggle="tab" href="#labResultsTab" role="tab" aria-controls="labResultsTab" aria-selected="false">
                                <i class="fas fa-flask"></i> Lab Results
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="meds-tab" data-bs-toggle="tab" href="#medicationsTab" role="tab" aria-controls="medicationsTab" aria-selected="false">
                                <i class="fas fa-pills"></i> Medications
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" id="charges-tab" data-bs-toggle="tab" href="#chargesTab" role="tab" aria-controls="chargesTab" aria-selected="false">
                                <i class="fas fa-file-invoice-dollar"></i> Charges
                            </a>
                        </li>
                    </ul>
                    <div class="tab-content mt-3" id="patientTabsContent">
                        <div id="overviewTab" class="tab-pane fade show active" role="tabpanel" aria-labelledby="overview-tab">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6 class="text-primary"><i class="fas fa-user"></i> Patient Information</h6>
                                    <table class="table table-sm">
                                        <tr><td class="info-label">Full Name:</td><td class="info-value" id="modalPatientName"></td></tr>
                                        <tr><td class="info-label">Sex:</td><td class="info-value" id="modalPatientSex"></td></tr>
                                        <tr><td class="info-label">DOB:</td><td class="info-value" id="modalPatientDOB"></td></tr>
                                        <tr><td class="info-label">Phone:</td><td class="info-value" id="modalPatientPhone"></td></tr>
                                        <tr><td class="info-label">Location:</td><td class="info-value" id="modalPatientLocation"></td></tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-primary"><i class="fas fa-bed"></i> Admission Details</h6>
                                    <table class="table table-sm">
                                        <tr><td class="info-label">Admission Date:</td><td class="info-value" id="modalAdmissionDate"></td></tr>
                                        <tr><td class="info-label">Days Admitted:</td><td class="info-value" id="modalDaysAdmitted"></td></tr>
                                        <tr><td class="info-label">Bed Charges:</td><td class="info-value" id="modalBedCharges"></td></tr>
                                        <tr><td class="info-label">Unpaid Charges:</td><td class="info-value text-danger" id="modalUnpaidCharges"></td></tr>
                                        <tr><td class="info-label">Paid Charges:</td><td class="info-value text-success" id="modalPaidCharges"></td></tr>
                                    </table>
                                </div>
                            </div>
                            <hr>
                            <div class="row">
                                <div class="col-md-6">
                                    <h6 class="text-primary"><i class="fas fa-notes-medical"></i> Clinical Notes</h6>
                                    <textarea class="form-control" id="clinicalNotes" rows="4" placeholder="Add clinical observations, progress notes, or instructions..."></textarea>
                                    <button class="btn btn-primary btn-sm mt-2" onclick="saveClinicalNote()"><i class="fas fa-save"></i> Save Note</button>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-danger"><i class="fas fa-exchange-alt"></i> Patient Type Management</h6>
                                    <div class="alert alert-warning">
                                        <small><i class="fas fa-exclamation-triangle"></i> <strong>Convert to Outpatient</strong></small>
                                        <p class="mb-2" style="font-size: 0.85rem;">If this patient was registered as inpatient by mistake, you can convert them to outpatient. This will:</p>
                                        <ul style="font-size: 0.85rem;">
                                            <li>Remove bed admission date</li>
                                            <li>Stop bed charge accumulation</li>
                                            <li>Change patient type to outpatient</li>
                                        </ul>
                                        <button type="button" class="btn btn-warning btn-sm mt-2" onclick="convertToOutpatient(); return false;">
                                            <i class="fas fa-exchange-alt"></i> Convert to Outpatient
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="labResultsTab" class="tab-pane fade" role="tabpanel" aria-labelledby="lab-tab">
                            <div class="mb-3">
                                <button type="button" class="btn btn-primary btn-sm" onclick="showOrderLabTests(); return false;">
                                    <i class="fas fa-flask"></i> Order Lab Tests
                                </button>
                                <button type="button" class="btn btn-info btn-sm ml-2" onclick="printLabResults(); return false;">
                                    <i class="fas fa-print"></i> Print Lab Orders
                                </button>
                            </div>
                            <div id="labResultsContent"><p class="text-muted">Click to load lab orders...</p></div>
                        </div>
                        <div id="medicationsTab" class="tab-pane fade" role="tabpanel" aria-labelledby="meds-tab">
                            <div class="mb-3">
                                <button type="button" class="btn btn-success btn-sm" onclick="showAddMedication(); return false;">
                                    <i class="fas fa-plus"></i> Add New Medication
                                </button>
                                <button type="button" class="btn btn-info btn-sm ml-2" onclick="printVisitSummary(); return false;">
                                    <i class="fas fa-print"></i> Print Medications
                                </button>
                            </div>
                            <div id="medicationsContent"><p class="text-muted">Click to load medications...</p></div>
                        </div>
                        <div id="chargesTab" class="tab-pane fade" role="tabpanel" aria-labelledby="charges-tab">
                            <div id="chargesContent"><p class="text-muted">Click to load charges...</p></div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" onclick="printDischargeSummary()"><i class="fas fa-print"></i> Print Discharge Summary</button>
                    <button type="button" class="btn btn-danger" onclick="dischargePatient()"><i class="fas fa-sign-out-alt"></i> Discharge Patient</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="assets/sweetalert2.min.js"></script>
    <script>
        // Bootstrap 5 compatibility for Bootstrap 4 modal syntax
        $(document).ready(function() {
            // Override jQuery modal methods to work with Bootstrap 5
            $.fn.modal = function(action) {
                return this.each(function() {
                    var modal = bootstrap.Modal.getOrCreateInstance(this);
                    if (action === 'show') {
                        modal.show();
                    } else if (action === 'hide') {
                        modal.hide();
                    } else if (action === 'toggle') {
                        modal.toggle();
                    }
                });
            };

            // Override jQuery tab methods to work with Bootstrap 5
            $.fn.tab = function(action) {
                return this.each(function() {
                    var tab = new bootstrap.Tab(this);
                    if (action === 'show') {
                        tab.show();
                    }
                });
            };
        });
        var currentPatient = null;
        var allPatients = [];
        var filteredPatients = [];

        $(document).ready(function() {
            // Enable real-time search as user types
            $('#searchPatient').on('input', function() {
                performSearch();
            }); 
            loadInpatients();
            
            // Manual tab switching (in case Bootstrap tabs don't work)
            $('.nav-tabs a').on('click', function(e) {
                e.preventDefault();
                
                // Remove active from all tabs
                $('.nav-tabs .nav-link').removeClass('active');
                $('.tab-pane').removeClass('show active');
                
                // Add active to clicked tab
                $(this).addClass('active');
                
                // Show corresponding content
                var target = $(this).attr('href');
                $(target).addClass('show active');
                
                console.log('Switched to tab:', target);
            });
            
            // Global fix: Prevent aria-hidden on form causing focus issues
            setInterval(function() {
                $('form[aria-hidden="true"]').removeAttr('aria-hidden');
            }, 500);
            
            // Fix aria-hidden when any modal or alert opens
            $(document).on('focus', 'input, textarea, select, button', function() {
                $('form').removeAttr('aria-hidden');
            });
        });

        function loadInpatients() {
            var doctorId = '<%= Session["id"] %>';
            console.log('Doctor ID:', doctorId);
            
            if (!doctorId || doctorId === '' || doctorId === 'null') {
                Swal.fire('Error', 'Doctor ID not found. Please login again.', 'error');
                return;
            }
            
            $.ajax({
                url: 'doctor_inpatient.aspx/GetInpatients',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ doctorId: doctorId }),
                success: function(response) {
                    console.log('Success:', response);
                    displayInpatients(response.d);
                },
                error: function(xhr, status, error) {
                    console.error('Error:', xhr.responseText);
                    var errorMsg = 'Failed to load inpatients: ' + error;
                    if (xhr.responseText) {
                        errorMsg += '<br><small>' + xhr.responseText.substring(0, 500) + '</small>';
                    }
                    Swal.fire({ title: 'Error', html: errorMsg, icon: 'error', width: '80%' });
                }
            });
        }

        function performSearch() {
            var searchTerm = $('#searchPatient').val().trim().toLowerCase();
            
            if (searchTerm === '') {
                filteredPatients = allPatients;
            } else {
                filteredPatients = allPatients.filter(function(patient) {
                    return patient.full_name.toLowerCase().includes(searchTerm) ||
                           patient.patientid.toLowerCase().includes(searchTerm) ||
                           patient.location.toLowerCase().includes(searchTerm) ||
                           patient.phone.toLowerCase().includes(searchTerm);
                });
            }
            
            renderPatientList(filteredPatients);
        }

        function clearSearch() {
            $('#searchPatient').val('');
            filteredPatients = allPatients;
            renderPatientList(allPatients);
        }

        function displayInpatients(data) {
            if (!data || data.length === 0) {
                $('#inpatientsContainer').html('<div class="col-md-12"><div class="card"><div class="card-body text-center py-5"><i class="fas fa-bed fa-3x text-muted mb-3"></i><h5 class="text-muted">No inpatients at this time</h5></div></div></div>');
                updateStatistics([]);
                return;
            }

            allPatients = data;
            filteredPatients = data;
            renderPatientList(data);
        }

        function renderPatientList(patients) {
            if (!patients || patients.length === 0) {
                if ($('#searchPatient').val().trim() !== '') {
                    $('#inpatientsContainer').html('<div class="col-12"><div class="alert alert-warning text-center"><i class="fas fa-search fa-2x mb-2"></i><h5>No patients found</h5><p>No patients match your search criteria. <button class="btn btn-sm btn-primary" onclick="clearSearch()"><i class="fas fa-times"></i> Clear Search</button></p></div></div>');
                } else {
                    $('#inpatientsContainer').html('<div class="col-md-12"><div class="card"><div class="card-body text-center py-5"><i class="fas fa-bed fa-3x text-muted mb-3"></i><h5 class="text-muted">No inpatients at this time</h5></div></div></div>');
                }
                updateStatistics(patients || []);
                return;
            }

            var html = '';
            
            for (var i = 0; i < patients.length; i++) {
                var patient = patients[i];
                html += '<div class="col-md-6 col-lg-4">';
                html += '<div class="card inpatient-card"><div class="card-body">';
                html += '<div class="patient-header">';
                html += '<h5 class="mb-1">' + patient.full_name + '</h5>';
                html += '<small><i class="fas fa-id-card"></i> ID: ' + patient.patientid + '</small>';
                html += '<div class="float-right"><span class="days-badge">Day ' + patient.days_admitted + '</span></div>';
                html += '</div>';
                html += '<div class="mt-3">';
                html += '<div class="row mb-2">';
                html += '<div class="col-6"><span class="info-label">Sex:</span><div class="info-value">' + patient.sex + '</div></div>';
                html += '<div class="col-6"><span class="info-label">Phone:</span><div class="info-value">' + patient.phone + '</div></div>';
                html += '</div>';
                html += '<div class="mb-2"><span class="info-label">Admission Date:</span><div class="info-value">' + patient.bed_admission_date + '</div></div>';
                html += '<hr>';
                html += '<div class="mb-2"><strong>Clinical Status:</strong><br>';
                html += '<span class="status-badge ' + getStatusClass(patient.lab_result_status) + '"><i class="fas fa-flask"></i> Lab: ' + patient.lab_result_status + '</span> ';
                html += '<span class="status-badge ' + getStatusClass(patient.xray_result_status) + '"><i class="fas fa-x-ray"></i> X-ray: ' + patient.xray_result_status + '</span>';
                html += '</div>';
                html += '<div class="mb-2"><strong>Medications:</strong> ' + patient.medication_count + ' prescribed</div>';
                html += '<hr>';
                html += '<div class="row text-center">';
                html += '<div class="col-6"><small class="text-muted">Unpaid</small><div class="text-danger font-weight-bold">$' + parseFloat(patient.unpaid_charges).toFixed(2) + '</div></div>';
                html += '<div class="col-6"><small class="text-muted">Paid</small><div class="text-success font-weight-bold">$' + parseFloat(patient.paid_charges).toFixed(2) + '</div></div>';
                html += '</div><hr>';
                html += '<div class="text-center">';
                html += '<button type="button" class="btn btn-primary btn-sm action-btn" onclick="viewPatientDetails(' + i + '); return false;"><i class="fas fa-eye"></i> View Details</button>';
                html += '</div>';
                html += '</div></div></div></div>';
            }

            $('#inpatientsContainer').html(html);
            updateStatistics(patients);
        }
        function getStatusClass(status) {
            if (status === 'Available') return 'status-available';
            if (status === 'Pending') return 'status-pending';
            if (status === 'Ordered') return 'status-ordered';
            return 'status-not-ordered';
        }

        function updateStatistics(data) {
            var total = data.length;
            var pendingLabs = data.filter(function(p) { return p.lab_result_status === 'Pending'; }).length;
            var pendingXrays = data.filter(function(p) { return p.xray_result_status === 'Pending'; }).length;
            var unpaid = data.reduce(function(sum, p) { return sum + parseFloat(p.unpaid_charges || 0); }, 0);
            $('#totalInpatients').text(total);
            $('#pendingLabs').text(pendingLabs);
            $('#pendingXrays').text(pendingXrays);
            $('#unpaidCharges').text('$' + unpaid.toFixed(2));
        }

        function viewPatientDetails(index) {
            console.log('viewPatientDetails called with index:', index);
            console.log('filteredPatients:', filteredPatients);
            
            // Use filteredPatients if search is active, otherwise use allPatients
            var patientsToUse = filteredPatients.length > 0 ? filteredPatients : allPatients;
            
            if (!patientsToUse || !patientsToUse[index]) {
                console.error('Patient not found at index:', index);
                Swal.fire('Error', 'Patient data not found', 'error');
                return false;
            }
            
            currentPatient = patientsToUse[index];
            $('#modalPatientName').text(currentPatient.full_name);
            $('#modalPatientSex').text(currentPatient.sex);
            $('#modalPatientDOB').text(currentPatient.dob);
            $('#modalPatientPhone').text(currentPatient.phone);
            $('#modalPatientLocation').text(currentPatient.location);
            $('#modalAdmissionDate').text(currentPatient.bed_admission_date);
            $('#modalDaysAdmitted').text(currentPatient.days_admitted + ' days');
            $('#modalBedCharges').text('$' + parseFloat(currentPatient.total_bed_charges).toFixed(2));
            $('#modalUnpaidCharges').text('$' + parseFloat(currentPatient.unpaid_charges).toFixed(2));
            $('#modalPaidCharges').text('$' + parseFloat(currentPatient.paid_charges).toFixed(2));
            // Load data immediately
            loadLabResults(currentPatient.prescid);
            loadMedications(currentPatient.prescid);
            loadCharges(currentPatient.patientid);
            
            // Reset to overview tab when opening
            $('#patientTabs a[href="#overviewTab"]').tab('show');
            
            // Show modal
            $('#patientDetailsModal').modal('show');
            
            return false;
        }

        function loadLabResults(prescid) {
            console.log('Loading lab orders for prescid:', prescid);
            $('#labResultsContent').html('<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading...</div>');
            
            $.ajax({
                url: 'doctor_inpatient.aspx/GetLabOrders',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ prescid: prescid }),
                success: function(response) {
                    console.log('Lab orders response:', response);
                    var orders = response.d;
                    var html = '';
                    
                    if (orders && orders.length > 0) {
                        // Display each order separately
                        for (var i = 0; i < orders.length; i++) {
                            var order = orders[i];
                            var orderNum = i + 1;
                            
                            html += '<div class="card mb-3" style="border-left: 4px solid ' + (order.IsReorder ? '#ff9800' : '#2196F3') + ';">';
                            html += '<div class="card-header" style="background-color: ' + (order.IsReorder ? '#fff3cd' : '#e3f2fd') + ';">';
                            html += '<h6 class="mb-0">';
                            html += '<i class="fas fa-flask"></i> Lab Order #' + orderNum;
                            if (order.IsReorder) {
                                html += ' <span class="badge badge-warning ml-2">Follow-up Order</span>';
                            } else {
                                html += ' <span class="badge badge-primary ml-2">Initial Order</span>';
                            }
                            
                            // Show charge status
                            if (order.IsPaid) {
                                html += ' <span class="badge badge-success ml-2"><i class="fas fa-check-circle"></i> Paid ($' + order.ChargeAmount.toFixed(2) + ')</span>';
                            } else {
                                html += ' <span class="badge badge-danger ml-2"><i class="fas fa-exclamation-circle"></i> Unpaid ($' + order.ChargeAmount.toFixed(2) + ')</span>';
                            }
                            
                            html += '<small class="float-right text-muted">' + order.OrderDate + '</small>';
                            html += '</h6>';
                            if (order.Notes) {
                                html += '<small class="text-muted"><i class="fas fa-sticky-note"></i> ' + order.Notes + '</small>';
                            }
                            
                            // Show payment warning if unpaid
                            if (!order.IsPaid) {
                                html += '<div class="alert alert-warning mt-2 mb-0" style="padding: 0.5rem;"><small><i class="fas fa-info-circle"></i> <strong>Payment Required:</strong> Patient must pay $' + order.ChargeAmount.toFixed(2) + ' at registration before lab can process this order.</small></div>';
                            }
                            
                            html += '</div>';
                            
                            html += '<div class="card-body">';
                            
                            // Ordered Tests
                            if (order.OrderedTests && order.OrderedTests.length > 0) {
                                html += '<div class="mb-2"><strong>Ordered Tests:</strong></div>';
                                html += '<div class="row mb-3">';
                                for (var j = 0; j < order.OrderedTests.length; j++) {
                                    html += '<div class="col-md-4 col-sm-6 mb-2">';
                                    html += '<span class="badge badge-secondary" style="font-size: 12px; padding: 6px 10px; width: 100%;">';
                                    html += '<i class="fas fa-check"></i> ' + order.OrderedTests[j];
                                    html += '</span></div>';
                                }
                                html += '</div>';
                            }
                            
                            // Results
                            if (order.Results && order.Results.length > 0) {
                                html += '<div class="alert alert-success mb-2"><i class="fas fa-check-circle"></i> <strong>Results Available</strong></div>';
                                html += '<div class="table-responsive">';
                                html += '<table class="table table-sm table-bordered">';
                                html += '<thead class="thead-light"><tr><th>Test</th><th>Result</th></tr></thead><tbody>';
                                for (var k = 0; k < order.Results.length; k++) {
                                    html += '<tr>';
                                    html += '<td>' + order.Results[k].TestName + '</td>';
                                    html += '<td><strong class="text-success">' + order.Results[k].TestValue + '</strong></td>';
                                    html += '</tr>';
                                }
                                html += '</tbody></table></div>';
                            } else {
                                html += '<div class="alert alert-warning"><i class="fas fa-hourglass-half"></i> Waiting for results...</div>';
                            }
                            
                            // Action buttons - only show if unpaid (can be deleted)
                            if (!order.IsPaid) {
                                html += '<div class="mt-3">';
                                html += '<button type="button" class="btn btn-sm btn-danger" onclick="deleteLabOrder(' + order.OrderId + ', ' + currentPatient.prescid + '); return false;">';
                                html += '<i class="fas fa-trash"></i> Delete Order';
                                html += '</button>';
                                html += '<small class="text-muted ml-2"><i class="fas fa-info-circle"></i> You can delete this order because payment has not been made yet.</small>';
                                html += '</div>';
                            } else {
                                html += '<div class="mt-3">';
                                html += '<small class="text-success"><i class="fas fa-lock"></i> This order cannot be deleted because payment has been received.</small>';
                                html += '</div>';
                            }
                            
                            html += '</div></div>';
                        }
                    } else {
                        html = '<div class="alert alert-info"><i class="fas fa-info-circle"></i> No lab tests ordered yet. Click "Order Lab Tests" to create an order.</div>';
                    }
                    
                    $('#labResultsContent').html(html);
                },
                error: function(xhr, status, error) {
                    console.error('Lab orders error:', xhr.responseText);
                    $('#labResultsContent').html('<div class="alert alert-danger">Error loading lab orders: ' + error + '</div>');
                }
            });
        }

        function loadMedications(prescid) {
            console.log('Loading medications for prescid:', prescid);
            $('#medicationsContent').html('<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading...</div>');
            
            $.ajax({
                url: 'doctor_inpatient.aspx/GetMedications',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ prescid: prescid }),
                success: function(response) {
                    console.log('Medications response:', response);
                    if (response.d && response.d.length > 0) {
                        var html = '<div class="table-responsive">';
                        html += '<table class="table table-hover table-bordered">';
                        html += '<thead class="thead-light">';
                        html += '<tr>';
                        html += '<th style="width: 20%;"><i class="fas fa-pills"></i> Medication</th>';
                        html += '<th style="width: 12%;">Dosage</th>';
                        html += '<th style="width: 12%;">Frequency</th>';
                        html += '<th style="width: 12%;">Duration</th>';
                        html += '<th style="width: 18%;">Special Instructions</th>';
                        html += '<th style="width: 10%;">Date</th>';
                        html += '<th style="width: 16%;">Actions</th>';
                        html += '</tr></thead><tbody>';
                        
                        for (var i = 0; i < response.d.length; i++) {
                            var med = response.d[i];
                            html += '<tr>';
                            html += '<td><strong class="text-primary">' + med.med_name + '</strong></td>';
                            html += '<td>' + (med.dosage || '-') + '</td>';
                            html += '<td>' + (med.frequency || '-') + '</td>';
                            html += '<td>' + (med.duration || '-') + '</td>';
                            html += '<td>' + (med.special_inst ? '<small class="text-muted">' + med.special_inst + '</small>' : '-') + '</td>';
                            html += '<td><small>' + (med.date_taken || '-') + '</small></td>';
                            html += '<td>';
                            html += '<button type="button" class="btn btn-sm btn-warning me-1 edit-med-btn" data-medid="' + med.medid + '" data-name="' + med.med_name + '" data-dosage="' + med.dosage + '" data-frequency="' + med.frequency + '" data-duration="' + med.duration + '" data-inst="' + (med.special_inst || '') + '" title="Edit">';
                            html += '<i class="fas fa-edit"></i>';
                            html += '</button>';
                            html += '<button type="button" class="btn btn-sm btn-danger delete-med-btn" data-medid="' + med.medid + '" data-name="' + med.med_name + '" title="Delete">';
                            html += '<i class="fas fa-trash"></i>';
                            html += '</button>';
                            html += '</td>';
                            html += '</tr>';
                        }
                        html += '</tbody></table></div>';
                        $('#medicationsContent').html(html);
                    } else {
                        $('#medicationsContent').html('<div class="alert alert-info"><i class="fas fa-info-circle"></i> No medications prescribed yet</div>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Medications error:', xhr.responseText);
                    $('#medicationsContent').html('<div class="alert alert-danger">Error loading medications: ' + error + '</div>');
                }
            });
        }

        function loadCharges(patientId) {
            console.log('Loading charges for patientId:', patientId);
            $('#chargesContent').html('<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Loading...</div>');
            
            $.ajax({
                url: 'doctor_inpatient.aspx/GetPatientCharges',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ patientId: patientId }),
                success: function(response) {
                    console.log('Charges response:', response);
                    if (response.d && response.d.length > 0) {
                        var totalAmount = 0;
                        var totalPaid = 0;
                        var totalUnpaid = 0;
                        
                        var html = '<table class="table table-sm table-bordered"><thead class="thead-light"><tr><th>Type</th><th>Description</th><th>Amount</th><th>Status</th><th>Date</th></tr></thead><tbody>';
                        for (var i = 0; i < response.d.length; i++) {
                            var charge = response.d[i];
                            var amount = parseFloat(charge.amount);
                            var isPaid = charge.is_paid === '1' || charge.is_paid === 'True' || charge.is_paid === true;
                            
                            totalAmount += amount;
                            if (isPaid) {
                                totalPaid += amount;
                            } else {
                                totalUnpaid += amount;
                            }
                            
                            html += '<tr><td><span class="badge badge-info">' + charge.charge_type + '</span></td>';
                            html += '<td>' + charge.charge_name + '</td>';
                            html += '<td><strong>$' + amount.toFixed(2) + '</strong></td>';
                            html += '<td><span class="' + (isPaid ? 'charge-paid' : 'charge-unpaid') + '"><i class="fas fa-' + (isPaid ? 'check-circle' : 'exclamation-circle') + '"></i> ' + (isPaid ? 'Paid' : 'Unpaid') + '</span></td>';
                            html += '<td><small>' + charge.date_added + '</small></td></tr>';
                        }
                        html += '</tbody>';
                        html += '<tfoot><tr class="table-active"><td colspan="2"><strong>TOTALS</strong></td>';
                        html += '<td><strong>$' + totalAmount.toFixed(2) + '</strong></td>';
                        html += '<td colspan="2"><span class="charge-paid">Paid: $' + totalPaid.toFixed(2) + '</span> | <span class="charge-unpaid">Unpaid: $' + totalUnpaid.toFixed(2) + '</span></td></tr></tfoot>';
                        html += '</table>';
                        $('#chargesContent').html(html);
                    } else {
                        $('#chargesContent').html('<div class="alert alert-info"><i class="fas fa-info-circle"></i> No charges recorded yet</div>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Charges error:', xhr.responseText);
                    $('#chargesContent').html('<div class="alert alert-danger">Error loading charges: ' + error + '</div>');
                }
            });
        }

        function saveClinicalNote() {
            var note = $('#clinicalNotes').val().trim();
            if (!note) { Swal.fire('Warning', 'Please enter a note', 'warning'); return; }
            $.ajax({
                url: 'doctor_inpatient.aspx/AddMedicalNote',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ patientId: currentPatient.patientid, prescid: currentPatient.prescid, note: note }),
                success: function(response) {
                    if (response.d === 'success') {
                        Swal.fire('Success', 'Clinical note saved', 'success');
                        $('#clinicalNotes').val('');
                        loadMedications(currentPatient.prescid);
                    } else {
                        Swal.fire('Error', response.d, 'error');
                    }
                }
            });
        }

        function printDischargeSummary() {
            if (!currentPatient) return;
            window.open('discharge_summary_print.aspx?patientId=' + currentPatient.patientid + '&prescid=' + currentPatient.prescid, '_blank', 'width=900,height=700');
        }

        function printLabResults() {
            if (!currentPatient) {
                Swal.fire('Error', 'No patient selected', 'error');
                return;
            }
            // Print lab orders with ordered tests and results
            window.open('lab_orders_print.aspx?prescid=' + currentPatient.prescid, '_blank', 'width=900,height=700');
        }

        function printVisitSummary() {
            if (!currentPatient) {
                Swal.fire('Error', 'No patient selected', 'error');
                return;
            }
            // Print medications only
            window.open('medication_print.aspx?prescid=' + currentPatient.prescid, '_blank', 'width=900,height=700');
        }

        function deleteLabOrder(orderId, prescid) {
            Swal.fire({
                title: 'Delete Lab Order?',
                html: '<p>Are you sure you want to delete this lab order?</p>' +
                      '<p class="text-danger"><i class="fas fa-exclamation-triangle"></i> <strong>This will:</strong></p>' +
                      '<ul class="text-left">' +
                      '<li>Remove all ordered tests</li>' +
                      '<li>Delete the associated charge</li>' +
                      '<li>This action cannot be undone</li>' +
                      '</ul>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: '<i class="fas fa-trash"></i> Yes, Delete Order',
                cancelButtonText: 'Cancel',
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d'
            }).then(function(result) {
                if (result.isConfirmed) {
                    $.ajax({
                        url: 'doctor_inpatient.aspx/DeleteLabOrder',
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({ orderId: orderId }),
                        success: function(response) {
                            if (response.d.success) {
                                Swal.fire({
                                    title: 'Deleted!',
                                    text: 'Lab order has been successfully deleted',
                                    icon: 'success',
                                    timer: 2000,
                                    showConfirmButton: false
                                }).then(function() {
                                    // Reload lab orders
                                    loadLabResults(prescid);
                                });
                            } else {
                                Swal.fire('Error', response.d.message || 'Failed to delete lab order', 'error');
                            }
                        },
                        error: function(xhr, status, error) {
                            console.error('Delete error:', xhr.responseText);
                            Swal.fire('Error', 'An error occurred while deleting the order: ' + error, 'error');
                        }
                    });
                }
            });
        }

        function convertToOutpatient() {
            if (!currentPatient) {
                Swal.fire('Error', 'No patient selected', 'error');
                return false;
            }

            // First, check for unpaid charges and bed charge count
            $.ajax({
                url: 'doctor_inpatient.aspx/CheckUnpaidCharges',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ patientId: currentPatient.patientid }),
                success: function(response) {
                    if (response.d.hasUnpaidCharges) {
                        Swal.fire({
                            title: 'Cannot Convert to Outpatient',
                            html: '<div class="text-left">' +
                                  '<p class="text-danger"><i class="fas fa-exclamation-circle"></i> <strong>This patient has unpaid charges:</strong></p>' +
                                  '<ul>' +
                                  (response.d.unpaidLabCharges > 0 ? '<li>Unpaid Lab Charges: <strong>$' + response.d.unpaidLabCharges.toFixed(2) + '</strong></li>' : '') +
                                  (response.d.unpaidBedCharges > 0 ? '<li>Unpaid Bed Charges: <strong>$' + response.d.unpaidBedCharges.toFixed(2) + '</strong></li>' : '') +
                                  '</ul>' +
                                  '<p class="text-warning"><i class="fas fa-info-circle"></i> <strong>Please ensure all charges are paid before converting to outpatient.</strong></p>' +
                                  '<p><small>Patient must go to registration to pay outstanding charges first.</small></p>' +
                                  '</div>',
                            icon: 'warning',
                            confirmButtonText: 'OK'
                        });
                    } else if (response.d.totalBedCharges > 1) {
                        Swal.fire({
                            title: 'Cannot Convert to Outpatient',
                            html: '<div class="text-left">' +
                                  '<p class="text-danger"><i class="fas fa-exclamation-circle"></i> <strong>This patient has accumulated bed charges for multiple days.</strong></p>' +
                                  '<p>The patient has <strong>' + response.d.totalBedCharges + ' days</strong> of bed charges, which indicates they have actually stayed as an inpatient.</p>' +
                                  '<p class="text-warning"><i class="fas fa-info-circle"></i> <strong>Conversion to outpatient is only allowed if:</strong></p>' +
                                  '<ul>' +
                                  '<li>Patient was registered as inpatient by mistake</li>' +
                                  '<li>Maximum of 1 day of bed charges</li>' +
                                  '<li>All charges are paid</li>' +
                                  '</ul>' +
                                  '<p class="text-info"><i class="fas fa-lightbulb"></i> <strong>Suggestion:</strong> If the patient is ready to leave, use the <strong>"Discharge Patient"</strong> function instead.</p>' +
                                  '</div>',
                            icon: 'error',
                            confirmButtonText: 'OK',
                            width: '600px'
                        });
                    } else {
                        // No unpaid charges and only 1 or 0 bed charges, proceed with confirmation
                        showConvertConfirmation();
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Check charges error:', xhr.responseText);
                    Swal.fire('Error', 'Failed to check charges: ' + error, 'error');
                }
            });
            
            return false;
        }

        function showConvertConfirmation() {
            Swal.fire({
                title: 'Convert to Outpatient?',
                html: '<div class="text-left">' +
                      '<p>Are you sure you want to convert <strong>' + currentPatient.full_name + '</strong> from inpatient to outpatient?</p>' +
                      '<p class="text-info"><i class="fas fa-info-circle"></i> <strong>This will:</strong></p>' +
                      '<ul>' +
                      '<li>Remove bed admission date</li>' +
                      '<li>Stop bed charge accumulation</li>' +
                      '<li>Change patient type to outpatient</li>' +
                      '<li>Remove patient from inpatient list</li>' +
                      '</ul>' +
                      '<p class="text-warning"><i class="fas fa-exclamation-triangle"></i> <strong>Note:</strong> This action should only be used if the patient was registered as inpatient by mistake.</p>' +
                      '</div>',
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: '<i class="fas fa-exchange-alt"></i> Yes, Convert to Outpatient',
                cancelButtonText: 'Cancel',
                confirmButtonColor: '#f39c12',
                cancelButtonColor: '#6c757d'
            }).then(function(result) {
                if (result.isConfirmed) {
                    performConvertToOutpatient();
                }
            });
        }

        function performConvertToOutpatient() {
            $.ajax({
                url: 'doctor_inpatient.aspx/ConvertToOutpatient',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ 
                    patientId: currentPatient.patientid,
                    prescid: currentPatient.prescid 
                }),
                success: function(response) {
                    if (response.d.success) {
                        Swal.fire({
                            title: 'Success!',
                            text: 'Patient has been successfully converted to outpatient',
                            icon: 'success',
                            timer: 2000,
                            showConfirmButton: false
                        }).then(function() {
                            // Close modal and refresh list
                            $('#patientDetailsModal').modal('hide');
                            loadInpatients();
                        });
                    } else {
                        Swal.fire('Error', response.d.message || 'Failed to convert patient', 'error');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Convert error:', xhr.responseText);
                    Swal.fire('Error', 'An error occurred while converting: ' + error, 'error');
                }
            });
        }

        function dischargePatient() {
            Swal.fire({
                title: 'Discharge Patient?',
                text: 'Discharge ' + currentPatient.full_name + '? Final bed charges will be calculated and verified.',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                confirmButtonText: 'Yes, Discharge'
            }).then(function(result) {
                if (result.isConfirmed) {
                    $.ajax({
                        url: 'doctor_inpatient.aspx/DischargePatient',
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({ patientId: currentPatient.patientid, prescid: currentPatient.prescid }),
                        success: function(response) {
                            var data = response.d;
                            
                            // Handle new object response format
                            if (data.success === true) {
                                Swal.fire('Discharged', data.message || 'Patient discharged successfully', 'success');
                                $('#patientDetailsModal').modal('hide');
                                loadInpatients();
                            } else if (data.success === false && data.unpaidCharges) {
                                // Show detailed unpaid charges alert
                                var chargesHtml = '<div class="text-left"><p class="text-danger"><strong>⚠️ Patient has unpaid charges:</strong></p><ul class="list-group">';
                                
                                data.unpaidCharges.forEach(function(charge) {
                                    chargesHtml += '<li class="list-group-item d-flex justify-content-between align-items-center">' +
                                        '<span><strong>' + charge.chargeType + ':</strong> ' + charge.chargeName + 
                                        '<br><small class="text-muted">' + charge.dateAdded + '</small></span>' +
                                        '<span class="badge bg-danger">$' + charge.amount.toFixed(2) + '</span>' +
                                        '</li>';
                                });
                                
                                chargesHtml += '</ul><hr><p class="text-end"><strong>Total Unpaid: <span class="text-danger">$' + 
                                    data.totalUnpaid.toFixed(2) + '</span></strong></p>' +
                                    '<p class="text-info mt-3"><i class="fas fa-info-circle"></i> Please ensure all charges are paid before discharging the patient.</p></div>';
                                
                                Swal.fire({
                                    title: 'Cannot Discharge',
                                    html: chargesHtml,
                                    icon: 'error',
                                    width: '600px',
                                    confirmButtonText: 'OK, I\'ll Process Payment'
                                });
                            } else {
                                // Fallback for old string response format
                                if (data === 'success' || data.message === 'success') {
                                    Swal.fire('Discharged', 'Patient discharged successfully', 'success');
                                    $('#patientDetailsModal').modal('hide');
                                    loadInpatients();
                                } else {
                                    Swal.fire('Error', data.message || data, 'error');
                                }
                            }
                        },
                        error: function(xhr, status, error) {
                            Swal.fire('Error', 'Failed to discharge patient: ' + error, 'error');
                        }
                    });
                }
            });
        }
        function showAddMedication() {
            console.log('=== showAddMedication called ===');
            if (!currentPatient) {
                console.log('ERROR: No currentPatient');
                return;
            }
            
            console.log('Current patient:', currentPatient);
            
            // CRITICAL FIX: Hide the Bootstrap modal temporarily
            // This is what's stealing focus!
            $('#patientDetailsModal').modal('hide');
            console.log('Hid Bootstrap modal');
            
            // Wait for modal to fully close before showing SweetAlert
            setTimeout(function() {
                showMedicationSweetAlert();
            }, 500);
        }

        function showMedicationSweetAlert() {
            console.log('=== showMedicationSweetAlert ===');
            
            // Remove aria-hidden from form to fix focus issue
            $('form').removeAttr('aria-hidden');
            console.log('Removed aria-hidden from form');
            
            Swal.fire({
                title: '<i class="fas fa-pills"></i> Add New Medication',
                html: `
                    <div class="text-left">
                        <div class="form-group">
                            <label>Medication Name *</label>
                            <input type="text" id="swal-medName" class="form-control" placeholder="Enter medication name">
                        </div>
                        <div class="form-group">
                            <label>Dosage</label>
                            <input type="text" id="swal-dosage" class="form-control" placeholder="e.g., 500mg">
                        </div>
                        <div class="form-group">
                            <label>Frequency</label>
                            <input type="text" id="swal-frequency" class="form-control" placeholder="e.g., 3 times daily">
                        </div>
                        <div class="form-group">
                            <label>Duration</label>
                            <input type="text" id="swal-duration" class="form-control" placeholder="e.g., 7 days">
                        </div>
                        <div class="form-group">
                            <label>Special Instructions</label>
                            <textarea id="swal-instructions" class="form-control" rows="2" placeholder="e.g., Take after meals"></textarea>
                        </div>
                    </div>
                `,
                width: '600px',
                showCancelButton: true,
                confirmButtonText: '<i class="fas fa-save"></i> Add Medication',
                cancelButtonText: 'Cancel',
                allowOutsideClick: false,
                allowEscapeKey: true,
                didOpen: function() {
                    console.log('=== SweetAlert didOpen callback ===');
                    
                    // Log all elements with aria-hidden
                    var ariaHiddenElements = $('[aria-hidden="true"]');
                    console.log('Elements with aria-hidden=true:', ariaHiddenElements.length);
                    ariaHiddenElements.each(function() {
                        console.log('  - ', this.tagName, this.id || this.className);
                    });
                    
                    // AGGRESSIVE FIX: Remove modal-backdrop that's blocking input
                    $('.modal-backdrop').remove();
                    console.log('Removed modal-backdrop');
                    
                    // Remove aria-hidden from ALL elements
                    $('[aria-hidden="true"]').removeAttr('aria-hidden');
                    $('.swal2-container').parents().removeAttr('aria-hidden');
                    $('form').removeAttr('aria-hidden');
                    $('body').removeAttr('aria-hidden');
                    console.log('Removed aria-hidden from all elements');
                    
                    // Remove any inert attribute
                    $('[inert]').removeAttr('inert');
                    
                    // Check if inputs exist
                    var medNameInput = $('#swal-medName');
                    console.log('Medication name input found:', medNameInput.length > 0);
                    console.log('Input is disabled:', medNameInput.prop('disabled'));
                    console.log('Input is readonly:', medNameInput.prop('readonly'));
                    console.log('Input has tabindex:', medNameInput.attr('tabindex'));
                    
                    // Make inputs explicitly focusable
                    $('#swal-medName, #swal-dosage, #swal-frequency, #swal-duration, #swal-instructions')
                        .attr('tabindex', '0')
                        .css('pointer-events', 'auto');
                    
                    // Focus on first input with multiple attempts
                    setTimeout(function() {
                        console.log('Attempting to focus on medication name input');
                        var input = $('#swal-medName')[0];
                        if (input) {
                            input.focus();
                            input.click(); // Also try clicking
                        }
                        console.log('Active element after focus:', document.activeElement.tagName, document.activeElement.id);
                    }, 100);
                    
                    // Keep trying to remove modal backdrop
                    var backdropInterval = setInterval(function() {
                        $('.modal-backdrop').remove();
                        $('[aria-hidden="true"]').removeAttr('aria-hidden');
                    }, 100);
                    
                    // Stop after 2 seconds
                    setTimeout(function() {
                        clearInterval(backdropInterval);
                    }, 2000);
                },
                preConfirm: function() {
                    console.log('=== preConfirm called ===');
                    var medName = $('#swal-medName').val().trim();
                    console.log('Medication name value:', medName);
                    if (!medName) {
                        console.log('ERROR: Medication name is empty');
                        Swal.showValidationMessage('Medication name is required');
                        return false;
                    }
                    var data = {
                        medName: medName,
                        dosage: $('#swal-dosage').val().trim(),
                        frequency: $('#swal-frequency').val().trim(),
                        duration: $('#swal-duration').val().trim(),
                        instructions: $('#swal-instructions').val().trim()
                    };
                    console.log('Medication data:', data);
                    return data;
                }
            }).then(function(result) {
                console.log('=== SweetAlert then callback ===');
                console.log('Result:', result);
                if (result.isConfirmed) {
                    console.log('Confirmed, adding medication');
                    addNewMedication(result.value);
                }
                
                // Re-show the Bootstrap modal after SweetAlert closes
                setTimeout(function() {
                    $('#patientDetailsModal').modal('show');
                    console.log('Re-showed Bootstrap modal');
                }, 100);
            });
            
            // Ensure form is accessible after modal closes
            setTimeout(function() {
                console.log('Cleanup: Removing aria-hidden from form');
                $('form').removeAttr('aria-hidden');
            }, 100);
        }

        // Event delegation for Edit and Delete buttons
        $(document).on('click', '.edit-med-btn', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            var medid = $(this).data('medid');
            var name = $(this).data('name');
            var dosage = $(this).data('dosage');
            var frequency = $(this).data('frequency');
            var duration = $(this).data('duration');
            var inst = $(this).data('inst');
            
            showEditMedication(medid, name, dosage, frequency, duration, inst);
            return false;
        });
        
        $(document).on('click', '.delete-med-btn', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            var medid = $(this).data('medid');
            var name = $(this).data('name');
            
            deleteMedication(medid, name);
            return false;
        });

        function showEditMedication(medid, name, dosage, frequency, duration, inst) {
            // Close the patient details modal first
            $('#patientDetailsModal').modal('hide');
            
            // Wait for modal to close before showing edit dialog
            setTimeout(function() {
                Swal.fire({
                title: '<i class="fas fa-edit"></i> Edit Medication',
                html: `
                    <div class="text-left">
                        <div class="form-group mb-3">
                            <label>Medication Name *</label>
                            <input type="text" id="edit-med-name" class="form-control" value="${name}" required>
                        </div>
                        <div class="form-group mb-3">
                            <label>Dosage *</label>
                            <input type="text" id="edit-dosage" class="form-control" value="${dosage}" required>
                        </div>
                        <div class="form-group mb-3">
                            <label>Frequency *</label>
                            <input type="text" id="edit-frequency" class="form-control" value="${frequency}" required>
                        </div>
                        <div class="form-group mb-3">
                            <label>Duration *</label>
                            <input type="text" id="edit-duration" class="form-control" value="${duration}" required>
                        </div>
                        <div class="form-group mb-3">
                            <label>Special Instructions</label>
                            <textarea id="edit-special-inst" class="form-control" rows="3">${inst}</textarea>
                        </div>
                    </div>
                `,
                width: '600px',
                showCancelButton: true,
                confirmButtonText: '<i class="fas fa-save"></i> Update Medication',
                cancelButtonText: 'Cancel',
                preConfirm: function() {
                    var medName = $('#edit-med-name').val().trim();
                    var medDosage = $('#edit-dosage').val().trim();
                    var medFrequency = $('#edit-frequency').val().trim();
                    var medDuration = $('#edit-duration').val().trim();
                    var specialInst = $('#edit-special-inst').val().trim();
                    
                    if (!medName) {
                        Swal.showValidationMessage('Medication name is required');
                        return false;
                    }
                    if (!medDosage) {
                        Swal.showValidationMessage('Dosage is required');
                        return false;
                    }
                    if (!medFrequency) {
                        Swal.showValidationMessage('Frequency is required');
                        return false;
                    }
                    if (!medDuration) {
                        Swal.showValidationMessage('Duration is required');
                        return false;
                    }
                    
                    return {
                        medid: medid,
                        med_name: medName,
                        dosage: medDosage,
                        frequency: medFrequency,
                        duration: medDuration,
                        special_inst: specialInst
                    };
                }
                }).then(function(result) {
                    if (result.isConfirmed) {
                        updateMedication(result.value);
                    } else {
                        // If user cancels, reopen the patient details modal
                        $('#patientDetailsModal').modal('show');
                    }
                });
            }, 300); // Wait 300ms for modal to close
        }

        function updateMedication(medData) {
            $.ajax({
                url: 'doctor_inpatient.aspx/UpdateMedication',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(medData),
                success: function(response) {
                    if (response.d === 'true') {
                        Swal.fire({
                            title: 'Success',
                            text: 'Medication updated successfully',
                            icon: 'success',
                            timer: 1500,
                            showConfirmButton: false
                        }).then(function() {
                            // Reload medications
                            loadMedications(currentPatient.prescid);
                            // Reopen patient details modal
                            $('#patientDetailsModal').modal('show');
                        });
                    } else {
                        Swal.fire('Error', 'Failed to update medication', 'error').then(function() {
                            $('#patientDetailsModal').modal('show');
                        });
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Update error:', xhr.responseText);
                    Swal.fire('Error', 'An error occurred while updating: ' + error, 'error').then(function() {
                        $('#patientDetailsModal').modal('show');
                    });
                }
            });
        }

        function deleteMedication(medid, name) {
            // Close the patient details modal first
            $('#patientDetailsModal').modal('hide');
            
            // Wait for modal to close before showing delete dialog
            setTimeout(function() {
                Swal.fire({
                title: 'Delete Medication?',
                html: '<p>Are you sure you want to delete <strong>' + name + '</strong>?</p><p class="text-danger"><i class="fas fa-exclamation-triangle"></i> This action cannot be undone.</p>',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: '<i class="fas fa-trash"></i> Yes, Delete',
                cancelButtonText: 'Cancel',
                confirmButtonColor: '#dc3545',
                cancelButtonColor: '#6c757d'
                }).then(function(result) {
                    if (result.isConfirmed) {
                        $.ajax({
                            url: 'doctor_inpatient.aspx/DeleteMedication',
                            method: 'POST',
                            contentType: 'application/json',
                            data: JSON.stringify({ medid: medid }),
                            success: function(response) {
                                if (response.d === 'true') {
                                    Swal.fire({
                                        title: 'Deleted!',
                                        text: 'Medication has been deleted successfully',
                                        icon: 'success',
                                        timer: 1500,
                                        showConfirmButton: false
                                    }).then(function() {
                                        // Reload medications
                                        loadMedications(currentPatient.prescid);
                                        // Reopen patient details modal
                                        $('#patientDetailsModal').modal('show');
                                    });
                                } else {
                                    Swal.fire('Error', 'Failed to delete medication', 'error').then(function() {
                                        $('#patientDetailsModal').modal('show');
                                    });
                                }
                            },
                            error: function(xhr, status, error) {
                                console.error('Delete error:', xhr.responseText);
                                Swal.fire('Error', 'An error occurred while deleting: ' + error, 'error').then(function() {
                                    $('#patientDetailsModal').modal('show');
                                });
                            }
                        });
                    } else {
                        // If user cancels, reopen the patient details modal
                        $('#patientDetailsModal').modal('show');
                    }
                });
            }, 300); // Wait 300ms for modal to close
        }

        function addNewMedication(medData) {
            $.ajax({
                url: 'doctor_inpatient.aspx/AddMedication',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    prescid: currentPatient.prescid,
                    medName: medData.medName,
                    dosage: medData.dosage,
                    frequency: medData.frequency,
                    duration: medData.duration,
                    specialInst: medData.instructions
                }),
                success: function(response) {
                    if (response.d === 'success') {
                        Swal.fire('Success', 'Medication added successfully', 'success');
                        loadMedications(currentPatient.prescid);
                    } else {
                        Swal.fire('Error', response.d, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    Swal.fire('Error', 'Failed to add medication: ' + error, 'error');
                }
            });
        }

        function showOrderLabTests() {
            if (!currentPatient) return;
            
            // First check if there's an existing editable order
            $.ajax({
                url: 'doctor_inpatient.aspx/CheckExistingOrder',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ prescid: currentPatient.prescid }),
                success: function(response) {
                    var orderInfo = response.d;
                    
                    if (orderInfo.hasOrder && orderInfo.canEdit) {
                        // Existing editable order found
                        Swal.fire({
                            icon: 'info',
                            title: 'Existing Lab Order Found',
                            html: '<p>You have an existing lab order that hasn\'t been processed yet.</p>' +
                                  '<p><strong>Status:</strong> ' + (orderInfo.isPaid ? 'Paid - Awaiting Lab Processing' : 'Unpaid - Can Edit') + '</p>' +
                                  '<p>Would you like to:</p>',
                            showDenyButton: true,
                            showCancelButton: true,
                            confirmButtonText: '<i class="fas fa-plus"></i> Add Tests to Existing Order',
                            denyButtonText: '<i class="fas fa-file-medical"></i> Create New Order',
                            cancelButtonText: 'Cancel'
                        }).then(function(result) {
                            if (result.isConfirmed) {
                                // Add to existing order
                                showAddTestsToOrder(orderInfo.orderId);
                            } else if (result.isDenied) {
                                // User wants new order - show warning
                                Swal.fire({
                                    icon: 'warning',
                                    title: 'Create New Order?',
                                    text: 'Creating a new order will generate a new charge. Are you sure you don\'t want to add tests to the existing order?',
                                    showCancelButton: true,
                                    confirmButtonText: 'Yes, Create New Order'
                                }).then(function(confirm) {
                                    if (confirm.isConfirmed) {
                                        showOrderLabTestsForm(false, null);
                                    }
                                });
                            }
                        });
                    } else if (orderInfo.hasOrder && !orderInfo.canEdit) {
                        // Order exists but has been processed
                        Swal.fire({
                            icon: 'info',
                            title: 'Previous Order Completed',
                            text: 'Your previous lab order has been processed. This will create a new order with a new charge.',
                            confirmButtonText: 'Continue'
                        }).then(function() {
                            showOrderLabTestsForm(true, null);
                        });
                    } else {
                        // No existing order
                        showOrderLabTestsForm(false, null);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error checking order:', error);
                    showOrderLabTestsForm(false, null);
                }
            });
        }
        
        function showAddTestsToOrder(orderId) {
            // First, get the existing tests for this order
            $.ajax({
                url: 'doctor_inpatient.aspx/GetOrderTests',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ orderId: orderId }),
                success: function (response) {
                    console.log(response);
                    var existingTests = response.d || [];
                    showEditOrderModal(orderId, existingTests);
                },
                error: function(xhr, status, error) {
                    console.error('Error loading order tests:', error);
                    Swal.fire('Error', 'Failed to load existing tests', 'error');
                }
            });
        }
        
        function showEditOrderModal(orderId, existingTests) {
            Swal.fire({
                title: '<i class="fas fa-edit"></i> Edit Lab Order #' + orderId,
                html: `
                    <div class="text-left" style="max-height: 500px; overflow-y: auto;">
                        <p class="text-muted"><strong>Edit tests for this order.</strong> Check/uncheck tests to modify the order:</p>
                        <div class="row">
                            <div class="col-md-4">
                                <h6 class="text-primary">Hematology</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Hemoglobin" value="Hemoglobin"><label class="form-check-label" for="lab-Hemoglobin">Hemoglobin</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Hemoglobin_A1c" value="Hemoglobin_A1c"><label class="form-check-label" for="lab-Hemoglobin_A1c">Hemoglobin A1c</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Malaria" value="Malaria"><label class="form-check-label" for="lab-Malaria">Malaria</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-ESR" value="ESR"><label class="form-check-label" for="lab-ESR">ESR</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Blood_grouping" value="Blood_grouping"><label class="form-check-label" for="lab-Blood_grouping">Blood Grouping</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Blood_sugar" value="Blood_sugar"><label class="form-check-label" for="lab-Blood_sugar">Blood Sugar</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Fasting_blood_sugar" value="Fasting_blood_sugar"><label class="form-check-label" for="lab-Fasting_blood_sugar">Fasting Blood Sugar</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-CBC" value="CBC"><label class="form-check-label" for="lab-CBC">CBC</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Cross_matching" value="Cross_matching"><label class="form-check-label" for="lab-Cross_matching">Cross Matching</label></div>
                                
                                <h6 class="text-primary mt-3">Liver Function</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-SGPT_ALT" value="SGPT_ALT"><label class="form-check-label" for="lab-SGPT_ALT">SGPT (ALT)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-SGOT_AST" value="SGOT_AST"><label class="form-check-label" for="lab-SGOT_AST">SGOT (AST)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Alkaline_phosphates_ALP" value="Alkaline_phosphates_ALP"><label class="form-check-label" for="lab-Alkaline_phosphates_ALP">ALP</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Total_bilirubin" value="Total_bilirubin"><label class="form-check-label" for="lab-Total_bilirubin">Total Bilirubin</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Direct_bilirubin" value="Direct_bilirubin"><label class="form-check-label" for="lab-Direct_bilirubin">Direct Bilirubin</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Albumin" value="Albumin"><label class="form-check-label" for="lab-Albumin">Albumin</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-JGlobulin" value="JGlobulin"><label class="form-check-label" for="lab-JGlobulin">Globulin</label></div>

                                <h6 class="text-primary mt-3">Lipid Profile</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Low_density_lipoprotein_LDL" value="Low_density_lipoprotein_LDL"><label class="form-check-label" for="lab-Low_density_lipoprotein_LDL">LDL</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-High_density_lipoprotein_HDL" value="High_density_lipoprotein_HDL"><label class="form-check-label" for="lab-High_density_lipoprotein_HDL">HDL</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Total_cholesterol" value="Total_cholesterol"><label class="form-check-label" for="lab-Total_cholesterol">Total Cholesterol</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Triglycerides" value="Triglycerides"><label class="form-check-label" for="lab-Triglycerides">Triglycerides</label></div>
                            </div>
                            
                            <div class="col-md-4">
                                <h6 class="text-primary">Immunology/Virology</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-TPHA" value="TPHA"><label class="form-check-label" for="lab-TPHA">TPHA</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Human_immune_deficiency_HIV" value="Human_immune_deficiency_HIV"><label class="form-check-label" for="lab-Human_immune_deficiency_HIV">HIV</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Hepatitis_B_virus_HBV" value="Hepatitis_B_virus_HBV"><label class="form-check-label" for="lab-Hepatitis_B_virus_HBV">Hepatitis B</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Hepatitis_C_virus_HCV" value="Hepatitis_C_virus_HCV"><label class="form-check-label" for="lab-Hepatitis_C_virus_HCV">Hepatitis C</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Brucella_melitensis" value="Brucella_melitensis"><label class="form-check-label" for="lab-Brucella_melitensis">Brucella Melitensis</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Brucella_abortus" value="Brucella_abortus"><label class="form-check-label" for="lab-Brucella_abortus">Brucella Abortus</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-C_reactive_protein_CRP" value="C_reactive_protein_CRP"><label class="form-check-label" for="lab-C_reactive_protein_CRP">C-Reactive Protein (CRP)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Rheumatoid_factor_RF" value="Rheumatoid_factor_RF"><label class="form-check-label" for="lab-Rheumatoid_factor_RF">Rheumatoid Factor (RF)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Antistreptolysin_O_ASO" value="Antistreptolysin_O_ASO"><label class="form-check-label" for="lab-Antistreptolysin_O_ASO">ASO</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Toxoplasmosis" value="Toxoplasmosis"><label class="form-check-label" for="lab-Toxoplasmosis">Toxoplasmosis</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Typhoid_hCG" value="Typhoid_hCG"><label class="form-check-label" for="lab-Typhoid_hCG">Typhoid (hCG)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Hpylori_antibody" value="Hpylori_antibody"><label class="form-check-label" for="lab-Hpylori_antibody">H.pylori Antibody</label></div>

                                <h6 class="text-primary mt-3">Renal Profile</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Urea" value="Urea"><label class="form-check-label" for="lab-Urea">Urea</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Creatinine" value="Creatinine"><label class="form-check-label" for="lab-Creatinine">Creatinine</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Uric_acid" value="Uric_acid"><label class="form-check-label" for="lab-Uric_acid">Uric Acid</label></div>
                                
                                <h6 class="text-primary mt-3">Electrolytes</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Sodium" value="Sodium"><label class="form-check-label" for="lab-Sodium">Sodium</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Potassium" value="Potassium"><label class="form-check-label" for="lab-Potassium">Potassium</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Chloride" value="Chloride"><label class="form-check-label" for="lab-Chloride">Chloride</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Calcium" value="Calcium"><label class="form-check-label" for="lab-Calcium">Calcium</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Phosphorous" value="Phosphorous"><label class="form-check-label" for="lab-Phosphorous">Phosphorous</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Magnesium" value="Magnesium"><label class="form-check-label" for="lab-Magnesium">Magnesium</label></div>
                            </div>

                            <div class="col-md-4">
                                <h6 class="text-primary">Thyroid Profile</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Thyroid_profile" value="Thyroid_profile"><label class="form-check-label" for="lab-Thyroid_profile">Thyroid Profile</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Triiodothyronine_T3" value="Triiodothyronine_T3"><label class="form-check-label" for="lab-Triiodothyronine_T3">T3</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Thyroxine_T4" value="Thyroxine_T4"><label class="form-check-label" for="lab-Thyroxine_T4">T4</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Thyroid_stimulating_hormone_TSH" value="Thyroid_stimulating_hormone_TSH"><label class="form-check-label" for="lab-Thyroid_stimulating_hormone_TSH">TSH</label></div>

                                <h6 class="text-primary mt-3">Pancreatic</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Amylase" value="Amylase"><label class="form-check-label" for="lab-Amylase">Amylase</label></div>

                                <h6 class="text-primary mt-3">Stool Tests</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Stool_occult_blood" value="Stool_occult_blood"><label class="form-check-label" for="lab-Stool_occult_blood">Stool Occult Blood</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-General_stool_examination" value="General_stool_examination"><label class="form-check-label" for="lab-General_stool_examination">General Stool Examination</label></div>

                                <h6 class="text-primary mt-3">Hormone Tests</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Progesterone_Female" value="Progesterone_Female"><label class="form-check-label" for="lab-Progesterone_Female">Progesterone (Female)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Follicle_stimulating_hormone_FSH" value="Follicle_stimulating_hormone_FSH"><label class="form-check-label" for="lab-Follicle_stimulating_hormone_FSH">FSH</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Estradiol" value="Estradiol"><label class="form-check-label" for="lab-Estradiol">Estradiol</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Luteinizing_hormone_LH" value="Luteinizing_hormone_LH"><label class="form-check-label" for="lab-Luteinizing_hormone_LH">Luteinizing Hormone (LH)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Testosterone_Male" value="Testosterone_Male"><label class="form-check-label" for="lab-Testosterone_Male">Testosterone (Male)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Prolactin" value="Prolactin"><label class="form-check-label" for="lab-Prolactin">Prolactin</label></div>

                                <h6 class="text-primary mt-3">Additional Tests</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Stool_examination" value="Stool_examination"><label class="form-check-label" for="lab-Stool_examination">Stool Examination</label></div>

                                <h6 class="text-primary mt-3">Specialized Tests</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Seminal_Fluid_Analysis_Male_B_HCG" value="Seminal_Fluid_Analysis_Male_B_HCG"><label class="form-check-label" for="lab-Seminal_Fluid_Analysis_Male_B_HCG">Seminal Fluid Analysis (Male)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Sperm_examination" value="Sperm_examination"><label class="form-check-label" for="lab-Sperm_examination">Sperm Examination</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Virginal_swab_trichomonas_virginals" value="Virginal_swab_trichomonas_virginals"><label class="form-check-label" for="lab-Virginal_swab_trichomonas_virginals">Virginal Swab & Trichomonas Virginals</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Urine_examination" value="Urine_examination"><label class="form-check-label" for="lab-Urine_examination">Urine Examination</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-General_urine_examination" value="General_urine_examination"><label class="form-check-label" for="lab-General_urine_examination">General Urine Examination</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Human_chorionic_gonadotropin_hCG" value="Human_chorionic_gonadotropin_hCG"><label class="form-check-label" for="lab-Human_chorionic_gonadotropin_hCG">Human Chorionic Gonadotropin (hCG)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Hpylori_Ag_stool" value="Hpylori_Ag_stool"><label class="form-check-label" for="lab-Hpylori_Ag_stool">H.pylori Ag (stool)</label></div>

                                <h6 class="text-primary mt-3">Cardiac Markers</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Troponin_I" value="Troponin_I"><label class="form-check-label" for="lab-Troponin_I">Troponin I (Cardiac marker)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-CK_MB" value="CK_MB"><label class="form-check-label" for="lab-CK_MB">CK-MB (Creatine Kinase-MB)</label></div>

                                <h6 class="text-primary mt-3">Coagulation Tests</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-aPTT" value="aPTT"><label class="form-check-label" for="lab-aPTT">aPTT (Activated Partial Thromboplastin Time)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-INR" value="INR"><label class="form-check-label" for="lab-INR">INR (International Normalized Ratio)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-D_Dimer" value="D_Dimer"><label class="form-check-label" for="lab-D_Dimer">D-Dimer</label></div>

                                <h6 class="text-primary mt-3">Vitamins & Minerals</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Vitamin_D" value="Vitamin_D"><label class="form-check-label" for="lab-Vitamin_D">Vitamin D</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Vitamin_B12" value="Vitamin_B12"><label class="form-check-label" for="lab-Vitamin_B12">Vitamin B12</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Ferritin" value="Ferritin"><label class="form-check-label" for="lab-Ferritin">Ferritin (Iron storage)</label></div>

                                <h6 class="text-primary mt-3">Additional Infectious Disease Tests</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-VDRL" value="VDRL"><label class="form-check-label" for="lab-VDRL">VDRL (Syphilis test)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Dengue_Fever_IgG_IgM" value="Dengue_Fever_IgG_IgM"><label class="form-check-label" for="lab-Dengue_Fever_IgG_IgM">Dengue Fever (IgG/IgM)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Gonorrhea_Ag" value="Gonorrhea_Ag"><label class="form-check-label" for="lab-Gonorrhea_Ag">Gonorrhea Ag</label></div>

                                <h6 class="text-primary mt-3">Tumor Markers</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-AFP" value="AFP"><label class="form-check-label" for="lab-AFP">AFP (Alpha-fetoprotein)</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Total_PSA" value="Total_PSA"><label class="form-check-label" for="lab-Total_PSA">Total PSA (Prostate-Specific Antigen)</label></div>

                                <h6 class="text-primary mt-3">Additional Fertility Tests</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-AMH" value="AMH"><label class="form-check-label" for="lab-AMH">AMH (Anti-Müllerian Hormone)</label></div>
                                
                                <h6 class="text-primary mt-3">New Tests</h6>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Electrolyte_Test" value="Electrolyte_Test"><label class="form-check-label" for="lab-Electrolyte_Test">Electrolyte Test</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-CRP_Titer" value="CRP_Titer"><label class="form-check-label" for="lab-CRP_Titer">CRP Titer</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Ultra" value="Ultra"><label class="form-check-label" for="lab-Ultra">Ultra</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Typhoid_IgG" value="Typhoid_IgG"><label class="form-check-label" for="lab-Typhoid_IgG">Typhoid IgG</label></div>
                                <div class="form-check"><input class="form-check-input lab-test-checkbox" type="checkbox" id="lab-Typhoid_Ag" value="Typhoid_Ag"><label class="form-check-label" for="lab-Typhoid_Ag">Typhoid Ag</label></div>
                            </div>
                        </div>
                        <div class="form-group mt-3">
                            <label>Notes/Reason (Optional)</label>
                            <textarea id="order-notes" class="form-control" rows="2" placeholder="Enter any notes or reason for ordering"></textarea>
                        </div>
                    </div>
                `,
                width: '800px',
                showCancelButton: true,
                confirmButtonText: '<i class="fas fa-save"></i> Update Order',
                cancelButtonText: 'Cancel',
                didOpen: function() {
                    // Pre-check the existing tests
                    existingTests.forEach(function(test) {
                        var checkbox = $('#lab-' + test);
                        if (checkbox.length > 0) {
                            checkbox.prop('checked', true);
                        }
                    });
                },
                preConfirm: function() {
                    var selectedTests = [];
                    $('input[id^="lab-"]:checked').each(function() {
                        selectedTests.push($(this).val());
                    });
                    
                    var notes = $('#order-notes').val().trim();
                    
                    if (selectedTests.length === 0) {
                        Swal.showValidationMessage('Please select at least one test');
                        return false;
                    }
                    
                    return { tests: selectedTests, notes: notes, orderId: orderId };
                }
            }).then(function(result) {
                if (result.isConfirmed) {
                    updateLabOrder(result.value);
                }
            });
        }
        
        function showOrderLabTestsForm(isReorder, orderId) {
            Swal.fire({
                title: '<i class="fas fa-flask"></i> Order Lab Tests',
                html: `
                    <div class="text-left" style="max-height: 500px; overflow-y: auto;">
                        <p class="text-muted">Select the tests to order:</p>
                        <div class="row">
                            <div class="col-md-6">
                                <h6 class="text-primary">Hematology</h6>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Hemoglobin" value="Hemoglobin"><label class="form-check-label" for="lab-Hemoglobin">Hemoglobin</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Hemoglobin_A1c" value="Hemoglobin_A1c"><label class="form-check-label" for="lab-Hemoglobin_A1c">Hemoglobin A1c</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Malaria" value="Malaria"><label class="form-check-label" for="lab-Malaria">Malaria</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-ESR" value="ESR"><label class="form-check-label" for="lab-ESR">ESR</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Blood_grouping" value="Blood_grouping"><label class="form-check-label" for="lab-Blood_grouping">Blood Grouping</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Blood_sugar" value="Blood_sugar"><label class="form-check-label" for="lab-Blood_sugar">Blood Sugar</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Fasting_blood_sugar" value="Fasting_blood_sugar"><label class="form-check-label" for="lab-Fasting_blood_sugar">Fasting Blood Sugar</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-CBC" value="CBC"><label class="form-check-label" for="lab-CBC">CBC</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Cross_matching" value="Cross_matching"><label class="form-check-label" for="lab-Cross_matching">Cross Matching</label></div>
                                
                                <h6 class="text-primary mt-3">Immunology/Virology</h6>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-TPHA" value="TPHA"><label class="form-check-label" for="lab-TPHA">TPHA</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Human_immune_deficiency_HIV" value="Human_immune_deficiency_HIV"><label class="form-check-label" for="lab-Human_immune_deficiency_HIV">HIV</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Hepatitis_B_virus_HBV" value="Hepatitis_B_virus_HBV"><label class="form-check-label" for="lab-Hepatitis_B_virus_HBV">Hepatitis B</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Hepatitis_C_virus_HCV" value="Hepatitis_C_virus_HCV"><label class="form-check-label" for="lab-Hepatitis_C_virus_HCV">Hepatitis C</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Brucella_melitensis" value="Brucella_melitensis"><label class="form-check-label" for="lab-Brucella_melitensis">Brucella Melitensis</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Brucella_abortus" value="Brucella_abortus"><label class="form-check-label" for="lab-Brucella_abortus">Brucella Abortus</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-C_reactive_protein_CRP" value="C_reactive_protein_CRP"><label class="form-check-label" for="lab-C_reactive_protein_CRP">C-Reactive Protein (CRP)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Rheumatoid_factor_RF" value="Rheumatoid_factor_RF"><label class="form-check-label" for="lab-Rheumatoid_factor_RF">Rheumatoid Factor (RF)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Antistreptolysin_O_ASO" value="Antistreptolysin_O_ASO"><label class="form-check-label" for="lab-Antistreptolysin_O_ASO">ASO</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Toxoplasmosis" value="Toxoplasmosis"><label class="form-check-label" for="lab-Toxoplasmosis">Toxoplasmosis</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Typhoid_hCG" value="Typhoid_hCG"><label class="form-check-label" for="lab-Typhoid_hCG">Typhoid (hCG)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Hpylori_antibody" value="Hpylori_antibody"><label class="form-check-label" for="lab-Hpylori_antibody">H.pylori Antibody</label></div>
                                
                                <h6 class="text-primary mt-3">Lipid Profile</h6>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Low_density_lipoprotein_LDL" value="Low_density_lipoprotein_LDL"><label class="form-check-label" for="lab-Low_density_lipoprotein_LDL">LDL</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-High_density_lipoprotein_HDL" value="High_density_lipoprotein_HDL"><label class="form-check-label" for="lab-High_density_lipoprotein_HDL">HDL</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Total_cholesterol" value="Total_cholesterol"><label class="form-check-label" for="lab-Total_cholesterol">Total Cholesterol</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Triglycerides" value="Triglycerides"><label class="form-check-label" for="lab-Triglycerides">Triglycerides</label></div>
                            </div>
                            
                            <div class="col-md-6">
                                <h6 class="text-primary">Thyroid Profile</h6>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Thyroid_profile" value="Thyroid_profile"><label class="form-check-label" for="lab-Thyroid_profile">Thyroid Profile</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Triiodothyronine_T3" value="Triiodothyronine_T3"><label class="form-check-label" for="lab-Triiodothyronine_T3">T3</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Thyroxine_T4" value="Thyroxine_T4"><label class="form-check-label" for="lab-Thyroxine_T4">T4</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Thyroid_stimulating_hormone_TSH" value="Thyroid_stimulating_hormone_TSH"><label class="form-check-label" for="lab-Thyroid_stimulating_hormone_TSH">TSH</label></div>

                                <h6 class="text-primary mt-3">Liver Function</h6>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-SGPT_ALT" value="SGPT_ALT"><label class="form-check-label" for="lab-SGPT_ALT">SGPT (ALT)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-SGOT_AST" value="SGOT_AST"><label class="form-check-label" for="lab-SGOT_AST">SGOT (AST)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Alkaline_phosphates_ALP" value="Alkaline_phosphates_ALP"><label class="form-check-label" for="lab-Alkaline_phosphates_ALP">ALP</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Total_bilirubin" value="Total_bilirubin"><label class="form-check-label" for="lab-Total_bilirubin">Total Bilirubin</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Direct_bilirubin" value="Direct_bilirubin"><label class="form-check-label" for="lab-Direct_bilirubin">Direct Bilirubin</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Albumin" value="Albumin"><label class="form-check-label" for="lab-Albumin">Albumin</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-JGlobulin" value="JGlobulin"><label class="form-check-label" for="lab-JGlobulin">JGlobulin</label></div>
                                
                                <h6 class="text-primary mt-3">Renal Profile</h6>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Urea" value="Urea"><label class="form-check-label" for="lab-Urea">Urea</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Creatinine" value="Creatinine"><label class="form-check-label" for="lab-Creatinine">Creatinine</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Uric_acid" value="Uric_acid"><label class="form-check-label" for="lab-Uric_acid">Uric Acid</label></div>
                                
                                <h6 class="text-primary mt-3">Electrolytes</h6>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Sodium" value="Sodium"><label class="form-check-label" for="lab-Sodium">Sodium</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Potassium" value="Potassium"><label class="form-check-label" for="lab-Potassium">Potassium</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Chloride" value="Chloride"><label class="form-check-label" for="lab-Chloride">Chloride</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Calcium" value="Calcium"><label class="form-check-label" for="lab-Calcium">Calcium</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Phosphorous" value="Phosphorous"><label class="form-check-label" for="lab-Phosphorous">Phosphorous</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Magnesium" value="Magnesium"><label class="form-check-label" for="lab-Magnesium">Magnesium</label></div>
                                
                                <h6 class="text-primary mt-3">Pancreatic</h6>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Amylase" value="Amylase"><label class="form-check-label" for="lab-Amylase">Amylase</label></div>

                                <h6 class="text-primary mt-3">Stool Tests</h6>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Stool_occult_blood" value="Stool_occult_blood"><label class="form-check-label" for="lab-Stool_occult_blood">Stool Occult Blood</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-General_stool_examination" value="General_stool_examination"><label class="form-check-label" for="lab-General_stool_examination">General Stool Examination</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Stool_examination" value="Stool_examination"><label class="form-check-label" for="lab-Stool_examination">Stool Examination</label></div>

                                <h6 class="text-primary mt-3">Hormone Tests</h6>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Progesterone_Female" value="Progesterone_Female"><label class="form-check-label" for="lab-Progesterone_Female">Progesterone (Female)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Follicle_stimulating_hormone_FSH" value="Follicle_stimulating_hormone_FSH"><label class="form-check-label" for="lab-Follicle_stimulating_hormone_FSH">FSH</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Estradiol" value="Estradiol"><label class="form-check-label" for="lab-Estradiol">Estradiol</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Luteinizing_hormone_LH" value="Luteinizing_hormone_LH"><label class="form-check-label" for="lab-Luteinizing_hormone_LH">Luteinizing Hormone (LH)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Testosterone_Male" value="Testosterone_Male"><label class="form-check-label" for="lab-Testosterone_Male">Testosterone (Male)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Prolactin" value="Prolactin"><label class="form-check-label" for="lab-Prolactin">Prolactin</label></div>

                                <h6 class="text-primary mt-3">Specialized Tests</h6>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Seminal_Fluid_Analysis_Male_B_HCG" value="Seminal_Fluid_Analysis_Male_B_HCG"><label class="form-check-label" for="lab-Seminal_Fluid_Analysis_Male_B_HCG">Seminal Fluid Analysis (Male)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Sperm_examination" value="Sperm_examination"><label class="form-check-label" for="lab-Sperm_examination">Sperm Examination</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Virginal_swab_trichomonas_virginals" value="Virginal_swab_trichomonas_virginals"><label class="form-check-label" for="lab-Virginal_swab_trichomonas_virginals">Virginal Swab & Trichomonas Virginals</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Urine_examination" value="Urine_examination"><label class="form-check-label" for="lab-Urine_examination">Urine Examination</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-General_urine_examination" value="General_urine_examination"><label class="form-check-label" for="lab-General_urine_examination">General Urine Examination</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Human_chorionic_gonadotropin_hCG" value="Human_chorionic_gonadotropin_hCG"><label class="form-check-label" for="lab-Human_chorionic_gonadotropin_hCG">Human Chorionic Gonadotropin (hCG)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Hpylori_Ag_stool" value="Hpylori_Ag_stool"><label class="form-check-label" for="lab-Hpylori_Ag_stool">H.pylori Ag (stool)</label></div>
                                
                                <h6 class="text-primary mt-3">Additional Tests</h6>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-VDRL" value="VDRL"><label class="form-check-label" for="lab-VDRL">VDRL (Syphilis test)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Dengue_Fever_IgG_IgM" value="Dengue_Fever_IgG_IgM"><label class="form-check-label" for="lab-Dengue_Fever_IgG_IgM">Dengue Fever (IgG/IgM)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Gonorrhea_Ag" value="Gonorrhea_Ag"><label class="form-check-label" for="lab-Gonorrhea_Ag">Gonorrhea Ag</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-AFP" value="AFP"><label class="form-check-label" for="lab-AFP">AFP (Alpha-fetoprotein)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Total_PSA" value="Total_PSA"><label class="form-check-label" for="lab-Total_PSA">Total PSA (Prostate-Specific Antigen)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-AMH" value="AMH"><label class="form-check-label" for="lab-AMH">AMH (Anti-Müllerian Hormone)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Electrolyte_Test" value="Electrolyte_Test"><label class="form-check-label" for="lab-Electrolyte_Test">Electrolyte Test</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-CRP_Titer" value="CRP_Titer"><label class="form-check-label" for="lab-CRP_Titer">CRP Titer</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Ultra" value="Ultra"><label class="form-check-label" for="lab-Ultra">Ultra</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Typhoid_IgG" value="Typhoid_IgG"><label class="form-check-label" for="lab-Typhoid_IgG">Typhoid IgG</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Typhoid_Ag" value="Typhoid_Ag"><label class="form-check-label" for="lab-Typhoid_Ag">Typhoid Ag</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Troponin_I" value="Troponin_I"><label class="form-check-label" for="lab-Troponin_I">Troponin I (Cardiac marker)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-CK_MB" value="CK_MB"><label class="form-check-label" for="lab-CK_MB">CK-MB (Creatine Kinase-MB)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-aPTT" value="aPTT"><label class="form-check-label" for="lab-aPTT">aPTT (Activated Partial Thromboplastin Time)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-INR" value="INR"><label class="form-check-label" for="lab-INR">INR (International Normalized Ratio)</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-D_Dimer" value="D_Dimer"><label class="form-check-label" for="lab-D_Dimer">D-Dimer</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Vitamin_D" value="Vitamin_D"><label class="form-check-label" for="lab-Vitamin_D">Vitamin D</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Vitamin_B12" value="Vitamin_B12"><label class="form-check-label" for="lab-Vitamin_B12">Vitamin B12</label></div>
                                <div class="form-check"><input class="form-check-input" type="checkbox" id="lab-Ferritin" value="Ferritin"><label class="form-check-label" for="lab-Ferritin">Ferritin (Iron storage)</label></div>
                            </div>
                        </div>
                        <div class="form-group mt-3">
                            <label>Notes/Reason (Optional)</label>
                            <textarea id="order-notes" class="form-control" rows="2" placeholder="Enter any notes or reason for ordering"></textarea>
                        </div>
                    </div>
                `,
                width: '800px',
                showCancelButton: true,
                confirmButtonText: '<i class="fas fa-paper-plane"></i> Submit Order',
                cancelButtonText: 'Cancel',
                preConfirm: function() {
                    var selectedTests = [];
                    $('input[id^="lab-"]:checked').each(function() {
                        selectedTests.push($(this).val());
                    });
                    
                    var notes = $('#order-notes').val().trim();
                    
                    if (selectedTests.length === 0) {
                        Swal.showValidationMessage('Please select at least one test');
                        return false;
                    }
                    
                    return { tests: selectedTests, notes: notes };
                }
            }).then(function(result) {
                if (result.isConfirmed) {
                    orderLabTests(result.value);
                }
            });
        }
        
        function updateLabOrder(data) {
            // DEBUG: Log what we're sending to the server
            console.log("=== UPDATE LAB ORDER DEBUG ===");
            console.log("Current Patient:", currentPatient);
            console.log("Prescription ID:", currentPatient.prescid);
            console.log("Order ID:", data.orderId);
            console.log("Selected Tests:", data.tests);
            console.log("Notes:", data.notes);
            console.log("Total Tests Selected:", data.tests ? data.tests.length : 0);
            console.log("============================");

            $.ajax({
                url: 'doctor_inpatient.aspx/UpdateLabOrder',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    prescid: currentPatient.prescid,
                    orderId: data.orderId,
                    tests: data.tests,
                    notes: data.notes
                }),
                success: function(response) {
                    // DEBUG: Log server response
                    console.log("=== UPDATE SERVER RESPONSE ===");
                    console.log("Full Response:", response);
                    console.log("Response.d:", response.d);
                    console.log("=============================");
                    
                    if (response.d === 'success') {
                        Swal.fire('Success', 'Tests updated successfully!', 'success');
                        loadLabResults(currentPatient.prescid);
                    } else {
                        Swal.fire('Error', 'Update failed: ' + response.d, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    // DEBUG: Log error details
                    console.log("=== UPDATE AJAX ERROR ===");
                    console.log("Status:", status);
                    console.log("Error:", error);
                    console.log("XHR Response Text:", xhr.responseText);
                    console.log("XHR Status Code:", xhr.status);
                    console.log("========================");
                    
                    Swal.fire('Error', 'Failed to update order: ' + error + ' (Status: ' + xhr.status + ')', 'error');
                }
            });
        }

        function orderLabTests(data) {
            $.ajax({
                url: 'doctor_inpatient.aspx/OrderLabTests',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    prescid: currentPatient.prescid,
                    patientId: currentPatient.patientid,
                    tests: data.tests,
                    notes: data.notes
                }),
                success: function(response) {
                    if (response.d === 'success') {
                        Swal.fire({
                            icon: 'info',
                            title: 'Lab Tests Ordered',
                            html: '<strong>Lab order created successfully!</strong><br><br>' +
                                  '<i class="fas fa-exclamation-triangle text-warning"></i> <strong>Important:</strong> The patient must pay the lab charges at registration before the lab can see and process this order.',
                            confirmButtonText: 'OK'
                        });
                        loadLabResults(currentPatient.prescid);
                    } else if (response.d.startsWith('existing_order:')) {
                        // Existing editable order detected
                        var orderId = response.d.split(':')[1];
                        Swal.fire({
                            icon: 'warning',
                            title: 'Existing Order Detected',
                            text: 'You have an existing unprocessed order. Please add tests to that order instead of creating a new one.',
                            confirmButtonText: 'OK'
                        });
                    } else {
                        Swal.fire('Error', response.d, 'error');
                    }
                },
                error: function(xhr, status, error) {
                    Swal.fire('Error', 'Failed to order tests: ' + error, 'error');
                }
            });
        }
    </script>

    <style>
        .nav-tabs .nav-link {
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .nav-tabs .nav-link:hover {
            background-color: #f8f9fa;
        }
        .nav-tabs .nav-link.active {
            font-weight: bold;
        }
        .tab-pane {
            padding: 20px;
        }
    </style></asp:Content>