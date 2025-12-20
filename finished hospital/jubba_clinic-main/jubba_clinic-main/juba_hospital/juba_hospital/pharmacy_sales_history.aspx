<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="pharmacy_sales_history.aspx.cs" Inherits="juba_hospital.pharmacy_sales_history" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
    <style>
        .dataTables_wrapper .dataTables_filter { float: right; }
        #datatable { width: 100%; margin: 20px 0; font-size: 14px; }
        #datatable th { background-color: #007bff; color: white; }
        
        /* Enhanced DataTable Styling */
        .dataTables_wrapper {
            padding: 0;
        }

        .dataTables_filter input {
            border: 2px solid #e9ecef;
            border-radius: 25px;
            padding: 8px 15px;
            margin-left: 8px;
            font-size: 14px;
            width: 250px;
        }

        .dataTables_filter input:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
            outline: none;
        }

        /* Desktop Styles (ensure full table on large screens) */
        @media (min-width: 992px) {
            #datatable {
                width: 100% !important;
            }
            
            .dataTables_wrapper {
                overflow-x: visible;
            }
            
            .dtr-control {
                display: none !important;
            }
        }

        /* Tablet Styles */
        @media (max-width: 991px) and (min-width: 769px) {
            .card-header .row {
                margin-top: 10px;
            }
            
            .card-header .col-md-3,
            .card-header .col-md-4,
            .card-header .col-md-2 {
                margin-bottom: 10px;
            }
            
            #datatable {
                font-size: 13px;
            }
        }

        /* Mobile Responsive Styles */
        @media (max-width: 768px) {
            .card-header .row {
                margin-top: 10px;
            }
            
            .card-header .col-md-3,
            .card-header .col-md-4,
            .card-header .col-md-2 {
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
            
            /* DataTables responsive controls */
            .dtr-control {
                cursor: pointer;
            }
            
            .dtr-details {
                width: 100%;
            }
            
            .dataTables_filter input {
                width: 100%;
                margin-left: 0;
                margin-top: 10px;
            }
        }

        /* Force table recalculation on orientation change */
        @media screen and (orientation: portrait) {
            .dataTables_wrapper {
                transition: all 0.3s ease;
            }
        }

        @media screen and (orientation: landscape) {
            .dataTables_wrapper {
                transition: all 0.3s ease;
            }
        }
        
        @media (max-width: 576px) {
            .card-header h4 {
                font-size: 18px;
            }
            
            #datatable {
                font-size: 11px;
            }
            
            .btn-block {
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
                    <h4 class="card-title">Sales History</h4>
                    <div class="row mt-3">
                        <div class="col-md-3">
                            <label>From Date</label>
                            <input type="date" class="form-control" id="fromDate" />
                        </div>
                        <div class="col-md-3">
                            <label>To Date</label>
                            <input type="date" class="form-control" id="toDate" />
                        </div>
                        <div class="col-md-4">
                            <label>Filter by Medicine (Optional)</label>
                            <select class="form-control" id="medicineFilter">
                                <option value="">All Medicines</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <label>&nbsp;</label>
                            <button type="button" class="btn btn-primary btn-block" onclick="loadSales()">
                                <i class="fas fa-filter"></i> Filter
                            </button>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <table class="display nowrap" style="width:100%" id="datatable">
                        <thead>
                            <tr>
                                <th>Invoice #</th>
                                <th>Date</th>
                                <th>Customer</th>
                                <th>Items</th>
                                <th>Subtotal</th>
                                <th>Discount</th>
                                <th>Total</th>
                                <th>Payment</th>
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
        function initSalesHistoryPage() {
            if (typeof jQuery === 'undefined' || typeof $ === 'undefined') {
                // jQuery not ready yet, try again
                setTimeout(initSalesHistoryPage, 100);
                return;
            }

            // jQuery is available, proceed with initialization
            $(document).ready(function () {
                console.log('jQuery confirmed available, loading DataTables...');
                loadDataTablesLibrary();
            });
        }

        // Start the initialization process immediately
        initSalesHistoryPage();

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
                    responsive: {
                        details: {
                            type: 'column',
                            target: 'tr'
                        }
                    },
                    autoWidth: false,
                    scrollX: true,
                    columnDefs: [
                        { responsivePriority: 1, targets: 0 }, // Invoice Number
                        { responsivePriority: 2, targets: -1 }, // Operations
                        { responsivePriority: 3, targets: 4 }, // Total Amount
                        { responsivePriority: 4, targets: 6 }, // Final Amount
                        { width: "15%", targets: 0 },
                        { width: "12%", targets: 1 },
                        { width: "15%", targets: 2 },
                        { width: "8%", targets: 3 },
                        { width: "12%", targets: 4 },
                        { width: "10%", targets: 5 },
                        { width: "12%", targets: 6 },
                        { width: "10%", targets: 7 },
                        { width: "16%", targets: 8, orderable: false }
                    ],
                    pageLength: 25,
                    lengthMenu: [10, 25, 50, 100],
                    language: {
                        search: "🔍 Search sales:",
                        lengthMenu: "Show _MENU_ sales per page",
                        info: "Showing _START_ to _END_ of _TOTAL_ sales",
                        infoEmpty: "No sales found",
                        infoFiltered: "(filtered from _MAX_ total sales)"
                    }
                });
                console.log('DataTable initialized successfully');
                
                // Add window resize handler to adjust DataTable
                $(window).on('resize', function() {
                    setTimeout(function() {
                        dataTable.columns.adjust().responsive.recalc();
                    }, 100);
                });
                
                loadMedicineList();
                loadSales();
            } catch (error) {
                console.error('Error initializing DataTable:', error);
            }
        }

        function loadMedicineList() {
            $.ajax({
                url: 'pharmacy_sales_history.aspx/getMedicineList',
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    $('#medicineFilter').empty();
                    $('#medicineFilter').append('<option value="">All Medicines</option>');
                    for (var i = 0; i < r.d.length; i++) {
                        $('#medicineFilter').append(
                            '<option value="' + r.d[i].medicineid + '">' + r.d[i].medicine_name + '</option>'
                        );
                    }
                }
            });
        }

        function loadSales() {
            var fromDate = $('#fromDate').val();
            var toDate = $('#toDate').val();
            var medicineId = $('#medicineFilter').val();
            
            $.ajax({
                url: 'pharmacy_sales_history.aspx/getSalesHistory',
                data: JSON.stringify({ fromDate: fromDate, toDate: toDate, medicineId: medicineId }),
                type: 'POST',
                contentType: 'application/json',
                dataType: 'json',
                success: function (r) {
                    // Clear existing data
                    dataTable.clear();
                    
                    if (r.d && r.d.length > 0) {
                        for (var i = 0; i < r.d.length; i++) {
                            var invoiceNum = r.d[i].invoice_number;
                            // Add row data to DataTable
                            dataTable.row.add([
                                r.d[i].invoice_number,
                                r.d[i].sale_date,
                                r.d[i].customer_name,
                                r.d[i].item_count,
                                '$' + parseFloat(r.d[i].total_amount).toFixed(2),
                                '$' + parseFloat(r.d[i].discount).toFixed(2),
                                '<strong>$' + parseFloat(r.d[i].final_amount).toFixed(2) + '</strong>',
                                r.d[i].payment_method,
                                '<button class="btn btn-info btn-sm" onclick="viewInvoice(\'' + invoiceNum + '\')"><i class="fas fa-eye"></i> View Invoice</button>'
                            ]);
                        }
                    } else {
                        // Add "no data" row
                        dataTable.row.add([
                            '<span colspan="9" style="text-align:center;">No sales found for the selected criteria</span>',
                            '', '', '', '', '', '', '', ''
                        ]);
                    }
                    
                    // Redraw the table to apply changes and maintain responsiveness
                    dataTable.draw();
                }
            });
        }

        function viewInvoice(invoiceNumber) {
            window.open('pharmacy_invoice.aspx?invoice=' + invoiceNumber, '_blank', 'width=900,height=800,scrollbars=yes');
        }
    </script>
</asp:Content>

