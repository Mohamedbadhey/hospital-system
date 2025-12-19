<%@ Page Title="" Language="C#" MasterPageFile="~/pharmacy.Master" AutoEventWireup="true" CodeBehind="dispense_medication.aspx.cs" Inherits="juba_hospital.dispense_medication" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <style>
        .dataTables_wrapper .dataTables_filter { float: right; }
        #datatable { width: 100%; margin: 20px 0; font-size: 14px; }
        #datatable th { background-color: #007bff; color: white; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="modal fade" id="dispensemodal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Dispense Medication</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <input type="hidden" id="medid" />
            <div class="mb-3">
                <label>Patient: <span id="patientname"></span></label>
            </div>
            <div class="mb-3">
                <label>Medicine: <span id="medicinename"></span></label>
            </div>
            <div class="mb-3">
                <label class="form-label">Select Medicine from Inventory</label>
                <select class="form-control" id="medicineid"></select>
            </div>
            <div class="mb-3">
                <label class="form-label">Quantity to Dispense</label>
                <input type="number" class="form-control" id="quantity" />
                <small>Available: <span id="availableqty"></span></small>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="button" onclick="dispense()" class="btn btn-primary">Dispense</button>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title">Pending Medications to Dispense</h4>
                </div>
                <div class="card-body">
                    <table class="display nowrap" style="width:100%" id="datatable">
                        <thead>
                            <tr>
                                <th>Patient Name</th>
                                <th>Medicine</th>
                                <th>Dosage</th>
                                <th>Frequency</th>
                                <th>Duration</th>
                                <th>Date Prescribed</th>
                                <th>Operation</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="assets/js/core/jquery-3.7.1.min.js"></script>
    <script src="datatables/datatables.min.js"></script>
    <script>
        $(document).ready(function () {
            $('#datatable').DataTable();
            loadPending();
        });

        function loadPending() {
            $.ajax({
                url: 'dispense_medication.aspx/getPendingMedications',
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    $('#datatable tbody').empty();
                    for (var i = 0; i < r.d.length; i++) {
                        $('#datatable tbody').append(
                            '<tr><td>' + r.d[i].patient_name + '</td>' +
                            '<td>' + r.d[i].med_name + '</td>' +
                            '<td>' + r.d[i].dosage + '</td>' +
                            '<td>' + r.d[i].frequency + '</td>' +
                            '<td>' + r.d[i].duration + '</td>' +
                            '<td>' + r.d[i].date_taken + '</td>' +
                            '<td><button class="btn btn-success" onclick="openDispense(' + r.d[i].medid + ', \'' + r.d[i].patient_name + '\', \'' + r.d[i].med_name + '\')">Dispense</button></td></tr>');
                    }
                }
            });
        }

        function openDispense(medid, patientname, medicinename) {
            $('#medid').val(medid);
            $('#patientname').text(patientname);
            $('#medicinename').text(medicinename);
            loadMedicines();
            $('#dispensemodal').modal('show');
        }

        function loadMedicines() {
            $.ajax({
                url: 'dispense_medication.aspx/getAvailableMedicines',
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    $('#medicineid').empty();
                    $('#medicineid').append('<option value="">Select Medicine</option>');
                    for (var i = 0; i < r.d.length; i++) {
                        $('#medicineid').append('<option value="' + r.d[i].inventoryid + '" data-qty="' + r.d[i].quantity + '">' + r.d[i].medicine_name + ' (Qty: ' + r.d[i].quantity + ')</option>');
                    }
                }
            });
        }

        $('#medicineid').change(function() {
            var qty = $(this).find(':selected').data('qty');
            $('#availableqty').text(qty || 0);
        });

        function dispense() {
            var medid = $('#medid').val();
            var inventoryid = $('#medicineid').val();
            var quantity = $('#quantity').val();
            var available = parseInt($('#availableqty').text());
            
            if (!inventoryid) {
                Swal.fire('Error', 'Please select a medicine', 'error');
                return;
            }
            if (!quantity || parseInt(quantity) <= 0) {
                Swal.fire('Error', 'Please enter valid quantity', 'error');
                return;
            }
            if (parseInt(quantity) > available) {
                Swal.fire('Error', 'Insufficient stock available', 'error');
                return;
            }

            $.ajax({
                url: 'dispense_medication.aspx/dispense',
                data: JSON.stringify({ medid: medid, inventoryid: inventoryid, quantity: quantity }),
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    if (r.d === 'true') {
                        Swal.fire('Success!', 'Medication dispensed successfully!', 'success');
                        $('#dispensemodal').modal('hide');
                        loadPending();
                    } else {
                        Swal.fire('Error', r.d, 'error');
                    }
                }
            });
        }
    </script>
</asp:Content>

