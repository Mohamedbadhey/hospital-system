<%@ Page Title="" Language="C#" MasterPageFile="~/doctor.Master" AutoEventWireup="true" CodeBehind="assignmed.aspx.cs"
    Inherits="juba_hospital.assignmed" %>
    <asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
        <link rel="stylesheet" type="text/css"
            href="https://cdn.datatables.net/2.0.8/css/dataTables.dataTables.min.css">
        <link rel="stylesheet" type="text/css"
            href="https://cdn.datatables.net/buttons/2.2.3/css/buttons.dataTables.min.css">
        <style>
            /* Custom table styling */
            .dataTables_wrapper .dataTables_filter {
                float: right;
                text-align: right;
            }

            .dataTables_wrapper .dataTables_length {
                float: left;
            }

            .dataTables_wrapper .dataTables_paginate {
                float: right;
                text-align: right;
            }

            .dataTables_wrapper .dataTables_info {
                float: left;
            }

            #datatable {
                width: 100%;
                margin: 20px 0;
                font-size: 19px;
                font-weight: bold;
            }

            #datatable th,
            #datatable td {
                text-align: center;
                vertical-align: middle;
            }

            #datatable th {
                background-color: #007bff;
                color: white;
                font-weight: bold;
            }

            #datatable td {
                background-color: #f8f9fa;
            }

            .btn-primary {
                background-color: #007bff;
                border-color: #007bff;
            }

            .btn-primary:hover {
                background-color: #0056b3;
                border-color: #004085;
            }

            .btn-success {
                background-color: #28a745;
                border-color: #28a745;
            }

            .btn-success:hover {
                background-color: #218838;
                border-color: #1e7e34;
            }

            /* Custom hover styles for pagination buttons */
            .dataTables_wrapper .dataTables_paginate .paginate_button {
                padding: 0.5em 1em;
                margin-left: 0.5em;
                color: #007bff;
                background-color: white;
                border: 1px solid #ddd;
            }

            .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
                color: white;
                background-color: #007bff;
                border: 1px solid #007bff;
                cursor: pointer;
            }

            .dataTables_wrapper .dataTables_paginate .paginate_button.current {
                color: white;
                background-color: #007bff;
                border: 1px solid #007bff;
            }

            /* Transaction Status Styling */
            .transaction-status-select {
                font-weight: bold;
                padding: 5px 10px;
                border-radius: 5px;
                border: none;
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .transaction-status-select:hover {
                opacity: 0.9;
                transform: scale(1.02);
            }

            .transaction-status-select:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }

            .transaction-status-select option {
                background-color: white;
                color: black;
                font-weight: normal;
                padding: 5px;
            }

            /* Lab Order Card Styling */
            .lab-order-card {
                margin-bottom: 20px;
                border: 1px solid #e9ecef;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .lab-order-card:hover {
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }

            .lab-order-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 15px;
                border-radius: 7px 7px 0 0;
                cursor: pointer;
                display: flex;
                justify-content: between;
                align-items: center;
            }

            .lab-order-body {
                padding: 0;
                display: none;
            }

            .lab-order-body.show {
                display: block;
            }

            .ordered-tests-section {
                background-color: #f8f9fa;
                padding: 15px;
                border-bottom: 1px solid #dee2e6;
            }

            .test-results-section {
                padding: 15px;
            }

            .test-badge {
                display: inline-block;
                background-color: #007bff;
                color: white;
                padding: 4px 8px;
                margin: 2px;
                border-radius: 12px;
                font-size: 0.8em;
            }

            .result-item {
                display: flex;
                justify-content: space-between;
                padding: 8px 0;
                border-bottom: 1px solid #f1f3f4;
            }

            .result-item:last-child {
                border-bottom: none;
            }

            .result-name {
                font-weight: 600;
                color: #495057;
            }

            .result-value {
                color: #28a745;
                font-weight: 500;
            }

            .payment-status {
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 0.85em;
                font-weight: 600;
            }

            .payment-status.paid {
                background-color: #d4edda;
                color: #155724;
            }

            .payment-status.unpaid {
                background-color: #f8d7da;
                color: #721c24;
            }

            .toggle-icon {
                transition: transform 0.3s ease;
            }

            .toggle-icon.rotated {
                transform: rotate(180deg);
            }

            /* Comprehensive Responsive Design for All Devices */
            
            /* Base responsive styles */
            .container-fluid {
                padding: 10px;
            }

            /* Header responsiveness */
            .page-header {
                text-align: center;
                margin-bottom: 20px;
            }

            .page-header h1 {
                font-size: 1.8rem;
                margin-bottom: 10px;
            }

            /* Card responsiveness */
            .card {
                margin-bottom: 20px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                border: none;
                border-radius: 8px;
            }

            .card-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border-radius: 8px 8px 0 0 !important;
                padding: 15px 20px;
            }

            .card-body {
                padding: 20px;
            }

            /* Table wrapper responsive */
            .table-responsive {
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                margin-bottom: 20px;
            }

            /* DataTable responsive enhancements */
            .dataTables_wrapper {
                padding: 0;
            }

            /* Search filters styling */
            #search-filters {
                background: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 15px;
                border: 1px solid #e9ecef;
            }

            #search-filters .form-label {
                font-weight: 600;
                color: #495057;
                margin-bottom: 5px;
                font-size: 13px;
            }

            #search-filters .form-select {
                border: 1px solid #ced4da;
                border-radius: 5px;
                padding: 6px 10px;
                font-size: 14px;
            }

            #search-filters .form-select:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            }

            /* DataTable search box enhancements */
            .dataTables_filter {
                margin-bottom: 10px;
            }

            .dataTables_filter label {
                font-weight: 600;
                color: #495057;
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
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
                outline: none;
            }

            /* Button enhancements */
            .dt-buttons {
                margin-bottom: 10px;
            }

            .dt-button {
                background: #667eea !important;
                border: none !important;
                color: white !important;
                padding: 8px 16px !important;
                border-radius: 5px !important;
                margin-right: 8px !important;
                font-size: 13px !important;
                font-weight: 500 !important;
            }

            .dt-button:hover {
                background: #5a6fd8 !important;
                transform: translateY(-1px);
            }

            .dataTables_length,
            .dataTables_filter {
                margin-bottom: 15px;
            }

            .dataTables_info,
            .dataTables_paginate {
                margin-top: 15px;
            }

            /* Button responsiveness */
            .btn {
                margin: 2px;
                white-space: nowrap;
                border-radius: 6px;
                transition: all 0.3s ease;
            }

            .btn:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }

            /* Modal responsiveness */
            .modal-dialog {
                margin: 10px;
            }

            .modal-content {
                border-radius: 10px;
                border: none;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            }

            /* Form controls responsiveness */
            .form-control, .form-select {
                border-radius: 6px;
                border: 1px solid #ddd;
                padding: 10px 12px;
                transition: all 0.3s ease;
            }

            .form-control:focus, .form-select:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            }

            /* Tablet styles (768px - 1024px) */
            @media (max-width: 1024px) {
                .container-fluid {
                    padding: 15px;
                }

                .card-body {
                    padding: 15px;
                }

                /* Adjust table for tablets */
                table.dataTable {
                    font-size: 14px;
                }

                .dataTables_length,
                .dataTables_filter {
                    text-align: center;
                    margin-bottom: 10px;
                }

                .dataTables_info,
                .dataTables_paginate {
                    text-align: center;
                    margin-top: 10px;
                }

                /* Stack buttons vertically on smaller tablets */
                .btn-group-vertical .btn {
                    margin-bottom: 5px;
                }
            }

            /* Mobile styles (up to 768px) */
            @media (max-width: 768px) {
                /* Hide regular table and show mobile-friendly version */
                #datatable_wrapper,
                #datatable,
                table#datatable,
                .dataTables_wrapper {
                    display: none !important;
                }

                /* Show mobile cards container */
                .mobile-view {
                    display: block !important;
                }

                .page-header h1 {
                    font-size: 1.5rem;
                }

                .container-fluid {
                    padding: 10px;
                }

                .card {
                    margin-bottom: 15px;
                }

                .card-body {
                    padding: 15px;
                }

                /* Mobile navigation adjustments */
                .navbar-nav {
                    text-align: center;
                }

                .navbar-nav .nav-link {
                    padding: 10px;
                }

                /* Form adjustments for mobile */
                .form-control, .form-select {
                    font-size: 16px; /* Prevents zoom on iOS */
                    padding: 12px;
                }

                .btn {
                    padding: 10px 15px;
                    font-size: 14px;
                    width: 100%;
                    margin-bottom: 10px;
                }

                .btn-sm {
                    padding: 8px 12px;
                    font-size: 13px;
                }

                /* Modal adjustments for mobile */
                .modal-dialog {
                    margin: 5px;
                    width: calc(100% - 10px);
                }

                .modal-header {
                    padding: 15px;
                }

                .modal-body {
                    padding: 15px;
                }

                .modal-footer {
                    padding: 10px 15px;
                    flex-direction: column;
                }

                .modal-footer .btn {
                    width: 100%;
                    margin: 5px 0;
                }
            }

            /* Small mobile styles (up to 480px) */
            @media (max-width: 480px) {
                .page-header h1 {
                    font-size: 1.3rem;
                }

                .container-fluid {
                    padding: 8px;
                }

                .card-header {
                    padding: 12px 15px;
                    font-size: 14px;
                }

                .card-body {
                    padding: 12px;
                }

                .btn {
                    padding: 12px;
                    font-size: 13px;
                }

                /* Even more compact forms for small screens */
                .form-control, .form-select {
                    padding: 14px 12px;
                }

                .modal-dialog {
                    margin: 0;
                    width: 100%;
                    height: 100%;
                }

                .modal-content {
                    height: 100%;
                    border-radius: 0;
                }
            }

            /* Mobile Cards Styles */
            .mobile-view {
                display: none;
            }

            .mobile-search {
                margin-bottom: 15px;
            }

            .mobile-search input {
                width: 100%;
                padding: 12px 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
                background: white;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .mobile-search input:focus {
                border-color: #667eea;
                outline: none;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.2);
            }

            .patient-mobile-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                margin-bottom: 15px;
                overflow: hidden;
                transition: all 0.3s ease;
                border: 1px solid #f0f0f0;
            }

            .patient-mobile-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            .patient-mobile-card.expanded {
                box-shadow: 0 8px 25px rgba(0,0,0,0.2);
            }

            .mobile-card-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 15px 20px;
                cursor: pointer;
                position: relative;
            }

            .mobile-card-header:hover {
                background: linear-gradient(135deg, #5a6fd8 0%, #6a4190 100%);
            }

            .patient-name-mobile {
                font-size: 18px;
                font-weight: bold;
                margin: 0 0 5px 0;
            }

            .patient-info-brief {
                font-size: 14px;
                opacity: 0.9;
                margin: 0;
            }

            .expand-icon {
                position: absolute;
                right: 20px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 16px;
                transition: transform 0.3s ease;
            }

            .patient-mobile-card.expanded .expand-icon {
                transform: translateY(-50%) rotate(180deg);
            }

            .mobile-card-body {
                padding: 0;
                max-height: 0;
                overflow: hidden;
                transition: all 0.3s ease;
            }

            .patient-mobile-card.expanded .mobile-card-body {
                max-height: 1000px;
                padding: 20px;
                overflow-y: auto;
                -webkit-overflow-scrolling: touch;
            }

            .mobile-info-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                margin-bottom: 20px;
            }

            .mobile-info-item {
                background: #f8f9fa;
                padding: 12px;
                border-radius: 8px;
                border-left: 4px solid #667eea;
            }

            .mobile-info-label {
                font-size: 12px;
                font-weight: 600;
                color: #666;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 4px;
            }

            .mobile-info-value {
                font-size: 14px;
                color: #333;
                font-weight: 500;
            }

            .mobile-actions {
                border-top: 1px solid #f0f0f0;
                padding-top: 15px;
                display: flex;
                flex-wrap: wrap;
                gap: 10px;
            }

            .mobile-actions .btn {
                flex: 1;
                min-width: 120px;
                margin: 0;
            }

            @media (max-width: 480px) {
                .mobile-info-grid {
                    grid-template-columns: 1fr;
                    gap: 10px;
                }

                .mobile-actions {
                    flex-direction: column;
                }

                .mobile-actions .btn {
                    width: 100%;
                }
            }


        </style>
        <style>
            .hidden {
                display: none;
            }
        </style>
        <style>
            .hidden {
                display: none;
            }
        </style>
        <style>
            .col-4 {
                width: 33.33%;
                /* Assuming col-4 means 4 columns in a 12-column layout */
                float: left;
                padding: 10px;
                /* Optional padding for spacing */
            }

            img {
                width: 90%;
                height: 90%;
                object-fit: cover;
                /* Ensures the image covers the area without distortion */
            }

            h1 {
                text-align: center;
                /* Centers the heading */
            }
        </style>
        <%--<style>
            .report-content {
            border: 3px solid black;
            padding: 0;
            box-shadow: 10px 10px 10px #888888;
            margin: 5px;
            width: 100%;
            }

            .report-header {
            border: 0;
            height: 150px;
            width: 100%;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            }

            .report-header img {
            max-height: 100%;
            width: auto;
            }

            .patient-details hr {
            border: 1px solid black;
            }

            .report-body {
            border: 0;
            font-size: 16px;
            overflow: auto;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            }

            table {
            width: 100%;
            border-collapse: collapse;
            table-layout: auto;
            }

            th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
            box-sizing: border-box;
            }

            th {
            background-color: #f2f2f2;
            text-transform: uppercase;
            }

            .report-sign {
            border: 0;
            height: 100px;
            margin: 30px 30px;
            }

            .report-footer {
            border: 0;
            height: 150px;
            }

            .lab-doctor-sign {
            float: right;
            }

            .report-sign img {
            height: 50px;
            width: 100px;
            display: inline-block;
            }

            .lab-incharge-sign {
            display: inline-block;
            }

            .align-left {
            text-align: left;
            padding: 10px;
            }

            /* Global styles */
            body {
            font-size: 16px;
            }

            .report-content {
            width: 100%;
            padding: 1rem;
            font-size: 1rem;
            }

            @media print {
            @page {
            size: A4;
            margin: 10mm;
            }

            body * {
            visibility: hidden;
            }

            .report-content, .report-content * {
            visibility: visible;
            }

            .report-content {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            padding: 1rem;
            font-size: 1.2rem;
            }

            .report-body {
            margin-top: 1rem;
            }

            table {
            width: 100%;
            margin-bottom: 1rem;
            }

            th, td {
            padding: 0.5rem;
            }

            .report-header img, .report-sign img {
            display: block;
            width: 100%;
            max-width: 100%;
            height: auto;
            }

            #print-button1 {
            display: none;
            }
            }
            </style>--%>
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        <!-- Hidden field to store doctor ID from session -->
        <asp:HiddenField ID="hdnDoctorId" runat="server" />

        <!-- Modal -->
        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog modal-fullscreen">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <div class="d-flex align-items-center">
                            <i class="fa fa-user-md fa-2x me-3"></i>
                            <div>
                                <h1 class="modal-title fs-4 mb-0" id="staticBackdropLabel">Patient Care Management</h1>
                                <small class="text-white-50">Assign medications, order tests, and manage patient care</small>
                            </div>
                        </div>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-0">
                        <input style="display:none" id="id11" />
                        <input style="display:none" id="pid" />
                        
                        <!-- Modern Tab Navigation -->
                        <ul class="nav nav-tabs nav-fill border-bottom-0" id="patientCareTabs" role="tablist" style="background: linear-gradient(to right, #f8f9fa, #e9ecef);">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="medication-tab" data-bs-toggle="tab" data-bs-target="#medication-pane" type="button" role="tab">
                                    <i class="fa fa-pills fa-lg"></i><br>
                                    <span class="fw-bold">Medications</span>
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="lab-tab" data-bs-toggle="tab" data-bs-target="#lab-pane" type="button" role="tab" onclick="onLabTabClick()">
                                    <i class="fa fa-flask fa-lg"></i><br>
                                    <span class="fw-bold">Lab Tests</span>
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="xray-tab" data-bs-toggle="tab" data-bs-target="#xray-pane" type="button" role="tab">
                                    <i class="fa fa-x-ray fa-lg"></i><br>
                                    <span class="fw-bold">Imaging</span>
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="patient-type-tab" data-bs-toggle="tab" data-bs-target="#patient-type-pane" type="button" role="tab">
                                    <i class="fa fa-hospital-user fa-lg"></i><br>
                                    <span class="fw-bold">Patient Type</span>
                                </button>
                            </li>
                        </ul>

                        <!-- Tab Content -->
                        <div class="tab-content p-4" id="patientCareTabContent">
                            
                            <!-- MEDICATION TAB -->
                            <div class="tab-pane fade show active" id="medication-pane" role="tabpanel">
                                <div class="card border-0 shadow-sm">
                                    <div class="card-header bg-gradient text-white" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                                        <h5 class="mb-0"><i class="fa fa-pills me-2"></i>Medication Management</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <!-- Left Column: Medication Form -->
                                            <div class="col-md-4">
                                                <h6 class="text-muted mb-3"><i class="fa fa-prescription-bottle me-2"></i>Prescription Details</h6>
                                <div class="mb-3">
                                    <label for="name" class="form-label">Medication Name</label>
                                    <input type="text" class="form-control" id="name" placeholder="Enter Name">
                                    <small id="nameError" class="text-danger"></small>
                                </div>

                                <div class="mb-3">
                                    <label for="dosage" class="form-label">Dosage</label>
                                    <input type="text" class="form-control" id="dosage" placeholder="Enter Dosage">
                                    <small id="dosageError" class="text-danger"></small>
                                </div>

                                <div class="mb-3">
                                    <label for="frequency" class="form-label">Frequency</label>
                                    <input type="text" class="form-control" id="frequency"
                                        placeholder="Enter Frequency">
                                    <small id="frequencyError" class="text-danger"></small>
                                </div>

                                <div class="mb-3">
                                    <label for="duration" class="form-label">Duration</label>
                                    <input type="text" class="form-control" id="duration" placeholder="Enter Duration">
                                    <small id="durationError" class="text-danger"></small>
                                </div>

                                <div class="mb-3">
                                    <label for="inst" class="form-label">Special Instruction</label>
                                    <textarea class="form-control" id="inst7" rows="3"></textarea>
                                    <small id="instError5" class="text-danger"></small>
                                </div>
                                
                                <div class="d-grid gap-2 mt-4">
                                    <button type="button" class="btn btn-primary btn-lg" onclick="submitInfo()">
                                        <i class="fa fa-plus-circle me-2"></i>Add Medication
                                    </button>
                                </div>
                            </div>

                            <!-- Right Column: Medication List & Report -->
                            <div class="col-md-8">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6 class="text-muted mb-0"><i class="fa fa-list me-2"></i>Prescribed Medications</h6>
                                    <button class="btn btn-sm btn-outline-success" onclick="showmedic()">
                                        <i class="fa fa-print me-1"></i>View Report
                                    </button>
                                </div>

                                <!-- Medication table will be displayed here -->
                                <div class="table-responsive">
                                    <table class="table table-hover" id="medicationTable">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Medication</th>
                                                <th>Dosage</th>
                                                <th>Frequency</th>
                                                <th>Duration</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- Medications will be added here dynamically -->
                                        </tbody>
                                    </table>
                                </div>
                                
                                <!-- Lab Test Results have been moved to Lab Tests tab -->
                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- End Medication Tab -->

                            <!-- LAB TESTS TAB -->
                            <div class="tab-pane fade" id="lab-pane" role="tabpanel">
                                <div class="card border-0 shadow-sm">
                                    <div class="card-header bg-gradient text-white" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                                        <h5 class="mb-0"><i class="fa fa-flask me-2"></i>Laboratory Tests</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="d-flex gap-2 mb-3">
                                            <button class="btn btn-success" id="sendlab" onclick="showlab()">
                                                <i class="fa fa-paper-plane me-1"></i>Send to Lab
                                            </button>
                                            <button class="btn btn-info" id="editlab1" onclick="checkLabOrderBeforeEdit()">
                                                <i class="fa fa-edit me-1"></i>Edit Lab Order
                                            </button>
                                        </div>
                                        <div id="labOrderWarning" class="alert alert-warning" style="display: none;">
                                            <i class="fa fa-lock"></i> <strong>Cannot Edit:</strong> Lab charges have been paid. Orders cannot be edited or deleted once payment is received.
                                        </div>
                                        
                                        <!-- Lab Orders with Test Details and Results -->
                                        <div class="mt-4">
                                            <h6 class="text-muted mb-3"><i class="fa fa-list me-2"></i>Lab Orders with Tests & Results</h6>
                                            <div id="labOrdersContainer">
                                                <div class="alert alert-info text-center">
                                                    <i class="fa fa-info-circle"></i> No lab orders found. Click "Send to Lab" to create one.
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <!-- Lab Results Print Button -->
                                        <div class="mb-3 mt-4">
                                            <button class="btn btn-outline-success btn-lg w-100" onclick="showLabReport()">
                                                <i class="fa fa-print me-2"></i>View Laboratory Report
                                            </button>
                                            <small class="text-muted d-block mt-2">
                                                <i class="fa fa-info-circle"></i> Opens lab results in a professional print-ready format
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- End Lab Tests Tab -->

                            <!-- IMAGING TAB -->
                            <div class="tab-pane fade" id="xray-pane" role="tabpanel">
                                <div class="card border-0 shadow-sm">
                                    <div class="card-header bg-gradient text-white" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                                        <h5 class="mb-0"><i class="fa fa-x-ray me-2"></i>Imaging & X-Ray</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="d-flex gap-2 mb-3">
                                            <button class="btn btn-success" id="sendxry" onclick="sendxray()">
                                                <i class="fa fa-paper-plane me-1"></i>Send to Imaging
                                            </button>
                                            <button class="btn btn-info" id="editxry" onclick="updatexry()">
                                                <i class="fa fa-edit me-1"></i>Edit Imaging Order
                                            </button>
                                        </div>
                                        
                                        <div class="row mt-3">
                                            <div class="col-md-12">
                                                <h6 class="text-muted mb-2">Image Results</h6>
                                                <label class="h5 text-primary" id="imgtype"></label>
                                                <div class="border rounded p-3 bg-light text-center">
                                                    <img src="" id="img" class="img-fluid" style="max-height: 500px;" alt="X-ray Image" />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- End Imaging Tab -->

                            <!-- PATIENT TYPE TAB -->
                            <div class="tab-pane fade" id="patient-type-pane" role="tabpanel">
                                <div class="card border-0 shadow-sm">
                                    <div class="card-header bg-gradient text-white" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                                        <h5 class="mb-0"><i class="fa fa-hospital-user me-2"></i>Patient Type Management</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="alert alert-info">
                                                    <i class="fa fa-info-circle me-2"></i>
                                                    <strong>Patient Type:</strong> Select whether this patient is an outpatient or inpatient.
                                                    Inpatients will have bed charges calculated automatically.
                                                </div>

                                                <div class="card mb-4">
                                                    <div class="card-body">
                                                        <h6 class="card-title mb-3">Current Patient Status</h6>
                                                        <div id="currentPatientTypeDisplay" class="alert alert-secondary">
                                                            <strong>Current Type:</strong> <span id="currentTypeText">Not Set</span>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="card">
                                                    <div class="card-body">
                                                        <h6 class="card-title mb-4">Select Patient Type</h6>
                                                        
                                                        <div class="row g-3">
                                                            <div class="col-md-6">
                                                                <div class="form-check p-3 border rounded" style="cursor: pointer;" onclick="selectPatientType('outpatient')">
                                                                    <input class="form-check-input" type="radio" name="patientTypeRadio" id="outpatientRadio" value="0">
                                                                    <label class="form-check-label ms-2" for="outpatientRadio" style="cursor: pointer;">
                                                                        <h5><i class="fa fa-walking text-success me-2"></i>Outpatient</h5>
                                                                        <p class="text-muted mb-0">Patient visits for consultation, diagnosis, or treatment without overnight stay.</p>
                                                                    </label>
                                                                </div>
                                                            </div>

                                                            <div class="col-md-6">
                                                                <div class="form-check p-3 border rounded" style="cursor: pointer;" onclick="selectPatientType('inpatient')">
                                                                    <input class="form-check-input" type="radio" name="patientTypeRadio" id="inpatientRadio" value="1">
                                                                    <label class="form-check-label ms-2" for="inpatientRadio" style="cursor: pointer;">
                                                                        <h5><i class="fa fa-bed text-primary me-2"></i>Inpatient</h5>
                                                                        <p class="text-muted mb-0">Patient requires admission and overnight stay. Bed charges will apply.</p>
                                                                    </label>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <div id="inpatientDetailsSection" class="mt-4" style="display: none;">
                                                            <div class="alert alert-warning">
                                                                <i class="fa fa-exclamation-triangle me-2"></i>
                                                                <strong>Note:</strong> Selecting Inpatient will start bed charge tracking from the admission date.
                                                            </div>
                                                            <div class="mb-3">
                                                                <label class="form-label"><strong>Admission Date:</strong></label>
                                                                <input type="datetime-local" class="form-control" id="admissionDateInput" />
                                                            </div>
                                                        </div>

                                                        <div class="mt-4">
                                                            <button type="button" class="btn btn-primary btn-lg" onclick="updatePatientType()">
                                                                <i class="fa fa-save me-2"></i>Save Patient Type
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- End Patient Type Tab -->

                        </div>
                        <!-- End Tab Content -->
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="fa fa-times me-1"></i>Close
                        </button>
                        <!-- Submit All button removed - medications are added individually with "Add Medication" button -->
                    </div>
                </div>
            </div>
        </div>



        <!-- Modal -->
        <div class="modal fade" id="medmodal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="staticBackdropLabel1">Add Medication </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input style="display:none" id="id1111" />

                        <div class="mb-3">
                            <label for="name" class="form-label">Medication Name</label>
                            <input type="text" class="form-control" id="name1" placeholder="Enter Name">
                            <small id="nameError1" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label for="dosage" class="form-label">Dosage</label>
                            <input type="text" class="form-control" id="dosage1" placeholder="Enter Dosage">
                            <small id="dosageError1" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label for="frequency" class="form-label">Frequency</label>
                            <input type="text" class="form-control" id="frequency1" placeholder="Enter Frequency">
                            <small id="frequencyError1" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label for="duration" class="form-label">Duration</label>
                            <input type="text" class="form-control" id="duration1" placeholder="Enter Duration">
                            <small id="durationError11" class="text-danger"></small>
                        </div>

                        <div class="mb-3">
                            <label for="inst" class="form-label">Special Instruction</label>
                            <textarea class="form-control" id="inst1" rows="3"></textarea>
                            <small id="instError1" class="text-danger"></small>
                        </div>
                    </div>





                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" onclick="deletejob()" class="btn btn-danger">delete</button>
                        <button type="button" onclick="update()" class="btn btn-primary">update</button>

                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h4 class="card-title">Assign Medication</h4>
                    </div>
                    <div class="card-body">
                        <div>
                            <table class="display nowrap" style="width:100%" id="datatable">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Sex</th>
                                        <th>Location</th>
                                        <th>Phone</th>
                                        <th>Amount</th>
                                        <th>D.O.B</th>
                                        <th>Date Registered</th>
                                        <th>Lap Status</th>
                                        <th>image Status</th>
                                        <th>Transaction Status</th>
                                        <th>Operation</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <th>Name</th>
                                        <th>Sex</th>
                                        <th>Location</th>
                                        <th>Phone</th>
                                        <th>Amount</th>
                                        <th>D.O.B</th>
                                        <th>Date Registered</th>
                                        <th>Lap Status</th>
                                        <th>image Status</th>
                                        <th>Transaction Status</th>
                                        <th>Operation</th>
                                    </tr>
                                </tfoot>
                                <tbody></tbody>
                            </table>
                        </div>

                        <!-- Mobile View for Responsive Design -->
                        <div class="mobile-view">
                            <div class="mobile-search">
                                <input type="text" id="mobileSearchInput" placeholder="🔍 Search patients by name, phone, or location..." />
                            </div>
                            <div id="mobileCardsContainer">
                                <!-- Mobile cards will be populated here -->
                                <div class="text-center text-muted p-4">
                                    <i class="fas fa-spinner fa-spin"></i> Loading patients...
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


        </div>



        <!-- Modal -->
        <div class="modal fade" id="staticBackdrop11" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel111">Lab Tests</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input style="display:none" id="labid" />
                        <input style="display:none" id="medid" />
                        <div class="row">
                            <div class="col-12">
                                <h1>Lab Test Details</h1>

                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="radio21" value="0">
                                    <label class="form-check-label" for="radio2">Show Lab Tests</label>
                                </div>

                                <div id="additionalTests" class="hidden">
                                    <div class="row">
                                        <div class="col-4">
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckLDL">
                                                <label class="form-check-label" for="flexCheckLDL">
                                                    Low-density lipoprotein (LDL)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckHDL">
                                                <label class="form-check-label" for="flexCheckHDL">
                                                    High-density lipoprotein (HDL)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckTotalCholesterol">
                                                <label class="form-check-label" for="flexCheckTotalCholesterol">
                                                    Total cholesterol
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckTriglycerides">
                                                <label class="form-check-label" for="flexCheckTriglycerides">
                                                    Triglycerides
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckSodium">
                                                <label class="form-check-label" for="flexCheckSodium">
                                                    Sodium
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckPotassium">
                                                <label class="form-check-label" for="flexCheckPotassium">
                                                    Potassium
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckChloride">
                                                <label class="form-check-label" for="flexCheckChloride">
                                                    Chloride
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckCalcium">
                                                <label class="form-check-label" for="flexCheckCalcium">
                                                    Calcium
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckPhosphorous">
                                                <label class="form-check-label" for="flexCheckPhosphorous">
                                                    Phosphorous
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckMagnesium">
                                                <label class="form-check-label" for="flexCheckMagnesium">
                                                    Magnesium
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckCreatinine">
                                                <label class="form-check-label" for="flexCheckCreatinine">
                                                    Creatinine
                                                </label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckAmylase">
                                                <label class="form-check-label" for="flexCheckAmylase">
                                                    Amylase
                                                </label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckProgesteroneFemale">
                                                <label class="form-check-label" for="flexCheckProgesteroneFemale">
                                                    Progesterone (Female)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckFSH">
                                                <label class="form-check-label" for="flexCheckFSH">
                                                    Follicle stimulating hormone (FSH)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckEstradiol">
                                                <label class="form-check-label" for="flexCheckEstradiol">
                                                    Estradiol
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckLH">
                                                <label class="form-check-label" for="flexCheckLH">
                                                    Luteinizing hormone (LH)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckTestosteroneMale">
                                                <label class="form-check-label" for="flexCheckTestosteroneMale">
                                                    Testosterone (Male)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckProlactin">
                                                <label class="form-check-label" for="flexCheckProlactin">
                                                    Prolactin
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckSeminalFluidAnalysis">
                                                <label class="form-check-label" for="flexCheckSeminalFluidAnalysis">
                                                    Seminal Fluid Analysis (Male)
                                                </label>
                                            </div>
                                           <%-- <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckBHCG">
                                                <label class="form-check-label" for="flexCheckBHCG">
                                                    B-HCG
                                                </label>
                                            </div>--%>

                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckUrineExamination">
                                                <label class="form-check-label" for="flexCheckUrineExamination">
                                                    Urine examination
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckStoolExamination">
                                                <label class="form-check-label" for="flexCheckStoolExamination">
                                                    Stool examination
                                                </label>
                                            </div>

                                        </div>



                                        <div class="col-4">


                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckUricAcid">
                                                <label class="form-check-label" for="flexCheckUricAcid">
                                                    Uric acid
                                                </label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckBrucellaAbortus">
                                                <label class="form-check-label" for="flexCheckBrucellaAbortus">
                                                    Brucella abortus
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckCRP">
                                                <label class="form-check-label" for="flexCheckCRP">
                                                    C-reactive protein (CRP)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckRF">
                                                <label class="form-check-label" for="flexCheckRF">
                                                    Rheumatoid factor (RF)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckASO">
                                                <label class="form-check-label" for="flexCheckASO">
                                                    Antistreptolysin O (ASO)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckToxoplasmosis">
                                                <label class="form-check-label" for="flexCheckToxoplasmosis">
                                                    Toxoplasmosis
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckTyphoid">
                                                <label class="form-check-label" for="flexCheckTyphoid">
                                                    Typhoid (hCG)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckHpyloriAntibody">
                                                <label class="form-check-label" for="flexCheckHpyloriAntibody">
                                                    H.pylori antibody
                                                </label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckStoolOccultBlood">
                                                <label class="form-check-label" for="flexCheckStoolOccultBlood">
                                                    Stool occult blood
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckGeneralStoolExamination">
                                                <label class="form-check-label" for="flexCheckGeneralStoolExamination">
                                                    General stool examination
                                                </label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckThyroidProfile">
                                                <label class="form-check-label" for="flexCheckThyroidProfile">
                                                    Thyroid profile
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckT3">
                                                <label class="form-check-label" for="flexCheckT3">
                                                    Triiodothyronine (T3)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckT4">
                                                <label class="form-check-label" for="flexCheckT4">
                                                    Thyroxine (T4)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckTSH">
                                                <label class="form-check-label" for="flexCheckTSH">
                                                    Thyroid stimulating hormone (TSH)
                                                </label>
                                            </div>


                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckSpermExamination">
                                                <label class="form-check-label" for="flexCheckSpermExamination">
                                                    Sperm examination
                                                </label>
                                            </div>
                                       <%--     <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckVirginalSwab">
                                                <label class="form-check-label" for="flexCheckVirginalSwab">
                                                    Virginal swab
                                                </label>
                                            </div>--%>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckTrichomonasVirginals">
                                                <label class="form-check-label" for="flexCheckTrichomonasVirginals">
                                                    Trichomonas virginals
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckHCG">
                                                <label class="form-check-label" for="flexCheckHCG">
                                                    Human chorionic gonadotropin (hCG)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckHpyloriAgStool">
                                                <label class="form-check-label" for="flexCheckHpyloriAgStool">
                                                    H.pylori Ag (stool)
                                                </label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckFastingBloodSugar">
                                                <label class="form-check-label" for="flexCheckFastingBloodSugar">
                                                    Fasting blood sugar
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckHemoglobinA1c">
                                                <label class="form-check-label" for="flexCheckHemoglobinA1c">
                                                    Hemoglobin A1c
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckGeneralUrineExamination">
                                                <label class="form-check-label" for="flexCheckGeneralUrineExamination">
                                                    General urine examination
                                                </label>
                                            </div>
                                        </div>

                                        <div class="col-4">


                                          <%--  <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckLiverFunctionTest">
                                                <label class="form-check-label" for="flexCheckLiverFunctionTest">
                                                    Liver function test
                                                </label>
                                            </div>--%>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckSGPTALT">
                                                <label class="form-check-label" for="flexCheckSGPTALT">
                                                    SGPT (ALT)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckSGOTAST">
                                                <label class="form-check-label" for="flexCheckSGOTAST">
                                                    SGOT (AST)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckAlkalinePhosphatesALP">
                                                <label class="form-check-label" for="flexCheckAlkalinePhosphatesALP">
                                                    Alkaline phosphates (ALP)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckTotalBilirubin">
                                                <label class="form-check-label" for="flexCheckTotalBilirubin">
                                                    Total bilirubin
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckDirectBilirubin">
                                                <label class="form-check-label" for="flexCheckDirectBilirubin">
                                                    Direct bilirubin
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckAlbumin">
                                                <label class="form-check-label" for="flexCheckAlbumin">
                                                    Albumin
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckJGlobulin">
                                                <label class="form-check-label" for="flexCheckJGlobulin">
                                                    JGlobulin
                                                </label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckUrea">
                                                <label class="form-check-label" for="flexCheckUrea">
                                                    Urea
                                                </label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckHemoglobin">
                                                <label class="form-check-label" for="flexCheckHemoglobin">
                                                    Hemoglobin
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckMalaria">
                                                <label class="form-check-label" for="flexCheckMalaria">
                                                    Malaria
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckESR">
                                                <label class="form-check-label" for="flexCheckESR">
                                                    ESR
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckBloodGrouping">
                                                <label class="form-check-label" for="flexCheckBloodGrouping">
                                                    Blood grouping
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckBloodSugar">
                                                <label class="form-check-label" for="flexCheckBloodSugar">
                                                    Blood sugar
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckCBC">
                                                <label class="form-check-label" for="flexCheckCBC">
                                                    CBC
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckCrossMatching">
                                                <label class="form-check-label" for="flexCheckCrossMatching">
                                                    Cross matching
                                                </label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckTPHA">
                                                <label class="form-check-label" for="flexCheckTPHA">
                                                    TPHA
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckHIV">
                                                <label class="form-check-label" for="flexCheckHIV">
                                                    Human immune deficiency (HIV)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckHBV">
                                                <label class="form-check-label" for="flexCheckHBV">
                                                    Hepatitis B virus (HBV)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckHCV">
                                                <label class="form-check-label" for="flexCheckHCV">
                                                    Hepatitis C virus (HCV)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckBrucellaMelitensis">
                                                <label class="form-check-label" for="flexCheckBrucellaMelitensis">
                                                    Brucella melitensis
                                                </label>
                                            </div>

                                            <!-- New Cardiac Markers -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckTroponinI">
                                                <label class="form-check-label" for="flexCheckTroponinI">
                                                    Troponin I (Cardiac marker)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckCKMB">
                                                <label class="form-check-label" for="flexCheckCKMB">
                                                    CK-MB (Creatine Kinase-MB)
                                                </label>
                                            </div>

                                            <!-- New Coagulation Tests -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckAPTT">
                                                <label class="form-check-label" for="flexCheckAPTT">
                                                    aPTT (Activated Partial Thromboplastin Time)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckINR">
                                                <label class="form-check-label" for="flexCheckINR">
                                                    INR (International Normalized Ratio)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckDDimer">
                                                <label class="form-check-label" for="flexCheckDDimer">
                                                    D-Dimer
                                                </label>
                                            </div>

                                            <!-- New Vitamins and Minerals -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckVitaminD">
                                                <label class="form-check-label" for="flexCheckVitaminD">
                                                    Vitamin D
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckVitaminB12">
                                                <label class="form-check-label" for="flexCheckVitaminB12">
                                                    Vitamin B12
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckFerritin">
                                                <label class="form-check-label" for="flexCheckFerritin">
                                                    Ferritin (Iron storage)
                                                </label>
                                            </div>

                                            <!-- New Infectious Disease Tests -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckVDRL">
                                                <label class="form-check-label" for="flexCheckVDRL">
                                                    VDRL (Syphilis test)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckDengueFever">
                                                <label class="form-check-label" for="flexCheckDengueFever">
                                                    Dengue Fever (IgG/IgM)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckGonorrheaAg">
                                                <label class="form-check-label" for="flexCheckGonorrheaAg">
                                                    Gonorrhea Ag
                                                </label>
                                            </div>

                                            <!-- New Tumor Markers -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckAFP">
                                                <label class="form-check-label" for="flexCheckAFP">
                                                    AFP (Alpha-fetoprotein)
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckTotalPSA">
                                                <label class="form-check-label" for="flexCheckTotalPSA">
                                                    Total PSA (Prostate-Specific Antigen)
                                                </label>
                                            </div>

                                            <!-- New Fertility Test -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckAMH">
                                                <label class="form-check-label" for="flexCheckAMH">
                                                    AMH (Anti-Müllerian Hormone)
                                                </label>
                                            </div>

                                            <!-- New Tests Added -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckElectrolyteTest">
                                                <label class="form-check-label" for="flexCheckElectrolyteTest">
                                                    Electrolyte Test
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckCRPTiter">
                                                <label class="form-check-label" for="flexCheckCRPTiter">
                                                    CRP Titer
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckUltra">
                                                <label class="form-check-label" for="flexCheckUltra">
                                                    Ultra
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckTyphoidIgG">
                                                <label class="form-check-label" for="flexCheckTyphoidIgG">
                                                    Typhoid IgG
                                                </label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckTyphoidAg">
                                                <label class="form-check-label" for="flexCheckTyphoidAg">
                                                    Typhoid Ag
                                                </label>
                                            </div>
                                        </div>
                                    </div>





                                </div>

                            </div>





                        </div>


                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" id="updateButton" onclick="callAjaxFunction()"
                            class="btn btn-primary">Update</button>
                        <button type="button" id="submitButton" class="btn btn-primary">Submit</button>
                    </div>
                </div>
            </div>
        </div>


        <!-- Modal -->
        <div class="modal fade" id="staticBackdrop9" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel9">Lab Tests</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input style="display:none" id="id9" />
                        <input style="display:none" id="id99" />
                        <div class="row">





                            <div class="col-12">
                                <h1>X-ray Details</h1>
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="radio">
                                    <label class="form-check-label" for="radio">Show X-Ray Details</label>
                                </div>

                                <div class="mb-3 hidden" id="xrayDetails">
                                    <label for="name" class="form-label">X-Ray Name</label>
                                    <input type="text" class="form-control" name="xrayname" id="xrayname"
                                        placeholder="Enter X-Ray name">
                                    <small id="xrayerror" class="text-danger"></small>
                                </div>

                                <div class="mb-3 hidden" id="xraySpecial">
                                    <label for="inst" class="form-label">Special Instruction</label>
                                    <textarea class="form-control" id="inst" rows="3"></textarea>
                                    <small id="instError" class="text-danger"></small>
                                </div>
                                <div class="mb-3 hidden" id="xraySpecial5">

                                    <select class="form-control" id="typeimg">
                                        <option value="0"> please select type</option>
                                        <option value="Xray">Xray</option>
                                        <option value="CT scan">CT scan</option>
                                        <option value="Ultra Sound<">Ultra Sound</option>
                                        <option value="MRI">MRI</option>
                                    </select>
                                    <small id="imgtype5" class="text-danger"></small>
                                </div>



                            </div>
                        </div>


                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" id="submitButton7" onclick="updatexrysub()"
                            class="btn btn-success">update</button>
                        <button type="button" id="submitButton5" class="btn btn-primary">Submit</button>
                    </div>
                </div>
            </div>
        </div>









        <%-- <!-- Modal -->
            <div class="modal fade" id="staticBackdrop6" data-bs-backdrop="static" data-bs-keyboard="false"
                tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog modal-xl modal-dialog-scrollable">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h1 class="modal-title fs-5" id="staticBackdropLabel16">Lab Tests</h1>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <input style="display:none" id="editl" />
                            <input style="display:none" id="medid" />

                            <div class="row">
                                <div class="col-12">
                                    <h1>Lab Test Details</h1>

                                    <div class="form-check form-switch">
                                        <input class="form-check-input" type="checkbox" id="radio22" value="0">
                                        <label class="form-check-label" for="radio2">Show Lab Tests</label>
                                    </div>

                                    <div id="additionalTests1" class="hidden">
                                        <div class="row">
                                            <div class="col-4">
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckLDL1">
                                                    <label class="form-check-label" for="flexCheckLDL">
                                                        Low-density lipoprotein (LDL)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckHDL1">
                                                    <label class="form-check-label" for="flexCheckHDL">
                                                        High-density lipoprotein (HDL)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckTotalCholesterol1">
                                                    <label class="form-check-label" for="flexCheckTotalCholesterol">
                                                        Total cholesterol
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckTriglycerides1">
                                                    <label class="form-check-label" for="flexCheckTriglycerides">
                                                        Triglycerides
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckSodium1">
                                                    <label class="form-check-label" for="flexCheckSodium">
                                                        Sodium
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckPotassium1">
                                                    <label class="form-check-label" for="flexCheckPotassium">
                                                        Potassium
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckChloride1">
                                                    <label class="form-check-label" for="flexCheckChloride">
                                                        Chloride
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckCalcium1">
                                                    <label class="form-check-label" for="flexCheckCalcium">
                                                        Calcium
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckPhosphorous1">
                                                    <label class="form-check-label" for="flexCheckPhosphorous">
                                                        Phosphorous
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckMagnesium1">
                                                    <label class="form-check-label" for="flexCheckMagnesium">
                                                        Magnesium
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckCreatinine1">
                                                    <label class="form-check-label" for="flexCheckCreatinine">
                                                        Creatinine
                                                    </label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckAmylase1">
                                                    <label class="form-check-label" for="flexCheckAmylase">
                                                        Amylase
                                                    </label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckProgesteroneFemale1">
                                                    <label class="form-check-label" for="flexCheckProgesteroneFemale">
                                                        Progesterone (Female)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckFSH1">
                                                    <label class="form-check-label" for="flexCheckFSH">
                                                        Follicle stimulating hormone (FSH)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckEstradiol1">
                                                    <label class="form-check-label" for="flexCheckEstradiol">
                                                        Estradiol
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckLH1">
                                                    <label class="form-check-label" for="flexCheckLH">
                                                        Luteinizing hormone (LH)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckTestosteroneMale1">
                                                    <label class="form-check-label" for="flexCheckTestosteroneMale">
                                                        Testosterone (Male)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckProlactin1">
                                                    <label class="form-check-label" for="flexCheckProlactin">
                                                        Prolactin
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckSeminalFluidAnalysis1">
                                                    <label class="form-check-label" for="flexCheckSeminalFluidAnalysis">
                                                        Seminal Fluid Analysis (Male)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckBHCG1">
                                                    <label class="form-check-label" for="flexCheckBHCG">
                                                        B-HCG
                                                    </label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckUrineExamination1">
                                                    <label class="form-check-label" for="flexCheckUrineExamination">
                                                        Urine examination
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckStoolExamination1">
                                                    <label class="form-check-label" for="flexCheckStoolExamination">
                                                        Stool examination
                                                    </label>
                                                </div>

                                            </div>



                                            <div class="col-4">


                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckUricAcid1">
                                                    <label class="form-check-label" for="flexCheckUricAcid">
                                                        Uric acid
                                                    </label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckBrucellaAbortus1">
                                                    <label class="form-check-label" for="flexCheckBrucellaAbortus">
                                                        Brucella abortus
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckCRP1">
                                                    <label class="form-check-label" for="flexCheckCRP">
                                                        C-reactive protein (CRP)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckRF1">
                                                    <label class="form-check-label" for="flexCheckRF">
                                                        Rheumatoid factor (RF)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckASO1">
                                                    <label class="form-check-label" for="flexCheckASO">
                                                        Antistreptolysin O (ASO)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckToxoplasmosis1">
                                                    <label class="form-check-label" for="flexCheckToxoplasmosis">
                                                        Toxoplasmosis
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckTyphoid1">
                                                    <label class="form-check-label" for="flexCheckTyphoid">
                                                        Typhoid (hCG)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckHpyloriAntibody1">
                                                    <label class="form-check-label" for="flexCheckHpyloriAntibody">
                                                        H.pylori antibody
                                                    </label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckStoolOccultBlood1">
                                                    <label class="form-check-label" for="flexCheckStoolOccultBlood">
                                                        Stool occult blood
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckGeneralStoolExamination1">
                                                    <label class="form-check-label"
                                                        for="flexCheckGeneralStoolExamination">
                                                        General stool examination
                                                    </label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckThyroidProfile1">
                                                    <label class="form-check-label" for="flexCheckThyroidProfile">
                                                        Thyroid profile
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckT31">
                                                    <label class="form-check-label" for="flexCheckT3">
                                                        Triiodothyronine (T3)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckT41">
                                                    <label class="form-check-label" for="flexCheckT4">
                                                        Thyroxine (T4)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckTSH1">
                                                    <label class="form-check-label" for="flexCheckTSH">
                                                        Thyroid stimulating hormone (TSH)
                                                    </label>
                                                </div>


                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckSpermExamination1">
                                                    <label class="form-check-label" for="flexCheckSpermExamination">
                                                        Sperm examination
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckVirginalSwab1">
                                                    <label class="form-check-label" for="flexCheckVirginalSwab">
                                                        Virginal swab
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckTrichomonasVirginals1">
                                                    <label class="form-check-label" for="flexCheckTrichomonasVirginals">
                                                        Trichomonas virginals
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckHCG1">
                                                    <label class="form-check-label" for="flexCheckHCG">
                                                        Human chorionic gonadotropin (hCG)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckHpyloriAgStool1">
                                                    <label class="form-check-label" for="flexCheckHpyloriAgStool">
                                                        H.pylori Ag (stool)
                                                    </label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckFastingBloodSugar1">
                                                    <label class="form-check-label" for="flexCheckFastingBloodSugar">
                                                        Fasting blood sugar
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckHemoglobinA1c1">
                                                    <label class="form-check-label" for="flexCheckHemoglobinA1c">
                                                        Hemoglobin A1c
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckGeneralUrineExamination1">
                                                    <label class="form-check-label"
                                                        for="flexCheckGeneralUrineExamination">
                                                        General urine examination
                                                    </label>
                                                </div>
                                            </div>

                                            <div class="col-4">


                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckLiverFunctionTest1">
                                                    <label class="form-check-label" for="flexCheckLiverFunctionTest">
                                                        Liver function test
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckSGPTALT1">
                                                    <label class="form-check-label" for="flexCheckSGPTALT">
                                                        SGPT (ALT)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckSGOTAST1">
                                                    <label class="form-check-label" for="flexCheckSGOTAST">
                                                        SGOT (AST)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckAlkalinePhosphatesALP1">
                                                    <label class="form-check-label"
                                                        for="flexCheckAlkalinePhosphatesALP">
                                                        Alkaline phosphates (ALP)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckTotalBilirubin1">
                                                    <label class="form-check-label" for="flexCheckTotalBilirubin">
                                                        Total bilirubin
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckDirectBilirubin1">
                                                    <label class="form-check-label" for="flexCheckDirectBilirubin">
                                                        Direct bilirubin
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckAlbumin1">
                                                    <label class="form-check-label" for="flexCheckAlbumin">
                                                        Albumin
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckJGlobulin1">
                                                    <label class="form-check-label" for="flexCheckJGlobulin">
                                                        JGlobulin
                                                    </label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckUrea1">
                                                    <label class="form-check-label" for="flexCheckUrea">
                                                        Urea
                                                    </label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckHemoglobin1">
                                                    <label class="form-check-label" for="flexCheckHemoglobin">
                                                        Hemoglobin
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckMalaria1">
                                                    <label class="form-check-label" for="flexCheckMalaria">
                                                        Malaria
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckESR1">
                                                    <label class="form-check-label" for="flexCheckESR">
                                                        ESR
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckBloodGrouping1">
                                                    <label class="form-check-label" for="flexCheckBloodGrouping">
                                                        Blood grouping
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckBloodSugar1">
                                                    <label class="form-check-label" for="flexCheckBloodSugar">
                                                        Blood sugar
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckCBC1">
                                                    <label class="form-check-label" for="flexCheckCBC">
                                                        CBC
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckCrossMatching1">
                                                    <label class="form-check-label" for="flexCheckCrossMatching">
                                                        Cross matching
                                                    </label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckTPHA1">
                                                    <label class="form-check-label" for="flexCheckTPHA">
                                                        TPHA
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckHIV1">
                                                    <label class="form-check-label" for="flexCheckHIV">
                                                        Human immune deficiency (HIV)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckHBV1">
                                                    <label class="form-check-label" for="flexCheckHBV">
                                                        Hepatitis B virus (HBV)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckHCV1">
                                                    <label class="form-check-label" for="flexCheckHCV">
                                                        Hepatitis C virus (HCV)
                                                    </label>
                                                </div>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="checkbox"
                                                        value="" id="flexCheckBrucellaMelitensis1">
                                                    <label class="form-check-label" for="flexCheckBrucellaMelitensis">
                                                        Brucella melitensis
                                                    </label>
                                                </div>
                                            </div>
                                        </div>





                                    </div>

                                </div>





                            </div>


                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="button" onclick="callAjaxFunction()" class="btn btn-primary">Update</button>
                        </div>
                    </div>
                </div>
            </div>--%>
            <script src="assets/js/core/jquery-3.7.1.min.js"></script>
            <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
            <script src="https://cdn.datatables.net/buttons/2.2.3/js/dataTables.buttons.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
            <script src="https://cdn.datatables.net/buttons/2.2.3/js/buttons.html5.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.70/pdfmake.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.70/vfs_fonts.js"></script>
            <script>
                function printReport1() {
                    const printContents = document.querySelector('#report').innerHTML;
                    const originalContents = document.body.innerHTML;

                    document.body.innerHTML = printContents;
                    window.print();
                    document.body.innerHTML = originalContents;
                }


                function showLabReport() {
                    var prescid = $("#id11").val();  // Use id11 which is in the main Patient Care Management modal
                    
                    if (!prescid) {
                        Swal.fire({
                            icon: 'warning',
                            title: 'No Prescription',
                            text: 'Please select a patient first.'
                        });
                        return;
                    }
                    
                    // Open lab orders print page in new window - same as doctor_inpatient.aspx
                    window.open('lab_orders_print.aspx?prescid=' + prescid, '_blank', 'width=900,height=700');
                }

                // Load lab orders for current patient
                function loadLabOrders(prescid) {
                    $.ajax({
                        url: 'assignmed.aspx/GetLabOrders',
                        data: JSON.stringify({ prescid: prescid }),
                        type: 'POST',
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        success: function (response) {
                            const tbody = $('#labOrdersTable tbody');
                            tbody.empty();
                            
                            if (!response.d || response.d.length === 0) {
                                tbody.append(`
                                    <tr>
                                        <td colspan="5" class="text-center text-muted">
                                            <i class="fa fa-info-circle"></i> No lab orders found. Click "Send to Lab" to create one.
                                        </td>
                                    </tr>
                                `);
                                // No orders, enable edit button
                                $('#editlab1').prop('disabled', false);
                                $('#labOrderWarning').hide();
                                return;
                            }
                            
                            // Check if any order is paid
                            var hasAnyPaidOrder = false;
                            
                            response.d.forEach(function(order) {
                                if (order.IsPaid) {
                                    hasAnyPaidOrder = true;
                                }
                                
                                const testsHtml = order.OrderedTests.length > 0 
                                    ? order.OrderedTests.slice(0, 3).join(', ') + (order.OrderedTests.length > 3 ? '...' : '')
                                    : 'No tests';
                                
                                const paymentBadge = order.IsPaid 
                                    ? '<span class="badge bg-success">Paid</span>'
                                    : '<span class="badge bg-warning text-dark">Unpaid</span>';
                                
                                const deleteBtn = !order.IsPaid 
                                    ? `<button class="btn btn-sm btn-danger" onclick="deleteLabOrder(${order.OrderId})" title="Delete Order">
                                           <i class="fa fa-trash"></i>
                                       </button>`
                                    : `<button class="btn btn-sm btn-secondary" disabled title="Cannot delete paid order">
                                           <i class="fa fa-trash"></i>
                                       </button>`;
                                
                                tbody.append(`
                                    <tr>
                                        <td><small>${new Date(order.OrderDate).toLocaleString()}</small></td>
                                        <td><small>${testsHtml}</small></td>
                                        <td>$${order.ChargeAmount.toFixed(2)}</td>
                                        <td>${paymentBadge}</td>
                                        <td>${deleteBtn}</td>
                                    </tr>
                                `);
                            });
                            
                            // Disable edit button if any order is paid
                            if (hasAnyPaidOrder) {
                                $('#editlab1').prop('disabled', true).addClass('btn-secondary').removeClass('btn-info');
                                $('#labOrderWarning').show();
                            } else {
                                $('#editlab1').prop('disabled', false).addClass('btn-info').removeClass('btn-secondary');
                                $('#labOrderWarning').hide();
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error('Error loading lab orders:', error);
                            Swal.fire('Error', 'Failed to load lab orders', 'error');
                        }
                    });
                }

                // Called when Lab Tests tab is clicked
                function onLabTabClick() {
                    const prescid = $('#id11').val();
                    if (prescid) {
                        loadLabOrdersEnhanced(prescid);
                    }
                }

                // Check if lab order can be edited (not paid)
                function checkLabOrderBeforeEdit() {
                    const prescid = $("#id11").val();
                    if (!prescid) {
                        Swal.fire('Error', 'Please select a patient first', 'error');
                        return false;
                    }
                    
                    // Check if edit button is disabled
                    if ($('#editlab1').prop('disabled')) {
                        Swal.fire({
                            title: 'Cannot Edit Lab Order',
                            html: '<p class="text-danger"><i class="fa fa-lock"></i> <strong>Lab charges have been paid.</strong></p>' +
                                  '<p>Orders cannot be edited or deleted once payment has been received.</p>' +
                                  '<p class="text-muted"><small>This is to maintain payment integrity and audit trail.</small></p>',
                            icon: 'warning',
                            confirmButtonText: 'OK'
                        });
                        return false;
                    }
                    
                    // If not disabled, proceed with edit
                    editlab();
                    return false;
                }

                // Delete lab order with confirmation
                function deleteLabOrder(orderId) {
                    Swal.fire({
                        title: 'Delete Lab Order?',
                        html: '<p>Are you sure you want to delete this lab order?</p>' +
                              '<p class="text-danger"><small><i class="fa fa-exclamation-triangle"></i> This will permanently delete the lab order, its results, and the associated charge.</small></p>',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6',
                        confirmButtonText: 'Yes, delete it',
                        cancelButtonText: 'Cancel'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax({
                                url: 'assignmed.aspx/DeleteLabOrder',
                                data: JSON.stringify({ orderId: parseInt(orderId) }),
                                type: 'POST',
                                contentType: 'application/json; charset=utf-8',
                                dataType: 'json',
                                success: function (response) {
                                    if (response.d.success) {
                                        Swal.fire('Deleted!', response.d.message, 'success');
                                        // Reload lab orders
                                        const prescid = $("#id11").val();
                                        if (prescid) {
                                            loadLabOrders(prescid);
                                        }
                                    } else {
                                        Swal.fire('Error', response.d.message, 'error');
                                    }
                                },
                                error: function (xhr, status, error) {
                                    console.error('Error deleting lab order:', error);
                                    Swal.fire('Error', 'Failed to delete lab order. Please try again.', 'error');
                                }
                            });
                        }
                    });
                }

                function openVisitSummary(evt, prescid) {
                    if (evt && evt.stopPropagation) {
                        evt.stopPropagation();
                    }
                    if (!prescid) {
                        return;
                    }
                    window.open('visit_summary_print.aspx?prescid=' + encodeURIComponent(prescid), '_blank');
                }


                //document.getElementById('print-button').addEventListener('click', function () {
                //    window.print();
                //});

                //document.getElementById('print-button1').addEventListener('click', function () {
                //    window.print();
                //});

                function deletejob() {
                    var medid = $("#id1111").val();
                    $.ajax({
                        type: "POST",
                        url: "assignmed.aspx/deleteJob",
                        data: JSON.stringify({ medid: medid }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            $('#medmodal').modal('hide');
                            if (response.d === 'true') {
                                Swal.fire(
                                    'Successfully updated !',
                                    'You Added a new job title!',
                                    'success'
                                )


                            } else {
                                // Handle errors in the response
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Data Insertion Failed',
                                    text: 'There was an error while inserting the data.',
                                });
                            }
                        },
                        error: function (xhr, status, error) {
                            alert("Error: " + xhr.responseText);
                        }
                    });

                }


                function update() {
                    var medid = $("#id1111").val();
                    var med_name = $("#name1").val();
                    var dosage = $("#dosage1").val();
                    var frequency = $("#frequency1").val();
                    var duration = $("#duration1").val();
                    var special_inst = $("#inst1").val();






                    $.ajax({
                        url: 'assignmed.aspx/updateJob',
                        data: "{  'medid':'" + medid + "','med_name':'" + med_name + "', 'dosage':'" + dosage + "', 'frequency':'" + frequency + "', 'duration':'" + duration + "' , 'special_inst':'" + special_inst + "'  }",

                        dataType: "json",
                        type: 'POST',
                        contentType: "application/json",
                        success: function (response) {
                            console.log(response);
                            $('#medmodal').modal('hide');
                            Swal.fire(
                                'Successfully Updated !',
                                'You Updated a new Customer!',
                                'success'
                            )
                            DataBind();
                            
                            // Reload medications after update
                            var prescid = $("#id111").val();
                            if (prescid) {
                                loadMedications(prescid);
                            }
                        },
                        error: function (response) {
                            alert(response.responseText);
                        }
                    });
                }

                function updatexrysub() {
                    var xryid = $("#id99").val();
                    var xrayname = $("#xrayname").val();
                    var inst = $("#inst").val();


                    var typeimg = $("#typeimg").val();




                    $.ajax({
                        url: 'assignmed.aspx/realxryupdate',
                        data: "{  'xryid':'" + xryid + "','xrayname':'" + xrayname + "', 'inst':'" + inst + "', 'typeimg':'" + typeimg + "' }",

                        dataType: "json",
                        type: 'POST',
                        contentType: "application/json",
                        success: function (response) {
                            console.log(response);
                            $('#staticBackdrop9').modal('hide');
                            Swal.fire(
                                'Successfully Updated !',
                                'You Updated a new Customer!',
                                'success'
                            )
                            DataBind();
                        },
                        error: function (response) {
                            alert(response.responseText);
                        }
                    });
                }

                // Note: datatable11 event handler removed - that table was in the old medication modal that has been removed

                // Delegate click events for edit button in medicationTable
                $("#medicationTable").on("click", ".edit1-btn", function (event) {
                    event.preventDefault();
                    var row = $(this).closest("tr");
                    var medid = $(this).data("id");

                    var med_name = row.find("td:nth-child(1)").text();
                    var dosage = row.find("td:nth-child(2)").text();
                    var frequency = row.find("td:nth-child(3)").text();
                    var duration = row.find("td:nth-child(4)").text();

                    // Note: medicationTable doesn't have special_inst column, so we'll leave it empty
                    $("#id1111").val(medid);
                    $("#name1").val(med_name);
                    $("#dosage1").val(dosage);
                    $("#frequency1").val(frequency);
                    $("#duration1").val(duration);
                    $("#inst1").val(''); // Clear special instructions as it's not in this table

                    $('#medmodal').modal('show');
                });

                // Delegate click events for delete button in medicationTable
                $("#medicationTable").on("click", ".delete-med-btn", function (event) {
                    event.preventDefault();
                    var medid = $(this).data("id");
                    var row = $(this).closest("tr");

                    Swal.fire({
                        title: 'Are you sure?',
                        text: "Do you want to delete this medication?",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6',
                        confirmButtonText: 'Yes, delete it!'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax({
                                url: 'assignmed.aspx/deleteJob',
                                data: JSON.stringify({ 'medid': medid }),
                                contentType: 'application/json; charset=utf-8',
                                dataType: 'json',
                                type: 'POST',
                                success: function (response) {
                                    if (response.d === 'true') {
                                        Swal.fire(
                                            'Deleted!',
                                            'Medication has been deleted.',
                                            'success'
                                        );
                                        // Remove the row from table
                                        row.remove();
                                        
                                        // If table is now empty, show the empty message
                                        if ($("#medicationTable tbody tr").length === 0) {
                                            $("#medicationTable tbody").append(
                                                "<tr><td colspan='5' class='text-center text-muted'>No medications prescribed yet</td></tr>"
                                            );
                                        }
                                    } else {
                                        Swal.fire({
                                            icon: 'error',
                                            title: 'Delete Failed',
                                            text: 'There was an error deleting the medication.',
                                        });
                                    }
                                },
                                error: function (response) {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Error',
                                        text: 'Failed to delete medication: ' + response.responseText,
                                    });
                                }
                            });
                        }
                    });
                });

                // Patient Type Management Functions
                function selectPatientType(type) {
                    if (type === 'outpatient') {
                        $('#outpatientRadio').prop('checked', true);
                        $('#inpatientDetailsSection').hide();
                    } else if (type === 'inpatient') {
                        $('#inpatientRadio').prop('checked', true);
                        $('#inpatientDetailsSection').show();
                        // Set current date/time as default
                        var now = new Date();
                        var dateString = now.getFullYear() + '-' + 
                            String(now.getMonth() + 1).padStart(2, '0') + '-' + 
                            String(now.getDate()).padStart(2, '0') + 'T' + 
                            String(now.getHours()).padStart(2, '0') + ':' + 
                            String(now.getMinutes()).padStart(2, '0');
                        $('#admissionDateInput').val(dateString);
                    }
                }

                function updatePatientType() {
                    var patientId = $("#pid").val();
                    // Try to get prescid from either field (different modals use different IDs)
                    var prescid = $("#id111").val() || $("#id11").val();
                    
                    console.log('updatePatientType - patientId:', patientId, 'prescid:', prescid);
                    console.log('updatePatientType - #id111:', $("#id111").val(), '#id11:', $("#id11").val());
                    
                    if (!patientId) {
                        Swal.fire({
                            icon: 'error',
                            title: 'No Patient Selected',
                            text: 'Please select a patient first.',
                        });
                        return;
                    }
                    
                    if (!prescid) {
                        Swal.fire({
                            icon: 'error',
                            title: 'No Prescription ID',
                            text: 'Prescription ID is missing. Please select a patient from the table first.',
                        });
                        return;
                    }

                    var patientType = $('input[name="patientTypeRadio"]:checked').val();
                    
                    if (patientType === undefined) {
                        Swal.fire({
                            icon: 'error',
                            title: 'No Selection',
                            text: 'Please select a patient type.',
                        });
                        return;
                    }

                    var status = patientType; // 0 for outpatient, 1 for inpatient
                    var admissionDate = null;
                    
                    if (status === '1') {
                        admissionDate = $('#admissionDateInput').val();
                        if (!admissionDate) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Missing Information',
                                text: 'Please select an admission date for inpatient.',
                            });
                            return;
                        }
                    }

                    // Call backend to update patient type
                    $.ajax({
                        url: 'assignmed.aspx/UpdatePatientType',
                        data: JSON.stringify({ 
                            'patientId': patientId, 
                            'prescid': prescid,
                            'status': status,
                            'admissionDate': admissionDate
                        }),
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        type: 'POST',
                        success: function (response) {
                            if (response.d === 'true') {
                                var typeText = status === '1' ? 'Inpatient' : 'Outpatient';
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Updated!',
                                    text: 'Patient type has been updated to ' + typeText,
                                });
                                loadCurrentPatientType(patientId);
                            } else {
                                console.error('Update Failed - Backend Response:', response.d);
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Update Failed',
                                    text: response.d || 'There was an error updating the patient type.',
                                });
                            }
                        },
                        error: function (response) {
                            console.error('AJAX Error:', response);
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'Failed to update patient type: ' + response.responseText,
                            });
                        }
                    });
                }

                function loadCurrentPatientType(patientId) {
                    if (!patientId) return;
                    
                    $.ajax({
                        url: 'assignmed.aspx/GetPatientType',
                        data: JSON.stringify({ 'patientId': patientId }),
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        type: 'POST',
                        success: function (response) {
                            if (response.d) {
                                var data = response.d;
                                var typeText = data.patient_type === 'inpatient' ? 'Inpatient' : 'Outpatient';
                                var statusClass = data.patient_type === 'inpatient' ? 'alert-warning' : 'alert-success';
                                var icon = data.patient_type === 'inpatient' ? 'fa-bed' : 'fa-walking';
                                
                                $('#currentPatientTypeDisplay').removeClass('alert-secondary alert-success alert-warning')
                                    .addClass(statusClass);
                                $('#currentTypeText').html('<i class="fa ' + icon + ' me-2"></i>' + typeText);
                                
                                if (data.patient_type === 'inpatient') {
                                    $('#inpatientRadio').prop('checked', true);
                                    $('#inpatientDetailsSection').show();
                                    if (data.bed_admission_date) {
                                        $('#admissionDateInput').val(data.bed_admission_date);
                                    }
                                } else {
                                    $('#outpatientRadio').prop('checked', true);
                                    $('#inpatientDetailsSection').hide();
                                }
                            }
                        },
                        error: function (response) {
                            console.error('Error loading patient type:', response);
                        }
                    });
                }

                // Make functions globally accessible
                window.selectPatientType = selectPatientType;
                window.updatePatientType = updatePatientType;
                window.loadCurrentPatientType = loadCurrentPatientType;


                document.addEventListener('DOMContentLoaded', function () {
                    const radio2 = document.getElementById('radio21');
                    const submitButton = document.getElementById('submitButton');
                    const additionalTests = document.getElementById('additionalTests');

                    function toggleAdditionalTests() {
                        if (radio21.checked) {
                            radio21.value = "1";
                            additionalTests.classList.remove('hidden');
                        } else {
                            radio21.value = "0";
                            additionalTests.classList.add('hidden');
                        }
                    }

                    function callAjaxFunction() {
                        if (!radio21.checked || !isAnyCheckboxChecked()) {
                            alert("Please ensure radio2 and at least one other checkbox are checked.");
                            return;
                        }


                        var flexCheckHDL, flexCheckLDL, flexCheckTotalCholesterol, flexCheckTriglycerides, flexCheckSGPTALT, flexCheckSGOTAST, flexCheckAlkalinePhosphatesALP, flexCheckTotalBilirubin, flexCheckDirectBilirubin, flexCheckAlbumin, flexCheckJGlobulin, flexCheckUrea, flexCheckCreatinine, flexCheckUricAcid, flexCheckSodium, flexCheckPotassium, flexCheckChloride, flexCheckCalcium, flexCheckPhosphorous, flexCheckMagnesium, flexCheckAmylase, flexCheckProgesteroneFemale, flexCheckFSH, flexCheckEstradiol, flexCheckLH, flexCheckTestosteroneMale, flexCheckProlactin, flexCheckSeminalFluidAnalysis, flexCheckUrineExamination, flexCheckStoolExamination, flexCheckHemoglobin, flexCheckMalaria, flexCheckESR, flexCheckBloodGrouping, flexCheckBloodSugar, flexCheckCBC, flexCheckCrossMatching, flexCheckTPHA, flexCheckHIV, flexCheckHBV, flexCheckHCV, flexCheckBrucellaMelitensis, flexCheckBrucellaAbortus, flexCheckCRP, flexCheckRF, flexCheckASO, flexCheckToxoplasmosis, flexCheckTyphoid, flexCheckHpyloriAntibody, flexCheckStoolOccultBlood, flexCheckGeneralStoolExamination, flexCheckThyroidProfile, flexCheckT3, flexCheckT4, flexCheckTSH, flexCheckSpermExamination, flexCheckTrichomonasVirginals, flexCheckHCG, flexCheckHpyloriAgStool, flexCheckFastingBloodSugar, flexCheckHemoglobinA1c, flexCheckGeneralUrineExamination, flexCheckTroponinI, flexCheckCKMB, flexCheckAPTT, flexCheckINR, flexCheckDDimer, flexCheckVitaminD, flexCheckVitaminB12, flexCheckFerritin, flexCheckVDRL, flexCheckDengueFever, flexCheckGonorrheaAg, flexCheckAFP, flexCheckTotalPSA, flexCheckAMH;
                        // Example for flexCheckHDL
                        flexCheckHDL = $('#flexCheckHDL');
                        if (flexCheckHDL.prop('checked')) {
                            flexCheckHDL = flexCheckHDL.next('label').text().trim();
                        } else {
                            flexCheckHDL = 'not checked';
                        }

                        // Example for flexCheckLDL
                        flexCheckLDL = $('#flexCheckLDL');
                        if (flexCheckLDL.prop('checked')) {
                            flexCheckLDL = flexCheckLDL.next('label').text().trim();
                        } else {
                            flexCheckLDL = 'not checked';
                        }

                        // Example for flexCheckTotalCholesterol
                        flexCheckTotalCholesterol = $('#flexCheckTotalCholesterol');
                        if (flexCheckTotalCholesterol.prop('checked')) {
                            flexCheckTotalCholesterol = flexCheckTotalCholesterol.next('label').text().trim();
                        } else {
                            flexCheckTotalCholesterol = 'not checked';
                        }

                        // Example for flexCheckTriglycerides
                        flexCheckTriglycerides = $('#flexCheckTriglycerides');
                        if (flexCheckTriglycerides.prop('checked')) {
                            flexCheckTriglycerides = flexCheckTriglycerides.next('label').text().trim();
                        } else {
                            flexCheckTriglycerides = 'not checked';
                        }

                        //// Example for flexCheckLiverFunctionTest
                        //flexCheckLiverFunctionTest = $('#flexCheckLiverFunctionTest');
                        //if (flexCheckLiverFunctionTest.prop('checked')) {
                        //    flexCheckLiverFunctionTest = flexCheckLiverFunctionTest.next('label').text().trim();
                        //} else {
                        //    flexCheckLiverFunctionTest = 'not checked';
                        //}

                        // Example for flexCheckSGPTALT
                        flexCheckSGPTALT = $('#flexCheckSGPTALT');
                        if (flexCheckSGPTALT.prop('checked')) {
                            flexCheckSGPTALT = flexCheckSGPTALT.next('label').text().trim();
                        } else {
                            flexCheckSGPTALT = 'not checked';
                        }

                        // Example for flexCheckSGOTAST
                        flexCheckSGOTAST = $('#flexCheckSGOTAST');
                        if (flexCheckSGOTAST.prop('checked')) {
                            flexCheckSGOTAST = flexCheckSGOTAST.next('label').text().trim();
                        } else {
                            flexCheckSGOTAST = 'not checked';
                        }

                        // Example for flexCheckAlkalinePhosphatesALP
                        flexCheckAlkalinePhosphatesALP = $('#flexCheckAlkalinePhosphatesALP');
                        if (flexCheckAlkalinePhosphatesALP.prop('checked')) {
                            flexCheckAlkalinePhosphatesALP = flexCheckAlkalinePhosphatesALP.next('label').text().trim();
                        } else {
                            flexCheckAlkalinePhosphatesALP = 'not checked';
                        }

                        // Example for flexCheckTotalBilirubin
                        flexCheckTotalBilirubin = $('#flexCheckTotalBilirubin');
                        if (flexCheckTotalBilirubin.prop('checked')) {
                            flexCheckTotalBilirubin = flexCheckTotalBilirubin.next('label').text().trim();
                        } else {
                            flexCheckTotalBilirubin = 'not checked';
                        }

                        // Example for flexCheckDirectBilirubin
                        flexCheckDirectBilirubin = $('#flexCheckDirectBilirubin');
                        if (flexCheckDirectBilirubin.prop('checked')) {
                            flexCheckDirectBilirubin = flexCheckDirectBilirubin.next('label').text().trim();
                        } else {
                            flexCheckDirectBilirubin = 'not checked';
                        }

                        // Example for flexCheckAlbumin
                        flexCheckAlbumin = $('#flexCheckAlbumin');
                        if (flexCheckAlbumin.prop('checked')) {
                            flexCheckAlbumin = flexCheckAlbumin.next('label').text().trim();
                        } else {
                            flexCheckAlbumin = 'not checked';
                        }

                        // Example for flexCheckJGlobulin
                        flexCheckJGlobulin = $('#flexCheckJGlobulin');
                        if (flexCheckJGlobulin.prop('checked')) {
                            flexCheckJGlobulin = flexCheckJGlobulin.next('label').text().trim();
                        } else {
                            flexCheckJGlobulin = 'not checked';
                        }

                        // Example for flexCheckUrea
                        flexCheckUrea = $('#flexCheckUrea');
                        if (flexCheckUrea.prop('checked')) {
                            flexCheckUrea = flexCheckUrea.next('label').text().trim();
                        } else {
                            flexCheckUrea = 'not checked';
                        }

                        // Example for flexCheckCreatinine
                        flexCheckCreatinine = $('#flexCheckCreatinine');
                        if (flexCheckCreatinine.prop('checked')) {
                            flexCheckCreatinine = flexCheckCreatinine.next('label').text().trim();
                        } else {
                            flexCheckCreatinine = 'not checked';
                        }

                        // Example for flexCheckUricAcid
                        flexCheckUricAcid = $('#flexCheckUricAcid');
                        if (flexCheckUricAcid.prop('checked')) {
                            flexCheckUricAcid = flexCheckUricAcid.next('label').text().trim();
                        } else {
                            flexCheckUricAcid = 'not checked';
                        }

                        // Example for flexCheckSodium
                        flexCheckSodium = $('#flexCheckSodium');
                        if (flexCheckSodium.prop('checked')) {
                            flexCheckSodium = flexCheckSodium.next('label').text().trim();
                        } else {
                            flexCheckSodium = 'not checked';
                        }

                        // Example for flexCheckPotassium
                        flexCheckPotassium = $('#flexCheckPotassium');
                        if (flexCheckPotassium.prop('checked')) {
                            flexCheckPotassium = flexCheckPotassium.next('label').text().trim();
                        } else {
                            flexCheckPotassium = 'not checked';
                        }

                        // Example for flexCheckChloride
                        flexCheckChloride = $('#flexCheckChloride');
                        if (flexCheckChloride.prop('checked')) {
                            flexCheckChloride = flexCheckChloride.next('label').text().trim();
                        } else {
                            flexCheckChloride = 'not checked';
                        }

                        // Example for flexCheckCalcium
                        flexCheckCalcium = $('#flexCheckCalcium');
                        if (flexCheckCalcium.prop('checked')) {
                            flexCheckCalcium = flexCheckCalcium.next('label').text().trim();
                        } else {
                            flexCheckCalcium = 'not checked';
                        }

                        // Example for flexCheckPhosphorous
                        flexCheckPhosphorous = $('#flexCheckPhosphorous');
                        if (flexCheckPhosphorous.prop('checked')) {
                            flexCheckPhosphorous = flexCheckPhosphorous.next('label').text().trim();
                        } else {
                            flexCheckPhosphorous = 'not checked';
                        }

                        // Example for flexCheckMagnesium
                        flexCheckMagnesium = $('#flexCheckMagnesium');
                        if (flexCheckMagnesium.prop('checked')) {
                            flexCheckMagnesium = flexCheckMagnesium.next('label').text().trim();
                        } else {
                            flexCheckMagnesium = 'not checked';
                        }

                        // Example for flexCheckAmylase
                        flexCheckAmylase = $('#flexCheckAmylase');
                        if (flexCheckAmylase.prop('checked')) {
                            flexCheckAmylase = flexCheckAmylase.next('label').text().trim();
                        } else {
                            flexCheckAmylase = 'not checked';
                        }

                        // Example for flexCheckProgesteroneFemale
                        flexCheckProgesteroneFemale = $('#flexCheckProgesteroneFemale');
                        if (flexCheckProgesteroneFemale.prop('checked')) {
                            flexCheckProgesteroneFemale = flexCheckProgesteroneFemale.next('label').text().trim();
                        } else {
                            flexCheckProgesteroneFemale = 'not checked';
                        }

                        // Example for flexCheckFSH
                        flexCheckFSH = $('#flexCheckFSH');
                        if (flexCheckFSH.prop('checked')) {
                            flexCheckFSH = flexCheckFSH.next('label').text().trim();
                        } else {
                            flexCheckFSH = 'not checked';
                        }

                        // Example for flexCheckEstradiol
                        flexCheckEstradiol = $('#flexCheckEstradiol');
                        if (flexCheckEstradiol.prop('checked')) {
                            flexCheckEstradiol = flexCheckEstradiol.next('label').text().trim();
                        } else {
                            flexCheckEstradiol = 'not checked';
                        }

                        // Example for flexCheckLH
                        flexCheckLH = $('#flexCheckLH');
                        if (flexCheckLH.prop('checked')) {
                            flexCheckLH = flexCheckLH.next('label').text().trim();
                        } else {
                            flexCheckLH = 'not checked';
                        }

                        // Example for flexCheckTestosteroneMale
                        flexCheckTestosteroneMale = $('#flexCheckTestosteroneMale');
                        if (flexCheckTestosteroneMale.prop('checked')) {
                            flexCheckTestosteroneMale = flexCheckTestosteroneMale.next('label').text().trim();
                        } else {
                            flexCheckTestosteroneMale = 'not checked';
                        }

                        // Example for flexCheckProlactin
                        flexCheckProlactin = $('#flexCheckProlactin');
                        if (flexCheckProlactin.prop('checked')) {
                            flexCheckProlactin = flexCheckProlactin.next('label').text().trim();
                        } else {
                            flexCheckProlactin = 'not checked';
                        }

                        // Example for flexCheckSeminalFluidAnalysis
                        flexCheckSeminalFluidAnalysis = $('#flexCheckSeminalFluidAnalysis');
                        if (flexCheckSeminalFluidAnalysis.prop('checked')) {
                            flexCheckSeminalFluidAnalysis = flexCheckSeminalFluidAnalysis.next('label').text().trim();
                        } else {
                            flexCheckSeminalFluidAnalysis = 'not checked';
                        }

                        //// Example for flexCheckBHCG
                        //flexCheckBHCG = $('#flexCheckBHCG');
                        //if (flexCheckBHCG.prop('checked')) {
                        //    flexCheckBHCG = flexCheckBHCG.next('label').text().trim();
                        //} else {
                        //    flexCheckBHCG = 'not checked';
                        //}

                        // Example for flexCheckUrineExamination
                        flexCheckUrineExamination = $('#flexCheckUrineExamination');
                        if (flexCheckUrineExamination.prop('checked')) {
                            flexCheckUrineExamination = flexCheckUrineExamination.next('label').text().trim();
                        } else {
                            flexCheckUrineExamination = 'not checked';
                        }

                        // Example for flexCheckStoolExamination
                        flexCheckStoolExamination = $('#flexCheckStoolExamination');
                        if (flexCheckStoolExamination.prop('checked')) {
                            flexCheckStoolExamination = flexCheckStoolExamination.next('label').text().trim();
                        } else {
                            flexCheckStoolExamination = 'not checked';
                        }

                        // Example for flexCheckHemoglobin
                        flexCheckHemoglobin = $('#flexCheckHemoglobin');
                        if (flexCheckHemoglobin.prop('checked')) {
                            flexCheckHemoglobin = flexCheckHemoglobin.next('label').text().trim();
                        } else {
                            flexCheckHemoglobin = 'not checked';
                        }

                        // Example for flexCheckMalaria
                        flexCheckMalaria = $('#flexCheckMalaria');
                        if (flexCheckMalaria.prop('checked')) {
                            flexCheckMalaria = flexCheckMalaria.next('label').text().trim();
                        } else {
                            flexCheckMalaria = 'not checked';
                        }

                        // Example for flexCheckESR
                        flexCheckESR = $('#flexCheckESR');
                        if (flexCheckESR.prop('checked')) {
                            flexCheckESR = flexCheckESR.next('label').text().trim();
                        } else {
                            flexCheckESR = 'not checked';
                        }

                        // Example for flexCheckBloodGrouping
                        flexCheckBloodGrouping = $('#flexCheckBloodGrouping');
                        if (flexCheckBloodGrouping.prop('checked')) {
                            flexCheckBloodGrouping = flexCheckBloodGrouping.next('label').text().trim();
                        } else {
                            flexCheckBloodGrouping = 'not checked';
                        }

                        // Example for flexCheckBloodSugar
                        flexCheckBloodSugar = $('#flexCheckBloodSugar');
                        if (flexCheckBloodSugar.prop('checked')) {
                            flexCheckBloodSugar = flexCheckBloodSugar.next('label').text().trim();
                        } else {
                            flexCheckBloodSugar = 'not checked';
                        }

                        // Example for flexCheckCBC
                        flexCheckCBC = $('#flexCheckCBC');
                        if (flexCheckCBC.prop('checked')) {
                            flexCheckCBC = flexCheckCBC.next('label').text().trim();
                        } else {
                            flexCheckCBC = 'not checked';
                        }

                        // Example for flexCheckCrossMatching
                        flexCheckCrossMatching = $('#flexCheckCrossMatching');
                        if (flexCheckCrossMatching.prop('checked')) {
                            flexCheckCrossMatching = flexCheckCrossMatching.next('label').text().trim();
                        } else {
                            flexCheckCrossMatching = 'not checked';
                        }

                        // Example for flexCheckTPHA
                        flexCheckTPHA = $('#flexCheckTPHA');
                        if (flexCheckTPHA.prop('checked')) {
                            flexCheckTPHA = flexCheckTPHA.next('label').text().trim();
                        } else {
                            flexCheckTPHA = 'not checked';
                        }

                        // Example for flexCheckHIV
                        flexCheckHIV = $('#flexCheckHIV');
                        if (flexCheckHIV.prop('checked')) {
                            flexCheckHIV = flexCheckHIV.next('label').text().trim();
                        } else {
                            flexCheckHIV = 'not checked';
                        }

                        // Example for flexCheckHBV
                        flexCheckHBV = $('#flexCheckHBV');
                        if (flexCheckHBV.prop('checked')) {
                            flexCheckHBV = flexCheckHBV.next('label').text().trim();
                        } else {
                            flexCheckHBV = 'not checked';
                        }

                        // Example for flexCheckHCV
                        flexCheckHCV = $('#flexCheckHCV');
                        if (flexCheckHCV.prop('checked')) {
                            flexCheckHCV = flexCheckHCV.next('label').text().trim();
                        } else {
                            flexCheckHCV = 'not checked';
                        }

                        // Example for flexCheckBrucellaMelitensis
                        flexCheckBrucellaMelitensis = $('#flexCheckBrucellaMelitensis');
                        if (flexCheckBrucellaMelitensis.prop('checked')) {
                            flexCheckBrucellaMelitensis = flexCheckBrucellaMelitensis.next('label').text().trim();
                        } else {
                            flexCheckBrucellaMelitensis = 'not checked';
                        }

                        // Example for flexCheckBrucellaAbortus
                        flexCheckBrucellaAbortus = $('#flexCheckBrucellaAbortus');
                        if (flexCheckBrucellaAbortus.prop('checked')) {
                            flexCheckBrucellaAbortus = flexCheckBrucellaAbortus.next('label').text().trim();
                        } else {
                            flexCheckBrucellaAbortus = 'not checked';
                        }

                        // Example for flexCheckCRP
                        flexCheckCRP = $('#flexCheckCRP');
                        if (flexCheckCRP.prop('checked')) {
                            flexCheckCRP = flexCheckCRP.next('label').text().trim();
                        } else {
                            flexCheckCRP = 'not checked';
                        }

                        // Example for flexCheckRF
                        flexCheckRF = $('#flexCheckRF');
                        if (flexCheckRF.prop('checked')) {
                            flexCheckRF = flexCheckRF.next('label').text().trim();
                        } else {
                            flexCheckRF = 'not checked';
                        }

                        // Example for flexCheckASO
                        flexCheckASO = $('#flexCheckASO');
                        if (flexCheckASO.prop('checked')) {
                            flexCheckASO = flexCheckASO.next('label').text().trim();
                        } else {
                            flexCheckASO = 'not checked';
                        }















                        // Example for flexCheckToxoplasmosis
                        flexCheckToxoplasmosis = $('#flexCheckToxoplasmosis');
                        if (flexCheckToxoplasmosis.prop('checked')) {
                            flexCheckToxoplasmosis = flexCheckToxoplasmosis.next('label').text().trim();

                        } else {
                            flexCheckToxoplasmosis = 'not checked';
                        }

                        // Example for flexCheckHpyloriAntibody
                        flexCheckHpyloriAntibody = $('#flexCheckHpyloriAntibody');
                        if (flexCheckHpyloriAntibody.prop('checked')) {
                            flexCheckHpyloriAntibody = flexCheckHpyloriAntibody.next('label').text().trim();

                        } else {
                            flexCheckHpyloriAntibody = 'not checked';
                        }

                        // Example for flexCheckStoolOccultBlood
                        flexCheckStoolOccultBlood = $('#flexCheckStoolOccultBlood');
                        if (flexCheckStoolOccultBlood.prop('checked')) {
                            flexCheckStoolOccultBlood = flexCheckStoolOccultBlood.next('label').text().trim();

                        } else {
                            flexCheckStoolOccultBlood = 'not checked';
                        }

                        // Example for flexCheckGeneralStoolExamination
                        flexCheckGeneralStoolExamination = $('#flexCheckGeneralStoolExamination');
                        if (flexCheckGeneralStoolExamination.prop('checked')) {
                            flexCheckGeneralStoolExamination = flexCheckGeneralStoolExamination.next('label').text().trim();

                        } else {
                            flexCheckGeneralStoolExamination = 'not checked';
                        }

                        // Example for flexCheckThyroidProfile
                        flexCheckThyroidProfile = $('#flexCheckThyroidProfile');
                        if (flexCheckThyroidProfile.prop('checked')) {
                            flexCheckThyroidProfile = flexCheckThyroidProfile.next('label').text().trim();

                        } else {
                            flexCheckThyroidProfile = 'not checked';
                        }

                        // Example for flexCheckT3
                        flexCheckT3 = $('#flexCheckT3');
                        if (flexCheckT3.prop('checked')) {
                            flexCheckT3 = flexCheckT3.next('label').text().trim();

                        } else {
                            flexCheckT3 = 'not checked';
                        }


                        // Example for flexCheckT4
                        flexCheckT4 = $('#flexCheckT4');
                        if (flexCheckT4.prop('checked')) {
                            flexCheckT4 = flexCheckT4.next('label').text().trim();

                        } else {
                            flexCheckT4 = 'not checked';
                        }


                        // Example for flexCheckTSH
                        flexCheckTSH = $('#flexCheckTSH');
                        if (flexCheckTSH.prop('checked')) {
                            flexCheckTSH = flexCheckTSH.next('label').text().trim();
                        } else {
                            flexCheckTSH = 'not checked';
                        }

                        // Example for flexCheckSpermExamination
                        flexCheckSpermExamination = $('#flexCheckSpermExamination');
                        if (flexCheckSpermExamination.prop('checked')) {
                            flexCheckSpermExamination = flexCheckSpermExamination.next('label').text().trim();
                        } else {
                            flexCheckSpermExamination = 'not checked';
                        }

                        //// Example for flexCheckVirginalSwab
                        //flexCheckVirginalSwab = $('#flexCheckVirginalSwab');
                        //if (flexCheckVirginalSwab.prop('checked')) {
                        //    flexCheckVirginalSwab = flexCheckVirginalSwab.next('label').text().trim();
                        //} else {
                        //    flexCheckVirginalSwab = 'not checked';
                        //}

                        // Example for flexCheckTrichomonasVirginals
                        flexCheckTrichomonasVirginals = $('#flexCheckTrichomonasVirginals');
                        if (flexCheckTrichomonasVirginals.prop('checked')) {
                            flexCheckTrichomonasVirginals = flexCheckTrichomonasVirginals.next('label').text().trim();
                        } else {
                            flexCheckTrichomonasVirginals = 'not checked';
                        }

                        // Example for flexCheckHCG
                        flexCheckHCG = $('#flexCheckHCG');
                        if (flexCheckHCG.prop('checked')) {
                            flexCheckHCG = flexCheckHCG.next('label').text().trim();
                        } else {
                            flexCheckHCG = 'not checked';
                        }

                        // Example for flexCheckGeneralHealthCheck
                        flexCheckGeneralHealthCheck = $('#flexCheckGeneralHealthCheck');
                        if (flexCheckGeneralHealthCheck.prop('checked')) {
                            flexCheckGeneralHealthCheck = flexCheckGeneralHealthCheck.next('label').text().trim();
                        } else {
                            flexCheckGeneralHealthCheck = 'not checked';
                        }

                        // Example for flexCheckECG
                        flexCheckECG = $('#flexCheckECG');
                        if (flexCheckECG.prop('checked')) {
                            flexCheckECG = flexCheckECG.next('label').text().trim();
                        } else {
                            flexCheckECG = 'not checked';
                        }

                        // Example for flexCheckXRay
                        flexCheckXRay = $('#flexCheckXRay');
                        if (flexCheckXRay.prop('checked')) {
                            flexCheckXRay = flexCheckXRay.next('label').text().trim();
                        } else {
                            flexCheckXRay = 'not checked';
                        }

                        // Example for flexCheckUltrasound
                        flexCheckUltrasound = $('#flexCheckUltrasound');
                        if (flexCheckUltrasound.prop('checked')) {
                            flexCheckUltrasound = flexCheckUltrasound.next('label').text().trim();
                        } else {
                            flexCheckUltrasound = 'not checked';
                        }

                        // Example for flexCheckCTScan
                        flexCheckCTScan = $('#flexCheckCTScan');
                        if (flexCheckCTScan.prop('checked')) {
                            flexCheckCTScan = flexCheckCTScan.next('label').text().trim();
                        } else {
                            flexCheckCTScan = 'not checked';
                        }

                        // Example for flexCheckMRI
                        flexCheckMRI = $('#flexCheckMRI');
                        if (flexCheckMRI.prop('checked')) {
                            flexCheckMRI = flexCheckMRI.next('label').text().trim();
                        } else {
                            flexCheckMRI = 'not checked';
                        }

                        // Example for flexCheckCardiacEvaluation
                        flexCheckCardiacEvaluation = $('#flexCheckCardiacEvaluation');
                        if (flexCheckCardiacEvaluation.prop('checked')) {
                            flexCheckCardiacEvaluation = flexCheckCardiacEvaluation.next('label').text().trim();
                        } else {
                            flexCheckCardiacEvaluation = 'not checked';
                        }

                        // Example for flexCheckEEG
                        flexCheckEEG = $('#flexCheckEEG');
                        if (flexCheckEEG.prop('checked')) {
                            flexCheckEEG = flexCheckEEG.next('label').text().trim();
                        } else {
                            flexCheckEEG = 'not checked';
                        }

                        // Example for flexCheckEchocardiogram
                        flexCheckEchocardiogram = $('#flexCheckEchocardiogram');
                        if (flexCheckEchocardiogram.prop('checked')) {
                            flexCheckEchocardiogram = flexCheckEchocardiogram.next('label').text().trim();
                        } else {
                            flexCheckEchocardiogram = 'not checked';
                        }

                        // Example for flexCheckBoneDensity
                        flexCheckBoneDensity = $('#flexCheckBoneDensity');
                        if (flexCheckBoneDensity.prop('checked')) {
                            flexCheckBoneDensity = flexCheckBoneDensity.next('label').text().trim();
                        } else {
                            flexCheckBoneDensity = 'not checked';
                        }

                        // Example for flexCheckMammogram
                        flexCheckMammogram = $('#flexCheckMammogram');
                        if (flexCheckMammogram.prop('checked')) {
                            flexCheckMammogram = flexCheckMammogram.next('label').text().trim();
                        } else {
                            flexCheckMammogram = 'not checked';
                        }

                        // Example for flexCheckPAPSmear
                        flexCheckPAPSmear = $('#flexCheckPAPSmear');
                        if (flexCheckPAPSmear.prop('checked')) {
                            flexCheckPAPSmear = flexCheckPAPSmear.next('label').text().trim();
                        } else {
                            flexCheckPAPSmear = 'not checked';
                        }
                        // Example for flexCheckPAPSmear
                        flexCheckGeneralUrineExamination = $('#flexCheckGeneralUrineExamination');
                        if (flexCheckGeneralUrineExamination.prop('checked')) {
                            flexCheckGeneralUrineExamination = flexCheckGeneralUrineExamination.next('label').text().trim();
                        } else {
                            flexCheckGeneralUrineExamination = 'not checked';
                        }


                        // Example for flexCheckPAPSmear
                        flexCheckHemoglobinA1c = $('#flexCheckHemoglobinA1c');
                        if (flexCheckHemoglobinA1c.prop('checked')) {
                            flexCheckHemoglobinA1c = flexCheckHemoglobinA1c.next('label').text().trim();
                        } else {
                            flexCheckHemoglobinA1c = 'not checked';
                        }


                        // Example for flexCheckPAPSmear
                        flexCheckFastingBloodSugar = $('#flexCheckFastingBloodSugar');
                        if (flexCheckFastingBloodSugar.prop('checked')) {
                            flexCheckFastingBloodSugar = flexCheckFastingBloodSugar.next('label').text().trim();
                        } else {
                            flexCheckFastingBloodSugar = 'not checked';
                        }

                        // Example for flexCheckPAPSmear
                        flexCheckHpyloriAgStool = $('#flexCheckHpyloriAgStool');
                        if (flexCheckHpyloriAgStool.prop('checked')) {
                            flexCheckHpyloriAgStool = flexCheckHpyloriAgStool.next('label').text().trim();
                        } else {
                            flexCheckHpyloriAgStool = 'not checked';
                        }

                        // New lab tests processing
                        flexCheckTroponinI = $('#flexCheckTroponinI');
                        if (flexCheckTroponinI.prop('checked')) {
                            flexCheckTroponinI = flexCheckTroponinI.next('label').text().trim();
                        } else {
                            flexCheckTroponinI = 'not checked';
                        }

                        flexCheckCKMB = $('#flexCheckCKMB');
                        if (flexCheckCKMB.prop('checked')) {
                            flexCheckCKMB = flexCheckCKMB.next('label').text().trim();
                        } else {
                            flexCheckCKMB = 'not checked';
                        }

                        flexCheckAPTT = $('#flexCheckAPTT');
                        if (flexCheckAPTT.prop('checked')) {
                            flexCheckAPTT = flexCheckAPTT.next('label').text().trim();
                        } else {
                            flexCheckAPTT = 'not checked';
                        }

                        flexCheckINR = $('#flexCheckINR');
                        if (flexCheckINR.prop('checked')) {
                            flexCheckINR = flexCheckINR.next('label').text().trim();
                        } else {
                            flexCheckINR = 'not checked';
                        }

                        flexCheckDDimer = $('#flexCheckDDimer');
                        if (flexCheckDDimer.prop('checked')) {
                            flexCheckDDimer = flexCheckDDimer.next('label').text().trim();
                        } else {
                            flexCheckDDimer = 'not checked';
                        }

                        flexCheckVitaminD = $('#flexCheckVitaminD');
                        if (flexCheckVitaminD.prop('checked')) {
                            flexCheckVitaminD = flexCheckVitaminD.next('label').text().trim();
                        } else {
                            flexCheckVitaminD = 'not checked';
                        }

                        flexCheckVitaminB12 = $('#flexCheckVitaminB12');
                        if (flexCheckVitaminB12.prop('checked')) {
                            flexCheckVitaminB12 = flexCheckVitaminB12.next('label').text().trim();
                        } else {
                            flexCheckVitaminB12 = 'not checked';
                        }

                        flexCheckFerritin = $('#flexCheckFerritin');
                        if (flexCheckFerritin.prop('checked')) {
                            flexCheckFerritin = flexCheckFerritin.next('label').text().trim();
                        } else {
                            flexCheckFerritin = 'not checked';
                        }

                        flexCheckVDRL = $('#flexCheckVDRL');
                        if (flexCheckVDRL.prop('checked')) {
                            flexCheckVDRL = flexCheckVDRL.next('label').text().trim();
                        } else {
                            flexCheckVDRL = 'not checked';
                        }

                        flexCheckDengueFever = $('#flexCheckDengueFever');
                        if (flexCheckDengueFever.prop('checked')) {
                            flexCheckDengueFever = flexCheckDengueFever.next('label').text().trim();
                        } else {
                            flexCheckDengueFever = 'not checked';
                        }

                        flexCheckGonorrheaAg = $('#flexCheckGonorrheaAg');
                        if (flexCheckGonorrheaAg.prop('checked')) {
                            flexCheckGonorrheaAg = flexCheckGonorrheaAg.next('label').text().trim();
                        } else {
                            flexCheckGonorrheaAg = 'not checked';
                        }

                        flexCheckAFP = $('#flexCheckAFP');
                        if (flexCheckAFP.prop('checked')) {
                            flexCheckAFP = flexCheckAFP.next('label').text().trim();
                        } else {
                            flexCheckAFP = 'not checked';
                        }

                        flexCheckTotalPSA = $('#flexCheckTotalPSA');
                        if (flexCheckTotalPSA.prop('checked')) {
                            flexCheckTotalPSA = flexCheckTotalPSA.next('label').text().trim();
                        } else {
                            flexCheckTotalPSA = 'not checked';
                        }

                        flexCheckAMH = $('#flexCheckAMH');
                        if (flexCheckAMH.prop('checked')) {
                            flexCheckAMH = flexCheckAMH.next('label').text().trim();
                        } else {
                            flexCheckAMH = 'not checked';
                        }

                        flexCheckElectrolyteTest = $('#flexCheckElectrolyteTest');
                        if (flexCheckElectrolyteTest.prop('checked')) {
                            flexCheckElectrolyteTest = flexCheckElectrolyteTest.next('label').text().trim();
                        } else {
                            flexCheckElectrolyteTest = 'not checked';
                        }

                        flexCheckCRPTiter = $('#flexCheckCRPTiter');
                        if (flexCheckCRPTiter.prop('checked')) {
                            flexCheckCRPTiter = flexCheckCRPTiter.next('label').text().trim();
                        } else {
                            flexCheckCRPTiter = 'not checked';
                        }

                        flexCheckUltra = $('#flexCheckUltra');
                        if (flexCheckUltra.prop('checked')) {
                            flexCheckUltra = flexCheckUltra.next('label').text().trim();
                        } else {
                            flexCheckUltra = 'not checked';
                        }

                        flexCheckTyphoidIgG = $('#flexCheckTyphoidIgG');
                        if (flexCheckTyphoidIgG.prop('checked')) {
                            flexCheckTyphoidIgG = flexCheckTyphoidIgG.next('label').text().trim();
                        } else {
                            flexCheckTyphoidIgG = 'not checked';
                        }

                        flexCheckTyphoidAg = $('#flexCheckTyphoidAg');
                        if (flexCheckTyphoidAg.prop('checked')) {
                            flexCheckTyphoidAg = flexCheckTyphoidAg.next('label').text().trim();
                        } else {
                            flexCheckTyphoidAg = 'not checked';
                        }


                        // Example for flexCheckPAPSmear
                        flexCheckTyphoid = $('#flexCheckTyphoid');
                        if (flexCheckTyphoid.prop('checked')) {
                            flexCheckTyphoid = flexCheckTyphoid.next('label').text().trim();
                        } else {
                            flexCheckTyphoid = 'not checked';
                        }



                        var id = parseInt($("#label2").html());

                        var presc = $("#labid").val();

                        $.ajax({
                            url: 'assingxray.aspx/submitdata',
                            data: "{'id':'" + id + "', 'presc':'" + presc + "','flexCheckDirectBilirubin':'" + flexCheckDirectBilirubin + "','flexCheckGeneralUrineExamination':'" + flexCheckGeneralUrineExamination + "','flexCheckProgesteroneFemale':'" + flexCheckProgesteroneFemale + "','flexCheckAmylase':'" + flexCheckAmylase + "','flexCheckMagnesium':'" + flexCheckMagnesium + "','flexCheckPhosphorous':'" + flexCheckPhosphorous + "','flexCheckCalcium':'" + flexCheckCalcium + "','flexCheckChloride':'" + flexCheckChloride + "','flexCheckPotassium':'" + flexCheckPotassium + "','flexCheckSodium':'" + flexCheckSodium + "','flexCheckUricAcid':'" + flexCheckUricAcid + "','flexCheckCreatinine':'" + flexCheckCreatinine + "','flexCheckUrea':'" + flexCheckUrea + "','flexCheckJGlobulin':'" + flexCheckJGlobulin + "','flexCheckAlbumin':'" + flexCheckAlbumin + "','flexCheckTotalBilirubin':'" + flexCheckTotalBilirubin + "','flexCheckAlkalinePhosphatesALP':'" + flexCheckAlkalinePhosphatesALP + "','flexCheckSGOTAST':'" + flexCheckSGOTAST + "','flexCheckSGPTALT':'" + flexCheckSGPTALT + "','flexCheckLiverFunctionTest':'" + flexCheckLiverFunctionTest + "','flexCheckTriglycerides':'" + flexCheckTriglycerides + "','flexCheckTotalCholesterol':'" + flexCheckTotalCholesterol + "','flexCheckHemoglobinA1c':'" + flexCheckHemoglobinA1c + "','flexCheckHDL':'" + flexCheckHDL + "','flexCheckLDL':'" + flexCheckLDL + "','flexCheckFSH':'" + flexCheckFSH + "','flexCheckEstradiol':'" + flexCheckEstradiol + "','flexCheckLH':'" + flexCheckLH + "','flexCheckTestosteroneMale':'" + flexCheckTestosteroneMale + "','flexCheckProlactin':'" + flexCheckProlactin + "','flexCheckSeminalFluidAnalysis':'" + flexCheckSeminalFluidAnalysis + "','flexCheckBHCG':'" + flexCheckBHCG + "','flexCheckUrineExamination':'" + flexCheckUrineExamination + "','flexCheckStoolExamination':'" + flexCheckStoolExamination + "','flexCheckHemoglobin':'" + flexCheckHemoglobin + "','flexCheckMalaria':'" + flexCheckMalaria + "','flexCheckESR':'" + flexCheckESR + "','flexCheckBloodGrouping':'" + flexCheckBloodGrouping + "','flexCheckBloodSugar':'" + flexCheckBloodSugar + "','flexCheckCBC':'" + flexCheckCBC + "','flexCheckCrossMatching':'" + flexCheckCrossMatching + "','flexCheckTPHA':'" + flexCheckTPHA + "','flexCheckHIV':'" + flexCheckHIV + "','flexCheckHBV':'" + flexCheckHBV + "','flexCheckHCV':'" + flexCheckHCV + "','flexCheckBrucellaMelitensis':'" + flexCheckBrucellaMelitensis + "','flexCheckBrucellaAbortus':'" + flexCheckBrucellaAbortus + "','flexCheckCRP':'" + flexCheckCRP + "','flexCheckRF':'" + flexCheckRF + "','flexCheckASO':'" + flexCheckASO + "','flexCheckToxoplasmosis':'" + flexCheckToxoplasmosis + "','flexCheckTyphoid':'" + flexCheckTyphoid + "','flexCheckHpyloriAntibody':'" + flexCheckHpyloriAntibody + "','flexCheckStoolOccultBlood':'" + flexCheckStoolOccultBlood + "','flexCheckGeneralStoolExamination':'" + flexCheckGeneralStoolExamination + "','flexCheckThyroidProfile':'" + flexCheckThyroidProfile + "','flexCheckT3':'" + flexCheckT3 + "','flexCheckT4':'" + flexCheckT4 + "','flexCheckTSH':'" + flexCheckTSH + "','flexCheckSpermExamination':'" + flexCheckSpermExamination + "','flexCheckTrichomonasVirginals':'" + flexCheckTrichomonasVirginals + "','flexCheckHCG':'" + flexCheckHCG + "','flexCheckHpyloriAgStool':'" + flexCheckHpyloriAgStool + "','flexCheckFastingBloodSugar':'" + flexCheckFastingBloodSugar + "' }",
                            contentType: 'application/json; charset=utf-8',

                            dataType: 'json',
                            type: 'POST',
                            success: function (response) {
                                console.log(response);
                                if (response.d === 'true') {
                                    Swal.fire(
                                        'Successfully Saved!',
                                        'You added a new Patient!',
                                        'success'
                                    );
                                    $('#staticBackdrop11').modal('hide');
                                    // Uncheck radio2 and other checkboxes
                                    radio21.checked = false;
                                    additionalTests.classList.add('hidden');
                                    // Uncheck all checkboxes with the class 'custom-checkbox'
                                    document.querySelectorAll('.custom-checkbox').forEach(checkbox => {
                                        checkbox.checked = false;
                                    });
                                    // Call the function on document ready
                                    $(document).ready(function () {
                                        loadData();
                                    })
                                } else {
                                    // Handle errors in the response
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Data Insertion Failed',
                                        text: 'There was an error while inserting the data.',
                                    });
                                }


                            },
                            error: function (response) {
                                alert(response.responseText);
                            }
                        });


                    }
                    function isAnyCheckboxChecked() {
                        return document.querySelectorAll('.custom-checkbox:checked').length > 0;
                    }

                    radio2.addEventListener('change', toggleAdditionalTests);
                    submitButton.addEventListener('click', function (event) {
                        event.preventDefault(); // Prevent form submission if inside a form
                        submitLabTest();
                    });

                    // Initially set the controls to hidden and value to 0
                    toggleAdditionalTests();


                });



                function callAjaxFunction() {

                    var flexCheckHDL, flexCheckLDL, flexCheckTotalCholesterol, flexCheckTriglycerides, flexCheckLiverFunctionTest, flexCheckSGPTALT, flexCheckSGOTAST, flexCheckAlkalinePhosphatesALP, flexCheckTotalBilirubin, flexCheckDirectBilirubin, flexCheckAlbumin, flexCheckJGlobulin, flexCheckUrea, flexCheckCreatinine, flexCheckUricAcid, flexCheckSodium, flexCheckPotassium, flexCheckChloride, flexCheckCalcium, flexCheckPhosphorous, flexCheckMagnesium, flexCheckAmylase, flexCheckProgesteroneFemale, flexCheckFSH, flexCheckEstradiol, flexCheckLH, flexCheckTestosteroneMale, flexCheckProlactin, flexCheckSeminalFluidAnalysis, flexCheckBHCG, flexCheckUrineExamination, flexCheckStoolExamination, flexCheckHemoglobin, flexCheckMalaria, flexCheckESR, flexCheckBloodGrouping, flexCheckBloodSugar, flexCheckCBC, flexCheckCrossMatching, flexCheckTPHA, flexCheckHIV, flexCheckHBV, flexCheckHCV, flexCheckBrucellaMelitensis, flexCheckBrucellaAbortus, flexCheckCRP, flexCheckRF, flexCheckASO, flexCheckToxoplasmosis, flexCheckTyphoid, flexCheckHpyloriAntibody, flexCheckStoolOccultBlood, flexCheckGeneralStoolExamination, flexCheckThyroidProfile, flexCheckT3, flexCheckT4, flexCheckTSH, flexCheckSpermExamination, flexCheckTrichomonasVirginals, flexCheckHCG, flexCheckHpyloriAgStool, flexCheckFastingBloodSugar, flexCheckHemoglobinA1c, flexCheckGeneralUrineExamination, flexCheckTroponinI, flexCheckCKMB, flexCheckAPTT, flexCheckINR, flexCheckDDimer, flexCheckVitaminD, flexCheckVitaminB12, flexCheckFerritin, flexCheckVDRL, flexCheckDengueFever, flexCheckGonorrheaAg, flexCheckAFP, flexCheckTotalPSA, flexCheckAMH;
                    // Example for flexCheckHDL
                    flexCheckHDL = $('#flexCheckHDL');
                    if (flexCheckHDL.prop('checked')) {
                        flexCheckHDL = flexCheckHDL.next('label').text().trim();
                    } else {
                        flexCheckHDL = 'not checked';
                    }

                    // Example for flexCheckLDL
                    flexCheckLDL = $('#flexCheckLDL');
                    if (flexCheckLDL.prop('checked')) {
                        flexCheckLDL = flexCheckLDL.next('label').text().trim();
                    } else {
                        flexCheckLDL = 'not checked';
                    }

                    // Example for flexCheckTotalCholesterol
                    flexCheckTotalCholesterol = $('#flexCheckTotalCholesterol');
                    if (flexCheckTotalCholesterol.prop('checked')) {
                        flexCheckTotalCholesterol = flexCheckTotalCholesterol.next('label').text().trim();
                    } else {
                        flexCheckTotalCholesterol = 'not checked';
                    }

                    // Example for flexCheckTriglycerides
                    flexCheckTriglycerides = $('#flexCheckTriglycerides');
                    if (flexCheckTriglycerides.prop('checked')) {
                        flexCheckTriglycerides = flexCheckTriglycerides.next('label').text().trim();
                    } else {
                        flexCheckTriglycerides = 'not checked';
                    }

                    // Example for flexCheckLiverFunctionTest
                    flexCheckLiverFunctionTest = $('#flexCheckLiverFunctionTest');
                    if (flexCheckLiverFunctionTest.prop('checked')) {
                        flexCheckLiverFunctionTest = flexCheckLiverFunctionTest.next('label').text().trim();
                    } else {
                        flexCheckLiverFunctionTest = 'not checked';
                    }

                    // Example for flexCheckSGPTALT
                    flexCheckSGPTALT = $('#flexCheckSGPTALT');
                    if (flexCheckSGPTALT.prop('checked')) {
                        flexCheckSGPTALT = flexCheckSGPTALT.next('label').text().trim();
                    } else {
                        flexCheckSGPTALT = 'not checked';
                    }

                    // Example for flexCheckSGOTAST
                    flexCheckSGOTAST = $('#flexCheckSGOTAST');
                    if (flexCheckSGOTAST.prop('checked')) {
                        flexCheckSGOTAST = flexCheckSGOTAST.next('label').text().trim();
                    } else {
                        flexCheckSGOTAST = 'not checked';
                    }

                    // Example for flexCheckAlkalinePhosphatesALP
                    flexCheckAlkalinePhosphatesALP = $('#flexCheckAlkalinePhosphatesALP');
                    if (flexCheckAlkalinePhosphatesALP.prop('checked')) {
                        flexCheckAlkalinePhosphatesALP = flexCheckAlkalinePhosphatesALP.next('label').text().trim();
                    } else {
                        flexCheckAlkalinePhosphatesALP = 'not checked';
                    }

                    // Example for flexCheckTotalBilirubin
                    flexCheckTotalBilirubin = $('#flexCheckTotalBilirubin');
                    if (flexCheckTotalBilirubin.prop('checked')) {
                        flexCheckTotalBilirubin = flexCheckTotalBilirubin.next('label').text().trim();
                    } else {
                        flexCheckTotalBilirubin = 'not checked';
                    }

                    // Example for flexCheckDirectBilirubin
                    flexCheckDirectBilirubin = $('#flexCheckDirectBilirubin');
                    if (flexCheckDirectBilirubin.prop('checked')) {
                        flexCheckDirectBilirubin = flexCheckDirectBilirubin.next('label').text().trim();
                    } else {
                        flexCheckDirectBilirubin = 'not checked';
                    }

                    // Example for flexCheckAlbumin
                    flexCheckAlbumin = $('#flexCheckAlbumin');
                    if (flexCheckAlbumin.prop('checked')) {
                        flexCheckAlbumin = flexCheckAlbumin.next('label').text().trim();
                    } else {
                        flexCheckAlbumin = 'not checked';
                    }

                    // Example for flexCheckJGlobulin
                    flexCheckJGlobulin = $('#flexCheckJGlobulin');
                    if (flexCheckJGlobulin.prop('checked')) {
                        flexCheckJGlobulin = flexCheckJGlobulin.next('label').text().trim();
                    } else {
                        flexCheckJGlobulin = 'not checked';
                    }

                    // Example for flexCheckUrea
                    flexCheckUrea = $('#flexCheckUrea');
                    if (flexCheckUrea.prop('checked')) {
                        flexCheckUrea = flexCheckUrea.next('label').text().trim();
                    } else {
                        flexCheckUrea = 'not checked';
                    }

                    // Example for flexCheckCreatinine
                    flexCheckCreatinine = $('#flexCheckCreatinine');
                    if (flexCheckCreatinine.prop('checked')) {
                        flexCheckCreatinine = flexCheckCreatinine.next('label').text().trim();
                    } else {
                        flexCheckCreatinine = 'not checked';
                    }

                    // Example for flexCheckUricAcid
                    flexCheckUricAcid = $('#flexCheckUricAcid');
                    if (flexCheckUricAcid.prop('checked')) {
                        flexCheckUricAcid = flexCheckUricAcid.next('label').text().trim();
                    } else {
                        flexCheckUricAcid = 'not checked';
                    }

                    // Example for flexCheckSodium
                    flexCheckSodium = $('#flexCheckSodium');
                    if (flexCheckSodium.prop('checked')) {
                        flexCheckSodium = flexCheckSodium.next('label').text().trim();
                    } else {
                        flexCheckSodium = 'not checked';
                    }

                    // Example for flexCheckPotassium
                    flexCheckPotassium = $('#flexCheckPotassium');
                    if (flexCheckPotassium.prop('checked')) {
                        flexCheckPotassium = flexCheckPotassium.next('label').text().trim();
                    } else {
                        flexCheckPotassium = 'not checked';
                    }

                    // Example for flexCheckChloride
                    flexCheckChloride = $('#flexCheckChloride');
                    if (flexCheckChloride.prop('checked')) {
                        flexCheckChloride = flexCheckChloride.next('label').text().trim();
                    } else {
                        flexCheckChloride = 'not checked';
                    }

                    // Example for flexCheckCalcium
                    flexCheckCalcium = $('#flexCheckCalcium');
                    if (flexCheckCalcium.prop('checked')) {
                        flexCheckCalcium = flexCheckCalcium.next('label').text().trim();
                    } else {
                        flexCheckCalcium = 'not checked';
                    }

                    // Example for flexCheckPhosphorous
                    flexCheckPhosphorous = $('#flexCheckPhosphorous');
                    if (flexCheckPhosphorous.prop('checked')) {
                        flexCheckPhosphorous = flexCheckPhosphorous.next('label').text().trim();
                    } else {
                        flexCheckPhosphorous = 'not checked';
                    }

                    // Example for flexCheckMagnesium
                    flexCheckMagnesium = $('#flexCheckMagnesium');
                    if (flexCheckMagnesium.prop('checked')) {
                        flexCheckMagnesium = flexCheckMagnesium.next('label').text().trim();
                    } else {
                        flexCheckMagnesium = 'not checked';
                    }

                    // Example for flexCheckAmylase
                    flexCheckAmylase = $('#flexCheckAmylase');
                    if (flexCheckAmylase.prop('checked')) {
                        flexCheckAmylase = flexCheckAmylase.next('label').text().trim();
                    } else {
                        flexCheckAmylase = 'not checked';
                    }

                    // Example for flexCheckProgesteroneFemale
                    flexCheckProgesteroneFemale = $('#flexCheckProgesteroneFemale');
                    if (flexCheckProgesteroneFemale.prop('checked')) {
                        flexCheckProgesteroneFemale = flexCheckProgesteroneFemale.next('label').text().trim();
                    } else {
                        flexCheckProgesteroneFemale = 'not checked';
                    }

                    // Example for flexCheckFSH
                    flexCheckFSH = $('#flexCheckFSH');
                    if (flexCheckFSH.prop('checked')) {
                        flexCheckFSH = flexCheckFSH.next('label').text().trim();
                    } else {
                        flexCheckFSH = 'not checked';
                    }

                    // Example for flexCheckEstradiol
                    flexCheckEstradiol = $('#flexCheckEstradiol');
                    if (flexCheckEstradiol.prop('checked')) {
                        flexCheckEstradiol = flexCheckEstradiol.next('label').text().trim();
                    } else {
                        flexCheckEstradiol = 'not checked';
                    }

                    // Example for flexCheckLH
                    flexCheckLH = $('#flexCheckLH');
                    if (flexCheckLH.prop('checked')) {
                        flexCheckLH = flexCheckLH.next('label').text().trim();
                    } else {
                        flexCheckLH = 'not checked';
                    }

                    // Example for flexCheckTestosteroneMale
                    flexCheckTestosteroneMale = $('#flexCheckTestosteroneMale');
                    if (flexCheckTestosteroneMale.prop('checked')) {
                        flexCheckTestosteroneMale = flexCheckTestosteroneMale.next('label').text().trim();
                    } else {
                        flexCheckTestosteroneMale = 'not checked';
                    }

                    // Example for flexCheckProlactin
                    flexCheckProlactin = $('#flexCheckProlactin');
                    if (flexCheckProlactin.prop('checked')) {
                        flexCheckProlactin = flexCheckProlactin.next('label').text().trim();
                    } else {
                        flexCheckProlactin = 'not checked';
                    }

                    // Example for flexCheckSeminalFluidAnalysis
                    flexCheckSeminalFluidAnalysis = $('#flexCheckSeminalFluidAnalysis');
                    if (flexCheckSeminalFluidAnalysis.prop('checked')) {
                        flexCheckSeminalFluidAnalysis = flexCheckSeminalFluidAnalysis.next('label').text().trim();
                    } else {
                        flexCheckSeminalFluidAnalysis = 'not checked';
                    }

                    // Example for flexCheckBHCG
                    flexCheckBHCG = $('#flexCheckBHCG');
                    if (flexCheckBHCG.prop('checked')) {
                        flexCheckBHCG = flexCheckBHCG.next('label').text().trim();
                    } else {
                        flexCheckBHCG = 'not checked';
                    }

                    // Example for flexCheckUrineExamination
                    flexCheckUrineExamination = $('#flexCheckUrineExamination');
                    if (flexCheckUrineExamination.prop('checked')) {
                        flexCheckUrineExamination = flexCheckUrineExamination.next('label').text().trim();
                    } else {
                        flexCheckUrineExamination = 'not checked';
                    }

                    // Example for flexCheckStoolExamination
                    flexCheckStoolExamination = $('#flexCheckStoolExamination');
                    if (flexCheckStoolExamination.prop('checked')) {
                        flexCheckStoolExamination = flexCheckStoolExamination.next('label').text().trim();
                    } else {
                        flexCheckStoolExamination = 'not checked';
                    }

                    // Example for flexCheckHemoglobin
                    flexCheckHemoglobin = $('#flexCheckHemoglobin');
                    if (flexCheckHemoglobin.prop('checked')) {
                        flexCheckHemoglobin = flexCheckHemoglobin.next('label').text().trim();
                    } else {
                        flexCheckHemoglobin = 'not checked';
                    }

                    // Example for flexCheckMalaria
                    flexCheckMalaria = $('#flexCheckMalaria');
                    if (flexCheckMalaria.prop('checked')) {
                        flexCheckMalaria = flexCheckMalaria.next('label').text().trim();
                    } else {
                        flexCheckMalaria = 'not checked';
                    }

                    // Example for flexCheckESR
                    flexCheckESR = $('#flexCheckESR');
                    if (flexCheckESR.prop('checked')) {
                        flexCheckESR = flexCheckESR.next('label').text().trim();
                    } else {
                        flexCheckESR = 'not checked';
                    }

                    // Example for flexCheckBloodGrouping
                    flexCheckBloodGrouping = $('#flexCheckBloodGrouping');
                    if (flexCheckBloodGrouping.prop('checked')) {
                        flexCheckBloodGrouping = flexCheckBloodGrouping.next('label').text().trim();
                    } else {
                        flexCheckBloodGrouping = 'not checked';
                    }

                    // Example for flexCheckBloodSugar
                    flexCheckBloodSugar = $('#flexCheckBloodSugar');
                    if (flexCheckBloodSugar.prop('checked')) {
                        flexCheckBloodSugar = flexCheckBloodSugar.next('label').text().trim();
                    } else {
                        flexCheckBloodSugar = 'not checked';
                    }

                    // Example for flexCheckCBC
                    flexCheckCBC = $('#flexCheckCBC');
                    if (flexCheckCBC.prop('checked')) {
                        flexCheckCBC = flexCheckCBC.next('label').text().trim();
                    } else {
                        flexCheckCBC = 'not checked';
                    }

                    // Example for flexCheckCrossMatching
                    flexCheckCrossMatching = $('#flexCheckCrossMatching');
                    if (flexCheckCrossMatching.prop('checked')) {
                        flexCheckCrossMatching = flexCheckCrossMatching.next('label').text().trim();
                    } else {
                        flexCheckCrossMatching = 'not checked';
                    }

                    // Example for flexCheckTPHA
                    flexCheckTPHA = $('#flexCheckTPHA');
                    if (flexCheckTPHA.prop('checked')) {
                        flexCheckTPHA = flexCheckTPHA.next('label').text().trim();
                    } else {
                        flexCheckTPHA = 'not checked';
                    }

                    // Example for flexCheckHIV
                    flexCheckHIV = $('#flexCheckHIV');
                    if (flexCheckHIV.prop('checked')) {
                        flexCheckHIV = flexCheckHIV.next('label').text().trim();
                    } else {
                        flexCheckHIV = 'not checked';
                    }

                    // Example for flexCheckHBV
                    flexCheckHBV = $('#flexCheckHBV');
                    if (flexCheckHBV.prop('checked')) {
                        flexCheckHBV = flexCheckHBV.next('label').text().trim();
                    } else {
                        flexCheckHBV = 'not checked';
                    }

                    // Example for flexCheckHCV
                    flexCheckHCV = $('#flexCheckHCV');
                    if (flexCheckHCV.prop('checked')) {
                        flexCheckHCV = flexCheckHCV.next('label').text().trim();
                    } else {
                        flexCheckHCV = 'not checked';
                    }

                    // Example for flexCheckBrucellaMelitensis
                    flexCheckBrucellaMelitensis = $('#flexCheckBrucellaMelitensis');
                    if (flexCheckBrucellaMelitensis.prop('checked')) {
                        flexCheckBrucellaMelitensis = flexCheckBrucellaMelitensis.next('label').text().trim();
                    } else {
                        flexCheckBrucellaMelitensis = 'not checked';
                    }

                    // Example for flexCheckBrucellaAbortus
                    flexCheckBrucellaAbortus = $('#flexCheckBrucellaAbortus');
                    if (flexCheckBrucellaAbortus.prop('checked')) {
                        flexCheckBrucellaAbortus = flexCheckBrucellaAbortus.next('label').text().trim();
                    } else {
                        flexCheckBrucellaAbortus = 'not checked';
                    }

                    // Example for flexCheckCRP
                    flexCheckCRP = $('#flexCheckCRP');
                    if (flexCheckCRP.prop('checked')) {
                        flexCheckCRP = flexCheckCRP.next('label').text().trim();
                    } else {
                        flexCheckCRP = 'not checked';
                    }

                    // Example for flexCheckRF
                    flexCheckRF = $('#flexCheckRF');
                    if (flexCheckRF.prop('checked')) {
                        flexCheckRF = flexCheckRF.next('label').text().trim();
                    } else {
                        flexCheckRF = 'not checked';
                    }

                    // Example for flexCheckASO
                    flexCheckASO = $('#flexCheckASO');
                    if (flexCheckASO.prop('checked')) {
                        flexCheckASO = flexCheckASO.next('label').text().trim();
                    } else {
                        flexCheckASO = 'not checked';
                    }















                    // Example for flexCheckToxoplasmosis
                    flexCheckToxoplasmosis = $('#flexCheckToxoplasmosis');
                    if (flexCheckToxoplasmosis.prop('checked')) {
                        flexCheckToxoplasmosis = flexCheckToxoplasmosis.next('label').text().trim();

                    } else {
                        flexCheckToxoplasmosis = 'not checked';
                    }

                    // Example for flexCheckHpyloriAntibody
                    flexCheckHpyloriAntibody = $('#flexCheckHpyloriAntibody');
                    if (flexCheckHpyloriAntibody.prop('checked')) {
                        flexCheckHpyloriAntibody = flexCheckHpyloriAntibody.next('label').text().trim();

                    } else {
                        flexCheckHpyloriAntibody = 'not checked';
                    }

                    // Example for flexCheckStoolOccultBlood
                    flexCheckStoolOccultBlood = $('#flexCheckStoolOccultBlood');
                    if (flexCheckStoolOccultBlood.prop('checked')) {
                        flexCheckStoolOccultBlood = flexCheckStoolOccultBlood.next('label').text().trim();

                    } else {
                        flexCheckStoolOccultBlood = 'not checked';
                    }

                    // Example for flexCheckGeneralStoolExamination
                    flexCheckGeneralStoolExamination = $('#flexCheckGeneralStoolExamination');
                    if (flexCheckGeneralStoolExamination.prop('checked')) {
                        flexCheckGeneralStoolExamination = flexCheckGeneralStoolExamination.next('label').text().trim();

                    } else {
                        flexCheckGeneralStoolExamination = 'not checked';
                    }

                    // Example for flexCheckThyroidProfile
                    flexCheckThyroidProfile = $('#flexCheckThyroidProfile');
                    if (flexCheckThyroidProfile.prop('checked')) {
                        flexCheckThyroidProfile = flexCheckThyroidProfile.next('label').text().trim();

                    } else {
                        flexCheckThyroidProfile = 'not checked';
                    }

                    // Example for flexCheckT3
                    flexCheckT3 = $('#flexCheckT3');
                    if (flexCheckT3.prop('checked')) {
                        flexCheckT3 = flexCheckT3.next('label').text().trim();

                    } else {
                        flexCheckT3 = 'not checked';
                    }


                    // Example for flexCheckT4
                    flexCheckT4 = $('#flexCheckT4');
                    if (flexCheckT4.prop('checked')) {
                        flexCheckT4 = flexCheckT4.next('label').text().trim();

                    } else {
                        flexCheckT4 = 'not checked';
                    }


                    // Example for flexCheckTSH
                    flexCheckTSH = $('#flexCheckTSH');
                    if (flexCheckTSH.prop('checked')) {
                        flexCheckTSH = flexCheckTSH.next('label').text().trim();
                    } else {
                        flexCheckTSH = 'not checked';
                    }

                    // Example for flexCheckSpermExamination
                    flexCheckSpermExamination = $('#flexCheckSpermExamination');
                    if (flexCheckSpermExamination.prop('checked')) {
                        flexCheckSpermExamination = flexCheckSpermExamination.next('label').text().trim();
                    } else {
                        flexCheckSpermExamination = 'not checked';
                    }

                    //// Example for flexCheckVirginalSwab
                    //flexCheckVirginalSwab = $('#flexCheckVirginalSwab');
                    //if (flexCheckVirginalSwab.prop('checked')) {
                    //    flexCheckVirginalSwab = flexCheckVirginalSwab.next('label').text().trim();
                    //} else {
                    //    flexCheckVirginalSwab = 'not checked';
                    //}

                    // Example for flexCheckTrichomonasVirginals
                    flexCheckTrichomonasVirginals = $('#flexCheckTrichomonasVirginals');
                    if (flexCheckTrichomonasVirginals.prop('checked')) {
                        flexCheckTrichomonasVirginals = flexCheckTrichomonasVirginals.next('label').text().trim();
                    } else {
                        flexCheckTrichomonasVirginals = 'not checked';
                    }

                    // Example for flexCheckHCG
                    flexCheckHCG = $('#flexCheckHCG');
                    if (flexCheckHCG.prop('checked')) {
                        flexCheckHCG = flexCheckHCG.next('label').text().trim();
                    } else {
                        flexCheckHCG = 'not checked';
                    }

                    // Example for flexCheckGeneralHealthCheck
                    flexCheckGeneralHealthCheck = $('#flexCheckGeneralHealthCheck');
                    if (flexCheckGeneralHealthCheck.prop('checked')) {
                        flexCheckGeneralHealthCheck = flexCheckGeneralHealthCheck.next('label').text().trim();
                    } else {
                        flexCheckGeneralHealthCheck = 'not checked';
                    }

                    // Example for flexCheckECG
                    flexCheckECG = $('#flexCheckECG');
                    if (flexCheckECG.prop('checked')) {
                        flexCheckECG = flexCheckECG.next('label').text().trim();
                    } else {
                        flexCheckECG = 'not checked';
                    }

                    // Example for flexCheckXRay
                    flexCheckXRay = $('#flexCheckXRay');
                    if (flexCheckXRay.prop('checked')) {
                        flexCheckXRay = flexCheckXRay.next('label').text().trim();
                    } else {
                        flexCheckXRay = 'not checked';
                    }

                    // Example for flexCheckUltrasound
                    flexCheckUltrasound = $('#flexCheckUltrasound');
                    if (flexCheckUltrasound.prop('checked')) {
                        flexCheckUltrasound = flexCheckUltrasound.next('label').text().trim();
                    } else {
                        flexCheckUltrasound = 'not checked';
                    }

                    // Example for flexCheckCTScan
                    flexCheckCTScan = $('#flexCheckCTScan');
                    if (flexCheckCTScan.prop('checked')) {
                        flexCheckCTScan = flexCheckCTScan.next('label').text().trim();
                    } else {
                        flexCheckCTScan = 'not checked';
                    }

                    // Example for flexCheckMRI
                    flexCheckMRI = $('#flexCheckMRI');
                    if (flexCheckMRI.prop('checked')) {
                        flexCheckMRI = flexCheckMRI.next('label').text().trim();
                    } else {
                        flexCheckMRI = 'not checked';
                    }

                    // Example for flexCheckCardiacEvaluation
                    flexCheckCardiacEvaluation = $('#flexCheckCardiacEvaluation');
                    if (flexCheckCardiacEvaluation.prop('checked')) {
                        flexCheckCardiacEvaluation = flexCheckCardiacEvaluation.next('label').text().trim();
                    } else {
                        flexCheckCardiacEvaluation = 'not checked';
                    }

                    // Example for flexCheckEEG
                    flexCheckEEG = $('#flexCheckEEG');
                    if (flexCheckEEG.prop('checked')) {
                        flexCheckEEG = flexCheckEEG.next('label').text().trim();
                    } else {
                        flexCheckEEG = 'not checked';
                    }

                    // Example for flexCheckEchocardiogram
                    flexCheckEchocardiogram = $('#flexCheckEchocardiogram');
                    if (flexCheckEchocardiogram.prop('checked')) {
                        flexCheckEchocardiogram = flexCheckEchocardiogram.next('label').text().trim();
                    } else {
                        flexCheckEchocardiogram = 'not checked';
                    }

                    // Example for flexCheckBoneDensity
                    flexCheckBoneDensity = $('#flexCheckBoneDensity');
                    if (flexCheckBoneDensity.prop('checked')) {
                        flexCheckBoneDensity = flexCheckBoneDensity.next('label').text().trim();
                    } else {
                        flexCheckBoneDensity = 'not checked';
                    }

                    // Example for flexCheckMammogram
                    flexCheckMammogram = $('#flexCheckMammogram');
                    if (flexCheckMammogram.prop('checked')) {
                        flexCheckMammogram = flexCheckMammogram.next('label').text().trim();
                    } else {
                        flexCheckMammogram = 'not checked';
                    }

                    // Example for flexCheckPAPSmear
                    flexCheckPAPSmear = $('#flexCheckPAPSmear');
                    if (flexCheckPAPSmear.prop('checked')) {
                        flexCheckPAPSmear = flexCheckPAPSmear.next('label').text().trim();
                    } else {
                        flexCheckPAPSmear = 'not checked';
                    }
                    // Example for flexCheckPAPSmear
                    flexCheckGeneralUrineExamination = $('#flexCheckGeneralUrineExamination');
                    if (flexCheckGeneralUrineExamination.prop('checked')) {
                        flexCheckGeneralUrineExamination = flexCheckGeneralUrineExamination.next('label').text().trim();
                    } else {
                        flexCheckGeneralUrineExamination = 'not checked';
                    }


                    // Example for flexCheckPAPSmear
                    flexCheckHemoglobinA1c = $('#flexCheckHemoglobinA1c');
                    if (flexCheckHemoglobinA1c.prop('checked')) {
                        flexCheckHemoglobinA1c = flexCheckHemoglobinA1c.next('label').text().trim();
                    } else {
                        flexCheckHemoglobinA1c = 'not checked';
                    }


                    // Example for flexCheckPAPSmear
                    flexCheckFastingBloodSugar = $('#flexCheckFastingBloodSugar');
                    if (flexCheckFastingBloodSugar.prop('checked')) {
                        flexCheckFastingBloodSugar = flexCheckFastingBloodSugar.next('label').text().trim();
                    } else {
                        flexCheckFastingBloodSugar = 'not checked';
                    }

                    // Example for flexCheckPAPSmear
                    flexCheckHpyloriAgStool = $('#flexCheckHpyloriAgStool');
                    if (flexCheckHpyloriAgStool.prop('checked')) {
                        flexCheckHpyloriAgStool = flexCheckHpyloriAgStool.next('label').text().trim();
                    } else {
                        flexCheckHpyloriAgStool = 'not checked';
                    }

                    // New lab tests processing
                    flexCheckTroponinI = $('#flexCheckTroponinI');
                    if (flexCheckTroponinI.prop('checked')) {
                        flexCheckTroponinI = flexCheckTroponinI.next('label').text().trim();
                    } else {
                        flexCheckTroponinI = 'not checked';
                    }

                    flexCheckCKMB = $('#flexCheckCKMB');
                    if (flexCheckCKMB.prop('checked')) {
                        flexCheckCKMB = flexCheckCKMB.next('label').text().trim();
                    } else {
                        flexCheckCKMB = 'not checked';
                    }

                    flexCheckAPTT = $('#flexCheckAPTT');
                    if (flexCheckAPTT.prop('checked')) {
                        flexCheckAPTT = flexCheckAPTT.next('label').text().trim();
                    } else {
                        flexCheckAPTT = 'not checked';
                    }

                    flexCheckINR = $('#flexCheckINR');
                    if (flexCheckINR.prop('checked')) {
                        flexCheckINR = flexCheckINR.next('label').text().trim();
                    } else {
                        flexCheckINR = 'not checked';
                    }

                    flexCheckDDimer = $('#flexCheckDDimer');
                    if (flexCheckDDimer.prop('checked')) {
                        flexCheckDDimer = flexCheckDDimer.next('label').text().trim();
                    } else {
                        flexCheckDDimer = 'not checked';
                    }

                    flexCheckVitaminD = $('#flexCheckVitaminD');
                    if (flexCheckVitaminD.prop('checked')) {
                        flexCheckVitaminD = flexCheckVitaminD.next('label').text().trim();
                    } else {
                        flexCheckVitaminD = 'not checked';
                    }

                    flexCheckVitaminB12 = $('#flexCheckVitaminB12');
                    if (flexCheckVitaminB12.prop('checked')) {
                        flexCheckVitaminB12 = flexCheckVitaminB12.next('label').text().trim();
                    } else {
                        flexCheckVitaminB12 = 'not checked';
                    }

                    flexCheckFerritin = $('#flexCheckFerritin');
                    if (flexCheckFerritin.prop('checked')) {
                        flexCheckFerritin = flexCheckFerritin.next('label').text().trim();
                    } else {
                        flexCheckFerritin = 'not checked';
                    }

                    flexCheckVDRL = $('#flexCheckVDRL');
                    if (flexCheckVDRL.prop('checked')) {
                        flexCheckVDRL = flexCheckVDRL.next('label').text().trim();
                    } else {
                        flexCheckVDRL = 'not checked';
                    }

                    flexCheckDengueFever = $('#flexCheckDengueFever');
                    if (flexCheckDengueFever.prop('checked')) {
                        flexCheckDengueFever = flexCheckDengueFever.next('label').text().trim();
                    } else {
                        flexCheckDengueFever = 'not checked';
                    }

                    flexCheckGonorrheaAg = $('#flexCheckGonorrheaAg');
                    if (flexCheckGonorrheaAg.prop('checked')) {
                        flexCheckGonorrheaAg = flexCheckGonorrheaAg.next('label').text().trim();
                    } else {
                        flexCheckGonorrheaAg = 'not checked';
                    }

                    flexCheckAFP = $('#flexCheckAFP');
                    if (flexCheckAFP.prop('checked')) {
                        flexCheckAFP = flexCheckAFP.next('label').text().trim();
                    } else {
                        flexCheckAFP = 'not checked';
                    }

                    flexCheckTotalPSA = $('#flexCheckTotalPSA');
                    if (flexCheckTotalPSA.prop('checked')) {
                        flexCheckTotalPSA = flexCheckTotalPSA.next('label').text().trim();
                    } else {
                        flexCheckTotalPSA = 'not checked';
                    }

                    flexCheckAMH = $('#flexCheckAMH');
                    if (flexCheckAMH.prop('checked')) {
                        flexCheckAMH = flexCheckAMH.next('label').text().trim();
                    } else {
                        flexCheckAMH = 'not checked';
                    }

                    flexCheckElectrolyteTest = $('#flexCheckElectrolyteTest');
                    if (flexCheckElectrolyteTest.prop('checked')) {
                        flexCheckElectrolyteTest = flexCheckElectrolyteTest.next('label').text().trim();
                    } else {
                        flexCheckElectrolyteTest = 'not checked';
                    }

                    flexCheckCRPTiter = $('#flexCheckCRPTiter');
                    if (flexCheckCRPTiter.prop('checked')) {
                        flexCheckCRPTiter = flexCheckCRPTiter.next('label').text().trim();
                    } else {
                        flexCheckCRPTiter = 'not checked';
                    }

                    flexCheckUltra = $('#flexCheckUltra');
                    if (flexCheckUltra.prop('checked')) {
                        flexCheckUltra = flexCheckUltra.next('label').text().trim();
                    } else {
                        flexCheckUltra = 'not checked';
                    }

                    flexCheckTyphoidIgG = $('#flexCheckTyphoidIgG');
                    if (flexCheckTyphoidIgG.prop('checked')) {
                        flexCheckTyphoidIgG = flexCheckTyphoidIgG.next('label').text().trim();
                    } else {
                        flexCheckTyphoidIgG = 'not checked';
                    }

                    flexCheckTyphoidAg = $('#flexCheckTyphoidAg');
                    if (flexCheckTyphoidAg.prop('checked')) {
                        flexCheckTyphoidAg = flexCheckTyphoidAg.next('label').text().trim();
                    } else {
                        flexCheckTyphoidAg = 'not checked';
                    }


                    // Example for flexCheckPAPSmear
                    flexCheckTyphoid = $('#flexCheckTyphoid');
                    if (flexCheckTyphoid.prop('checked')) {
                        flexCheckTyphoid = flexCheckTyphoid.next('label').text().trim();
                    } else {
                        flexCheckTyphoid = 'not checked';
                    }





                    var id = $("#medid").val();


                    // Build clean data object with all tests including new ones
                    var updateData = {
                        id: id,
                        flexCheckHemoglobin: flexCheckHemoglobin,
                        flexCheckMalaria: flexCheckMalaria,
                        flexCheckESR: flexCheckESR,
                        flexCheckBloodGrouping: flexCheckBloodGrouping,
                        flexCheckBloodSugar: flexCheckBloodSugar,
                        flexCheckCBC: flexCheckCBC,
                        flexCheckCrossMatching: flexCheckCrossMatching,
                        flexCheckTPHA: flexCheckTPHA,
                        flexCheckHIV: flexCheckHIV,
                        flexCheckHBV: flexCheckHBV,
                        flexCheckHCV: flexCheckHCV,
                        flexCheckLDL: flexCheckLDL,
                        flexCheckHDL: flexCheckHDL,
                        flexCheckTotalCholesterol: flexCheckTotalCholesterol,
                        flexCheckTriglycerides: flexCheckTriglycerides,
                        flexCheckLiverFunctionTest: flexCheckLiverFunctionTest,
                        flexCheckSGPTALT: flexCheckSGPTALT,
                        flexCheckSGOTAST: flexCheckSGOTAST,
                        flexCheckAlkalinePhosphatesALP: flexCheckAlkalinePhosphatesALP,
                        flexCheckTotalBilirubin: flexCheckTotalBilirubin,
                        flexCheckDirectBilirubin: flexCheckDirectBilirubin,
                        flexCheckAlbumin: flexCheckAlbumin,
                        flexCheckUrea: flexCheckUrea,
                        flexCheckCreatinine: flexCheckCreatinine,
                        flexCheckUricAcid: flexCheckUricAcid,
                        flexCheckSodium: flexCheckSodium,
                        flexCheckPotassium: flexCheckPotassium,
                        flexCheckChloride: flexCheckChloride,
                        flexCheckCalcium: flexCheckCalcium,
                        flexCheckPhosphorous: flexCheckPhosphorous,
                        flexCheckMagnesium: flexCheckMagnesium,
                        flexCheckGeneralUrineExamination: flexCheckGeneralUrineExamination,
                        flexCheckProgesteroneFemale: flexCheckProgesteroneFemale,
                        flexCheckAmylase: flexCheckAmylase,
                        flexCheckJGlobulin: flexCheckJGlobulin,
                        flexCheckFSH: flexCheckFSH,
                        flexCheckEstradiol: flexCheckEstradiol,
                        flexCheckLH: flexCheckLH,
                        flexCheckTestosteroneMale: flexCheckTestosteroneMale,
                        flexCheckProlactin: flexCheckProlactin,
                        flexCheckSeminalFluidAnalysis: flexCheckSeminalFluidAnalysis,
                        flexCheckBHCG: flexCheckBHCG,
                        flexCheckUrineExamination: flexCheckUrineExamination,
                        flexCheckStoolExamination: flexCheckStoolExamination,
                        flexCheckBrucellaMelitensis: flexCheckBrucellaMelitensis,
                        flexCheckBrucellaAbortus: flexCheckBrucellaAbortus,
                        flexCheckCRP: flexCheckCRP,
                        flexCheckRF: flexCheckRF,
                        flexCheckASO: flexCheckASO,
                        flexCheckToxoplasmosis: flexCheckToxoplasmosis,
                        flexCheckTyphoid: flexCheckTyphoid,
                        flexCheckHpyloriAntibody: flexCheckHpyloriAntibody,
                        flexCheckStoolOccultBlood: flexCheckStoolOccultBlood,
                        flexCheckGeneralStoolExamination: flexCheckGeneralStoolExamination,
                        flexCheckThyroidProfile: flexCheckThyroidProfile,
                        flexCheckT3: flexCheckT3,
                        flexCheckT4: flexCheckT4,
                        flexCheckTSH: flexCheckTSH,
                        flexCheckSpermExamination: flexCheckSpermExamination,
                      
                        flexCheckTrichomonasVirginals: flexCheckTrichomonasVirginals,
                        flexCheckHCG: flexCheckHCG,
                        flexCheckHpyloriAgStool: flexCheckHpyloriAgStool,
                        flexCheckFastingBloodSugar: flexCheckFastingBloodSugar,
                        flexCheckHemoglobinA1c: flexCheckHemoglobinA1c,
                        flexCheckTroponinI: flexCheckTroponinI,
                        flexCheckCKMB: flexCheckCKMB,
                        flexCheckAPTT: flexCheckAPTT,
                        flexCheckINR: flexCheckINR,
                        flexCheckDDimer: flexCheckDDimer,
                        flexCheckVitaminD: flexCheckVitaminD,
                        flexCheckVitaminB12: flexCheckVitaminB12,
                        flexCheckFerritin: flexCheckFerritin,
                        flexCheckVDRL: flexCheckVDRL,
                        flexCheckDengueFever: flexCheckDengueFever,
                        flexCheckGonorrheaAg: flexCheckGonorrheaAg,
                        flexCheckAFP: flexCheckAFP,
                        flexCheckTotalPSA: flexCheckTotalPSA,
                        flexCheckAMH: flexCheckAMH,
                        flexCheckElectrolyteTest: flexCheckElectrolyteTest,
                        flexCheckCRPTiter: flexCheckCRPTiter,
                        flexCheckUltra: flexCheckUltra,
                        flexCheckTyphoidIgG: flexCheckTyphoidIgG,
                        flexCheckTyphoidAg: flexCheckTyphoidAg
                    };

                    $.ajax({
                        url: 'lap_operation.aspx/updateLabTest',
                        data: JSON.stringify(updateData),
                        contentType: 'application/json; charset=utf-8',

                        dataType: 'json',
                        type: 'POST',
                        success: function (response) {
                            console.log(response);


                            $('#staticBackdrop11').modal('hide');

                            Swal.fire(
                                'Successfully Updated !',
                                'You have added a new lab details!',
                                'success'
                            )



                        },
                        error: function (response) {
                            alert(response.responseText);
                        }
                    });


                }

                function showlab() {

                    var prescid = $("#labid").val();

                    event.preventDefault()

                    document.getElementById('submitButton5').style.display = 'inline-block';
                    document.getElementById('submitButton7').style.display = 'none';

                    document.getElementById('updateButton').style.display = 'none';
                    document.getElementById('submitButton').style.display = 'inline-block';

                    // Show the modal
                    $('#staticBackdrop11').modal('show');

                }

                function submitLabTest() {
                    // Prevent duplicate submissions
                    if (window.isSubmittingLabTest) {
                        console.log("Lab test submission already in progress");
                        return false;
                    }

                    window.isSubmittingLabTest = true;
                    var prescid = $("#labid").val();

                    function getCheckVal(id) {
                        // IMPORTANT: Only return label text if checked, otherwise return "not checked"
                        var checkbox = $('#' + id);
                        if (checkbox.prop('checked')) {
                            return checkbox.next('label').text().trim();
                        } else {
                            return 'not checked';
                        }
                    }

                    var data = {
                        id: prescid,
                        presc: prescid,
                        flexCheckGeneralUrineExamination: getCheckVal('flexCheckGeneralUrineExamination'),
                        flexCheckProgesteroneFemale: getCheckVal('flexCheckProgesteroneFemale'),
                        flexCheckAmylase: getCheckVal('flexCheckAmylase'),
                        flexCheckMagnesium: getCheckVal('flexCheckMagnesium'),
                        flexCheckPhosphorous: getCheckVal('flexCheckPhosphorous'),
                        flexCheckCalcium: getCheckVal('flexCheckCalcium'),
                        flexCheckChloride: getCheckVal('flexCheckChloride'),
                        flexCheckPotassium: getCheckVal('flexCheckPotassium'),
                        flexCheckSodium: getCheckVal('flexCheckSodium'),
                        flexCheckUricAcid: getCheckVal('flexCheckUricAcid'),
                        flexCheckCreatinine: getCheckVal('flexCheckCreatinine'),
                        flexCheckUrea: getCheckVal('flexCheckUrea'),
                        flexCheckJGlobulin: getCheckVal('flexCheckJGlobulin'),
                        flexCheckAlbumin: getCheckVal('flexCheckAlbumin'),
                        flexCheckTotalBilirubin: getCheckVal('flexCheckTotalBilirubin'),
                        flexCheckAlkalinePhosphatesALP: getCheckVal('flexCheckAlkalinePhosphatesALP'),
                        flexCheckSGOTAST: getCheckVal('flexCheckSGOTAST'),
                        flexCheckSGPTALT: getCheckVal('flexCheckSGPTALT'),
                        flexCheckLiverFunctionTest: getCheckVal('flexCheckLiverFunctionTest'),
                        flexCheckTriglycerides: getCheckVal('flexCheckTriglycerides'),
                        flexCheckTotalCholesterol: getCheckVal('flexCheckTotalCholesterol'),
                        flexCheckHemoglobinA1c: getCheckVal('flexCheckHemoglobinA1c'),
                        flexCheckHDL: getCheckVal('flexCheckHDL'),
                        flexCheckLDL: getCheckVal('flexCheckLDL'),
                        flexCheckFSH: getCheckVal('flexCheckFSH'),
                        flexCheckEstradiol: getCheckVal('flexCheckEstradiol'),
                        flexCheckLH: getCheckVal('flexCheckLH'),
                        flexCheckTestosteroneMale: getCheckVal('flexCheckTestosteroneMale'),
                        flexCheckProlactin: getCheckVal('flexCheckProlactin'),
                        flexCheckSeminalFluidAnalysis: getCheckVal('flexCheckSeminalFluidAnalysis'),
                        flexCheckBHCG: getCheckVal('flexCheckBHCG'),
                        flexCheckUrineExamination: getCheckVal('flexCheckUrineExamination'),
                        flexCheckStoolExamination: getCheckVal('flexCheckStoolExamination'),
                        flexCheckHemoglobin: getCheckVal('flexCheckHemoglobin'),
                        flexCheckMalaria: getCheckVal('flexCheckMalaria'),
                        flexCheckESR: getCheckVal('flexCheckESR'),
                        flexCheckBloodGrouping: getCheckVal('flexCheckBloodGrouping'),
                        flexCheckBloodSugar: getCheckVal('flexCheckBloodSugar'),
                        flexCheckCBC: getCheckVal('flexCheckCBC'),
                        flexCheckCrossMatching: getCheckVal('flexCheckCrossMatching'),
                        flexCheckTPHA: getCheckVal('flexCheckTPHA'),
                        flexCheckHIV: getCheckVal('flexCheckHIV'),
                        flexCheckHBV: getCheckVal('flexCheckHBV'),
                        flexCheckHCV: getCheckVal('flexCheckHCV'),
                        flexCheckBrucellaMelitensis: getCheckVal('flexCheckBrucellaMelitensis'),
                        flexCheckBrucellaAbortus: getCheckVal('flexCheckBrucellaAbortus'),
                        flexCheckCRP: getCheckVal('flexCheckCRP'),
                        flexCheckRF: getCheckVal('flexCheckRF'),
                        flexCheckASO: getCheckVal('flexCheckASO'),
                        flexCheckToxoplasmosis: getCheckVal('flexCheckToxoplasmosis'),
                        flexCheckTyphoid: getCheckVal('flexCheckTyphoid'),
                        flexCheckHpyloriAntibody: getCheckVal('flexCheckHpyloriAntibody'),
                        flexCheckStoolOccultBlood: getCheckVal('flexCheckStoolOccultBlood'),
                        flexCheckGeneralStoolExamination: getCheckVal('flexCheckGeneralStoolExamination'),
                        flexCheckThyroidProfile: getCheckVal('flexCheckThyroidProfile'),
                        flexCheckT3: getCheckVal('flexCheckT3'),
                        flexCheckT4: getCheckVal('flexCheckT4'),
                        flexCheckTSH: getCheckVal('flexCheckTSH'),
                        flexCheckSpermExamination: getCheckVal('flexCheckSpermExamination'),
                   
                        flexCheckTrichomonasVirginals: getCheckVal('flexCheckTrichomonasVirginals'),
                        flexCheckHCG: getCheckVal('flexCheckHCG'),
                        flexCheckHpyloriAgStool: getCheckVal('flexCheckHpyloriAgStool'),
                        flexCheckFastingBloodSugar: getCheckVal('flexCheckFastingBloodSugar'),
                        flexCheckDirectBilirubin: getCheckVal('flexCheckDirectBilirubin'),
                        flexCheckTroponinI: getCheckVal('flexCheckTroponinI'),
                        flexCheckCKMB: getCheckVal('flexCheckCKMB'),
                        flexCheckAPTT: getCheckVal('flexCheckAPTT'),
                        flexCheckINR: getCheckVal('flexCheckINR'),
                        flexCheckDDimer: getCheckVal('flexCheckDDimer'),
                        flexCheckVitaminD: getCheckVal('flexCheckVitaminD'),
                        flexCheckVitaminB12: getCheckVal('flexCheckVitaminB12'),
                        flexCheckFerritin: getCheckVal('flexCheckFerritin'),
                        flexCheckVDRL: getCheckVal('flexCheckVDRL'),
                        flexCheckDengueFever: getCheckVal('flexCheckDengueFever'),
                        flexCheckGonorrheaAg: getCheckVal('flexCheckGonorrheaAg'),
                        flexCheckAFP: getCheckVal('flexCheckAFP'),
                        flexCheckTotalPSA: getCheckVal('flexCheckTotalPSA'),
                        flexCheckAMH: getCheckVal('flexCheckAMH'),
                        flexCheckElectrolyteTest: getCheckVal('flexCheckElectrolyteTest'),
                        flexCheckCRPTiter: getCheckVal('flexCheckCRPTiter'),
                        flexCheckUltra: getCheckVal('flexCheckUltra'),
                        flexCheckTyphoidIgG: getCheckVal('flexCheckTyphoidIgG'),
                        flexCheckTyphoidAg: getCheckVal('flexCheckTyphoidAg')
                    };

                    $.ajax({
                        url: 'lap_operation.aspx/submitdata',
                        data: JSON.stringify(data),
                        contentType: 'application/json; charset=utf-8',
                        dataType: 'json',
                        type: 'POST',
                        success: function (response) {
                            window.isSubmittingLabTest = false;
                            console.log(response);
                            if (response.d === 'true') {
                                Swal.fire('Successfully Submitted!', 'Lab tests have been sent.', 'success');
                                $('#staticBackdrop11').modal('hide');
                            } else {
                                Swal.fire({ icon: 'error', title: 'Submission Failed', text: response.d });
                            }
                        },
                        error: function (response) {
                            window.isSubmittingLabTest = false;
                            alert(response.responseText);
                        }
                    });

                    return false;
                }

                function sendxray() {
                    document.getElementById('submitButton5').style.display = 'inline-block';
                    document.getElementById('submitButton7').style.display = 'none';



                    event.preventDefault()



                    // Show the modal
                    $('#staticBackdrop9').modal('show');

                }




                function updatexry() {
                    var prescid = $("#id9").val();
                    document.getElementById('submitButton7').style.display = 'inline-block';
                    document.getElementById('submitButton5').style.display = 'none';

                    event.preventDefault()

                    $.ajax({
                        url: 'assignmed.aspx/xrydata',
                        data: JSON.stringify({ prescid: prescid }),
                        dataType: "json",
                        type: 'POST',
                        contentType: "application/json",
                        success: function (response) {
                            console.log(response);

                            if (response.d && response.d.length > 0) {
                                var data = response.d[0];
                                var xrynameInput = document.getElementById('xrayname');
                                var xrydescribtionInput = document.getElementById('inst');
                                var xrytype = document.getElementById('typeimg');// Updated to use the textarea's ID

                                // Ensure elements exist
                                if (xrynameInput && xrydescribtionInput && xrytype) {
                                    // Show the hidden elements
                                    $('#xrayDetails').removeClass('hidden');
                                    $('#xraySpecial').removeClass('hidden');
                                    $('#xraySpecial5').removeClass('hidden');

                                    // Set their values
                                    xrynameInput.value = data.xryname;
                                    xrytype.value = data.type;
                                    xrydescribtionInput.value = data.xrydescribtion;
                                } else {
                                    console.log("Elements not found");
                                }
                            } else {
                                console.log("No data found in response");
                            }
                        },
                        error: function (response) {
                            alert(response.responseText);
                        }
                    });



                    // Show the modal
                    $('#staticBackdrop9').modal('show');
                }













                document.addEventListener('DOMContentLoaded', function () {
                    const radio = document.getElementById('radio');
                    const xrayDetails = document.getElementById('xrayDetails');
                    const xraySpecial = document.getElementById('xraySpecial');

                    function toggleXrayDetails() {
                        if (radio.checked) {
                            radio.value = "1";
                            xrayDetails.classList.remove('hidden');
                            xraySpecial.classList.remove('hidden');
                        } else {
                            radio.value = "0";
                            xrayDetails.classList.add('hidden');
                            xraySpecial.classList.add('hidden');
                        }
                    }

                    radio.addEventListener('change', toggleXrayDetails);

                    // Initially set the controls to hidden and value to 0
                    toggleXrayDetails();
                });





                document.addEventListener('DOMContentLoaded', function () {
                    const radio = document.getElementById('radio');
                    const xrayDetails = document.getElementById('xrayDetails');
                    const xraySpecial = document.getElementById('xraySpecial');

                    function toggleXrayDetails() {
                        if (radio.checked) {
                            radio.value = "1";
                            xrayDetails.classList.remove('hidden');
                            xraySpecial.classList.remove('hidden');
                        } else {
                            radio.value = "0";
                            xrayDetails.classList.add('hidden');
                            xraySpecial.classList.add('hidden');
                        }
                    }

                    radio.addEventListener('change', toggleXrayDetails);

                    function callxray() {
                        if (!radio.checked) {
                            alert("Please ensure radio");
                            return;
                        }

                        const xrname = document.getElementById('xrayname').value;
                        const xrydescribtion = document.getElementById('inst').value;

                        var typeimg = $("#typeimg").val();
                        var id = $("#id9").val();

                        $.ajax({
                            url: 'assingxray.aspx/submitxray',
                            data: "{'xrname':'" + xrname + "','xrydescribtion':'" + xrydescribtion + "','id':'" + id + "','typeimg':'" + typeimg + "'}",
                            contentType: 'application/json; charset=utf-8',
                            dataType: 'json',
                            type: 'POST',
                            success: function (response) {
                                console.log(response);
                                if (response.d === 'true') {
                                    Swal.fire(
                                        'Successfully Saved!',
                                        'You added a new image details!',
                                        'success'
                                    );
                                    // Uncheck radio2 and other checkboxes
                                    radio.checked = false;
                                    xrayDetails.classList.add('hidden');
                                    xraySpecial.classList.add('hidden');
                                    // Uncheck all checkboxes with the class 'custom-checkbox'

                                } else {
                                    // Handle errors in the response
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Data Insertion Failed',
                                        text: 'There was an error while inserting the data.',
                                    });
                                }


                            },
                            error: function (response) {
                                alert(response.responseText);
                            }
                        });


                    }


                    radio.addEventListener('change', toggleXrayDetails);
                    submitButton5.addEventListener('click', function (event) {
                        event.preventDefault(); // Prevent form submission if inside a form
                        callxray();
                    });

                    toggleXrayDetails();

                });
























                function editlab() {
                    // Show the update button and hide the submit button
                    document.getElementById('updateButton').style.display = 'inline-block';
                    document.getElementById('submitButton').style.display = 'none';


                    event.preventDefault();

                    var prescid = $("#labid").val();
                    var search = parseInt($("#label2").html());


                    $.ajax({
                        type: "POST",
                        url: "lap_operation.aspx/getlapprocessed",
                        data: JSON.stringify({ prescid: prescid, search: search }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            console.log(response);
                            uncheckAllCheckboxes();
                            // Access the nested data
                            var data = response.d[0];
                            document.getElementById('medid').value = data.med_id;
                            ;
                            // Iterate over each property in the data
                            for (var key in data) {
                                if (data.hasOwnProperty(key)) {
                                    var checkboxId = getCheckboxId(key);
                                    var isChecked = data[key] !== "not checked";

                                    // Find the checkbox element by id
                                    var checkbox = document.getElementById(checkboxId);

                                    if (checkbox) {
                                        checkbox.checked = isChecked;
                                    }
                                }
                            }
                        },
                        error: function (response) {
                            alert(response.responseText);
                        }
                    });

                    // Function to uncheck all checkboxes
                    function uncheckAllCheckboxes() {
                        var checkboxes = document.querySelectorAll('input[type="checkbox"]');
                        checkboxes.forEach(function (checkbox) {
                            checkbox.checked = false;
                        });
                    }


                    //// Function to map data keys to checkbox IDs
                    //function getCheckboxId(dataKey) {
                    //    switch (dataKey) {
                    //        case "Albumin": return "flexCheckAlbumin1";
                    //        case "Alkaline_phosphates_ALP": return "flexCheckAlkalinePhosphatesALP1";
                    //        case "Amylase": return "flexCheckAmylase1";
                    //        case "Antistreptolysin_O_ASO": return "flexCheckASO1";
                    //        case "Blood_grouping": return "flexCheckBloodGrouping1";
                    //        case "Blood_sugar": return "flexCheckBloodSugar1";
                    //        case "Brucella_abortus": return "flexCheckBrucellaAbortus1";
                    //        case "Brucella_melitensis": return "flexCheckBrucellaMelitensis1";
                    //        case "CBC": return "flexCheckCBC1";
                    //        case "C_reactive_protein_CRP": return "flexCheckCRP1";
                    //        case "Calcium": return "flexCheckCalcium1";
                    //        case "Chloride": return "flexCheckChloride1";
                    //        case "Creatinine": return "flexCheckCreatinine1";
                    //        case "Cross_matching": return "flexCheckCrossMatching1";
                    //        case "Direct_bilirubin": return "flexCheckDirectBilirubin";
                    //        case "ESR": return "flexCheckESR1";
                    //        case "Estradiol": return "flexCheckEstradiol1";
                    //        case "Fasting_blood_sugar": return "flexCheckFastingBloodSugar1";
                    //        case "Follicle_stimulating_hormone_FSH": return "flexCheckFSH1";
                    //        case "General_stool_examination": return "flexCheckGeneralStoolExamination1";
                    //        case "General_urine_examination": return "flexCheckGeneralUrineExamination1";
                    //        case "Hemoglobin": return "flexCheckHemoglobin1";
                    //        case "Hemoglobin_A1c": return "flexCheckHemoglobinA1c1";
                    //        case "Hepatitis_B_virus_HBV": return "flexCheckHBV1";
                    //        case "Hepatitis_C_virus_HCV": return "flexCheckHCV1";
                    //        case "High_density_lipoprotein_HDL": return "flexCheckHDL1";
                    //        case "Hpylori_Ag_stool": return "flexCheckHpyloriAgStool1";
                    //        case "Hpylori_antibody": return "flexCheckHpyloriAntibody1";
                    //        case "Human_chorionic_gonadotropin_hCG": return "flexCheckHCG1";
                    //        case "Human_immune_deficiency_HIV": return "flexCheckHIV1";
                    //        case "JGlobulin": return "flexCheckJGlobulin1";
                    //        case "Low_density_lipoprotein_LDL": return "flexCheckLDL1";
                    //        case "Luteinizing_hormone_LH": return "flexCheckLH1";
                    //        case "Magnesium": return "flexCheckMagnesium1";
                    //        case "Malaria": return "flexCheckMalaria1";
                    //        case "Phosphorous": return "flexCheckPhosphorous1";
                    //        case "Potassium": return "flexCheckPotassium1";
                    //        case "Progesterone_Female": return "flexCheckProgesteroneFemale1";
                    //        case "Prolactin": return "flexCheckProlactin1";
                    //        case "Rheumatoid_factor_RF": return "flexCheckRF1";
                    //        case "SGOT_AST": return "flexCheckSGOTAST1";
                    //        case "SGPT_ALT": return "flexCheckSGPTALT1";
                    //        case "Seminal_Fluid_Analysis_Male_B_HCG": return "flexCheckSeminalFluidAnalysis1";
                    //        case "Sodium": return "flexCheckSodium1";
                    //        case "Sperm_examination": return "flexCheckSpermExamination1";
                    //        case "Stool_examination": return "flexCheckStoolExamination1";
                    //        case "Stool_occult_blood": return "flexCheckStoolOccultBlood1";
                    //        case "TPHA": return "flexCheckTPHA1";
                    //        case "Testosterone_Male": return "flexCheckTestosteroneMale1";
                    //        case "Thyroid_profile": return "flexCheckThyroidProfile1";
                    //        case "Thyroid_stimulating_hormone_TSH": return "flexCheckTSH1";
                    //        case "Thyroxine_T4": return "flexCheckT41";
                    //        case "Total_bilirubin": return "flexCheckTotalBilirubin1";
                    //        case "Total_cholesterol": return "flexCheckTotalCholesterol1";
                    //        case "Toxoplasmosis": return "flexCheckToxoplasmosis1";
                    //        case "Triglycerides": return "flexCheckTriglycerides1";
                    //        case "Triiodothyronine_T3": return "flexCheckT31";
                    //        case "Typhoid_hCG": return "flexCheckTyphoid1";
                    //        case "Urea": return "flexCheckUrea1";
                    //        case "Uric_acid": return "flexCheckUricAcid1";
                    //        case "Urine_examination": return "flexCheckUrineExamination1";
                    //        case "Virginal_swab_trichomonas_virginals": return "flexCheckTrichomonasVirginals1";
                    //        // Add more mappings as needed
                    //        default: return null;
                    //    }
                    //}


                    // Show the modal



                    // Function to map data keys to checkbox IDs
                    function getCheckboxId(dataKey) {
                        switch (dataKey) {
                            case "Albumin": return "flexCheckAlbumin";
                            case "Alkaline_phosphates_ALP": return "flexCheckAlkalinePhosphatesALP";
                            case "Amylase": return "flexCheckAmylase";
                            case "Antistreptolysin_O_ASO": return "flexCheckASO";
                            case "Blood_grouping": return "flexCheckBloodGrouping";
                            case "Blood_sugar": return "flexCheckBloodSugar";
                            case "Brucella_abortus": return "flexCheckBrucellaAbortus";
                            case "Brucella_melitensis": return "flexCheckBrucellaMelitensis";
                            case "CBC": return "flexCheckCBC";
                            case "C_reactive_protein_CRP": return "flexCheckCRP";
                            case "Calcium": return "flexCheckCalcium";
                            case "Chloride": return "flexCheckChloride";
                            case "Creatinine": return "flexCheckCreatinine";
                            case "Cross_matching": return "flexCheckCrossMatching";
                            case "Direct_bilirubin": return "flexCheckDirectBilirubin";
                            case "ESR": return "flexCheckESR";
                            case "Estradiol": return "flexCheckEstradiol";
                            case "Fasting_blood_sugar": return "flexCheckFastingBloodSugar";
                            case "Follicle_stimulating_hormone_FSH": return "flexCheckFSH";
                            case "General_stool_examination": return "flexCheckGeneralStoolExamination";
                            case "General_urine_examination": return "flexCheckGeneralUrineExamination";
                            case "Hemoglobin": return "flexCheckHemoglobin";
                            case "Hemoglobin_A1c": return "flexCheckHemoglobinA1c";
                            case "Hepatitis_B_virus_HBV": return "flexCheckHBV";
                            case "Hepatitis_C_virus_HCV": return "flexCheckHCV";
                            case "High_density_lipoprotein_HDL": return "flexCheckHDL";
                            case "Hpylori_Ag_stool": return "flexCheckHpyloriAgStool";
                            case "Hpylori_antibody": return "flexCheckHpyloriAntibody";
                            case "Human_chorionic_gonadotropin_hCG": return "flexCheckHCG";
                            case "Human_immune_deficiency_HIV": return "flexCheckHIV";
                            case "JGlobulin": return "flexCheckJGlobulin";
                            case "Low_density_lipoprotein_LDL": return "flexCheckLDL";
                            case "Luteinizing_hormone_LH": return "flexCheckLH";
                            case "Magnesium": return "flexCheckMagnesium";
                            case "Malaria": return "flexCheckMalaria";
                            case "Phosphorous": return "flexCheckPhosphorous";
                            case "Potassium": return "flexCheckPotassium";
                            case "Progesterone_Female": return "flexCheckProgesteroneFemale";
                            case "Prolactin": return "flexCheckProlactin";
                            case "Rheumatoid_factor_RF": return "flexCheckRF";
                            case "SGOT_AST": return "flexCheckSGOTAST";
                            case "SGPT_ALT": return "flexCheckSGPTALT";
                            case "Seminal_Fluid_Analysis_Male_B_HCG": return "flexCheckSeminalFluidAnalysis";
                            case "Sodium": return "flexCheckSodium";
                            case "Sperm_examination": return "flexCheckSpermExamination";
                            case "Stool_examination": return "flexCheckStoolExamination";
                            case "Stool_occult_blood": return "flexCheckStoolOccultBlood";
                            case "TPHA": return "flexCheckTPHA";
                            case "Testosterone_Male": return "flexCheckTestosteroneMale";
                            case "Thyroid_profile": return "flexCheckThyroidProfile";
                            case "Thyroid_stimulating_hormone_TSH": return "flexCheckTSH";
                            case "Thyroxine_T4": return "flexCheckT4";
                            case "Total_bilirubin": return "flexCheckTotalBilirubin";
                            case "Total_cholesterol": return "flexCheckTotalCholesterol";
                            case "Toxoplasmosis": return "flexCheckToxoplasmosis";
                            case "Triglycerides": return "flexCheckTriglycerides";
                            case "Triiodothyronine_T3": return "flexCheckT3";
                            case "Typhoid_hCG": return "flexCheckTyphoid";
                            case "Urea": return "flexCheckUrea";
                            case "Uric_acid": return "flexCheckUricAcid";
                            case "Urine_examination": return "flexCheckUrineExamination";
                            case "Virginal_swab_trichomonas_virginals": return "flexCheckTrichomonasVirginals";
                            case "Troponin_I": return "flexCheckTroponinI";
                            case "CK_MB": return "flexCheckCKMB";
                            case "aPTT": return "flexCheckAPTT";
                            case "INR": return "flexCheckINR";
                            case "D_Dimer": return "flexCheckDDimer";
                            case "Vitamin_D": return "flexCheckVitaminD";
                            case "Vitamin_B12": return "flexCheckVitaminB12";
                            case "Ferritin": return "flexCheckFerritin";
                            case "VDRL": return "flexCheckVDRL";
                            case "Dengue_Fever_IgG_IgM": return "flexCheckDengueFever";
                            case "Gonorrhea_Ag": return "flexCheckGonorrheaAg";
                            case "AFP": return "flexCheckAFP";
                            case "Total_PSA": return "flexCheckTotalPSA";
                            case "AMH": return "flexCheckAMH";
                            case "Electrolyte_Test": return "flexCheckElectrolyteTest";
                            case "CRP_Titer": return "flexCheckCRPTiter";
                            case "Ultra": return "flexCheckUltra";
                            case "Typhoid_IgG": return "flexCheckTyphoidIgG";
                            case "Typhoid_Ag": return "flexCheckTyphoidAg";
                            // Add more mappings as needed
                            default: return null;
                        }
                    }



                    $('#staticBackdrop11').modal('show');

                }










                // Function to load medications for a prescription
                function loadMedications(prescid) {
                    $.ajax({
                        url: 'medication_report.aspx/medicdata',
                        data: "{'prescid':'" + prescid + "'}",
                        dataType: "json",
                        type: 'POST',
                        contentType: "application/json",
                        success: function (response) {
                            console.log("Loading medications:", response);

                            $("#medicationTable tbody").empty();

                            if (response.d && response.d.length > 0) {
                                for (var i = 0; i < response.d.length; i++) {
                                    $("#medicationTable tbody").append(
                                        "<tr>" +
                                        "<td>" + response.d[i].med_name + "</td>" +
                                        "<td>" + response.d[i].dosage + "</td>" +
                                        "<td>" + response.d[i].frequency + "</td>" +
                                        "<td>" + response.d[i].duration + "</td>" +
                                        "<td>" +
                                        "<button class='btn btn-sm btn-success edit1-btn' data-id='" + response.d[i].medid + "'>" +
                                        "<i class='fa fa-edit'></i> Edit" +
                                        "</button> " +
                                        "<button class='btn btn-sm btn-danger delete-med-btn' data-id='" + response.d[i].medid + "'>" +
                                        "<i class='fa fa-trash'></i>" +
                                        "</button>" +
                                        "</td>" +
                                        "</tr>"
                                    );
                                }
                            } else {
                                $("#medicationTable tbody").append(
                                    "<tr><td colspan='5' class='text-center text-muted'>No medications prescribed yet</td></tr>"
                                );
                            }
                        },
                        error: function (response) {
                            console.error("Error loading medications:", response.responseText);
                        }
                    });
                }

                function showmedic() {
                    var prescid = $("#id11").val();  // Use id11 which is in the main Patient Care Management modal
                    
                    if (!prescid) {
                        Swal.fire({
                            icon: 'warning',
                            title: 'No Prescription',
                            text: 'Please select a patient first.'
                        });
                        return;
                    }
                    
                    // Open medication print page in new window - same as doctor_inpatient.aspx
                    window.open('medication_print.aspx?prescid=' + prescid, '_blank', 'width=900,height=700');
                }





                function submitInfo() {
                    // Clear previous error messages
                    document.getElementById('nameError').textContent = "";
                    document.getElementById('dosageError').textContent = "";
                    document.getElementById('frequencyError').textContent = "";
                    document.getElementById('durationError').textContent = "";
                    document.getElementById('instError5').textContent = "";

                    // Get the form values
                    var prescid = $("#id11").val();
                    var med_name = $("#name").val();
                    var dosage = $("#dosage").val();
                    var frequency = $("#frequency").val();
                    var duration = $("#duration").val();
                    var special_inst = $("#inst7").val();
                    var id = $("#pid").val();
                    var status = "0"; // Default to outpatient, patient type managed in separate tab


                    // Validate the form values
                    let isValid = true;

                    if (med_name.trim() === "") {
                        document.getElementById('nameError').textContent = "Please enter the medication name.";
                        isValid = false;
                    }

                    if (dosage.trim() === "") {
                        document.getElementById('dosageError').textContent = "Please enter the dosage.";
                        isValid = false;
                    }

                    if (frequency.trim() === "") {
                        document.getElementById('frequencyError').textContent = "Please enter the frequency.";
                        isValid = false;
                    }

                    if (duration.trim() === "") {
                        document.getElementById('durationError').textContent = "Please enter the duration.";
                        isValid = false;
                    }

                    // Special instruction is optional, so no validation needed


                    // If all validations pass, proceed with AJAX call
                    if (isValid) {

                        $.ajax({
                            url: 'assignmed.aspx/submitdata',
                            data: "{ 'status':'" + status + "','id':'" + id + "', 'med_name':'" + med_name + "', 'dosage':'" + dosage + "', 'frequency':'" + frequency + "', 'duration':'" + duration + "', 'prescid':'" + prescid + "' , 'special_inst':'" + special_inst + "'  }",
                            contentType: 'application/json; charset=utf-8',
                            dataType: 'json',
                            type: 'POST',
                            success: function (response) {
                                console.log(response);
                                if (response.d === 'true') {
                                    Swal.fire(
                                        'Successfully Saved!',
                                        'Medication has been added!',
                                        'success'
                                    );

                                    clearInputFields(); // Clear input fields
                                    
                                    // Reload medications after adding new one
                                    var prescid = $("#id111").val();
                                    if (prescid) {
                                        loadMedications(prescid);
                                    }
                                } else {
                                    // Handle errors in the response
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Data Insertion Failed',
                                        text: 'There was an error while inserting the data.',
                                    });
                                }
                            },
                            error: function (response) {
                                alert(response.responseText);
                            }
                        });

                    }

                    function clearInputFields() {
                        // Replace these lines with code to clear the input fields
                        $("#name").val('');
                        $("#dosage").val('');
                        $("#inst").val('');
                        $("#frequency").val('');
                        $("#duration").val('');

                    }
                }

                // Delegate click events for edit and delete buttons to the table and mobile cards
                $(document).on("click", ".edit-btn", function (event) {
                    event.preventDefault(); // Prevent default behavior
                    var prescid = $(this).data("id");
                    var patientid, id;
                    
                    // Check if this is a mobile card or table row
                    var mobileCard = $(this).closest(".patient-mobile-card");
                    if (mobileCard.length > 0) {
                        // This is a mobile card - find patient data from the stored data
                        var patientData = allPatientsData.find(p => p.prescid == prescid);
                        if (patientData) {
                            patientid = patientData.patientid;
                            id = patientid;
                        }
                    } else {
                        // This is a table row - use original logic
                        var row = $(this).closest("tr");
                        patientid = row.find("td:nth-child(11)").text();
                        id = patientid;  // Use actual patientid
                    }
                    
                    console.log("Clicked row - prescid:", prescid, "patientid:", patientid);
                    
                    // Store correct IDs
                    $("#id111").val(prescid);
                    $("#pid").val(patientid);  // Use actual patientid from hidden column
                    console.log("Set #pid to patientid:", patientid);

                    // Get patient data based on source (mobile card or table row)
                    var name, gender, phone, location, sex, dobText, doctor, prescidFromTable;
                    
                    if (mobileCard.length > 0) {
                        // Get data from stored patient data for mobile cards
                        var patientData = allPatientsData.find(p => p.prescid == prescid);
                        if (patientData) {
                            name = patientData.full_name;
                            gender = patientData.sex;
                            phone = patientData.phone;
                            location = patientData.location;
                            sex = patientData.sex;
                            dobText = patientData.dob;
                            doctor = patientData.doctortitle;
                            prescidFromTable = patientData.prescid;
                        }
                    } else {
                        // Get data from table row for desktop table
                        var row = $(this).closest("tr");
                        name = row.find("td:nth-child(2)").text(); // Assuming jobname is in the second column
                        gender = row.find("td:nth-child(3)").text();
                        name = row.find("td:nth-child(2)").text();
                        phone = row.find("td:nth-child(5)").text();
                        location = row.find("td:nth-child(4)").text();
                        sex = row.find("td:nth-child(3)").text();
                        dobText = row.find("td:nth-child(7)").text();
                        doctor = row.find("td:nth-child(9)").text();
                        prescidFromTable = row.find("td:nth-child(10)").text();  // This is prescid
                    }

                    // Get status information based on source
                    var status, xrystatus;
                    
                    if (mobileCard.length > 0) {
                        // Get status from stored patient data for mobile cards
                        var patientData = allPatientsData.find(p => p.prescid == prescid);
                        if (patientData) {
                            status = patientData.status;
                            xrystatus = patientData.xray_status;
                        }
                    } else {
                        // Get status from table row for desktop table
                        var row = $(this).closest("tr");
                        status = row.find("td:nth-child(12)").text().trim();
                        xrystatus = row.find("td:nth-child(13)").text().trim(); // Trim whitespace
                    }
                    
                    // Get xrayid based on source
                    var xrayid;
                    if (mobileCard.length > 0) {
                        // Get xrayid from stored patient data for mobile cards
                        var patientData = allPatientsData.find(p => p.prescid == prescid);
                        if (patientData) {
                            xrayid = patientData.xrayid || '';
                        }
                    } else {
                        // Get xrayid from table row for desktop table
                        var row = $(this).closest("tr");
                        xrayid = row.find("td:nth-child(14)").text().trim();
                    }


                    if (status === 'pending-lab') {
                        document.getElementById('sendlab').disabled = true;
                        document.getElementById('editlab1').disabled = false;
                    } else if (status === 'waiting') {
                        document.getElementById('sendlab').disabled = false;
                        document.getElementById('editlab1').disabled = true;
                    } else if (status === 'processed') {
                        document.getElementById('sendlab').disabled = true;
                        document.getElementById('editlab1').disabled = true;
                    } else if (status === 'lab-processed') {
                        document.getElementById('sendlab').disabled = true;
                        document.getElementById('editlab1').disabled = true;
                    } else if (status === 'pending-xray') {
                        document.getElementById('sendlab').disabled = true;
                        document.getElementById('editlab1').disabled = true;
                    } else if (status === 'xray-processed') {
                        document.getElementById('sendlab').disabled = true;
                        document.getElementById('editlab1').disabled = true;
                    }





                    if (xrystatus === 'pending_image') {
                        document.getElementById('sendxry').disabled = true;
                        document.getElementById('editxry').disabled = false;
                    } else if (xrystatus === 'waiting') {
                        document.getElementById('sendxry').disabled = false;
                        document.getElementById('editxry').disabled = true;
                    } else if (xrystatus === 'image_processed') {
                        document.getElementById('sendxry').disabled = true;
                        document.getElementById('editxry').disabled = true;
                    }








                    $("#doctor").text(doctor);
                    $("#doctor1").text(doctor);
                    // Parse the DOB into a Date object
                    var dob = new Date(dobText);
                    var today = new Date();

                    // Calculate the age
                    var age = today.getFullYear() - dob.getFullYear();
                    var monthDiff = today.getMonth() - dob.getMonth();
                    var dayDiff = today.getDate() - dob.getDate();

                    // Adjust the age if the current date hasn't yet reached the birthday in the current year
                    if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
                        age--;
                    }


                    // Display the current date in the element with ID "date"
                    var options = { year: 'numeric', month: 'long', day: 'numeric' };
                    var formattedToday = today.toLocaleDateString('en-US', options);
                    $("#date").text(formattedToday);
                    $("#date1").text(formattedToday);
                    // Display the age in the input field
                    $("#DOB").text(age);

                    // #pid is already set earlier from rowData.patientid

                    $("#ptname").text(name);

                    $("#phone").text(phone);
                    $("#location").text(location);
                    $("#sex").text(sex);
                    $("#ptname1").text(name);

                    $("#phone1").text(phone);
                    $("#location1").text(location);
                    $("#sex1").text(sex);
                    $("#id111").val(prescid);
                    $("#labid").val(prescid);
                    $("#editl").val(prescid);
                    $("#id9").val(prescid);
                    $("#id99").val(xrayid);
                    $("#id11").val(prescid);

                    // Load medications automatically when patient is selected
                    loadMedications(prescid);
                    
                    // Load patient type information
                    loadCurrentPatientType(id);



                    $.ajax({
                        url: 'assignmed.aspx/xryimage',
                        data: JSON.stringify({ 'prescid': prescid }),
                        dataType: "json",
                        type: 'POST',
                        contentType: "application/json",
                        success: function (response) {
                            console.log(response);


                            if (response.d && response.d.length > 0) {
                                var base64Data = response.d[0].image; // Assuming imageData is base64-encoded
                                var image = response.d[0].type;
                                $("#imgtype").text(image);
                                // Update image source directly
                                $("#img").attr('src', 'data:image/jpeg;base64,' + base64Data);
                            } else {
                                console.log("No image data found for the given prescid.");
                                // Optionally handle the case where no image data is returned
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error("Error fetching image data:", error);
                            // Handle errors more gracefully, e.g., display an error message to the user
                        }
                    });


                    $.ajax({
                        url: 'assignmed.aspx/lab_test',
                        data: "{'prescid':'" + prescid + "'}",
                        dataType: "json",
                        type: 'POST',
                        contentType: "application/json",
                        success: function (response) {
                            console.log(response);

                            $("#datatable1 tbody").empty();

                            for (var i = 0; i < response.d.length; i++) {
                                $("#datatable1 tbody").append(
                                    "<tr>"


                                    + "<td style='border: 1px solid #000; padding: 5px;'>" + response.d[i].TestName + "</td>"
                                    + "<td style='border: 1px solid #000; padding: 5px;'>" + response.d[i].TestValue + "</td>"

                                    + "</tr>"
                                );
                            }




                        },
                        error: function (response) {
                            alert(response.responseText);
                        }
                    });


                    // Show the modal
                    $('#staticBackdrop').modal('show');
                });


                //$(document).ready(function () {






                //    var search = parseInt($("#label2").html());
                //    $.ajax({
                //        url: 'assignmed.aspx/medic',
                //        data: JSON.stringify({ 'search': search }),
                //        dataType: "json",
                //        type: 'POST',
                //        contentType: "application/json",
                //        success: function (response) {
                //            console.log(response);

                //            $("#datatable tbody").empty();



                //            for (var i = 0; i < response.d.length; i++) {


                //                $("#datatable tbody").append(
                //                    "<tr style='cursor:pointer' onclick='passValue(this)'>" +
                //                    "<td style='display:none'>" + response.d[i].doctorid + "</td>" +
                //                    "<td>" + response.d[i].full_name + "</td>" +
                //                    "<td>" + response.d[i].sex + "</td>" +
                //                    "<td>" + response.d[i].location + "</td>" +
                //                    "<td>" + response.d[i].phone + "</td>" +
                //                    "<td>" + response.d[i].amount + "</td>" +
                //                    "<td>" + response.d[i].dob + "</td>" +
                //                    "<td>" + response.d[i].date_registered + "</td>" +
                //                    "<td style='display:none'>" + response.d[i].doctortitle + "</td>" +
                //                    "<td style='display:none'>" + response.d[i].prescid + "</td>" +
                //                    "<td style='display:none'>" + response.d[i].patientid + "</td>" +
                //                    "<td>" + response.d[i].status + "</td>" +
                //                    "<td>" + response.d[i].xray_status + "</td>" +
                //                    "<td style='display:none'>" + response.d[i].xrayid + "</td>" +


                //                    "<td><button class='edit-btn btn btn-success' data-id='" + response.d[i].prescid + "'>Assign Medication</button></td>" +
                //                    "</tr>"
                //                );
                //            }
                //        },
                //        error: function (response) {
                //            alert(response.responseText);
                //        }
                //    });

                //    });


                // Function to handle row click and populate patient details
                function passValue(row) {
                    // Get values from the clicked row
                    var cells = row.cells;
                    
                    // Extract data from hidden and visible cells
                    var doctorid = cells[0].innerText; // Hidden column
                    var fullName = cells[1].innerText;
                    var sex = cells[2].innerText;
                    var location = cells[3].innerText;
                    var phone = cells[4].innerText;
                    var amount = cells[5].innerText;
                    var dob = cells[6].innerText;
                    var dateRegistered = cells[7].innerText;
                    var doctorTitle = cells[8].innerText; // Hidden
                    var prescid = cells[9].innerText; // Hidden
                    var patientid = cells[10].innerText; // Hidden
                    
                    // Populate BOTH hidden fields for prescid (different modals use different fields)
                    $("#id111").val(prescid);  // Used in some modals
                    $("#id11").val(prescid);   // Used in Patient Care Management modal
                    $("#pid").val(patientid);
                    
                    // Log for debugging
                    console.log('passValue - Set prescid:', prescid, 'patientid:', patientid);
                    console.log('passValue - #id111:', $("#id111").val(), '#id11:', $("#id11").val());
                }

                // Function to initialize DataTable
                // Function to initialize DataTable
                function initDataTable() {
                    // Check if DataTable is available
                    if (typeof $.fn.DataTable !== 'undefined') {
                        // Destroy existing DataTable if it exists
                        if ($.fn.DataTable.isDataTable('#datatable')) {
                            $('#datatable').DataTable().destroy();
                        }

                        // Initialize DataTable with enhanced search functionality
                        var table = $('#datatable').DataTable({
                            dom: 'Bfrtip',
                            buttons: [
                                'excelHtml5',
                                {
                                    extend: 'pdfHtml5',
                                    text: 'PDF',
                                    title: 'Patient Assignment Report'
                                },
                                {
                                    extend: 'print',
                                    text: 'Print',
                                    title: 'Patient Assignment Report'
                                }
                            ],
                            paging: true,
                            pageLength: 15,
                            lengthMenu: [10, 15, 25, 50, 100],
                            responsive: true,
                            searching: true,
                            order: [[6, 'desc']], // Order by Date Registered (column index 6), newest first
                            orderMulti: true,
                            stateSave: true,
                            language: {
                                search: "🔍 Search patients:",
                                searchPlaceholder: "Name, phone, location, status...",
                                lengthMenu: "Show _MENU_ patients per page",
                                info: "Showing _START_ to _END_ of _TOTAL_ patients",
                                infoEmpty: "No patients found",
                                infoFiltered: "(filtered from _MAX_ total patients)",
                                paginate: {
                                    first: "First",
                                    last: "Last",
                                    next: "Next",
                                    previous: "Previous"
                                }
                            },
                            columnDefs: [
                                // Hide certain columns from search if needed
                                { targets: [0], visible: false }, // Hide doctorid column
                                { targets: [8], visible: false }, // Hide doctortitle column  
                                { targets: [9], visible: false }, // Hide prescid column
                                { targets: [10], visible: false }, // Hide patientid column
                                { targets: [13], visible: false }, // Hide xrayid column
                                { 
                                    targets: [7, 8], // Lab and Image status columns
                                    orderable: true,
                                    searchable: true
                                },
                                {
                                    targets: [10], // Operation column
                                    orderable: false,
                                    searchable: false
                                }
                            ],
                            order: [[6, 'desc']], // Sort by date registered (newest first)
                            initComplete: function() {
                                // Add search filters above the table
                                var filtersHtml = `
                                    <div class="row mb-3" id="search-filters">
                                        <div class="col-md-3">
                                            <label class="form-label">Filter by Lab Status:</label>
                                            <select class="form-select form-select-sm" id="labStatusFilter">
                                                <option value="">All Lab Status</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">Filter by Image Status:</label>
                                            <select class="form-select form-select-sm" id="imageStatusFilter">
                                                <option value="">All Image Status</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">Filter by Transaction:</label>
                                            <select class="form-select form-select-sm" id="transactionFilter">
                                                <option value="">All Transactions</option>
                                                <option value="pending">Pending</option>
                                                <option value="completed">Completed</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label class="form-label">Filter by Gender:</label>
                                            <select class="form-select form-select-sm" id="genderFilter">
                                                <option value="">All Genders</option>
                                                <option value="male">Male</option>
                                                <option value="female">Female</option>
                                            </select>
                                        </div>
                                    </div>
                                `;
                                
                                // Add filters above the DataTable
                                $('#datatable_wrapper').prepend(filtersHtml);
                                
                                // Populate status dropdowns with actual data
                                var table = this.api();
                                
                                // Get unique lab statuses
                                var labStatuses = [];
                                table.column(7).data().each(function(d) {
                                    var text = $(d).text() || d;
                                    if (text && text.trim() && labStatuses.indexOf(text.trim()) === -1) {
                                        labStatuses.push(text.trim());
                                    }
                                });
                                labStatuses.sort().forEach(function(status) {
                                    $('#labStatusFilter').append('<option value="' + status + '">' + status + '</option>');
                                });
                                
                                // Get unique image statuses
                                var imageStatuses = [];
                                table.column(8).data().each(function(d) {
                                    var text = $(d).text() || d;
                                    if (text && text.trim() && imageStatuses.indexOf(text.trim()) === -1) {
                                        imageStatuses.push(text.trim());
                                    }
                                });
                                imageStatuses.sort().forEach(function(status) {
                                    $('#imageStatusFilter').append('<option value="' + status + '">' + status + '</option>');
                                });
                                
                                // Add filter event handlers
                                $('#labStatusFilter').on('change', function() {
                                    var val = $(this).val();
                                    table.column(7).search(val ? val : '', false, false).draw();
                                    if (isMobileView) updateMobileCardsFromSearch();
                                });
                                
                                $('#imageStatusFilter').on('change', function() {
                                    var val = $(this).val();
                                    table.column(8).search(val ? val : '', false, false).draw();
                                    if (isMobileView) updateMobileCardsFromSearch();
                                });
                                
                                $('#transactionFilter').on('change', function() {
                                    var val = $(this).val();
                                    table.column(9).search(val ? val : '', false, false).draw();
                                    if (isMobileView) updateMobileCardsFromSearch();
                                });
                                
                                $('#genderFilter').on('change', function() {
                                    var val = $(this).val();
                                    table.column(1).search(val ? val : '', false, false).draw();
                                    if (isMobileView) updateMobileCardsFromSearch();
                                });

                                console.log('DataTable initialized with enhanced search functionality');
                            },
                            drawCallback: function() {
                                // Update mobile cards when table is redrawn (search, page change, etc.)
                                if (isMobileView) {
                                    updateMobileCardsFromSearch();
                                }
                            }
                        });

                        // Add custom global search enhancements
                        $('#datatable_filter input').addClass('form-control');
                        $('#datatable_filter input').attr('placeholder', 'Search by name, phone, location, or status...');
                        
                        // Real-time search sync with mobile cards
                        $('#datatable_filter input').on('keyup', function() {
                            if (isMobileView) {
                                updateMobileCardsFromSearch();
                            }
                        });

                    } else {
                        console.error('DataTables library not loaded');
                    }
                }



                // Global variables for responsive functionality
                var allPatientsData = [];
                var isMobileView = false;
                
                // Store expanded card states globally
                var expandedCards = new Set();

                // Responsive utility functions
                function checkIfMobile() {
                    return window.innerWidth <= 768;
                }

                function updateViewMode() {
                    isMobileView = checkIfMobile();
                    if (isMobileView) {
                        $('#datatable_wrapper').hide();
                        $('.mobile-view').show();
                        populateMobileCards(allPatientsData);
                    } else {
                        $('#datatable_wrapper').show();
                        $('.mobile-view').hide();
                    }
                }

                // Mobile cards generation
                function populateMobileCards(patients) {
                    const container = $('#mobileCardsContainer');
                    container.empty();

                    if (!patients || patients.length === 0) {
                        container.html(`
                            <div class="text-center text-muted p-4">
                                <i class="fas fa-user-slash fa-2x mb-3"></i>
                                <p>No patients found</p>
                            </div>
                        `);
                        return;
                    }

                    patients.forEach(function(patient, index) {
                        const card = createMobilePatientCard(patient, index);
                        container.append(card);
                    });
                    
                    // Setup event handlers after cards are added
                    setupMobileCardHandlers();
                }

                function createMobilePatientCard(patient, index) {
                    const statusColor = getStatusColor(patient.status);
                    const xrayStatusColor = getStatusColor(patient.xray_status);
                    const transactionStatus = patient.transaction_status || 'pending';
                    const isExpanded = expandedCards.has(patient.prescid);
                    
                    return `
                        <div class="patient-mobile-card ${isExpanded ? 'expanded' : ''}" data-patient-id="${patient.prescid}" data-prescid="${patient.prescid}">
                            <div class="mobile-card-header">
                                <h5 class="patient-name-mobile">${patient.full_name || 'Unknown Patient'}</h5>
                                <p class="patient-info-brief">${patient.sex || 'N/A'} • ${patient.location || 'N/A'} • ${patient.phone || 'N/A'}</p>
                                <i class="fas fa-chevron-down expand-icon"></i>
                            </div>
                            <div class="mobile-card-body">
                                <div class="mobile-info-grid">
                                    <div class="mobile-info-item">
                                        <div class="mobile-info-label">Sex</div>
                                        <div class="mobile-info-value">${patient.sex || 'N/A'}</div>
                                    </div>
                                    <div class="mobile-info-item">
                                        <div class="mobile-info-label">Phone</div>
                                        <div class="mobile-info-value">${patient.phone || 'N/A'}</div>
                                    </div>
                                    <div class="mobile-info-item">
                                        <div class="mobile-info-label">Location</div>
                                        <div class="mobile-info-value">${patient.location || 'N/A'}</div>
                                    </div>
                                    <div class="mobile-info-item">
                                        <div class="mobile-info-label">Amount</div>
                                        <div class="mobile-info-value">$${patient.amount || '0.00'}</div>
                                    </div>
                                    <div class="mobile-info-item">
                                        <div class="mobile-info-label">Date of Birth</div>
                                        <div class="mobile-info-value">${patient.dob || 'N/A'}</div>
                                    </div>
                                    <div class="mobile-info-item">
                                        <div class="mobile-info-label">Date Registered</div>
                                        <div class="mobile-info-value">${patient.date_registered || 'N/A'}</div>
                                    </div>
                                    <div class="mobile-info-item">
                                        <div class="mobile-info-label">Lab Status</div>
                                        <div class="mobile-info-value">
                                            <span class="badge" style="background-color: ${statusColor}; color: white; padding: 4px 8px; border-radius: 4px; font-size: 11px;">
                                                ${patient.status || 'N/A'}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="mobile-info-item">
                                        <div class="mobile-info-label">Image Status</div>
                                        <div class="mobile-info-value">
                                            <span class="badge" style="background-color: ${xrayStatusColor}; color: white; padding: 4px 8px; border-radius: 4px; font-size: 11px;">
                                                ${patient.xray_status || 'N/A'}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="mobile-info-item" style="grid-column: 1 / -1;">
                                        <div class="mobile-info-label">Transaction Status</div>
                                        <div class="mobile-info-value">
                                            <select class="form-select form-select-sm" 
                                                    style="background-color: ${transactionStatus === 'completed' ? '#28a745' : '#ffc107'}; color: white; border: none; font-weight: bold;"
                                                    onchange="updateTransactionStatus(this, ${patient.prescid}, this.value)">
                                                <option value="pending" ${transactionStatus === 'pending' ? 'selected' : ''}>⏳ Pending</option>
                                                <option value="completed" ${transactionStatus === 'completed' ? 'selected' : ''}>✓ Completed</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="mobile-actions">
                                    <button type="button" class="btn btn-success edit-btn" data-id="${patient.prescid}">
                                        <i class="fas fa-pills me-1"></i> Assign Medication
                                    </button>
                                    <button type="button" class="btn btn-outline-primary" onclick="openVisitSummary(event, ${patient.prescid})">
                                        <i class="fas fa-print me-1"></i> Print Visit
                                    </button>
                                </div>
                            </div>
                        </div>
                    `;
                }

                function getStatusColor(status) {
                    switch (status) {
                        case 'waiting': return '#dc3545';
                        case 'processed': return '#007bff';
                        case 'pending-xray': case 'pending-lab': case 'pending_image': return '#fd7e14';
                        case 'xray-processed': case 'lab-processed': case 'image_processed': return '#28a745';
                        default: return '#6c757d';
                    }
                }

                function toggleMobileCard(header, event) {
                    // Only toggle if the click is directly on the header, not during scroll
                    if (event) {
                        // Prevent toggle if clicking/touching inside card body
                        if ($(event.target).closest('.mobile-card-body').length > 0) {
                            return;
                        }
                        
                        // Only allow clicks on header elements
                        if (!$(event.target).closest('.mobile-card-header').length) {
                            return;
                        }
                    }
                    
                    const card = $(header).closest('.patient-mobile-card');
                    const prescid = card.data('prescid');
                    
                    card.toggleClass('expanded');
                    
                    // Store/remove expanded state
                    if (card.hasClass('expanded')) {
                        expandedCards.add(prescid);
                    } else {
                        expandedCards.delete(prescid);
                    }
                }
                
                // Setup mobile card click handlers with proper event delegation
                function setupMobileCardHandlers() {
                    // Remove any existing handlers to prevent duplicates
                    $(document).off('click', '.mobile-card-header');
                    $(document).off('touchend', '.mobile-card-header');
                    
                    // Use event delegation for click (desktop/tablet)
                    $(document).on('click', '.mobile-card-header', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        toggleMobileCard(this, e);
                    });
                    
                    // Handle touch events separately to prevent scroll from triggering
                    let touchStartY = 0;
                    let isTouchMove = false;
                    
                    $(document).on('touchstart', '.mobile-card-header', function(e) {
                        touchStartY = e.touches[0].clientY;
                        isTouchMove = false;
                    });
                    
                    $(document).on('touchmove', '.mobile-card-header', function(e) {
                        const touchMoveY = e.touches[0].clientY;
                        // If moved more than 10px, consider it a scroll
                        if (Math.abs(touchMoveY - touchStartY) > 10) {
                            isTouchMove = true;
                        }
                    });
                    
                    $(document).on('touchend', '.mobile-card-header', function(e) {
                        // Only toggle if it wasn't a scroll gesture
                        if (!isTouchMove) {
                            e.preventDefault();
                            e.stopPropagation();
                            toggleMobileCard(this, e);
                        }
                        isTouchMove = false;
                    });
                    
                    // Prevent card body from triggering any events
                    $(document).on('click touchend', '.mobile-card-body', function(e) {
                        e.stopPropagation();
                    });
                }

                // Mobile search functionality
                function setupMobileSearch() {
                    $('#mobileSearchInput').on('input', function() {
                        const searchTerm = $(this).val().toLowerCase().trim();
                        
                        if (searchTerm === '') {
                            populateMobileCards(allPatientsData);
                            return;
                        }

                        const filteredPatients = allPatientsData.filter(function(patient) {
                            const searchableText = [
                                patient.full_name,
                                patient.phone,
                                patient.location,
                                patient.sex,
                                patient.status,
                                patient.xray_status
                            ].join(' ').toLowerCase();
                            
                            return searchableText.includes(searchTerm);
                        });

                        populateMobileCards(filteredPatients);
                    });
                }

                // Function to update mobile cards based on DataTable search results
                function updateMobileCardsFromSearch() {
                    try {
                        if (!$.fn.DataTable.isDataTable('#datatable')) {
                            return;
                        }

                        const table = $('#datatable').DataTable();
                        const searchedData = [];
                        
                        // Get currently visible (searched/filtered) rows
                        table.rows({ search: 'applied' }).every(function(rowIdx, tableLoop, rowLoop) {
                            const rowData = this.data();
                            // Find corresponding patient data from our stored array
                            const patientData = allPatientsData.find(p => p.prescid == rowData[9]); // prescid is in column 9
                            if (patientData) {
                                searchedData.push(patientData);
                            }
                        });

                        // Update mobile cards with filtered results
                        populateMobileCards(searchedData);
                        
                        console.log('Mobile cards updated with ' + searchedData.length + ' filtered patients');
                    } catch (error) {
                        console.error('Error updating mobile cards from search:', error);
                    }
                }

                // Sync mobile search with DataTable search
                function syncSearches() {
                    // When mobile search changes, update DataTable
                    $('#mobileSearchInput').on('input', function() {
                        const searchTerm = $(this).val();
                        if ($.fn.DataTable.isDataTable('#datatable')) {
                            $('#datatable').DataTable().search(searchTerm).draw();
                        }
                    });

                    // When DataTable search changes, update mobile search
                    $(document).on('keyup', '#datatable_filter input', function() {
                        const searchTerm = $(this).val();
                        $('#mobileSearchInput').val(searchTerm);
                    });
                }

                // Window resize handler
                $(window).on('resize', function() {
                    updateViewMode();
                });

                // Function to update transaction status (global scope)
                function updateTransactionStatus(selectElement, prescid, newStatus) {
                    // Ensure selectElement is a jQuery object
                    var $select = $(selectElement);
                    $select.prop('disabled', true);
                    
                    $.ajax({
                        type: "POST",
                        url: "assignmed.aspx/UpdateTransactionStatus",
                        data: JSON.stringify({
                            prescid: prescid.toString(),
                            transactionStatus: newStatus
                        }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function(response) {
                            if (response.d === "success") {
                                Swal.fire({
                                    icon: 'success',
                                    title: 'Success',
                                    text: 'Transaction status updated successfully',
                                    timer: 2000,
                                    showConfirmButton: false
                                });
                                
                                // Update the select background color based on status
                                if (newStatus === 'completed') {
                                    $select.css('background-color', '#28a745');
                                } else {
                                    $select.css('background-color', '#ffc107');
                                }
                            } else {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Error',
                                    text: response.d || 'Failed to update status'
                                });
                                
                                // Revert the dropdown value
                                $select.val(newStatus === 'completed' ? 'pending' : 'completed');
                            }
                            
                            $select.prop('disabled', false);
                        },
                        error: function (xhr, status, error) {
                            Swal.fire({
                                icon: 'error',
                                title: 'Error',
                                text: 'Failed to update status: ' + error
                            });
                            
                            $select.val(newStatus === 'completed' ? 'pending' : 'completed');
                            $select.prop('disabled', false);
                        }
                    });
                }

                // Function to load patients data
                function loadPatients() {
                    var search = parseInt($("#label2").html());
                    var doctorId = $('#<%= hdnDoctorId.ClientID %>').val();
                    
                    // Show loading indicator
                    if (!$('#refreshIndicator').length) {
                        $('body').append('<div id="refreshIndicator" style="position: fixed; top: 10px; right: 10px; background: rgba(0, 123, 255, 0.9); color: white; padding: 10px 20px; border-radius: 5px; z-index: 9999; display: none; box-shadow: 0 2px 10px rgba(0,0,0,0.2);"><i class="fa fa-sync fa-spin" style="margin-right: 8px;"></i>Refreshing patients...</div>');
                    }
                    $('#refreshIndicator').fadeIn(200);
                    
                    // Ajax request to populate the table
                    $.ajax({
                        url: 'assignmed.aspx/medic',
                        data: JSON.stringify({ 'search': search, 'doctorId': doctorId }),
                        dataType: "json",
                        type: 'POST',
                        contentType: "application/json",
                        success: function (response) {
                            console.log(response);

                            // Clear existing tbody content
                            $("#datatable tbody").empty();

                            // Function to determine button style based on status
                            function getStatusButton(status) {
                                var color;
                                var displayText = status || 'N/A';
                                
                                switch (status) {
                                    case 'waiting':
                                        color = 'red';
                                        break;
                                    case 'processed':
                                        color = 'blue';
                                        break;
                                    case 'pending-xray':
                                        color = 'orange';
                                        break;
                                    case 'xray-processed':
                                        color = 'blue';
                                        break;
                                    case 'pending-lab':
                                        color = 'orange';
                                        break;
                                    case 'lab-processed':
                                        color = 'green';
                                        break;
                                    case 'pending_image':
                                        color = 'orange';
                                        break;
                                    case 'image_processed':
                                        color = 'green';
                                        break;
                                    default:
                                        color = 'gray';
                                        displayText = status || 'N/A';
                                }
                                return "<button style='background-color:" + color + "; cursor:default; color:white; border:none; padding:5px 10px; border-radius:5px;' disabled>" + displayText + "</button>";
                            }

                            // Function to generate transaction status dropdown
                            function getTransactionStatusDropdown(prescid, currentStatus) {
                                var statusValue = currentStatus || 'pending';
                                var selectId = 'transStatus_' + prescid;
                                
                                var completedSelected = (statusValue === 'completed') ? 'selected' : '';
                                var pendingSelected = (statusValue === 'pending') ? 'selected' : '';
                                
                                var statusColor = (statusValue === 'completed') ? '#28a745' : '#ffc107';
                                var statusIcon = (statusValue === 'completed') ? 'fa-check-circle' : 'fa-hourglass-half';
                                var statusText = (statusValue === 'completed') ? 'Completed' : 'Pending';
                                
                                return '<div style="display: flex; align-items: center; gap: 10px;">' +
                                       '<select id="' + selectId + '" class="form-select form-select-sm transaction-status-select" ' +
                                       'style="width: 140px; font-weight: bold; padding: 5px 10px; border-radius: 5px; ' +
                                       'background-color: ' + statusColor + '; color: white; border: none; cursor: pointer;" ' +
                                       'onchange="updateTransactionStatus(this, ' + prescid + ', this.value)" ' +
                                       'data-prescid="' + prescid + '">' +
                                       '<option value="pending" ' + pendingSelected + ' style="background-color: white; color: black;">⏳ Pending</option>' +
                                       '<option value="completed" ' + completedSelected + ' style="background-color: white; color: black;">✓ Completed</option>' +
                                       '</select>' +
                                       '</div>';
                            }

                            // Populate table rows
                            for (var i = 0; i < response.d.length; i++) {
                                var statusButton = getStatusButton(response.d[i].status);
                                var xrayStatusButton = getStatusButton(response.d[i].xray_status);
                                var transactionStatusDropdown = getTransactionStatusDropdown(response.d[i].prescid, response.d[i].transaction_status);

                                $("#datatable tbody").append(
                                    "<tr style='cursor:pointer' onclick='passValue(this)'>" +
                                    "<td style='display:none;'>" + response.d[i].doctorid + "</td>" +
                                    "<td>" + response.d[i].full_name + "</td>" +
                                    "<td>" + response.d[i].sex + "</td>" +
                                    "<td>" + response.d[i].location + "</td>" +
                                    "<td>" + response.d[i].phone + "</td>" +
                                    "<td>" + response.d[i].amount + "</td>" +
                                    "<td>" + response.d[i].dob + "</td>" +
                                    "<td>" + response.d[i].date_registered + "</td>" +
                                    "<td style='display:none;'>" + response.d[i].doctortitle + "</td>" +
                                    "<td style='display:none;'>" + response.d[i].prescid + "</td>" +
                                    "<td style='display:none;'>" + response.d[i].patientid + "</td>" +
                                    "<td>" + statusButton + "</td>" +
                                    "<td>" + xrayStatusButton + "</td>" +
                                    "<td style='display:none;'>" + response.d[i].xrayid + "</td>" +
                                    "<td onclick='event.stopPropagation();'>" + transactionStatusDropdown + "</td>" +
                                    "<td>" +
                                    "<div class='d-flex flex-wrap gap-2 justify-content-center'>" +
                                    "<button type='button' class='edit-btn btn btn-success' data-id='" + response.d[i].prescid + "'>Assign Medication</button>" +
                                    "<button type='button' class='btn btn-outline-primary btn-sm' onclick='openVisitSummary(event, " + response.d[i].prescid + ")'>Print Visit</button>" +
                                    "</div>" +
                                    "</td>" +
                                    "</tr>"
                                );
                            }

                // Bed Charge Management Functions
                function toggleBedCharges() {
                    const status = document.getElementById('status').value;
                    const bedChargeSection = document.getElementById('bedChargeSection');

                    if (status === '1') { // In Patient
                        bedChargeSection.style.display = 'block';
                        loadBedChargeRates();
                    } else {
                        bedChargeSection.style.display = 'none';
                    }
                }

                function loadBedChargeRates() {
                    $.ajax({
                        type: "POST",
                        url: "assignmed.aspx/GetBedChargeRates",
                        data: '{}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            var bedChargeRate = $("#bedChargeRate");
                            bedChargeRate.empty();

                            if (response.d && response.d.length > 0) {
                                $.each(response.d, function () {
                                    bedChargeRate.append($("<option></option>").val(this['Value']).html(this['Text']));
                                });
                            } else {
                                bedChargeRate.append('<option value="0">No bed charges configured</option>');
                            }
                        },
                        error: function (error) {
                            console.log("Error loading bed charge rates:", error);
                            $("#bedChargeRate").html('<option value="0">Error loading rates</option>');
                        }
                    });
                }

                // Load bed charge rates on page load
                $(document).ready(function () {
                    loadBedChargeRates();
                });
                    
                    // Store data globally for responsive functionality
                    allPatientsData = response.d;
                    
                    // Initialize DataTable only after table population
                    initDataTable();
                    
                    // Update view mode to show appropriate interface
                    updateViewMode();
                }, // End of success function for loadPatients
                error: function(xhr, status, error) {
                    console.error('Error loading patients:', error);
                    alert(xhr.responseText);
                },
                complete: function() {
                    // Hide loading indicator after data is loaded (whether success or error)
                    $('#refreshIndicator').fadeOut(300);
                }
            }); // End of $.ajax for loadPatients
        } // End of loadPatients function

                // Document ready function
                $(document).ready(function () {
                    // Initialize responsive functionality
                    setupMobileSearch();
                    syncSearches();
                    updateViewMode();
                    setupMobileCardHandlers(); // Setup card event handlers
                    
                    // Load patients immediately
                    loadPatients();
                    
                    // Auto-refresh every 5 seconds
                    setInterval(function() {
                        console.log('Auto-refreshing patient list...');
                        loadPatients();
                    }, 5000);
                });

                    // Enhanced load lab orders with tests and results for current patient
                function loadLabOrdersEnhanced(prescid) {
                    console.log(`DEBUG: loadLabOrdersEnhanced called with prescid: ${prescid}`);
                    
                    $.ajax({
                        type: "POST",
                        url: "assignmed.aspx/GetLabOrders",
                        data: JSON.stringify({ prescid: prescid }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            console.log('DEBUG: GetLabOrders response:', response);
                            
                            const orders = response.d;
                            console.log(`DEBUG: Orders array:`, orders);
                            console.log(`DEBUG: Number of orders: ${orders ? orders.length : 'null/undefined'}`);
                            
                            let container = $('#labOrdersContainer');
                            container.empty();

                            if (orders && orders.length > 0) {
                                orders.forEach(function (order, index) {
                                    console.log(`DEBUG: Processing order ${index}:`, order);
                                    console.log(`DEBUG: Order ${order.OrderId} has ${order.OrderedTests ? order.OrderedTests.length : 'null'} tests:`, order.OrderedTests);
                                    createLabOrderCard(order, index, prescid, container);
                                });
                            } else {
                                console.log('DEBUG: No orders found, showing empty state');
                                container.append(`
                                    <div class="alert alert-info text-center">
                                        <i class="fa fa-info-circle"></i> No lab orders found. Click "Send to Lab" to create one.
                                    </div>
                                `);
                            }
                        },
                        error: function (error) {
                            console.error('DEBUG: Error loading lab orders:', error);
                            Swal.fire('Error', 'Failed to load lab orders', 'error');
                        }
                    });
                }

                // Create a lab order card with tests and results
                function createLabOrderCard(order, index, prescid, container) {
                    console.log(`DEBUG: Creating card for order ${order.OrderId}, tests:`, order.OrderedTests);
                    console.log(`DEBUG: Test count: ${order.OrderedTests ? order.OrderedTests.length : 'undefined'}`);
                    
                    let paymentStatusClass = order.IsPaid ? 'paid' : 'unpaid';
                    let paymentStatusText = order.IsPaid ? 'Paid' : 'Unpaid';
                    
                    let actionsHtml = '';
                    if (!order.IsPaid) {
                        actionsHtml = `
                            <button class="btn btn-sm btn-outline-light me-2" onclick="printLabOrder(${order.OrderId}); return false;" title="Print Order">
                                <i class="fa fa-print"></i>
                            </button>
                            <button class="btn btn-sm btn-outline-light" onclick="deleteLabOrderEnhanced(${order.OrderId}); return false;" title="Delete Order">
                                <i class="fa fa-trash"></i>
                            </button>
                        `;
                    } else {
                        actionsHtml = `
                            <button class="btn btn-sm btn-outline-light" onclick="printLabOrder(${order.OrderId}); return false;" title="Print Order">
                                <i class="fa fa-print"></i>
                            </button>
                        `;
                    }

                    let testBadgesHtml = '';
                    if (order.OrderedTests && order.OrderedTests.length > 0) {
                        testBadgesHtml = order.OrderedTests.map(test => {
                            console.log(`DEBUG: Creating badge for test: ${test}`);
                            return `<span class="test-badge">${test}</span>`;
                        }).join('');
                    }

                    let cardHtml = `
                        <div class="lab-order-card">
                            <div class="lab-order-header" onclick="toggleLabOrderDetails(${index})">
                                <div class="d-flex justify-content-between align-items-center w-100">
                                    <div>
                                        <h6 class="mb-1"><i class="fa fa-flask me-2"></i>Lab Order #${order.OrderId}</h6>
                                        <small>Ordered: ${order.OrderDate} | Tests: ${order.OrderedTests ? order.OrderedTests.length : 0} | Amount: $${order.ChargeAmount.toFixed(2)}</small>
                                    </div>
                                    <div class="d-flex align-items-center">
                                        <span class="payment-status ${paymentStatusClass} me-3">${paymentStatusText}</span>
                                        ${actionsHtml}
                                        <i class="fa fa-chevron-down toggle-icon ms-3" id="toggleIcon${index}"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="lab-order-body" id="labOrderBody${index}">
                                <div class="ordered-tests-section">
                                    <h6 class="mb-3"><i class="fa fa-list-alt me-2"></i>Ordered Tests</h6>
                                    <div class="test-badges">
                                        ${testBadgesHtml}
                                    </div>
                                    ${(!order.OrderedTests || order.OrderedTests.length === 0) ? '<p class="text-muted">No tests selected for this order.</p>' : ''}
                                </div>
                                <div class="test-results-section">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h6 class="mb-0"><i class="fa fa-chart-line me-2"></i>Test Results</h6>
                                        <button class="btn btn-sm btn-outline-primary" onclick="loadLabResults('${order.OrderId}', ${index})">
                                            <i class="fa fa-sync-alt me-1"></i>Refresh Results
                                        </button>
                                    </div>
                                    <div id="labResults${index}" class="lab-results-container">
                                        <div class="text-center text-muted">
                                            <i class="fa fa-spinner fa-spin me-2"></i>Loading results...
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `;

                    console.log(`DEBUG: Generated card HTML for order ${order.OrderId}`);
                    container.append(cardHtml);
                    
                    // Load results for this order
                    loadLabResults(order.OrderId, index);
                }

                // Toggle lab order details
                function toggleLabOrderDetails(index) {
                    let body = $(`#labOrderBody${index}`);
                    let icon = $(`#toggleIcon${index}`);
                    
                    body.toggleClass('show');
                    icon.toggleClass('rotated');
                }

                // Load lab results for a specific order
                function loadLabResults(orderId, cardIndex) {
                    console.log(`DEBUG: Loading lab results for order ${orderId}, cardIndex ${cardIndex}`);
                    
                    $.ajax({
                        type: "POST",
                        url: "assignmed.aspx/GetLabResults",
                        data: JSON.stringify({ orderId: orderId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            console.log(`DEBUG: Lab results response for order ${orderId}:`, response);
                            
                            const results = response.d;
                            let resultsContainer = $(`#labResults${cardIndex}`);
                            resultsContainer.empty();

                            if (results && results.length > 0) {
                                console.log(`DEBUG: Found ${results.length} results for order ${orderId}`);
                                let resultsHtml = '<div class="results-list">';
                                results.forEach(function (result) {
                                    console.log(`DEBUG: Result - ${result.TestName}: ${result.TestValue}`);
                                    resultsHtml += `
                                        <div class="result-item">
                                            <span class="result-name">${result.TestName.replace(/_/g, ' ')}</span>
                                            <span class="result-value">${result.TestValue}</span>
                                        </div>
                                    `;
                                });
                                resultsHtml += '</div>';
                                resultsContainer.html(resultsHtml);
                            } else {
                                console.log(`DEBUG: No results found for order ${orderId}`);
                                resultsContainer.html(`
                                    <div class="alert alert-warning text-center mb-0">
                                        <i class="fa fa-exclamation-triangle me-2"></i>No results available yet. Results will appear here once lab processing is complete.
                                    </div>
                                `);
                            }
                        },
                        error: function (error) {
                            console.error(`DEBUG: Error loading lab results for order ${orderId}:`, error);
                            let resultsContainer = $(`#labResults${cardIndex}`);
                            resultsContainer.html(`
                                <div class="alert alert-danger text-center mb-0">
                                    <i class="fa fa-exclamation-circle me-2"></i>Error loading results. Please try again.
                                </div>
                            `);
                        }
                    });
                }

                // Enhanced delete function for lab orders
                function deleteLabOrderEnhanced(orderId) {
                    event.preventDefault();
                    event.stopPropagation();
                    
                    Swal.fire({
                        title: 'Delete Lab Order?',
                        text: `Are you sure you want to delete Lab Order #${orderId}?`,
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#d33',
                        cancelButtonColor: '#3085d6',
                        confirmButtonText: 'Yes, delete it!'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax({
                                type: "POST",
                                url: "assignmed.aspx/DeleteLabOrder",
                                data: JSON.stringify({ orderId: orderId }),
                                contentType: "application/json; charset=utf-8",
                                dataType: "json",
                                success: function (response) {
                                    if (response.d.success) {
                                        Swal.fire('Deleted!', response.d.message, 'success');
                                        // Reload lab orders to refresh the display
                                        const prescid = $('#id11').val();
                                        if (prescid) {
                                            loadLabOrdersEnhanced(prescid);
                                        }
                                    } else {
                                        Swal.fire('Error', response.d.message, 'error');
                                    }
                                },
                                error: function (error) {
                                    console.error('Delete error:', error);
                                    Swal.fire('Error', 'Failed to delete lab order', 'error');
                                }
                            });
                        }
                    });
                    
                    return false;
                }

                // Enhanced print function for lab orders
                function printLabOrder(orderId) {
                    if (event) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    
                    console.log(`DEBUG: printLabOrder called with orderId: ${orderId}`);
                    console.log(`DEBUG: orderId type: ${typeof orderId}`);
                    
                    if (!orderId || orderId === 'undefined' || orderId === 'null') {
                        console.error('ERROR: Invalid orderId passed to printLabOrder:', orderId);
                        Swal.fire('Error', 'Invalid order ID. Cannot print.', 'error');
                        return false;
                    }
                    
                    // Open lab order print page in new window
                    const printUrl = `lab_orders_print.aspx?order_id=${orderId}`;
                    console.log(`DEBUG: Opening print URL: ${printUrl}`);
                    window.open(printUrl, '_blank', 'width=800,height=600,scrollbars=yes,resizable=yes');
                    
                    return false;
                }

        </script>
    </asp:Content>