<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="manage_charges.aspx.cs" Inherits="juba_hospital.manage_charges" %>

    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link href="datatables/datatables.min.css" rel="stylesheet" />
        <style>
            /* Base Responsive Styles */
            .container-fluid {
                padding: 10px;
            }

            /* DataTable Enhanced Styles */
            .dataTables_wrapper .dataTables_filter {
                float: right;
                text-align: right;
                margin-bottom: 10px;
            }

            .dataTables_wrapper .dataTables_length {
                float: left;
                margin-bottom: 10px;
            }

            .dataTables_wrapper .dataTables_paginate {
                float: right;
                text-align: right;
                margin-top: 10px;
            }

            .dataTables_wrapper .dataTables_info {
                float: left;
                margin-top: 10px;
            }

            /* Enhanced DataTable Search */
            .dataTables_filter input {
                border: 2px solid #e9ecef;
                border-radius: 25px;
                padding: 8px 15px;
                margin-left: 8px;
                font-size: 14px;
                width: 250px;
            }

            .dataTables_filter input:focus {
                border-color: #007bff;
                box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
                outline: none;
            }

            .dataTables_filter label {
                font-weight: 600;
                color: #495057;
            }

            /* Enhanced Buttons */
            .dt-buttons {
                margin-bottom: 10px;
            }

            .dt-button {
                background: #007bff !important;
                border: none !important;
                color: white !important;
                padding: 8px 16px !important;
                border-radius: 5px !important;
                margin-right: 8px !important;
                font-size: 13px !important;
                font-weight: 500 !important;
            }

            .dt-button:hover {
                background: #0056b3 !important;
                transform: translateY(-1px);
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
                padding: 12px 8px;
            }

            #datatable th {
                background-color: #007bff;
                color: white;
                font-weight: bold;
                font-size: 13px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            #datatable td {
                background-color: #f8f9fa;
                border-bottom: 1px solid #dee2e6;
            }

            #datatable tbody tr:hover {
                background-color: #e3f2fd;
                transition: all 0.3s ease;
            }

            .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
                border-radius: 6px;
                transition: all 0.3s ease;
            }

            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #004085;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }

            .btn-success {
                background-color: #28a745;
                border-color: #28a745;
                border-radius: 6px;
                transition: all 0.3s ease;
            }

            .btn-success:hover {
                background-color: #218838;
                border-color: #1e7e34;
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }

            .badge-active {
                background-color: #28a745;
                padding: 6px 12px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 600;
            }

            .badge-inactive {
                background-color: #dc3545;
                padding: 6px 12px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 600;
            }

            .card {
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                border: none;
            }

            .card-header {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                border-radius: 10px 10px 0 0;
                padding: 20px;
            }

            /* Tablet Styles (768px - 1024px) */
            @media (max-width: 1024px) {
                .container-fluid {
                    padding: 15px;
                }

                .card-body {
                    padding: 15px;
                }

                table.dataTable {
                    font-size: 13px;
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

                .dataTables_filter input {
                    width: 200px;
                }
            }

            /* Mobile Styles (up to 768px) */
            @media (max-width: 768px) {
                /* Hide DataTable on mobile */
                .table-responsive {
                    display: none !important;
                }

                /* Show mobile cards container */
                .mobile-view {
                    display: block !important;
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

                /* Mobile Header Responsive */
                .card-header {
                    padding: 15px !important;
                }

                .card-header h4 {
                    font-size: 1.3rem;
                    margin-bottom: 15px;
                    text-align: center;
                }

                .card-header .row {
                    flex-direction: column;
                }

                .card-header .col-9,
                .card-header .col-3 {
                    max-width: 100%;
                    flex: 0 0 100%;
                }

                /* Mobile Add Button */
                .card-header .btn {
                    width: 100%;
                    padding: 12px;
                    font-size: 16px;
                    font-weight: 600;
                    margin: 0;
                    border-radius: 8px;
                }

                .btn {
                    width: 100%;
                    margin-bottom: 10px;
                }

                .btn-sm {
                    width: auto;
                    padding: 8px 12px;
                    font-size: 13px;
                }
            }

            /* Small mobile styles (up to 480px) */
            @media (max-width: 480px) {
                .card-header {
                    padding: 15px !important;
                    text-align: center !important;
                }

                .card-header h4 {
                    font-size: 1.1rem !important;
                    margin-bottom: 15px !important;
                }

                .card-header .d-flex {
                    flex-direction: column !important;
                    align-items: center !important;
                }

                .card-header .btn {
                    width: 100% !important;
                    max-width: 250px !important;
                    padding: 14px !important;
                    font-size: 15px !important;
                    font-weight: 600 !important;
                    border-radius: 8px !important;
                }

                .card-body {
                    padding: 12px;
                }

                .btn {
                    padding: 12px;
                    font-size: 14px;
                }

                .modal-dialog {
                    margin: 5px;
                    width: calc(100% - 10px);
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
                border-color: #007bff;
                outline: none;
                box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.2);
            }

            .charge-mobile-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                margin-bottom: 15px;
                overflow: hidden;
                transition: all 0.3s ease;
                border: 1px solid #f0f0f0;
                border-left: 5px solid #007bff;
            }

            .charge-mobile-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            .mobile-card-header {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                padding: 15px 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .charge-type-mobile {
                font-size: 18px;
                font-weight: bold;
                margin: 0;
            }

            .charge-status-mobile {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: bold;
            }

            .mobile-card-body {
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
                border-left: 4px solid #007bff;
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
                display: flex;
                gap: 10px;
                justify-content: center;
            }

            .mobile-actions .btn {
                flex: 1;
                min-width: 100px;
                margin: 0;
                padding: 10px;
            }

            @media (max-width: 480px) {
                .mobile-info-grid {
                    grid-template-columns: 1fr;
                    gap: 10px;
                }

                .charge-type-mobile {
                    font-size: 16px;
                }

                .mobile-card-header {
                    padding: 12px 15px;
                }

                .mobile-card-body {
                    padding: 15px;
                }

                .mobile-actions {
                    flex-direction: column;
                }

                .mobile-actions .btn {
                    width: 100%;
                    margin-bottom: 8px;
                }
            }
        </style>
    </asp:Content>

    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <!-- Add/Edit Modal -->
        <div class="modal fade" id="chargeModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">Add Charge</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="chargeId" />

                        <div class="mb-3">
                            <label class="form-label">Charge Type *</label>
                            <select class="form-control" id="chargeType" required>
                                <option value="">Select Type</option>
                                <option value="Registration">Registration</option>
                                <option value="Bed">Bed (Per Night)</option>
                                <option value="Delivery">Delivery</option>
                                <option value="Lab">Lab</option>
                                <option value="Xray">Xray</option>
                            </select>
                            <small id="typeError" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Charge Name *</label>
                            <input type="text" class="form-control" id="chargeName"
                                placeholder="e.g., Patient Registration Fee">
                            <small id="nameError" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Amount *</label>
                            <input type="number" step="0.01" class="form-control" id="chargeAmount" placeholder="0.00">
                            <small id="amountError" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select class="form-control" id="chargeActive">
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" onclick="saveCharge()" class="btn btn-primary">Save</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit/Delete Modal -->
        <div class="modal fade" id="editModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit/Delete Charge</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="editChargeId" />

                        <div class="mb-3">
                            <label class="form-label">Charge Type *</label>
                            <select class="form-control" id="editChargeType">
                                <option value="Registration">Registration</option>
                                <option value="Bed">Bed (Per Night)</option>
                                <option value="Delivery">Delivery</option>
                                <option value="Lab">Lab</option>
                                <option value="Xray">Xray</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Charge Name *</label>
                            <input type="text" class="form-control" id="editChargeName">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Amount *</label>
                            <input type="number" step="0.01" class="form-control" id="editChargeAmount">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select class="form-control" id="editChargeActive">
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" onclick="deleteCharge()" class="btn btn-danger">Delete</button>
                        <button type="button" onclick="updateCharge()" class="btn btn-primary">Update</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex flex-column flex-md-row align-items-center justify-content-between">
                            <h4 class="card-title mb-3 mb-md-0">
                                <i class="fas fa-dollar-sign me-2"></i>Manage Charges
                            </h4>
                            <button type="button" id="addBtn" class="btn btn-primary">
                                <i class="fas fa-plus me-2"></i>Add New Charge
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="display nowrap" style="width:100%" id="datatable">
                                <thead>
                                    <tr>
                                        <th>Charge Type</th>
                                        <th>Charge Name</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                        <th>Date Added</th>
                                        <th>Operation</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <th>Charge Type</th>
                                        <th>Charge Name</th>
                                        <th>Amount</th>
                                        <th>Status</th>
                                        <th>Date Added</th>
                                        <th>Operation</th>
                                    </tr>
                                </tfoot>
                                <tbody></tbody>
                            </table>
                        </div>

                        <!-- Mobile View for Responsive Design -->
                        <div class="mobile-view">
                            <div class="mobile-search">
                                <input type="text" id="mobileSearchInput" placeholder="🔍 Search charges..." />
                            </div>
                            <div id="mobileChargesContainer">
                                <!-- Mobile cards will be populated here -->
                                <div class="text-center text-muted p-4">
                                    <i class="fas fa-spinner fa-spin"></i> Loading charges...
                                </div>
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
            // Global variables for responsive functionality
            var allChargesData = [];
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
                    populateMobileCards(allChargesData);
                } else {
                    $('.table-responsive').show();
                    $('.mobile-view').hide();
                }
            }

            // Mobile cards generation
            function populateMobileCards(charges) {
                const container = $('#mobileChargesContainer');
                container.empty();

                if (!charges || charges.length === 0) {
                    container.html(`
                        <div class="text-center text-muted p-4">
                            <i class="fas fa-cog fa-2x mb-3"></i>
                            <p>No charges found</p>
                        </div>
                    `);
                    return;
                }

                charges.forEach(function(charge, index) {
                    const card = createChargeCard(charge, index);
                    container.append(card);
                });
            }

            function createChargeCard(charge, index) {
                const isActive = charge.is_active == "1";
                const statusClass = isActive ? 'badge-active' : 'badge-inactive';
                const statusText = isActive ? 'Active' : 'Inactive';
                const amount = parseFloat(charge.amount).toFixed(2);
                
                return `
                    <div class="charge-mobile-card" data-charge-id="${charge.charge_config_id}">
                        <div class="mobile-card-header">
                            <h5 class="charge-type-mobile">${charge.charge_type}</h5>
                            <span class="charge-status-mobile ${statusClass}">${statusText}</span>
                        </div>
                        <div class="mobile-card-body">
                            <div class="mobile-info-grid">
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Charge Name</div>
                                    <div class="mobile-info-value">${charge.charge_name}</div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Amount</div>
                                    <div class="mobile-info-value">$${amount}</div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Status</div>
                                    <div class="mobile-info-value">
                                        <span class="badge ${statusClass}">${statusText}</span>
                                    </div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Date Added</div>
                                    <div class="mobile-info-value">${charge.date_added}</div>
                                </div>
                            </div>
                            <div class="mobile-actions">
                                <button type="button" class="btn btn-success edit-btn-mobile" 
                                        data-id="${charge.charge_config_id}"
                                        data-type="${charge.charge_type}"
                                        data-name="${charge.charge_name}"
                                        data-amount="${amount}"
                                        data-status="${charge.is_active}">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                            </div>
                        </div>
                    </div>
                `;
            }

            // Mobile search functionality
            function setupMobileSearch() {
                $('#mobileSearchInput').on('input', function() {
                    const searchTerm = $(this).val().toLowerCase().trim();
                    
                    if (searchTerm === '') {
                        populateMobileCards(allChargesData);
                        return;
                    }

                    const filteredCharges = allChargesData.filter(function(charge) {
                        const searchableText = [
                            charge.charge_type,
                            charge.charge_name,
                            charge.amount.toString(),
                            charge.is_active == "1" ? 'active' : 'inactive'
                        ].join(' ').toLowerCase();
                        
                        return searchableText.includes(searchTerm);
                    });

                    populateMobileCards(filteredCharges);
                });
            }

            // Handle mobile edit buttons
            $(document).on('click', '.edit-btn-mobile', function() {
                var id = $(this).data('id');
                var type = $(this).data('type');
                var name = $(this).data('name');
                var amount = $(this).data('amount');
                var status = $(this).data('status');

                $("#editChargeId").val(id);
                $("#editChargeType").val(type);
                $("#editChargeName").val(name);
                $("#editChargeAmount").val(amount);
                $("#editChargeActive").val(status);
                $('#editModal').modal('show');
            });

            // Window resize handler
            $(window).on('resize', function() {
                updateViewMode();
            });

            $(document).ready(function () {
                // Initialize responsive functionality
                setupMobileSearch();
                updateViewMode();
                
                loadCharges();
            });

            $("#datatable").on("click", ".edit-btn", function () {
                var row = $(this).closest("tr");
                var id = $(this).data("id");
                var type = row.find("td:eq(0)").text();
                var name = row.find("td:eq(1)").text();
                var amount = row.find("td:eq(2)").text().replace(/[^0-9.]/g, '');
                var status = row.find("td:eq(3)").text().trim() === "Active" ? "1" : "0";

                $("#editChargeId").val(id);
                $("#editChargeType").val(type);
                $("#editChargeName").val(name);
                $("#editChargeAmount").val(amount);
                $("#editChargeActive").val(status);
                $('#editModal').modal('show');
            });

            $("#addBtn").click(function () {
                $("#chargeId").val("");
                $("#chargeType").val("");
                $("#chargeName").val("");
                $("#chargeAmount").val("");
                $("#chargeActive").val("1");
                $("#modalTitle").text("Add Charge");
                $('#chargeModal').modal('show');
            });

            function loadCharges() {
                $.ajax({
                    url: 'manage_charges.aspx/GetCharges',
                    type: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    success: function (response) {
                        console.log("GetCharges response:", response);

                        // Store data globally for responsive functionality
                        allChargesData = response.d || [];

                        // Clear table body (no DataTables)
                        $("#datatable tbody").empty();
                        if (response.d && response.d.length > 0) {
                            console.log("Found " + response.d.length + " charges");
                            for (var i = 0; i < response.d.length; i++) {
                                var statusBadge = response.d[i].is_active == "1"
                                    ? '<span class="badge badge-active">Active</span>'
                                    : '<span class="badge badge-inactive">Inactive</span>';

                                $("#datatable tbody").append(
                                    "<tr>" +
                                    "<td>" + response.d[i].charge_type + "</td>" +
                                    "<td>" + response.d[i].charge_name + "</td>" +
                                    "<td>" + parseFloat(response.d[i].amount).toFixed(2) + "</td>" +
                                    "<td>" + statusBadge + "</td>" +
                                    "<td>" + response.d[i].date_added + "</td>" +
                                    "<td><button class='edit-btn btn btn-success' data-id='" + response.d[i].charge_config_id + "'>Edit</button></td>" +
                                    "</tr>"
                                );
                            }
                        } else {
                            console.log("No charges found in response");
                        }

                        // Don't use DataTables - simple table is sufficient
                        console.log('Table loaded with ' + response.d.length + ' charges');

                        // Update view mode to show appropriate interface
                        updateViewMode();
                    },
                    error: function (response) {
                        console.error("Error loading charges:", response);
                        alert("Error loading charges: " + response.responseText);
                    }
                });
            }

            function saveCharge() {
                var id = $("#chargeId").val() || "0";
                var type = $("#chargeType").val();
                var name = $("#chargeName").val();
                var amount = $("#chargeAmount").val();
                var active = $("#chargeActive").val();

                if (!type || !name || !amount) {
                    Swal.fire('Validation Error', 'Please fill all required fields', 'error');
                    return;
                }

                $.ajax({
                    url: 'manage_charges.aspx/SaveCharge',
                    data: JSON.stringify({
                        id: id, charge_type: type, charge_name: name,
                        amount: amount, is_active: active
                    }),
                    type: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === 'true') {
                            $('#chargeModal').modal('hide');
                            Swal.fire('Success!', 'Charge saved successfully', 'success');
                            loadCharges();
                        } else {
                            Swal.fire('Error', response.d, 'error');
                        }
                    },
                    error: function (response) {
                        alert("Error: " + response.responseText);
                    }
                });
            }

            function updateCharge() {
                var id = $("#editChargeId").val();
                var type = $("#editChargeType").val();
                var name = $("#editChargeName").val();
                var amount = $("#editChargeAmount").val();
                var active = $("#editChargeActive").val();

                $.ajax({
                    url: 'manage_charges.aspx/SaveCharge',
                    data: JSON.stringify({
                        id: id, charge_type: type, charge_name: name,
                        amount: amount, is_active: active
                    }),
                    type: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === 'true') {
                            $('#editModal').modal('hide');
                            Swal.fire('Success!', 'Charge updated successfully', 'success');
                            loadCharges();
                        } else {
                            Swal.fire('Error', response.d, 'error');
                        }
                    },
                    error: function (response) {
                        alert("Error: " + response.responseText);
                    }
                });
            }

            function deleteCharge() {
                var id = $("#editChargeId").val();
                if (!confirm('Are you sure you want to delete this charge?')) return;

                $.ajax({
                    url: 'manage_charges.aspx/DeleteCharge',
                    data: JSON.stringify({ id: id }),
                    type: 'POST',
                    contentType: "application/json",
                    dataType: "json",
                    success: function (response) {
                        if (response.d === 'true') {
                            $('#editModal').modal('hide');
                            Swal.fire('Success!', 'Charge deleted successfully', 'success');
                            loadCharges();
                        } else {
                            Swal.fire('Error', response.d, 'error');
                        }
                    },
                    error: function (response) {
                        alert("Error: " + response.responseText);
                    }
                });
            }
        </script>
    </asp:Content>