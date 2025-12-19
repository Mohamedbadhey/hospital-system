<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="add_medicine_units.aspx.cs" Inherits="juba_hospital.add_medicine_units" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link href="datatables/datatables.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <style>
            .card {
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                border-radius: 8px;
            }

            .badge-active {
                background-color: #28a745;
            }

            .badge-inactive {
                background-color: #dc3545;
            }

            /* Enhanced DataTable Styling */
            .dataTables_wrapper {
                padding: 0;
            }

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

            /* Tablet Styles (768px - 1024px) */
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

                /* Header responsiveness */
                .card-header .d-flex {
                    flex-direction: column;
                    align-items: center !important;
                }

                .card-header h4 {
                    margin-bottom: 15px;
                    text-align: center;
                }

                .card-header .btn {
                    width: 100%;
                    max-width: 250px;
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
                    width: auto;
                    padding: 8px 12px;
                    font-size: 13px;
                }

                /* Modal responsiveness */
                .modal-dialog {
                    margin: 10px;
                    width: calc(100% - 20px);
                }

                .modal-body {
                    padding: 15px;
                }

                .modal-footer .btn {
                    margin: 5px 0;
                }
            }

            /* Small mobile styles (up to 480px) */
            @media (max-width: 480px) {
                .container-fluid {
                    padding: 8px;
                }

                .card-header {
                    padding: 12px 15px;
                    text-align: center;
                }

                .card-header h4 {
                    font-size: 1.1rem;
                }

                .card-body {
                    padding: 12px;
                }

                .btn {
                    padding: 12px;
                    font-size: 13px;
                }

                .modal-dialog {
                    margin: 5px;
                    width: calc(100% - 10px);
                }

                .modal-footer {
                    flex-direction: column;
                }

                .modal-footer .btn {
                    width: 100%;
                    margin: 5px 0;
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

            .unit-mobile-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                margin-bottom: 15px;
                overflow: hidden;
                transition: all 0.3s ease;
                border: 1px solid #f0f0f0;
                border-left: 5px solid #007bff;
            }

            .unit-mobile-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            .unit-mobile-card.expanded {
                box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            }

            .mobile-card-header {
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                padding: 15px 20px;
                cursor: pointer;
                position: relative;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .mobile-card-header:hover {
                background: linear-gradient(135deg, #0056b3 0%, #004085 100%);
            }

            .unit-name-mobile {
                font-size: 18px;
                font-weight: bold;
                margin: 0;
                flex: 1;
            }

            .unit-status-mobile {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: bold;
                margin-right: 15px;
            }

            .expand-icon {
                position: absolute;
                right: 20px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 16px;
                transition: transform 0.3s ease;
                color: rgba(255, 255, 255, 0.8);
            }

            .unit-mobile-card.expanded .expand-icon {
                transform: translateY(-50%) rotate(180deg);
            }

            .mobile-card-compact {
                padding: 15px 20px;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            }

            .unit-brief-info {
                font-size: 14px;
                opacity: 0.9;
                margin: 5px 0 0 0;
            }

            .mobile-card-body {
                padding: 0;
                max-height: 0;
                overflow: hidden;
                transition: all 0.3s ease;
            }

            .unit-mobile-card.expanded .mobile-card-body {
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
                border-top: 1px solid #f0f0f0;
                padding-top: 15px;
                display: flex;
                justify-content: center;
            }

            .mobile-actions .btn {
                width: auto;
                margin: 0;
                padding: 10px 20px;
            }

            @media (max-width: 480px) {
                .mobile-info-grid {
                    grid-template-columns: 1fr;
                    gap: 10px;
                }

                .unit-name-mobile {
                    font-size: 16px;
                }

                .mobile-card-header {
                    padding: 12px 15px;
                }

                .mobile-card-body {
                    padding: 15px;
                }

                .mobile-actions .btn {
                    width: 100%;
                }
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <!-- Add Modal -->
        <div class="modal fade" id="unitModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="unitModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="unitModalLabel">Add Medicine Unit</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input style="display:none" id="unitId" />
                        <div class="mb-3">
                            <label for="unitName" class="form-label">Unit Name <span
                                    class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="unitName"
                                placeholder="e.g., Bottle, Ointment, Syrup">
                            <small id="unitNameError" class="text-danger"></small>
                        </div>
                        <div class="mb-3">
                            <label for="unitAbbreviation" class="form-label">Abbreviation</label>
                            <input type="text" class="form-control" id="unitAbbreviation"
                                placeholder="e.g., Btl, Oint, Syr" maxlength="10">
                            <small id="unitAbbreviationError" class="text-danger"></small>
                        </div>
                        <div class="mb-3">
                            <label for="sellingMethod" class="form-label">Selling Method</label>
                            <select class="form-control" id="sellingMethod">
                                <option value="countable">Countable (pieces, bottles, vials)</option>
                                <option value="volume">Volume (ml, liters)</option>
                                <option value="weight">Weight (mg, grams)</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="baseUnitName" class="form-label">Base Unit Name</label>
                            <input type="text" class="form-control" id="baseUnitName"
                                placeholder="e.g., piece, bottle, vial, tube">
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="allowsSubdivision"
                                    onchange="toggleSubdivision('allowsSubdivision', 'subdivisionField')">
                                <label class="form-check-label" for="allowsSubdivision">
                                    Allows Subdivision (e.g., strips, ml)
                                </label>
                            </div>
                        </div>
                        <div class="mb-3" id="subdivisionField" style="display:none;">
                            <label for="subdivisionUnit" class="form-label">Subdivision Unit</label>
                            <input type="text" class="form-control" id="subdivisionUnit"
                                placeholder="e.g., strip, ml, box">
                        </div>
                        <div class="mb-3">
                            <label for="unitSizeLabel" class="form-label">Unit Size Label</label>
                            <input type="text" class="form-control" id="unitSizeLabel"
                                placeholder="e.g., 'ml per bottle', 'pieces per strip'">
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="isActive" checked>
                                <label class="form-check-label" for="isActive">
                                    Active
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" onclick="submitUnit()" class="btn btn-primary">Save</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Update Modal -->
        <div class="modal fade" id="unitModalEdit" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="unitModalEditLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="unitModalEditLabel">Edit Medicine Unit</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input style="display:none" id="unitId1" />
                        <div class="mb-3">
                            <label for="unitName1" class="form-label">Unit Name <span
                                    class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="unitName1"
                                placeholder="e.g., Bottle, Ointment, Syrup">
                            <small id="unitNameError1" class="text-danger"></small>
                        </div>
                        <div class="mb-3">
                            <label for="unitAbbreviation1" class="form-label">Abbreviation</label>
                            <input type="text" class="form-control" id="unitAbbreviation1"
                                placeholder="e.g., Btl, Oint, Syr" maxlength="10">
                            <small id="unitAbbreviationError1" class="text-danger"></small>
                        </div>
                        <div class="mb-3">
                            <label for="sellingMethod1" class="form-label">Selling Method</label>
                            <select class="form-control" id="sellingMethod1">
                                <option value="countable">Countable (pieces, bottles, vials)</option>
                                <option value="volume">Volume (ml, liters)</option>
                                <option value="weight">Weight (mg, grams)</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="baseUnitName1" class="form-label">Base Unit Name</label>
                            <input type="text" class="form-control" id="baseUnitName1"
                                placeholder="e.g., piece, bottle, vial, tube">
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="allowsSubdivision1"
                                    onchange="toggleSubdivision('allowsSubdivision1', 'subdivisionField1')">
                                <label class="form-check-label" for="allowsSubdivision1">
                                    Allows Subdivision (e.g., strips, ml)
                                </label>
                            </div>
                        </div>
                        <div class="mb-3" id="subdivisionField1" style="display:none;">
                            <label for="subdivisionUnit1" class="form-label">Subdivision Unit</label>
                            <input type="text" class="form-control" id="subdivisionUnit1"
                                placeholder="e.g., strip, ml, box">
                        </div>
                        <div class="mb-3">
                            <label for="unitSizeLabel1" class="form-label">Unit Size Label</label>
                            <input type="text" class="form-control" id="unitSizeLabel1"
                                placeholder="e.g., 'ml per bottle', 'pieces per strip'">
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="isActive1">
                                <label class="form-check-label" for="isActive1">
                                    Active
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" onclick="updateUnit()" class="btn btn-primary">Update</button>
                        <button type="button" onclick="deleteUnit()" class="btn btn-danger">Delete</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h4 class="card-title">Medicine Units</h4>
                            <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                                data-bs-target="#unitModal">
                                <i class="fa fa-plus"></i> Add New Unit
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table id="unitsTable" class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Unit Name</th>
                                        <th>Abbreviation</th>
                                        <th>Selling Method</th>
                                        <th>Status</th>
                                        <th>Created Date</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="unitsTableBody">
                                </tbody>
                            </table>
                        </div>

                        <!-- Mobile View for Responsive Design -->
                        <div class="mobile-view">
                            <div class="mobile-search">
                                <input type="text" id="mobileSearchInput" placeholder="🔍 Search medicine units..." />
                            </div>
                            <div id="mobileUnitsContainer">
                                <!-- Mobile cards will be populated here -->
                                <div class="text-center text-muted p-4">
                                    <i class="fas fa-spinner fa-spin"></i> Loading medicine units...
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="Scripts/jquery-3.4.1.min.js"></script>
        <script src="datatables/datatables.min.js"></script>
        <script>
            var unitModal = new bootstrap.Modal(document.getElementById('unitModal'));
            var unitModalEdit = new bootstrap.Modal(document.getElementById('unitModalEdit'));

            $(document).ready(function () {
                loadUnits();
            });

            function toggleSubdivision(checkboxId, fieldId) {
                if ($('#' + checkboxId).is(':checked')) {
                    $('#' + fieldId).show();
                } else {
                    $('#' + fieldId).hide();
                }
            }

            function loadUnits() {
                $.ajax({
                    type: "POST",
                    url: "add_medicine_units.aspx/getUnits",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                        $('#unitsTableBody').empty();

                        // Check if DataTables is loaded and table exists before destroying
                        if (typeof $.fn.DataTable !== 'undefined' && $.fn.DataTable.isDataTable('#unitsTable')) {
                            $('#unitsTable').DataTable().destroy();
                        }

                        for (var i = 0; i < r.d.length; i++) {
                            var statusBadge = r.d[i].is_active == "True"
                                ? '<span class="badge badge-active">Active</span>'
                                : '<span class="badge badge-inactive">Inactive</span>';

                            $('#unitsTableBody').append(
                                '<tr>' +
                                '<td>' + r.d[i].unit_id + '</td>' +
                                '<td>' + r.d[i].unit_name + '</td>' +
                                '<td>' + (r.d[i].unit_abbreviation || '-') + '</td>' +
                                '<td>' + (r.d[i].selling_method || '-') + '</td>' +
                                '<td>' + statusBadge + '</td>' +
                                '<td>' + new Date(r.d[i].created_date).toLocaleDateString() + '</td>' +
                                '<td><button type="button" class="btn btn-sm btn-info" onclick="editUnitDesktop(' + r.d[i].unit_id + ', event)"><i class="fa fa-edit"></i> Edit</button></td>' +
                                '</tr>'
                            );
                        }

                        // Initialize DataTable with safety check
                        if (typeof $.fn.DataTable !== 'undefined') {
                            $('#unitsTable').DataTable({
                                "pageLength": 10,
                                "ordering": true,
                                "searching": true,
                                "responsive": true,
                                "language": {
                                    "search": "🔍 Search units:",
                                    "lengthMenu": "Show _MENU_ units per page",
                                    "info": "Showing _START_ to _END_ of _TOTAL_ units",
                                    "infoEmpty": "No units found",
                                    "emptyTable": "No medicine units available"
                                }
                            });
                            console.log('Medicine units DataTable initialized successfully');
                        } else {
                            console.error('DataTables library not available - displaying basic table');
                        }

                        // Update mobile view with loaded data
                        updateMobileView(r.d);
                    },
                    error: function (xhr, status, error) {
                        console.error(xhr.responseText);
                        alert("Error loading units: " + error);
                    }
                });
            }

            // Global variables for responsive functionality
            var allUnitsData = [];
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
                    populateMobileCards(allUnitsData);
                } else {
                    $('.table-responsive').show();
                    $('.mobile-view').hide();
                }
            }

            // Update mobile view with units data
            function updateMobileView(unitsData) {
                allUnitsData = unitsData || [];
                if (checkIfMobile()) {
                    populateMobileCards(allUnitsData);
                }
            }

            // Mobile cards generation
            function populateMobileCards(units) {
                const container = $('#mobileUnitsContainer');
                container.empty();

                if (!units || units.length === 0) {
                    container.html(`
                        <div class="text-center text-muted p-4">
                            <i class="fas fa-pills fa-2x mb-3"></i>
                            <p>No medicine units found</p>
                        </div>
                    `);
                    return;
                }

                units.forEach(function(unit, index) {
                    const card = createUnitCard(unit, index);
                    container.append(card);
                });
            }

            function createUnitCard(unit, index) {
                const isActive = unit.is_active == "True";
                const statusClass = isActive ? 'badge-success' : 'badge-secondary';
                const statusText = isActive ? 'Active' : 'Inactive';
                
                return `
                    <div class="unit-mobile-card" data-unit-id="${unit.unit_id}">
                        <div class="mobile-card-header" onclick="toggleUnitCard(this)">
                            <div class="mobile-card-compact">
                                <h5 class="unit-name-mobile">${unit.unit_name || 'Unknown Unit'}</h5>
                                <p class="unit-brief-info">${unit.unit_abbreviation || 'N/A'} • ${unit.selling_method || 'Standard'}</p>
                            </div>
                            <span class="unit-status-mobile badge ${statusClass}">${statusText}</span>
                            <i class="fas fa-chevron-down expand-icon"></i>
                        </div>
                        <div class="mobile-card-body">
                            <div class="mobile-info-grid">
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Unit ID</div>
                                    <div class="mobile-info-value">${unit.unit_id || 'N/A'}</div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Unit Name</div>
                                    <div class="mobile-info-value">${unit.unit_name || 'Unknown Unit'}</div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Abbreviation</div>
                                    <div class="mobile-info-value">${unit.unit_abbreviation || 'N/A'}</div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Selling Method</div>
                                    <div class="mobile-info-value">${unit.selling_method || 'N/A'}</div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Status</div>
                                    <div class="mobile-info-value">
                                        <span class="badge ${statusClass}">${statusText}</span>
                                    </div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Created Date</div>
                                    <div class="mobile-info-value">${new Date(unit.created_date).toLocaleDateString() || 'N/A'}</div>
                                </div>
                            </div>
                            <div class="mobile-actions">
                                <button type="button" class="btn btn-primary btn-sm" onclick="editUnitMobile(${unit.unit_id}, event)">
                                    <i class="fas fa-edit"></i> Edit Unit
                                </button>
                            </div>
                        </div>
                    </div>
                `;
            }

            // Function to toggle card expansion
            function toggleUnitCard(header) {
                const card = $(header).closest('.unit-mobile-card');
                card.toggleClass('expanded');
            }

            // Mobile search functionality
            function setupMobileSearch() {
                $('#mobileSearchInput').on('input', function() {
                    const searchTerm = $(this).val().toLowerCase().trim();
                    
                    if (searchTerm === '') {
                        populateMobileCards(allUnitsData);
                        return;
                    }

                    const filteredUnits = allUnitsData.filter(function(unit) {
                        const searchableText = [
                            unit.unit_name,
                            unit.unit_abbreviation,
                            unit.selling_method,
                            unit.is_active == "True" ? 'active' : 'inactive'
                        ].join(' ').toLowerCase();
                        
                        return searchableText.includes(searchTerm);
                    });

                    populateMobileCards(filteredUnits);
                });
            }

            // Window resize handler
            $(window).on('resize', function() {
                updateViewMode();
            });

            // Initialize mobile functionality when document is ready
            $(document).ready(function() {
                setupMobileSearch();
                updateViewMode();
            });

            function submitUnit() {
                // Clear errors
                $('#unitNameError').text('');
                $('#unitAbbreviationError').text('');

                var unitName = $('#unitName').val().trim();
                var unitAbbreviation = $('#unitAbbreviation').val().trim();
                var sellingMethod = $('#sellingMethod').val();
                var baseUnitName = $('#baseUnitName').val().trim();
                var allowsSubdivision = $('#allowsSubdivision').is(':checked');
                var subdivisionUnit = $('#subdivisionUnit').val().trim();
                var unitSizeLabel = $('#unitSizeLabel').val().trim();
                var isActive = $('#isActive').is(':checked');

                // Validation
                if (!unitName) {
                    $('#unitNameError').text('Unit name is required');
                    return;
                }

                $.ajax({
                    type: "POST",
                    url: "add_medicine_units.aspx/addUnit",
                    data: JSON.stringify({
                        unitName: unitName,
                        unitAbbreviation: unitAbbreviation,
                        sellingMethod: sellingMethod,
                        baseUnitName: baseUnitName,
                        subdivisionUnit: subdivisionUnit,
                        allowsSubdivision: allowsSubdivision,
                        unitSizeLabel: unitSizeLabel,
                        isActive: isActive
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                        if (r.d === "true") {
                            unitModal.hide();
                            $('#unitName').val('');
                            $('#unitAbbreviation').val('');
                            $('#sellingMethod').val('countable');
                            $('#baseUnitName').val('');
                            $('#allowsSubdivision').prop('checked', false);
                            $('#subdivisionUnit').val('');
                            $('#unitSizeLabel').val('');
                            $('#subdivisionField').hide();
                            $('#isActive').prop('checked', true);
                            loadUnits();
                            alert("Unit added successfully!");
                        } else {
                            alert("Error: " + r.d);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error(xhr.responseText);
                        alert("Error adding unit: " + error);
                    }
                });
            }

            function editUnitMobile(id, event) {
                if (event) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                editUnit(id);
                return false;
            }

            function editUnitDesktop(id, event) {
                if (event) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                editUnit(id);
                return false;
            }

            function editUnit(id) {
                $.ajax({
                    type: "POST",
                    url: "add_medicine_units.aspx/getUnitById",
                    data: JSON.stringify({ id: id }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                        if (r.d && r.d.length > 0) {
                            var unit = r.d[0];
                            $('#unitId1').val(unit.unit_id);
                            $('#unitName1').val(unit.unit_name);
                            $('#unitAbbreviation1').val(unit.unit_abbreviation);
                            $('#sellingMethod1').val(unit.selling_method || 'countable');
                            $('#baseUnitName1').val(unit.base_unit_name);
                            $('#allowsSubdivision1').prop('checked', unit.allows_subdivision == "True");
                            $('#subdivisionUnit1').val(unit.subdivision_unit);
                            $('#unitSizeLabel1').val(unit.unit_size_label);
                            $('#isActive1').prop('checked', unit.is_active == "True");

                            toggleSubdivision('allowsSubdivision1', 'subdivisionField1');
                            unitModalEdit.show();
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error(xhr.responseText);
                        alert("Error loading unit: " + error);
                    }
                });
            }

            function updateUnit() {
                // Clear errors
                $('#unitNameError1').text('');
                $('#unitAbbreviationError1').text('');

                var unitId = $('#unitId1').val();
                var unitName = $('#unitName1').val().trim();
                var unitAbbreviation = $('#unitAbbreviation1').val().trim();
                var sellingMethod = $('#sellingMethod1').val();
                var baseUnitName = $('#baseUnitName1').val().trim();
                var allowsSubdivision = $('#allowsSubdivision1').is(':checked');
                var subdivisionUnit = $('#subdivisionUnit1').val().trim();
                var unitSizeLabel = $('#unitSizeLabel1').val().trim();
                var isActive = $('#isActive1').is(':checked');

                // Validation
                if (!unitName) {
                    $('#unitNameError1').text('Unit name is required');
                    return;
                }

                $.ajax({
                    type: "POST",
                    url: "add_medicine_units.aspx/updateUnit",
                    data: JSON.stringify({
                        id: unitId,
                        unitName: unitName,
                        unitAbbreviation: unitAbbreviation,
                        sellingMethod: sellingMethod,
                        baseUnitName: baseUnitName,
                        subdivisionUnit: subdivisionUnit,
                        allowsSubdivision: allowsSubdivision,
                        unitSizeLabel: unitSizeLabel,
                        isActive: isActive
                    }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                        if (r.d === "true") {
                            unitModalEdit.hide();
                            loadUnits();
                            alert("Unit updated successfully!");
                        } else {
                            alert("Error: " + r.d);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error(xhr.responseText);
                        alert("Error updating unit: " + error);
                    }
                });
            }

            function deleteUnit() {
                if (!confirm("Are you sure you want to delete this unit? This action cannot be undone.")) {
                    return;
                }

                var unitId = $('#unitId1').val();

                $.ajax({
                    type: "POST",
                    url: "add_medicine_units.aspx/deleteUnit",
                    data: JSON.stringify({ id: unitId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (r) {
                        if (r.d === "true") {
                            unitModalEdit.hide();
                            loadUnits();
                            alert("Unit deleted successfully!");
                        } else {
                            alert("Error: " + r.d);
                        }
                    },
                    error: function (xhr, status, error) {
                        console.error(xhr.responseText);
                        alert("Error deleting unit: " + error);
                    }
                });
            }
        </script>
    </asp:Content>