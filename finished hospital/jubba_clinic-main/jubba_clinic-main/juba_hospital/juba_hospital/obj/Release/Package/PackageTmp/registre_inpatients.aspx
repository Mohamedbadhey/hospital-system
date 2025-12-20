<%@ Page Title="Inpatients Management" Language="C#" MasterPageFile="~/register.Master" AutoEventWireup="true" CodeBehind="registre_inpatients.aspx.cs" Inherits="juba_hospital.registre_inpatients" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <style>
        .patient-card {
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .badge-status {
            font-size: 12px;
            padding: 5px 10px;
        }
        .charge-summary {
            background: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .print-btn {
            margin: 5px;
        }
        .total-row {
            font-weight: bold;
            background-color: #e9ecef;
        }
        .paid-status {
            color: #28a745;
        }
        .unpaid-status {
            color: #dc3545;
        }
        .detail-section {
            margin-top: 15px;
        }
        .section-header {
            background: #007bff;
            color: white;
            padding: 8px 15px;
            border-radius: 4px;
            margin-bottom: 10px;
        }
        
        /* Mobile Responsive Styles */
        @media (max-width: 768px) {
            .patient-card .row {
                flex-direction: column;
            }
            
            .patient-card .col-md-8,
            .patient-card .col-md-4 {
                max-width: 100%;
                flex: 0 0 100%;
            }
            
            .patient-card .text-right {
                text-align: left !important;
                margin-top: 15px;
            }
            
            .patient-card h5 {
                font-size: 16px;
            }
            
            .patient-card p {
                font-size: 13px;
            }
            
            .badge-status {
                font-size: 10px;
                padding: 3px 6px;
                display: inline-block;
                margin: 2px;
            }
            
            .charge-summary h6 {
                font-size: 14px;
            }
            
            .print-btn {
                width: 100%;
                margin: 3px 0;
            }
            
            .table-responsive {
                font-size: 12px;
            }
            
            .table-responsive th,
            .table-responsive td {
                padding: 5px;
                white-space: nowrap;
            }
            
            /* Filter buttons stack on mobile */
            .row.mb-3 .col-md-3 {
                margin-bottom: 10px;
            }
            
            .btn-block {
                width: 100%;
            }
        }
        
        @media (max-width: 576px) {
            .patient-card {
                margin-bottom: 15px;
            }
            
            .patient-card h5 {
                font-size: 14px;
            }
            
            .patient-card p {
                font-size: 12px;
                line-height: 1.4;
            }
            
            .section-header {
                font-size: 14px;
                padding: 6px 10px;
            }
            
            .charge-summary {
                padding: 8px;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-inner">
        <div class="page-header">
            <h4 class="page-title">Inpatients Management</h4>
            <ul class="breadcrumbs">
                <li class="nav-home">
                    <a href="Add_patients.aspx"><i class="flaticon-home"></i></a>
                </li>
                <li class="separator"><i class="flaticon-right-arrow"></i></li>
                <li class="nav-item">Inpatients List</li>
            </ul>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex align-items-center">
                            <h4 class="card-title">Active Inpatients</h4>
                            <button class="btn btn-primary btn-round ml-auto" onclick="printAllInpatients()">
                                <i class="fa fa-print"></i> Print All Inpatients
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <!-- Filter Options -->
                        <div class="row mb-3">
                            <div class="col-md-3">
                                <input type="text" id="searchPatient" class="form-control" placeholder="Search by name, phone, or ID...">
                            </div>
                            <div class="col-md-3">
                                <select id="filterPayment" class="form-control">
                                    <option value="">All Payment Status</option>
                                    <option value="paid">Fully Paid</option>
                                    <option value="unpaid">Has Unpaid</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <input type="date" id="filterDate" class="form-control" placeholder="Filter by admission date">
                            </div>
                            <div class="col-md-3">
                                <button type="button" class="btn btn-secondary btn-block" onclick="resetFilters()">
                                    <i class="fa fa-undo"></i> Reset Filters
                                </button>
                            </div>
                        </div>

                        <!-- Inpatients List -->
                        <asp:Repeater ID="rptInpatients" runat="server">
                            <ItemTemplate>
                                <div class="patient-card card">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-8">
                                                <h5>
                                                    <strong><%# Eval("full_name") %></strong>
                                                    <span class="badge badge-info badge-status">ID: <%# Eval("patientid") %></span>
                                                    <span class="badge badge-success badge-status">Inpatient</span>
                                                </h5>
                                                <p class="mb-1">
                                                    <i class="fa fa-calendar"></i> DOB: <%# Eval("dob", "{0:MMM dd, yyyy}") %> | 
                                                    <i class="fa fa-venus-mars"></i> <%# Eval("sex") %> | 
                                                    <i class="fa fa-phone"></i> <%# Eval("phone") %> | 
                                                    <i class="fa fa-map-marker"></i> <%# Eval("location") %>
                                                </p>
                                                <p class="mb-1">
                                                    <i class="fa fa-bed"></i> Admitted: <%# Eval("bed_admission_date", "{0:MMM dd, yyyy hh:mm tt}") %> |
                                                    <i class="fa fa-clock"></i> Days: <strong><%# Eval("days_admitted") %></strong>
                                                </p>
                                            </div>
                                            <div class="col-md-4 text-right">
                                                <div class="charge-summary">
                                                    <h6>Total Charges: $<%# Eval("total_charges", "{0:N2}") %></h6>
                                                    <p class="mb-0 paid-status">Paid: $<%# Eval("paid_amount", "{0:N2}") %></p>
                                                    <p class="mb-0 unpaid-status">Unpaid: $<%# Eval("unpaid_amount", "{0:N2}") %></p>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Action Buttons -->
                                        <div class="row mt-3">
                                            <div class="col-md-12">
                                                <button type="button" class="btn btn-sm btn-info print-btn" onclick="viewPatientDetails(<%# Eval("patientid") %>)">
                                                    <i class="fa fa-eye"></i> View Details
                                                </button>
                                                <button type="button" class="btn btn-sm btn-primary print-btn" onclick="printPatientSummary(<%# Eval("patientid") %>, <%# Eval("prescid") ?? "0" %>)">
                                                    <i class="fa fa-print"></i> Print Summary
                                                </button>
                                                <button type="button" class="btn btn-sm btn-success print-btn" onclick="printInvoice(<%# Eval("patientid") %>)">
                                                    <i class="fa fa-file-invoice"></i> Print Invoice
                                                </button>
                                                <button type="button" class="btn btn-sm btn-warning print-btn" onclick="printFullReport(<%# Eval("patientid") %>, <%# Eval("prescid") ?? "0" %>)">
                                                    <i class="fa fa-file-medical-alt"></i> Full Report
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Collapsible Details -->
                                        <div class="detail-section" id="details_<%# Eval("patientid") %>" style="display:none;">
                                            <hr>
                                            <asp:HiddenField ID="hdnPatientId" runat="server" Value='<%# Eval("patientid") %>' />
                                            
                                            <!-- Charges Section -->
                                            <div class="section-header">
                                                <i class="fa fa-dollar-sign"></i> Charges Breakdown
                                            </div>
                                            <div class="table-responsive">
                                                <table class="table table-sm table-bordered">
                                                    <thead class="thead-light">
                                                        <tr>
                                                            <th>Date</th>
                                                            <th>Type</th>
                                                            <th>Description</th>
                                                            <th>Amount</th>
                                                            <th>Status</th>
                                                            <th>Payment Method</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody class="charges-data" data-patientid="<%# Eval("patientid") %>">
                                                        <tr><td colspan="6" class="text-center">Loading...</td></tr>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <!-- Medications Section -->
                                            <div class="section-header mt-3">
                                                <i class="fa fa-pills"></i> Medications
                                            </div>
                                            <div class="table-responsive">
                                                <table class="table table-sm table-bordered">
                                                    <thead class="thead-light">
                                                        <tr>
                                                            <th>Medication</th>
                                                            <th>Dosage</th>
                                                            <th>Frequency</th>
                                                            <th>Duration</th>
                                                            <th>Instructions</th>
                                                            <th>Date Prescribed</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody class="medications-data" data-patientid="<%# Eval("patientid") %>">
                                                        <tr><td colspan="6" class="text-center">Loading...</td></tr>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <!-- Lab Tests Section -->
                                            <div class="section-header mt-3">
                                                <i class="fa fa-flask"></i> Lab Tests
                                            </div>
                                            <div class="labtests-data" data-patientid="<%# Eval("patientid") %>" style="padding:10px;">
                                                <div class="text-center" style="padding:20px; color:#999;">
                                                    <i class="fa fa-spinner fa-spin"></i> Loading lab tests...
                                                </div>
                                            </div>

                                            <!-- X-ray Section -->
                                            <div class="section-header mt-3">
                                                <i class="fa fa-x-ray"></i> X-ray Tests
                                            </div>
                                            <div class="table-responsive">
                                                <table class="table table-sm table-bordered">
                                                    <thead class="thead-light">
                                                        <tr>
                                                            <th>X-ray Type</th>
                                                            <th>Status</th>
                                                            <th>Ordered Date</th>
                                                            <th>Completed Date</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody class="xrays-data" data-patientid="<%# Eval("patientid") %>">
                                                        <tr><td colspan="5" class="text-center">Loading...</td></tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>

                        <div id="noData" runat="server" visible="false" class="alert alert-info">
                            <i class="fa fa-info-circle"></i> No active inpatients found.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="datatables/datatables.min.js"></script>
    <script src="assets/sweetalert2.min.js"></script>
    <script>
        function viewPatientDetails(patientId) {
            var detailsDiv = document.getElementById('details_' + patientId);
            if (detailsDiv.style.display === 'none') {
                detailsDiv.style.display = 'block';
                loadPatientDetails(patientId);
            } else {
                detailsDiv.style.display = 'none';
            }
        }

        function loadPatientDetails(patientId) {
            // Load Charges
            $.ajax({
                type: "POST",
                url: "registre_inpatients.aspx/GetPatientCharges",
                data: JSON.stringify({ patientId: patientId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var charges = JSON.parse(response.d);
                    var html = '';
                    var total = 0;
                    if (charges.length === 0) {
                        html = '<tr><td colspan="6" class="text-center">No charges recorded</td></tr>';
                    } else {
                        charges.forEach(function (charge) {
                            var statusClass = charge.is_paid == 1 ? 'badge-success' : 'badge-danger';
                            var statusText = charge.is_paid == 1 ? 'Paid' : 'Unpaid';
                            html += '<tr>' +
                                '<td>' + formatDate(charge.date_added) + '</td>' +
                                '<td>' + charge.charge_type + '</td>' +
                                '<td>' + charge.charge_name + '</td>' +
                                '<td>$' + parseFloat(charge.amount).toFixed(2) + '</td>' +
                                '<td><span class="badge ' + statusClass + '">' + statusText + '</span></td>' +
                                '<td>' + (charge.payment_method || '-') + '</td>' +
                                '</tr>';
                            total += parseFloat(charge.amount);
                        });
                        html += '<tr class="total-row"><td colspan="3" class="text-right">Total:</td><td colspan="3">$' + total.toFixed(2) + '</td></tr>';
                    }
                    $('.charges-data[data-patientid="' + patientId + '"]').html(html);
                },
                error: function () {
                    $('.charges-data[data-patientid="' + patientId + '"]').html('<tr><td colspan="6" class="text-center text-danger">Error loading charges</td></tr>');
                }
            });

            // Load Medications
            $.ajax({
                type: "POST",
                url: "registre_inpatients.aspx/GetPatientMedications",
                data: JSON.stringify({ patientId: patientId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var meds = JSON.parse(response.d);
                    var html = '';
                    if (meds.length === 0) {
                        html = '<tr><td colspan="6" class="text-center">No medications prescribed</td></tr>';
                    } else {
                        meds.forEach(function (med) {
                            html += '<tr>' +
                                '<td>' + med.med_name + '</td>' +
                                '<td>' + med.dosage + '</td>' +
                                '<td>' + med.frequency + '</td>' +
                                '<td>' + med.duration + '</td>' +
                                '<td>' + (med.special_inst || '-') + '</td>' +
                                '<td>' + (med.date_taken ? formatDate(med.date_taken) : '-') + '</td>' +
                                '</tr>';
                        });
                    }
                    $('.medications-data[data-patientid="' + patientId + '"]').html(html);
                },
                error: function () {
                    $('.medications-data[data-patientid="' + patientId + '"]').html('<tr><td colspan="6" class="text-center text-danger">Error loading medications</td></tr>');
                }
            });

            // Load Lab Tests
            $.ajax({
                type: "POST",
                url: "registre_inpatients.aspx/GetPatientLabTests",
                data: JSON.stringify({ patientId: patientId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var labTests = JSON.parse(response.d);
                    var html = '';
                    
                    if (labTests.length === 0) {
                        html = '<div class="alert alert-info">No lab tests ordered</div>';
                    } else {
                        // Display each lab order separately (like full report)
                        labTests.forEach(function (order, index) {
                            var statusBadge = order.status === 'Completed' 
                                ? '<span class="badge badge-success">Completed</span>' 
                                : '<span class="badge badge-warning">Pending</span>';
                            
                            html += '<div style="border:2px solid #9b59b6; border-radius:5px; padding:15px; margin-bottom:15px; background:#f9f9f9;">';
                            html += '<div style="background:#9b59b6; color:white; padding:8px; margin:-15px -15px 10px -15px; border-radius:3px 3px 0 0; font-weight:bold;">';
                            html += 'LAB ORDER #' + (index + 1) + ' - Order ID: ' + order.order_id + ' (Prescription: ' + order.prescid + ')';
                            html += '</div>';
                            
                            html += '<div style="margin-bottom:8px;"><strong>Status:</strong> ' + statusBadge + '</div>';
                            html += '<div style="margin-bottom:8px;"><strong>Ordered Date:</strong> ' + (order.ordered_date ? formatDate(order.ordered_date) : '-') + '</div>';
                            
                            // Display ordered tests
                            if (order.ordered_tests && order.ordered_tests.length > 0) {
                                html += '<div style="margin-top:12px;"><strong>Tests Ordered:</strong></div>';
                                html += '<ul style="margin:5px 0; padding-left:20px;">';
                                order.ordered_tests.forEach(function(test) {
                                    html += '<li>' + test + '</li>';
                                });
                                html += '</ul>';
                                
                                // Display results if available
                                if (order.status === 'Completed' && order.test_results && Object.keys(order.test_results).length > 0) {
                                    html += '<div style="margin-top:12px;"><strong>Lab Results:</strong></div>';
                                    html += '<table style="width:100%; margin-top:8px; border:1px solid #ddd;">';
                                    html += '<tr><th style="background:#ecf0f1; padding:8px; border:1px solid #bdc3c7;">Test</th><th style="background:#ecf0f1; padding:8px; border:1px solid #bdc3c7;">Result</th></tr>';
                                    
                                    for (var testName in order.test_results) {
                                        html += '<tr>';
                                        html += '<td style="padding:6px; border:1px solid #ddd;"><strong>' + testName + '</strong></td>';
                                        html += '<td style="padding:6px; border:1px solid #ddd;">' + order.test_results[testName] + '</td>';
                                        html += '</tr>';
                                    }
                                    
                                    html += '</table>';
                                } else if (order.status === 'Pending') {
                                    html += '<div style="margin-top:12px; padding:8px; background:#fff3cd; border-left:4px solid #ffc107;">';
                                    html += '<strong>Note:</strong> Lab tests are pending. Results not yet available.';
                                    html += '</div>';
                                }
                            } else {
                                html += '<div style="margin-top:12px; padding:8px; background:#f0f0f0;">No tests found for this order.</div>';
                            }
                            
                            html += '</div>';
                        });
                    }
                    
                    $('.labtests-data[data-patientid="' + patientId + '"]').html(html);
                },
                error: function () {
                    $('.labtests-data[data-patientid="' + patientId + '"]').html('<div class="alert alert-danger">Error loading lab tests</div>');
                }
            });

            // Load X-rays
            $.ajax({
                type: "POST",
                url: "registre_inpatients.aspx/GetPatientXrays",
                data: JSON.stringify({ patientId: patientId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    var xrays = JSON.parse(response.d);
                    var html = '';
                    if (xrays.length === 0) {
                        html = '<tr><td colspan="5" class="text-center">No X-rays ordered</td></tr>';
                    } else {
                        xrays.forEach(function (xray) {
                            var statusBadge = getXrayStatusBadge(xray.xray_status);
                            html += '<tr>' +
                                '<td>' + xray.xray_name + '</td>' +
                                '<td>' + statusBadge + '</td>' +
                                '<td>' + formatDate(xray.ordered_date) + '</td>' +
                                '<td>' + (xray.completed_date ? formatDate(xray.completed_date) : '-') + '</td>' +
                                '<td><button class="btn btn-xs btn-info" onclick="viewXray(' + xray.xray_result_id + ')"><i class="fa fa-eye"></i> View</button></td>' +
                                '</tr>';
                        });
                    }
                    $('.xrays-data[data-patientid="' + patientId + '"]').html(html);
                },
                error: function () {
                    $('.xrays-data[data-patientid="' + patientId + '"]').html('<tr><td colspan="5" class="text-center text-danger">Error loading X-rays</td></tr>');
                }
            });
        }

        function getLabStatusBadge(status) {
            switch (parseInt(status)) {
                case 0: return '<span class="badge badge-secondary">Waiting</span>';
                case 1: return '<span class="badge badge-info">Processed</span>';
                case 2: return '<span class="badge badge-warning">Pending X-ray</span>';
                case 3: return '<span class="badge badge-info">X-ray Processed</span>';
                case 4: return '<span class="badge badge-warning">Pending Lab</span>';
                case 5: return '<span class="badge badge-success">Lab Processed</span>';
                default: return '<span class="badge badge-secondary">Unknown</span>';
            }
        }

        function getXrayStatusBadge(status) {
            switch (parseInt(status)) {
                case 0: return '<span class="badge badge-secondary">Not Ordered</span>';
                case 1: return '<span class="badge badge-warning">Pending</span>';
                case 2: return '<span class="badge badge-success">Completed</span>';
                default: return '<span class="badge badge-secondary">Unknown</span>';
            }
        }

        function formatDate(dateStr) {
            if (!dateStr) return '-';
            var date = new Date(dateStr);
            return date.toLocaleDateString() + ' ' + date.toLocaleTimeString();
        }

        function printPatientSummary(patientId, prescid) {
            console.log('Print Summary - Patient ID:', patientId, 'Prescid:', prescid);
            
            var actualPrescId = (prescid && prescid > 0) ? prescid : patientId;
            
            if (actualPrescId && actualPrescId > 0) {
                window.open('visit_summary_print.aspx?prescid=' + actualPrescId, '_blank');
            } else {
                Swal.fire('No Prescription', 'This patient has no prescription record yet.', 'info');
            }
        }

        function printInvoice(patientId) {
            window.open('patient_invoice_print.aspx?patientid=' + patientId, '_blank');
        }
        
        function printFullReport(patientId, prescid) {
            console.log('Print Full Report - Patient ID:', patientId, 'Prescid:', prescid);
            
            var actualPrescId = (prescid && prescid > 0) ? prescid : patientId;
            
            // Open comprehensive INPATIENT report showing all lab tests with results
            window.open('inpatient_full_report.aspx?patientid=' + patientId + '&prescid=' + actualPrescId, '_blank');
        }

        function printLabResult(prescId) {
            window.open('lab_result_print.aspx?prescid=' + prescId, '_blank');
        }

        function viewXray(xrayResultId) {
            // Implement X-ray viewer
            Swal.fire('X-ray Viewer', 'X-ray viewing functionality', 'info');
        }

        // Wait for jQuery to be loaded
        function waitForJQuery(callback) {
            if (typeof jQuery !== 'undefined') {
                callback();
            } else {
                setTimeout(function() { waitForJQuery(callback); }, 50);
            }
        }

        function printAllInpatients() {
            var patientIds = [];
            $('.patient-card:visible').each(function() {
                var patientId = $(this).find('.badge:contains("ID:")').text().replace('ID:', '').trim();
                if (patientId) {
                    patientIds.push(patientId);
                }
            });

            if (patientIds.length === 0) {
                Swal.fire('No Patients', 'No patients to print. Please adjust your filters.', 'info');
                return;
            }

            var url = 'print_all_inpatients.aspx?patientids=' + patientIds.join(',');
            window.open(url, '_blank');
        }

        // Combined filter function
        function applyFilters() {
            var searchValue = $('#searchPatient').val().toLowerCase();
            var paymentFilter = $('#filterPayment').val();
            var dateFilter = $('#filterDate').val();
            var selectedDate = dateFilter ? new Date(dateFilter) : null;

            var visibleCount = 0;
            var totalCount = 0;

            $('.patient-card').each(function () {
                var $card = $(this);
                var showCard = true;
                totalCount++;

                // Search filter
                if (searchValue !== '') {
                    var cardText = $card.text().toLowerCase();
                    if (cardText.indexOf(searchValue) === -1) {
                        showCard = false;
                    }
                }

                // Payment status filter
                if (showCard && paymentFilter !== '') {
                    var unpaidText = $card.find('.unpaid-status').text();
                    var unpaidMatch = unpaidText.match(/Unpaid: \$([0-9.,]+)/);
                    var unpaidAmount = unpaidMatch ? parseFloat(unpaidMatch[1].replace(',', '')) : 0;

                    if (paymentFilter === 'paid' && unpaidAmount > 0) {
                        showCard = false;
                    } else if (paymentFilter === 'unpaid' && unpaidAmount === 0) {
                        showCard = false;
                    }
                }

                // Date filter
                if (showCard && selectedDate && !isNaN(selectedDate)) {
                    var dateText = $card.find('p:contains("Admitted:")').text();
                    var match = dateText.match(/Admitted: (.+)/);
                    if (match) {
                        var cardDate = new Date(match[1]);
                        if (cardDate.toDateString() !== selectedDate.toDateString()) {
                            showCard = false;
                        }
                    }
                }

                if (showCard) {
                    visibleCount++;
                }

                $card.toggle(showCard);
            });

            updatePatientCount();
        }

        function updatePatientCount() {
            var visibleCount = $('.patient-card:visible').length;
            var totalCount = $('.patient-card').length;
            
            var countDisplay = $('#patientCount');
            if (countDisplay.length === 0) {
                $('.card-title').after('<span id="patientCount" class="ml-2 badge badge-info"></span>');
                countDisplay = $('#patientCount');
            }
            countDisplay.text('Showing ' + visibleCount + ' of ' + totalCount + ' patients');
        }

        function resetFilters() {
            $('#searchPatient').val('');
            $('#filterPayment').val('');
            $('#filterDate').val('');
            applyFilters();
        }

        // Initialize when jQuery is loaded
        waitForJQuery(function() {
            $(document).ready(function() {
                updatePatientCount();
                
                $('#searchPatient').on('input keyup', function () {
                    applyFilters();
                });

                $('#filterPayment').on('change', function () {
                    applyFilters();
                });

                $('#filterDate').on('change', function () {
                    applyFilters();
                });
            });
        });
    </script>
</asp:Content>
