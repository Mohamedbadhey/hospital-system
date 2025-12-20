<%@ Page Title="Medicine Management" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="add_medicine.aspx.cs" Inherits="juba_hospital.add_medicine" %>


    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

        <link href="datatables/datatables.min.css" rel="stylesheet" />
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <style>
            .dataTables_wrapper .dataTables_filter {
                float: right;
                text-align: right;
            }

            .dataTables_wrapper .dataTables_length {
                float: left;
            }

            .dataTables_wrapper .dataTables_paginate {
                float: right;
                text-align: right;
            }

            .dataTables_wrapper .dataTables_info {
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

            .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
            }

            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #004085;
            }

            .btn-success {
                background-color: #28a745;
                border-color: #28a745;
            }

            .btn-success:hover {
                background-color: #218838;
                border-color: #1e7e34;
            }
        </style>

    </asp:Content>


    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <div class="container-fluid">
            <div class="row">
                <div class="col-md-12">

                    <div class="card">
                        <div class="card-header d-flex justify-content-between">
                            <h4>Medicine Management</h4>
                            <button type="button" id="add" class="btn btn-primary">Add Medicine</button>
                        </div>

                        <div class="card-body">
                            <table id="datatable" class="table table-striped table-bordered">
                                <thead>
                                    <tr>
                                        <th>Medicine Name</th>
                                        <th>Generic Name</th>
                                        <th>Manufacturer</th>
                                        <th>Unit</th>
                                        <th>Cost Price</th>
                                        <th>Selling Price</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>

                    </div>

                </div>
            </div>
        </div>

        <!-- =================== ADD MODAL =================== -->
        <div class="modal fade" id="medmodal" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">

                    <div class="modal-header">
                        <h5 class="modal-title">Add Medicine</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <div class="mb-3">
                            <label>Medicine Name</label>
                            <input type="text" class="form-control" id="medname">
                            <small id="mednameError" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label>Generic Name</label>
                            <input type="text" class="form-control" id="generic">
                            <small id="genericError" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label>Manufacturer</label>
                            <input type="text" class="form-control" id="manufacturer">
                            <small id="manufacturerError" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label>Barcode <small class="text-muted">(Optional)</small></label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="barcode" placeholder="Scan or enter barcode" autofocus-on-scan>
                                <span class="input-group-text"><i class="fas fa-barcode"></i></span>
                            </div>
                            <small class="text-muted">Use barcode scanner or enter manually. Press Enter after scanning.</small>
                            <small id="barcodeError" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label>Unit</label>
                            <select class="form-control" id="unit"></select>
                            <small id="unitError" class="text-danger"></small>
                        </div>

                        <!-- Strip/Box Configuration (shown only for Capsule/Tablet) -->
                        <div class="strip-box-config">
                            <div class="mb-3">
                                <label for="tablets_per_strip">Tablets Per Strip</label>
                                <input type="number" id="tablets_per_strip" class="form-control" value="1">
                            </div>

                            <div class="mb-3">
                                <label for="strips_per_box">Strips Per Box</label>
                                <input type="number" id="strips_per_box" class="form-control" value="10">
                            </div>
                        </div>

                        <hr>
                        <h6 class="text-primary">Cost Prices (Your Purchase Cost)</h6>

                        <!-- Complex unit costs (Capsule/Tablet) -->
                        <div class="complex-unit-fields">
                            <div class="mb-3">
                                <label for="cost_per_tablet">Cost per Piece</label>
                                <input type="number" id="cost_per_tablet" step="0.01" class="form-control" value="0"
                                    onchange="calculateProfitMargins()">
                                <small class="text-muted">What you pay supplier per piece</small>
                            </div>
                        </div>

                        <!-- All units have this field-->
                        <div class="mb-3">
                            <label for="cost_per_strip">Cost per Strip</label>
                            <input type="number" id="cost_per_strip" step="0.01" class="form-control" value="0"
                                onchange="calculateProfitMargins()">
                            <small class="text-muted">What you pay supplier per strip</small>
                        </div>

                        <!-- Complex unit costs (Capsule/Tablet) -->
                        <div class="complex-unit-fields">
                            <div class="mb-3">
                                <label for="cost_per_box">Cost per Box</label>
                                <input type="number" id="cost_per_box" step="0.01" class="form-control" value="0"
                                    onchange="calculateProfitMargins()">
                                <small class="text-muted">What you pay supplier per box</small>
                            </div>
                        </div>

                        <hr>
                        <h6 class="text-success">Selling Prices (Customer Pays)</h6>

                        <!-- Complex unit prices (Capsule/Tablet) -->
                        <div class="complex-unit-fields">
                            <div class="mb-3">
                                <label for="price_per_tablet">Price Per Tablet</label>
                                <input type="number" id="price_per_tablet" step="0.01" class="form-control"
                                    onchange="calculateProfitMargins()">
                                <div id="profit_per_tablet" class="badge bg-success mt-1" style="display:none;"></div>
                            </div>
                        </div>

                        <!-- All units have this field -->
                        <div class="mb-3">
                            <label for="price_per_strip">Price Per Strip</label>
                            <input type="number" id="price_per_strip" step="0.01" class="form-control"
                                onchange="calculateProfitMargins()">
                            <div id="profit_per_strip" class="badge bg-success mt-1" style="display:none;"></div>
                        </div>

                        <!-- Complex unit prices (Capsule/Tablet) -->
                        <div class="complex-unit-fields">
                            <div class="mb-3">
                                <label for="price_per_box">Price Per Box</label>
                                <input type="number" id="price_per_box" step="0.01" class="form-control"
                                    onchange="calculateProfitMargins()">
                                <div id="profit_per_box" class="badge bg-success mt-1" style="display:none;"></div>
                            </div>
                        </div>

                        <!-- Profit Margin Summary -->
                        <div id="profit_summary" class="alert alert-info mt-3" style="display:none;">
                            <strong><i class="fas fa-chart-line"></i> Profit Margins:</strong>
                            <div id="profit_summary_content" class="mt-2"></div>
                        </div>

                    </div>

                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary" onclick="submitInfo()">Save</button>
                    </div>

                </div>
            </div>
        </div>


        <!-- =================== EDIT MODAL =================== -->
        <div class="modal fade" id="medmodal1" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">

                    <div class="modal-header">
                        <h5 class="modal-title">Edit Medicine</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">

                        <input id="id111" hidden />

                        <div class="mb-3">
                            <label>Medicine Name</label>
                            <input type="text" id="medname1" class="form-control">
                            <small id="mednameError1" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label>Generic Name</label>
                            <input type="text" id="generic1" class="form-control">
                            <small id="genericError1" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label>Manufacturer</label>
                            <input type="text" id="manufacturer1" class="form-control">
                            <small id="manufacturerError1" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label>Barcode <small class="text-muted">(Optional)</small></label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="barcode1" placeholder="Scan or enter barcode">
                                <span class="input-group-text"><i class="fas fa-barcode"></i></span>
                            </div>
                            <small class="text-muted">Use barcode scanner or enter manually.</small>
                        </div>

                        <div class="mb-3">
                            <label>Unit</label>
                            <select id="unit1" class="form-control"></select>
                            <small id="unitError1" class="text-danger"></small>
                        </div>

                        <!-- Strip/Box Configuration (shown only for Capsule/Tablet) -->
                        <div class="strip-box-config1">
                            <div class="mb-3">
                                <label for="tablets_per_strip1">Tablets Per Strip</label>
                                <input type="number" id="tablets_per_strip1" class="form-control" value="1">
                            </div>

                            <div class="mb-3">
                                <label for="strips_per_box1">Strips Per Box</label>
                                <input type="number" id="strips_per_box1" class="form-control" value="10">
                            </div>
                        </div>

                        <hr>
                        <h6 class="text-primary">Cost Prices (Your Purchase Cost)</h6>

                        <!-- Complex unit costs (Capsule/Tablet) -->
                        <div class="complex-unit-fields1">
                            <div class="mb-3">
                                <label for="cost_per_tablet1">Cost per Piece</label>
                                <input type="number" id="cost_per_tablet1" step="0.01" class="form-control" value="0" readonly>
                                <small class="text-muted">What you pay supplier per piece (read-only, set during inventory)</small>
                            </div>
                        </div>

                        <!-- All units have this field-->
                        <div class="mb-3">
                            <label for="cost_per_strip1">Cost per Strip</label>
                            <input type="number" id="cost_per_strip1" step="0.01" class="form-control" value="0" readonly>
                            <small class="text-muted">What you pay supplier per strip (read-only, set during inventory)</small>
                        </div>

                        <!-- Complex unit costs (Capsule/Tablet) -->
                        <div class="complex-unit-fields1">
                            <div class="mb-3">
                                <label for="cost_per_box1">Cost per Box</label>
                                <input type="number" id="cost_per_box1" step="0.01" class="form-control" value="0" readonly>
                                <small class="text-muted">What you pay supplier per box (read-only, set during inventory)</small>
                            </div>
                        </div>

                        <hr>
                        <h6 class="text-success">Selling Prices (Customer Pays)</h6>

                        <!-- Complex unit prices (Capsule/Tablet) -->
                        <div class="complex-unit-fields1">
                            <div class="mb-3">
                                <label for="price_per_tablet1">Price Per Tablet</label>
                                <input type="number" id="price_per_tablet1" step="0.01" class="form-control">
                            </div>
                        </div>

                        <!-- All units have this field -->
                        <div class="mb-3">
                            <label for="price_per_strip1">Price Per Strip</label>
                            <input type="number" id="price_per_strip1" step="0.01" class="form-control">
                        </div>

                        <!-- Complex unit prices (Capsule/Tablet) -->
                        <div class="complex-unit-fields1">
                            <div class="mb-3">
                                <label for="price_per_box1">Price Per Box</label>
                                <input type="number" id="price_per_box1" step="0.01" class="form-control">
                            </div>
                        </div>

                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger" onclick="deletejob()">Delete</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary" onclick="update()">Update</button>
                    </div>

                </div>
            </div>
        </div>

        <!-- ===================== JS FILES ===================== -->
        <script src="Scripts/jquery-3.4.1.min.js"></script>
        <script src="datatables/datatables.min.js"></script>
        <script>
            // Fallback system for DataTables
            $(document).ready(function() {
                // Check if DataTables is available
                if (typeof $.fn.DataTable === 'undefined') {
                    console.log('Local DataTables failed, loading from CDN...');
                    // Load DataTables from CDN
                    $.getScript('https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js')
                        .done(function() {
                            console.log('DataTables loaded from CDN - initialization will happen in main script');
                        })
                        .fail(function() {
                            console.error('Failed to load DataTables from CDN');
                            alert('Unable to load DataTables. Please check your internet connection.');
                        });
                } else {
                    console.log('DataTables loaded successfully from local file');
                }
            });
        </script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <!-- Place your long JavaScript here -->
        <script>
            // jQuery is now loaded above
            console.log('jQuery version:', jQuery.fn.jquery);

            jQuery(document).ready(function ($) {
                    console.log('Initializing medicine management page...');

                    // Always load units first
                    loadUnits();
                    
                    // Global table variable
                    var globalDataTable = null;
                    
                    // Function to initialize DataTable and load data
                    function initializeDataTableAndLoadData() {
                        if (typeof $.fn.DataTable !== 'undefined') {
                            if (!$.fn.DataTable.isDataTable('#datatable')) {
                                // Initialize DataTable
                                globalDataTable = $('#datatable').DataTable({
                                    responsive: {
                                        breakpoints: [
                                            { name: 'bigdesktop', width: Infinity },
                                            { name: 'meddesktop', width: 1480 },
                                            { name: 'desktop', width: 1024 },
                                            { name: 'tablet', width: 768 },
                                            { name: 'phablet', width: 480 },
                                            { name: 'phone', width: 320 }
                                        ]
                                    },
                                    autoWidth: false,
                                    scrollX: true, // Enable horizontal scroll for desktop
                                    columnDefs: [
                                        { responsivePriority: 1, targets: 0 }, // Medicine Name - Always visible
                                        { responsivePriority: 2, targets: -1 }, // Action - Always visible
                                        { responsivePriority: 3, targets: 1 }, // Generic Name - Show on tablet+
                                        { responsivePriority: 4, targets: 3 }, // Unit - Show on tablet+
                                        { responsivePriority: 5, targets: 5 }, // Selling Price - Show on tablet+
                                        { responsivePriority: 6, targets: 2 }, // Manufacturer - Hide on mobile
                                        { responsivePriority: 7, targets: 4 }  // Cost Price - Hide on mobile
                                    ]
                                });
                                console.log('DataTable initialized in main script');
                                
                                // Load data directly using the table instance
                                setTimeout(function() {
                                    console.log('Loading data using global table instance...');
                                    datadisplayDirect(globalDataTable);
                                }, 100);
                            } else {
                                console.log('DataTable already exists, getting instance');
                                globalDataTable = $('#datatable').DataTable();
                                datadisplayDirect(globalDataTable);
                            }
                        } else {
                            console.log('DataTables not available, retrying...');
                            // Retry after a short delay
                            setTimeout(initializeDataTableAndLoadData, 200);
                        }
                    }
                    
                    // Start initialization process
                    setTimeout(initializeDataTableAndLoadData, 500);

                    // Add button click handler
                    $('#add').click(function () {
                        clearInputFields();
                        var modal = new bootstrap.Modal(document.getElementById('medmodal'));
                        modal.show();
                    });
                });

                // Global edit function to prevent page refresh
                function editMedicine(id, event) {
                    if (event) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    
                    $("#id111").val(id);

                    $.ajax({
                        url: 'add_medicine.aspx/getMedicineById',
                        data: JSON.stringify({ id: id }),
                        contentType: 'application/json',
                        dataType: "json",
                        type: 'POST',
                        success: function (response) {
                            if (response.d && response.d.length > 0) {
                                var medicine = response.d[0];
                                $("#medname1").val(medicine.medicine_name);
                                $("#generic1").val(medicine.generic_name);
                                $("#manufacturer1").val(medicine.manufacturer);
                                $("#barcode1").val(medicine.barcode || "");
                                $("#unit1").val(medicine.unit_id);
                                $("#tablets_per_strip1").val(medicine.tablets_per_strip || "1");
                                $("#strips_per_box1").val(medicine.strips_per_box || "10");
                                
                                // Load cost prices (read-only)
                                $("#cost_per_tablet1").val(medicine.cost_per_tablet || "0");
                                $("#cost_per_strip1").val(medicine.cost_per_strip || "0");
                                $("#cost_per_box1").val(medicine.cost_per_box || "0");
                                
                                // Load selling prices (editable)
                                $("#price_per_tablet1").val(medicine.price_per_tablet || "0");
                                $("#price_per_strip1").val(medicine.price_per_strip || "0");
                                $("#price_per_box1").val(medicine.price_per_box || "0");

                                // Update labels for edit modal
                                updatePricingLabels(medicine.unit_id, true);

                                // Show edit modal
                                var modal = new bootstrap.Modal(document.getElementById('medmodal1'));
                                modal.show();
                            }
                        },
                        error: function (response) {
                            alert('Error loading medicine data: ' + response.responseText);
                        }
                    });
                    return false;
                }

                // Load units from server
                function loadUnits() {
                    $.ajax({
                        url: 'add_medicine.aspx/getUnits',
                        contentType: 'application/json',
                        dataType: "json",
                        type: 'POST',
                        success: function (response) {
                            var units = response.d;
                            var unitSelect = $("#unit");
                            var unitSelect1 = $("#unit1");

                            unitSelect.empty().append('<option value="">Select Unit</option>');
                            unitSelect1.empty().append('<option value="">Select Unit</option>');

                            for (var i = 0; i < units.length; i++) {
                                unitSelect.append('<option value="' + units[i].unit_id + '">' + units[i].unit_name + '</option>');
                                unitSelect1.append('<option value="' + units[i].unit_id + '">' + units[i].unit_name + '</option>');
                            }
                            console.log('Units loaded:', units.length);

                            // Add event listener for unit change
                            unitSelect.on('change', function () {
                                updatePricingLabels($(this).val(), false);
                            });
                            unitSelect1.on('change', function () {
                                updatePricingLabels($(this).val(), true);
                            });
                        },
                        error: function (response) {
                            console.error('Error loading units:', response.responseText);
                        }
                    });
                }

                // Update pricing field labels based on selected unit
                function updatePricingLabels(unitId, isEdit) {
                    if (!unitId) return;

                $.ajax({
                    url: 'add_medicine.aspx/getUnitDetails',
                data: JSON.stringify({unitId: unitId }),
                contentType: 'application/json',
                dataType: "json",
                type: 'POST',
                success: function (response) {
                            var config = response.d;
                var suffix = isEdit ? '1' : '';

                // Check if this is a complex unit
                var allowsSubdivision = config.allows_subdivision;
                console.log('Unit selected:', config.unit_name, 'Allows Subdivision:', allowsSubdivision);

                var isComplex = (allowsSubdivision === true || allowsSubdivision === 1 || allowsSubdivision === '1' || allowsSubdivision === 'True');

                if (isComplex) {
                    // Show all fields for complex units
                    $('.strip-box-config' + suffix).show();
                $('.complex-unit-fields' + suffix).show();

                // Update labels
                $('label[for="tablets_per_strip' + suffix + '"]').text((config.base_unit_name || 'Tablet') + ' per ' + (config.subdivision_unit || 'Strip'));
                $('label[for="strips_per_box' + suffix + '"]').text((config.subdivision_unit || 'Strip') + ' per Box');
                $('label[for="cost_per_tablet' + suffix + '"]').text('Cost per ' + (config.base_unit_name || 'Piece'));
                $('label[for="cost_per_strip' + suffix + '"]').text('Cost per ' + (config.subdivision_unit || 'Strip'));
                $('label[for="cost_per_box' + suffix + '"]').text('Cost per Box');
                $('label[for="price_per_tablet' + suffix + '"]').text('Price per ' + (config.base_unit_name || 'Piece'));
                $('label[for="price_per_strip' + suffix + '"]').text('Price per ' + (config.subdivision_unit || 'Strip'));
                $('label[for="price_per_box' + suffix + '"]').text('Price per Box');
                            } else {
                    // Hide complex fields for simple units
                    $('.strip-box-config' + suffix).hide();
                $('.complex-unit-fields' + suffix).hide();

                // Update labels for simple units
                $('label[for="cost_per_strip' + suffix + '"]').text('Cost per Unit');
                $('label[for="price_per_strip' + suffix + '"]').text('Price per Unit');

                // Set defaults
                $('#tablets_per_strip' + suffix).val('1');
                $('#strips_per_box' + suffix).val('1');
                var unitPrice = $('#price_per_strip' + suffix).val() || '0';
                var unitCost = $('#cost_per_strip' + suffix).val() ||  '0';
                $('#price_per_tablet' + suffix).val(unitPrice);
                $('#price_per_box' + suffix).val(unitPrice);
                $('#cost_per_tablet' + suffix).val(unitCost);
                $('#cost_per_box' + suffix).val(unitCost);
                            }
                        }
                    });
                }

                // Direct data loading using table instance
                function datadisplayDirect(tableInstance) {
                    $.ajax({
                        url: 'add_medicine.aspx/datadisplay',
                        dataType: "json",
                        type: 'POST',
                        contentType: "application/json",
                        success: function (response) {
                            console.log('Backend response (direct):', response.d);
                            
                            if (tableInstance && response.d && response.d.length > 0) {
                                console.log('Using direct table instance to load data');
                                tableInstance.clear();

                                for (var i = 0; i < response.d.length; i++) {
                                    var record = response.d[i];
                                    tableInstance.row.add([
                                        record.medicine_name || '',
                                        record.generic_name || '',
                                        record.manufacturer || '',
                                        record.unit_name || '',
                                        '$' + (record.cost_per_strip || '0'),
                                        '$' + (record.price_per_strip || '0'),
                                        "<button type='button' class='edit1-btn btn btn-success btn-sm' data-id='" + (record.medicineid || record.id || '') + "' onclick='editMedicine(" + (record.medicineid || record.id || '') + ", event)'>Edit</button>"
                                    ]);
                                }
                                tableInstance.draw();
                                console.log('Data loaded via direct table instance:', response.d.length + ' records');
                            } else {
                                console.log('Table instance not available, falling back to manual loading');
                                loadDataManually();
                            }
                        },
                        error: function (response) {
                            console.error('Error loading data (direct):', response.responseText);
                            loadDataManually(); // Fallback to manual loading
                        }
                    });
                }

                // Manual data loading fallback (without DataTable)
                function loadDataManually() {
                    $.ajax({
                        url: 'add_medicine.aspx/datadisplay',
                        dataType: "json",
                        type: 'POST',
                        contentType: "application/json",
                        success: function (response) {
                            console.log('Loading data manually without DataTable');
                            var tbody = $('#datatable tbody');
                            tbody.empty();

                            for (var i = 0; i < response.d.length; i++) {
                                var record = response.d[i];
                                var row = '<tr>' +
                                    '<td>' + (record.medicine_name || '') + '</td>' +
                                    '<td>' + (record.generic_name || '') + '</td>' +
                                    '<td>' + (record.manufacturer || '') + '</td>' +
                                    '<td>' + (record.unit_name || '') + '</td>' +
                                    '<td>$' + (record.cost_per_strip || '0') + '</td>' +
                                    '<td>$' + (record.price_per_strip || '0') + '</td>' +
                                    '<td><button type="button" class="edit1-btn btn btn-success btn-sm" data-id="' + (record.medicineid || record.id || '') + '" onclick="editMedicine(' + (record.medicineid || record.id || '') + ', event)">Edit</button></td>' +
                                    '</tr>';
                                tbody.append(row);
                            }
                            console.log('Data loaded manually:', response.d.length + ' records');
                        },
                        error: function (response) {
                            console.error('Error loading data manually:', response.responseText);
                        }
                    });
                }

                // Display all medicines
                function datadisplay() {
                    $.ajax({
                        url: 'add_medicine.aspx/datadisplay',
                        dataType: "json",
                        type: 'POST',
                        contentType: "application/json",
                        success: function (response) {
                            console.log('Backend response:', response.d);
                            
                            // Check if we have data
                            if (response.d && response.d.length > 0) {
                                console.log('First record structure:', Object.keys(response.d[0]));
                                console.log('Sample record:', response.d[0]);
                            }
                            
                            // Check if DataTable is available and initialized
                            if (typeof $.fn.DataTable !== 'undefined' && $.fn.DataTable.isDataTable('#datatable')) {
                                var table = $('#datatable').DataTable();
                                table.clear();

                                for (var i = 0; i < response.d.length; i++) {
                                    var record = response.d[i];
                                    // Make sure we have all the expected fields
                                    table.row.add([
                                        record.medicine_name || '',
                                        record.generic_name || '',
                                        record.manufacturer || '',
                                        record.unit_name || '',
                                        record.price_per_strip || '0',
                                        "<button class='edit1-btn btn btn-success btn-sm' data-id='" + (record.medicineid || record.id || '') + "'>Edit</button>"
                                    ]);
                                }
                                table.draw();
                                console.log('Data loaded successfully:', response.d.length + ' records');
                            } else {
                                console.log('DataTable not available for data loading');
                                console.log('DataTable available?', typeof $.fn.DataTable !== 'undefined');
                                console.log('DataTable initialized?', $.fn.DataTable.isDataTable('#datatable'));
                            }
                        },
                        error: function (response) {
                            console.error('Error loading data:', response.responseText);
                            alert('Error loading medicine data: ' + response.responseText);
                        }
                    });
                }

                // Calculate profit margins in real-time
                function calculateProfitMargins() {
                    var costTablet = parseFloat($('#cost_per_tablet').val()) || 0;
                var costStrip = parseFloat($('#cost_per_strip').val()) || 0;
                var costBox = parseFloat($('#cost_per_box').val()) || 0;
                var priceTablet = parseFloat($('#price_per_tablet').val()) || 0;
                var priceStrip = parseFloat($('#price_per_strip').val()) || 0;
                var priceBox = parseFloat($('#price_per_box').val()) || 0;

                var hasProfitData = false;
                var summaryHtml = '<div class="row">';

                    if (priceTablet > 0 && costTablet > 0) {
                        var profitTablet = priceTablet - costTablet;
                    var profitPctTablet = ((profitTablet / costTablet) * 100).toFixed(1);
                        var badgeClass = profitPctTablet > 30 ? 'bg-success' : (profitPctTablet > 15 ? 'bg-warning' : 'bg-danger');
                    $('#profit_per_tablet').removeClass('bg-success bg-warning bg-danger').addClass(badgeClass)
                    .text('💰 Profit: ' + profitTablet.toFixed(2) + ' SDG (' + profitPctTablet + '%)').show();
                    summaryHtml += '<div class="col-md-4"><strong>Per Piece:</strong> ' + profitTablet.toFixed(2) + ' SDG (' + profitPctTablet + '%)</div>';
                    hasProfitData = true;
                    } else {
                        $('#profit_per_tablet').hide();
                    }

                    if (priceStrip > 0 && costStrip > 0) {
                        var profitStrip = priceStrip - costStrip;
                    var profitPctStrip = ((profitStrip / costStrip) * 100).toFixed(1);
                        var badgeClass = profitPctStrip > 30 ? 'bg-success' : (profitPctStrip > 15 ? 'bg-warning' : 'bg-danger');
                    $('#profit_per_strip').removeClass('bg-success bg-warning bg-danger').addClass(badgeClass)
                    .text('💰 Profit: ' + profitStrip.toFixed(2) + ' SDG (' + profitPctStrip + '%)').show();
                    summaryHtml += '<div class="col-md-4"><strong>Per Strip:</strong> ' + profitStrip.toFixed(2) + ' SDG (' + profitPctStrip + '%)</div>';
                    hasProfitData = true;
                    } else {
                        $('#profit_per_strip').hide();
                    }

                    if (priceBox > 0 && costBox > 0) {
                        var profitBox = priceBox - costBox;
                    var profitPctBox = ((profitBox / costBox) * 100).toFixed(1);
                        var badgeClass = profitPctBox > 30 ? 'bg-success' : (profitPctBox > 15 ? 'bg-warning' : 'bg-danger');
                    $('#profit_per_box').removeClass('bg-success bg-warning bg-danger').addClass(badgeClass)
                    .text('💰 Profit: ' + profitBox.toFixed(2) + ' SDG (' + profitPctBox + '%)').show();
                    summaryHtml += '<div class="col-md-4"><strong>Per Box:</strong> ' + profitBox.toFixed(2) + ' SDG (' + profitPctBox + '%)</div>';
                    hasProfitData = true;
                    } else {
                        $('#profit_per_box').hide();
                    }

                    summaryHtml += '</div>';

                if (hasProfitData) {
                    $('#profit_summary_content').html(summaryHtml);
                $('#profit_summary').show();
                    } else {
                    $('#profit_summary').hide();
                    }
                }

                // Submit new medicine
                function submitInfo() {
                    console.log('submitInfo() called');
                $('#mednameError, #genericError, #manufacturerError, #unitError, #barcodeError').text('');

                var medname = $("#medname").val();
                var generic = $("#generic").val();
                var manufacturer = $("#manufacturer").val();
                var barcode = $("#barcode").val().trim();
                var unitId = $("#unit").val();
                var tabletsPerStrip = $("#tablets_per_strip").val() || "1";
                var stripsPerBox = $("#strips_per_box").val() || "10";
                var costPerTablet = $("#cost_per_tablet").val() || "0";
                var costPerStrip = $("#cost_per_strip").val() || "0";
                var costPerBox = $("#cost_per_box").val() || "0";
                var pricePerTablet = $("#price_per_tablet").val() || "0";
                var pricePerStrip = $("#price_per_strip").val() || "0";
                var pricePerBox = $("#price_per_box").val() || "0";

                var isValid = true;
                if (!medname.trim()) {$('#mednameError').text("Please enter medicine name."); isValid = false; }
                if (!generic.trim()) {$('#genericError').text("Please enter generic name."); isValid = false; }
                if (!manufacturer.trim()) {$('#manufacturerError').text("Please enter manufacturer."); isValid = false; }
                if (!unitId.trim()) {$('#unitError').text("Please select a unit."); isValid = false; }

                if (!isValid) {
                    console.log('Validation failed');
                return;
                    }

                $.ajax({
                    url: 'add_medicine.aspx/submitdata',
                data: JSON.stringify({medname, generic, manufacturer, barcode, unitId, tabletsPerStrip, stripsPerBox, costPerTablet, costPerStrip, costPerBox, pricePerTablet, pricePerStrip, pricePerBox}),
                contentType: 'application/json; charset=utf-8',
                dataType: 'json',
                type: 'POST',
                success: function (response) {
                            var modal = bootstrap.Modal.getInstance(document.getElementById('medmodal'));
                if (modal) modal.hide();
                if (response.d === 'true') {
                    Swal.fire('Successfully Saved!', 'Medicine added successfully!', 'success');
                datadisplay();
                clearInputFields();
                            } else {
                    Swal.fire('Error', 'Failed to save medicine: ' + response.d, 'error');
                            }
                        },
                error: function (xhr, status, error) {
                    console.error('AJAX error:', xhr, status, error);
                Swal.fire('Error', 'Error saving medicine: ' + xhr.responseText, 'error');
                        }
                    });
                }

                // Update medicine
                function update() {
                    $('#mednameError1, #genericError1, #manufacturerError1, #unitError1').text('');

                var id = $("#id111").val();
                var medname = $("#medname1").val();
                var generic = $("#generic1").val();
                var manufacturer = $("#manufacturer1").val();
                var barcode = $("#barcode1").val() || "";
                var unitId = $("#unit1").val();
                var tabletsPerStrip = $("#tablets_per_strip1").val() || "1";
                var stripsPerBox = $("#strips_per_box1").val() || "10";
                
                // Get cost prices (read-only but still need to send to server)
                var costPerTablet = $("#cost_per_tablet1").val() || "0";
                var costPerStrip = $("#cost_per_strip1").val() || "0";
                var costPerBox = $("#cost_per_box1").val() || "0";
                
                // Get selling prices (editable)
                var pricePerTablet = $("#price_per_tablet1").val() || "0";
                var pricePerStrip = $("#price_per_strip1").val() || "0";
                var pricePerBox = $("#price_per_box1").val() || "0";

                var isValid = true;
                if (!medname.trim()) {$('#mednameError1').text("Please enter medicine name."); isValid = false; }
                if (!generic.trim()) {$('#genericError1').text("Please enter generic name."); isValid = false; }
                if (!manufacturer.trim()) {$('#manufacturerError1').text("Please enter manufacturer."); isValid = false; }
                if (!unitId.trim()) {$('#unitError1').text("Please select a unit."); isValid = false; }

                if (!isValid) return;

                $.ajax({
                    url: 'add_medicine.aspx/updateMedicine',
                data: JSON.stringify({id, medname, generic, manufacturer, barcode, unitId, tabletsPerStrip, stripsPerBox, costPerTablet, costPerStrip, costPerBox, pricePerTablet, pricePerStrip, pricePerBox}),
                contentType: 'application/json',
                dataType: "json",
                type: 'POST',
                success: function (response) {
                            var modal = bootstrap.Modal.getInstance(document.getElementById('medmodal1'));
                modal.hide();
                Swal.fire('Successfully Updated!', 'Medicine updated successfully!', 'success');
                datadisplay();
                        },
                error: function (response) {
                    alert('Error updating medicine: ' + response.responseText);
                        }
                    });
                }

                // Delete medicine
                function deletejob() {
                    Swal.fire({
                        title: 'Are you sure?',
                        text: "You won't be able to revert this!",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonText: 'Yes, delete it!'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            var id = $("#id111").val();
                            $.ajax({
                                type: "POST",
                                url: "add_medicine.aspx/deleteMedicine",
                                data: JSON.stringify({ id }),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function (response) {
                                    var modal = bootstrap.Modal.getInstance(document.getElementById('medmodal1'));
                                    modal.hide();
                                    if (response.d === 'true') {
                                        Swal.fire('Successfully Deleted!', 'Medicine deleted successfully!', 'success');
                                        datadisplay();
                                    }
                                },
                                error: function (xhr) { alert("Error deleting medicine: " + xhr.responseText); }
                            });
                        }
                    });
                }

                // Clear input fields
                function clearInputFields() {
                    $("#medname,#generic,#manufacturer,#unit,#cost_per_tablet,#cost_per_strip,#cost_per_box,#price_per_tablet,#price_per_strip,#price_per_box").val('');
                $("#tablets_per_strip").val('1');
                $("#strips_per_box").val('10');
                }

            // Make functions global
            window.loadUnits = loadUnits;
            window.datadisplay = datadisplay;
            window.calculateProfitMargins = calculateProfitMargins;
            window.submitInfo = submitInfo;
            window.update = update;
            window.deletejob = deletejob;
            window.clearInputFields = clearInputFields;
            window.editMedicine = editMedicine;

        </script>

    </asp:Content>