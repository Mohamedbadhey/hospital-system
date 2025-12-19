<%@ Page Title="Inpatient Billing" Language="C#" MasterPageFile="~/register.Master" AutoEventWireup="true" CodeBehind="register_inpatient.aspx.cs" Inherits="juba_hospital.register_inpatient" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .payment-card { border-left: 4px solid #28a745; margin-bottom: 20px; transition: all 0.3s ease; }
        .payment-card:hover { box-shadow: 0 4px 15px rgba(0,0,0,0.15); transform: translateY(-2px); }
        .patient-header { background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; padding: 15px; border-radius: 8px 8px 0 0; margin: -15px -15px 15px -15px; }
        .info-label { font-weight: 600; color: #495057; font-size: 13px; }
        .info-value { font-size: 16px; color: #212529; font-weight: 500; }
        .days-badge { background: #ff6b6b; color: white; padding: 8px 15px; border-radius: 25px; font-weight: bold; }
        .summary-card { border-radius: 10px; padding: 20px; margin-bottom: 15px; background: white; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .stat-box { text-align: center; padding: 15px; border-radius: 8px; background: #f8f9fa; }
        .stat-number { font-size: 28px; font-weight: bold; color: #28a745; }
        .stat-label { font-size: 12px; color: #6c757d; text-transform: uppercase; }
        .charge-unpaid { background: #fff3cd; border-left: 4px solid #ffc107; padding: 10px; margin: 5px 0; }
        .charge-paid { background: #d4edda; border-left: 4px solid #28a745; padding: 10px; margin: 5px 0; }
        .payment-btn { width: 100%; margin-top: 5px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="page-inner">
        <div class="page-header">
            <h4 class="page-title"><i class="fas fa-procedures"></i> Inpatient Billing & Payments</h4>
        </div>

        <div class="row mb-4">
            <div class="col-md-4"><div class="summary-card"><div class="stat-box"><div class="stat-number" id="totalInpatients">0</div><div class="stat-label">Active Inpatients</div></div></div></div>
            <div class="col-md-4"><div class="summary-card"><div class="stat-box"><div class="stat-number text-danger" id="totalUnpaid">$0</div><div class="stat-label">Total Unpaid</div></div></div></div>
            <div class="col-md-4"><div class="summary-card"><div class="stat-box"><div class="stat-number text-success" id="totalPaid">$0</div><div class="stat-label">Total Paid</div></div></div></div>
        </div>

        <div class="row" id="patientsContainer">
            <div class="col-md-12"><div class="card"><div class="card-body text-center py-5"><i class="fas fa-spinner fa-spin fa-3x text-primary"></i><p class="mt-3">Loading patients...</p></div></div></div>
        </div>
    </div>

    <div class="modal fade" id="paymentModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title"><i class="fas fa-credit-card"></i> Process Payment</h5>
                    <button type="button" class="close text-white" data-dismiss="modal"><span>&times;</span></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <h6><strong>Patient:</strong> <span id="paymentPatientName"></span> (ID: <span id="paymentPatientId"></span>)</h6>
                    </div>
                    <div id="chargesList"></div>
                    <hr>
                    <div class="row">
                        <div class="col-md-6">
                            <h5>Total Unpaid: <span class="text-danger" id="paymentTotalUnpaid">$0.00</span></h5>
                        </div>
                        <div class="col-md-6">
                            <h5>Total Paid: <span class="text-success" id="paymentTotalPaid">$0.00</span></h5>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" onclick="printInvoice()"><i class="fas fa-print"></i> Print Invoice</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="assets/sweetalert2.min.js"></script>
    <script>
        var currentPatient = null;

        $(document).ready(function() { loadPatients(); });

        function loadPatients() {
            $.ajax({
                url: 'register_inpatient.aspx/GetInpatientsForPayment',
                method: 'POST',
                contentType: 'application/json',
                success: function(response) { displayPatients(response.d); },
                error: function() { Swal.fire('Error', 'Failed to load patients', 'error'); }
            });
        }

        function displayPatients(data) {
            if (!data || data.length === 0) {
                $('#patientsContainer').html('<div class="col-md-12"><div class="card"><div class="card-body text-center py-5"><i class="fas fa-bed fa-3x text-muted mb-3"></i><h5 class="text-muted">No inpatients</h5></div></div></div>');
                updateStatistics([]);
                return;
            }
            var html = '';
            data.forEach(function(patient) {
                var hasUnpaid = parseFloat(patient.unpaid_charges) > 0;
                html += '<div class="col-md-6 col-lg-4"><div class="card payment-card"><div class="card-body">';
                html += '<div class="patient-header"><h5 class="mb-1">' + patient.full_name + '</h5><small>ID: ' + patient.patientid + '</small>';
                html += '<div class="float-right"><span class="days-badge">Day ' + patient.days_admitted + '</span></div></div>';
                html += '<div class="mt-3"><div class="mb-2"><strong>Doctor:</strong> ' + patient.doctortitle + ' ' + patient.doctor_name + '</div>';
                html += '<div class="mb-2"><strong>Phone:</strong> ' + patient.phone + '</div>';
                html += '<div class="mb-2"><strong>Admitted:</strong> ' + patient.bed_admission_date + '</div><hr>';
                html += '<div class="row text-center mb-3"><div class="col-6"><small>Total Charges</small><div class="font-weight-bold">$' + parseFloat(patient.total_charges).toFixed(2) + '</div></div>';
                html += '<div class="col-6"><small>Paid</small><div class="text-success font-weight-bold">$' + parseFloat(patient.paid_charges).toFixed(2) + '</div></div></div>';
                if (hasUnpaid) {
                    html += '<div class="alert alert-warning text-center"><strong>Balance Due: $' + parseFloat(patient.unpaid_charges).toFixed(2) + '</strong></div>';
                } else {
                    html += '<div class="alert alert-success text-center"><i class="fas fa-check-circle"></i> Fully Paid</div>';
                }
                html += '<button class="btn btn-success btn-block" onclick=\'openPaymentModal(' + JSON.stringify(patient) + ')\'><i class="fas fa-credit-card"></i> Process Payment</button>';
                html += '<button class="btn btn-info btn-block mt-2" onclick="printInvoiceForPatient(' + patient.patientid + ', ' + patient.prescid + ')"><i class="fas fa-print"></i> Print Invoice</button>';
                html += '</div></div></div></div>';
            });
            $('#patientsContainer').html(html);
            updateStatistics(data);
        }

        function updateStatistics(data) {
            var total = data.length;
            var unpaid = data.reduce((sum, p) => sum + parseFloat(p.unpaid_charges || 0), 0);
            var paid = data.reduce((sum, p) => sum + parseFloat(p.paid_charges || 0), 0);
            $('#totalInpatients').text(total);
            $('#totalUnpaid').text('$' + unpaid.toFixed(2));
            $('#totalPaid').text('$' + paid.toFixed(2));
        }

        function openPaymentModal(patient) {
            currentPatient = patient;
            $('#paymentPatientName').text(patient.full_name);
            $('#paymentPatientId').text(patient.patientid);
            loadChargesForPayment(patient.patientid);
            $('#paymentModal').modal('show');
        }

        function loadChargesForPayment(patientId) {
            $.ajax({
                url: 'register_inpatient.aspx/GetPatientCharges',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ patientId: patientId }),
                success: function(response) {
                    if (response.d && response.d.length > 0) {
                        var html = '';
                        var totalUnpaid = 0;
                        var totalPaid = 0;
                        response.d.forEach(function(charge) {
                            var amount = parseFloat(charge.amount);
                            var isPaid = charge.is_paid === '1' || charge.is_paid === 'True';
                            if (isPaid) totalPaid += amount; else totalUnpaid += amount;
                            var chargeClass = isPaid ? 'charge-paid' : 'charge-unpaid';
                            html += '<div class="' + chargeClass + '"><div class="row"><div class="col-md-8">';
                            html += '<strong>' + charge.charge_type + ':</strong> ' + charge.charge_name + '<br><small>' + charge.date_added + '</small></div>';
                            html += '<div class="col-md-4 text-right"><h5>$' + amount.toFixed(2) + '</h5>';
                            if (isPaid) {
                                html += '<span class="badge badge-success">PAID</span><br><small>' + (charge.payment_method || 'N/A') + '</small>';
                            } else {
                                html += '<select class="form-control form-control-sm mb-1" id="paymentMethod' + charge.charge_id + '">';
                                html += '<option value="Cash">Cash</option><option value="Card">Card</option><option value="Mobile Money">Mobile Money</option><option value="Insurance">Insurance</option></select>';
                                html += '<button class="btn btn-success btn-sm payment-btn" onclick="processPayment(' + charge.charge_id + ')">Pay Now</button>';
                            }
                            html += '</div></div></div>';
                        });
                        $('#chargesList').html(html);
                        $('#paymentTotalUnpaid').text('$' + totalUnpaid.toFixed(2));
                        $('#paymentTotalPaid').text('$' + totalPaid.toFixed(2));
                    }
                }
            });
        }

        function processPayment(chargeId) {
            var paymentMethod = $('#paymentMethod' + chargeId).val();
            $.ajax({
                url: 'register_inpatient.aspx/ProcessPayment',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ chargeId: chargeId.toString(), paymentMethod: paymentMethod }),
                success: function(response) {
                    if (response.d === 'success') {
                        Swal.fire('Success', 'Payment processed successfully', 'success');
                        loadChargesForPayment(currentPatient.patientid);
                        loadPatients();
                    } else {
                        Swal.fire('Error', response.d, 'error');
                    }
                }
            });
        }

        function printInvoice() {
            if (!currentPatient) return;
            window.open('patient_invoice_print.aspx?patientid=' + currentPatient.patientid, '_blank');
        }

        function printInvoiceForPatient(patientId, prescid) {
            window.open('patient_invoice_print.aspx?patientid=' + patientId, '_blank');
        }
    </script>
</asp:Content>
