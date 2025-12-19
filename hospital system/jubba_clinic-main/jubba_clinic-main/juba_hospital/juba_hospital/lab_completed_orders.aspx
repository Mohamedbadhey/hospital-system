<%@ Page Title="" Language="C#" MasterPageFile="~/labtest.Master" AutoEventWireup="true"
    CodeBehind="lab_completed_orders.aspx.cs" Inherits="juba_hospital.lab_completed_orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css" rel="stylesheet" />
    <link href="https://cdn.datatables.net/buttons/2.2.2/css/buttons.bootstrap5.min.css" rel="stylesheet" />
    <style>
        .badge {
            padding: 0.35em 0.65em;
            font-size: 0.85em;
            font-weight: 600;
        }

        .badge-success {
            background-color: #28a745;
            color: white;
        }

        .card {
            border: none;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.08);
        }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: 600;
        }

        .table thead th {
            background-color: #f8f9fa;
            font-weight: 600;
            border-bottom: 2px solid #dee2e6;
        }

        .action-btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            margin: 0 2px;
        }

        .status-completed {
            background-color: #d4edda;
            color: #155724;
            padding: 4px 12px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .reorder-badge {
            background-color: #fff3cd;
            color: #856404;
            padding: 2px 8px;
            border-radius: 8px;
            font-size: 0.75rem;
            margin-left: 5px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container-fluid mt-4">
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">
                            <i class="fas fa-check-circle text-success"></i> Completed Lab Orders
                        </h2>
                        <p class="text-muted mb-0">View all processed lab test results</p>
                    </div>
                    <div>
                        <a href="lab_waiting_list.aspx" class="btn btn-outline-primary">
                            <i class="fas fa-list"></i> All Orders
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Card -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="fas fa-file-medical-alt"></i> Completed Test Results
                </h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table id="completedOrdersTable" class="table table-hover table-bordered">
                        <thead>
                            <tr>
                                <th>Patient ID</th>
                                <th>Patient Name</th>
                                <th>Age/Sex</th>
                                <th>Phone</th>
                                <th>Doctor</th>
                                <th>Completed Date</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Data populated via AJAX -->
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- View Ordered Tests Modal -->
    <div class="modal fade" id="orderedTestsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-warning text-dark">
                    <h5 class="modal-title">
                        <i class="fas fa-flask"></i> Ordered Tests
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="orderedTestsContent">
                        <!-- Content loaded via AJAX -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- View Results Modal -->
    <div class="modal fade" id="resultsModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-file-medical-alt"></i> Test Results
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="resultsContent">
                        <!-- Content loaded via AJAX -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Patient Lab History Modal -->
    <div class="modal fade" id="historyModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title">
                        <i class="fas fa-history"></i> Patient Lab History
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="historyContent">
                        <!-- Content loaded via AJAX -->
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Results Modal -->
    <div class="modal fade" id="editResultsModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white;">
                    <h5 class="modal-title">
                        <i class="fas fa-edit"></i> Edit Lab Results
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="editLabResultId" />
                    <input type="hidden" id="editPrescId" />
                    
                    <div class="alert alert-info">
                        <strong>Patient:</strong> <span id="editPatientName"></span><br>
                        <strong>Test Date:</strong> <span id="editTestDate"></span>
                    </div>
                    
                    <div id="editResultsContent">
                        <!-- Test result fields loaded dynamically -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="saveEditedResults()">
                        <i class="fas fa-save"></i> Save Changes
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.2.2/js/dataTables.buttons.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.2.2/js/buttons.bootstrap5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.2.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/2.2.2/js/buttons.print.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script>

    <script>
        let table;

        $(document).ready(function () {
            loadCompletedOrders();
        });

        function loadCompletedOrders() {
            $.ajax({
                type: "POST",
                url: "lab_completed_orders.aspx/GetCompletedOrders",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    populateTable(response.d);
                },
                error: function (error) {
                    console.error('Error loading orders:', error);
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Failed to load completed orders.'
                    });
                }
            });
        }

        function populateTable(data) {
            if (table) {
                table.destroy();
            }

            const tableBody = $('#completedOrdersTable tbody');
            tableBody.empty();

            data.forEach(function (order) {
                const age = calculateAge(order.dob);
                const reorderBadge = order.is_reorder === "1" ? 
                    '<span class="reorder-badge" title="' + (order.reorder_reason || 'Follow-up') + '">Re-order</span>' : '';

                const row = `
                    <tr>
                        <td>${order.patientid}</td>
                        <td>${order.full_name}${reorderBadge}</td>
                        <td>${age} / ${order.sex}</td>
                        <td>${order.phone}</td>
                        <td>${order.doctortitle}</td>
                        <td>${formatDate(order.last_order_date)}</td>
                        <td><span class="status-completed"><i class="fas fa-check-circle"></i> Completed</span></td>
                        <td>
                            <button type="button" class="btn btn-sm btn-warning action-btn" onclick="viewOrderedTests('${order.prescid}', '${order.order_id}')" title="View Ordered Tests">
                                <i class="fas fa-flask"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-success action-btn" onclick="viewResults('${order.prescid}', '${order.order_id}')" title="View Results">
                                <i class="fas fa-file-medical"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-secondary action-btn" onclick="editResults('${order.prescid}', '${order.order_id}')" title="Edit Results">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-primary action-btn" onclick="printLabReport('${order.prescid}')" title="Print Report">
                                <i class="fas fa-print"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-info action-btn" onclick="viewHistory('${order.patientid}')" title="Patient History">
                                <i class="fas fa-history"></i>
                            </button>
                        </td>
                    </tr>
                `;
                tableBody.append(row);
            });

            table = $('#completedOrdersTable').DataTable({
                dom: 'Bfrtip',
                buttons: [
                    'copy', 'csv', 'excel', 'pdf', 'print'
                ],
                order: [[5, 'desc']],
                pageLength: 25,
                language: {
                    emptyTable: "No completed lab orders found"
                }
            });
        }

        function viewOrderedTests(prescid, orderId) {
            $.ajax({
                type: "POST",
                url: "lab_completed_orders.aspx/GetOrderedTests",
                data: JSON.stringify({ prescid: prescid, orderId: orderId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    displayOrderedTests(response.d);
                },
                error: function (error) {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to load ordered tests', 'error');
                }
            });
        }

        function displayOrderedTests(tests) {
            const content = $('#orderedTestsContent');
            content.empty();

            if (tests.length === 0) {
                content.html('<p class="text-muted">No tests found for this order.</p>');
            } else {
                let html = `
                    <div class="alert alert-info">
                        <strong>Patient:</strong> ${tests[0].PatientName}<br>
                        <strong>Order Date:</strong> ${tests[0].OrderDate}
                    </div>
                    <div class="row">
                `;

                tests.forEach(function (test) {
                    html += `
                        <div class="col-md-6 mb-2">
                            <div class="alert alert-warning mb-2">
                                <i class="fas fa-check-circle"></i> ${test.TestName}
                            </div>
                        </div>
                    `;
                });

                html += '</div>';
                content.html(html);
            }

            $('#orderedTestsModal').modal('show');
        }

        function viewResults(prescid, orderId) {
            $.ajax({
                type: "POST",
                url: "lab_completed_orders.aspx/GetTestResults",
                data: JSON.stringify({ prescid: prescid, orderId: orderId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    displayResults(response.d);
                },
                error: function (error) {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to load test results', 'error');
                }
            });
        }

        function displayResults(data) {
            const content = $('#resultsContent');
            content.empty();

            let html = `
                <div class="card mb-3">
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p><strong>Patient:</strong> ${data.PatientName}</p>
                                <p><strong>Patient ID:</strong> ${data.PatientId}</p>
                            </div>
                            <div class="col-md-6">
                                <p><strong>Doctor:</strong> ${data.Doctor || '—'}</p>
                                <p><strong>Test Date:</strong> ${data.OrderDate}</p>
                            </div>
                        </div>
                    </div>
                </div>
            `;

            if (data.Results.length === 0) {
                html += '<div class="alert alert-warning">No results recorded yet.</div>';
            } else {
                html += `
                    <table class="table table-bordered">
                        <thead class="table-light">
                            <tr>
                                <th>Test Parameter</th>
                                <th>Result</th>
                            </tr>
                        </thead>
                        <tbody>
                `;

                data.Results.forEach(function (result) {
                    html += `
                        <tr>
                            <td><strong>${result.Parameter}</strong></td>
                            <td>${result.Value}</td>
                        </tr>
                    `;
                });

                html += '</tbody></table>';
            }

            content.html(html);
            $('#resultsModal').modal('show');
        }

        function viewHistory(patientId) {
            $.ajax({
                type: "POST",
                url: "lab_completed_orders.aspx/GetPatientLabHistory",
                data: JSON.stringify({ patientId: patientId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    displayHistory(response.d);
                },
                error: function (error) {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to load patient history', 'error');
                }
            });
        }

        function displayHistory(data) {
            const content = $('#historyContent');
            content.empty();

            let html = `
                <div class="row mb-3">
                    <div class="col-md-4">
                        <div class="card text-center">
                            <div class="card-body">
                                <h3 class="text-primary">${data.TotalOrders}</h3>
                                <p class="mb-0">Total Orders</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-center">
                            <div class="card-body">
                                <h3 class="text-success">${data.CompletedOrders}</h3>
                                <p class="mb-0">Completed</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card text-center">
                            <div class="card-body">
                                <h3 class="text-warning">${data.PendingOrders}</h3>
                                <p class="mb-0">Pending</p>
                            </div>
                        </div>
                    </div>
                </div>
            `;

            if (data.Orders.length === 0) {
                html += '<div class="alert alert-info">No lab orders found for this patient.</div>';
            } else {
                data.Orders.forEach(function (order) {
                    const statusClass = order.IsCompleted ? 'success' : 'warning';
                    const statusText = order.IsCompleted ? 'Completed' : 'Pending';

                    html += `
                        <div class="card mb-3">
                            <div class="card-header bg-${statusClass} text-white">
                                <div class="d-flex justify-content-between align-items-center">
                                    <span><i class="fas fa-calendar"></i> ${order.OrderDate}</span>
                                    <span class="badge badge-light">${statusText}</span>
                                </div>
                            </div>
                            <div class="card-body">
                                <p><strong>Doctor:</strong> ${order.Doctor || '—'}</p>
                                <p><strong>Ordered Tests:</strong></p>
                                <div class="row">
                    `;

                    order.Tests.forEach(function (test) {
                        html += `
                            <div class="col-md-6 mb-2">
                                <span class="badge bg-warning text-dark">${test}</span>
                            </div>
                        `;
                    });

                    html += '</div>';

                    if (order.IsCompleted && order.Results.length > 0) {
                        html += `
                            <hr>
                            <p><strong>Results:</strong></p>
                            <table class="table table-sm table-bordered">
                                <thead>
                                    <tr>
                                        <th>Parameter</th>
                                        <th>Value</th>
                                    </tr>
                                </thead>
                                <tbody>
                        `;

                        order.Results.forEach(function (result) {
                            html += `
                                <tr>
                                    <td>${result.Parameter}</td>
                                    <td>${result.Value}</td>
                                </tr>
                            `;
                        });

                        html += '</tbody></table>';
                    }

                    html += '</div></div>';
                });
            }

            content.html(html);
            $('#historyModal').modal('show');
        }

        function editResults(prescid, labResultId) {
            $.ajax({
                type: "POST",
                url: "lab_completed_orders.aspx/GetResultsForEdit",
                data: JSON.stringify({ prescid: prescid, labResultId: labResultId }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    displayEditForm(response.d);
                },
                error: function (error) {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to load results for editing', 'error');
                }
            });
        }

        function displayEditForm(data) {
            $('#editLabResultId').val(data.LabResultId);
            $('#editPrescId').val(data.PrescId);
            $('#editPatientName').text(data.PatientName);
            $('#editTestDate').text(data.TestDate);

            const content = $('#editResultsContent');
            content.empty();

            if (data.Results.length === 0) {
                content.html('<div class="alert alert-warning">No results found to edit.</div>');
            } else {
                let html = '';
                
                // Show Ordered Tests section
                if (data.OrderedTests && data.OrderedTests.length > 0) {
                    html += `
                        <div class="mb-4">
                            <h5 style="color: #334155; border-bottom: 2px solid #f59e0b; padding-bottom: 8px; margin-bottom: 15px;">
                                <i class="fas fa-flask"></i> Ordered Tests
                            </h5>
                            <div style="background: #fef3c7; padding: 15px; border-radius: 6px; border-left: 4px solid #f59e0b;">
                    `;
                    
                    data.OrderedTests.forEach(function (test) {
                        html += `
                            <span style="display: inline-block; background: #fff; padding: 6px 12px; margin: 4px; border-radius: 4px; font-size: 0.9rem;">
                                <i class="fas fa-check-circle" style="color: #f59e0b;"></i> ${test}
                            </span>
                        `;
                    });
                    
                    html += `
                            </div>
                        </div>
                    `;
                }
                
                // Show Test Results Input Fields
                html += `
                    <div class="mb-3">
                        <h5 style="color: #334155; border-bottom: 2px solid #667eea; padding-bottom: 8px; margin-bottom: 15px;">
                            <i class="fas fa-edit"></i> Edit Test Results
                        </h5>
                        <div class="row">
                `;
                
                data.Results.forEach(function (result, index) {
                    html += `
                        <div class="col-md-6 mb-3">
                            <div class="card" style="border-left: 3px solid #667eea;">
                                <div class="card-body">
                                    <label class="form-label"><strong>${result.Parameter}</strong></label>
                                    <input type="text" class="form-control result-field" 
                                           data-column="${result.ColumnName}" 
                                           value="${result.Value}" 
                                           placeholder="Enter ${result.Parameter}">
                                </div>
                            </div>
                        </div>
                    `;
                });

                html += '</div></div>';
                content.html(html);
            }

            $('#editResultsModal').modal('show');
        }

        function saveEditedResults() {
            const labTestId = $('#editLabResultId').val(); // This actually contains order_id (med_id)
            
            // Collect all edited values
            const results = {};
            $('.result-field').each(function () {
                const column = $(this).data('column');
                const value = $(this).val();
                results[column] = value;
            });

            $.ajax({
                type: "POST",
                url: "lab_completed_orders.aspx/UpdateLabResults",
                data: JSON.stringify({ 
                    labTestId: labTestId,
                    results: results 
                }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    if (response.d.success) {
                        Swal.fire({
                            icon: 'success',
                            title: 'Success',
                            text: 'Lab results updated successfully!'
                        }).then(() => {
                            $('#editResultsModal').modal('hide');
                            loadCompletedOrders(); // Reload the table
                        });
                    } else {
                        Swal.fire('Error', response.d.message || 'Failed to update results', 'error');
                    }
                },
                error: function (error) {
                    console.error('Error:', error);
                    Swal.fire('Error', 'Failed to update lab results', 'error');
                }
            });
        }

        function printLabReport(prescid) {
            window.open('lab_orders_print.aspx?prescid=' + prescid, '_blank', 'width=900,height=700');
        }

        function calculateAge(dob) {
            if (!dob) return '—';
            const birthDate = new Date(dob);
            const today = new Date();
            let age = today.getFullYear() - birthDate.getFullYear();
            const monthDiff = today.getMonth() - birthDate.getMonth();
            if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
                age--;
            }
            return age;
        }

        function formatDate(dateString) {
            if (!dateString) return '—';
            const date = new Date(dateString);
            return date.toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'short',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        }
    </script>
</asp:Content>
