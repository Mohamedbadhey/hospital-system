<%@ Page Title="" Language="C#" MasterPageFile="~/pharmacy.Master" AutoEventWireup="true" CodeBehind="low_stock.aspx.cs"
    Inherits="juba_hospital.low_stock" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link href="datatables/datatables.min.css" rel="stylesheet" />
        <style>
            .dataTables_wrapper .dataTables_filter {
                float: right;
            }

            #datatable {
                width: 100%;
                margin: 20px 0;
                font-size: 14px;
            }

            #datatable th {
                background-color: #dc3545;
                color: white;
            }

            .badge-danger {
                background-color: #dc3545;
            }
            
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
                
                .btn-sm i {
                    margin-right: 2px;
                }
                
                .badge {
                    font-size: 10px;
                    padding: 3px 6px;
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
                
                .d-flex {
                    flex-direction: column;
                    align-items: flex-start !important;
                }
                
                .d-flex .btn {
                    margin-top: 10px;
                    width: 100%;
                }
            }
        </style>
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h4 class="card-title mb-0">Low Stock Alerts</h4>
                            <button type="button" class="btn btn-primary btn-sm" onclick="printReport()">
                                <i class="fas fa-print"></i> Print Report
                            </button>
                        </div>
                    </div>
                    <div class="card-body">
                        <table class="display nowrap" style="width:100%" id="datatable">
                            <thead>
                                <tr>
                                    <th>Medicine Name</th>
                                    <th>Primary Qty</th>
                                    <th>Secondary Qty</th>
                                    <th>Reorder Level</th>
                                    <th>Difference</th>
                                    <th>Expiry Date</th>
                                    <th>Status</th>
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
            function initLowStockPage() {
                if (typeof jQuery === 'undefined' || typeof $ === 'undefined') {
                    // jQuery not ready yet, try again
                    setTimeout(initLowStockPage, 100);
                    return;
                }

                // jQuery is available, proceed with initialization
                $(document).ready(function () {
                    console.log('jQuery confirmed available, loading DataTables...');
                    loadDataTablesLibrary();
                });
            }

            // Start the initialization process immediately
            initLowStockPage();

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
                            { responsivePriority: 1, targets: 0 }, // Medicine Name
                            { responsivePriority: 2, targets: -1 } // Status
                        ]
                    });
                    console.log('DataTable initialized successfully');
                    loadLowStock();
                } catch (error) {
                    console.error('Error initializing DataTable:', error);
                }
            }

            function loadLowStock() {
                $.ajax({
                    url: 'low_stock.aspx/getLowStock',
                    type: 'POST',
                    contentType: 'application/json',
                    dataType: 'json',
                    success: function (r) {
                        console.log('Low stock data received:', r);
                        
                        // Clear existing data
                        dataTable.clear();
                        
                        if (r.d && r.d.length > 0) {
                            for (var i = 0; i < r.d.length; i++) {
                                var diff = parseInt(r.d[i].reorder_level_strips) - parseInt(r.d[i].primary_quantity);
                                // Add row data to DataTable
                                dataTable.row.add([
                                    r.d[i].medicine_name,
                                    '<span class="badge badge-danger">' + r.d[i].primary_quantity + '</span>',
                                    r.d[i].secondary_quantity,
                                    r.d[i].reorder_level_strips,
                                    diff,
                                    r.d[i].expiry_date,
                                    '<span class="badge bg-danger">Urgent</span>'
                                ]);
                            }
                        } else {
                            console.log('No low stock items found');
                        }
                        
                        // Redraw the table to apply changes and maintain responsiveness
                        dataTable.draw();
                    },
                    error: function(xhr, status, error) {
                        console.error('Error loading low stock data:', error);
                    }
                });
            }

            function printReport() {
                window.open('print_low_stock_report.aspx', '_blank', 'width=1000,height=800');
            }
        </script>
    </asp:Content>