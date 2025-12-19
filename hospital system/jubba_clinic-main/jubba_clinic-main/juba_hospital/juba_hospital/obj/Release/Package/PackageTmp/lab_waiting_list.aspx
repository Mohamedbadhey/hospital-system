<%@ Page Title="" Language="C#" MasterPageFile="~/labtest.Master" AutoEventWireup="true"
    CodeBehind="lab_waiting_list.aspx.cs" Inherits="juba_hospital.lab_waiting_list" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <style>
        /* Custom table styling */
        .dataTables_wrapper .dataTables_filter { float: right; text-align: right; }
        .dataTables_wrapper .dataTables_length { float: left; }
        .dataTables_wrapper .dataTables_paginate { float: right; text-align: right; }
        .dataTables_wrapper .dataTables_info { float: left; }

        #datatable { width: 100%; margin: 20px 0; font-size: 19px; font-weight: bold; }
        #datatable th, #datatable td { text-align: center; vertical-align: middle; }
        #datatable th { background-color: #007bff; color: white; font-weight: bold; }
        #datatable td { background-color: #f8f9fa; }

        .btn-primary { background-color: #007bff; border-color: #007bff; }
        .btn-primary:hover { background-color: #0056b3; border-color: #004085; }

        .btn-success { background-color: #28a745; border-color: #28a745; }
        .btn-success:hover { background-color: #218838; border-color: #1e7e34; }

        /* Pagination hover */
        .dataTables_wrapper .dataTables_paginate .paginate_button {
            padding: 0.5em 1em; margin-left: 0.5em; color: #007bff; background-color: white; border: 1px solid #ddd;
        }
        .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
            color: white; background-color: #007bff; border: 1px solid #007bff; cursor: pointer;
        }
        .dataTables_wrapper .dataTables_paginate .paginate_button.current {
            color: white; background-color: #007bff; border: 1px solid #007bff;
        }
        .view-btn-group button {
            margin: 2px;
            padding: 5px 8px;
            font-size: 0.85rem;
        }
        
        /* Highlight reorder rows */
        .reorder-row {
            background-color: #fff3cd !important;
            border-left: 4px solid #ff9800 !important;
        }
        
        .badge-warning {
            background-color: #ff9800;
            animation: pulse-warning 2s infinite;
        }
        
        @keyframes pulse-warning {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title">
                        Lab Waiting List 
                        <small class="text-muted" id="lastUpdated"></small>
                        <span class="badge badge-success" id="autoRefreshIndicator" style="font-size: 11px; margin-left: 10px;">
                            <i class="fas fa-sync-alt"></i> Auto-refresh: ON (5s)
                        </span>
                    </h4>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="display nowrap" style="width:100%" id="datatable">
                            <thead>
                                <tr>
                                    <th>Order #</th>
                                    <th>Patient Name</th>
                                    <th>Order Date</th>
                                    <th>Order Type</th>
                                    <th>Order Status</th>
                                    <th>Notes</th>
                                    <th>Doctor</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tfoot>
                                <tr>
                                    <th>Order #</th>
                                    <th>Patient Name</th>
                                    <th>Order Date</th>
                                    <th>Order Type</th>
                                    <th>Order Status</th>
                                    <th>Notes</th>
                                    <th>Doctor</th>
                                    <th>Actions</th>
                                </tr>
                            </tfoot>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modals -->
    <!-- View Ordered Tests Modal -->
    <div class="modal fade" id="testsModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title"><i class="fas fa-list"></i> Ordered Tests</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="testsModalBody">
                    <div class="text-center">
                        <i class="fas fa-spinner fa-spin fa-2x"></i>
                        <p>Loading...</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- View Results Modal -->
    <div class="modal fade" id="resultsModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title"><i class="fas fa-eye"></i> Test Results</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="resultsModalBody">
                    <div class="text-center">
                        <i class="fas fa-spinner fa-spin fa-2x"></i>
                        <p>Loading...</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="printResultsBtn">
                        <i class="fas fa-print"></i> Print
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Test Results Entry Modal (from test_details.aspx) -->
    <div class="modal fade" id="testResultsModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
        aria-labelledby="testResultsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-fullscreen">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="testResultsModalLabel">Lab Test Results Entry</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input style="display:none" id="modalOrderId" />
                    <input style="display:none" id="modalPrescId" />
                    <input style="display:none" id="modalMedId" />

                    <!-- Patient Information Card -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card border-primary">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0"><i class="fa fa-user"></i> Patient Information</h5>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-4"><strong>Name:</strong> <span id="modalPatientName"></span></div>
                                        <div class="col-md-4"><strong>Sex:</strong> <span id="modalPatientSex"></span></div>
                                        <div class="col-md-4"><strong>Phone:</strong> <span id="modalPatientPhone"></span></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Ordered Tests Section -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card border-success">
                                <div class="card-header bg-success text-white">
                                    <h5 class="mb-0"><i class="fa fa-flask"></i> Ordered Lab Tests</h5>
                                </div>
                                <div class="card-body">
                                    <div id="modalOrderedTestsList" class="alert alert-info">
                                        <p class="mb-0">Loading ordered tests...</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Dynamic Ordered Tests Input Section -->
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card border-info">
                                <div class="card-header bg-info text-white">
                                    <h5 class="mb-0"><i class="fa fa-edit"></i> Enter Results for Ordered Tests Only</h5>
                                </div>
                                <div class="card-body">
                                    <div id="modalOrderedTestsInputs" class="row">
                                        <p class="mb-0">Loading input fields...</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times"></i> Cancel
                    </button>
                    <button type="button" class="btn btn-success" id="saveTestResults">
                        <i class="fas fa-save"></i> Save Results
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Patient Lab History Modal -->
    <div class="modal fade" id="historyModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header bg-warning text-white">
                    <h5 class="modal-title"><i class="fas fa-history"></i> Patient Lab History</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="historyModalBody" style="max-height: 70vh; overflow-y: auto;">
                    <div class="text-center">
                        <i class="fas fa-spinner fa-spin fa-2x"></i>
                        <p>Loading...</p>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="printHistoryBtn">
                        <i class="fas fa-print"></i> Print History
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="assets/js/core/jquery-3.7.1.min.js"></script>
    <script src="assets/js/core/bootstrap.min.js"></script>
    <script src="datatables/datatables.min.js"></script>
    <script>
        $(document).ready(function () {
            var table = $('#datatable').DataTable({
                dom: 'Bfrtip',
                buttons: ['excelHtml5'],
                paging: true,
                pageLength: 10,
                lengthMenu: [10, 25, 50, 100],
                responsive: true,
                order: [[2, 'desc']] // Order by Order Date (column index 2), newest first
            });

            // Function to load data
            function loadLabWaitingList() {
                $.ajax({
                    url: 'lab_waiting_list.aspx/pendlap',
                    dataType: "json",
                    type: 'POST',
                    contentType: "application/json",
                    success: function (response) {
                    console.log(response);
                    table.clear().draw();

                    function getStatusButton(status) {
                        var color;
                        switch (status) {
                            case 'waiting': color = 'red'; break;
                            case 'pending-lap': color = 'orange'; break;
                            case 'lap-processed': color = 'green'; break;
                            case 'pending_scan': color = 'orange'; break;
                            case 'scan_processed': color = 'green'; break;
                            default: color = 'initial';
                        }
                        return "<button style='background-color:" + color + "; cursor:default; color:white; border:none; padding:5px 10px; border-radius:30%;' disabled>" + status + "</button>";
                    }

                    for (var i = 0; i < response.d.length; i++) {
                        var order = response.d[i];
                        console.log(order);
                        // Order number
                        var orderNum = "<strong>#" + order.order_id + "</strong>";
                        
                        // Patient info with details
                        var patientInfo = "<strong>" + order.full_name + "</strong><br>" +
                            "<small>Sex: " + order.sex + " | DOB: " + order.dob + "</small><br>" +
                            "<small>Phone: " + order.phone + " | Location: " + order.location + "</small>";
                        
                        // Order date
                        var orderDate = order.last_order_date || order.date_registered;
                        
                        // Order type with badge
                        var orderType = '';
                        if (order.is_reorder === '1' || order.is_reorder === 1) {
                            orderType = "<span class='badge badge-warning' style='font-size: 13px;'>" +
                                "<i class='fas fa-redo'></i> Follow-up</span>";
                        } else {
                            orderType = "<span class='badge badge-primary' style='font-size: 13px;'>" +
                                "<i class='fas fa-file-medical'></i> Initial</span>";
                        }
                        
                        // Order status with icon
                        var orderStatus = '';
                        if (order.status === 'Completed') {
                            orderStatus = "<span class='badge badge-success' style='font-size: 13px;'>" +
                                "<i class='fas fa-check-circle'></i> Completed</span>";
                        } else {
                            orderStatus = "<span class='badge badge-warning' style='font-size: 13px;'>" +
                                "<i class='fas fa-hourglass-half'></i> Pending</span>";
                        }
                        
                        // Charge info - Show actual payment status
                        var paymentStatus = "";
                        if (order.lab_charge_paid === "1" || order.lab_charge_paid === 1 || order.lab_charge_paid === true || 
                            order.lab_charge_paid === "True" || order.lab_charge_paid === "true") {
                            paymentStatus = " - <span style='color: green; font-weight: bold;'>Paid ✅</span>";
                        } else {
                            paymentStatus = " - <span style='color: red; font-weight: bold;'>Unpaid ❌</span>";
                        }
                        var chargeInfo = "<small><strong>" + (order.charge_name || 'Lab Charge') + "</strong><br>" +
                            "$" + parseFloat(order.charge_amount || 0).toFixed(2) + paymentStatus + "</small>";
                        
                        // Notes
                        var notes = order.reorder_reason ? 
                            "<small class='text-muted'>" + order.reorder_reason + "</small>" : 
                            "<small class='text-muted'>No notes</small>";
                        
                        // Doctor
                        var doctorInfo = "<small>" + order.doctortitle + "</small>";
                        
                        // Actions - Enhanced with more functionality
                        var viewBtns = "<div class='view-btn-group' style='display: flex; flex-wrap: wrap; gap: 5px;'>";
                        
                        // View ordered tests button - always visible
                        viewBtns += "<button type='button' class='btn btn-sm btn-primary view-order-btn' data-orderid='" + order.order_id + "' data-prescid='" + order.prescid + "' title='View ordered tests'>" +
                            "<i class='fas fa-list'></i> Tests</button>";
                        
                        if (order.status === 'Pending') {
                            // For pending orders: Enter results (ADD mode)
                            viewBtns += "<button type='button' class='btn btn-sm btn-success enter-results-btn' data-orderid='" + order.order_id + "' data-prescid='" + order.prescid + "' title='Enter test results'>" +
                                "<i class='fas fa-plus-circle'></i> Enter</button>";
                        } else {
                            // For completed orders: View, Edit, and Print results
                            viewBtns += "<button type='button' class='btn btn-sm btn-info view-results-btn' data-orderid='" + order.order_id + "' data-prescid='" + order.prescid + "' title='View results'>" +
                                "<i class='fas fa-eye'></i> View</button>";
                            viewBtns += "<button type='button' class='btn btn-sm btn-success edit-results-btn' data-orderid='" + order.order_id + "' data-prescid='" + order.prescid + "' title='Edit results'>" +
                                "<i class='fas fa-edit'></i> Edit</button>";
                            viewBtns += "<button type='button' class='btn btn-sm btn-secondary print-results-btn' data-orderid='" + order.order_id + "' data-prescid='" + order.prescid + "' title='Print results'>" +
                                "<i class='fas fa-print'></i> Print</button>";
                        }
                        
                        // Patient lab history button - always visible
                        viewBtns += "<button type='button' class='btn btn-sm btn-warning patient-history-btn' data-patientid='" + order.patientid + "' data-patientname='" + order.full_name + "' title='View complete lab history'>" +
                            "<i class='fas fa-history'></i> History</button>";
                        
                        viewBtns += "</div>";

                        var rowNode = table.row.add([
                            orderNum,
                            patientInfo,
                            orderDate,
                            orderType,
                            orderStatus,
                            notes,
                            doctorInfo,
                            viewBtns
                        ]).draw().node();
                        
                        // Add special styling
                        if (order.status === 'Completed') {
                            $(rowNode).css('background-color', '#f0f8f0');
                        } else if (order.is_reorder === '1' || order.is_reorder === 1) {
                            $(rowNode).addClass('reorder-row');
                        }
                    }
                    },
                    error: function (response) {
                        console.error('Error loading lab waiting list:', response.responseText);
                    }
                });
            }

            // Load data initially
            loadLabWaitingList();

            // Auto-refresh every 5 seconds
            setInterval(function() {
                loadLabWaitingList();
            }, 5000);

            // Open report page based on type
            $('#datatable').on('click', '.view-report-btn', function () {
                var prescid = $(this).data('prescid');
                var type = $(this).data('type');
                window.open('lab_comprehensive_report.aspx?prescid=' + prescid + '&type=' + type, '_blank');
            });
            
            // View order tests button - Show in modal
            $('#datatable').on('click', '.view-order-btn', function (e) {
                e.preventDefault();
                e.stopPropagation();
                var orderId = $(this).data('orderid');
                var prescid = $(this).data('prescid');
                
                // Show loading modal
                $('#testsModal').modal('show');
                $('#testsModalBody').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x"></i><p>Loading tests...</p></div>');
                
                // Load tests data
                loadOrderedTests(prescid, orderId);
                return false;
            });
            
            // Enter results button - Open Modal (ADD mode)
            $('#datatable').on('click', '.enter-results-btn', function (e) {
                e.preventDefault();
                e.stopPropagation();
                
                var orderId = $(this).data('orderid');
                var prescid = $(this).data('prescid');
                
                // Get current row data for patient information  
                var rowData = table.row($(this).closest('tr')).data();
                
                // Set hidden fields (same as test_details.aspx approach)
                $('#modalOrderId').val(orderId);
                $('#modalPrescId').val(prescid); 
                $('#modalMedId').val(orderId);
                
                // Load patient information from API
                $.ajax({
                    url: 'lab_waiting_list.aspx/GetTestResults',
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    data: JSON.stringify({ prescid: prescid, orderId: orderId }),
                    dataType: 'json',
                    success: function (response) {
                        if (response.d) {
                            $('#modalPatientName').text(response.d.PatientName || 'N/A');
                            $('#modalPatientSex').text(response.d.PatientSex || 'N/A');
                            $('#modalPatientPhone').text(response.d.PatientPhone || 'N/A');
                        }
                    },
                    error: function () {
                        // Fallback to rowData if API fails
                        if (rowData) {
                            $('#modalPatientName').text(rowData.full_name || 'N/A');
                            $('#modalPatientSex').text(rowData.sex || 'N/A');
                            $('#modalPatientPhone').text(rowData.phone || 'N/A');
                        }
                    }
                });
                
                // Load ordered tests using simple approach (no AJAX)
                loadOrderedTestsSimple(prescid, orderId);
                
                // Show the results entry modal
                $('#testResultsModal').modal('show');
                
                return false;
            });
            
            // Edit results button - Navigate to form (EDIT mode)
            $('#datatable').on('click', '.edit-results-btn', function (e) {
                e.preventDefault();
                e.stopPropagation();
                var orderId = $(this).data('orderid');
                var prescid = $(this).data('prescid');
                window.location.href = 'test_details.aspx?id=' + orderId + '&prescid=' + prescid;
                return false;
            });
            
            // View results button - Show in modal
            $('#datatable').on('click', '.view-results-btn', function (e) {
                e.preventDefault();
                e.stopPropagation();
                var orderId = $(this).data('orderid');
                var prescid = $(this).data('prescid');
                
                // Show loading modal
                $('#resultsModal').modal('show');
                $('#resultsModalBody').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x"></i><p>Loading results...</p></div>');
                
                // Store for printing
                $('#printResultsBtn').data('prescid', prescid).data('orderid', orderId);
                
                // Load results data
                loadTestResults(prescid, orderId);
                return false;
            });
            
            // Print results button - Open print page
            $('#datatable').on('click', '.print-results-btn', function (e) {
                e.preventDefault();
                e.stopPropagation();
                var orderId = $(this).data('orderid');
                var prescid = $(this).data('prescid');
                window.open('lab_result_print.aspx?prescid=' + prescid + '&orderid=' + orderId, '_blank');
                return false;
            });
            
            // Patient lab history button - Show in modal
            $('#datatable').on('click', '.patient-history-btn', function (e) {
                e.preventDefault();
                e.stopPropagation();
                var patientId = $(this).data('patientid');
                var patientName = $(this).data('patientname');
                
                // Show loading modal
                $('#historyModal').modal('show');
                $('#historyModalBody').html('<div class="text-center"><i class="fas fa-spinner fa-spin fa-2x"></i><p>Loading patient history...</p></div>');
                
                // Store for printing
                $('#printHistoryBtn').data('patientid', patientId).data('patientname', patientName);
                
                // Load history data
                loadPatientHistory(patientId, patientName);
                return false;
            });
            
            // Print results from modal
            $('#printResultsBtn').on('click', function() {
                var prescid = $(this).data('prescid');
                var orderId = $(this).data('orderid');
                window.open('lab_result_print.aspx?prescid=' + prescid + '&orderid=' + orderId, '_blank');
            });
            
            // Print history from modal
            $('#printHistoryBtn').on('click', function() {
                var patientId = $(this).data('patientid');
                var patientName = $(this).data('patientname');
                window.open('patient_lab_history.aspx?patientid=' + patientId + '&name=' + encodeURIComponent(patientName), '_blank');
            });
        });
        
        // Function to load ordered tests
        function loadOrderedTests(prescid, orderId) {
            $.ajax({
                url: 'lab_waiting_list.aspx/GetOrderedTests',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ prescid: prescid, orderId: orderId }),
                success: function(response) {
                    if (response.d && response.d.length > 0) {
                        var html = '<div class="patient-info mb-3">';
                        html += '<h5>Patient: ' + response.d[0].PatientName + '</h5>';
                        html += '<p><strong>Order #' + orderId + '</strong> | Date: ' + response.d[0].OrderDate + '</p>';
                        html += '</div>';
                        html += '<h6>Ordered Tests:</h6>';
                        html += '<ul class="list-group">';
                        response.d.forEach(function(test) {
                            html += '<li class="list-group-item">';
                            html += '<i class="fas fa-vial text-primary"></i> ' + test.TestName;
                            html += '</li>';
                        });
                        html += '</ul>';
                        $('#testsModalBody').html(html);
                    } else {
                        $('#testsModalBody').html('<div class="alert alert-info">No tests found for this order.</div>');
                    }
                },
                error: function() {
                    $('#testsModalBody').html('<div class="alert alert-danger">Error loading tests. Please try again.</div>');
                }
            });
        }
        
        // Function to load test results
        function loadTestResults(prescid, orderId) {
            $.ajax({
                url: 'lab_waiting_list.aspx/GetTestResults',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ prescid: prescid, orderId: orderId }),
                success: function(response) {
                    if (response.d && response.d.PatientName) {
                        var data = response.d;
                        var html = '<div class="patient-info mb-3 p-3 bg-light rounded">';
                        html += '<h5><i class="fas fa-user"></i> ' + data.PatientName + '</h5>';
                        html += '<p><strong>Patient ID:</strong> ' + data.PatientId + ' | <strong>Order #' + orderId + '</strong></p>';
                        html += '<p><strong>Date:</strong> ' + data.OrderDate + ' | <strong>Doctor:</strong> ' + (data.Doctor || 'N/A') + '</p>';
                        html += '</div>';
                        
                        if (data.Results && data.Results.length > 0) {
                            html += '<h6>Test Results:</h6>';
                            html += '<table class="table table-bordered">';
                            html += '<thead class="thead-light"><tr><th>Test Parameter</th><th>Result</th></tr></thead>';
                            html += '<tbody>';
                            data.Results.forEach(function(result) {
                                html += '<tr>';
                                html += '<td>' + result.Parameter + '</td>';
                                html += '<td><strong>' + result.Value + '</strong></td>';
                                html += '</tr>';
                            });
                            html += '</tbody></table>';
                        } else {
                            html += '<div class="alert alert-warning">No results recorded yet.</div>';
                        }
                        $('#resultsModalBody').html(html);
                    } else {
                        $('#resultsModalBody').html('<div class="alert alert-info">No results found.</div>');
                    }
                },
                error: function() {
                    $('#resultsModalBody').html('<div class="alert alert-danger">Error loading results. Please try again.</div>');
                }
            });
        }
        
        // Function to load patient lab history
        function loadPatientHistory(patientId, patientName) {
            $.ajax({
                url: 'lab_waiting_list.aspx/GetPatientLabHistory',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ patientId: patientId }),
                success: function(response) {
                    if (response.d && response.d.Orders) {
                        var data = response.d;
                        var html = '<div class="patient-header mb-4 p-3 bg-light rounded">';
                        html += '<h5><i class="fas fa-user-circle"></i> ' + patientName + '</h5>';
                        html += '<p><strong>Patient ID:</strong> ' + patientId + '</p>';
                        
                        // Summary stats
                        html += '<div class="row mt-3">';
                        html += '<div class="col-md-4"><div class="stat-box bg-primary text-white p-3 rounded text-center">';
                        html += '<h3>' + data.TotalOrders + '</h3><small>Total Orders</small></div></div>';
                        html += '<div class="col-md-4"><div class="stat-box bg-success text-white p-3 rounded text-center">';
                        html += '<h3>' + data.CompletedOrders + '</h3><small>Completed</small></div></div>';
                        html += '<div class="col-md-4"><div class="stat-box bg-warning text-white p-3 rounded text-center">';
                        html += '<h3>' + data.PendingOrders + '</h3><small>Pending</small></div></div>';
                        html += '</div></div>';
                        
                        // Orders
                        html += '<h6 class="mb-3">Lab Order History:</h6>';
                        
                        if (data.Orders.length > 0) {
                            data.Orders.forEach(function(order) {
                                var statusClass = order.IsCompleted ? 'success' : 'warning';
                                var statusText = order.IsCompleted ? 'Completed' : 'Pending';
                                
                                html += '<div class="card mb-3">';
                                html += '<div class="card-header bg-' + statusClass + ' text-white">';
                                html += '<strong>Order #' + order.OrderId + '</strong> - ' + order.OrderDate;
                                html += '<span class="badge badge-light float-right">' + statusText + '</span>';
                                html += '</div>';
                                html += '<div class="card-body">';
                                
                                // Doctor info
                                if (order.Doctor) {
                                    html += '<p><strong>Doctor:</strong> ' + order.Doctor + '</p>';
                                }
                                
                                // Tests
                                html += '<p><strong>Tests Ordered:</strong></p><ul>';
                                if (order.Tests && order.Tests.length > 0) {
                                    order.Tests.forEach(function(test) {
                                        html += '<li>' + test + '</li>';
                                    });
                                } else {
                                    html += '<li>No tests recorded</li>';
                                }
                                html += '</ul>';
                                
                                // Results
                                if (order.IsCompleted && order.Results && order.Results.length > 0) {
                                    html += '<p><strong>Results:</strong></p>';
                                    html += '<table class="table table-sm table-bordered">';
                                    html += '<thead><tr><th>Parameter</th><th>Result</th></tr></thead><tbody>';
                                    order.Results.forEach(function(result) {
                                        html += '<tr><td>' + result.Parameter + '</td><td><strong>' + result.Value + '</strong></td></tr>';
                                    });
                                    html += '</tbody></table>';
                                }
                                
                                html += '</div></div>';
                            });
                        } else {
                            html += '<div class="alert alert-info">No previous orders found.</div>';
                        }
                        
                        $('#historyModalBody').html(html);
                    } else {
                        $('#historyModalBody').html('<div class="alert alert-info">No history found for this patient.</div>');
                    }
                },
                error: function() {
                    $('#historyModalBody').html('<div class="alert alert-danger">Error loading history. Please try again.</div>');
                }
            });
        }

        // Function to load ordered tests for modal (copy exact approach from test_details.aspx)
        function loadOrderedTestsSimple(prescid, orderId) {
            // Load ordered tests list using simple AJAX
            $.ajax({
                url: 'lab_waiting_list.aspx/GetOrderedTests',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify({ prescid: prescid, orderId: orderId }),
                dataType: 'json',
                success: function (response) {
                    if (response.d && response.d.length > 0) {
                        var testsHtml = '<div class="row">';
                        var inputsHtml = '';
                        
                        response.d.forEach(function (test, index) {
                            testsHtml += '<div class="col-md-4 mb-2">';
                            testsHtml += '<span class="badge badge-primary p-2">' + test.TestName + '</span>';
                            testsHtml += '</div>';
                            
                            // Create input fields (same as test_details approach)
                            inputsHtml += '<div class="col-md-6 mb-3">';
                            inputsHtml += '<div class="form-group">';
                            inputsHtml += '<label class="form-label"><strong>' + test.TestName + '</strong></label>';
                            inputsHtml += '<input type="text" class="form-control" id="' + test.ColumnName + '" name="' + test.ColumnName + '" placeholder="Enter result for ' + test.TestName + '">';
                            inputsHtml += '</div>';
                            inputsHtml += '</div>';
                        });
                        
                        testsHtml += '</div>';
                        $('#modalOrderedTestsList').html(testsHtml);
                        $('#modalOrderedTestsInputs').html(inputsHtml);
                    } else {
                        $('#modalOrderedTestsList').html('<div class="alert alert-warning">No tests ordered for this prescription.</div>');
                        $('#modalOrderedTestsInputs').html('<div class="alert alert-warning">No input fields to display.</div>');
                    }
                },
                error: function () {
                    $('#modalOrderedTestsList').html('<div class="alert alert-danger">Error loading ordered tests.</div>');
                    $('#modalOrderedTestsInputs').html('<div class="alert alert-danger">Error loading input fields.</div>');
                }
            });
        }

        // Handle Save Test Results button (copy exact approach from test_details.aspx)
        $('#saveTestResults').click(function () {
            var orderId = $('#modalOrderId').val();
            
            if (!orderId) {
                alert('Missing order information.');
                return;
            }
            
            // Show loading
            $('#saveTestResults').prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Saving...');
            
            // Collect all input values (same as test_details approach)
            var data = {
                id: orderId,
                flexCheckGeneralUrineExamination1: $('#General_urine_examination').val() || '',
                flexCheckProgesteroneFemale1: $('#Progesterone_Female').val() || '',
                flexCheckAmylase1: $('#Amylase').val() || '',
                flexCheckMagnesium1: $('#Magnesium').val() || '',
                flexCheckPhosphorous1: $('#Phosphorous').val() || '',
                flexCheckCalcium1: $('#Calcium').val() || '',
                flexCheckChloride1: $('#Chloride').val() || '',
                flexCheckPotassium1: $('#Potassium').val() || '',
                flexCheckSodium1: $('#Sodium').val() || '',
                flexCheckUricAcid1: $('#Uric_acid').val() || '',
                flexCheckCreatinine1: $('#Creatinine').val() || '',
                flexCheckUrea1: $('#Urea').val() || '',
                flexCheckJGlobulin1: $('#JGlobulin').val() || '',
                flexCheckAlbumin1: $('#Albumin').val() || '',
                flexCheckTotalBilirubin1: $('#Total_bilirubin').val() || '',
                flexCheckAlkalinePhosphatesALP1: $('#Alkaline_phosphates_ALP').val() || '',
                flexCheckSGOTAST1: $('#SGOT_AST').val() || '',
                flexCheckSGPTALT1: $('#SGPT_ALT').val() || '',
                flexCheckLiverFunctionTest1: $('#Liver_function_test').val() || '',
                flexCheckTriglycerides1: $('#Triglycerides').val() || '',
                flexCheckTotalCholesterol1: $('#Total_cholesterol').val() || '',
                flexCheckHemoglobinA1c1: $('#Hemoglobin_A1c').val() || '',
                flexCheckHDL1: $('#High_density_lipoprotein_HDL').val() || '',
                flexCheckLDL1: $('#Low_density_lipoprotein_LDL').val() || '',
                flexCheckFSH1: $('#Follicle_stimulating_hormone_FSH').val() || '',
                flexCheckEstradiol1: $('#Estradiol').val() || '',
                flexCheckLH1: $('#Luteinizing_hormone_LH').val() || '',
                flexCheckTestosteroneMale1: $('#Testosterone_Male').val() || '',
                flexCheckProlactin1: $('#Prolactin').val() || '',
                flexCheckSeminalFluidAnalysis1: $('#Seminal_Fluid_Analysis_Male_B_HCG').val() || '',
                flexCheckBHCG1: $('#Clinical_path').val() || '',
                flexCheckUrineExamination1: $('#Urine_examination').val() || '',
                flexCheckStoolExamination1: $('#Stool_examination').val() || '',
                flexCheckHemoglobin1: $('#Hemoglobin').val() || '',
                flexCheckMalaria1: $('#Malaria').val() || '',
                flexCheckESR1: $('#ESR').val() || '',
                flexCheckBloodGrouping1: $('#Blood_grouping').val() || '',
                flexCheckBloodSugar1: $('#Blood_sugar').val() || '',
                flexCheckCBC1: $('#CBC').val() || '',
                flexCheckCrossMatching1: $('#Cross_matching').val() || '',
                flexCheckTPHA1: $('#TPHA').val() || '',
                flexCheckHIV1: $('#Human_immune_deficiency_HIV').val() || '',
                flexCheckHBV1: $('#Hepatitis_B_virus_HBV').val() || '',
                flexCheckHCV1: $('#Hepatitis_C_virus_HCV').val() || '',
                flexCheckBrucellaMelitensis1: $('#Brucella_melitensis').val() || '',
                flexCheckBrucellaAbortus1: $('#Brucella_abortus').val() || '',
                flexCheckCRP1: $('#C_reactive_protein_CRP').val() || '',
                flexCheckRF1: $('#Rheumatoid_factor_RF').val() || '',
                flexCheckASO1: $('#Antistreptolysin_O_ASO').val() || '',
                flexCheckToxoplasmosis1: $('#Toxoplasmosis').val() || '',
                flexCheckTyphoid1: $('#Typhoid_hCG').val() || '',
                flexCheckHpyloriAntibody1: $('#Hpylori_antibody').val() || '',
                flexCheckStoolOccultBlood1: $('#Stool_occult_blood').val() || '',
                flexCheckGeneralStoolExamination1: $('#General_stool_examination').val() || '',
                flexCheckThyroidProfile1: $('#Thyroid_profile').val() || '',
                flexCheckT31: $('#Triiodothyronine_T3').val() || '',
                flexCheckT41: $('#Thyroxine_T4').val() || '',
                flexCheckTSH1: $('#Thyroid_stimulating_hormone_TSH').val() || '',
                flexCheckSpermExamination1: $('#Sperm_examination').val() || '',
                flexCheckVirginalSwab1: $('#Virginal_swab_trichomonas_virginals').val() || '',
                flexCheckTrichomonasVirginals1: '',
                flexCheckHCG1: $('#Human_chorionic_gonadotropin_hCG').val() || '',
                flexCheckHpyloriAgStool1: $('#Hpylori_Ag_stool').val() || '',
                flexCheckFastingBloodSugar1: $('#Fasting_blood_sugar').val() || '',
                flexCheckDirectBilirubin1: $('#Direct_bilirubin').val() || '',
                flexCheckTroponinI1: $('#Troponin_I').val() || '',
                flexCheckCKMB1: $('#CK_MB').val() || '',
                flexCheckAPTT1: $('#aPTT').val() || '',
                flexCheckINR1: $('#INR').val() || '',
                flexCheckDDimer1: $('#D_Dimer').val() || '',
                flexCheckVitaminD1: $('#Vitamin_D').val() || '',
                flexCheckVitaminB121: $('#Vitamin_B12').val() || '',
                flexCheckFerritin1: $('#Ferritin').val() || '',
                flexCheckVDRL1: $('#VDRL').val() || '',
                flexCheckDengueFever1: $('#Dengue_Fever_IgG_IgM').val() || '',
                flexCheckGonorrheaAg1: $('#Gonorrhea_Ag').val() || '',
                flexCheckAFP1: $('#AFP').val() || '',
                flexCheckTotalPSA1: $('#Total_PSA').val() || '',
                flexCheckAMH1: $('#AMH').val() || '',
                flexCheckElectrolyteTest1: $('#Electrolyte_Test').val() || '',
                flexCheckCRPTiter1: $('#CRP_Titer').val() || '',
                flexCheckUltra1: $('#Ultra').val() || '',
                flexCheckTyphoidIgG1: $('#Typhoid_IgG').val() || '',
                flexCheckTyphoidAg1: $('#Typhoid_Ag').val() || ''
            };
            
            // Save results using exact same approach as test_details
            $.ajax({
                url: 'lab_waiting_list.aspx/updatetest',
                type: 'POST',
                contentType: 'application/json; charset=utf-8',
                data: JSON.stringify(data),
                dataType: 'json',
                success: function (response) {
                    $('#saveTestResults').prop('disabled', false).html('<i class="fas fa-save"></i> Save Results');
                    
                    if (response.d) {
                        alert(response.d);
                        $('#testResultsModal').modal('hide');
                        // Refresh the table
                        location.reload();
                    } else {
                        alert('Unexpected response from server.');
                    }
                },
                error: function () {
                    $('#saveTestResults').prop('disabled', false).html('<i class="fas fa-save"></i> Save Results');
                    alert('Error saving test results. Please try again.');
                }
            });
        });
    </script>
</asp:Content>
