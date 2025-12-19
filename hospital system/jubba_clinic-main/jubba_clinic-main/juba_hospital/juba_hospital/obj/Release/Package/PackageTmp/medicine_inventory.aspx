<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true"
    CodeBehind="medicine_inventory.aspx.cs" Inherits="juba_hospital.medicine_inventory" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link href="datatables/datatables.min.css" rel="stylesheet" />
        <link href="https://cdn.datatables.net/responsive/2.5.0/css/responsive.dataTables.min.css" rel="stylesheet" />
         <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
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

            /* Desktop Styles - Show table */
            @media screen and (min-width: 768px) {
                .table-container {
                    display: block !important;
                    overflow-x: auto;
                }
                
                .mobile-view {
                    display: none !important;
                }
            }

            /* Mobile Responsive Styles - Card View */
            @media screen and (max-width: 767px) {
                /* Hide DataTable on mobile */
                .table-container {
                    display: none !important;
                }
                
                /* Show mobile cards container */
                .mobile-view {
                    display: block !important;
                }
                
                .card {
                    margin: 10px;
                }
                
                .card-header {
                    padding: 10px 15px;
                    text-align: center;
                }
                
                .card-header h4 {
                    font-size: 1.1rem;
                    margin-bottom: 10px;
                }
                
                .card-header #addStock {
                    width: 100%;
                    max-width: 200px;
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

            .inventory-mobile-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                margin-bottom: 15px;
                overflow: hidden;
                transition: all 0.3s ease;
                border: 1px solid #f0f0f0;
                border-left: 5px solid #007bff;
            }

            .inventory-mobile-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            .inventory-mobile-card.expanded {
                box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            }

            .inventory-mobile-card.low-stock {
                border-left-color: #dc3545;
            }

            .inventory-mobile-card.expired {
                border-left-color: #fd7e14;
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

            .mobile-card-header.low-stock {
                background: linear-gradient(135deg, #dc3545 0%, #c82333 100%);
            }

            .mobile-card-header.expired {
                background: linear-gradient(135deg, #fd7e14 0%, #e8681a 100%);
            }

            .mobile-card-header:hover {
                background: linear-gradient(135deg, #0056b3 0%, #004085 100%);
            }

            .medicine-name-mobile {
                font-size: 18px;
                font-weight: bold;
                margin: 0;
                flex: 1;
            }

            .stock-status-mobile {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: bold;
                margin-right: 15px;
                background: rgba(255, 255, 255, 0.2);
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

            .inventory-mobile-card.expanded .expand-icon {
                transform: translateY(-50%) rotate(180deg);
            }

            .mobile-card-compact {
                padding: 15px 20px;
                border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            }

            .stock-brief-info {
                font-size: 14px;
                opacity: 0.9;
                margin: 5px 0 0 0;
            }

            .mobile-card-body {
                padding: 0;
                max-height: 0;
                overflow: hidden;
                transition: all 0.3s ease;
                background: #f8f9fa;
            }

            .inventory-mobile-card.expanded .mobile-card-body {
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
                background: white;
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

                .medicine-name-mobile {
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

            /* Tablet styles */
            @media screen and (max-width: 1024px) and (min-width: 768px) {
                .dataTables_wrapper .dataTables_length,
                .dataTables_wrapper .dataTables_filter {
                    text-align: center;
                    margin-bottom: 10px;
                }
                
                .dataTables_wrapper .dataTables_info,
                .dataTables_wrapper .dataTables_paginate {
                    text-align: center;
                    margin-top: 10px;
                }
            }

            /* Enhanced responsive table styles */
            table.dataTable.dtr-inline.collapsed > tbody > tr > td.dtr-control,
            table.dataTable.dtr-inline.collapsed > tbody > tr > th.dtr-control {
                position: relative;
                padding-left: 30px;
                cursor: pointer;
            }

            table.dataTable > tbody > tr.child {
                padding: 0.5em 1em;
            }

            table.dataTable > tbody > tr.child:hover {
                background: transparent !important;
            }

            table.dataTable > tbody > tr.child ul.dtr-details {
                display: inline-block;
                list-style-type: none;
                margin: 0;
                padding: 0;
            }

            table.dataTable > tbody > tr.child ul.dtr-details > li {
                border-bottom: 1px solid #efefef;
                padding: 0.5em 0;
            }

            table.dataTable > tbody > tr.child ul.dtr-details > li:first-child {
                padding-top: 0;
            }

            table.dataTable > tbody > tr.child ul.dtr-details > li:last-child {
                border-bottom: none;
            }

            table.dataTable > tbody > tr.child span.dtr-title {
                display: inline-block;
                min-width: 75px;
                font-weight: bold;
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="modal fade" id="stockmodal" data-bs-backdrop="static" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Add/Update Stock</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="inventoryid" />
                        <div class="mb-3">
                            <label class="form-label">Medicine</label>
                            <select class="form-control" id="medicineid"></select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" id="lblPrimary">Primary Quantity</label>
                            <input type="number" class="form-control" id="primary_quantity" value="0" required />
                            <small class="text-muted">Main stock quantity</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" id="lblSecondary">Secondary Quantity</label>
                            <input type="number" class="form-control" id="secondary_quantity" value="0" />
                            <small class="text-muted">Loose items (for complex units)</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" id="lblUnitSize">Unit Size</label>
                            <input type="number" class="form-control" id="unit_size" value="1" />
                            <small class="text-muted">Items per package</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Reorder Level (Strips)</label>
                            <input type="number" class="form-control" id="reorder_level_strips" value="10" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Expiry Date</label>
                            <input type="date" class="form-control" id="expiry_date" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Batch Number</label>
                            <input type="text" class="form-control" id="batch_number" />
                        </div>
                        <!-- Purchase Price removed - Cost prices are managed in medicine master data (add_medicine.aspx) -->
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" onclick="saveStock()" class="btn btn-primary">Save</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h4 class="card-title">Medicine Inventory</h4>
                        <button type="button" id="addStock" class="btn btn-primary">Add Stock</button>
                    </div>
                    <div class="card-body">
                        <!-- Desktop Table View -->
                        <div class="table-container">
                            <table class="display nowrap" style="width:100%" id="datatable">
                                <thead>
                                    <tr>
                                        <th>Medicine Name</th>
                                        <th>Primary Qty</th>
                                        <th>Secondary Qty</th>
                                        <th>Unit Size</th>
                                        <th>Reorder Level</th>
                                        <th>Expiry Date</th>
                                        <th>Batch Number</th>
                                        <th>Status</th>
                                        <th>Operation</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>

                        <!-- Mobile Card View -->
                        <div class="mobile-view">
                            <div class="mobile-search">
                                <input type="text" id="mobileSearchInput" placeholder="🔍 Search medicine inventory..." />
                            </div>
                            <div id="mobileInventoryContainer">
                                <!-- Mobile cards will be populated here -->
                                <div class="text-center text-muted p-4">
                                    <i class="fas fa-spinner fa-spin"></i> Loading inventory...
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- JavaScript -->
        <script src="<%= ResolveUrl("~/Scripts/jquery-3.4.1.min.js") %>"></script>
        <script src="<%= ResolveUrl("~/datatables/datatables.min.js") %>"></script>
        <script>
            // Check if DataTables loaded and provide fallback
            $(document).ready(function() {
                if (typeof $.fn.DataTable === 'undefined') {
                    console.log('Local DataTables failed, loading from CDN...');
                    // Load DataTables from CDN
                    $.getScript('https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js')
                        .then(function() {
                            return $.getScript('https://cdn.datatables.net/responsive/2.5.0/js/dataTables.responsive.min.js');
                        })
                        .done(function() {
                            console.log('DataTables and Responsive loaded from CDN');
                            // Initialize after loading
                            setTimeout(function() {
                                if (typeof loadInventory === 'function') {
                                    loadInventory();
                                }
                                if (typeof loadMedicines === 'function') {
                                    loadMedicines();
                                }
                            }, 100);
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
        <script src="<%= ResolveUrl("~/assets/sweetalert2.min.js") %>"></script>
        <script>
            $(document).ready(function () {
                // Only load if DataTables is available
                if (typeof $.fn.DataTable !== 'undefined') {
                    loadInventory();
                    loadMedicines();
                } else {
                    // DataTables will be loaded by fallback script, which will call loadInventory
                    loadMedicines(); // This doesn't need DataTables
                    console.log('Waiting for DataTables to load...');
                }

                // Add Stock button click
                $('#addStock').click(function () {
                    $('#inventoryid').val('');
                    $('#medicineid').val('');
                    $('#primary_quantity').val('0');
                    $('#secondary_quantity').val('0');
                    $('#unit_size').val('1');
                    $('#reorder_level_strips').val('10');
                    $('#expiry_date').val('');
                    $('#batch_number').val('');
                    // Purchase price field removed - managed in medicine master
                    
                    var modal = new bootstrap.Modal(document.getElementById('stockmodal'));
                    modal.show();
                });

                // Medicine change event - update labels based on unit
                $('#medicineid').change(function () {
                    var medId = $(this).val();
                    if (medId) {
                        updateLabelsForMedicine(medId);
                    }
                });
            });

            function loadMedicines() {
                $.ajax({
                    url: 'medicine_inventory.aspx/getMedicines',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    success: function (response) {
                        var dropdown = $('#medicineid');
                        dropdown.empty();
                        dropdown.append('<option value="">-- Select Medicine --</option>');
                        for (var i = 0; i < response.d.length; i++) {
                            dropdown.append('<option value="' + response.d[i].medicineid + '">' + 
                                response.d[i].medicine_name + '</option>');
                        }
                    },
                    error: function (xhr) {
                        console.error('Error loading medicines:', xhr.responseText);
                    }
                });
            }

            function updateLabelsForMedicine(medicineId) {
                $.ajax({
                    url: 'medicine_inventory.aspx/getMedicineUnitDetails',
                    data: JSON.stringify({ medicineid: medicineId }),
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    success: function (response) {
                        if (response.d) {
                            var unit = response.d;
                            var isComplex = (unit.allows_subdivision === 'True' || unit.allows_subdivision === true || unit.allows_subdivision === '1');
                            
                            if (isComplex) {
                                // COMPLEX UNITS (Tablet/Capsule) - Show all fields
                                $('#primary_quantity').closest('.mb-3').show();
                                $('#secondary_quantity').closest('.mb-3').show();
                                $('#unit_size').closest('.mb-3').show();
                                
                                // Update labels for complex units
                                $('#lblPrimary').text('Primary Quantity (' + (unit.subdivision_unit || 'strips') + ')');
                                $('#lblSecondary').text('Secondary Quantity (loose ' + (unit.base_unit_name || 'pieces') + ')');
                                $('#lblUnitSize').text('Unit Size (' + (unit.base_unit_name || 'pieces') + ' per ' + (unit.subdivision_unit || 'strip') + ')');
                            } else {
                                // SIMPLE UNITS - Hide secondary quantity and unit size
                                $('#primary_quantity').closest('.mb-3').show();
                                $('#secondary_quantity').closest('.mb-3').hide();
                                $('#unit_size').closest('.mb-3').hide();
                                
                                // Update label for simple units
                                $('#lblPrimary').text('Quantity (units in stock)');
                                
                                // Set hidden fields to defaults
                                $('#secondary_quantity').val('0');
                                $('#unit_size').val('1');
                            }
                        }
                    },
                    error: function(xhr) {
                        console.error('Error loading medicine unit details:', xhr.responseText);
                    }
                });
            }

            function loadInventory() {
                $.ajax({
                    url: 'medicine_inventory.aspx/getInventory',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    success: function (response) {
                        console.log('Inventory data loaded:', response.d);
                        
                        // Check if DataTables is available
                        if (typeof $.fn.DataTable === 'undefined') {
                            console.error('DataTables library not loaded');
                            alert('DataTables library not loaded. Please check your internet connection and refresh the page.');
                            return;
                        }
                        
                        // Destroy existing table if it exists
                        if ($.fn.DataTable.isDataTable('#datatable')) {
                            $('#datatable').DataTable().destroy();
                        }
                        
                        var table = $('#datatable').DataTable({
                            destroy: true,
                            responsive: {
                                details: {
                                    type: 'inline',
                                    display: $.fn.dataTable.Responsive.display.childRowImmediate,
                                    renderer: function (api, rowIdx, columns) {
                                        var data = $.map(columns, function (col, i) {
                                            return col.hidden ?
                                                '<li data-dtr-index="' + col.columnIndex + '" data-dt-row="' + col.rowIndex + '" data-dt-column="' + col.columnIndex + '">' +
                                                '<span class="dtr-title">' +
                                                col.title +
                                                '</span> ' +
                                                '<span class="dtr-data">' +
                                                col.data +
                                                '</span>' +
                                                '</li>' :
                                                '';
                                        }).join('');
                                        return data ? $('<ul data-dtr-index="' + rowIdx + '" class="dtr-details"/>').append(data) : false;
                                    }
                                }
                            },
                            autoWidth: false,
                            scrollX: true,
                            data: response.d,
                            columnDefs: [
                                { responsivePriority: 1, targets: 0 }, // Medicine Name - Always visible
                                { responsivePriority: 2, targets: -1 }, // Operation - Always visible
                                { responsivePriority: 3, targets: 1 }, // Primary Qty - High priority
                                { responsivePriority: 4, targets: 7 }, // Status - High priority
                                { responsivePriority: 10, targets: [2, 3, 4, 5, 6] } // Secondary data - Lower priority
                            ],
                            columns: [
                                { 
                                    data: 'medicine_name',
                                    render: function(data) {
                                        return data || 'N/A';
                                    }
                                },
                                { data: 'primary_quantity' },
                                { data: 'secondary_quantity' },
                                { data: 'unit_size' },
                                { data: 'reorder_level_strips' },
                                { 
                                    data: 'expiry_date',
                                    render: function(data) {
                                        return data || 'N/A';
                                    }
                                },
                                { 
                                    data: 'batch_number',
                                    render: function(data) {
                                        return data || 'N/A';
                                    }
                                },
                                { 
                                    data: null,
                                    render: function(data) {
                                        var primaryQty = parseInt(data.primary_quantity) || 0;
                                        var reorderLevel = parseInt(data.reorder_level_strips) || 0;
                                        if (primaryQty <= reorderLevel) {
                                            return '<span class="badge bg-danger">Low Stock</span>';
                                        }
                                        return '<span class="badge bg-success">In Stock</span>';
                                    }
                                },
                                {
                                    data: null,
                                    render: function (data) {
                                        return '<button type="button" class="btn btn-sm btn-primary edit-btn" data-id="' + 
                                            data.inventoryid + '">Edit</button>';
                                    }
                                }
                            ]
                        });

                        // Edit button click
                        $('#datatable').on('click', '.edit-btn', function (e) {
                            e.preventDefault();
                            e.stopPropagation();
                            var id = $(this).data('id');
                            editStock(id);
                            return false;
                        });

                        // Update mobile view with loaded data
                        updateMobileView(response.d);
                    },
                    error: function (xhr) {
                        console.error('Error loading inventory:', xhr.responseText);
                        Swal.fire('Error', 'Failed to load inventory data', 'error');
                    }
                });
            }

            function editStock(id) {
                console.log('=== EDIT STOCK DEBUG ===');
                console.log('Inventory ID:', id);
                
                $.ajax({
                    url: 'medicine_inventory.aspx/getInventoryById',
                    data: JSON.stringify({ id: id }),
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    success: function (response) {
                        console.log('Edit response:', response);
                        
                        if (response.d && response.d.length > 0) {
                            // Backend returns array, get first item
                            var data = response.d[0];
                            console.log('Loaded data:', data);
                            
                            $('#inventoryid').val(data.inventoryid);
                            $('#medicineid').val(data.medicineid);
                            $('#primary_quantity').val(data.primary_quantity);
                            $('#secondary_quantity').val(data.secondary_quantity);
                            $('#unit_size').val(data.unit_size);
                            $('#reorder_level_strips').val(data.reorder_level_strips);
                            $('#expiry_date').val(data.expiry_date);
                            $('#batch_number').val(data.batch_number);
                            // Purchase price field removed
                            
                            console.log('Medicine ID set to:', data.medicineid);
                            console.log('Fields populated - opening modal');
                            
                            var modal = new bootstrap.Modal(document.getElementById('stockmodal'));
                            modal.show();
                            
                            console.log('Modal opened');
                        } else {
                            console.warn('No data returned from backend!');
                            Swal.fire('Error', 'No data found for this inventory item', 'error');
                        }
                    },
                    error: function (xhr) {
                        console.error('Edit error:', xhr.responseText);
                        Swal.fire('Error', 'Failed to load inventory data: ' + xhr.responseText, 'error');
                    }
                });
            }

            function saveStock() {
                var inventoryid = $('#inventoryid').val();
                var medicineid = $('#medicineid').val();
                var primary_quantity = $('#primary_quantity').val();
                var secondary_quantity = $('#secondary_quantity').val();
                var unit_size = $('#unit_size').val();
                var reorder_level_strips = $('#reorder_level_strips').val();
                var expiry_date = $('#expiry_date').val();
                var batch_number = $('#batch_number').val();
                // Purchase price removed - cost is managed in medicine master data

                if (!medicineid) {
                    Swal.fire('Error', 'Please select a medicine', 'error');
                    return;
                }

                var data = {
                    inventoryid: inventoryid,
                    medicineid: medicineid,
                    primary_quantity: primary_quantity,
                    secondary_quantity: secondary_quantity,
                    unit_size: unit_size,
                    reorder_level_strips: reorder_level_strips,
                    expiry_date: expiry_date,
                    batch_number: batch_number,
                    // purchase_price removed - not needed in inventory
                };

                $.ajax({
                    url: 'medicine_inventory.aspx/saveStock',
                    data: JSON.stringify(data),
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    success: function (response) {
                        if (response.d === 'true') {
                            var modal = bootstrap.Modal.getInstance(document.getElementById('stockmodal'));
                            if (modal) modal.hide();
                            Swal.fire('Success', 'Inventory saved successfully!', 'success');
                            loadInventory();
                        } else {
                            Swal.fire('Error', response.d, 'error');
                        }
                    },
                    error: function (xhr) {
                        Swal.fire('Error', 'Failed to save: ' + xhr.responseText, 'error');
                    }
                });
            }

            // Mobile View Functions
            var allInventoryData = [];
            var isMobileView = false;

            // Responsive utility functions
            function checkIfMobile() {
                return window.innerWidth <= 767;
            }

            function updateViewMode() {
                isMobileView = checkIfMobile();
                if (isMobileView) {
                    $('.table-container').hide();
                    $('.mobile-view').show();
                    populateMobileCards(allInventoryData);
                } else {
                    $('.table-container').show();
                    $('.mobile-view').hide();
                }
            }

            // Update mobile view with inventory data
            function updateMobileView(inventoryData) {
                allInventoryData = inventoryData || [];
                if (checkIfMobile()) {
                    populateMobileCards(allInventoryData);
                }
            }

            // Mobile cards generation
            function populateMobileCards(inventory) {
                const container = $('#mobileInventoryContainer');
                container.empty();

                if (!inventory || inventory.length === 0) {
                    container.html(`
                        <div class="text-center text-muted p-4">
                            <i class="fas fa-pills fa-2x mb-3"></i>
                            <p>No inventory items found</p>
                        </div>
                    `);
                    return;
                }

                inventory.forEach(function(item, index) {
                    const card = createInventoryCard(item, index);
                    container.append(card);
                });
            }

            function createInventoryCard(item, index) {
                const primaryQty = parseInt(item.primary_quantity) || 0;
                const reorderLevel = parseInt(item.reorder_level_strips) || 0;
                const isLowStock = primaryQty <= reorderLevel;
                
                // Check if expired
                const expiryDate = item.expiry_date ? new Date(item.expiry_date) : null;
                const isExpired = expiryDate && expiryDate < new Date();
                
                let statusClass = 'badge-success';
                let statusText = 'In Stock';
                let cardClass = '';
                let headerClass = '';
                
                if (isExpired) {
                    statusClass = 'badge-warning';
                    statusText = 'Expired';
                    cardClass = 'expired';
                    headerClass = 'expired';
                } else if (isLowStock) {
                    statusClass = 'badge-danger';
                    statusText = 'Low Stock';
                    cardClass = 'low-stock';
                    headerClass = 'low-stock';
                }
                
                return `
                    <div class="inventory-mobile-card ${cardClass}" data-inventory-id="${item.inventoryid}">
                        <div class="mobile-card-header ${headerClass}" onclick="toggleInventoryCard(this)">
                            <div class="mobile-card-compact">
                                <h5 class="medicine-name-mobile">${item.medicine_name || 'Unknown Medicine'}</h5>
                                <p class="stock-brief-info">Stock: ${primaryQty} • Reorder: ${reorderLevel}</p>
                            </div>
                            <span class="stock-status-mobile badge ${statusClass}">${statusText}</span>
                            <i class="fas fa-chevron-down expand-icon"></i>
                        </div>
                        <div class="mobile-card-body">
                            <div class="mobile-info-grid">
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Primary Qty</div>
                                    <div class="mobile-info-value">${primaryQty}</div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Secondary Qty</div>
                                    <div class="mobile-info-value">${item.secondary_quantity || '0'}</div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Unit Size</div>
                                    <div class="mobile-info-value">${item.unit_size || '1'}</div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Reorder Level</div>
                                    <div class="mobile-info-value">${reorderLevel}</div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Expiry Date</div>
                                    <div class="mobile-info-value">${expiryDate ? expiryDate.toLocaleDateString() : 'N/A'}</div>
                                </div>
                                <div class="mobile-info-item">
                                    <div class="mobile-info-label">Batch Number</div>
                                    <div class="mobile-info-value">${item.batch_number || 'N/A'}</div>
                                </div>
                            </div>
                            <div class="mobile-actions">
                                <button type="button" class="btn btn-primary btn-sm" onclick="editStockMobile(${item.inventoryid}, event)">
                                    <i class="fas fa-edit"></i> Edit Stock
                                </button>
                            </div>
                        </div>
                    </div>
                `;
            }

            function editStockMobile(id, event) {
                if (event) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                editStock(id);
                return false;
            }

            // Function to toggle card expansion
            function toggleInventoryCard(header) {
                const card = $(header).closest('.inventory-mobile-card');
                card.toggleClass('expanded');
            }

            // Mobile search functionality
            function setupMobileSearch() {
                $('#mobileSearchInput').on('input', function() {
                    const searchTerm = $(this).val().toLowerCase().trim();
                    
                    if (searchTerm === '') {
                        populateMobileCards(allInventoryData);
                        return;
                    }

                    const filteredInventory = allInventoryData.filter(function(item) {
                        const searchableText = [
                            item.medicine_name,
                            item.batch_number,
                            item.primary_quantity,
                            item.secondary_quantity
                        ].join(' ').toLowerCase();
                        
                        return searchableText.includes(searchTerm);
                    });

                    populateMobileCards(filteredInventory);
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
        </script>
    </asp:Content>
