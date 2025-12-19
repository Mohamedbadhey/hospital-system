<%@ Page Title="" Language="C#" MasterPageFile="~/pharmacy.Master" AutoEventWireup="true"
    CodeBehind="pharmacy_pos.aspx.cs" Inherits="juba_hospital.pharmacy_pos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .pos-container {
            display: flex;
            gap: 20px;
        }

        .pos-left {
            flex: 2; /* Takes 2/3 of the space - Product section */
        }

        .pos-right {
            flex: 1; /* Takes 1/3 of the space - Cart section */
        }

        .cart-item {
            padding: 10px;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .cart-item-info {
            flex: 1;
            min-width: 150px;
        }

        .cart-item-controls {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .total-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }

        /* Mobile Responsive Styles */
        @media (max-width: 768px) {
            .pos-container {
                flex-direction: column;
                gap: 15px;
            }

            .pos-left,
            .pos-right {
                width: 100%;
            }

            .card-body {
                padding: 10px;
            }

            .input-group {
                flex-wrap: nowrap;
            }

            .input-group .btn {
                padding: 6px 10px;
                font-size: 14px;
            }

            .form-control,
            .form-select {
                font-size: 14px;
                padding: 8px;
            }

            .cart-item {
                flex-direction: column;
                align-items: flex-start;
                padding: 15px 10px;
            }

            .cart-item-info {
                width: 100%;
                margin-bottom: 10px;
            }

            .cart-item-controls {
                width: 100%;
                justify-content: space-between;
            }

            .quantity-controls {
                flex-wrap: nowrap;
            }

            .quantity-controls input {
                width: 50px;
                text-align: center;
                padding: 5px;
            }

            .btn-sm {
                padding: 4px 8px;
                font-size: 12px;
            }

            .total-section {
                padding: 15px;
            }

            .btn-block {
                width: 100%;
                margin-bottom: 10px;
            }

            h4, h5 {
                font-size: 18px;
            }

            .card-title {
                font-size: 16px;
            }

            /* Make search box more mobile friendly */
            #searchMedicine {
                font-size: 16px; /* Prevents zoom on iOS */
            }

            /* Stack medicine details better on mobile */
            #medicineDetails .card-body {
                padding: 15px;
            }

            #medicineDetails .mb-3 {
                margin-bottom: 15px;
            }
        }

        @media (max-width: 480px) {
            .card-header {
                padding: 10px;
            }

            .card-title {
                font-size: 14px;
            }

            .form-label {
                font-size: 13px;
                margin-bottom: 5px;
            }

            .btn {
                padding: 8px 12px;
                font-size: 13px;
            }

            .btn-lg {
                padding: 10px 16px;
                font-size: 14px;
            }

            .total-section h4 {
                font-size: 16px;
            }

            .cart-item {
                font-size: 13px;
            }

            /* Make text more readable on small screens */
            body {
                font-size: 14px;
            }

            small {
                font-size: 11px;
            }
        }

        /* Landscape orientation on mobile */
        @media (max-width: 768px) and (orientation: landscape) {
            .pos-container {
                flex-direction: row;
            }

            .pos-left,
            .pos-right {
                width: 50%;
            }
        }

        /* Touch-friendly buttons */
        @media (hover: none) and (pointer: coarse) {
            .btn {
                min-height: 44px; /* Apple's recommended touch target size */
                min-width: 44px;
            }

            .form-control,
            .form-select {
                min-height: 44px;
            }

            .quantity-controls button {
                min-width: 40px;
                min-height: 40px;
            }
        }

        /* Medicine grid and card styles */
        .medicine-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
            gap: 12px;
            max-height: 65vh; /* enable virtual scrolling */
            overflow-y: auto;
            padding-right: 4px; /* room for scrollbar */
        }
        .medicine-card {
            border: 2px solid #e5e5e5;
            border-radius: 8px;
            padding: 12px;
            background: #ffffff !important;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            flex-direction: column;
            gap: 8px;
            min-height: 95px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        .medicine-card:hover {
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
            border-color: #007bff;
            transform: translateY(-1px);
        }
        .medicine-card:active {
            transform: scale(0.98) translateY(0);
        }
        .medicine-card.selected {
            border-color: #007bff !important;
            box-shadow: 0 0 0 3px rgba(0,123,255,0.25) !important;
            background: #f8f9ff !important;
        }
        .medicine-name {
            font-weight: 700;
            font-size: 15px;
            color: #1a1a1a !important;
            line-height: 1.3;
            margin: 0;
            text-shadow: none;
        }
        .medicine-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 6px;
        }
        .badge {
            display: inline-block;
            font-size: 12px;
            padding: 3px 6px;
            border-radius: 10px;
            line-height: 1;
        }
        .badge-price {
            background: #007bff !important;
            color: #ffffff !important;
            font-weight: 700;
            font-size: 11px;
            text-shadow: none;
        }
        .badge-stock {
            background: #28a745 !important;
            color: #ffffff !important;
            font-weight: 700;
            font-size: 11px;
            text-shadow: none;
        }
        .badge-low {
            background: #ffc107 !important;
            color: #212529 !important;
            font-weight: 700;
            font-size: 11px;
            text-shadow: none;
        }
        .badge-out {
            background: #dc3545 !important;
            color: #ffffff !important;
            font-weight: 700;
            font-size: 11px;
            text-shadow: none;
        }
        .stock-details {
            color: #666666 !important;
            font-size: 11px;
            margin: 4px 0 0 0;
            font-weight: 500;
            text-shadow: none;
            font-style: italic;
        }
        .medicine-sub {
            color: #495057 !important;
            font-size: 12px;
            margin: 2px 0 0 0;
            font-weight: 500;
            text-shadow: none;
        }
        
        /* Category tabs */
        .category-tabs {
            display: flex;
            gap: 8px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }
        .category-tab {
            padding: 8px 16px;
            border: 2px solid #dee2e6;
            border-radius: 25px;
            background: #ffffff !important;
            color: #333333 !important;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            transition: all 0.2s ease;
            white-space: nowrap;
            text-shadow: none;
        }
        .category-tab:hover {
            border-color: #007bff !important;
            color: #007bff !important;
            background: #f8f9ff !important;
        }
        .category-tab.active {
            background: #007bff !important;
            border-color: #007bff !important;
            color: #ffffff !important;
            box-shadow: 0 2px 8px rgba(0,123,255,0.3);
        }
        .category-tab .count {
            margin-left: 4px;
            opacity: 0.8;
        }
        
        @media (max-width: 768px) {
            .medicine-grid {
                grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
                gap: 10px;
            }
            .medicine-card { min-height: 84px; }
            .category-tabs {
                gap: 6px;
            }
            .category-tab {
                font-size: 12px;
                padding: 5px 10px;
            }
        }

        /* Price validation styles */
        .price-valid {
            border-color: #28a745 !important;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25) !important;
        }
        
        .price-invalid {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25) !important;
        }
        
        .price-warning {
            border-color: #ffc107 !important;
            box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.25) !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title">Point of Sale (POS)</h4>
                </div>
                <div class="card-body">
                    <div class="pos-container">
                        <!-- Left Side - Product Selection -->
                        <div class="pos-left">
                            <div class="mb-3">
                                <label class="form-label">Search Medicine</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-barcode"></i></span>
                                    <input type="text" class="form-control" id="searchMedicine"
                                        placeholder="Search by name, barcode, or scan..." 
                                        autocomplete="off">
                                    <button class="btn btn-primary" type="button" onclick="performSearch()">
                                        <i class="fas fa-search"></i> Search
                                    </button>
                                </div>
                                <small class="text-muted">
                                    Type name/barcode and press Enter, or scan with barcode scanner
                                </small>
                                <small id="searchResultInfo" class="d-block mt-1"></small>
                            </div>
                            <div class="mb-3 d-none" id="selectFallback">
                                <label class="form-label">Select Medicine</label>
                                <select class="form-control" id="medicineSelect" onchange="loadMedicineDetails()">
                                    <option value="">-- Select Medicine --</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Browse Medicines</label>
                                <div id="categoryTabs" class="category-tabs"></div>
                                <div id="medicineGrid" class="medicine-grid"></div>
                                <small class="text-muted d-block mt-1" id="gridInfo"></small>
                            </div>

                            <div id="medicineDetails" style="display:none;">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 id="medName"></h5>
                                        <p><strong>Generic:</strong> <span id="medGeneric"></span></p>
                                        <p><strong>Manufacturer:</strong> <span id="medManufacturer"></span></p>
                                        <p><strong>Available Stock:</strong> <span id="medStock"></span></p>

                                        <div class="mb-3">
                                            <label class="form-label">Sell Type</label>
                                            <select class="form-control" id="sellType" onchange="updatePrice()">
                                                <!-- Options will be dynamically populated based on unit type -->
                                            </select>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Quantity</label>
                                            <input type="number" class="form-control" id="quantity" min="1"
                                                value="1" onchange="updatePrice()">
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Unit Price (Editable)</label>
                                            <input type="number" step="0.01" class="form-control" id="unitPrice" onchange="validateAndUpdatePrice()">
                                            <small class="text-muted" id="priceHint">You can set any price equal to or above the minimum unit price</small>
                                            <div class="mt-1">
                                                <small class="text-info" id="minPriceDisplay"></small>
                                            </div>
                                        </div>

                                        <div class="mb-3">
                                            <label class="form-label">Total Price</label>
                                            <input type="text" class="form-control" id="totalPrice" readonly>
                                        </div>

                                        <div class="row g-2">
                                            <div class="col-8">
                                                <button type="button" class="btn btn-primary btn-block"
                                                    onclick="addToCart()">
                                                    <i class="fas fa-cart-plus"></i> Add to Cart
                                                </button>
                                            </div>
                                            <div class="col-4">
                                                <button type="button" class="btn btn-outline-secondary btn-block"
                                                    onclick="clearMedicineDetails()" title="Clear selection">
                                                    <i class="fas fa-times"></i> Clear
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Right Side - Cart -->
                        <div class="pos-right">
                            <div class="card">
                                <div class="card-header">
                                    <h5>Shopping Cart</h5>
                                </div>
                                <div class="card-body">
                                    <div id="cartItems"></div>
                                    <div class="total-section">
                                        <div class="d-flex justify-content-between mb-2">
                                            <strong>Subtotal:</strong>
                                            <span id="subtotal">0.00</span>
                                        </div>
                                        <div class="d-flex justify-content-between">
                                            <h4>Total:</h4>
                                            <h4 id="finalTotal">0.00</h4>
                                        </div>
                                    </div>

                                    <div class="mb-3 mt-3">
                                        <label class="form-label">Customer Name (Optional)</label>
                                        <input type="text" class="form-control" id="customerName"
                                            placeholder="Walk-in customer">
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label">Payment Method</label>
                                        <select class="form-control" id="paymentMethod">
                                            <option value="Cash">Cash</option>
                                            <option value="Card">Card</option>
                                            <option value="Mobile Payment">Mobile Payment</option>
                                        </select>
                                    </div>

                                    <button type="button" class="btn btn-success btn-lg btn-block"
                                        onclick="processSale()">Complete Sale</button>
                                    <button type="button" class="btn btn-danger btn-block mt-2"
                                        onclick="clearCart()">Clear Cart</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="<%= ResolveUrl("~/Scripts/jquery-3.4.1.min.js") %>"></script>
    <script src="<%= ResolveUrl("~/assets/sweetalert2.min.js") %>"></script>
    <script>
        var cart = [];
        var currentMedicine = null;

        $(document).ready(function () {
            loadMedicines();
            setupBarcodeScanning();
        });

        function loadMedicines() {
            $.ajax({
                url: 'pharmacy_pos.aspx/getAvailableMedicines',
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    renderMedicineGrid(r.d || []);
                },
                error: function (xhr, status, error) {
                    console.error('Error loading medicines:', error);
                    Swal.fire('Error', 'Failed to load medicines. Please check if the database columns exist.', 'error');
                }
            });
        }

        function formatPrice(med) {
            var price = parseFloat(med.price_per_tablet || med.price_per_strip || med.price_per_box || 0);
            if (!price || price <= 0) return '';
            return '$' + price.toFixed(2);
        }

        function formatStockBadge(med) {
            var primaryQty = parseInt(med.primary_quantity || med.total_strips || 0);
            var secondaryQty = parseFloat(med.secondary_quantity || med.loose_tablets || 0);
            var total = primaryQty + secondaryQty;
            
            if (total <= 0) {
                return '<span class="badge badge-out">Out of Stock</span>';
            } else if (total < 10) {
                return '<span class="badge badge-low">Low: ' + total + '</span>';
            } else {
                return '<span class="badge badge-stock">Stock: ' + total + '</span>';
            }
        }

        function formatStockDetails(med) {
            var details = [];
            
            // Primary quantity (strips/bottles/vials etc.)
            var primaryQty = parseInt(med.primary_quantity || med.total_strips || 0);
            if (primaryQty > 0) {
                var unitName = med.subdivision_unit || med.unit_name || 'units';
                details.push(primaryQty + ' ' + unitName);
            }
            
            // Secondary quantity (loose tablets/ml etc.)
            var secondaryQty = parseFloat(med.secondary_quantity || med.loose_tablets || 0);
            if (secondaryQty > 0) {
                var baseUnit = med.base_unit_name || 'tablets';
                details.push(secondaryQty + ' ' + baseUnit);
            }
            
            return details.length > 0 ? details.join(' + ') : 'No stock';
        }

        // Virtual/infinite scrolling implementation
        var __medAll = [];
        var __medFiltered = [];
        var __medBatchIndex = 0;
        var __medBatchSize = 60;
        var __gridInitialized = false;
        var __activeCategory = 'all';

        function categorizeMetMedicines(medicines) {
            var categories = {
                'all': { name: 'All', medicines: medicines },
                'tablet': { name: 'Tablets', medicines: [] },
                'syrup': { name: 'Syrups', medicines: [] },
                'injection': { name: 'Injections', medicines: [] },
                'cream': { name: 'Creams/Ointments', medicines: [] },
                'other': { name: 'Other', medicines: [] }
            };

            medicines.forEach(function(med) {
                var name = (med.medicine_name || '').toLowerCase();
                var generic = (med.generic_name || '').toLowerCase();
                var combined = name + ' ' + generic;

                if (combined.includes('tablet') || combined.includes('tab') || combined.includes('capsule') || combined.includes('cap')) {
                    categories.tablet.medicines.push(med);
                } else if (combined.includes('syrup') || combined.includes('suspension') || combined.includes('liquid')) {
                    categories.syrup.medicines.push(med);
                } else if (combined.includes('injection') || combined.includes('inj') || combined.includes('vial') || combined.includes('ampoule')) {
                    categories.injection.medicines.push(med);
                } else if (combined.includes('cream') || combined.includes('ointment') || combined.includes('gel') || combined.includes('lotion')) {
                    categories.cream.medicines.push(med);
                } else {
                    categories.other.medicines.push(med);
                }
            });

            return categories;
        }

        function renderCategoryTabs(categories) {
            var $tabs = $('#categoryTabs');
            $tabs.empty();

            Object.keys(categories).forEach(function(key) {
                var category = categories[key];
                if (key !== 'all' && category.medicines.length === 0) return;

                var isActive = __activeCategory === key ? 'active' : '';
                var count = category.medicines.length;
                var tabHtml = '<div class="category-tab ' + isActive + '" data-category="' + key + '">' +
                             category.name + '<span class="count">(' + count + ')</span></div>';
                $tabs.append(tabHtml);
            });
        }

        function renderMedicineGrid(medicines) {
            var $grid = $('#medicineGrid');
            var $info = $('#gridInfo');
            $grid.empty();

            __medAll = medicines || [];
            __medBatchIndex = 0;

            if (!__gridInitialized) {
                // Attach scroll handler once
                $grid.on('scroll', function() {
                    var el = this;
                    if (el.scrollTop + el.clientHeight >= el.scrollHeight - 100) {
                        renderNextMedicineBatch();
                    }
                });
                __gridInitialized = true;
            }

            // Categorize and render tabs
            var categories = categorizeMetMedicines(__medAll);
            renderCategoryTabs(categories);

            // Filter by active category
            if (__activeCategory === 'all') {
                __medFiltered = __medAll;
            } else {
                __medFiltered = categories[__activeCategory] ? categories[__activeCategory].medicines : [];
            }

            if (!__medFiltered || __medFiltered.length === 0) {
                $grid.html('<div class="text-muted p-3">No medicines available in this category</div>');
                $info.text('');
                return;
            }

            $info.text(__medFiltered.length + ' medicine(s)');
            renderNextMedicineBatch();
        }

        function renderNextMedicineBatch() {
            var $grid = $('#medicineGrid');
            if (__medBatchIndex >= __medFiltered.length) return;
            var end = Math.min(__medBatchIndex + __medBatchSize, __medFiltered.length);

            for (var i = __medBatchIndex; i < end; i++) {
                var med = __medFiltered[i];
                var price = formatPrice(med);
                var stockBadge = formatStockBadge(med);
                var stockDetails = formatStockDetails(med);
                var generic = med.generic_name ? '<div class="medicine-sub">' + med.generic_name + '</div>' : '';
                var barcode = med.barcode ? '<div class="medicine-sub"><i class="fas fa-barcode"></i> ' + med.barcode + '</div>' : '';
                var priceBadge = price ? '<span class="badge badge-price">' + price + '</span>' : '';

                // Combine all additional info
                var additionalInfo = '';
                if (generic) additionalInfo += generic;
                if (barcode) additionalInfo += barcode;
                additionalInfo += '<div class="stock-details"><i class="fas fa-boxes"></i> ' + stockDetails + '</div>';

                var cardHtml = 
                    '<div class="medicine-card" data-medicineid="' + med.medicineid + '" data-inventoryid="' + (med.inventoryid || '') + '" data-barcode="' + (med.barcode || '') + '">' +
                        '<div class="medicine-name">' + med.medicine_name + '</div>' +
                        '<div class="medicine-meta">' +
                            (priceBadge || '<span style="flex:1"></span>') +
                            stockBadge +
                        '</div>' +
                        additionalInfo +
                    '</div>';
                $grid.append(cardHtml);
            }

            __medBatchIndex = end;
        }

        // Category tab click handler
        $(document).on('click', '.category-tab', function() {
            var category = $(this).data('category');
            __activeCategory = category;
            $('.category-tab').removeClass('active');
            $(this).addClass('active');
            
            // Re-render grid with filtered medicines
            var categories = categorizeMetMedicines(__medAll);
            if (__activeCategory === 'all') {
                __medFiltered = __medAll;
            } else {
                __medFiltered = categories[__activeCategory] ? categories[__activeCategory].medicines : [];
            }
            
            var $grid = $('#medicineGrid');
            var $info = $('#gridInfo');
            $grid.empty();
            __medBatchIndex = 0;
            
            if (!__medFiltered || __medFiltered.length === 0) {
                $grid.html('<div class="text-muted p-3">No medicines available in this category</div>');
                $info.text('');
                return;
            }
            
            $info.text(__medFiltered.length + ' medicine(s)');
            renderNextMedicineBatch();
        });

        // Click on a card to load its details
        $(document).on('click', '.medicine-card', function() {
            var $card = $(this);
            var medId = $card.data('medicineid');
            var inventoryId = $card.data('inventoryid');
            
            if (!medId) {
                console.log('No medicine ID found on card');
                return;
            }

            // Clear previous selection first
            clearMedicineDetails(false); // false = don't hide the details panel
            
            // Visual feedback and hide other cards
            $('.medicine-card').removeClass('selected');
            $card.addClass('selected');
            
            // Hide all other cards except the selected one
            $('.medicine-card').not($card).hide();
            
            // Scroll to the selected card
            $card[0].scrollIntoView({ behavior: 'smooth', block: 'start' });

            // Find the medicine data and populate the hidden select
            var selectedMed = null;
            for (var i = 0; i < __medAll.length; i++) {
                if (__medAll[i].medicineid == medId) {
                    selectedMed = __medAll[i];
                    break;
                }
            }

            if (selectedMed) {
                // Update the hidden select with proper option
                $('#medicineSelect').empty();
                var unitDisplay = selectedMed.unit_name || 'Unit';
                if (selectedMed.unit_abbreviation) {
                    unitDisplay += ' (' + selectedMed.unit_abbreviation + ')';
                }
                var stockQty = selectedMed.primary_quantity || selectedMed.total_strips || '0';
                var stockUnit = selectedMed.subdivision_unit || 'Units';
                var displayText = selectedMed.medicine_name + ' - ' + unitDisplay + ' (Stock: ' + stockQty + ' ' + stockUnit + ')';
                
                $('#medicineSelect').append('<option value="' + selectedMed.medicineid + '" data-inventory="' + (selectedMed.inventoryid || '') + '" selected>' + displayText + '</option>');
                $('#medicineSelect').val(selectedMed.medicineid);
            }

            // Load medicine details
            loadMedicineDetails();
            
            // Scroll to details on mobile
            if (window.innerWidth < 769) {
                setTimeout(function() {
                    var detailsElement = document.getElementById('medicineDetails');
                    if (detailsElement && detailsElement.style.display !== 'none') {
                        $('html, body').animate({ 
                            scrollTop: $(detailsElement).offset().top - 60 
                        }, 300);
                    }
                }, 100);
            }
        });

        function loadMedicineDetails() {
            var medicineid = $('#medicineSelect').val();
            if (!medicineid) {
                $('#medicineDetails').hide();
                return;
            }

            $.ajax({
                url: 'pharmacy_pos.aspx/getMedicineDetails',
                data: JSON.stringify({ medicineid: medicineid }),
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    if (r.d && r.d.length > 0) {
                        currentMedicine = r.d[0];

                        // Display medicine info
                        $('#medName').text(currentMedicine.medicine_name);
                        $('#medGeneric').text(currentMedicine.generic_name || 'N/A');
                        $('#medManufacturer').text(currentMedicine.manufacturer || 'N/A');

                        // Calculate and display stock
                        var stockDisplay = calculateStockDisplay(currentMedicine);
                        $('#medStock').html(stockDisplay);

                        // Populate sell type dropdown based on unit configuration
                        populateSellTypes(currentMedicine);

                        // Reset quantity and update price
                        $('#quantity').val(1);
                        updatePrice();

                        $('#medicineDetails').show();
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error loading medicine details:', xhr.responseText);
                    Swal.fire('Error', 'Failed to load medicine details: ' + xhr.responseText, 'error');
                }
            });
        }

        function calculateStockDisplay(med) {
            var stockParts = [];

            // Primary quantity (strips, bottles, vials, etc.)
            var primaryQty = parseInt(med.primary_quantity || med.total_strips || 0);
            var stripsPerBox = parseInt(med.strips_per_box || 0);
            
            // If we have box packaging configured, show boxes + remaining strips
            if (stripsPerBox > 0 && primaryQty >= stripsPerBox) {
                var fullBoxes = Math.floor(primaryQty / stripsPerBox);
                var looseStrips = primaryQty % stripsPerBox;
                
                if (fullBoxes > 0) {
                    stockParts.push('<strong>' + fullBoxes + ' boxes</strong>');
                }
                if (looseStrips > 0) {
                    var primaryUnit = med.subdivision_unit || med.unit_name || 'units';
                    stockParts.push(looseStrips + ' ' + primaryUnit);
                }
            } else if (primaryQty > 0) {
                // No box packaging or less than a box
                var primaryUnit = med.subdivision_unit || med.unit_name || 'units';
                stockParts.push(primaryQty + ' ' + primaryUnit);
            }

            // Secondary quantity (loose items)
            var secondaryQty = parseFloat(med.secondary_quantity || med.loose_tablets || 0);
            if (secondaryQty > 0) {
                var secondaryUnit = med.base_unit_name || 'piece';
                if (med.selling_method === 'volume') {
                    secondaryUnit = 'ml';
                }
                // Make plural only if secondaryUnit doesn't already end with 's'
                var displayUnit = secondaryUnit;
                if (secondaryQty !== 1 && !secondaryUnit.endsWith('s')) {
                    displayUnit = secondaryUnit + 's';
                }
                stockParts.push(secondaryQty + ' loose ' + displayUnit);
            }

            if (stockParts.length === 0) {
                return '<span class="text-danger"><strong>Out of stock</strong></span>';
            }
            
            return stockParts.join(' + ');
        }

        function populateSellTypes(med) {
            var sellTypeSelect = $('#sellType');
            sellTypeSelect.empty();
            
            // Remove any existing change handler to prevent duplicates
            sellTypeSelect.off('change');

            var sellingMethod = med.selling_method || 'countable';
            var baseUnit = med.base_unit_name || 'piece';
            var subdivisionUnit = med.subdivision_unit || '';
            var allowsSubdivision = med.allows_subdivision === 'True' || med.allows_subdivision === '1' || med.allows_subdivision === true;
            var tabletsPerStrip = parseInt(med.tablets_per_strip || med.unit_size || 0);
            var stripsPerBox = parseInt(med.strips_per_box || 0);
            var pricePerTablet = parseFloat(med.price_per_tablet || 0);
            var pricePerStrip = parseFloat(med.price_per_strip || 0);
            var pricePerBox = parseFloat(med.price_per_box || 0);

            // Always add base unit (individual pieces, ml, mg, etc.)
            var baseLabel = baseUnit.charAt(0).toUpperCase() + baseUnit.slice(1);
            if (sellingMethod === 'volume') {
                baseLabel = 'By Volume (ml)';
            }
            // Add price info if available
            if (pricePerTablet > 0) {
                baseLabel += ' - $' + pricePerTablet.toFixed(2) + ' each';
            }
            sellTypeSelect.append('<option value="' + baseUnit + '">' + baseLabel + '</option>');

            // Add subdivision if allowed (strips, boxes, bottles, etc.)
            if (allowsSubdivision && subdivisionUnit) {
                var subdivLabel = subdivisionUnit.charAt(0).toUpperCase() + subdivisionUnit.slice(1);
                
                // Add detailed info about what's in a strip/bottle
                if (tabletsPerStrip > 0) {
                    subdivLabel += ' (' + tabletsPerStrip + ' ' + baseUnit + 's)';
                }
                
                // Add price info if available
                if (pricePerStrip > 0) {
                    subdivLabel += ' - $' + pricePerStrip.toFixed(2);
                }
                
                sellTypeSelect.append('<option value="' + subdivisionUnit + '">' + subdivLabel + '</option>');
            }

            // Show boxes option if medicine has box pricing and packaging configured
            // Works for ANY medicine type (not just Tablet/Capsule)
            if (stripsPerBox > 0 && pricePerBox > 0) {
                var boxLabel = 'Boxes';
                
                // Add detailed info about box contents
                if (stripsPerBox > 0) {
                    boxLabel += ' (' + stripsPerBox + ' ' + (subdivisionUnit || med.unit_name || 'units') + 's';
                    
                    // Calculate total pieces per box
                    if (tabletsPerStrip > 0) {
                        var totalPiecesPerBox = stripsPerBox * tabletsPerStrip;
                        boxLabel += ' = ' + totalPiecesPerBox + ' ' + baseUnit + 's';
                    }
                    
                    boxLabel += ')';
                }
                
                // Add price info
                boxLabel += ' - $' + pricePerBox.toFixed(2);
                
                sellTypeSelect.append('<option value="boxes">' + boxLabel + '</option>');
            }
            
            // Add event listener to update price when sell type changes
            sellTypeSelect.on('change', function() {
                console.log('=== Sell Type Changed ===');
                console.log('New sell type:', $(this).val());
                console.log('Current medicine:', currentMedicine);
                updatePrice();
            });
            
            // Set initial price
            updatePrice();
        }

        // Store minimum prices for validation
        var currentMinPrice = 0;
        var originalUnitPrice = 0; // Store the original unit price as minimum
        var currentCostPrice = 0; // Store the current cost price for profit calculation

        function updatePrice() {
            console.log('=== updatePrice() called ===');
            
            if (!currentMedicine) {
                console.log('ERROR: No currentMedicine!');
                return;
            }
            
            console.log('currentMedicine:', currentMedicine);
            console.log('Prices:', {
                price_per_tablet: currentMedicine.price_per_tablet,
                price_per_strip: currentMedicine.price_per_strip,
                price_per_box: currentMedicine.price_per_box
            });

            var sellType = $('#sellType').val();
            var quantity = parseInt($('#quantity').val()) || 1;
            var unitPrice = 0;
            
            console.log('Sell Type:', sellType);
            console.log('Quantity:', quantity);

            // Determine price and cost based on sell type
            var costPrice = 0;
            if (sellType === 'boxes') {
                unitPrice = parseFloat(currentMedicine.price_per_box || 0);
                costPrice = parseFloat(currentMedicine.cost_per_box || 0);
                console.log('Using BOX price:', unitPrice, 'Cost:', costPrice);
            } else if (sellType === 'strip' || sellType === 'strips' || sellType === 'stripe') {
                unitPrice = parseFloat(currentMedicine.price_per_strip || 0);
                costPrice = parseFloat(currentMedicine.cost_per_strip || 0);
                console.log('Using STRIP price:', unitPrice, 'Cost:', costPrice);
            } else if (sellType === 'bottle' || sellType === 'vial' || sellType === 'tube' || sellType === 'inhaler' || sellType === 'sachet') {
                // For containers, use price_per_strip as container price
                unitPrice = parseFloat(currentMedicine.price_per_strip || currentMedicine.price_per_box || 0);
                costPrice = parseFloat(currentMedicine.cost_per_strip || currentMedicine.cost_per_box || 0);
                console.log('Using CONTAINER price:', unitPrice, 'Cost:', costPrice);
            } else {
                // Base unit (piece, ml, etc.)
                unitPrice = parseFloat(currentMedicine.price_per_tablet || 0);
                costPrice = parseFloat(currentMedicine.cost_per_tablet || 0);
                console.log('Using PIECE/TABLET price:', unitPrice, 'Cost:', costPrice);

                // If no tablet price but has strip price, calculate per-tablet
                if (unitPrice === 0 && parseFloat(currentMedicine.price_per_strip || 0) > 0) {
                    var tabletsPerStrip = parseFloat(currentMedicine.tablets_per_strip || currentMedicine.unit_size || 10);
                    unitPrice = parseFloat(currentMedicine.price_per_strip) / tabletsPerStrip;
                    costPrice = parseFloat(currentMedicine.cost_per_strip || 0) / tabletsPerStrip;
                    console.log('Calculated from strip - Price:', unitPrice, 'Cost:', costPrice);
                }
            }

            // Store COST PRICE as the minimum allowed price (not selling price)
            originalUnitPrice = costPrice;
            currentMinPrice = costPrice; // Use COST price as minimum to prevent loss
            currentCostPrice = costPrice; // Store for cart item

            var totalPrice = unitPrice * quantity;
            
            console.log('Final Unit Price:', unitPrice);
            console.log('Final Total Price:', totalPrice);

            // Update the UI
            $('#unitPrice').val(unitPrice.toFixed(2));
            $('#totalPrice').val(totalPrice.toFixed(2));
            
            console.log('UI Updated - Unit Price field:', $('#unitPrice').val());
            console.log('UI Updated - Total Price field:', $('#totalPrice').val());

            // Show minimum price information
            if (unitPrice > 0) {
                if (costPrice > 0) {
                    // Show cost price as minimum if available
                    $('#minPriceDisplay').html('<i class="fas fa-info-circle"></i> Minimum allowed: $' + costPrice.toFixed(2) + ' (cost price)');
                    $('#minPriceDisplay').removeClass('text-danger').addClass('text-info');
                } else {
                    // No cost price, just show selling price as minimum
                    $('#minPriceDisplay').html('<i class="fas fa-info-circle"></i> Price: $' + unitPrice.toFixed(2));
                    $('#minPriceDisplay').removeClass('text-danger').addClass('text-info');
                    // Use selling price as minimum if no cost price
                    currentMinPrice = unitPrice;
                }
            } else {
                $('#minPriceDisplay').html('<i class="fas fa-exclamation-triangle"></i> No unit price configured');
                $('#minPriceDisplay').removeClass('text-info').addClass('text-warning');
            }

            // Validate the current price
            validatePrice(unitPrice);
        }

        // Price validation function
        function validatePrice(price) {
            var $unitPriceInput = $('#unitPrice');
            var $priceHint = $('#priceHint');
            
            // Remove existing validation classes
            $unitPriceInput.removeClass('price-valid price-invalid price-warning');
            
            if (currentMinPrice > 0) {
                if (price >= currentMinPrice) {
                    // Price is valid (equal or above cost price)
                    $unitPriceInput.addClass('price-valid');
                    $priceHint.html('<span class="text-success"><i class="fas fa-check-circle"></i> Price is acceptable (above cost: $' + currentMinPrice.toFixed(2) + ')</span>');
                } else {
                    // Price is below original unit price
                    $unitPriceInput.addClass('price-invalid');
                    $priceHint.html('<span class="text-danger"><i class="fas fa-times-circle"></i> Cannot sell below unit price ($' + currentMinPrice.toFixed(2) + ')</span>');
                }
            } else {
                // No unit price set - show warning
                $unitPriceInput.addClass('price-warning');
                $priceHint.html('<span class="text-warning"><i class="fas fa-exclamation-circle"></i> No unit price configured for this item</span>');
            }
        }

        // New function to validate and update price when user changes unit price
        function validateAndUpdatePrice() {
            var unitPrice = parseFloat($('#unitPrice').val()) || 0;
            var quantity = parseInt($('#quantity').val()) || 1;
            
            // Validate the price
            validatePrice(unitPrice);
            
            // STRICT: Automatically correct below-minimum prices
            if (currentMinPrice > 0 && unitPrice < currentMinPrice) {
                // Show warning and auto-correct to minimum
                Swal.fire({
                    title: 'Price Too Low!',
                    html: `
                        <p>You entered: <strong>$${unitPrice.toFixed(2)}</strong></p>
                        <p>Cannot sell below unit price: <strong>$${currentMinPrice.toFixed(2)}</strong></p>
                        <p><strong>Price will be reset to unit price.</strong></p>
                    `,
                    icon: 'warning',
                    confirmButtonText: 'OK',
                    confirmButtonColor: '#28a745',
                    timer: 3000,
                    timerProgressBar: true
                });

                // Automatically set to minimum price
                $('#unitPrice').val(currentMinPrice.toFixed(2));
                validatePrice(currentMinPrice);
                updateTotal();
            } else {
                // Price is valid, update total
                updateTotal();
            }
        }

        // Helper function to update total price
        function updateTotal() {
            var unitPrice = parseFloat($('#unitPrice').val()) || 0;
            var quantity = parseInt($('#quantity').val()) || 1;
            var totalPrice = unitPrice * quantity;
            $('#totalPrice').val(totalPrice.toFixed(2));
        }

        // Legacy function for compatibility
        function updateTotalFromUnitPrice() {
            validateAndUpdatePrice();
        }

        // Clear medicine details function
        function clearMedicineDetails(hidePanel = true) {
            // Reset global variables
            currentMedicine = null;
            currentMinPrice = 0;
            originalUnitPrice = 0;
            
            // Clear all form fields
            $('#sellType').val('').empty().append('<option value="">Select sell type</option>');
            $('#quantity').val('1');
            $('#unitPrice').val('0.00');
            $('#totalPrice').val('0.00');
            
            // Clear validation styles and messages
            $('#unitPrice').removeClass('price-valid price-invalid price-warning');
            $('#priceHint').html('Select a medicine first');
            $('#minPriceDisplay').html('');
            
            // Clear visual selection from cards
            $('.medicine-card').removeClass('selected');
            
            // Clear hidden select
            $('#medicineSelect').empty().append('<option value="">-- Select Medicine --</option>');
            
            // Hide the details panel if requested
            if (hidePanel) {
                $('#medicineDetails').hide();
                
                // Show all hidden cards when fully clearing
                $('.medicine-card').show();
                
                // Reset search and show all medicines
                $('#searchMedicine').val(''); // Clear search input
                $('#searchResultInfo').html(''); // Clear search result messages
                __activeCategory = 'all'; // Reset to "All" category
                $('.category-tab').removeClass('active'); // Remove active class from all tabs
                $('.category-tab[data-category="all"]').addClass('active'); // Set "All" tab as active
                
                // Reload all medicines to default state
                loadMedicines();
                
                // Show helpful message
                Swal.fire({
                    title: 'Selection Cleared',
                    text: 'Showing all medicines. Select a medicine to continue.',
                    icon: 'info',
                    timer: 2000,
                    timerProgressBar: true,
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false
                });
            }
            
            console.log('Medicine details cleared and grid reset to default');
        }

        // Global barcode scanning setup
        function setupBarcodeScanning() {
            var barcodeBuffer = '';
            var barcodeTimeout;
            var isTypingInInput = false;

            // Track when user is typing in input fields
            $(document).on('focusin', 'input, textarea, select', function() {
                isTypingInInput = true;
            });

            $(document).on('focusout', 'input, textarea, select', function() {
                setTimeout(function() {
                    isTypingInInput = false;
                }, 100);
            });

            // Global keypress handler for barcode scanning
            $(document).on('keypress', function(e) {
                // Don't interfere if user is typing in input fields
                if (isTypingInInput) return;

                // Don't interfere with special keys or if modal is open
                if (e.which < 32 || $('.modal:visible').length > 0 || $('.swal2-container:visible').length > 0) {
                    return;
                }

                var char = String.fromCharCode(e.which);
                
                // Add character to buffer
                barcodeBuffer += char;
                
                // Clear any existing timeout
                if (barcodeTimeout) {
                    clearTimeout(barcodeTimeout);
                }
                
                // Set timeout to process buffer (barcode scanners type fast)
                barcodeTimeout = setTimeout(function() {
                    processBarcodeBuffer();
                }, 100); // 100ms timeout - adjust as needed for your scanner
            });

            // Handle Enter key for barcode completion
            $(document).on('keydown', function(e) {
                if (e.which === 13 && !isTypingInInput && barcodeBuffer.length > 0) { // Enter key
                    e.preventDefault();
                    if (barcodeTimeout) {
                        clearTimeout(barcodeTimeout);
                    }
                    processBarcodeBuffer();
                }
            });

            function processBarcodeBuffer() {
                var barcode = barcodeBuffer.trim();
                barcodeBuffer = ''; // Reset buffer
                
                if (barcode.length < 3) {
                    return; // Too short to be a valid barcode
                }
                
                // Set scanning flag to protect cart
                isScanning = true;
                console.log('Starting barcode scan process for:', barcode);
                
                // Check if it looks like a barcode (mostly numbers)
                var numericChars = barcode.replace(/[^0-9]/g, '').length;
                var isLikelyBarcode = numericChars / barcode.length > 0.7; // At least 70% numbers
                
                if (isLikelyBarcode || /^[0-9]+$/.test(barcode)) {
                    console.log('Barcode scanned globally:', barcode);
                    
                    // DON'T clear medicine details during scanning - this might affect cart
                    // Just focus and set the search input
                    $('#searchMedicine').focus();
                    $('#searchMedicine').val(barcode);
                    
                    // Perform the search
                    performSearch();
                    
                    // Show scanning indicator
                    Swal.fire({
                        title: 'Barcode Scanned',
                        text: 'Searching for: ' + barcode,
                        icon: 'info',
                        timer: 1500,
                        timerProgressBar: true,
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false
                    });
                    
                    // Clear scanning flag after a delay
                    setTimeout(function() {
                        isScanning = false;
                        console.log('Barcode scan process completed');
                    }, 3000);
                } else {
                    isScanning = false;
                }
            }
        }

        function addToCart() {
            if (!currentMedicine) {
                Swal.fire('Error', 'Please select a medicine first', 'error');
                return;
            }

            var sellType = $('#sellType').val();
            var quantity = parseInt($('#quantity').val()) || 0;
            var unitPrice = parseFloat($('#unitPrice').val()) || 0;
            var totalPrice = parseFloat($('#totalPrice').val()) || 0;

            if (quantity <= 0) {
                Swal.fire('Error', 'Please enter a valid quantity', 'error');
                return;
            }

            if (unitPrice <= 0) {
                Swal.fire('Error', 'Please enter a valid unit price', 'error');
                return;
            }

            // STRICT: Cannot add to cart if price is below minimum
            if (currentMinPrice > 0 && unitPrice < currentMinPrice) {
                Swal.fire({
                    title: 'Cannot Add to Cart!',
                    html: `
                        <p><strong>Cannot sell below unit price.</strong></p>
                        <p>Your price: <span class="text-danger">$${unitPrice.toFixed(2)}</span></p>
                        <p>Unit price: <span class="text-success">$${currentMinPrice.toFixed(2)}</span></p>
                        <p>You can only sell at or above the unit price.</p>
                    `,
                    icon: 'error',
                    confirmButtonText: 'Set to Unit Price',
                    confirmButtonColor: '#28a745',
                    showCancelButton: true,
                    cancelButtonText: 'Cancel'
                }).then((result) => {
                    if (result.isConfirmed) {
                        // Automatically set to unit price
                        $('#unitPrice').val(currentMinPrice.toFixed(2));
                        validateAndUpdatePrice();
                        // Focus back to unit price field for user to see the change
                        $('#unitPrice').focus();
                    }
                });
                return;
            }

            // Check stock availability
            var available = checkStockAvailability(currentMedicine, sellType, quantity);
            if (!available) {
                Swal.fire('Error', 'Insufficient stock for this quantity', 'error');
                return;
            }

            // Price is acceptable, proceed to add to cart
            proceedToAddToCart(sellType, quantity, unitPrice, totalPrice);
        }

        function proceedToAddToCart(sellType, quantity, unitPrice, totalPrice) {

            // Create cart item
            var item = {
                medicineid: parseInt(currentMedicine.medicineid),
                inventoryid: parseInt(currentMedicine.inventoryid),
                medicine_name: currentMedicine.medicine_name,
                quantity_type: sellType,
                quantity: quantity,
                unit_price: unitPrice,
                total_price: totalPrice,
                purchase_price: currentCostPrice // Use the calculated cost price based on sell type
            };

            console.log('=== Item added to cart ===');
            console.log('Sell Type:', sellType);
            console.log('Unit Price:', unitPrice);
            console.log('Cost Price (purchase_price):', currentCostPrice);
            console.log('Profit per unit:', (unitPrice - currentCostPrice).toFixed(2));

            cart.push(item);
            updateCart();

            // Reset form
            $('#medicineSelect').val('');
            $('#medicineDetails').hide();
            currentMedicine = null;
        }

        function checkStockAvailability(med, sellType, quantity) {
            var primaryQty = parseInt(med.primary_quantity || med.total_strips || 0);
            var secondaryQty = parseFloat(med.secondary_quantity || med.loose_tablets || 0);
            var unitSize = parseFloat(med.unit_size || med.tablets_per_strip || 10);

            if (sellType === 'boxes') {
                var stripsPerBox = parseInt(med.strips_per_box || 10);
                var requiredStrips = quantity * stripsPerBox;
                return primaryQty >= requiredStrips;
            } else if (sellType === 'strip' || sellType === 'strips' || sellType === 'bottle' || sellType === 'vial' || sellType === 'tube') {
                return primaryQty >= quantity;
            } else {
                // Base unit (pieces, ml, etc.)
                var totalAvailable = (primaryQty * unitSize) + secondaryQty;
                return totalAvailable >= quantity;
            }
        }

        // Enhanced search function - searches by name, barcode, generic, manufacturer
        function performSearch() {
            var searchTerm = $('#searchMedicine').val().trim();
            
            if (!searchTerm) {
                // If empty, load all medicines
                loadMedicines();
                $('#searchResultInfo').html('');
                return;
            }

            // Allow single character for barcodes (they might be short)
            var isLikelyBarcode = /^[0-9]+$/.test(searchTerm);
            if (!isLikelyBarcode && searchTerm.length < 2) {
                $('#searchResultInfo').html('<span class="text-warning"><i class="fas fa-exclamation-triangle"></i> Enter at least 2 characters</span>');
                return;
            }

            // Show what we're searching for
            if (isLikelyBarcode) {
                $('#searchResultInfo').html('<span class="text-info"><i class="fas fa-barcode"></i> Searching barcode: ' + searchTerm + '...</span>');
                console.log('Barcode search for:', searchTerm);
            } else {
                $('#searchResultInfo').html('<span class="text-info"><i class="fas fa-spinner fa-spin"></i> Searching medicines...</span>');
                console.log('Medicine name search for:', searchTerm);
            }

            $.ajax({
                url: 'pharmacy_pos.aspx/searchMedicines',
                type: 'POST',
                data: JSON.stringify({ searchTerm: searchTerm }),
                contentType: 'application/json',
                dataType: 'json',
                timeout: 10000, // 10 second timeout
                success: function (response) {
                    var medicines = response.d || [];
                    
                    // Render results as cards
                    renderMedicineGrid(medicines);
                    
                    if (medicines.length > 0) {
                        var resultText = 'Found ' + medicines.length + ' medicine(s)';
                        
                        // Log all barcodes found for debugging
                        console.log('Medicines found:', medicines.length);
                        medicines.forEach(function(med, index) {
                            console.log('Medicine ' + index + ':', med.medicine_name, 'Barcode:', med.barcode || 'None');
                        });
                        
                        // Check if this was a barcode search (exact or partial match)
                        var exactBarcodeMatch = medicines.find(function(med) {
                            return med.barcode && (
                                med.barcode === searchTerm || 
                                med.barcode.indexOf(searchTerm) !== -1 || 
                                searchTerm.indexOf(med.barcode) !== -1
                            );
                        });
                        
                        if (exactBarcodeMatch) {
                            resultText = '<i class="fas fa-barcode"></i> Barcode match: ' + exactBarcodeMatch.medicine_name + ' (Barcode: ' + exactBarcodeMatch.barcode + ')';
                            console.log('Barcode match found:', exactBarcodeMatch.medicine_name, 'with barcode:', exactBarcodeMatch.barcode);
                            // Auto-select barcode match - call selectMedicine directly instead of triggering click
                            setTimeout(function() {
                                console.log('Auto-selecting medicine ID:', exactBarcodeMatch.medicineid);
                                selectMedicine(exactBarcodeMatch.medicineid);
                            }, 100);
                        } else if (/^[0-9]+$/.test(searchTerm)) {
                            console.log('Barcode search but no match found for:', searchTerm);
                            resultText = 'No barcode match for: ' + searchTerm;
                        }
                        
                        $('#searchResultInfo').html('<span class="text-success"><i class="fas fa-check-circle"></i> ' + resultText + '</span>');
                        
                        // Populate hidden select as fallback
                        $('#medicineSelect').empty();
                        $('#medicineSelect').append('<option value="">-- ' + medicines.length + ' result(s) found --</option>');
                        for (var i = 0; i < medicines.length; i++) {
                            var med = medicines[i];
                            $('#medicineSelect').append('<option value="' + med.medicineid + '" data-inventory="' + med.inventoryid + '">' + med.medicine_name + '</option>');
                        }
                        
                        // If only one result and not barcode match, auto-select
                        if (medicines.length === 1 && !exactBarcodeMatch) {
                            setTimeout(function() {
                                $('.medicine-card[data-medicineid="' + medicines[0].medicineid + '"]').click();
                            }, 100);
                        }
                    } else {
                        $('#searchResultInfo').html('<span class="text-warning"><i class="fas fa-search"></i> No medicines found for "' + searchTerm + '"</span>');
                        $('#medicineGrid').html('<div class="text-muted p-3">No medicines found. Try a different search term.</div>');
                        $('#medicineSelect').empty().append('<option value="">-- No results found --</option>');
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Search error details:', {xhr: xhr, status: status, error: error});
                    var errorMsg = 'Search failed';
                    
                    if (status === 'timeout') {
                        errorMsg = 'Search timed out. Please try again.';
                    } else if (xhr.status === 500) {
                        errorMsg = 'Server error. Please check database connection.';
                    } else if (xhr.responseText) {
                        try {
                            var errorData = JSON.parse(xhr.responseText);
                            if (errorData.Message && errorData.Message.indexOf('barcode') !== -1) {
                                errorMsg = 'Database column missing. Please contact administrator.';
                            } else {
                                errorMsg = errorData.Message || errorData.ExceptionMessage || errorMsg;
                            }
                        } catch (e) {
                            errorMsg = 'Connection error. Please try again.';
                        }
                    }
                    
                    $('#searchResultInfo').html('<span class="text-danger"><i class="fas fa-exclamation-triangle"></i> ' + errorMsg + '</span>');
                    $('#medicineGrid').html('<div class="text-muted p-3">Search failed. Please try again or contact support.</div>');
                }
            });
        }

        // Legacy function - filter dropdown (old method)
        function searchMedicines() {
            var search = $('#searchMedicine').val().toLowerCase();
            if (search.length < 2 && search.length > 0) {
                return; // Don't filter with less than 2 chars
            }
            $('#medicineSelect option').each(function () {
                var text = $(this).text().toLowerCase();
                if (text.indexOf(search) > -1 || search === '') {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });
        }

        // Search on Enter key
        $('#searchMedicine').on('keypress', function(e) {
            if (e.which === 13) {  // Enter key
                e.preventDefault();
                performSearch();
            }
        });

        // Note: Duplicate barcode scanning system removed - using setupBarcodeScanning() only

        function updateCart() {
            $('#cartItems').empty();
            var subtotal = 0;

            for (var i = 0; i < cart.length; i++) {
                var item = cart[i];
                subtotal += item.total_price;

                var displayType = item.quantity_type;
                if (displayType === 'piece') displayType = 'pieces';
                else if (displayType === 'vial') displayType = 'vials';
                else if (displayType === 'tube') displayType = 'tubes';
                else if (displayType === 'bottle') displayType = 'bottles';

                $('#cartItems').append(
                    '<div class="cart-item">' +
                    '<div class="d-flex justify-content-between">' +
                    '<div>' +
                    '<strong>' + item.medicine_name + '</strong><br>' +
                    '<small>' + item.quantity + ' ' + displayType + ' @ ' + item.unit_price.toFixed(2) + '</small>' +
                    '</div>' +
                    '<div>' +
                    '<strong>' + item.total_price.toFixed(2) + '</strong><br>' +
                    '<button class="btn btn-sm btn-danger" onclick="removeFromCart(' + i + ')">Remove</button>' +
                    '</div>' +
                    '</div>' +
                    '</div>'
                );
            }

            $('#subtotal').text(subtotal.toFixed(2));
            calculateTotal();
        }

        function removeFromCart(index) {
            cart.splice(index, 1);
            updateCart();
        }

        function calculateTotal() {
            var subtotal = parseFloat($('#subtotal').text()) || 0;
            var discountAmount = 0;
            var finalTotal = subtotal;
            $('#finalTotal').text(finalTotal.toFixed(2));
        }

        var isScanning = false; // Flag to prevent accidental cart clearing during scanning

        function clearCart() {
            // Don't clear cart if we're in the middle of scanning
            if (isScanning) {
                console.log('Cart clear prevented - scanning in progress');
                return;
            }
            
            console.log('Clearing cart - previous cart size:', cart.length);
            cart = [];
            updateCart();
            console.log('Cart cleared successfully');
        }

        function processSale() {
            if (cart.length === 0) {
                Swal.fire('Error', 'Cart is empty', 'error');
                return;
            }

            var customerName = $('#customerName').val() || 'Walk-in Customer';
            var paymentMethod = $('#paymentMethod').val();
            var discount = 0;
            var finalTotal = parseFloat($('#finalTotal').text());

            var saleData = {
                customerName: customerName,
                paymentMethod: paymentMethod,
                discount: discount,
                finalAmount: finalTotal,
                items: cart
            };

            $.ajax({
                url: 'pharmacy_pos.aspx/processSale',
                data: JSON.stringify({ request: saleData }),
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    if (r.d && r.d.invoice_number) {
                                                    var adminSummary = '';
                                                    if (true) { // show for now; can restrict by role via server flag
                                                        adminSummary = `\nRevenue: $${(r.d.total_revenue||0).toFixed(2)}\nCost: $${(r.d.total_cost||0).toFixed(2)}\nProfit: $${(r.d.total_profit||0).toFixed(2)}`;
                                                    }
                        Swal.fire({
                            title: 'Sale Completed!',
                            text: 'Invoice: ' + r.d.invoice_number + adminSummary,
                            icon: 'success',
                            showCancelButton: true,
                            confirmButtonText: 'Print Invoice',
                            cancelButtonText: 'New Sale'
                        }).then((result) => {
                            if (result.isConfirmed) {
                                window.open('pharmacy_invoice.aspx?invoice=' + r.d.invoice_number, '_blank');
                            }
                            clearCart();
                            loadMedicines();
                            // Reload currently selected medicine to show updated stock
                            if ($('#medicineSelect').val()) {
                                loadMedicineDetails();
                            }
                        });
                    } else {
                        Swal.fire('Error', r.d.error || 'Sale failed', 'error');
                    }
                },
                error: function (xhr) {
                    Swal.fire('Error', 'Sale failed: ' + xhr.responseText, 'error');
                }
            });
        }
    </script>
</asp:Content>
