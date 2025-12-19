<%@ Page Title="" Language="C#" MasterPageFile="~/register.Master" AutoEventWireup="true" CodeBehind="Patient_details.aspx.cs" Inherits="juba_hospital.Patient_details" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="datatables/datatables.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

       <div class="row">
              <div class="col-md-12">
                <div class="card">
                  <div class="card-header">
                    <h4 class="card-title">Patient Details</h4>
                  </div>
                  <div class="card-body">
                    <div class="table-responsive">
                      <table
                        id="datatable"
                        class="display nowrap" style="width:100%"
                      >
                        <thead>
                          <tr>
                            <th>Name</th>
                            <th>Sex</th>
                            <th>Location</th>
                            <th>Phone</th>
                            <th>D.O.B</th>
                            <th>Date Registered</th>
                            <th>Doctor Title</th>
                          </tr>
                        </thead>
                        <tfoot>
                          <tr>
                            <th>Name</th>
   <th>Sex</th>
   <th>Location</th>
   <th>Phone</th>
                            <th>D.O.B</th>
   <th>Date Registered</th>
   <th>Doctor Title</th>
                          </tr>
                        </tfoot>
               <tbody></tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>

        
            </div>

    <script src="assets/js/core/jquery-3.7.1.min.js"></script>
    <script src="datatables/datatables.min.js"></script>
    <script>
        var dataTable;
        
        $(document).ready(function () {
            // Initialize DataTable with mobile responsiveness
            dataTable = $('#datatable').DataTable({
                dom: 'Bfrtip',
                buttons: ['excelHtml5'],
                paging: true,
                pageLength: 10,
                lengthMenu: [10, 25, 50, 100],
                responsive: true,
                autoWidth: false,
                columnDefs: [
                    { responsivePriority: 1, targets: 0 }, // Name
                    { responsivePriority: 2, targets: 3 }, // Phone
                    { responsivePriority: 3, targets: -1 } // Doctor Title
                ]
            });
            
            datadisplay();
        });
        
        function datadisplay() {
            $.ajax({
                url: 'Patient_details.aspx/datadisplay',
                dataType: "json",
                type: 'POST',
                contentType: "application/json",
                success: function (response) {
                    console.log(response);
                    
                    // Clear existing data
                    dataTable.clear();
                    
                    for (var i = 0; i < response.d.length; i++) {
                        // Add row data to DataTable
                        dataTable.row.add([
                            response.d[i].full_name,
                            response.d[i].sex,
                            response.d[i].location,
                            response.d[i].phone,
                            response.d[i].dob,
                            response.d[i].date_registered,
                            response.d[i].doctortitle
                        ]);










                    }
                    
                    // Redraw the table to apply changes and maintain responsiveness
                    dataTable.draw();
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }
    </script>
</asp:Content>
