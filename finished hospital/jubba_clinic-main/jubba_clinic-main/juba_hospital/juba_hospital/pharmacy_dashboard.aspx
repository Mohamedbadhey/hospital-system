<%@ Page Title="" Language="C#" MasterPageFile="~/pharmacy.Master" AutoEventWireup="true"
  CodeBehind="pharmacy_dashboard.aspx.cs" Inherits="juba_hospital.pharmacy_dashboard" %>
  <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  </asp:Content>
  <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="row">
      <div class="col-sm-6 col-md-3">
        <div class="card card-stats card-round">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-icon">
                <div class="icon-big text-center icon-primary bubble-shadow-small">
                  <i class="fas fa-pills"></i>
                </div>
              </div>
              <div class="col col-stats ms-3 ms-sm-0">
                <div class="numbers">
                  <p class="card-category">Total Medicines</p>
                  <h4 class="card-title"><span id="tm"></span></h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-md-3">
        <div class="card card-stats card-round">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-icon">
                <div class="icon-big text-center icon-danger bubble-shadow-small">
                  <i class="fas fa-exclamation-triangle"></i>
                </div>
              </div>
              <div class="col col-stats ms-3 ms-sm-0">
                <div class="numbers">
                  <p class="card-category">Low Stock Items</p>
                  <h4 class="card-title"><span id="ls"></span></h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-md-3">
        <div class="card card-stats card-round">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-icon">
                <div class="icon-big text-center icon-warning bubble-shadow-small">
                  <i class="fas fa-calendar-times"></i>
                </div>
              </div>
              <div class="col col-stats ms-3 ms-sm-0">
                <div class="numbers">
                  <p class="card-category">Expired/Expiring Soon</p>
                  <h4 class="card-title"><span id="ex"></span></h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-md-3">
        <div class="card card-stats card-round">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-icon">
                <div class="icon-big text-center icon-success bubble-shadow-small">
                  <i class="fas fa-dollar-sign"></i>
                </div>
              </div>
              <div class="col col-stats ms-3 ms-sm-0">
                <div class="numbers">
                  <p class="card-category">Today's Sales</p>
                  <h4 class="card-title"><span id="ts"></span></h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Profit Stats Row -->
    <div class="row">
      <div class="col-sm-6 col-md-3">
        <div class="card card-stats card-round">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-icon">
                <div class="icon-big text-center icon-info bubble-shadow-small">
                  <i class="fas fa-chart-line"></i>
                </div>
              </div>
              <div class="col col-stats ms-3 ms-sm-0">
                <div class="numbers">
                  <p class="card-category">Today's Profit</p>
                  <h4 class="card-title"><span id="tp"></span></h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-md-3">
        <div class="card card-stats card-round">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-icon">
                <div class="icon-big text-center icon-secondary bubble-shadow-small">
                  <i class="fas fa-percentage"></i>
                </div>
              </div>
              <div class="col col-stats ms-3 ms-sm-0">
                <div class="numbers">
                  <p class="card-category">Today's Profit Margin</p>
                  <h4 class="card-title"><span id="tpm"></span></h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-md-3">
        <div class="card card-stats card-round">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-icon">
                <div class="icon-big text-center icon-primary bubble-shadow-small">
                  <i class="fas fa-calendar-alt"></i>
                </div>
              </div>
              <div class="col col-stats ms-3 ms-sm-0">
                <div class="numbers">
                  <p class="card-category">This Month's Profit</p>
                  <h4 class="card-title"><span id="mp"></span></h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-sm-6 col-md-3">
        <div class="card card-stats card-round">
          <div class="card-body">
            <div class="row align-items-center">
              <div class="col-icon">
                <div class="icon-big text-center icon-success bubble-shadow-small">
                  <i class="fas fa-money-bill-wave"></i>
                </div>
              </div>
              <div class="col col-stats ms-3 ms-sm-0">
                <div class="numbers">
                  <p class="card-category">This Month's Sales</p>
                  <h4 class="card-title"><span id="ms"></span></h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Expired/Expiring Soon Table -->
    <div class="row mt-4">
      <div class="col-md-12">
        <div class="card">
          <div class="card-header">
            <h4 class="card-title">Expired & Expiring Soon Medicines</h4>
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-striped" id="expiryTable">
                <thead>
                  <tr>
                    <th>Medicine Name</th>
                    <th>Batch Number</th>
                    <th>Expiry Date</th>
                    <th>Days Remaining</th>
                    <th>Stock (Primary)</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody id="expiryTableBody">
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>

    <script src="assets/js/plugin/datatables/datatables.min.js"></script>
    <script src="Scripts/jquery-3.4.1.min.js"></script>
    <script>
      $(document).ready(function () {
        // Total Medicines
        $.ajax({
          type: "POST",
          url: "pharmacy_dashboard.aspx/total_medicines",
          contentType: "application/json; charset=utf-8",
          dataType: "json",
          success: function (r) {
            $("#tm").text(r.d[0].total);
          },
          error: function (xhr, status, error) {
            console.error(xhr.responseText);
          }
        });

        // Low Stock
        $.ajax({
          type: "POST",
          url: "pharmacy_dashboard.aspx/low_stock",
          contentType: "application/json; charset=utf-8",
          dataType: "json",
          success: function (r) {
            $("#ls").text(r.d[0].total);
          },
          error: function (xhr, status, error) {
            console.error(xhr.responseText);
          }
        });

        // Expired/Expiring Soon
        $.ajax({
          type: "POST",
          url: "pharmacy_dashboard.aspx/expired_medicines",
          contentType: "application/json; charset=utf-8",
          dataType: "json",
          success: function (r) {
            $("#ex").text(r.d[0].total);
          },
          error: function (xhr, status, error) {
            console.error(xhr.responseText);
          }
        });

        // Today's Sales
        var now = new Date();
        var localDate = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0') + '-' + String(now.getDate()).padStart(2, '0');
        
        $.ajax({
          type: "POST",
          url: "pharmacy_dashboard.aspx/todays_sales",
          data: JSON.stringify({ currentDate: localDate }),
          contentType: "application/json; charset=utf-8",
          dataType: "json",
          success: function (r) {
            var localTime = String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0') + ':' + String(now.getSeconds()).padStart(2, '0');
            
            console.log('=== TODAY\'S SALES DEBUG ===');
            console.log('Client Local Date:', localDate);
            console.log('Client Local Time:', localTime);
            console.log('Client Local DateTime:', localDate + ' ' + localTime);
            console.log('Query Date Sent to Server:', localDate);
            console.log('Total Sales:', r.d[0].total);
            console.log('Formatted:', '$' + parseFloat(r.d[0].total).toFixed(2));
            $("#ts").text('$' + parseFloat(r.d[0].total).toFixed(2));
          },
          error: function (xhr, status, error) {
            console.error('=== TODAY\'S SALES ERROR ===');
            console.error(xhr.responseText);
            $("#ts").text('$0.00');
          }
        });

        // Today's Profit
        $.ajax({
          type: "POST",
          url: "pharmacy_dashboard.aspx/todays_profit",
          data: JSON.stringify({ currentDate: localDate }),
          contentType: "application/json; charset=utf-8",
          dataType: "json",
          success: function (r) {
            var localTime = String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0') + ':' + String(now.getSeconds()).padStart(2, '0');
            
            console.log('=== TODAY\'S PROFIT DEBUG ===');
            console.log('Client Local Date:', localDate);
            console.log('Client Local Time:', localTime);
            console.log('Client Local DateTime:', localDate + ' ' + localTime);
            console.log('Query Date Sent to Server:', localDate);
            console.log('Total Profit:', r.d[0].total);
            console.log('Formatted:', '$' + parseFloat(r.d[0].total).toFixed(2));
            $("#tp").text('$' + parseFloat(r.d[0].total).toFixed(2));
          },
          error: function (xhr, status, error) {
            console.error('=== TODAY\'S PROFIT ERROR ===');
            console.error(xhr.responseText);
            $("#tp").text('$0.00');
          }
        });

        // Today's Profit Margin
        $.ajax({
          type: "POST",
          url: "pharmacy_dashboard.aspx/todays_profit_margin",
          contentType: "application/json; charset=utf-8",
          dataType: "json",
          success: function (r) {
            $("#tpm").text(parseFloat(r.d[0].margin).toFixed(2) + '%');
          },
          error: function (xhr, status, error) {
            console.error(xhr.responseText);
            $("#tpm").text('0.00%');
          }
        });

        // This Month's Sales
        $.ajax({
          type: "POST",
          url: "pharmacy_dashboard.aspx/month_sales",
          contentType: "application/json; charset=utf-8",
          dataType: "json",
          success: function (r) {
            var now = new Date();
            var localDate = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0') + '-' + String(now.getDate()).padStart(2, '0');
            var localMonth = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0');
            
            console.log('=== THIS MONTH\'S SALES DEBUG ===');
            console.log('Client Local Date:', localDate);
            console.log('Client Local Month:', localMonth);
            console.log('Server Month (GETDATE): Using server\'s current month (may differ from client)');
            console.log('Total Sales:', r.d[0].total);
            console.log('Formatted:', '$' + parseFloat(r.d[0].total).toFixed(2));
            $("#ms").text('$' + parseFloat(r.d[0].total).toFixed(2));
          },
          error: function (xhr, status, error) {
            console.error('=== THIS MONTH\'S SALES ERROR ===');
            console.error(xhr.responseText);
            $("#ms").text('$0.00');
          }
        });

        // This Month's Profit
        $.ajax({
          type: "POST",
          url: "pharmacy_dashboard.aspx/month_profit",
          contentType: "application/json; charset=utf-8",
          dataType: "json",
          success: function (r) {
            var now = new Date();
            var localDate = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0') + '-' + String(now.getDate()).padStart(2, '0');
            var localMonth = now.getFullYear() + '-' + String(now.getMonth() + 1).padStart(2, '0');
            
            console.log('=== THIS MONTH\'S PROFIT DEBUG ===');
            console.log('Client Local Date:', localDate);
            console.log('Client Local Month:', localMonth);
            console.log('Server Month (GETDATE): Using server\'s current month (may differ from client)');
            console.log('Total Profit:', r.d[0].total);
            console.log('Formatted:', '$' + parseFloat(r.d[0].total).toFixed(2));
            $("#mp").text('$' + parseFloat(r.d[0].total).toFixed(2));
          },
          error: function (xhr, status, error) {
            console.error('=== THIS MONTH\'S PROFIT ERROR ===');
            console.error(xhr.responseText);
            $("#mp").text('$0.00');
          }
        });

        // Load Expiry Table
        loadExpiryTable();
      });

      function loadExpiryTable() {
        $.ajax({
          type: "POST",
          url: "pharmacy_dashboard.aspx/getExpiryList",
          contentType: "application/json; charset=utf-8",
          dataType: "json",
          success: function (r) {
            $("#expiryTableBody").empty();
            for (var i = 0; i < r.d.length; i++) {
              var item = r.d[i];
              var daysRemaining = parseInt(item.days_remaining);
              var statusClass = daysRemaining < 0 ? 'danger' : (daysRemaining <= 30 ? 'warning' : 'info');
              var statusText = daysRemaining < 0 ? 'Expired' : (daysRemaining <= 30 ? 'Expiring Soon' : 'OK');

              $("#expiryTableBody").append(
                '<tr class="table-' + statusClass + '">' +
                '<td>' + item.medicine_name + '</td>' +
                '<td>' + item.batch_number + '</td>' +
                '<td>' + item.expiry_date + '</td>' +
                '<td>' + (daysRemaining < 0 ? '<strong>Expired</strong>' : daysRemaining + ' days') + '</td>' +
                '<td>' + item.primary_quantity + '</td>' +
                '<td><span class="badge bg-' + statusClass + '">' + statusText + '</span></td>' +
                '</tr>'
              );
            }
          },
          error: function (xhr, status, error) {
            console.error(xhr.responseText);
          }
        });
      }
    </script>
  </asp:Content>