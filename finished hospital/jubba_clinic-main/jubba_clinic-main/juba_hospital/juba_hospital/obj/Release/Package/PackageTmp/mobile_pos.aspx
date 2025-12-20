<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="mobile_pos.aspx.cs" Inherits="juba_hospital.mobile_pos" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xmln">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="mobile-web-app-capable" content="yes">
    <title>Mobile POS - Juba Hospital</title>
    
    <!-- Bootstrap 5 for better mobile support -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- QuaggaJS for barcode scanning -->
    <script src="https://cdn.jsdelivr.net/npm/@ericblade/quagga2@1.7.2/dist/quagga.min.js"></script>
    
    <style>
        body {
            background: #f5f5f5;
            padding-bottom: 80px;
        }
        
        .mobile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px;
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .search-section {
            background: white;
            padding: 15px;
            margin: 10px;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .scan-button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50px;
            padding: 15px 30px;
            color: white;
            font-size: 18px;
            font-weight: bold;
            width: 100%;
            margin: 10px 0;
        }
        
        .medicine-card {
            background: white;
            border-radius: 10px;
            padding: 15px;
            margin: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .cart-item {
            background: white;
            border-radius: 10px;
            padding: 10px;
            margin: 5px 0;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .cart-footer {
            position: fixed;
            bottom: 0;
            left: 0;
            right: 0;
            background: white;
            padding: 15px;
            box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
        }
        
        .btn-checkout {
            background: #28a745;
            border: none;
            border-radius: 50px;
            padding: 15px;
            color: white;
            font-size: 18px;
            font-weight: bold;
            width: 100%;
        }
        
        #scanner-container {
            position: relative;
            width: 100%;
            max-width: 500px;
            margin: 0 auto;
        }
        
        #scanner-video {
            width: 100%;
            border-radius: 10px;
        }
        
        .scanner-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 80%;
            height: 40%;
            border: 2px solid #00ff00;
            border-radius: 10px;
            box-shadow: 0 0 0 9999px rgba(0, 0, 0, 0.5);
        }
        
        .badge-stock {
            font-size: 12px;
            padding: 5px 10px;
        }
        
        .quantity-control {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .quantity-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid #667eea;
            background: white;
            color: #667eea;
            font-size: 20px;
            font-weight: bold;
        }
        
        .quantity-display {
            font-size: 24px;
            font-weight: bold;
            min-width: 50px;
            text-align: center;
        }
        
        .medicine-image {
            width: 60px;
            height: 60px;
            border-radius: 10px;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <!-- Header -->
        <div class="mobile-header">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h5 class="mb-0"><i class="fas fa-mobile-alt"></i> Mobile POS</h5>
                    <small id="userInfo">Pharmacy Staff</small>
                </div>
                <div>
                    <span class="badge bg-light text-dark" id="cartCount">0 items</span>
                </div>
            </div>
        </div>

        <!-- Search Section -->
        <div class="search-section">
            <div class="input-group mb-2">
                <span class="input-group-text"><i class="fas fa-search"></i></span>
                <input type="text" class="form-control" id="mobileSearch" 
                       placeholder="Search medicine name or barcode...">
                <button class="btn btn-primary" type="button" onclick="searchMedicine()">
                    Search
                </button>
            </div>
            
            <button class="scan-button" onclick="startScanner()">
                <i class="fas fa-camera"></i> Scan Barcode with Camera
            </button>
            
            <div id="scanResult" class="mt-2"></div>
        </div>

        <!-- Scanner Container (Hidden initially) -->
        <div id="scanner-container" class="d-none">
            <div class="text-center mb-2">
                <h6>Point camera at barcode</h6>
                <button class="btn btn-danger btn-sm" onclick="stopScanner()">
                    <i class="fas fa-times"></i> Cancel
                </button>
            </div>
            <div style="position: relative;">
                <div id="scanner-video"></div>
                <div class="scanner-overlay"></div>
            </div>
        </div>

        <!-- Medicine Details (Hidden initially) -->
        <div id="medicineDetails" class="medicine-card d-none">
            <div class="row">
                <div class="col-3">
                    <div class="medicine-image">
                        <i class="fas fa-pills text-primary"></i>
                    </div>
                </div>
                <div class="col-9">
                    <h6 class="mb-1" id="medName">Medicine Name</h6>
                    <small class="text-muted" id="medGeneric">Generic Name</small><br>
                    <span class="badge badge-stock bg-info" id="medStock">Stock: 0</span>
                    <span class="badge bg-success" id="medUnit">Unit</span>
                </div>
            </div>
            
            <hr>
            
            <div class="mb-3">
                <label class="form-label">Select Type</label>
                <select class="form-select" id="quantityType">
                    <option value="">Select...</option>
                </select>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Quantity</label>
                <div class="quantity-control">
                    <button type="button" class="quantity-btn" onclick="decreaseQty()">-</button>
                    <span class="quantity-display" id="qtyDisplay">1</span>
                    <button type="button" class="quantity-btn" onclick="increaseQty()">+</button>
                </div>
            </div>
            
            <div class="mb-3">
                <h5 class="text-center">
                    Total: $<span id="itemTotal">0.00</span>
                </h5>
            </div>
            
            <button class="btn btn-primary w-100 btn-lg" onclick="addToCart()">
                <i class="fas fa-cart-plus"></i> Add to Cart
            </button>
        </div>

        <!-- Cart Items -->
        <div id="cartSection" class="mt-3 px-3 d-none">
            <h6><i class="fas fa-shopping-cart"></i> Cart Items</h6>
            <div id="cartItems"></div>
        </div>

        <!-- Cart Footer -->
        <div class="cart-footer d-none" id="cartFooter">
            <div class="d-flex justify-content-between mb-2">
                <h5>Total:</h5>
                <h5 class="text-primary">$<span id="cartTotal">0.00</span></h5>
            </div>
            <button class="btn-checkout" onclick="checkout()">
                <i class="fas fa-check-circle"></i> Checkout ($<span id="checkoutTotal">0.00</span>)
            </button>
        </div>
    </form>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
        var currentMedicine = null;
        var cart = [];
        var quantity = 1;
        var isScanning = false;

        $(document).ready(function() {
            // Get user info from session
            getUserInfo();
            
            // Enter key search
            $('#mobileSearch').on('keypress', function(e) {
                if (e.which === 13) {
                    searchMedicine();
                }
            });
        });

        function getUserInfo() {
            // Get logged in user info
            var username = '<%= Session["pharmacy_username"] %>';
            if (username && username !== '') {
                $('#userInfo').text(username);
            }
        }

        function searchMedicine() {
            var searchTerm = $('#mobileSearch').val().trim();
            
            if (!searchTerm) {
                Swal.fire('Search Required', 'Please enter medicine name or barcode', 'info');
                return;
            }

            $('#scanResult').html('<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Searching...</div>');

            $.ajax({
                url: 'pharmacy_pos.aspx/searchMedicines',
                type: 'POST',
                data: JSON.stringify({ searchTerm: searchTerm }),
                contentType: 'application/json',
                dataType: 'json',
                success: function(response) {
                    if (response.d && response.d.length > 0) {
                        if (response.d.length === 1) {
                            // Single result - show directly
                            displayMedicine(response.d[0]);
                            $('#scanResult').html('<div class="alert alert-success">Medicine found!</div>');
                        } else {
                            // Multiple results - let user choose
                            showMedicineList(response.d);
                        }
                    } else {
                        $('#scanResult').html('<div class="alert alert-danger">No medicine found</div>');
                        Swal.fire('Not Found', 'No medicine found for: ' + searchTerm, 'warning');
                    }
                },
                error: function() {
                    $('#scanResult').html('<div class="alert alert-danger">Search failed</div>');
                    Swal.fire('Error', 'Failed to search. Please run ADD_BARCODE_COLUMN.sql script.', 'error');
                }
            });
        }

        function showMedicineList(medicines) {
            var html = '<div class="list-group mt-2">';
            medicines.forEach(function(med) {
                html += '<a href="#" class="list-group-item list-group-item-action" onclick="selectFromList(\'' + 
                        med.medicineid + '\', event)">' +
                        '<strong>' + med.medicine_name + '</strong><br>' +
                        '<small>' + med.generic_name + '</small> ' +
                        (med.barcode ? '<span class="badge bg-secondary">' + med.barcode + '</span>' : '') +
                        '</a>';
            });
            html += '</div>';
            $('#scanResult').html(html);
        }

        function selectFromList(medicineId, event) {
            event.preventDefault();
            
            $.ajax({
                url: 'pharmacy_pos.aspx/getMedicineDetails',
                type: 'POST',
                data: JSON.stringify({ medicineid: medicineId }),
                contentType: 'application/json',
                dataType: 'json',
                success: function(response) {
                    if (response.d && response.d.length > 0) {
                        displayMedicine(response.d[0]);
                        $('#scanResult').html('');
                    }
                }
            });
        }

        function displayMedicine(medicine) {
            currentMedicine = medicine;
            quantity = 1;
            
            $('#medName').text(medicine.medicine_name);
            $('#medGeneric').text(medicine.generic_name || 'No generic name');
            
            var stock = medicine.primary_quantity || medicine.total_strips || '0';
            var stockUnit = medicine.subdivision_unit || 'units';
            $('#medStock').text('Stock: ' + stock + ' ' + stockUnit);
            $('#medUnit').text(medicine.unit_name || 'Unit');
            
            // Populate quantity types
            var qtyType = $('#quantityType');
            qtyType.empty();
            
            // Add base unit
            qtyType.append('<option value="' + (medicine.base_unit_name || 'piece') + '">' + 
                          (medicine.base_unit_name || 'piece').toUpperCase() + ' - $' + 
                          (medicine.price_per_tablet || '0') + '</option>');
            
            // Add subdivision if available
            if (medicine.allows_subdivision === 'True' && medicine.subdivision_unit) {
                qtyType.append('<option value="' + medicine.subdivision_unit + '">' + 
                              medicine.subdivision_unit.toUpperCase() + ' - $' + 
                              (medicine.price_per_strip || '0') + '</option>');
            }
            
            // Add boxes if configured
            if (medicine.strips_per_box && parseInt(medicine.strips_per_box) > 0 && medicine.price_per_box) {
                qtyType.append('<option value="boxes">BOXES - $' + medicine.price_per_box + '</option>');
            }
            
            qtyType.val(medicine.subdivision_unit || medicine.base_unit_name || 'piece');
            
            $('#qtyDisplay').text('1');
            updateItemTotal();
            
            $('#medicineDetails').removeClass('d-none');
            
            // Scroll to medicine details
            $('html, body').animate({
                scrollTop: $('#medicineDetails').offset().top - 70
            }, 500);
        }

        function increaseQty() {
            quantity++;
            $('#qtyDisplay').text(quantity);
            updateItemTotal();
        }

        function decreaseQty() {
            if (quantity > 1) {
                quantity--;
                $('#qtyDisplay').text(quantity);
                updateItemTotal();
            }
        }

        function updateItemTotal() {
            if (!currentMedicine) return;
            
            var qtyType = $('#quantityType').val();
            var price = 0;
            
            if (qtyType === 'boxes') {
                price = parseFloat(currentMedicine.price_per_box || 0);
            } else if (qtyType === (currentMedicine.subdivision_unit || '')) {
                price = parseFloat(currentMedicine.price_per_strip || 0);
            } else {
                price = parseFloat(currentMedicine.price_per_tablet || 0);
            }
            
            var total = price * quantity;
            $('#itemTotal').text(total.toFixed(2));
        }

        $('#quantityType').on('change', updateItemTotal);

        function addToCart() {
            if (!currentMedicine) return;
            
            var qtyType = $('#quantityType').val();
            var price = parseFloat($('#itemTotal').text());
            
            var item = {
                medicineid: currentMedicine.medicineid,
                inventoryid: currentMedicine.inventoryid,
                medicine_name: currentMedicine.medicine_name,
                quantity_type: qtyType,
                quantity: quantity,
                unit_price: price / quantity,
                total_price: price
            };
            
            cart.push(item);
            updateCart();
            
            // Reset
            $('#medicineDetails').addClass('d-none');
            $('#mobileSearch').val('');
            currentMedicine = null;
            
            Swal.fire({
                icon: 'success',
                title: 'Added to Cart!',
                text: item.medicine_name,
                timer: 1500,
                showConfirmButton: false
            });
        }

        function updateCart() {
            if (cart.length === 0) {
                $('#cartSection').addClass('d-none');
                $('#cartFooter').addClass('d-none');
                $('#cartCount').text('0 items');
                return;
            }
            
            $('#cartSection').removeClass('d-none');
            $('#cartFooter').removeClass('d-none');
            $('#cartCount').text(cart.length + ' items');
            
            var cartHtml = '';
            var total = 0;
            
            cart.forEach(function(item, index) {
                total += item.total_price;
                cartHtml += '<div class="cart-item">' +
                           '<div class="d-flex justify-content-between">' +
                           '<div>' +
                           '<strong>' + item.medicine_name + '</strong><br>' +
                           '<small>' + item.quantity + ' ' + item.quantity_type + ' × $' + item.unit_price.toFixed(2) + '</small>' +
                           '</div>' +
                           '<div class="text-end">' +
                           '<h6 class="text-primary mb-1">$' + item.total_price.toFixed(2) + '</h6>' +
                           '<button class="btn btn-sm btn-danger" onclick="removeFromCart(' + index + ')">' +
                           '<i class="fas fa-trash"></i></button>' +
                           '</div>' +
                           '</div>' +
                           '</div>';
            });
            
            $('#cartItems').html(cartHtml);
            $('#cartTotal').text(total.toFixed(2));
            $('#checkoutTotal').text(total.toFixed(2));
        }

        function removeFromCart(index) {
            cart.splice(index, 1);
            updateCart();
        }

        function checkout() {
            if (cart.length === 0) {
                Swal.fire('Empty Cart', 'Please add items to cart first', 'warning');
                return;
            }
            
            Swal.fire({
                title: 'Process Sale?',
                text: 'Total: $' + $('#cartTotal').text(),
                icon: 'question',
                showCancelButton: true,
                confirmButtonText: 'Yes, Process Sale',
                cancelButtonText: 'Cancel'
            }).then((result) => {
                if (result.isConfirmed) {
                    processSale();
                }
            });
        }

        function processSale() {
            var saleData = {
                customerName: 'Walk-in Customer',
                paymentMethod: 'Cash',
                items: cart
            };
            
            Swal.fire({
                title: 'Processing...',
                text: 'Please wait',
                allowOutsideClick: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            $.ajax({
                url: 'pharmacy_pos.aspx/processSale',
                type: 'POST',
                data: JSON.stringify(saleData),
                contentType: 'application/json',
                dataType: 'json',
                success: function(response) {
                    if (response.d === 'true' || response.d === 'success') {
                        Swal.fire({
                            icon: 'success',
                            title: 'Sale Complete!',
                            text: 'Total: $' + $('#cartTotal').text(),
                            confirmButtonText: 'New Sale'
                        }).then(() => {
                            cart = [];
                            updateCart();
                        });
                    } else {
                        Swal.fire('Error', response.d || 'Failed to process sale', 'error');
                    }
                },
                error: function() {
                    Swal.fire('Error', 'Failed to process sale', 'error');
                }
            });
        }

        // Barcode Scanner Functions
        function startScanner() {
            if (isScanning) return;
            
            $('#scanner-container').removeClass('d-none');
            isScanning = true;
            
            Quagga.init({
                inputStream: {
                    name: "Live",
                    type: "LiveStream",
                    target: document.querySelector('#scanner-video'),
                    constraints: {
                        facingMode: "environment" // Use back camera
                    }
                },
                decoder: {
                    readers: ["ean_reader", "ean_8_reader", "code_128_reader", "upc_reader"]
                }
            }, function(err) {
                if (err) {
                    console.error(err);
                    Swal.fire('Camera Error', 'Could not access camera', 'error');
                    stopScanner();
                    return;
                }
                Quagga.start();
            });
            
            Quagga.onDetected(function(data) {
                var barcode = data.codeResult.code;
                console.log("Barcode detected:", barcode);
                
                stopScanner();
                $('#mobileSearch').val(barcode);
                searchMedicine();
            });
        }

        function stopScanner() {
            if (isScanning) {
                Quagga.stop();
                isScanning = false;
            }
            $('#scanner-container').addClass('d-none');
        }
    </script>
</body>
</html>