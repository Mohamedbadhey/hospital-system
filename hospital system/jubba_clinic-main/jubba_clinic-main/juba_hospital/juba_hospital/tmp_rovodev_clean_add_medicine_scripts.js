// Clean JavaScript for add_medicine.aspx
// Check if jQuery is loaded
if (typeof jQuery === 'undefined') {
    console.error('ERROR: jQuery is not loaded! Make sure jQuery is included in your master page before this script.');
    alert('jQuery is not loaded. Please contact the administrator.');
} else {
    console.log('jQuery version:', jQuery.fn.jquery);

    jQuery(document).ready(function ($) {
        console.log('Initializing medicine management page...');

        // Initialize DataTable only if available
        if (typeof $.fn.DataTable !== 'undefined') {
            $('#datatable').DataTable({
                responsive: true,
                autoWidth: false,
                columnDefs: [
                    { responsivePriority: 1, targets: 0 }, // Medicine Name
                    { responsivePriority: 2, targets: -1 } // Operation
                ]
            });
            console.log('DataTable initialized');
            
            // Load units and data
            loadUnits();
            datadisplay();
        } else {
            console.log('DataTables not available yet, waiting for fallback...');
        }

        // Edit button click handler
        $(document).on('click', '.edit1-btn', function () {
            var id = $(this).data('id');
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
                        $("#unit1").val(medicine.unit_id);
                        $("#tablets_per_strip1").val(medicine.tablets_per_strip || "1");
                        $("#strips_per_box1").val(medicine.strips_per_box || "10");
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
        });

        // Add button click handler
        $('#add').click(function () {
            clearInputFields();
            var modal = new bootstrap.Modal(document.getElementById('medmodal'));
            modal.show();
        });
    });

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
            data: JSON.stringify({unitId: unitId}),
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
            },
            error: function (response) {
                console.error('Error loading unit details:', response.responseText);
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
                // Check if DataTable is available
                if (typeof $.fn.DataTable !== 'undefined' && $.fn.DataTable.isDataTable('#datatable')) {
                    var table = $('#datatable').DataTable();
                    table.clear();

                    for (var i = 0; i < response.d.length; i++) {
                        table.row.add([
                            response.d[i].medicine_name,
                            response.d[i].generic_name,
                            response.d[i].manufacturer,
                            response.d[i].unit_name,
                            response.d[i].price_per_strip,
                            "<button class='edit1-btn btn btn-success btn-sm' data-id='" + response.d[i].medicineid + "'>Edit</button>"
                        ]);
                    }
                    table.draw();
                    console.log('Data loaded:', response.d.length + ' records');
                } else {
                    console.error('DataTable not available for data display');
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
        if (!medname.trim()) {$('#mednameError').text("Please enter medicine name."); isValid = false;}
        if (!generic.trim()) {$('#genericError').text("Please enter generic name."); isValid = false;}
        if (!manufacturer.trim()) {$('#manufacturerError').text("Please enter manufacturer."); isValid = false;}
        if (!unitId.trim()) {$('#unitError').text("Please select a unit."); isValid = false;}

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
        var unitId = $("#unit1").val();
        var tabletsPerStrip = $("#tablets_per_strip1").val() || "1";
        var stripsPerBox = $("#strips_per_box1").val() || "10";
        var pricePerTablet = $("#price_per_tablet1").val() || "0";
        var pricePerStrip = $("#price_per_strip1").val() || "0";
        var pricePerBox = $("#price_per_box1").val() || "0";

        var isValid = true;
        if (!medname.trim()) {$('#mednameError1').text("Please enter medicine name."); isValid = false;}
        if (!generic.trim()) {$('#genericError1').text("Please enter generic name."); isValid = false;}
        if (!manufacturer.trim()) {$('#manufacturerError1').text("Please enter manufacturer."); isValid = false;}
        if (!unitId.trim()) {$('#unitError1').text("Please select a unit."); isValid = false;}

        if (!isValid) return;

        $.ajax({
            url: 'add_medicine.aspx/updateMedicine',
            data: JSON.stringify({id, medname, generic, manufacturer, unitId, tabletsPerStrip, stripsPerBox, pricePerTablet, pricePerStrip, pricePerBox}),
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
                        } else {
                            Swal.fire('Error', 'Failed to delete: ' + response.d, 'error');
                        }
                    },
                    error: function (response) {
                        alert('Error deleting medicine: ' + response.responseText);
                    }
                });
            }
        });
    }

    // Clear input fields
    function clearInputFields() {
        $("#medname, #generic, #manufacturer, #barcode, #unit").val('');
        $("#tablets_per_strip, #strips_per_box").val('1');
        $("#cost_per_tablet, #cost_per_strip, #cost_per_box, #price_per_tablet, #price_per_strip, #price_per_box").val('0');
        $('.strip-box-config, .complex-unit-fields').hide();
        $('#profit_summary').hide();
        $('.badge').hide();
        $('#mednameError, #genericError, #manufacturerError, #unitError, #barcodeError').text('');
    }

    // Barcode scanning support
    $(document).ready(function() {
        var barcodeInput = $('#barcode');
        var scanTimeout;
        
        barcodeInput.on('keypress', function(e) {
            if (e.which === 13) { // Enter key
                clearTimeout(scanTimeout);
                console.log('Barcode scanned:', $(this).val());
                // Auto-focus next field or perform validation
                $('#unit').focus();
            } else {
                // Reset timeout on each keystroke (distinguishes scanning from typing)
                clearTimeout(scanTimeout);
                scanTimeout = setTimeout(function() {
                    console.log('Manual entry detected');
                }, 100);
            }
        });
    });
}

// Make functions globally available
window.submitInfo = submitInfo;
window.update = update;
window.deletejob = deletejob;
window.calculateProfitMargins = calculateProfitMargins;
window.loadUnits = loadUnits;
window.datadisplay = datadisplay;
window.updatePricingLabels = updatePricingLabels;
window.clearInputFields = clearInputFields;