<%@ Page Title="" Language="C#" MasterPageFile="~/register.Master" AutoEventWireup="true"
    CodeBehind="add_bed_charges.aspx.cs" Inherits="juba_hospital.add_bed_charges" %>

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

                #receiptPrint {
                    display: block;
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
                        <h5 class="modal-title">Process Bed Charge Payment</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="paymentBedChargeId" />
                        <input type="hidden" id="paymentPatientid" />

                        <div class="mb-3">
                            <label class="form-label">Patient Name</label>
                            <input type="text" class="form-control" id="paymentPatientName" readonly />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Charge Amount</label>
                            <input type="number" step="0.01" class="form-control" id="paymentAmount" readonly />
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

        <!-- Receipt Print Modal -->
        <div class="modal fade" id="receiptModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Receipt</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body" id="receiptContent">
                        <!-- Receipt content will be populated here -->
                    </div>
                    <div class="modal-footer no-print">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" onclick="window.print()" class="btn btn-primary">Print Receipt</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h4 class="card-title mb-1">Bed Charges - Daily Breakdown</h4>
                        <p class="text-muted mb-0">View and process bed charges for all inpatients by day</p>
                    </div>
                    <div class="card-body">
                        <!-- Desktop Table View -->
                        <div class="table-responsive">
                        <table class="display nowrap" style="width:100%" id="datatable">
                            <thead>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Day #</th>
                                    <th>Charge Date</th>
                                    <th>Amount</th>
                                    <th>Phone</th>
                                    <th>Doctor</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tfoot>
                                <tr>
                                    <th>Patient Name</th>
                                    <th>Day #</th>
                                    <th>Charge Date</th>
                                    <th>Amount</th>
                                    <th>Phone</th>
                                    <th>Doctor</th>
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
            var bedChargeAmount = 0;
            var dataTable;

            $(document).ready(function () {
                // Initialize DataTable with mobile responsiveness
                dataTable = $('#datatable').DataTable({
                    dom: 'Bfrtip',
                    buttons: ['excelHtml5'],
                    responsive: true,
                    autoWidth: false,
                    order: [[2, 'desc']], // Order by Charge Date (column index 2), newest first
                    columnDefs: [
                        { responsivePriority: 1, targets: 0 }, // Patient Name
                        { responsivePriority: 2, targets: -1 } // Actions
                    ]
                });
                
                // Get bed charge amount
                $.ajax({
                    url: 'add_bed_charges.aspx/GetBedChargeAmount',
                    type: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    success: function (response) {
                        bedChargeAmount = response.d || 0;
                        console.log("Bed charge amount:", bedChargeAmount);
                    },
                    error: function (response) {
                        console.error("Error getting bed charge amount:", response);
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
                    url: 'add_bed_charges.aspx/GetPendingBedCharges',
                    type: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    success: function (response) {
                        console.log("GetPendingBedCharges response:", response);

                        // Clear existing data
                        dataTable.clear();
                        $('#mobileCards').empty();
                        
                        if (response.d && response.d.length > 0) {
                            console.log("Found " + response.d.length + " pending bed charges");
                            for (var i = 0; i < response.d.length; i++) {
                                var statusBadge = response.d[i].status === "Paid"
                                    ? '<span class="badge-paid">Paid</span>'
                                    : '<span class="badge-pending">Pending Payment</span>';

                                var actionBtn = response.d[i].status === "Paid"
                                    ? '<button class="btn btn-info" onclick="event.stopPropagation(); event.preventDefault(); viewReceipt(\''
                                    + response.d[i].prescid + '\'); return false;">View Receipt</button>'
                                    : '<button class="btn btn-success" onclick="event.stopPropagation(); event.preventDefault(); openPaymentModal(\''
                                    + response.d[i].bed_charge_id + '\', \''
                                    + response.d[i].patientid + '\', \''
                                    + response.d[i].full_name + '\', \''
                                    + response.d[i].bed_charge_amount + '\'); return false;">Process Payment</button>';

                                actionBtn += '<button type="button" class="btn btn-outline-primary ms-2" onclick="event.stopPropagation(); event.preventDefault(); openInvoice(\''
                                    + response.d[i].patientid + '\'); return false;">Print Invoice</button>';

                                // Add row data to DataTable (for desktop)
                                dataTable.row.add([
                                    response.d[i].full_name,
                                    'Day ' + response.d[i].day_number,
                                    response.d[i].charge_date_formatted,
                                    '$' + parseFloat(response.d[i].bed_charge_amount).toFixed(2),
                                    response.d[i].phone,
                                    response.d[i].doctortitle,
                                    statusBadge,
                                    actionBtn
                                ]);
                                
                                // Create mobile card view
                                var card = `
                                    <div class="patient-charge-card">
                                        <h5><i class="fas fa-user"></i> ${response.d[i].full_name}</h5>
                                        <p><strong>Day:</strong> Day ${response.d[i].day_number}</p>
                                        <p><strong>Charge Date:</strong> ${response.d[i].charge_date_formatted}</p>
                                        <p><strong>Amount:</strong> $${parseFloat(response.d[i].bed_charge_amount).toFixed(2)}</p>
                                        <p><strong>Phone:</strong> ${response.d[i].phone}</p>
                                        <p><strong>Doctor:</strong> ${response.d[i].doctortitle}</p>
                                        <p><strong>Status:</strong> ${statusBadge}</p>
                                        <div class="mt-2">
                                            ${actionBtn}
                                        </div>
                                    </div>
                                `;
                                $('#mobileCards').append(card);
                            }
                        } else {
                            $('#mobileCards').html('<div class="alert alert-info"><i class="fas fa-info-circle"></i> No inpatients found or all bed charges have been paid.</div>');
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

            function openPaymentModal(bedChargeId, patientid, patientName, amount) {
                $('#paymentBedChargeId').val(bedChargeId);
                $('#paymentPatientid').val(patientid);
                $('#paymentPatientName').val(patientName);
                $('#paymentAmount').val(amount);
                $('#paymentModal').modal('show');
            }

            function processPayment() {
                var bedChargeId = $('#paymentBedChargeId').val();
                var patientid = $('#paymentPatientid').val();
                var amount = $('#paymentAmount').val();
                var paymentMethod = $('#paymentMethod').val();

                $.ajax({
                    url: 'add_bed_charges.aspx/ProcessBedPayment',
                    type: 'POST',
                    contentType: "application/json",
                    data: JSON.stringify({
                        bedChargeId: bedChargeId,
                        patientid: patientid,
                        amount: amount,
                        paymentMethod: paymentMethod
                    }),
                    dataType: "json",
                    success: function (response) {
                        if (response.d === "Success") {
                            $('#paymentModal').modal('hide');
                            Swal.fire('Success', 'Payment processed successfully!', 'success');
                            loadPendingCharges();
                        } else {
                            Swal.fire('Error', response.d, 'error');
                        }
                    },
                    error: function (response) {
                        Swal.fire('Error', 'Error processing payment', 'error');
                    }
                });
            }

            function viewReceipt(prescid) {
                Swal.fire('Info', 'Receipt feature coming soon. Check patient charges history.', 'info');
            }

            function openInvoice(patientId) {
                if (!patientId) {
                    Swal.fire('Info', 'Select a patient first', 'info');
                    return;
                }
                window.open('patient_invoice_print.aspx?patientid=' + encodeURIComponent(patientId), '_blank');
            }
        </script>
    </asp:Content>
