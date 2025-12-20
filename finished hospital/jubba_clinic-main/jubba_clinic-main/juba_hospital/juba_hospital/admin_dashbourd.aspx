<%@ Page Title="" Language="C#" MasterPageFile="~/Admin.Master" AutoEventWireup="true" CodeBehind="admin_dashbourd.aspx.cs" Inherits="juba_hospital.admin_dashbourd" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .revenue-card-clickable {
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .revenue-card-clickable:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.3) !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
                <div class="row">
              <div class="col-sm-6 col-md-3">
                <div class="card card-stats card-round">
                  <div class="card-body">
                    <div class="row align-items-center">
                      <div class="col-icon">
                        <div
                          class="icon-big text-center icon-primary bubble-shadow-small"
                        >
                          <i class="fas fa-users"></i>
                        </div>
                      </div>
                      <div class="col col-stats ms-3 ms-sm-0">
                        <div class="numbers">
                          <p class="card-category">Doctors</p>
                          <h4 class="card-title"><span id="td"></span></h4>
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
                        <div
                          class="icon-big text-center icon-info bubble-shadow-small"
                        >
                          <i class="fas fa-user-check"></i>
                        </div>
                      </div>
                      <div class="col col-stats ms-3 ms-sm-0">
                        <div class="numbers">
                          <p class="card-category">In Patients </p>
                          <h4 class="card-title"><span id="ip"></span></h4>
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
                        <div
                          class="icon-big text-center icon-success bubble-shadow-small"
                        >
                          <i class="fas fa-luggage-cart"></i>
                        </div>
                      </div>
                      <div class="col col-stats ms-3 ms-sm-0">
                        <div class="numbers">
                          <p class="card-category">Out Patients</p>
                          <h4 class="card-title"><span id="op"></span></h4>
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
                        <div
                          class="icon-big text-center icon-secondary bubble-shadow-small"
                        >
                          <i class="fas fa-dollar-sign"></i>
                        </div>
                      </div>
                      <div class="col col-stats ms-3 ms-sm-0">
                        <div class="numbers">
                          <p class="card-category">Total Revenue (Today)</p>
                          <h4 class="card-title">$<span id="total_revenue"></span></h4>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Revenue Breakdown Section -->
            <div class="row mt-4">
              <div class="col-md-12">
                <div class="card">
                  <div class="card-header">
                    <div class="d-flex align-items-center">
                      <h4 class="card-title">Revenue Dashboard</h4>
                      <button class="btn btn-primary btn-round ms-auto" onclick="window.location.href='financial_reports.aspx'">
                        <i class="fa fa-chart-line"></i> Detailed Reports
                      </button>
                    </div>
                  </div>
                  <div class="card-body">
                    <!-- First Row: Registration, Lab, X-Ray, Pharmacy -->
                    <div class="row">
                      <div class="col-md-3">
                        <a href="registration_revenue_report.aspx" style="text-decoration: none;">
                        <div class="card card-stats card-primary card-round revenue-card-clickable">
                          <div class="card-body">
                            <div class="row">
                              <div class="col-3">
                                <div class="icon-big text-center">
                                  <i class="fas fa-user-plus"></i>
                                </div>
                              </div>
                              <div class="col-9 col-stats">
                                <div class="numbers">
                                  <p class="card-category">Registration</p>
                                  <h4 class="card-title">$<span id="reg_revenue"></span></h4>
                                  <small class="text-white"><i class="fas fa-arrow-right"></i> Click for details</small>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        </a>
                      </div>
                      <div class="col-md-3">
                        <a href="lab_revenue_report.aspx" style="text-decoration: none;">
                        <div class="card card-stats card-info card-round revenue-card-clickable">
                          <div class="card-body">
                            <div class="row">
                              <div class="col-3">
                                <div class="icon-big text-center">
                                  <i class="fas fa-flask"></i>
                                </div>
                              </div>
                              <div class="col-9 col-stats">
                                <div class="numbers">
                                  <p class="card-category">Lab Tests</p>
                                  <h4 class="card-title">$<span id="lab_revenue"></span></h4>
                                  <small class="text-white"><i class="fas fa-arrow-right"></i> Click for details</small>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        </a>
                      </div>
                      <div class="col-md-3">
                        <a href="xray_revenue_report.aspx" style="text-decoration: none;">
                        <div class="card card-stats card-success card-round revenue-card-clickable">
                          <div class="card-body">
                            <div class="row">
                              <div class="col-3">
                                <div class="icon-big text-center">
                                  <i class="fas fa-x-ray"></i>
                                </div>
                              </div>
                              <div class="col-9 col-stats">
                                <div class="numbers">
                                  <p class="card-category">X-Ray</p>
                                  <h4 class="card-title">$<span id="xray_revenue"></span></h4>
                                  <small class="text-white"><i class="fas fa-arrow-right"></i> Click for details</small>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        </a>
                      </div>
                      <div class="col-md-3">
                        <a href="pharmacy_revenue_report.aspx" style="text-decoration: none;">
                        <div class="card card-stats card-warning card-round revenue-card-clickable">
                          <div class="card-body">
                            <div class="row">
                              <div class="col-3">
                                <div class="icon-big text-center">
                                  <i class="fas fa-capsules"></i>
                                </div>
                              </div>
                              <div class="col-9 col-stats">
                                <div class="numbers">
                                  <p class="card-category">Pharmacy</p>
                                  <h4 class="card-title">$<span id="pharmacy_revenue"></span></h4>
                                  <small class="text-white"><i class="fas fa-arrow-right"></i> Click for details</small>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        </a>
                      </div>
                    </div>

                    <!-- Second Row: Bed and Delivery -->
                    <div class="row mt-3">
                      <div class="col-md-3">
                        <a href="bed_revenue_report.aspx" style="text-decoration: none;">
                        <div class="card card-stats card-danger card-round revenue-card-clickable">
                          <div class="card-body">
                            <div class="row">
                              <div class="col-3">
                                <div class="icon-big text-center">
                                  <i class="fas fa-bed"></i>
                                </div>
                              </div>
                              <div class="col-9 col-stats">
                                <div class="numbers">
                                  <p class="card-category">Bed Charges</p>
                                  <h4 class="card-title">$<span id="bed_revenue"></span></h4>
                                  <small class="text-white"><i class="fas fa-arrow-right"></i> Click for details</small>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        </a>
                      </div>
                      <div class="col-md-3">
                        <a href="delivery_revenue_report.aspx" style="text-decoration: none;">
                        <div class="card card-stats card-secondary card-round revenue-card-clickable">
                          <div class="card-body">
                            <div class="row">
                              <div class="col-3">
                                <div class="icon-big text-center">
                                  <i class="fas fa-baby"></i>
                                </div>
                              </div>
                              <div class="col-9 col-stats">
                                <div class="numbers">
                                  <p class="card-category">Delivery Charges</p>
                                  <h4 class="card-title">$<span id="delivery_revenue"></span></h4>
                                  <small class="text-white"><i class="fas fa-arrow-right"></i> Click for details</small>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                        </a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>


          <script src="assets/js/plugin/datatables/datatables.min.js"></script>
<script src="Scripts/jquery-3.4.1.min.js"></script>
    <script>
        $(document).ready(function () {
            // Load revenue data
            loadRevenueData();
        });

        function loadRevenueData() {
            $.ajax({
                type: "POST",
                url: "admin_dashbourd.aspx/GetTodayRevenue",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    console.log(r);
                    if (r.d && r.d.length > 0) {
                        var data = r.d[0];
                        $("#total_revenue").text(parseFloat(data.total_revenue || 0).toFixed(2));
                        $("#reg_revenue").text(parseFloat(data.registration_revenue || 0).toFixed(2));
                        $("#lab_revenue").text(parseFloat(data.lab_revenue || 0).toFixed(2));
                        $("#xray_revenue").text(parseFloat(data.xray_revenue || 0).toFixed(2));
                        $("#pharmacy_revenue").text(parseFloat(data.pharmacy_revenue || 0).toFixed(2));
                        $("#bed_revenue").text(parseFloat(data.bed_revenue || 0).toFixed(2));
                        $("#delivery_revenue").text(parseFloat(data.delivery_revenue || 0).toFixed(2));
                    }
                },
                error: function (xhr, status, error) {
                    console.error(xhr.responseText);
                }
            });
        }
        $(document).ready(function () {
            // When the first dropdown changes



            $.ajax({
                type: "POST",
                url: "admin_dashbourd.aspx/op_patients",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    console.log(r);
                    var earnings = r.d; // Assuming it's an array
                    var total = earnings[0].op_patients; // Accessing the total property of the first element

                    $("#op").text(total); // Update the text content of the label with the total value

                },
                error: function (xhr, status, error) {
                    console.error(xhr.responseText);
                }
            });

        });
        $(document).ready(function () {
            // When the first dropdown changes



            $.ajax({
                type: "POST",
                url: "admin_dashbourd.aspx/inpatient",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    console.log(r);
                    var earnings = r.d; // Assuming it's an array
                    var total = earnings[0].in_patients; // Accessing the total property of the first element

                    $("#ip").text(total); // Update the text content of the label with the total value

                },
                error: function (xhr, status, error) {
                    console.error(xhr.responseText);
                }
            });

        });

        $(document).ready(function () {
            // When the first dropdown changes



            $.ajax({
                type: "POST",
                url: "admin_dashbourd.aspx/doctors",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (r) {
                    console.log(r);
                    var earnings = r.d; // Assuming it's an array
                    var total = earnings[0].inpatient; // Accessing the total property of the first element

                    $("#td").text(total); // Update the text content of the label with the total value

                },
                error: function (xhr, status, error) {
                    console.error(xhr.responseText);
                }
            });

        });
    </script>
</asp:Content>
