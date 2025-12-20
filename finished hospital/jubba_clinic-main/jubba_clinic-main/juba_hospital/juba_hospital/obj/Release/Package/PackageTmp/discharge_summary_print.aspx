<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="discharge_summary_print.aspx.cs" Inherits="juba_hospital.discharge_summary_print" %>

<!DOCTYPE html>
<html>
<head>
    <title>Discharge Summary</title>
    <link rel="stylesheet" href="Content/print-header.css">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { text-align: center; border-bottom: 3px solid #007bff; padding-bottom: 15px; margin-bottom: 30px; }
        .header h1 { color: #007bff; margin: 0; font-size: 28px; }
        .header p { margin: 5px 0; color: #666; }
        .section { margin: 20px 0; }
        .section-title { background: #007bff; color: white; padding: 10px; font-size: 16px; font-weight: bold; margin-bottom: 10px; }
        .info-grid { display: table; width: 100%; border-collapse: collapse; }
        .info-row { display: table-row; }
        .info-label { display: table-cell; font-weight: bold; padding: 8px; width: 30%; border: 1px solid #ddd; background: #f8f9fa; }
        .info-value { display: table-cell; padding: 8px; border: 1px solid #ddd; }
        .table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        .table th { background: #f8f9fa; padding: 10px; text-align: left; border: 1px solid #ddd; font-weight: bold; }
        .table td { padding: 8px; border: 1px solid #ddd; }
        .signature-section { margin-top: 50px; display: flex; justify-content: space-between; }
        .signature-box { width: 45%; border-top: 2px solid #333; padding-top: 10px; text-align: center; }
        .footer { text-align: center; margin-top: 40px; font-size: 12px; color: #666; border-top: 1px solid #ddd; padding-top: 10px; }
        @media print {
            .no-print { display: none; }
            body { margin: 0; }
        }
    </style>
</head>
<body>
    <div class="no-print" style="text-align: right; margin-bottom: 20px;">
        <button onclick="window.print()" style="padding: 10px 20px; background: #007bff; color: white; border: none; cursor: pointer; border-radius: 5px;">
            <i class="fas fa-print"></i> Print Summary
        </button>
        <button onclick="window.close()" style="padding: 10px 20px; background: #6c757d; color: white; border: none; cursor: pointer; border-radius: 5px; margin-left: 10px;">
            Close
        </button>
    </div>

    <form id="form1" runat="server">
        <asp:Literal ID="PrintHeaderLiteral" runat="server"></asp:Literal>
    </form>

    <div class="header" id="hospitalHeader" style="display:none;"></div>

    <div class="section">
        <div class="section-title">PATIENT INFORMATION</div>
        <div class="info-grid">
            <div class="info-row">
                <div class="info-label">Patient Name:</div>
                <div class="info-value" id="patientName"></div>
                <div class="info-label">Patient ID:</div>
                <div class="info-value" id="patientId"></div>
            </div>
            <div class="info-row">
                <div class="info-label">Date of Birth:</div>
                <div class="info-value" id="dob"></div>
                <div class="info-label">Sex:</div>
                <div class="info-value" id="sex"></div>
            </div>
            <div class="info-row">
                <div class="info-label">Phone:</div>
                <div class="info-value" id="phone"></div>
                <div class="info-label">Address:</div>
                <div class="info-value" id="location"></div>
            </div>
        </div>
    </div>

    <div class="section">
        <div class="section-title">ADMISSION & DISCHARGE DETAILS</div>
        <div class="info-grid">
            <div class="info-row">
                <div class="info-label">Admission Date:</div>
                <div class="info-value" id="admissionDate"></div>
                <div class="info-label">Discharge Date:</div>
                <div class="info-value" id="dischargeDate"></div>
            </div>
            <div class="info-row">
                <div class="info-label">Length of Stay:</div>
                <div class="info-value" id="lengthOfStay"></div>
                <div class="info-label">Attending Doctor:</div>
                <div class="info-value" id="doctorName"></div>
            </div>
        </div>
    </div>

    <div class="section">
        <div class="section-title">MEDICATIONS PRESCRIBED</div>
        <table class="table" id="medicationsTable">
            <thead>
                <tr>
                    <th>Medication</th>
                    <th>Dosage</th>
                    <th>Frequency</th>
                    <th>Duration</th>
                    <th>Special Instructions</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <div class="section">
        <div class="section-title">LABORATORY TESTS - ALL ORDERS</div>
        <div id="labTestsContainer" style="margin-top:15px;">
            <div style="text-align:center; padding:20px; color:#999;">Loading lab tests...</div>
        </div>
    </div>

    <div class="section">
        <div class="section-title">FINANCIAL SUMMARY</div>
        <table class="table" id="chargesTable">
            <thead>
                <tr>
                    <th>Charge Type</th>
                    <th>Description</th>
                    <th>Amount</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody></tbody>
            <tfoot>
                <tr style="font-weight: bold; background: #f8f9fa;">
                    <td colspan="2" style="text-align: right;">Total Charges:</td>
                    <td id="totalCharges">$0.00</td>
                    <td id="paymentStatus"></td>
                </tr>
            </tfoot>
        </table>
    </div>

    <div class="section">
        <div class="section-title">DISCHARGE INSTRUCTIONS</div>
        <div id="dischargeInstructions" style="padding: 15px; border: 1px solid #ddd; min-height: 100px; background: #f8f9fa;">
            <p>• Follow prescribed medications as instructed</p>
            <p>• Return for follow-up appointment as scheduled</p>
            <p>• Contact hospital immediately if symptoms worsen</p>
            <p>• Maintain proper rest and nutrition</p>
        </div>
    </div>

    <div class="signature-section">
        <div class="signature-box">
            <strong>Doctor's Signature</strong><br>
            <span id="doctorNameSig"></span><br>
            <span id="printDate"></span>
        </div>
        <div class="signature-box">
            <strong>Patient/Guardian Signature</strong><br>
            <span style="height: 40px; display: block;"></span>
        </div>
    </div>

    <div class="footer">
        This is a computer-generated discharge summary. Please keep for your records.
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            const urlParams = new URLSearchParams(window.location.search);
            const patientId = urlParams.get('patientId');
            const prescid = urlParams.get('prescid');

            if (!patientId || !prescid) {
                alert('Invalid parameters');
                window.close();
                return;
            }

            loadDischargeSummary(patientId, prescid);
        });

        function loadDischargeSummary(patientId, prescid) {
            // Load patient data
            $.ajax({
                url: 'discharge_summary_print.aspx/GetDischargeSummary',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({ patientId: patientId, prescid: prescid }),
                success: function(response) {
                    if (response.d) {
                        populateSummary(response.d);
                    }
                },
                error: function() {
                    alert('Error loading discharge summary');
                }
            });
        }

        function populateSummary(data) {
            // Load hospital header with logo
            loadHospitalHeader();
            
            // Patient info
            $('#patientName').text(data.patientName);
            $('#patientId').text(data.patientId);
            $('#dob').text(data.dob);
            $('#sex').text(data.sex);
            $('#phone').text(data.phone);
            $('#location').text(data.location);
            
            // Admission details
            $('#admissionDate').text(data.admissionDate);
            $('#dischargeDate').text(data.dischargeDate);
            $('#lengthOfStay').text(data.lengthOfStay + ' days');
            $('#doctorName').text(data.doctorName);
            $('#doctorNameSig').text(data.doctorName);
            $('#printDate').text(new Date().toLocaleDateString());
            
            // Medications
            if (data.medications && data.medications.length > 0) {
                var medHtml = '';
                data.medications.forEach(function(med) {
                    medHtml += '<tr><td>' + med.med_name + '</td><td>' + med.dosage + '</td><td>' + med.frequency + '</td><td>' + med.duration + '</td><td>' + (med.special_inst || '-') + '</td></tr>';
                });
                $('#medicationsTable tbody').html(medHtml);
            } else {
                $('#medicationsTable tbody').html('<tr><td colspan="5" style="text-align:center;">No medications prescribed</td></tr>');
            }
            
            // Lab Tests - Card format
            if (data.labTests && data.labTests.length > 0) {
                var labHtml = '';
                data.labTests.forEach(function(order, index) {
                    var statusBadge = order.order_status === 'Completed' 
                        ? '<span style="background:#27ae60; color:white; padding:5px 10px; border-radius:3px;">Completed</span>' 
                        : '<span style="background:#f39c12; color:white; padding:5px 10px; border-radius:3px;">Pending</span>';
                    
                    labHtml += '<div style="border:2px solid #9b59b6; border-radius:5px; padding:15px; margin-bottom:15px; background:#f9f9f9;">';
                    labHtml += '<div style="background:#9b59b6; color:white; padding:8px; margin:-15px -15px 10px -15px; border-radius:3px 3px 0 0; font-weight:bold;">';
                    labHtml += 'LAB ORDER #' + (index + 1) + ' - Order ID: ' + order.order_id + ' (Prescription: ' + order.prescid + ')';
                    labHtml += '</div>';
                    
                    labHtml += '<div style="margin-bottom:8px;"><strong>Status:</strong> ' + statusBadge + '</div>';
                    labHtml += '<div style="margin-bottom:8px;"><strong>Ordered Date:</strong> ' + order.ordered_date + '</div>';
                    
                    if (order.ordered_tests && order.ordered_tests.length > 0) {
                        labHtml += '<div style="margin-top:12px;"><strong>Tests Ordered:</strong></div>';
                        labHtml += '<ul style="margin:5px 0; padding-left:20px;">';
                        order.ordered_tests.forEach(function(test) {
                            labHtml += '<li>' + test + '</li>';
                        });
                        labHtml += '</ul>';
                        
                        if (order.order_status === 'Completed' && order.test_results && Object.keys(order.test_results).length > 0) {
                            labHtml += '<div style="margin-top:12px;"><strong>Lab Results:</strong></div>';
                            labHtml += '<table style="width:100%; margin-top:8px; border:1px solid #ddd; border-collapse:collapse;">';
                            labHtml += '<tr><th style="background:#ecf0f1; padding:8px; border:1px solid #bdc3c7;">Test</th><th style="background:#ecf0f1; padding:8px; border:1px solid #bdc3c7;">Result</th></tr>';
                            
                            for (var testName in order.test_results) {
                                labHtml += '<tr>';
                                labHtml += '<td style="padding:6px; border:1px solid #ddd;"><strong>' + testName + '</strong></td>';
                                labHtml += '<td style="padding:6px; border:1px solid #ddd;">' + order.test_results[testName] + '</td>';
                                labHtml += '</tr>';
                            }
                            
                            labHtml += '</table>';
                        } else if (order.order_status === 'Pending') {
                            labHtml += '<div style="margin-top:12px; padding:8px; background:#fff3cd; border-left:4px solid #ffc107;">';
                            labHtml += '<strong>Note:</strong> Lab tests are pending. Results not yet available.';
                            labHtml += '</div>';
                        }
                    }
                    
                    labHtml += '</div>';
                });
                $('#labTestsContainer').html(labHtml);
            } else {
                $('#labTestsContainer').html('<div style="text-align:center; padding:20px; color:#999;">No laboratory tests ordered</div>');
            }
            
            // Charges
            if (data.charges && data.charges.length > 0) {
                var chargeHtml = '';
                var total = 0;
                var unpaid = 0;
                data.charges.forEach(function(charge) {
                    var amount = parseFloat(charge.amount);
                    total += amount;
                    var isPaid = charge.is_paid === '1' || charge.is_paid === 'True';
                    if (!isPaid) unpaid += amount;
                    chargeHtml += '<tr><td>' + charge.charge_type + '</td><td>' + charge.charge_name + '</td><td>$' + amount.toFixed(2) + '</td><td>' + (isPaid ? '<span style="color:green">Paid</span>' : '<span style="color:red">Unpaid</span>') + '</td></tr>';
                });
                $('#chargesTable tbody').html(chargeHtml);
                $('#totalCharges').text('$' + total.toFixed(2));
                $('#paymentStatus').html(unpaid > 0 ? '<span style="color:red">Balance Due: $' + unpaid.toFixed(2) + '</span>' : '<span style="color:green">Fully Paid</span>');
            }
        }
        
        function loadHospitalHeader() {
            $.ajax({
                url: 'discharge_summary_print.aspx/GetPrintHeader',
                method: 'POST',
                contentType: 'application/json',
                success: function(response) {
                    if (response.d) {
                        $('#hospitalHeader').html(response.d);
                    }
                },
                error: function() {
                    // Fallback to simple header
                    $('#hospitalHeader').html('<h1>Hospital Discharge Summary</h1>');
                }
            });
        }
    </script>
    
    <!-- Watermark -->
    <% var __logoUrl = juba_hospital.HospitalSettingsHelper.GetPrintLogoUrl(); %>
    <div class="print-watermark">
        <img src="<%= __logoUrl %>" alt="Hospital Logo Watermark" />
    </div>
</body>
</html>
