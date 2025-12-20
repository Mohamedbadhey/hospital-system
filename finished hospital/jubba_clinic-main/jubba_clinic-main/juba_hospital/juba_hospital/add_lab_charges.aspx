<%@ Page Title="" Language="C#" MasterPageFile="~/register.Master" AutoEventWireup="true"
    CodeBehind="add_lab_charges.aspx.cs" Inherits="juba_hospital.add_lab_charges" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link href="datatables/datatables.min.css" rel="stylesheet" />
        <style>
            .dataTables_wrapper .dataTables_filter {
                float: right;
                text-align: right;
            }

            .dataTables_wrapper .dataTables_length {
                float: left;
            }

            #datatable {
                width: 100%;
                margin: 20px 0;
                font-size: 14px;
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

            .btn-success {
                background-color: #28a745;
                border-color: #28a745;
            }

            .badge-paid {
                background-color: #28a745;
                color: white;
                padding: 5px 10px;
                border-radius: 4px;
            }

            .badge-pending {
                background-color: #ffc107;
                color: black;
                padding: 5px 10px;
                border-radius: 4px;
            }

            @media print {
                .no-print {
                    display: none;
                }

            }
            
            /* Mobile Card Layout */
            .mobile-card-view {
                display: none;
            }
            
            .patient-charge-card {
                background: white;
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            
            .patient-charge-card h5 {
                color: #007bff;
                margin-bottom: 10px;
                font-size: 16px;
            }
            
            .patient-charge-card p {
                margin: 5px 0;
                font-size: 13px;
            }
            
            .patient-charge-card .badge-paid,
            .patient-charge-card .badge-pending {
                display: inline-block;
                margin: 5px 0;
            }
            
            .patient-charge-card .btn {
                width: 100%;
                margin: 5px 0;
            }
            
            .mobile-search-box {
                display: none;
                margin-bottom: 15px;
            }
            
            .mobile-search-box input {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
                font-size: 14px;
            }
            
            .mobile-search-box input:focus {
                outline: none;
                border-color: #007bff;
                box-shadow: 0 0 5px rgba(0,123,255,0.3);
            }
            
            /* Mobile Responsive Styles */
            @media (max-width: 991px) {
                /* Hide table on mobile, show card view */
                .table-responsive {
                    display: none !important;
                }
                
                .mobile-card-view {
                    display: block;
                }
                
                .mobile-search-box {
                    display: block;
                }
                
                .card-header {
                    padding: 15px 10px;
                }
                
                .card-header h4 {
                    font-size: 16px;
                }
                
                .card-body {
                    padding: 10px;
                }
                
                .patient-charge-card {
                    padding: 12px;
                }
                
                .patient-charge-card h5 {
                    font-size: 15px;
                }
                
                .patient-charge-card p {
                    font-size: 12px;
                }
                
                .btn {
                    font-size: 12px;
                    padding: 8px 12px;
                }
            }
            
            @media (max-width: 576px) {
                .card-header h4 {
                    font-size: 14px;
                }
                
                .patient-charge-card h5 {
                    font-size: 14px;
                }
                
                .patient-charge-card p {
                    font-size: 11px;
                }
                
                .modal-dialog {
                    margin: 10px;
                }
                
                .modal-body {
                    padding: 15px;
                }
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <!-- Payment Modal -->
        <div class="modal fade" id="paymentModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Process Lab Charge Payment</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="paymentPrescid" />
                        <input type="hidden" id="paymentPatientid" />

                        <div class="mb-3">
                            <label class="form-label">Patient Name</label>
                            <input type="text" class="form-control" id="paymentPatientName" readonly />
                        </div>
                        
                        <!-- Itemized Test Charges -->
                        <div class="mb-3">
                            <label class="form-label"><strong>Lab Tests & Charges</strong></label>
                            <p class="text-muted" style="font-size: 0.9em;">Adjust actual amounts received if needed</p>
                            <div id="testChargesContainer" style="max-height: 300px; overflow-y: auto; border: 1px solid #ddd; border-radius: 4px; padding: 10px; background: #f8f9fa;">
                                <div class="text-center text-muted">Loading tests...</div>
                            </div>
                        </div>

                        <!-- Total Summary -->
                        <div class="mb-3" style="background: #e9ecef; padding: 15px; border-radius: 4px; border: 2px solid #dee2e6;">
                            <div class="row mb-2">
                                <div class="col-7">
                                    <strong>Expected Total:</strong>
                                </div>
                                <div class="col-5 text-end">
                                    <span id="expectedTotal" style="font-size: 1.1em;">$0.00</span>
                                </div>
                            </div>
                            <div class="row" style="border-top: 2px solid #495057; padding-top: 10px;">
                                <div class="col-7">
                                    <strong style="color: #28a745; font-size: 1.1em;">Actual Total Received:</strong>
                                </div>
                                <div class="col-5 text-end">
                                    <strong style="color: #28a745; font-size: 1.3em;" id="actualTotal">$0.00</strong>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Payment Method</label>
                            <select class="form-control" id="paymentMethod">
                                <option value="Cash">Cash</option>
                                <option value="Card">Card</option>
                                <option value="Mobile Payment">Mobile Payment</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" onclick="processPayment()" class="btn btn-success">Process
                            Payment</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Payment Modal -->
        <div class="modal fade" id="editPaymentModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-warning text-dark">
                        <h5 class="modal-title">
                            <i class="fas fa-edit"></i> Edit Payment Details
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="editPaymentPrescid" />
                        <input type="hidden" id="editPaymentPatientid" />

                        <div class="mb-3">
                            <label class="form-label">Patient Name</label>
                            <input type="text" class="form-control" id="editPaymentPatientName" readonly />
                        </div>
                        
                        <!-- Itemized Test Charges for Edit -->
                        <div class="mb-3">
                            <label class="form-label"><strong>Lab Tests & Charges</strong></label>
                            <p class="text-muted" style="font-size: 0.9em;">Edit payment amounts as needed</p>
                            <div id="editTestChargesContainer" style="max-height: 300px; overflow-y: auto; border: 1px solid #ddd; border-radius: 4px; padding: 10px; background: #f8f9fa;">
                                <div class="text-center text-muted">Loading tests...</div>
                            </div>
                        </div>

                        <!-- Total Summary -->
                        <div class="mb-3" style="background: #e9ecef; padding: 15px; border-radius: 4px; border: 2px solid #dee2e6;">
                            <div class="row mb-2">
                                <div class="col-7">
                                    <strong>Original Total:</strong>
                                </div>
                                <div class="col-5 text-end">
                                    <span id="editOriginalTotal" style="font-size: 1.1em;">$0.00</span>
                                </div>
                            </div>
                            <div class="row" style="border-top: 2px solid #495057; padding-top: 10px;">
                                <div class="col-7">
                                    <strong style="color: #ffc107; font-size: 1.1em;">New Total:</strong>
                                </div>
                                <div class="col-5 text-end">
                                    <strong style="color: #ffc107; font-size: 1.3em;" id="editNewTotal">$0.00</strong>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Payment Method</label>
                            <select class="form-control" id="editPaymentMethod">
                                <option value="Cash">Cash</option>
                                <option value="Card">Card</option>
                                <option value="Mobile Payment">Mobile Payment</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" onclick="updatePayment()" class="btn btn-warning">
                            <i class="fas fa-save"></i> Update Payment
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Receipt modal removed -->

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h4 class="card-title">Lab Charges Management</h4>
                        <p class="text-muted">Process pending payments or edit already paid charges</p>
                    </div>
                    <div class="card-body">
                        <!-- Desktop Table View -->
                        <div class="table-responsive">
                        <table class="display nowrap" style="width:100%" id="datatable">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Lab Order ID</th>
                                    <th>Prescription ID</th>
                                    <th>Phone</th>
                                    <th>Location</th>
                                    <th>Doctor</th>
                                    <th>Order Date</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tfoot>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Lab Order ID</th>
                                    <th>Prescription ID</th>
                                    <th>Phone</th>
                                    <th>Location</th>
                                    <th>Doctor</th>
                                    <th>Date Registered</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </tfoot>
                            <tbody></tbody>
                        </table>
                        </div>
                        
                        <!-- Mobile Card View -->
                        <div class="mobile-card-view">
                            <div class="mobile-search-box">
                                <input type="text" id="mobileSearch" placeholder="Search by name, phone, or location..." />
                            </div>
                            <div id="mobileCards">
                                <!-- Cards will be populated here -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="assets/js/core/jquery-3.7.1.min.js"></script>
        <script src="datatables/datatables.min.js"></script>
        <script src="assets/sweetalert2.min.js"></script>

        <script>
            var labChargeAmount = 0;
            var dataTable;

            $(document).ready(function () {
                // Initialize DataTable with mobile responsiveness
                dataTable = $('#datatable').DataTable({
                    dom: 'Bfrtip',
                    buttons: ['excelHtml5'],
                    responsive: true,
                    autoWidth: false,
                    order: [[6, 'desc']], // Order by Order Date (column index 6), newest first
                    columnDefs: [
                        { responsivePriority: 1, targets: 0 }, // Patient Name
                        { responsivePriority: 2, targets: -1 } // Actions
                    ]
                });
                
                // Get lab charge amount
                $.ajax({
                    url: 'add_lab_charges.aspx/GetLabChargeAmount',
                    type: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    success: function (response) {
                        labChargeAmount = response.d || 0;
                        console.log("Lab charge amount:", labChargeAmount);
                    },
                    error: function (response) {
                        console.error("Error getting lab charge amount:", response);
                    }
                });

                loadPendingCharges();
                
                // Mobile search functionality
                $('#mobileSearch').on('keyup', function() {
                    var searchText = $(this).val().toLowerCase();
                    $('.patient-charge-card').each(function() {
                        var cardText = $(this).text().toLowerCase();
                        if (cardText.indexOf(searchText) > -1) {
                            $(this).show();
                        } else {
                            $(this).hide();
                        }
                    });
                });
            });

            function loadPendingCharges() {
                $.ajax({
                    url: 'add_lab_charges.aspx/GetPendingLabCharges',
                    type: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    success: function (response) {
                        console.log("GetPendingLabCharges response:", response);

                        // Clear existing data
                        dataTable.clear();
                        $('#mobileCards').empty();
                        
                        if (response.d && response.d.length > 0) {
                            console.log("Found " + response.d.length + " pending lab charges");
                            for (var i = 0; i < response.d.length; i++) {
                                var statusBadge = response.d[i].status === "Paid"
                                    ? '<span class="badge-paid">Paid</span>'
                                    : '<span class="badge-pending">Pending Payment</span>';

                                var actionBtn = '';
                                
                                if (response.d[i].status === "Paid") {
                                    // Receipt button removed
                                    actionBtn += '<button class="btn btn-warning btn-sm me-1" onclick="event.stopPropagation(); event.preventDefault(); openEditPaymentModal(\''
                                        + response.d[i].prescid + '\', \''
                                        + response.d[i].lab_order_id + '\', \''
                                        + response.d[i].patientid + '\', \''
                                        + response.d[i].full_name + '\'); return false;"><i class="fas fa-edit"></i> Edit</button>';
                                } else {
                                    actionBtn += '<button class="btn btn-success btn-sm me-1" onclick="event.stopPropagation(); event.preventDefault(); openPaymentModal(\''
                                        + response.d[i].prescid + '\', \''
                                        + response.d[i].patientid + '\', \''
                                        + response.d[i].full_name + '\'); return false;">Process Payment</button>';
                                }

                                actionBtn += '<button type="button" class="btn btn-outline-primary btn-sm" onclick="event.stopPropagation(); event.preventDefault(); openInvoice(\''
                                    + response.d[i].patientid + '\'); return false;">Print Invoice</button>';

                                // Add row data to DataTable (for desktop)
                                dataTable.row.add([
                                    response.d[i].full_name,
                                    '<span class="badge bg-success">' + response.d[i].lab_order_id + '</span>',
                                    '<span class="badge bg-primary">' + response.d[i].prescid + '</span>',
                                    response.d[i].phone,
                                    response.d[i].location,
                                    response.d[i].doctortitle,
                                    response.d[i].lab_order_date || response.d[i].date_registered,
                                    statusBadge,
                                    actionBtn
                                ]);
                                
                                // Create mobile card view
                                var card = `
                                    <div class="patient-charge-card">
                                        <h5><i class="fas fa-user"></i> ${response.d[i].full_name}</h5>
                                        <p><strong>Lab Order ID:</strong> <span class="badge bg-success">${response.d[i].lab_order_id}</span></p>
                                        <p><strong>Prescription ID:</strong> <span class="badge bg-primary">${response.d[i].prescid}</span></p>
                                        <p><strong>Phone:</strong> ${response.d[i].phone}</p>
                                        <p><strong>Location:</strong> ${response.d[i].location}</p>
                                        <p><strong>Doctor:</strong> ${response.d[i].doctortitle}</p>
                                        <p><strong>Order Date:</strong> ${response.d[i].lab_order_date || response.d[i].date_registered}</p>
                                        <p><strong>Status:</strong> ${statusBadge}</p>
                                        <div class="mt-2">
                                            ${actionBtn}
                                        </div>
                                    </div>
                                `;
                                $('#mobileCards').append(card);
                            }
                        } else {
                            $('#mobileCards').html('<div class="alert alert-info">No pending lab charges found</div>');
                        }
                        
                        // Redraw the table to apply changes and maintain responsiveness
                        dataTable.draw();
                    },
                    error: function (response) {
                        console.error("Error loading pending charges:", response);
                        alert("Error loading pending charges: " + response.responseText);
                    }
                });
            }

            function openPaymentModal(prescid, patientid, patientName) {

                // Set hidden fields
                $("#paymentPrescid").val(prescid);
                $("#paymentPatientid").val(patientid);
                $("#paymentPatientName").val(patientName);

                // Load itemized test charges breakdown
                $.ajax({
                    url: 'add_lab_charges.aspx/GetLabChargeBreakdown',
                    type: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    data: JSON.stringify({ prescid: prescid }),
                    success: function (response) {
                        if (response.d && response.d.success) {
                            displayTestCharges(response.d);
                            $("#paymentModal").modal("show");
                        } else {
                            Swal.fire("Error", response.d.message || "Unable to load test charges", "error");
                        }
                    },
                    error: function (response) {
                        console.error("Error getting lab charge breakdown:", response);
                        Swal.fire("Error", "Unable to load charge breakdown", "error");
                    }
                });
            }

            function displayTestCharges(data) {
                var container = $("#testChargesContainer");
                container.empty();

                if (!data.tests || data.tests.length === 0) {
                    container.html('<div class="text-center text-muted">No tests found</div>');
                    return;
                }

                var expectedTotal = 0;

                data.tests.forEach(function(test, index) {
                    expectedTotal += test.price;

                    var testRow = $('<div class="test-charge-row" style="margin-bottom: 10px; padding: 10px; background: white; border-radius: 4px; border: 1px solid #dee2e6;"></div>');
                    
                    testRow.html(`
                        <div class="row align-items-center">
                            <div class="col-6">
                                <strong>${test.testDisplayName}</strong>
                                <input type="hidden" class="test-name" value="${test.testName}" />
                                <input type="hidden" class="test-charge-id" value="${test.chargeId}" />
                            </div>
                            <div class="col-3 text-end">
                                <small class="text-muted">Expected:</small><br/>
                                <strong>$${test.price.toFixed(2)}</strong>
                            </div>
                            <div class="col-3">
                                <label style="font-size: 0.8em; margin-bottom: 2px;">Actual:</label>
                                <input type="number" 
                                       class="form-control form-control-sm actual-amount" 
                                       value="${test.price.toFixed(2)}" 
                                       step="0.01" 
                                       min="0"
                                       data-expected="${test.price}"
                                       onchange="updateTotals()" 
                                       style="font-weight: bold; text-align: right;" />
                            </div>
                        </div>
                    `);

                    container.append(testRow);
                });

                $("#expectedTotal").text("$" + expectedTotal.toFixed(2));
                updateTotals(); // Calculate actual total
            }

            function updateTotals() {
                var actualTotal = 0;
                $(".actual-amount").each(function() {
                    var value = parseFloat($(this).val()) || 0;
                    actualTotal += value;
                });
                $("#actualTotal").text("$" + actualTotal.toFixed(2));

                // Highlight if different from expected
                var expected = parseFloat($("#expectedTotal").text().replace('$', ''));
                if (actualTotal < expected) {
                    $("#actualTotal").css("color", "#dc3545"); // Red if less
                } else if (actualTotal > expected) {
                    $("#actualTotal").css("color", "#007bff"); // Blue if more
                } else {
                    $("#actualTotal").css("color", "#28a745"); // Green if exact
                }
            }
            function processPayment() {
            
                var prescid = $("#paymentPrescid").val();
                var patientid = $("#paymentPatientid").val();
                var paymentMethod = $("#paymentMethod").val();

                // Collect individual charge amounts
                var chargePayments = [];
                $(".test-charge-row").each(function() {
                    var chargeId = $(this).find(".test-charge-id").val();
                    var actualAmount = parseFloat($(this).find(".actual-amount").val()) || 0;
                    
                    chargePayments.push({
                        chargeId: parseInt(chargeId),
                        actualAmount: actualAmount
                    });
                });

                $.ajax({
                    url: 'add_lab_charges.aspx/ProcessLabChargeWithAmounts',
                    type: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    data: JSON.stringify({
                        prescid: prescid,
                        patientid: patientid,
                        chargePayments: chargePayments,
                        paymentMethod: paymentMethod
                    }),
                    success: function (response) {

                        if (response.d && response.d.indexOf("Error") === -1) {

                            $('#paymentModal').modal('hide');
                            var invoiceNumber = response.d;

                            Swal.fire("Success!", "Payment processed successfully", "success")
                                .then(() => {
                                    loadPendingCharges();
                                    // Receipt removed
                                });

                        } else {
                            Swal.fire("Error", response.d || "Payment failed", "error");
                        }
                    },
                    error: function (response) {
                        Swal.fire("Error", response.responseText, "error");
                    }
                });
            }

            function openEditPaymentModal(prescid, labOrderId, patientid, patientName) {
                // Set hidden fields
                $("#editPaymentPrescid").val(prescid);
                $("#editPaymentPatientid").val(patientid);
                $("#editPaymentPatientName").val(patientName);

                // Load existing payment data for this specific lab order
                $.ajax({
                    url: 'add_lab_charges.aspx/GetPaidLabChargesForOrder',
                    type: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    data: JSON.stringify({ prescid: prescid, labOrderId: labOrderId }),
                    success: function (response) {
                        if (response.d && response.d.success) {
                            displayEditTestCharges(response.d);
                            $("#editPaymentModal").modal("show");
                        } else {
                            Swal.fire("Error", response.d.message || "Unable to load payment details", "error");
                        }
                    },
                    error: function (response) {
                        console.error("Error getting paid charges:", response);
                        Swal.fire("Error", "Unable to load payment details", "error");
                    }
                });
            }

            function displayEditTestCharges(data) {
                var container = $("#editTestChargesContainer");
                container.empty();

                if (!data.tests || data.tests.length === 0) {
                    container.html('<div class="text-center text-muted">No paid charges found</div>');
                    return;
                }

                var originalTotal = 0;

                // Set payment method from first charge
                if (data.tests.length > 0 && data.tests[0].paymentMethod) {
                    $("#editPaymentMethod").val(data.tests[0].paymentMethod);
                }

                data.tests.forEach(function(test, index) {
                    originalTotal += test.amount;

                    var testRow = $('<div class="edit-test-charge-row" style="margin-bottom: 10px; padding: 10px; background: white; border-radius: 4px; border: 1px solid #dee2e6;"></div>');
                    
                    testRow.html(`
                        <div class="row align-items-center">
                            <div class="col-6">
                                <strong>${test.chargeName}</strong>
                                <input type="hidden" class="edit-test-charge-id" value="${test.chargeId}" />
                                <br/><small class="text-muted">Invoice: ${test.invoiceNumber}</small>
                            </div>
                            <div class="col-3 text-end">
                                <small class="text-muted">Original:</small><br/>
                                <strong>$${test.amount.toFixed(2)}</strong>
                            </div>
                            <div class="col-3">
                                <label style="font-size: 0.8em; margin-bottom: 2px;">New Amount:</label>
                                <input type="number" 
                                       class="form-control form-control-sm edit-actual-amount" 
                                       value="${test.amount.toFixed(2)}" 
                                       step="0.01" 
                                       min="0"
                                       data-original="${test.amount}"
                                       onchange="updateEditTotals()" 
                                       style="font-weight: bold; text-align: right;" />
                            </div>
                        </div>
                    `);

                    container.append(testRow);
                });

                $("#editOriginalTotal").text("$" + originalTotal.toFixed(2));
                updateEditTotals(); // Calculate new total
            }

            function updateEditTotals() {
                var newTotal = 0;
                $(".edit-actual-amount").each(function() {
                    var value = parseFloat($(this).val()) || 0;
                    newTotal += value;
                });
                $("#editNewTotal").text("$" + newTotal.toFixed(2));

                // Highlight if different from original
                var original = parseFloat($("#editOriginalTotal").text().replace('$', ''));
                if (newTotal < original) {
                    $("#editNewTotal").css("color", "#dc3545"); // Red if less
                } else if (newTotal > original) {
                    $("#editNewTotal").css("color", "#007bff"); // Blue if more
                } else {
                    $("#editNewTotal").css("color", "#28a745"); // Green if same
                }
            }

            function updatePayment() {
                var prescid = $("#editPaymentPrescid").val();
                var paymentMethod = $("#editPaymentMethod").val();

                // Collect updated charge amounts
                var chargeUpdates = [];
                $(".edit-test-charge-row").each(function() {
                    var chargeId = $(this).find(".edit-test-charge-id").val();
                    var newAmount = parseFloat($(this).find(".edit-actual-amount").val()) || 0;
                    
                    chargeUpdates.push({
                        chargeId: parseInt(chargeId),
                        newAmount: newAmount
                    });
                });

                $.ajax({
                    url: 'add_lab_charges.aspx/UpdateLabChargePayment',
                    type: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    data: JSON.stringify({
                        prescid: prescid,
                        chargeUpdates: chargeUpdates,
                        paymentMethod: paymentMethod
                    }),
                    success: function (response) {
                        if (response.d && response.d.success) {
                            $('#editPaymentModal').modal('hide');
                            
                            Swal.fire("Success!", "Payment updated successfully", "success")
                                .then(() => {
                                    loadPendingCharges();
                                });
                        } else {
                            Swal.fire("Error", response.d.message || "Update failed", "error");
                        }
                    },
                    error: function (response) {
                        console.error("Error updating payment:", response);
                        Swal.fire("Error", "Failed to update payment", "error");
                    }
                });
            }

           

            // Receipt functions removed

            function openInvoice(patientId) {
                if (!patientId) {
                    Swal.fire('Info', 'Select a patient first', 'info');
                    return;
                }
                // Open patient invoice in new window
                window.open('patient_invoice_print.aspx?patientid=' + patientId, '_blank');
            }
        </script>
    </asp:Content>