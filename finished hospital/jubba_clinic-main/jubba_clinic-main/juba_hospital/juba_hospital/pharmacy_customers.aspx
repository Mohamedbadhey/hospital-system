<%@ Page Title="" Language="C#" MasterPageFile="~/pharmacy.Master" AutoEventWireup="true" CodeBehind="pharmacy_customers.aspx.cs" Inherits="juba_hospital.pharmacy_customers" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <style>
        .dataTables_wrapper .dataTables_filter { float: right; }
        #datatable { width: 100%; margin: 20px 0; font-size: 14px; }
        #datatable th { background-color: #007bff; color: white; }
        
        /* Mobile Responsive Styles */
        @media (max-width: 768px) {
            .card-header {
                padding: 15px 10px;
            }
            
            .card-header h4 {
                font-size: 16px;
                margin-bottom: 10px;
            }
            
            .card-body {
                padding: 10px;
                overflow-x: auto;
            }
            
            #datatable {
                font-size: 12px;
            }
            
            .btn-sm {
                padding: 4px 8px;
                font-size: 11px;
            }
            
            /* DataTables responsive controls */
            .dtr-control {
                cursor: pointer;
            }
            
            .dtr-details {
                width: 100%;
            }
        }
        
        @media (max-width: 576px) {
            .card-header h4 {
                font-size: 14px;
            }
            
            #datatable {
                font-size: 11px;
            }
            
            .modal-dialog {
                margin: 10px;
            }
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="modal fade" id="customerModal" tabindex="-1">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Add Customer</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <input type="hidden" id="customerid" />
            <div class="mb-3">
                <label class="form-label">Customer Name</label>
                <input type="text" class="form-control" id="customerName" />
            </div>
            <div class="mb-3">
                <label class="form-label">Phone</label>
                <input type="text" class="form-control" id="phone" />
            </div>
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" class="form-control" id="email" />
            </div>
            <div class="mb-3">
                <label class="form-label">Address</label>
                <textarea class="form-control" id="address"></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="button" onclick="saveCustomer()" class="btn btn-primary">Save</button>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title">Customers</h4>
                    <button type="button" id="addCustomer" class="btn btn-primary">Add Customer</button>
                </div>
                <div class="card-body">
                    <table class="display nowrap" style="width:100%" id="datatable">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Phone</th>
                                <th>Email</th>
                                <th>Address</th>
                                <th>Date Registered</th>
                                <th>Operation</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script>
        var dataTable;

        // Function to initialize everything after jQuery is loaded
        function initPharmacyCustomersPage() {
            if (typeof jQuery === 'undefined' || typeof $ === 'undefined') {
                // jQuery not ready yet, try again
                setTimeout(initPharmacyCustomersPage, 100);
                return;
            }

            // jQuery is available, proceed with initialization
            $(document).ready(function () {
                console.log('jQuery confirmed available, loading DataTables...');
                loadDataTablesLibrary();
            });
        }

        // Start the initialization process immediately
        initPharmacyCustomersPage();

        function loadDataTablesLibrary() {
            // Dynamically load DataTables after jQuery is confirmed loaded
            var script = document.createElement('script');
            script.src = 'datatables/datatables.min.js';
            script.onload = function() {
                console.log('DataTables library loaded successfully');
                initializeDataTable();
            };
            script.onerror = function() {
                console.error('Failed to load DataTables library');
            };
            document.head.appendChild(script);
        }

        function initializeDataTable() {
            try {
                // Initialize empty DataTable
                dataTable = $('#datatable').DataTable({
                    responsive: true,
                    autoWidth: false,
                    columnDefs: [
                        { responsivePriority: 1, targets: 0 }, // Customer Name
                        { responsivePriority: 2, targets: -1 } // Operations
                    ]
                });
                console.log('DataTable initialized successfully');
                loadCustomers();
                
                // Setup event handlers after DataTable is ready
                setupEventHandlers();
            } catch (error) {
                console.error('Error initializing DataTable:', error);
            }
        }

        function setupEventHandlers() {
            // Add Customer button click handler
            $('#addCustomer').click(function() {
                $('#customerid').val('');
                $('#customerName').val('');
                $('#phone').val('');
                $('#email').val('');
                $('#address').val('');
                $('#customerModal').modal('show');
            });
        }

        function loadCustomers() {
            $.ajax({
                url: 'pharmacy_customers.aspx/getCustomers',
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    // Clear existing data
                    dataTable.clear();
                    
                    for (var i = 0; i < r.d.length; i++) {
                        // Add row data to DataTable
                        dataTable.row.add([
                            r.d[i].customer_name,
                            r.d[i].phone,
                            r.d[i].email,
                            r.d[i].address,
                            r.d[i].date_registered,
                            '<button class="btn btn-success btn-sm" onclick="editCustomer(' + r.d[i].customerid + ')">Edit</button>'
                        ]);
                    }
                    
                    // Redraw the table to apply changes and maintain responsiveness
                    dataTable.draw();
                }
            });
        }

        function editCustomer(id) {
            $.ajax({
                url: 'pharmacy_customers.aspx/getCustomerById',
                data: JSON.stringify({ id: id }),
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    if (r.d && r.d.length > 0) {
                        var cust = r.d[0];
                        $('#customerid').val(cust.customerid);
                        $('#customerName').val(cust.customer_name);
                        $('#phone').val(cust.phone);
                        $('#email').val(cust.email);
                        $('#address').val(cust.address);
                        $('#customerModal').modal('show');
                    }
                }
            });
        }

        function saveCustomer() {
            var data = {
                customerid: $('#customerid').val() || '0',
                customerName: $('#customerName').val(),
                phone: $('#phone').val(),
                email: $('#email').val(),
                address: $('#address').val()
            };

            $.ajax({
                url: 'pharmacy_customers.aspx/saveCustomer',
                data: JSON.stringify(data),
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    if (r.d === 'true') {
                        Swal.fire('Success!', 'Customer saved successfully!', 'success');
                        $('#customerModal').modal('hide');
                        loadCustomers();
                        $('#customerid').val('');
                        $('#customerName').val('');
                        $('#phone').val('');
                        $('#email').val('');
                        $('#address').val('');
                    }
                }
            });
        }
    </script>
</asp:Content>

