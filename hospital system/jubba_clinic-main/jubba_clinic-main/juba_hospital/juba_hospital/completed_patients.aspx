<%@ Page Title="Completed Patients" Language="C#" MasterPageFile="~/doctor.Master" AutoEventWireup="true" CodeBehind="completed_patients.aspx.cs" Inherits="juba_hospital.completed_patients" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="datatables/datatables.min.css" />
    <link href="assets/sweetalert2.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid">
        <div class="page-header">
            <h3 class="fw-bold mb-3">Completed Patients</h3>
         <%--   <ul class="breadcrumbs mb-3">
                <li class="nav-home">
                    <a href="Dashbourd.aspx">
                        <i class="icon-home"></i>
                    </a>
                </li>
                <li class="separator">
                    <i class="icon-arrow-right"></i>
                </li>
                <li class="nav-item">
                    <a href="#">Patients</a>
                </li>
                <li class="separator">
                    <i class="icon-arrow-right"></i>
                </li>
                <li class="nav-item">
                    <a href="#">Completed Patients</a>
                </li>
            </ul>--%>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex align-items-center">
                            <h4 class="card-title">
                                <i class="fas fa-check-circle text-success"></i> All Completed Patients
                            </h4>
                            <div class="ms-auto">
                                <span class="badge badge-success" id="completedCount" style="font-size: 16px;">
                                    <i class="fas fa-users"></i> <span id="patientCount">0</span> Patients
                                </span>
                            </div>
                        </div>
                        <p class="text-muted mb-0 mt-2">
                            <i class="fas fa-info-circle"></i> Patients whose work has been marked as completed
                        </p>
                    </div>
                    <div class="card-body">
                        <!-- Filter Options -->
                        <div class="row mb-3">
                            <div class="col-md-3">
                                <label class="form-label">Filter by Date Range:</label>
                                <select class="form-select" id="dateFilter" onchange="applyDateFilter()">
                                    <option value="all">All Time</option>
                                    <option value="today">Today</option>
                                    <option value="week">This Week</option>
                                    <option value="month">This Month</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Export:</label>
                                <div class="btn-group w-100" role="group">
                                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="exportToExcel()">
                                        <i class="fas fa-file-excel"></i> Excel
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="exportToPDF()">
                                        <i class="fas fa-file-pdf"></i> PDF
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-success" onclick="window.print()">
                                        <i class="fas fa-print"></i> Print
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Patients Table -->
                        <div class="table-responsive">
                            <table class="display nowrap" style="width:100%" id="completedPatientsTable">
                                <thead>
                                    <tr>
                                        <th>Patient Name</th>
                                        <th>Sex</th>
                                        <th>Location</th>
                                        <th>Phone</th>
                                        <th>Amount</th>
                                        <th>D.O.B</th>
                                        <th>Registration Date</th>
                                        <th>Completed Date</th>
                                        <th>Lab Status</th>
                                        <th>X-ray Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <th>Patient Name</th>
                                        <th>Sex</th>
                                        <th>Location</th>
                                        <th>Phone</th>
                                        <th>Amount</th>
                                        <th>D.O.B</th>
                                        <th>Registration Date</th>
                                        <th>Completed Date</th>
                                        <th>Lab Status</th>
                                        <th>X-ray Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </tfoot>
                                <tbody>
                                    <!-- Data loaded via AJAX -->
                                </tbody>
                            </table>
                        </div>

                        <!-- Mobile View for Responsive Design -->
                        <div class="mobile-view">
                            <div class="mobile-search">
                                <input type="text" id="mobileSearchInput" placeholder="🔍 Search completed patients..." />
                            </div>
                            <div id="mobileCardsContainer">
                                <!-- Mobile cards will be populated here -->
                                <div class="text-center text-muted p-4">
                                    <i class="fas fa-spinner fa-spin"></i> Loading completed patients...
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- View Details Modal -->
    <div class="modal fade" id="detailsModal" tabindex="-1" aria-labelledby="detailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="detailsModalLabel">
                        <i class="fas fa-user-check"></i> Patient Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="modalBody">
                    <!-- Details loaded dynamically -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="printPatientSummary()">
                        <i class="fas fa-print"></i> Print Summary
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="Scripts/jquery-3.4.1.min.js"></script>
    <script src="datatables/datatables.min.js"></script>
    <script src="assets/sweetalert2.min.js"></script>
    <script src="assets/js/core/bootstrap.min.js"></script>

    <script type="text/javascript">
        var dataTable;
        var currentPrescId = null;
        var allCompletedPatientsData = [];
        var isMobileView = false;

        // Responsive utility functions
        function checkIfMobile() {
            return window.innerWidth <= 768;
        }

        function updateViewMode() {
            isMobileView = checkIfMobile();
            if (isMobileView) {
                $('.table-responsive').hide();
                $('.mobile-view').show();
                populateMobileCards(allCompletedPatientsData);
            } else {
                $('.table-responsive').show();
                $('.mobile-view').hide();
            }
        }

        // Mobile cards generation
        function populateMobileCards(patients) {
            const container = $('#mobileCardsContainer');
            container.empty();

            if (!patients || patients.length === 0) {
                container.html(`
                    <div class="text-center text-muted p-4">
                        <i class="fas fa-check-circle fa-2x mb-3 text-success"></i>
                        <p>No completed patients found</p>
                    </div>
                `);
                return;
            }

            patients.forEach(function(patient, index) {
                const card = createCompletedPatientCard(patient, index);
                container.append(card);
            });
        }

        function createCompletedPatientCard(patient, index) {
            const labStatusColor = getStatusColor(patient.status);
            const xrayStatusColor = getStatusColor(patient.xray_status);
            const completedDate = patient.completed_date || 'Recently completed';
            
            return `
                <div class="completed-patient-card" data-patient-id="${patient.prescid}">
                    <div class="mobile-card-header" onclick="toggleCompletedCard(this)">
                        <h5 class="patient-name-mobile">${patient.full_name || 'Unknown Patient'}</h5>
                        <p class="patient-info-brief">${patient.sex || 'N/A'} • ${patient.location || 'N/A'} • $${patient.amount || '0.00'}</p>
                        <div class="completed-badge">✓ COMPLETED</div>
                        <i class="fas fa-chevron-down expand-icon"></i>
                    </div>
                    <div class="mobile-card-body">
                        <div class="mobile-info-grid">
                            <div class="mobile-info-item">
                                <div class="mobile-info-label">Sex</div>
                                <div class="mobile-info-value">${patient.sex || 'N/A'}</div>
                            </div>
                            <div class="mobile-info-item">
                                <div class="mobile-info-label">Phone</div>
                                <div class="mobile-info-value">${patient.phone || 'N/A'}</div>
                            </div>
                            <div class="mobile-info-item">
                                <div class="mobile-info-label">Location</div>
                                <div class="mobile-info-value">${patient.location || 'N/A'}</div>
                            </div>
                            <div class="mobile-info-item">
                                <div class="mobile-info-label">Amount</div>
                                <div class="mobile-info-value">$${patient.amount || '0.00'}</div>
                            </div>
                            <div class="mobile-info-item">
                                <div class="mobile-info-label">Date of Birth</div>
                                <div class="mobile-info-value">${patient.dob || 'N/A'}</div>
                            </div>
                            <div class="mobile-info-item">
                                <div class="mobile-info-label">Registration Date</div>
                                <div class="mobile-info-value">${patient.date_registered || 'N/A'}</div>
                            </div>
                            <div class="mobile-info-item">
                                <div class="mobile-info-label">Completed Date</div>
                                <div class="mobile-info-value">${completedDate}</div>
                            </div>
                            <div class="mobile-info-item">
                                <div class="mobile-info-label">Lab Status</div>
                                <div class="mobile-info-value">
                                    <span class="badge" style="background-color: ${labStatusColor}; color: white; padding: 4px 8px; border-radius: 4px; font-size: 11px;">
                                        ${patient.status || 'N/A'}
                                    </span>
                                </div>
                            </div>
                            <div class="mobile-info-item" style="grid-column: 1 / -1;">
                                <div class="mobile-info-label">X-ray Status</div>
                                <div class="mobile-info-value">
                                    <span class="badge" style="background-color: ${xrayStatusColor}; color: white; padding: 4px 8px; border-radius: 4px; font-size: 11px;">
                                        ${patient.xray_status || 'N/A'}
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div class="mobile-actions">
                            <button type="button" class="btn btn-info btn-sm" onclick="viewDetails(${patient.prescid}); event.stopPropagation();">
                                <i class="fas fa-eye"></i> View Details
                            </button>
                            <button type="button" class="btn btn-primary btn-sm" onclick="openVisitSummary(${patient.prescid}); event.stopPropagation();">
                                <i class="fas fa-print"></i> Print Visit
                            </button>
                            <button type="button" class="btn btn-warning btn-sm" onclick="markAsPending(${patient.prescid}); event.stopPropagation();">
                                <i class="fas fa-undo"></i> Mark Pending
                            </button>
                        </div>
                    </div>
                </div>
            `;
        }

        function getStatusColor(status) {
            switch (status) {
                case 'waiting': return '#dc3545';
                case 'processed': case 'lab-processed': case 'xray-processed': case 'image_processed': return '#28a745';
                case 'pending-xray': case 'pending-lab': case 'pending_image': return '#fd7e14';
                default: return '#6c757d';
            }
        }

        function toggleCompletedCard(header) {
            const card = $(header).closest('.completed-patient-card');
            card.toggleClass('expanded');
        }

        // Mobile search functionality
        function setupMobileSearch() {
            $('#mobileSearchInput').on('input', function() {
                const searchTerm = $(this).val().toLowerCase().trim();
                
                if (searchTerm === '') {
                    populateMobileCards(allCompletedPatientsData);
                    return;
                }

                const filteredPatients = allCompletedPatientsData.filter(function(patient) {
                    const searchableText = [
                        patient.full_name,
                        patient.phone,
                        patient.location,
                        patient.sex,
                        patient.status,
                        patient.xray_status
                    ].join(' ').toLowerCase();
                    
                    return searchableText.includes(searchTerm);
                });

                populateMobileCards(filteredPatients);
            });
        }

        // Window resize handler
        $(window).on('resize', function() {
            updateViewMode();
        });

        $(document).ready(function () {
            // Initialize responsive functionality
            setupMobileSearch();
            updateViewMode();
            
            loadCompletedPatients();
        });

        function loadCompletedPatients() {
            // Get doctor ID from label2 (same as assignmed.aspx)
            var doctorid = $("#label2").html();
            
            console.log('Loading completed patients for doctor ID:', doctorid);
            console.log('label2 value:', $("#label2").html());

            $.ajax({
                type: "POST",
                url: "completed_patients.aspx/GetCompletedPatients",
                data: JSON.stringify({ doctorid: doctorid }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log('AJAX Response:', response);
                    console.log('Response.d:', response.d);
                    console.log('Response.d.length:', response.d ? response.d.length : 'null');
                    
                    if (response.d && response.d.length > 0) {
                        console.log('Found completed patients:', response.d.length);
                        
                        // Store data globally for responsive functionality
                        allCompletedPatientsData = response.d;
                        
                        populateTable(response.d);
                        $('#patientCount').text(response.d.length);
                        
                        // Update view mode to show appropriate interface
                        updateViewMode();
                    } else {
                        console.log('No completed patients found - showing message');
                        
                        // Clear data
                        allCompletedPatientsData = [];
                        
                        showNoDataMessage();
                        updateViewMode();
                    }
                },
                error: function (xhr, status, error) {
                    console.error('AJAX Error:', xhr, status, error);
                    console.error('Response Text:', xhr.responseText);
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Failed to load completed patients: ' + error
                    });
                }
            });
        }

        function populateTable(data) {
            console.log('populateTable called with data:', data);
            
            // Check if DataTable is available
            if (typeof $.fn.DataTable !== 'undefined') {
                // Destroy existing DataTable if it exists
                if ($.fn.DataTable.isDataTable('#completedPatientsTable')) {
                    $('#completedPatientsTable').DataTable().destroy();
                }
            }

            // Clear table body
            $('#completedPatientsTable tbody').empty();

            // Populate table rows
            for (var i = 0; i < data.length; i++) {
                var patient = data[i];
                var labStatusBadge = getStatusBadge(patient.status);
                var xrayStatusBadge = getStatusBadge(patient.xray_status);
                var completedDate = patient.completed_date || 'N/A';

                var row = '<tr>' +
                    '<td><strong>' + patient.full_name + '</strong></td>' +
                    '<td>' + patient.sex + '</td>' +
                    '<td>' + patient.location + '</td>' +
                    '<td>' + patient.phone + '</td>' +
                    '<td><strong>$' + patient.amount + '</strong></td>' +
                    '<td>' + patient.dob + '</td>' +
                    '<td>' + patient.date_registered + '</td>' +
                    '<td>' + completedDate + '</td>' +
                    '<td>' + labStatusBadge + '</td>' +
                    '<td>' + xrayStatusBadge + '</td>' +
                    '<td>' +
                    '<div class="btn-group" role="group">' +
                    '<button type="button" class="btn btn-sm btn-info" onclick="viewDetails(' + patient.prescid + ')" title="View Details">' +
                    '<i class="fas fa-eye"></i>' +
                    '</button>' +
                    '<button type="button" class="btn btn-sm btn-primary" onclick="openVisitSummary(' + patient.prescid + ')" title="Print Visit">' +
                    '<i class="fas fa-print"></i>' +
                    '</button>' +
                    '<button type="button" class="btn btn-sm btn-warning" onclick="markAsPending(' + patient.prescid + ')" title="Mark as Pending">' +
                    '<i class="fas fa-undo"></i>' +
                    '</button>' +
                    '</div>' +
                    '</td>' +
                    '</tr>';

                $('#completedPatientsTable tbody').append(row);
            }

            // Initialize DataTable
            if (typeof $.fn.DataTable !== 'undefined') {
                dataTable = $('#completedPatientsTable').DataTable({
                    "pageLength": 25,
                    "order": [[6, "desc"]], // Sort by registration date descending
                    "language": {
                        "emptyTable": "No completed patients found"
                    },
                    "dom": 'Bfrtip',
                    "buttons": [
                        'copy', 'excel', 'pdf', 'print'
                    ]
                });
                console.log('DataTable initialized successfully');
            } else {
                console.warn('DataTables library not loaded - table will work without DataTable features');
            }
        }

        function getStatusBadge(status) {
            if (!status || status === 'waiting' || status === 'N/A') {
                return '<span class="badge badge-secondary"><i class="fas fa-clock"></i> Waiting</span>';
            } else if (status === 'processed' || status === 'lab-processed' || status === 'image_processed' || status === 'xray-processed') {
                return '<span class="badge badge-success"><i class="fas fa-check-circle"></i> Completed</span>';
            } else if (status === 'pending-lab' || status === 'pending_image') {
                return '<span class="badge badge-warning"><i class="fas fa-hourglass-half"></i> Pending</span>';
            } else {
                return '<span class="badge badge-info">' + status + '</span>';
            }
        }

        function viewDetails(prescid) {
            currentPrescId = prescid;

            $.ajax({
                type: "POST",
                url: "completed_patients.aspx/GetPatientDetails",
                data: JSON.stringify({ prescid: prescid }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d) {
                        displayPatientDetails(response.d);
                    }
                },
                error: function (xhr, status, error) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Failed to load patient details: ' + error
                    });
                }
            });
        }

        function displayPatientDetails(patient) {
            var html = '<div class="row">' +
                '<div class="col-md-6">' +
                '<h6 class="text-success"><i class="fas fa-user"></i> Patient Information</h6>' +
                '<table class="table table-sm">' +
                '<tr><th>Name:</th><td>' + patient.full_name + '</td></tr>' +
                '<tr><th>Sex:</th><td>' + patient.sex + '</td></tr>' +
                '<tr><th>Location:</th><td>' + patient.location + '</td></tr>' +
                '<tr><th>Phone:</th><td>' + patient.phone + '</td></tr>' +
                '<tr><th>D.O.B:</th><td>' + patient.dob + '</td></tr>' +
                '<tr><th>Amount:</th><td><strong>$' + patient.amount + '</strong></td></tr>' +
                '</table>' +
                '</div>' +
                '<div class="col-md-6">' +
                '<h6 class="text-success"><i class="fas fa-clipboard-check"></i> Status Information</h6>' +
                '<table class="table table-sm">' +
                '<tr><th>Registration Date:</th><td>' + patient.date_registered + '</td></tr>' +
                '<tr><th>Completed Date:</th><td>' + (patient.completed_date || 'N/A') + '</td></tr>' +
                '<tr><th>Lab Status:</th><td>' + getStatusBadge(patient.status) + '</td></tr>' +
                '<tr><th>X-ray Status:</th><td>' + getStatusBadge(patient.xray_status) + '</td></tr>' +
                '<tr><th>Transaction Status:</th><td><span class="badge badge-success"><i class="fas fa-check-circle"></i> Completed</span></td></tr>' +
                '</table>' +
                '</div>' +
                '</div>';

            $('#modalBody').html(html);
            $('#detailsModal').modal('show');
        }

        function markAsPending(prescid) {
            Swal.fire({
                title: 'Mark as Pending?',
                text: 'Are you sure you want to mark this patient as pending?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#ffc107',
                cancelButtonColor: '#6c757d',
                confirmButtonText: 'Yes, mark as pending',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    updateTransactionStatus(prescid, 'pending');
                }
            });
        }

        function updateTransactionStatus(prescid, status) {
            $.ajax({
                type: "POST",
                url: "assignmed.aspx/UpdateTransactionStatus",
                data: JSON.stringify({ prescid: prescid.toString(), transactionStatus: status }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d === "success") {
                        Swal.fire({
                            icon: 'success',
                            title: 'Status Updated!',
                            text: 'Patient marked as ' + status,
                            timer: 2000
                        }).then(() => {
                            loadCompletedPatients(); // Reload table
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Error',
                            text: 'Failed to update status: ' + response.d
                        });
                    }
                },
                error: function (xhr, status, error) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Failed to update status: ' + error
                    });
                }
            });
        }

        function openVisitSummary(prescid) {
            window.open('visit_summary_print.aspx?prescid=' + prescid, '_blank');
        }

        function printPatientSummary() {
            window.print();
        }

        function showNoDataMessage() {
            $('#completedPatientsTable tbody').html(
                '<tr><td colspan="11" class="text-center">' +
                '<div class="py-5">' +
                '<i class="fas fa-inbox fa-3x text-muted mb-3"></i>' +
                '<h5 class="text-muted">No Completed Patients</h5>' +
                '<p class="text-muted">You haven\'t marked any patients as completed yet.</p>' +
                '</div>' +
                '</td></tr>'
            );
        }

        function applyDateFilter() {
            var filter = $('#dateFilter').val();
            // Implement date filtering logic
            loadCompletedPatients();
        }

        function exportToExcel() {
            dataTable.button('.buttons-excel').trigger();
        }

        function exportToPDF() {
            dataTable.button('.buttons-pdf').trigger();
        }
    </script>

    <style>
        .badge {
            padding: 6px 12px;
            font-size: 12px;
        }

        .btn-group .btn {
            margin: 0 2px;
        }

        .card-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }

        .card-header h4 {
            color: white;
            margin: 0;
        }

        #completedCount {
            font-size: 16px;
            padding: 8px 15px;
        }

        /* Comprehensive Responsive Design for All Devices */

        /* Button responsiveness */
        .btn {
            margin: 2px;
            white-space: nowrap;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        /* Form controls responsiveness */
        .form-control, .form-select {
            border-radius: 6px;
            border: 1px solid #ddd;
            padding: 10px 12px;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }

        /* DataTable responsive enhancements */
        .dataTables_wrapper {
            padding: 0;
        }

        .dataTables_length,
        .dataTables_filter {
            margin-bottom: 15px;
        }

        .dataTables_info,
        .dataTables_paginate {
            margin-top: 15px;
        }

        /* DataTable search box enhancements */
        .dataTables_filter input {
            border: 2px solid #e9ecef;
            border-radius: 25px;
            padding: 8px 15px;
            margin-left: 8px;
            font-size: 14px;
            width: 250px;
        }

        .dataTables_filter input:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
            outline: none;
        }

        /* Button enhancements */
        .dt-buttons {
            margin-bottom: 10px;
        }

        .dt-button {
            background: #28a745 !important;
            border: none !important;
            color: white !important;
            padding: 8px 16px !important;
            border-radius: 5px !important;
            margin-right: 8px !important;
            font-size: 13px !important;
            font-weight: 500 !important;
        }

        .dt-button:hover {
            background: #218838 !important;
            transform: translateY(-1px);
        }

        /* Tablet styles (768px - 1024px) */
        @media (max-width: 1024px) {
            .container-fluid {
                padding: 15px;
            }

            .card-body {
                padding: 15px;
            }

            table.dataTable {
                font-size: 14px;
            }

            .dataTables_length,
            .dataTables_filter {
                text-align: center;
                margin-bottom: 10px;
            }

            .dataTables_info,
            .dataTables_paginate {
                text-align: center;
                margin-top: 10px;
            }
        }

        /* Mobile styles (up to 768px) */
        @media (max-width: 768px) {
            /* Hide regular table and show mobile-friendly version */
            .table-responsive {
                display: none !important;
            }

            /* Show mobile cards container */
            .mobile-view {
                display: block !important;
            }

            .page-header h3 {
                font-size: 1.5rem;
            }

            .container-fluid {
                padding: 10px;
            }

            .card {
                margin-bottom: 15px;
            }

            .card-body {
                padding: 15px;
            }

            /* Form adjustments for mobile */
            .form-control, .form-select {
                font-size: 16px; /* Prevents zoom on iOS */
                padding: 12px;
            }

            .btn {
                padding: 10px 15px;
                font-size: 14px;
                width: 100%;
                margin-bottom: 10px;
            }

            .btn-sm {
                padding: 8px 12px;
                font-size: 13px;
                width: auto;
            }

            /* Mobile filter row adjustments */
            .row.mb-3 .col-md-3 {
                margin-bottom: 15px;
            }

            .btn-group {
                display: flex;
                flex-direction: column;
            }

            .btn-group .btn {
                margin-bottom: 5px;
                border-radius: 5px !important;
            }
        }

        /* Small mobile styles (up to 480px) */
        @media (max-width: 480px) {
            .page-header h3 {
                font-size: 1.3rem;
            }

            .container-fluid {
                padding: 8px;
            }

            .card-header {
                padding: 12px 15px;
                font-size: 14px;
            }

            .card-body {
                padding: 12px;
            }

            .btn {
                padding: 12px;
                font-size: 13px;
            }

            .d-flex.align-items-center {
                flex-direction: column;
                align-items: flex-start !important;
            }

            .ms-auto {
                margin-left: 0 !important;
                margin-top: 10px;
            }
        }

        /* Mobile Cards Styles */
        .mobile-view {
            display: none;
        }

        .mobile-search {
            margin-bottom: 15px;
        }

        .mobile-search input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            background: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .mobile-search input:focus {
            border-color: #28a745;
            outline: none;
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.2);
        }

        .completed-patient-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
            border: 1px solid #f0f0f0;
            border-left: 5px solid #28a745;
        }

        .completed-patient-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }

        .completed-patient-card.expanded {
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }

        .mobile-card-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 15px 20px;
            cursor: pointer;
            position: relative;
        }

        .mobile-card-header:hover {
            background: linear-gradient(135deg, #218838 0%, #1ba87f 100%);
        }

        .patient-name-mobile {
            font-size: 18px;
            font-weight: bold;
            margin: 0 0 5px 0;
        }

        .patient-info-brief {
            font-size: 14px;
            opacity: 0.9;
            margin: 0;
        }

        .completed-badge {
            position: absolute;
            top: 10px;
            right: 60px;
            background: rgba(255, 255, 255, 0.2);
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
        }

        .expand-icon {
            position: absolute;
            right: 20px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 16px;
            transition: transform 0.3s ease;
        }

        .completed-patient-card.expanded .expand-icon {
            transform: translateY(-50%) rotate(180deg);
        }

        .mobile-card-body {
            padding: 0;
            max-height: 0;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .completed-patient-card.expanded .mobile-card-body {
            max-height: 1000px;
            padding: 20px;
        }

        .mobile-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-bottom: 20px;
        }

        .mobile-info-item {
            background: #f8f9fa;
            padding: 12px;
            border-radius: 8px;
            border-left: 4px solid #28a745;
        }

        .mobile-info-label {
            font-size: 12px;
            font-weight: 600;
            color: #666;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .mobile-info-value {
            font-size: 14px;
            color: #333;
            font-weight: 500;
        }

        .mobile-actions {
            border-top: 1px solid #f0f0f0;
            padding-top: 15px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .mobile-actions .btn {
            flex: 1;
            min-width: 100px;
            margin: 0;
            padding: 8px 12px;
            font-size: 12px;
            width: auto;
        }

        @media (max-width: 480px) {
            .mobile-info-grid {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .mobile-actions {
                flex-direction: column;
            }

            .mobile-actions .btn {
                width: 100%;
            }
        }

        @media print {
            .no-print {
                display: none !important;
            }

            .card {
                box-shadow: none;
                border: none;
            }
        }
    </style>
</asp:Content>
