<%@ Page Title="Charge History" Language="C#" MasterPageFile="~/register.Master" AutoEventWireup="true"
    CodeBehind="charge_history.aspx.cs" Inherits="juba_hospital.charge_history" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" href="datatables/datatables.min.css" />
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
        <style>
            /* Mobile Card Layout */
            .mobile-card-view {
                display: none;
            }
            
            .charge-card {
                background: white;
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 15px;
                margin-bottom: 15px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            
            .charge-card h5 {
                color: #007bff;
                margin-bottom: 10px;
                font-size: 16px;
            }
            
            .charge-card p {
                margin: 5px 0;
                font-size: 13px;
            }
            
            .charge-card .badge {
                display: inline-block;
                margin: 5px 0;
            }
            
            .charge-card .btn {
                width: 100%;
                margin: 3px 0;
                font-size: 12px;
                padding: 8px;
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
                
                .card-header .d-flex {
                    flex-direction: column;
                }
                
                .card-header .form-select,
                .card-header .btn {
                    width: 100%;
                    margin: 5px 0;
                }
                
                .charge-card {
                    padding: 12px;
                }
                
                .charge-card h5 {
                    font-size: 15px;
                }
                
                .charge-card p {
                    font-size: 12px;
                }
            }
            
            @media (max-width: 576px) {
                .card-header h4 {
                    font-size: 16px;
                }
                
                .charge-card h5 {
                    font-size: 14px;
                }
                
                .charge-card p {
                    font-size: 11px;
                }
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header d-flex flex-wrap align-items-center justify-content-between">
                        <div>
                            <h4 class="card-title mb-1">Charge & Payment History</h4>
                            <p class="text-muted mb-0">Track every patient charge, make corrections, or re-print
                                invoices.</p>
                        </div>
                        <div class="d-flex gap-2 align-items-center mt-3 mt-md-0 w-100 w-md-auto flex-wrap">
                            <!-- Charge Type Filter -->
                            <select id="chargeTypeFilter" class="form-select" style="min-width: 140px;">
                                <option value="All">All Types</option>
                                <option value="Registration">Registration</option>
                                <option value="Lab">Lab</option>
                                <option value="Xray">X-ray</option>
                                <option value="Bed">Bed</option>
                                <option value="Delivery">Delivery</option>
                            </select>
                            
                            <!-- Date Range Filter -->
                            <select id="dateRangeFilter" class="form-select" style="min-width: 130px;" onchange="handleDateRangeChange()">
                                <option value="all">All Time</option>
                                <option value="today">Today</option>
                                <option value="yesterday">Yesterday</option>
                                <option value="week">This Week</option>
                                <option value="month">This Month</option>
                                <option value="custom">Custom Range</option>
                            </select>
                            
                            <!-- Custom Date Inputs (Hidden by default) -->
                            <input type="date" id="startDate" class="form-control" style="min-width: 150px; display: none;" />
                            <input type="date" id="endDate" class="form-control" style="min-width: 150px; display: none;" />
                            
                            <!-- Action Buttons -->
                            <button type="button" class="btn btn-primary" onclick="applyFilters(); return false;">
                                <i class="fas fa-filter"></i> Apply
                            </button>
                            <button type="button" class="btn btn-outline-secondary" onclick="resetFilters(); return false;">
                                <i class="fas fa-redo"></i> Reset
                            </button>
                            <button type="button" class="btn btn-outline-primary" onclick="printAllPatientsByChargeType(); return false;">
                                <i class="fas fa-print"></i> Print
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <!-- Desktop Table View -->
                        <div class="table-responsive">
                            <table id="chargeHistoryTable" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Invoice</th>
                                        <th>Patient</th>
                                        <th>Type</th>
                                        <th>Amount</th>
                                        <th>Payment Method</th>
                                        <th>Paid On</th>
                                        <th>Status</th>
                                        <th class="text-end">Actions</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        
                        <!-- Mobile Card View -->
                        <div class="mobile-card-view">
                            <div class="mobile-search-box">
                                <input type="text" id="mobileSearch" placeholder="Search by patient, invoice, or type..." />
                            </div>
                            <div id="mobileCards">
                                <!-- Cards will be populated here -->
                            </div>
                        </div>
                        
                        <div id="historyEmptyState" class="text-center py-4 text-muted d-none">
                            <i class="fas fa-file-invoice-dollar fa-2x mb-2"></i>
                            <p class="mb-0">No charge history found for the selected filters.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Modal -->
        <div class="modal fade" id="editChargeModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Charge</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="editChargeId" />
                        <div class="mb-3">
                            <label class="form-label">Invoice Number</label>
                            <input type="text" id="editInvoiceLiteral" class="form-control" readonly />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Charge Type <span class="text-danger">*</span></label>
                            <select class="form-select" id="editChargeType" required>
                                <option value="">-- Select Charge Type --</option>
                                <option value="Registration">Registration</option>
                                <option value="Lab">Lab</option>
                                <option value="Xray">X-ray</option>
                                <option value="Bed">Bed</option>
                                <option value="Delivery">Delivery</option>
                            </select>
                            <small class="text-muted">Change this if the wrong charge type was applied</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Charge Name</label>
                            <input type="text" class="form-control" id="editChargeName" placeholder="e.g., Standard Registration Fee" />
                            <small class="text-muted">Optional: Descriptive name for this charge</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Amount <span class="text-danger">*</span></label>
                            <input type="number" class="form-control" id="editAmount" min="0" step="0.01" required />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Payment Method</label>
                            <select class="form-select" id="editPaymentMethod">
                                <option value="">-- Select Payment Method --</option>
                                <option value="Cash">Cash</option>
                                <option value="Card">Card</option>
                                <option value="Mobile Payment">Mobile Payment</option>
                                <option value="Bank Transfer">Bank Transfer</option>
                                <option value="Insurance">Insurance</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" onclick="submitChargeEdit()">Save Changes</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Revert Modal -->
        <div class="modal fade" id="revertChargeModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Revert Charge</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="revertChargeId" />
                        <p class="mb-0">Reverting this payment will return the patient to the pending queue for this
                            service.</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger" onclick="confirmRevert()">Revert Charge</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Print All Modal -->
        <div class="modal fade" id="printAllModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Print All Charges</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Enter Patient ID</label>
                            <input type="text" class="form-control" id="printAllPatientId" placeholder="e.g., P12345" />
                            <small class="text-muted">This will print all charges for this patient in one
                                invoice</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Charge Type Filter (Optional)</label>
                            <select class="form-select" id="printAllChargeType">
                                <option value="All">All Charges</option>
                                <option value="Registration">Registration Only</option>
                                <option value="Lab">Lab Only</option>
                                <option value="Xray">X-ray Only</option>
                                <option value="Bed">Bed Only</option>
                                <option value="Delivery">Delivery Only</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" onclick="printAllCharges()">
                            <i class="fas fa-print"></i> Print Invoice
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script src="Scripts/jquery-3.4.1.min.js"></script>
        <script src="datatables/datatables.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="assets/js/plugin/bootstrap-notify/bootstrap-notify.min.js"></script>
        <script>
            let chargeTable;
            let editModal;
            let revertModal;
            let printAllModal;

            document.addEventListener('DOMContentLoaded', function () {
                // Initialize Bootstrap modals
                editModal = new bootstrap.Modal(document.getElementById('editChargeModal'));
                revertModal = new bootstrap.Modal(document.getElementById('revertChargeModal'));
                printAllModal = new bootstrap.Modal(document.getElementById('printAllModal'));

                // Initialize DataTable
                chargeTable = $('#chargeHistoryTable').DataTable({
                    paging: true,
                    searching: true,
                    info: false,
                    ordering: false,
                    pageLength: 25
                });

                loadChargeHistory();

                // Add change listener to filter
                $('#chargeTypeFilter').on('change', function () {
                    loadChargeHistory();
                });

                // Event delegation for dynamically created buttons
                $('#chargeHistoryTable').on('click', '.btn-edit-charge', function (e) {
                    e.preventDefault();
                    const $btn = $(this);
                    const chargeId = $btn.data('charge-id');
                    const invoice = $btn.data('invoice');
                    const amount = $btn.data('amount');
                    const paymentMethod = $btn.data('payment-method');
                    openEditModal(chargeId, invoice, amount, paymentMethod);
                });

                $('#chargeHistoryTable').on('click', '.btn-revert-charge', function (e) {
                    e.preventDefault();
                    const chargeId = $(this).data('charge-id');
                    openRevertModal(chargeId);
                });

                $('#chargeHistoryTable').on('click', '.btn-print-single', function (e) {
                    e.preventDefault();
                    const $btn = $(this);
                    const patientId = $btn.data('patient-id');
                    const invoice = $btn.data('invoice');
                    const chargeType = $btn.data('charge-type');
                    openInvoicePrint(patientId, invoice, chargeType);
                });

                $('#chargeHistoryTable').on('click', '.btn-print-all', function (e) {
                    e.preventDefault();
                    const patientId = $(this).data('patient-id');
                    quickPrintAll(patientId);
                });
                
                // Mobile search functionality
                $('#mobileSearch').on('keyup', function() {
                    var searchText = $(this).val().toLowerCase();
                    $('.charge-card').each(function() {
                        var cardText = $(this).text().toLowerCase();
                        if (cardText.indexOf(searchText) > -1) {
                            $(this).show();
                        } else {
                            $(this).hide();
                        }
                    });
                });
                
                // Event delegation for mobile card buttons
                $('#mobileCards').on('click', '.btn-edit-charge', function (e) {
                    e.preventDefault();
                    const $btn = $(this);
                    const chargeId = $btn.data('charge-id');
                    const invoice = $btn.data('invoice');
                    const amount = $btn.data('amount');
                    const paymentMethod = $btn.data('payment-method');
                    openEditModal(chargeId, invoice, amount, paymentMethod);
                });

                $('#mobileCards').on('click', '.btn-revert-charge', function (e) {
                    e.preventDefault();
                    const chargeId = $(this).data('charge-id');
                    openRevertModal(chargeId);
                });

                $('#mobileCards').on('click', '.btn-print-single', function (e) {
                    e.preventDefault();
                    const $btn = $(this);
                    const patientId = $btn.data('patient-id');
                    const invoice = $btn.data('invoice');
                    const chargeType = $btn.data('charge-type');
                    openInvoicePrint(patientId, invoice, chargeType);
                });

                $('#mobileCards').on('click', '.btn-print-all', function (e) {
                    e.preventDefault();
                    const patientId = $(this).data('patient-id');
                    quickPrintAll(patientId);
                });
            });

            // Handle date range filter change
            function handleDateRangeChange() {
                const dateRange = $('#dateRangeFilter').val();
                
                if (dateRange === 'custom') {
                    // Show custom date inputs
                    $('#startDate').show();
                    $('#endDate').show();
                    
                    // Set default dates
                    const today = new Date().toISOString().split('T')[0];
                    $('#startDate').val(today);
                    $('#endDate').val(today);
                } else {
                    // Hide custom date inputs
                    $('#startDate').hide();
                    $('#endDate').hide();
                }
            }
            
            // Apply filters with date range
            function applyFilters() {
                console.log('Apply button clicked');
                loadChargeHistory();
                return false; // Prevent form submission
            }
            
            // Reset all filters
            function resetFilters() {
                console.log('Reset button clicked');
                $('#chargeTypeFilter').val('All');
                $('#dateRangeFilter').val('all');
                $('#startDate').hide().val('');
                $('#endDate').hide().val('');
                loadChargeHistory();
                return false; // Prevent form submission
            }
            
            // Get date range based on selection
            function getDateRange() {
                const dateRange = $('#dateRangeFilter').val();
                let startDate = null;
                let endDate = null;
                
                switch(dateRange) {
                    case 'today':
                        const today = new Date();
                        startDate = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0, 0, 0, 0);
                        endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 23, 59, 59, 999);
                        break;
                    case 'yesterday':
                        const now = new Date();
                        const yesterday = new Date(now.getFullYear(), now.getMonth(), now.getDate() - 1);
                        startDate = new Date(yesterday.getFullYear(), yesterday.getMonth(), yesterday.getDate(), 0, 0, 0, 0);
                        endDate = new Date(yesterday.getFullYear(), yesterday.getMonth(), yesterday.getDate(), 23, 59, 59, 999);
                        break;
                    case 'week':
                        const thisWeek = new Date();
                        const weekStart = new Date(thisWeek);
                        weekStart.setDate(thisWeek.getDate() - thisWeek.getDay()); // Start of week (Sunday)
                        startDate = new Date(weekStart.getFullYear(), weekStart.getMonth(), weekStart.getDate(), 0, 0, 0, 0);
                        endDate = new Date(thisWeek.getFullYear(), thisWeek.getMonth(), thisWeek.getDate(), 23, 59, 59, 999);
                        break;
                    case 'month':
                        const thisMonth = new Date();
                        startDate = new Date(thisMonth.getFullYear(), thisMonth.getMonth(), 1, 0, 0, 0, 0);
                        endDate = new Date(thisMonth.getFullYear(), thisMonth.getMonth(), thisMonth.getDate(), 23, 59, 59, 999);
                        break;
                    case 'custom':
                        const start = $('#startDate').val();
                        const end = $('#endDate').val();
                        if (start && end) {
                            startDate = new Date(start + 'T00:00:00');
                            endDate = new Date(end + 'T23:59:59');
                        }
                        break;
                    case 'all':
                    default:
                        return null; // No date filter
                }
                
                return { startDate, endDate };
            }

            function loadChargeHistory() {
                chargeTable.clear().draw();
                $('#historyEmptyState').addClass('d-none');
                $('#mobileCards').empty();

                const type = $('#chargeTypeFilter').val();
                
                // Get date range parameters
                const dateRangeType = $('#dateRangeFilter').val();
                let startDate = '';
                let endDate = '';
                
                if (dateRangeType === 'custom') {
                    startDate = $('#startDate').val();
                    endDate = $('#endDate').val();
                } else if (dateRangeType !== 'all') {
                    // Calculate date range for predefined options
                    const range = getDateRange();
                    if (range && range.startDate && range.endDate) {
                        startDate = range.startDate.toISOString().split('T')[0];
                        endDate = range.endDate.toISOString().split('T')[0];
                    }
                }

                console.log('Sending AJAX request with:', { chargeType: type, startDate: startDate, endDate: endDate });
                
                $.ajax({
                    url: 'charge_history.aspx/GetChargeHistory',
                    data: JSON.stringify({ 
                        chargeType: type,
                        startDate: startDate,
                        endDate: endDate
                    }),
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (response) {
                        console.log('Received response:', response);
                        console.log('Number of records:', response.d ? response.d.length : 0);
                        
                        if (!response.d || !response.d.length) {
                            console.warn('No data returned from server');
                            $('#historyEmptyState').removeClass('d-none');
                            $('#mobileCards').html('<div class="alert alert-info">No charge history found for the selected filters.</div>');
                            return;
                        }

                        // Data is already filtered on server side, no need for client-side filtering
                        let filteredData = response.d;

                        filteredData.forEach(function (item) {
                            const statusBadge = item.IsPaid === true || item.IsPaid === 1
                                ? '<span class="badge bg-success">Paid</span>'
                                : (item.IsPaid === false || item.IsPaid === 0)
                                    ? '<span class="badge bg-danger">Unpaid</span>'
                                : '<span class="badge bg-warning text-dark">Reverted</span>';

                            const invoice = item.InvoiceNumber || '—';
                            const amount = parseFloat(item.Amount || 0).toFixed(2);
                            const paidDate = item.PaidDate || '—';
                            const patientInfo = `<div>${item.PatientName}</div><small class="text-muted">ID: ${item.PatientId}</small>`;
                            const chargeActions = buildActionButtons(item);

                            // Add to desktop table
                            chargeTable.row.add([
                                invoice,
                                patientInfo,
                                item.ChargeType,
                                amount,
                                item.PaymentMethod || '—',
                                paidDate,
                                statusBadge,
                                chargeActions
                            ]);
                            
                            // Create mobile card
                            const card = `
                                <div class="charge-card">
                                    <h5><i class="fas fa-file-invoice"></i> ${invoice}</h5>
                                    <p><strong>Patient:</strong> ${item.PatientName} <small class="text-muted">(ID: ${item.PatientId})</small></p>
                                    <p><strong>Type:</strong> ${item.ChargeType}</p>
                                    <p><strong>Amount:</strong> $${amount}</p>
                                    <p><strong>Payment Method:</strong> ${item.PaymentMethod || '—'}</p>
                                    <p><strong>Paid On:</strong> ${paidDate}</p>
                                    <p><strong>Status:</strong> ${statusBadge}</p>
                                    <div class="mt-2">
                                        ${chargeActions}
                                    </div>
                                </div>
                            `;
                            $('#mobileCards').append(card);
                        });

                        chargeTable.draw(false);
                    },
                    error: function (xhr, status, error) {
                        console.error('AJAX Error:', { status: xhr.status, statusText: xhr.statusText, error: error });
                        console.error('Response Text:', xhr.responseText);
                        Swal.fire('Error', xhr.responseText || 'Unable to load history. Check console for details.', 'error');
                    }
                });
            }

            function buildActionButtons(item) {
                // Escape and sanitize data for use in data attributes
                const patientId = String(item.PatientId || '');
                const invoiceNumber = String(item.InvoiceNumber || '');
                const chargeType = String(item.ChargeType || '');

                const printButton = `<button class="btn btn-sm btn-outline-secondary me-1 btn-print-single" 
                data-patient-id="${patientId}" 
                data-invoice="${invoiceNumber}" 
                data-charge-type="${chargeType}" 
                title="Print this charge"><i class="fas fa-print"></i></button>`;

                const printAllBtn = `<button class="btn btn-sm btn-outline-info btn-print-all" 
                data-patient-id="${patientId}" 
                title="Print all charges for this patient"><i class="fas fa-file-invoice"></i></button>`;

                // Only show print buttons (Edit and Revert removed)
                return `
                <div class="d-flex justify-content-end">
                    ${printButton}
                    ${printAllBtn}
                </div>`;
            }

            function openInvoicePrint(patientId, invoice, chargeType) {
                if (!patientId) {
                    Swal.fire('Info', 'Patient information is missing for this record.', 'info');
                    return;
                }

                // Build URL with all parameters
                let url = `patient_invoice_print.aspx?patientid=${encodeURIComponent(patientId)}`;

                if (invoice) {
                    url += `&invoice=${encodeURIComponent(invoice)}`;
                }

                if (chargeType) {
                    url += `&type=${encodeURIComponent(chargeType)}`;
                }

                window.open(url, '_blank');
            }

            function openEditModal(chargeId, invoice, amount, paymentMethod) {
                console.log('Opening edit modal:', { chargeId, invoice, amount, paymentMethod });

                if (!chargeId) {
                    Swal.fire('Error', 'Charge ID is missing', 'error');
                    return;
                }

                $('#editChargeId').val(chargeId);
                $('#editInvoiceLiteral').val(invoice || '—');
                $('#editAmount').val(amount || '0');
                $('#editPaymentMethod').val(paymentMethod || 'Cash');
                editModal.show();
            }

            function submitChargeEdit() {
                const chargeId = $('#editChargeId').val();
                const amount = $('#editAmount').val();
                const paymentMethod = $('#editPaymentMethod').val();

                console.log('Submitting charge edit:', { chargeId, amount, paymentMethod });

                if (!chargeId || amount === '') {
                    Swal.fire('Info', 'Please provide the amount and payment method.', 'info');
                    return;
                }

                // Show loading
                Swal.fire({
                    title: 'Updating...',
                    text: 'Please wait',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                $.ajax({
                    url: 'charge_history.aspx/UpdateCharge',
                    data: JSON.stringify({ chargeId: chargeId, amount: amount, paymentMethod: paymentMethod }),
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (response) {
                        console.log('Update success:', response);
                        editModal.hide();
                        Swal.fire('Success', response.d || 'Charge updated successfully.', 'success');
                        loadChargeHistory();
                    },
                    error: function (xhr, status, error) {
                        console.error('Update error:', xhr, status, error);
                        Swal.fire('Error', xhr.responseJSON?.Message || xhr.responseText || 'Unable to update charge.', 'error');
                    }
                });
            }

            function openRevertModal(chargeId) {
                console.log('Opening revert modal:', chargeId);

                if (!chargeId) {
                    Swal.fire('Error', 'Charge ID is missing', 'error');
                    return;
                }

                $('#revertChargeId').val(chargeId);
                revertModal.show();
            }

            function confirmRevert() {
                const chargeId = $('#revertChargeId').val();

                console.log('Confirming revert:', chargeId);

                if (!chargeId) {
                    Swal.fire('Info', 'Charge reference missing.', 'info');
                    return;
                }

                // Show loading
                Swal.fire({
                    title: 'Reverting...',
                    text: 'Please wait',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                $.ajax({
                    url: 'charge_history.aspx/RevertCharge',
                    data: JSON.stringify({ chargeId: chargeId }),
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (response) {
                        console.log('Revert success:', response);
                        revertModal.hide();
                        Swal.fire('Success', response.d || 'Charge reverted successfully.', 'success');
                        loadChargeHistory();
                    },
                    error: function (xhr, status, error) {
                        console.error('Revert error:', xhr, status, error);
                        Swal.fire('Error', xhr.responseJSON?.Message || xhr.responseText || 'Unable to revert charge.', 'error');
                    }
                });
            }

            function openPrintAllModal() {
                $('#printAllPatientId').val('');
                $('#printAllChargeType').val('All');
                printAllModal.show();
            }

            function quickPrintAll(patientId) {
                if (!patientId) {
                    Swal.fire('Info', 'Patient information is missing.', 'info');
                    return;
                }

                const url = `patient_invoice_print.aspx?patientid=${encodeURIComponent(patientId)}&printall=true`;
                window.open(url, '_blank');
            }

            function printAllCharges() {
                const patientId = $('#printAllPatientId').val().trim();
                const chargeType = $('#printAllChargeType').val();

                if (!patientId) {
                    Swal.fire('Info', 'Please enter a Patient ID.', 'info');
                    return;
                }

                let url = `patient_invoice_print.aspx?patientid=${encodeURIComponent(patientId)}`;
                
                // Add charge type filter if not "all"
                if (chargeType && chargeType !== 'All') {
                    url += `&type=${encodeURIComponent(chargeType)}`;
                }

                printAllModal.hide();
                window.open(url, '_blank');
            }

            function printAllPatientsByChargeType() {
                const chargeType = document.getElementById('chargeTypeFilter').value;
                
                if (!chargeType) {
                    Swal.fire('Info', 'Please select a charge type to print.', 'info');
                    return;
                }
                
                // Get date range parameters
                const dateRangeType = $('#dateRangeFilter').val();
                let startDate = '';
                let endDate = '';
                
                if (dateRangeType === 'custom') {
                    startDate = $('#startDate').val();
                    endDate = $('#endDate').val();
                } else if (dateRangeType !== 'all') {
                    // Calculate date range for predefined options
                    const range = getDateRange();
                    if (range && range.startDate && range.endDate) {
                        startDate = range.startDate.toISOString().split('T')[0];
                        endDate = range.endDate.toISOString().split('T')[0];
                    }
                }
                
                // Build URL with date parameters
                let url = `print_all_patients_by_charge.aspx?type=${encodeURIComponent(chargeType)}`;
                
                if (startDate && endDate) {
                    url += `&startDate=${encodeURIComponent(startDate)}&endDate=${encodeURIComponent(endDate)}`;
                }
                
                console.log('Print URL:', url);
                window.open(url, '_blank');
            }
        </script>
    </asp:Content>