<%@ Page Title="Patient Medications" Language="C#" MasterPageFile="~/pharmacy.Master" AutoEventWireup="true" CodeBehind="pharmacy_patient_medications.aspx.cs" Inherits="juba_hospital.pharmacy_patient_medications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <link href="assets/css/kaiadmin.6930170604842
        min.css" rel="stylesheet" />
    <style>
        .patient-card {
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .patient-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .medication-item {
            border-left: 4px solid #007bff;
            padding: 10px;
            margin: 5px 0;
            background: #f8f9fa;
            border-radius: 5px;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: bold;
        }
        .status-assigned { background: #fff3cd; color: #856404; }
        .status-dispensed { background: #d1ecf1; color: #0c5460; }
        .status-completed { background: #d4edda; color: #155724; }
        .medication-details {
            background: white;
            border-radius: 8px;
            padding: 15px;
            margin-top: 10px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-inner">
        <div class="d-flex align-items-left align-items-md-center flex-column flex-md-row pt-2 pb-4">
            <div>
                <h3 class="fw-bold mb-3">📋 Patient Medications</h3>
                <h6 class="op-7 mb-2">View and manage patient medications</h6>
            </div>
        </div>

        <!-- Search and Filter Section -->
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">🔍 Search Patients</div>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label>Patient Name or ID</label>
                                    <input type="text" class="form-control" id="searchInput" placeholder="Search by name or patient ID...">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Medication Status</label>
                                    <select class="form-control" id="statusFilter">
                                        <option value="">All Statuses</option>
                                        <option value="prescribed">Prescribed</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="form-group">
                                    <label>Date Range</label>
                                    <select class="form-control" id="dateFilter">
                                        <option value="">All Dates</option>
                                        <option value="today">Today</option>
                                        <option value="week">This Week</option>
                                        <option value="month">This Month</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label>&nbsp;</label>
                                    <button type="button" class="btn btn-primary btn-block" id="searchBtn">
                                        <i class="fa fa-search"></i> Search
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Patients List -->
        <div class="row" id="patientsContainer">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">👥 Patients with Medications</div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover" id="patientsTable">
                                <thead>
                                    <tr>
                                        <th>Patient ID</th>
                                        <th>Patient Name</th>
                                        <th>Age</th>
                                        <th>Gender</th>
                                        <th>Phone</th>
                                        <th>Medications</th>
                                        <th>Last Visit</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Data will be populated here -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Patient Medications Modal -->
        <div class="modal fade" id="medicationsModal" tabindex="-1" role="dialog" aria-labelledby="medicationsModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="medicationsModalLabel">
                            <i class="fa fa-pills"></i> Patient Medications
                        </h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Patient Info -->
                        <div class="row mb-4">
                            <div class="col-md-12">
                                <div class="card border-info">
                                    <div class="card-header bg-info text-white">
                                        <h6 class="mb-0"><i class="fa fa-user"></i> Patient Information</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-3"><strong>Name:</strong> <span id="modalPatientName"></span></div>
                                            <div class="col-md-2"><strong>ID:</strong> <span id="modalPatientId"></span></div>
                                            <div class="col-md-2"><strong>Age:</strong> <span id="modalPatientAge"></span></div>
                                            <div class="col-md-2"><strong>Gender:</strong> <span id="modalPatientGender"></span></div>
                                            <div class="col-md-3"><strong>Phone:</strong> <span id="modalPatientPhone"></span></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Medications List -->
                        <div class="row">
                            <div class="col-md-12">
                                <div class="card border-success">
                                    <div class="card-header bg-success text-white">
                                        <h6 class="mb-0"><i class="fa fa-pills"></i> Prescribed Medications</h6>
                                    </div>
                                    <div class="card-body">
                                        <div id="medicationsList">
                                            <div class="text-center">
                                                <i class="fa fa-spinner fa-spin fa-2x"></i>
                                                <p>Loading medications...</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">
                            <i class="fa fa-times"></i> Close
                        </button>
                        <button type="button" class="btn btn-primary" id="printMedications">
                            <i class="fa fa-print"></i> Print Medications
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="assets/js/core/jquery-3.7.1.min.js"></script>
    <script src="datatables/datatables.min.js"></script>
    <script>

        $(document).ready(function () {
            // Initialize DataTable (same as other pharmacy pages)
            // Simple table without DataTables for now
            console.log('Page ready, loading patient data...');
            
            // Load patient data directly
            loadPatientsData();

            // Search button
            $('#searchBtn').click(function() {
                loadPatientsData();
            });

            // Enter key search
            $('#searchInput').keypress(function(e) {
                if (e.which === 13) {
                    loadPatientsData();
                }
            });

            // Filter changes
            $('#statusFilter, #dateFilter').change(function() {
                loadPatientsData();
            });

            // View medications button
            $('#patientsTable').on('click', '.view-medications', function(e) {
                e.preventDefault();
                e.stopPropagation();
                
                var patientId = $(this).data('patient-id');
                var prescId = $(this).data('presc-id');
                var patientName = $(this).data('patient-name');
                var patientAge = $(this).data('patient-age');
                var patientGender = $(this).data('patient-gender');
                var patientPhone = $(this).data('patient-phone');
                
                console.log('View medications clicked for patient:', patientId, 'prescId:', prescId);
                
                // Debug modal availability
                console.log('Modal element found:', $('#medicationsModal').length);
                console.log('Bootstrap modal available:', typeof $.fn.modal);
                
                // Set patient info in modal
                $('#modalPatientName').text(patientName);
                $('#modalPatientId').text(patientId);
                $('#modalPrescId').val(prescId); // Store prescid in hidden field for printing
                $('#modalPatientAge').text(patientAge);
                $('#modalPatientGender').text(patientGender);
                $('#modalPatientPhone').text(patientPhone);
                
                // Load medications using prescid
                loadPatientMedications(prescId);
                
                // Try different approaches to show modal
                try {
                    console.log('Trying to show modal...');
                    $('#medicationsModal').modal('show');
                    console.log('Modal show command executed');
                } catch (error) {
                    console.error('Error showing modal:', error);
                    // Fallback - try showing without Bootstrap
                    $('#medicationsModal').show();
                }
                
                return false;
            });

            // Print medications
            $('#printMedications').click(function() {
                var patientId = $('#modalPatientId').text();
                var prescId = $('#modalPrescId').val(); // Get prescid from hidden field
                if (patientId && prescId) {
                    window.open('medication_print.aspx?prescid=' + prescId + '&patientId=' + patientId, '_blank');
                } else if (patientId) {
                    window.open('medication_print.aspx?patientId=' + patientId, '_blank');
                } else {
                    alert('No patient selected for printing.');
                }
            });
        });

        function loadPatientsData() {
            $('#patientsTable tbody').html('<tr><td colspan="8" class="text-center">Loading patients...</td></tr>');
            
            $.ajax({
                url: 'pharmacy_patient_medications.aspx/GetPatientsWithMedications',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                data: JSON.stringify({
                    search: $('#searchInput').val(),
                    statusFilter: $('#statusFilter').val(),
                    dateFilter: $('#dateFilter').val()
                }),
                success: function(response) {
                    console.log('AJAX Response:', response);
                    console.log('Response.d:', response.d);
                    console.log('Response.d length:', response.d ? response.d.length : 'undefined');
                    
                    if (response.d && response.d.length > 0) {
                        var html = '';
                        response.d.forEach(function(patient) {
                            var lastVisit = patient.LastVisit ? new Date(patient.LastVisit).toLocaleDateString() : 'N/A';
                            html += '<tr>';
                            html += '<td>' + patient.PatientId + '</td>';
                            html += '<td>' + patient.FullName + '</td>';
                            html += '<td>' + patient.Age + '</td>';
                            html += '<td>' + patient.Gender + '</td>';
                            html += '<td>' + patient.Phone + '</td>';
                            html += '<td><span class="badge badge-info">' + patient.MedicationCount + ' medication(s)</span></td>';
                            html += '<td>' + lastVisit + '</td>';
                            html += '<td><button class="btn btn-sm btn-primary view-medications" ';
                            html += 'data-patient-id="' + patient.PatientId + '" ';
                            html += 'data-presc-id="' + patient.PrescId + '" ';
                            html += 'data-patient-name="' + patient.FullName + '" ';
                            html += 'data-patient-age="' + patient.Age + '" ';
                            html += 'data-patient-gender="' + patient.Gender + '" ';
                            html += 'data-patient-phone="' + patient.Phone + '">';
                            html += '<i class="fa fa-eye"></i> View Medications</button></td>';
                            html += '</tr>';
                        });
                        $('#patientsTable tbody').html(html);
                    } else {
                        $('#patientsTable tbody').html('<tr><td colspan="8" class="text-center">No patients found</td></tr>');
                    }
                },
                error: function(xhr, status, error) {
                    console.error('Error loading patients:', error);
                    console.error('XHR:', xhr);
                    console.error('Status:', status);
                    console.error('Response Text:', xhr.responseText);
                    $('#patientsTable tbody').html('<tr><td colspan="8" class="text-center text-danger">Error loading patients: ' + error + '</td></tr>');
                }
            });
        }

        function loadPatientMedications(prescId) {
            $('#medicationsList').html('<div class="text-center"><i class="fa fa-spinner fa-spin fa-2x"></i><p>Loading medications...</p></div>');
            
            $.ajax({
                url: 'pharmacy_patient_medications.aspx/GetPatientMedications',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ prescId: prescId }),
                dataType: 'json',
                success: function(response) {
                    console.log('GetPatientMedications response:', response);
                    console.log('Medications found:', response.d ? response.d.length : 'undefined');
                    
                    if (response.d && response.d.length > 0) {
                        var html = '';
                        response.d.forEach(function(med, index) {
                            var statusClass = 'status-' + (med.Status ? med.Status.toLowerCase() : 'prescribed');
                            html += '<div class="medication-item">';
                            html += '<div class="row">';
                            html += '<div class="col-md-4"><strong>' + med.MedicineName + '</strong></div>';
                            html += '<div class="col-md-2"><span class="badge ' + statusClass + '">' + (med.Status || 'prescribed') + '</span></div>';
                            html += '<div class="col-md-2">Qty: ' + (med.Quantity || 'N/A') + '</div>';
                            html += '<div class="col-md-2">Unit: ' + (med.Unit || 'N/A') + '</div>';
                            html += '<div class="col-md-2">Date: ' + (med.AssignedDate ? new Date(med.AssignedDate).toLocaleDateString() : 'N/A') + '</div>';
                            html += '</div>';
                            if (med.Instructions) {
                                html += '<div class="row mt-2">';
                                html += '<div class="col-md-12"><small><strong>Instructions:</strong> ' + med.Instructions + '</small></div>';
                                html += '</div>';
                            }
                            html += '</div>';
                        });
                        $('#medicationsList').html(html);
                    } else {
                        $('#medicationsList').html('<div class="alert alert-info">No medications found for this patient.</div>');
                    }
                },
                error: function() {
                    $('#medicationsList').html('<div class="alert alert-danger">Error loading medications. Please try again.</div>');
                }
            });
        }
    </script>
</asp:Content>