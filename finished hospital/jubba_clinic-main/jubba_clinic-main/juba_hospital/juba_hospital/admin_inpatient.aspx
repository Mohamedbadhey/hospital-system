<%@ Page Title="Inpatient Management - Admin" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="admin_inpatient.aspx.cs" Inherits="juba_hospital.admin_inpatient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap4.min.css">
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
        .filter-btn { margin: 5px; }
        .filter-btn.active { background-color: #007bff; color: white; }
        .patient-status-1 { border-left-color: #28a745; }
        .patient-status-3 { border-left-color: #6c757d; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-inner">
        <div class="page-header">
            <h4 class="page-title"><i class="fas fa-procedures"></i> Inpatient Management - Admin View</h4>
            <ul class="breadcrumbs">
                <li class="nav-home"><a href="admin_dashbourd.aspx"><i class="flaticon-home"></i></a></li>
                <li class="separator"><i class="flaticon-right-arrow"></i></li>
                <li class="nav-item">Admin</li>
                <li class="separator"><i class="flaticon-right-arrow"></i></li>
                <li class="nav-item active">Inpatients</li>
            </ul>
        </div>

        <div class="row mb-3">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-body">
                        <h5><i class="fas fa-filter"></i> Filter Patients</h5>
                        <button class="btn btn-primary filter-btn active" onclick="filterPatients('active')">Active Inpatients</button>
                        <button class="btn btn-secondary filter-btn" onclick="filterPatients('all')">All Patients</button>
                        <button class="btn btn-success filter-btn" onclick="filterPatients('discharged')">Recently Discharged</button>
                    </div>
                </div>
            </div>
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
                    <h5 class="modal-title"><i class="fas fa-user-injured"></i> Patient Details - Admin View</h5>
                    <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div class="modal-body">
                    <ul class="nav nav-tabs">
                        <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#overviewTab"><i class="fas fa-info-circle"></i> Overview</a></li>
                        <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#labResultsTab"><i class="fas fa-flask"></i> Lab Results</a></li>
                        <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#medicationsTab"><i class="fas fa-pills"></i> Medications</a></li>
                        <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#chargesTab"><i class="fas fa-file-invoice-dollar"></i> Charges</a></li>
                        <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#historyTab" onclick="loadPatientHistoryAdmin()"><i class="fas fa-clipboard-list"></i> History</a></li>
                    </ul>
                    <div class="tab-content mt-3">
                        <div id="overviewTab" class="tab-pane fade show active">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6 class="text-primary"><i class="fas fa-user"></i> Patient Information</h6>
                                    <table class="table table-sm">
                                        <tr><td class="info-label">Full Name:</td><td class="info-value" id="modalPatientName"></td></tr>
                                        <tr><td class="info-label">Patient ID:</td><td class="info-value" id="modalPatientId"></td></tr>
                                        <tr><td class="info-label">Sex:</td><td class="info-value" id="modalPatientSex"></td></tr>
                                        <tr><td class="info-label">DOB:</td><td class="info-value" id="modalPatientDOB"></td></tr>
                                        <tr><td class="info-label">Phone:</td><td class="info-value" id="modalPatientPhone"></td></tr>
                                        <tr><td class="info-label">Location:</td><td class="info-value" id="modalPatientLocation"></td></tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-primary"><i class="fas fa-bed"></i> Admission Details</h6>
                                    <table class="table table-sm">
                                        <tr><td class="info-label">Doctor:</td><td class="info-value" id="modalDoctor"></td></tr>
                                        <tr><td class="info-label">Admission Date:</td><td class="info-value" id="modalAdmissionDate"></td></tr>
                                        <tr><td class="info-label">Days Admitted:</td><td class="info-value" id="modalDaysAdmitted"></td></tr>
                                        <tr><td class="info-label">Bed Charges:</td><td class="info-value" id="modalBedCharges"></td></tr>
                                        <tr><td class="info-label">Unpaid Charges:</td><td class="info-value text-danger" id="modalUnpaidCharges"></td></tr>
                                        <tr><td class="info-label">Paid Charges:</td><td class="info-value text-success" id="modalPaidCharges"></td></tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div id="labResultsTab" class="tab-pane fade"><div id="labResultsContent"></div></div>
                        <div id="medicationsTab" class="tab-pane fade"><div id="medicationsContent"></div></div>
                        <div id="chargesTab" class="tab-pane fade"><div id="chargesContent"></div></div>
                        <div id="historyTab" class="tab-pane fade">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6 class="text-primary"><i class="fas fa-edit"></i> Record Patient History</h6>
                                    <textarea class="form-control" id="historyTextAdmin" rows="12" placeholder="Enter patient history..."></textarea>
                                    <small id="historyTextErrorAdmin" class="text-danger"></small>
                                    <div class="mt-3">
                                        <button type="button" class="btn btn-primary btn-block" onclick="submitPatientHistoryAdmin()">
                                            <i class="fas fa-save"></i> Save History
                                        </button>
                                        <button type="button" class="btn btn-secondary btn-block" onclick="clearHistoryFormAdmin()">
                                            <i class="fas fa-times"></i> Clear
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h6 class="text-primary mb-0"><i class="fas fa-history"></i> History Records</h6>
                                        <button class="btn btn-sm btn-outline-primary" onclick="loadPatientHistoryAdmin()">
                                            <i class="fas fa-sync"></i> Refresh
                                        </button>
                                    </div>
                                    <div id="historyRecordsContainerAdmin" style="max-height: 500px; overflow-y: auto;">
                                        <div class="alert alert-info text-center">
                                            <i class="fas fa-info-circle"></i> No history records found.
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" onclick="printDischargeSummary()"><i class="fas fa-print"></i> Print Discharge Summary</button>
                    <button type="button" class="btn btn-info" onclick="viewChargeHistory()"><i class="fas fa-file-invoice"></i> View Full Billing</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="assets/sweetalert2.min.js"></script>
    <script>
        var currentPatient = null;
        var currentFilter = 'active';

        $(document).ready(function() { loadInpatients('active'); });

        function filterPatients(type) {
            currentFilter = type;
            $('.filter-btn').removeClass('active');
            $('.filter-btn').each(function() {
                if ($(this).text().toLowerCase().includes(type)) $(this).addClass('active');
            });
            loadInpatients(type === 'active' ? 'current' : 'all');
        }

        function loadInpatients(filterType) {
            $.ajax({
                url: 'admin_inpatient.aspx/GetAllInpatients',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ filterType: filterType }),
                success: function(response) { displayInpatients(response.d); },
                error: function() { Swal.fire('Error', 'Failed to load inpatients', 'error'); }
            });
        }

        function displayInpatients(data) {
            if (!data || data.length === 0) {
                $('#inpatientsContainer').html('<div class="col-md-12"><div class="card"><div class="card-body text-center py-5"><i class="fas fa-bed fa-3x text-muted mb-3"></i><h5 class="text-muted">No patients found</h5></div></div></div>');
                updateStatistics([]);
                return;
            }
            var html = '';
            data.forEach(function(patient) {
                var statusClass = patient.patient_status === '1' ? 'patient-status-1' : 'patient-status-3';
                var statusText = patient.patient_status === '1' ? 'Active' : 'Discharged';
                html += '<div class="col-md-6 col-lg-4"><div class="card inpatient-card ' + statusClass + '"><div class="card-body">';
                html += '<div class="patient-header"><h5 class="mb-1">' + patient.full_name + '</h5><small><i class="fas fa-id-card"></i> ID: ' + patient.patientid + '</small>';
                html += '<div class="float-right"><span class="days-badge">Day ' + patient.days_admitted + '</span></div></div>';
                html += '<div class="mt-3"><div class="mb-2"><strong>Doctor:</strong> ' + patient.doctortitle + ' ' + patient.doctor_name + '</div>';
                html += '<div class="mb-2"><strong>Status:</strong> <span class="badge badge-' + (patient.patient_status === '1' ? 'success' : 'secondary') + '">' + statusText + '</span></div>';
                html += '<div class="row mb-2"><div class="col-6"><span class="info-label">Sex:</span><div class="info-value">' + patient.sex + '</div></div>';
                html += '<div class="col-6"><span class="info-label">Phone:</span><div class="info-value">' + patient.phone + '</div></div></div>';
                html += '<div class="mb-2"><span class="info-label">Admission:</span><div class="info-value">' + patient.bed_admission_date + '</div></div><hr>';
                html += '<div class="mb-2"><strong>Clinical Status:</strong><br><span class="status-badge status-' + getStatusClass(patient.lab_result_status).split('-')[1] + '"><i class="fas fa-flask"></i> Lab: ' + patient.lab_result_status + '</span> ';
                html += '<span class="status-badge status-' + getStatusClass(patient.xray_result_status).split('-')[1] + '"><i class="fas fa-x-ray"></i> X-ray: ' + patient.xray_result_status + '</span></div>';
                html += '<div class="mb-2"><strong>Medications:</strong> ' + patient.medication_count + ' prescribed</div><hr>';
                html += '<div class="row text-center"><div class="col-6"><small class="text-muted">Unpaid</small><div class="text-danger font-weight-bold">$' + parseFloat(patient.unpaid_charges).toFixed(2) + '</div></div>';
                html += '<div class="col-6"><small class="text-muted">Paid</small><div class="text-success font-weight-bold">$' + parseFloat(patient.paid_charges).toFixed(2) + '</div></div></div><hr>';
                html += '<div class="text-center"><button class="btn btn-primary btn-sm" onclick=\'viewPatientDetails(' + JSON.stringify(patient) + ')\'><i class="fas fa-eye"></i> View Details</button></div>';
                html += '</div></div></div></div>';
            });
            $('#inpatientsContainer').html(html);
            updateStatistics(data);
        }

        function getStatusClass(status) {
            if (status === 'Available') return 'status-available';
            if (status === 'Pending') return 'status-pending';
            if (status === 'Ordered') return 'status-ordered';
            return 'status-not-ordered';
        }

        function updateStatistics(data) {
            var activePatients = data.filter(p => p.patient_status === '1');
            var pendingLabs = activePatients.filter(p => p.lab_result_status === 'Pending').length;
            var pendingXrays = activePatients.filter(p => p.xray_result_status === 'Pending').length;
            var unpaid = data.reduce((sum, p) => sum + parseFloat(p.unpaid_charges || 0), 0);
            $('#totalInpatients').text(activePatients.length);
            $('#pendingLabs').text(pendingLabs);
            $('#pendingXrays').text(pendingXrays);
            $('#unpaidCharges').text('$' + unpaid.toFixed(2));
        }

        function viewPatientDetails(patient) {
            currentPatient = patient;
            $('#modalPatientName').text(patient.full_name);
            $('#modalPatientId').text(patient.patientid);
            $('#modalPatientSex').text(patient.sex);
            $('#modalPatientDOB').text(patient.dob);
            $('#modalPatientPhone').text(patient.phone);
            $('#modalPatientLocation').text(patient.location);
            $('#modalDoctor').text(patient.doctortitle + ' ' + patient.doctor_name);
            $('#modalAdmissionDate').text(patient.bed_admission_date);
            $('#modalDaysAdmitted').text(patient.days_admitted + ' days');
            $('#modalBedCharges').text('$' + parseFloat(patient.total_bed_charges).toFixed(2));
            $('#modalUnpaidCharges').text('$' + parseFloat(patient.unpaid_charges).toFixed(2));
            $('#modalPaidCharges').text('$' + parseFloat(patient.paid_charges).toFixed(2));
            loadLabResults(patient.prescid);
            loadMedications(patient.prescid);
            loadCharges(patient.patientid);
            $('#patientDetailsModal').modal('show');
        }

        function loadLabResults(prescid) {
            $.ajax({ url: 'admin_inpatient.aspx/GetLabResults', method: 'POST', contentType: 'application/json',
                data: JSON.stringify({ prescid: prescid }),
                success: function(response) {
                    if (response.d && response.d.length > 0) {
                        var html = '<table class="table table-sm table-striped"><thead><tr><th>Test</th><th>Result</th></tr></thead><tbody>';
                        response.d.forEach(function(test) { html += '<tr><td>' + test.TestName + '</td><td><strong>' + test.TestValue + '</strong></td></tr>'; });
                        html += '</tbody></table>';
                        $('#labResultsContent').html(html);
                    } else { $('#labResultsContent').html('<div class="alert alert-info">No lab results</div>'); }
                }
            });
        }

        function loadMedications(prescid) {
            $.ajax({ url: 'admin_inpatient.aspx/GetMedications', method: 'POST', contentType: 'application/json',
                data: JSON.stringify({ prescid: prescid }),
                success: function(response) {
                    if (response.d && response.d.length > 0) {
                        var html = '<div class="list-group">';
                        response.d.forEach(function(med) {
                            html += '<div class="list-group-item"><h6>' + med.med_name + '</h6><p><strong>Dosage:</strong> ' + med.dosage + ' | <strong>Frequency:</strong> ' + med.frequency + ' | <strong>Duration:</strong> ' + med.duration + '</p>';
                            if (med.special_inst) html += '<small class="text-muted">' + med.special_inst + '</small>';
                            html += '</div>';
                        });
                        html += '</div>';
                        $('#medicationsContent').html(html);
                    } else { $('#medicationsContent').html('<div class="alert alert-info">No medications</div>'); }
                }
            });
        }

        function loadCharges(patientId) {
            $.ajax({ url: 'admin_inpatient.aspx/GetPatientCharges', method: 'POST', contentType: 'application/json',
                data: JSON.stringify({ patientId: patientId }),
                success: function(response) {
                    if (response.d && response.d.length > 0) {
                        var html = '<table class="table table-sm"><thead><tr><th>Type</th><th>Description</th><th>Amount</th><th>Status</th></tr></thead><tbody>';
                        response.d.forEach(function(charge) {
                            var isPaid = charge.is_paid === '1' || charge.is_paid === 'True';
                            html += '<tr><td><span class="badge badge-info">' + charge.charge_type + '</span></td><td>' + charge.charge_name + '</td>';
                            html += '<td>$' + parseFloat(charge.amount).toFixed(2) + '</td><td><span class="' + (isPaid ? 'charge-paid' : 'charge-unpaid') + '">' + (isPaid ? 'Paid' : 'Unpaid') + '</span></td></tr>';
                        });
                        html += '</tbody></table>';
                        $('#chargesContent').html(html);
                    } else { $('#chargesContent').html('<div class="alert alert-info">No charges</div>'); }
                }
            });
        }

        function printDischargeSummary() {
            if (!currentPatient) return;
            window.open('discharge_summary_print.aspx?patientId=' + currentPatient.patientid + '&prescid=' + currentPatient.prescid, '_blank', 'width=900,height=700');
        }

        function viewChargeHistory() {
            if (!currentPatient) return;
            window.open('charge_history.aspx?patientid=' + currentPatient.patientid, '_blank');
        }

        // Patient History Functions for Admin
        var editingHistoryIdAdmin = null;

        function loadPatientHistoryAdmin() {
            if (!currentPatient) return;
            
            $.ajax({
                type: "POST",
                url: "doctor_inpatient.aspx/GetPatientHistoryDoctor",
                data: JSON.stringify({ patientId: currentPatient.patientid.toString(), prescid: currentPatient.prescid.toString() }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    displayPatientHistoryAdmin(response.d);
                },
                error: function (xhr, status, error) {
                    console.error('Error loading history:', error);
                    $('#historyRecordsContainerAdmin').html('<div class="alert alert-danger">Error loading history records</div>');
                }
            });
        }

        function displayPatientHistoryAdmin(histories) {
            var container = $('#historyRecordsContainerAdmin');
            container.empty();

            if (!histories || histories.length === 0) {
                container.html('<div class="alert alert-info text-center"><i class="fas fa-info-circle"></i> No history records found.</div>');
                return;
            }

            histories.forEach(function (history) {
                var card = $('<div class="card mb-3"></div>');
                var cardBody = $('<div class="card-body"></div>');
                
                var header = $('<div class="d-flex justify-content-between align-items-start mb-2"></div>');
                var dateInfo = $('<div><small class="text-muted"><i class="fas fa-calendar"></i> ' + history.CreatedDate + 
                    (history.LastUpdated ? ' (Updated: ' + history.LastUpdated + ')' : '') + '</small></div>');
                
                var btnGroup = $('<div class="btn-group btn-group-sm"></div>');
                var editBtn = $('<button class="btn btn-outline-primary btn-sm" type="button"><i class="fas fa-edit"></i></button>');
                editBtn.on('click', function(e) {
                    e.preventDefault();
                    editHistoryAdmin(history.HistoryId, history.HistoryText);
                });
                
                var deleteBtn = $('<button class="btn btn-outline-danger btn-sm" type="button"><i class="fas fa-trash"></i></button>');
                deleteBtn.on('click', function(e) {
                    e.preventDefault();
                    deleteHistoryAdmin(history.HistoryId);
                });
                
                btnGroup.append(editBtn).append(deleteBtn);
                header.append(dateInfo).append(btnGroup);
                
                var historyContent = $('<div style="white-space: pre-wrap; background: #f8f9fa; padding: 10px; border-radius: 5px; border-left: 3px solid #667eea;"></div>');
                historyContent.text(history.HistoryText);
                
                cardBody.append(header).append(historyContent);
                card.append(cardBody);
                container.append(card);
            });
        }

        function submitPatientHistoryAdmin() {
            var historyText = $('#historyTextAdmin').val().trim();
            
            if (!currentPatient) {
                Swal.fire({ icon: 'error', title: 'Error', text: 'No patient selected' });
                return;
            }

            if (!historyText) {
                $('#historyTextErrorAdmin').text('Please enter patient history');
                return;
            }

            $('#historyTextErrorAdmin').text('');

            if (editingHistoryIdAdmin) {
                updateHistoryAdmin(editingHistoryIdAdmin, historyText);
            } else {
                saveNewHistoryAdmin(currentPatient.patientid, currentPatient.prescid, historyText);
            }
        }

        function saveNewHistoryAdmin(patientId, prescid, historyText) {
            $.ajax({
                type: "POST",
                url: "doctor_inpatient.aspx/SavePatientHistoryDoctor",
                data: JSON.stringify({ patientId: patientId.toString(), prescid: prescid.toString(), historyText: historyText, createdBy: '<%= Session["id"] %>' }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === 'success') {
                        Swal.fire({ icon: 'success', title: 'Success!', text: 'History record saved successfully!', timer: 2000, showConfirmButton: false });
                        $('#historyTextAdmin').val('');
                        loadPatientHistoryAdmin();
                    } else {
                        Swal.fire({ icon: 'error', title: 'Error', text: response.d });
                    }
                },
                error: function (xhr, status, error) {
                    Swal.fire({ icon: 'error', title: 'Failed', text: 'Failed to save history record' });
                }
            });
        }

        function editHistoryAdmin(historyId, historyText) {
            editingHistoryIdAdmin = historyId;
            $('#historyTextAdmin').val(historyText);
            $('#historyTextAdmin').focus();
        }

        function updateHistoryAdmin(historyId, historyText) {
            $.ajax({
                type: "POST",
                url: "doctor_inpatient.aspx/UpdatePatientHistoryDoctor",
                data: JSON.stringify({ historyId: historyId, historyText: historyText, updatedBy: '<%= Session["id"] %>' }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === 'success') {
                        Swal.fire({ icon: 'success', title: 'Updated!', text: 'History record updated successfully!', timer: 2000, showConfirmButton: false });
                        clearHistoryFormAdmin();
                        loadPatientHistoryAdmin();
                    } else {
                        Swal.fire({ icon: 'error', title: 'Error', text: response.d });
                    }
                },
                error: function (xhr, status, error) {
                    Swal.fire({ icon: 'error', title: 'Failed', text: 'Failed to update history record' });
                }
            });
        }

        function deleteHistoryAdmin(historyId) {
            Swal.fire({
                title: 'Are you sure?',
                text: "You won't be able to revert this!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: 'Yes, delete it!'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        type: "POST",
                        url: "doctor_inpatient.aspx/DeletePatientHistoryDoctor",
                        data: JSON.stringify({ historyId: historyId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d === 'success') {
                                Swal.fire({ icon: 'success', title: 'Deleted!', text: 'History record has been deleted.', timer: 2000, showConfirmButton: false });
                                loadPatientHistoryAdmin();
                            } else {
                                Swal.fire({ icon: 'error', title: 'Error', text: response.d });
                            }
                        },
                        error: function (xhr, status, error) {
                            Swal.fire({ icon: 'error', title: 'Failed', text: 'Failed to delete history record' });
                        }
                    });
                }
            });
        }

        function clearHistoryFormAdmin() {
            $('#historyTextAdmin').val('');
            $('#historyTextErrorAdmin').text('');
            editingHistoryIdAdmin = null;
        }
    </script>
</asp:Content>
