<%@ Page Title="" Language="C#" MasterPageFile="~/labtest.Master" AutoEventWireup="true"
    CodeBehind="test_details.aspx.cs" Inherits="juba_hospital.test_details" %>
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

            .card {
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }

            /* Hide optional sections by default */
            .hidden {
                display: none !important;
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
        </style>
    </asp:Content>
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

        <!-- Modal -->
        <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1"
            aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog modal-fullscreen">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel1">Lab Tests</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input style="display:none" id="id111" />
                        <input style="display:none" id="id67" />
                        <input style="display:none" id="medid" />

                        <!-- Patient Information Card -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <div class="card border-primary">
                                    <div class="card-header bg-primary text-white">
                                        <h5 class="mb-0"><i class="fa fa-user"></i> Patient Information</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-4"><strong>Name:</strong> <span id="patientName"></span>
                                            </div>
                                            <div class="col-md-4"><strong>Sex:</strong> <span id="patientSex"></span>
                                            </div>
                                            <div class="col-md-4"><strong>Phone:</strong> <span
                                                    id="patientPhone"></span></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Ordered Tests Section -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <div class="card border-success">
                                    <div class="card-header bg-success text-white">
                                        <h5 class="mb-0"><i class="fa fa-flask"></i> Ordered Lab Tests</h5>
                                    </div>
                                    <div class="card-body">
                                        <div id="orderedTestsList" class="alert alert-info">
                                            <p class="mb-0">Loading ordered tests...</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Dynamic Ordered Tests Input Section -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <div class="card border-info">
                                    <div class="card-header bg-info text-white">
                                        <h5 class="mb-0"><i class="fa fa-edit"></i> Enter Results for Ordered Tests Only
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div id="orderedTestsInputs" class="row">
                                            <p class="mb-0">Loading input fields...</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- OLD SECTIONS - Optional reference (hidden by default) -->
                        <div class="row hidden" id="chk1">
                            <div class="col-12">
                                <h1>Lab Test Details</h1>

                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="radio2" value="0">
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
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckBHCG">
                                                <label class="form-check-label" for="flexCheckBHCG">
                                                    B-HCG
                                                </label>
                                            </div>

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
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckVirginalSwab">
                                                <label class="form-check-label" for="flexCheckVirginalSwab">
                                                    Virginal swab
                                                </label>
                                            </div>
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


                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="checkbox"
                                                    value="" id="flexCheckLiverFunctionTest">
                                                <label class="form-check-label" for="flexCheckLiverFunctionTest">
                                                    Liver function test
                                                </label>
                                            </div>
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
                                        </div>
                                    </div>





                                </div>

                            </div>





                        </div>

                        <div class="row">

                            <div class="col-12">
                                <h1>Lab Test Inputs Data</h1>

                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="radio21" value="0">
                                    <label class="form-check-label" for="radio2">Show Lab Tests</label>
                                </div>

                                <div id="additionalTests1" class="hidden">
                                    <div class="row">
                                        <div class="col-4">
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckLDL1">
                                                <label class="form-check-label" for="flexCheckLDL">Low-density
                                                    lipoprotein (LDL)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckHDL1">
                                                <label class="form-check-label" for="flexCheckHDL">High-density
                                                    lipoprotein (HDL)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckTotalCholesterol1">
                                                <label class="form-check-label" for="flexCheckTotalCholesterol">Total
                                                    cholesterol</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckTriglycerides1">
                                                <label class="form-check-label"
                                                    for="flexCheckTriglycerides">Triglycerides</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckSodium1">
                                                <label class="form-check-label" for="flexCheckSodium">Sodium</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input" type="text"
                                                    id="flexCheckTrichomonasVirginals1">
                                                <label class="form-check-label"
                                                    for="flexCheckTrichomonasVirginals1">TrichomonasVirginals</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input" type="text" id="flexCheckHCG1">
                                                <label class="form-check-label" for="flexCheckHCG1">HCG1</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input" type="text"
                                                    id="flexCheckFastingBloodSugar1">
                                                <label class="form-check-label"
                                                    for="flexCheckFastingBloodSugar1">FastingBloodSugar</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input" type="text"
                                                    id="flexCheckHpyloriAgStool1">
                                                <label class="form-check-label"
                                                    for="flexCheckHpyloriAgStool1">CheckHpyloriAgStool</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input" type="text"
                                                    id="flexCheckDirectBilirubin1">
                                                <label class="form-check-label"
                                                    for="flexCheckDirectBilirubin1">DirectBilirubin</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input" type="text" id="flexCheckUrea1">
                                                <label class="form-check-label" for="flexCheckUrea1">Urea</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input" type="text"
                                                    id="flexCheckLiverFunctionTest1">
                                                <label class="form-check-label"
                                                    for="flexCheckLiverFunctionTest1">LiverFunctionTest</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input" type="text" id="flexCheckHBV1">
                                                <label class="form-check-label" for="flexCheckHBV1">HBV1</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input" type="text"
                                                    id="Hepatitis_C_virus_HCV1">
                                                <label class="form-check-label"
                                                    for="flexCheckHBV1">Hepatitis_C_virus_HCV</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckPotassium1">
                                                <label class="form-check-label"
                                                    for="flexCheckPotassium">Potassium</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckChloride1">
                                                <label class="form-check-label" for="flexCheckChloride">Chloride</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckCalcium1">
                                                <label class="form-check-label" for="flexCheckCalcium">Calcium</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckPhosphorous1">
                                                <label class="form-check-label"
                                                    for="flexCheckPhosphorous">Phosphorous</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckMagnesium1">
                                                <label class="form-check-label"
                                                    for="flexCheckMagnesium">Magnesium</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckCreatinine1">
                                                <label class="form-check-label"
                                                    for="flexCheckCreatinine">Creatinine</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckAmylase1">
                                                <label class="form-check-label" for="flexCheckAmylase">Amylase</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckProgesteroneFemale1">
                                                <label class="form-check-label"
                                                    for="flexCheckProgesteroneFemale">Progesterone (Female)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckFSH1">
                                                <label class="form-check-label" for="flexCheckFSH">Follicle stimulating
                                                    hormone (FSH)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckEstradiol1">
                                                <label class="form-check-label"
                                                    for="flexCheckEstradiol">Estradiol</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckLH1">
                                                <label class="form-check-label" for="flexCheckLH">Luteinizing hormone
                                                    (LH)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckTestosteroneMale1">
                                                <label class="form-check-label"
                                                    for="flexCheckTestosteroneMale">Testosterone (Male)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckProlactin1">
                                                <label class="form-check-label"
                                                    for="flexCheckProlactin">Prolactin</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckSeminalFluidAnalysis1">
                                                <label class="form-check-label"
                                                    for="flexCheckSeminalFluidAnalysis">Seminal Fluid Analysis
                                                    (Male)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckBHCG1">
                                                <label class="form-check-label" for="flexCheckBHCG">B-HCG</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckUrineExamination1">
                                                <label class="form-check-label" for="flexCheckUrineExamination">Urine
                                                    examination</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckMalaria1">
                                                <label class="form-check-label" for="flexCheckTroponinI">Malaria</label>
                                            </div>

                                            <!-- New Cardiac Markers -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckTroponinI1">
                                                <label class="form-check-label" for="flexCheckTroponinI1">Troponin I (Cardiac marker)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckCKMB1">
                                                <label class="form-check-label" for="flexCheckCKMB1">CK-MB (Creatine Kinase-MB)</label>
                                            </div>

                                            <!-- New Coagulation Tests -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckAPTT1">
                                                <label class="form-check-label" for="flexCheckAPTT1">aPTT (Activated Partial Thromboplastin Time)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckINR1">
                                                <label class="form-check-label" for="flexCheckINR1">INR (International Normalized Ratio)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckDDimer1">
                                                <label class="form-check-label" for="flexCheckDDimer1">D-Dimer</label>
                                            </div>

                                            <!-- New Vitamins and Minerals -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckVitaminD1">
                                                <label class="form-check-label" for="flexCheckVitaminD1">Vitamin D</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckVitaminB121">
                                                <label class="form-check-label" for="flexCheckVitaminB121">Vitamin B12</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckFerritin1">
                                                <label class="form-check-label" for="flexCheckFerritin1">Ferritin (Iron storage)</label>
                                            </div>

                                            <!-- New Infectious Disease Tests -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckVDRL1">
                                                <label class="form-check-label" for="flexCheckVDRL1">VDRL (Syphilis test)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckDengueFever1">
                                                <label class="form-check-label" for="flexCheckDengueFever1">Dengue Fever (IgG/IgM)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckGonorrheaAg1">
                                                <label class="form-check-label" for="flexCheckGonorrheaAg1">Gonorrhea Ag</label>
                                            </div>

                                            <!-- New Tumor Markers -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckAFP1">
                                                <label class="form-check-label" for="flexCheckAFP1">AFP (Alpha-fetoprotein)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckTotalPSA1">
                                                <label class="form-check-label" for="flexCheckTotalPSA1">Total PSA (Prostate-Specific Antigen)</label>
                                            </div>

                                            <!-- New Fertility Test -->
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckAMH1">
                                                <label class="form-check-label" for="flexCheckAMH1">AMH (Anti-Müllerian Hormone)</label>
                                            </div>

                                        </div>

                                        <div class="col-4">
                                            <div class="form-check">
                                                <input class="custom-control-input" type="text"
                                                    id="flexCheckThyroidProfile1">
                                                <label class="form-check-label"
                                                    for="flexCheckThyroidProfile1">ThyroidProfile</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input" type="text" id="flexCheckT31">
                                                <label class="form-check-label" for="flexCheckT31">T31</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input" type="text" id="flexCheckT41">
                                                <label class="form-check-label" for="flexCheckT41">T41</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input" type="text" id="flexCheckTSH1">
                                                <label class="form-check-label" for="flexCheckTSH1">TSH1</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckStoolExamination1">
                                                <label class="form-check-label" for="flexCheckStoolExamination">Stool
                                                    examination</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input" type="text"
                                                    id="flexCheckSpermExamination1">
                                                <label class="form-check-label"
                                                    for="flexCheckSpermExamination1">SpermExamination</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input" type="text"
                                                    id="flexCheckVirginalSwab1">
                                                <label class="form-check-label"
                                                    for="flexCheckVirginalSwab1">VirginalSwab</label>
                                            </div>

                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckTyphoid1">
                                                <label class="form-check-label" for="flexCheckTyphoid">Typhoid
                                                    (hCG)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckHpyloriAntibody1">
                                                <label class="form-check-label" for="flexCheckHpyloriAntibody">H.pylori
                                                    antibody</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckStoolOccultBlood1">
                                                <label class="form-check-label" for="flexCheckStoolOccultBlood">Stool
                                                    occult blood</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckGeneralStoolExamination1">
                                                <label class="form-check-label"
                                                    for="flexCheckGeneralStoolExamination">General stool
                                                    examination</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckCalciumBlood1">
                                                <label class="form-check-label" for="flexCheckCalciumBlood">Calcium in
                                                    blood</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckG6PD">
                                                <label class="form-check-label" for="flexCheckG6PD">G6PD</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckAlkalinePhosphatase">
                                                <label class="form-check-label"
                                                    for="flexCheckAlkalinePhosphatase">Alkaline phosphatase</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckSGOTAST1">
                                                <label class="form-check-label" for="flexCheckSGOTAST">SGOT/AST</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckSGPTALT1">
                                                <label class="form-check-label" for="flexCheckSGPTALT">SGPT/ALT</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckGammaGlutamylTransferase">
                                                <label class="form-check-label"
                                                    for="flexCheckGammaGlutamylTransferase">Gamma-glutamyl transferase
                                                    (GGT)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckTotalProtein">
                                                <label class="form-check-label" for="flexCheckTotalProtein">Total
                                                    protein</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckAlbumin1">
                                                <label class="form-check-label" for="flexCheckAlbumin">Albumin</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckJGlobulin1">
                                                <label class="form-check-label" for="flexCheckGlobulin">Globulin</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckBilirubinTotal">
                                                <label class="form-check-label" for="flexCheckBilirubinTotal">Bilirubin
                                                    (Total)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckBilirubinDirect">
                                                <label class="form-check-label" for="flexCheckBilirubinDirect">Bilirubin
                                                    (Direct)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckCreatineKinaseTotal">
                                                <label class="form-check-label"
                                                    for="flexCheckCreatineKinaseTotal">Creatine kinase (Total)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckCKMB">
                                                <label class="form-check-label" for="flexCheckCKMB">CK-MB</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckLactateDehydrogenase">
                                                <label class="form-check-label"
                                                    for="flexCheckLactateDehydrogenase">Lactate dehydrogenase</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckLipase">
                                                <label class="form-check-label" for="flexCheckLipase">Lipase</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckPhosphataseAcid">
                                                <label class="form-check-label"
                                                    for="flexCheckPhosphataseAcid">Phosphatase (Acid)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckAlkalinePhosphatesALP1">
                                                <label class="form-check-label"
                                                    for="flexCheckPhosphataseAlkaline">Phosphatase (Alkaline)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckTroponinI">
                                                <label class="form-check-label" for="flexCheckTroponinI">Troponin
                                                    I</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckGeneralUrineExamination1">
                                                <label class="form-check-label"
                                                    for="flexCheckTroponinI">GeneralUrineExamination</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckHemoglobinA1c1">
                                                <label class="form-check-label"
                                                    for="flexCheckTroponinI">HemoglobinA1c</label>
                                            </div>



                                        </div>

                                        <div class="col-4">
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckTroponinT">
                                                <label class="form-check-label" for="flexCheckTroponinT">Troponin
                                                    T</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckUricAcid1">
                                                <label class="form-check-label" for="flexCheckUricAcid">Uric
                                                    acid</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckBrucellaAbortus1">
                                                <label class="form-check-label" for="flexCheckBrucellaAbortus">Brucella
                                                    abortus</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckCRP1">
                                                <label class="form-check-label" for="flexCheckCRP">C-reactive protein
                                                    (CRP)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckRF1">
                                                <label class="form-check-label" for="flexCheckRF">Rheumatoid factor
                                                    (RF)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckASO1">
                                                <label class="form-check-label" for="flexCheckASO">Antistreptolysin O
                                                    (ASO)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckToxoplasmosis1">
                                                <label class="form-check-label"
                                                    for="flexCheckToxoplasmosis">Toxoplasmosis</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckHBsAg">
                                                <label class="form-check-label" for="flexCheckHBsAg">HBsAg</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckAntiHCV">
                                                <label class="form-check-label" for="flexCheckAntiHCV">Anti-HCV</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckHIVAb1and2">
                                                <label class="form-check-label" for="flexCheckHIVAb1and2">HIV Ab
                                                    1&2</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckCMV">
                                                <label class="form-check-label" for="flexCheckCMV">CMV (IgG &
                                                    IgM)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckEBVIgM">
                                                <label class="form-check-label" for="flexCheckEBVIgM">EBV (IgM)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckRubella">
                                                <label class="form-check-label" for="flexCheckRubella">Rubella (IgG &
                                                    IgM)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckAntiHAVIgMandIgG">
                                                <label class="form-check-label" for="flexCheckAntiHAVIgMandIgG">Anti-HAV
                                                    (IgM & IgG)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckSalmonellaParatyphiAH">
                                                <label class="form-check-label"
                                                    for="flexCheckSalmonellaParatyphiAH">Salmonella Paratyphi A
                                                    (H)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckSalmonellaParatyphiBH">
                                                <label class="form-check-label"
                                                    for="flexCheckSalmonellaParatyphiBH">Salmonella Paratyphi B
                                                    (H)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckSalmonellaTyphiOH">
                                                <label class="form-check-label"
                                                    for="flexCheckSalmonellaTyphiOH">Salmonella Typhi (O&H)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckRPRSyphillis">
                                                <label class="form-check-label" for="flexCheckRPRSyphillis">RPR
                                                    (Syphilis)</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckTPHA1">
                                                <label class="form-check-label" for="flexCheckTPHA">TPHA</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckHIV1">
                                                <label class="form-check-label" for="flexCheckHIV1">HIV 1</label>
                                            </div>
                                            <div class="form-check">
                                                <input class="custom-control-input custom-checkbox" type="text"
                                                    id="flexCheckHIV2">
                                                <label class="form-check-label" for="flexCheckHIV2">HIV 2</label>
                                                <div class="form-check">
                                                    <input class="custom-control-input custom-checkbox" type="text"
                                                        id="flexCheckESR1">
                                                    <label class="form-check-label" for="flexCheckESR1">ESR</label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input" type="text"
                                                        id="flexCheckBloodGrouping1">
                                                    <label class="form-check-label"
                                                        for="flexCheckBloodGrouping1">BloodGrouping</label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input" type="text"
                                                        id="flexCheckBloodSugar1">
                                                    <label class="form-check-label"
                                                        for="flexCheckBloodSugar1">BloodSugar</label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input" type="text" id="flexCheckCBC1">
                                                    <label class="form-check-label" for="flexCheckCBC1">CBC</label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input" type="text"
                                                        id="flexCheckCrossMatching1">
                                                    <label class="form-check-label"
                                                        for="flexCheckCrossMatching1">CrossMatching</label>
                                                </div>

                                                <div class="form-check">
                                                    <input class="custom-control-input" type="text"
                                                        id="flexCheckBrucellaMelitensis1">
                                                    <label class="form-check-label"
                                                        for="flexCheckBrucellaMelitensis1">BrucellaMelitensis</label>
                                                </div>


                                                <div class="form-check">
                                                    <input class="custom-control-input" type="text"
                                                        id="flexCheckTotalBilirubin1">
                                                    <label class="form-check-label"
                                                        for="flexCheckBrucellaMelitensis1">TotalBilirubin</label>
                                                </div>


                                                <div class="form-check">
                                                    <input class="custom-control-input" type="text"
                                                        id="flexCheckHemoglobin1">
                                                    <label class="form-check-label"
                                                        for="flexCheckBrucellaMelitensis1">Hemoglobin</label>
                                                </div>


                                            </div>
                                        </div>







                                    </div>
                                </div>


                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button type="button" id="update" onclick="updateDynamicInputs()"
                            class="btn btn-primary">Update</button>
                        <button type="button" id="submit" onclick="callAjaxFunction()"
                            class="btn btn-primary">submit</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="card">
                <div class="card-header">
                    <div class="d-flex align-items-center">
                        <h4 class="card-title"> send lap results and edit results</h4>

                    </div>
                </div>
                <div class="card-body">


                    <div class="table-responsive">
                        <table id="datatable" class="display table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Sex</th>
                                    <th>Location</th>
                                    <th>Phone</th>
                                    <th>Amount</th>
                                    <th>D.O.B</th>
                                    <th>Date Registered</th>
                                    <th>Status</th>
                                    <th>Actions</th>
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
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </tfoot>
                            <tbody>

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <script src="assets/js/core/jquery-3.7.1.min.js"></script>
        <script src="https://cdn.datatables.net/1.10.25/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.2.3/js/dataTables.buttons.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/2.2.3/js/buttons.html5.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.70/pdfmake.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.70/vfs_fonts.js"></script>

        <script>

            // Helper function to build ordered tests display - GLOBAL SCOPE (used by both auto-load and edit button)
            function buildOrderedTestsDisplay(orderedTests, resultValues) {
                var orderedTestsList = '';
                var orderedTestsInputs = '';
                var testCount = 0;
                
                // Test name mapping
                var testNames = {
                    'Albumin': 'Albumin',
                    'Alkaline_phosphates_ALP': 'Alkaline Phosphatase (ALP)',
                    'Amylase': 'Amylase',
                    'Antistreptolysin_O_ASO': 'Antistreptolysin O (ASO)',
                    'Blood_grouping': 'Blood Grouping',
                    'Blood_sugar': 'Blood Sugar',
                    'Brucella_abortus': 'Brucella Abortus',
                    'Brucella_melitensis': 'Brucella Melitensis',
                    'CBC': 'CBC (Complete Blood Count)',
                    'C_reactive_protein_CRP': 'C-Reactive Protein (CRP)',
                    'Calcium': 'Calcium',
                    'Chloride': 'Chloride',
                    'Creatinine': 'Creatinine',
                    'Cross_matching': 'Cross Matching',
                    'Direct_bilirubin': 'Direct Bilirubin',
                    'ESR': 'ESR',
                    'Estradiol': 'Estradiol',
                    'Fasting_blood_sugar': 'Fasting Blood Sugar',
                    'Follicle_stimulating_hormone_FSH': 'FSH',
                    'General_stool_examination': 'General Stool Examination',
                    'General_urine_examination': 'General Urine Examination',
                    'Hemoglobin': 'Hemoglobin',
                    'Hemoglobin_A1c': 'Hemoglobin A1c',
                    'Hepatitis_B_virus_HBV': 'Hepatitis B (HBV)',
                    'Hepatitis_C_virus_HCV': 'Hepatitis C (HCV)',
                    'High_density_lipoprotein_HDL': 'HDL Cholesterol',
                    'Hpylori_Ag_stool': 'H. Pylori Ag (Stool)',
                    'Hpylori_antibody': 'H. Pylori Antibody',
                    'Human_chorionic_gonadotropin_hCG': 'hCG',
                    'Human_immune_deficiency_HIV': 'HIV',
                    'JGlobulin': 'J Globulin',
                    'Low_density_lipoprotein_LDL': 'LDL Cholesterol',
                    'Luteinizing_hormone_LH': 'LH',
                    'Magnesium': 'Magnesium',
                    'Malaria': 'Malaria',
                    'Phosphorous': 'Phosphorous',
                    'Potassium': 'Potassium',
                    'Progesterone_Female': 'Progesterone',
                    'Prolactin': 'Prolactin',
                    'Rheumatoid_factor_RF': 'Rheumatoid Factor (RF)',
                    'SGOT_AST': 'SGOT (AST)',
                    'SGPT_ALT': 'SGPT (ALT)',
                    'Seminal_Fluid_Analysis_Male_B_HCG': 'Seminal Fluid Analysis',
                    'Sodium': 'Sodium',
                    'Sperm_examination': 'Sperm Examination',
                    'Stool_examination': 'Stool Examination',
                    'Stool_occult_blood': 'Stool Occult Blood',
                    'TPHA': 'TPHA',
                    'Testosterone_Male': 'Testosterone',
                    'Thyroid_profile': 'Thyroid Profile',
                    'Thyroid_stimulating_hormone_TSH': 'TSH',
                    'Thyroxine_T4': 'T4',
                    'Total_bilirubin': 'Total Bilirubin',
                    'Total_cholesterol': 'Total Cholesterol',
                    'Toxoplasmosis': 'Toxoplasmosis',
                    'Triglycerides': 'Triglycerides',
                    'Triiodothyronine_T3': 'T3',
                    'Typhoid_hCG': 'Typhoid',
                    'Urea': 'Urea',
                    'Uric_acid': 'Uric Acid',
                    'Urine_examination': 'Urine Examination',
                    'Virginal_swab_trichomonas_virginals': 'Vaginal Swab',
                    'Troponin_I': 'Troponin I (Cardiac marker)',
                    'CK_MB': 'CK-MB (Creatine Kinase-MB)',
                    'aPTT': 'aPTT (Activated Partial Thromboplastin Time)',
                    'INR': 'INR (International Normalized Ratio)',
                    'D_Dimer': 'D-Dimer',
                    'Vitamin_D': 'Vitamin D',
                    'Vitamin_B12': 'Vitamin B12',
                    'Ferritin': 'Ferritin (Iron storage)',
                    'VDRL': 'VDRL (Syphilis test)',
                    'Dengue_Fever_IgG_IgM': 'Dengue Fever (IgG/IgM)',
                    'Gonorrhea_Ag': 'Gonorrhea Ag',
                    'AFP': 'AFP (Alpha-fetoprotein)',
                    'Total_PSA': 'Total PSA (Prostate-Specific Antigen)',
                    'AMH': 'AMH (Anti-Müllerian Hormone)'
                };
                
                // Loop through ordered tests to find which tests were ordered
                for (var key in orderedTests) {
                    if (orderedTests.hasOwnProperty(key) && testNames[key]) {
                        var value = orderedTests[key];
                        // Check if this test was ordered (value is not empty and not "not checked")
                        if (value && value !== '' && value !== 'not checked' && value !== 'Not checked' && key !== 'med_id' && key !== '__type' && key !== 'prescid' && key !== 'date_taken') {
                            testCount++;
                            var testName = testNames[key];
                            var resultValue = resultValues[key] || '';
                            
                            // Add to ordered tests list
                            orderedTestsList += '<span class="badge badge-primary mr-2 mb-2">' + testCount + '. ' + testName + '</span>';
                            
                            // Add input field for this test
                            orderedTestsInputs += '<div class="col-md-6 mb-3">' +
                                '<label for="input_' + key + '" class="form-label">' + testName + '</label>' +
                                '<input type="text" class="form-control" id="input_' + key + '" name="' + key + '" value="' + resultValue + '" placeholder="Enter result">' +
                                '</div>';
                        }
                    }
                }
                
                // Display the ordered tests list
                if (testCount > 0) {
                    $('#orderedTestsList').html(
                        '<div class="alert alert-info">' +
                        '<h5><i class="fa fa-list-ul"></i> Ordered Tests (' + testCount + ')</h5>' +
                        orderedTestsList +
                        '</div>'
                    );
                    $('#orderedTestsInputs').html('<div class="row">' + orderedTestsInputs + '</div>');
                } else {
                    $('#orderedTestsList').html('<div class="alert alert-warning">No tests ordered for this patient.</div>');
                    $('#orderedTestsInputs').html('');
                }
            }

            $(document).ready(function () {
                
                // Check if page loaded with URL parameters from lab_waiting_list.aspx
                var urlParams = new URLSearchParams(window.location.search);
                var orderId = urlParams.get('id');
                var prescid = urlParams.get('prescid');
                
                if (orderId && prescid) {
                    console.log("Auto-loading edit modal for order:", orderId, "prescid:", prescid);
                    
                    // Wait a moment for the page to fully load, then trigger the edit modal
                    setTimeout(function() {
                        autoLoadEditModal(orderId, prescid);
                    }, 500);
                }
                
                // Function to automatically load the edit modal when coming from lab_waiting_list
                function autoLoadEditModal(orderId, prescid) {
                    $("#id111").val(prescid);
                    
                    // Show loading state
                    $('#orderedTestsList').show().html('<div class="alert alert-info"><i class="fa fa-spinner fa-spin"></i> Loading ordered tests...</div>');
                    $('#orderedTestsInputs').show().html('<div class="alert alert-info"><i class="fa fa-spinner fa-spin"></i> Loading input fields...</div>');
                    
                    // Hide old checkbox sections
                    $('#chk1').addClass('hidden').hide();
                    
                    // Show the modal immediately
                    $('#staticBackdrop').modal('show');
                    
                    // First AJAX call - Get ordered tests
                    var ajaxCall1 = $.ajax({
                        type: "POST",
                        url: "test_details.aspx/getlapprocessed",
                        data: JSON.stringify({ prescid: prescid, orderId: orderId }),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            console.log("Auto-load: getlapprocessed response:", response);
                        },
                        error: function (response) {
                            alert("Error loading ordered tests: " + response.responseText);
                        }
                    });
                    
                    // Second AJAX call - Get result values
                    var ajaxCall2 = $.ajax({
                        url: 'test_details.aspx/editlabmedic',
                        data: JSON.stringify({ prescid: prescid, orderId: orderId }),
                        dataType: "json",
                        type: 'POST',
                        contentType: "application/json",
                        success: function (response) {
                            console.log("Auto-load: editlabmedic response:", response);
                        },
                        error: function (response) {
                            alert("Error loading result values: " + response.responseText);
                        }
                    });
                    
                    // Wait for BOTH AJAX calls to complete
                    $.when(ajaxCall1, ajaxCall2).done(function(result1, result2) {
                        var orderedTestsData = result1[0].d;
                        var resultValuesData = result2[0].d;
                        
                        console.log("Auto-load: Data loaded for order ID:", orderId);
                        console.log("Auto-load: Ordered tests data:", orderedTestsData);
                        console.log("Auto-load: Result values data:", resultValuesData);
                        
                        if (orderedTestsData.length > 0) {
                            var orderedTests = orderedTestsData[0];
                            var resultValues = resultValuesData.length > 0 ? resultValuesData[0] : {};
                            
                            console.log("Auto-load: orderedTests object:", orderedTests);
                            console.log("Auto-load: resultValues object:", resultValues);
                            console.log("Auto-load: lab_result_id value:", resultValues.lab_result_id);
                            console.log("Auto-load: med_id value:", resultValues.med_id);
                            
                            // Set lab_result_id for updating (backend returns it as med_id in editlabmedic!)
                            var labResultId = resultValues.lab_result_id || resultValues.med_id;
                            
                            if (labResultId) {
                                $("#id67").val(labResultId);
                                console.log("Auto-load: Set #id67 to:", labResultId);
                            } else {
                                console.error("Auto-load: No lab_result_id or med_id found in response!");
                            }
                            
                            // Build the ordered tests display and input fields dynamically
                            buildOrderedTestsDisplay(orderedTests, resultValues);
                        } else {
                            $('#orderedTestsList').html('<div class="alert alert-warning">No ordered tests found.</div>');
                            $('#orderedTestsInputs').html('');
                        }
                        
                        // Show Update button, hide Submit button
                        document.getElementById('update').style.display = 'inline-block';
                        document.getElementById('submit').style.display = 'none';
                        
                        console.log("Auto-load: Modal populated with ordered tests and results");
                    }).fail(function() {
                        alert("Error loading data. Please try again.");
                    });
                    
                    // Get patient info from URL or make separate call to get patient details
                    // Make a third AJAX call to get patient information
                    $.ajax({
                        type: "POST",
                        url: "lab_waiting_list.aspx/pendlap",
                        data: JSON.stringify({}),
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (response) {
                            if (response.d && response.d.length > 0) {
                                // Find the patient with matching order_id
                                var patientData = response.d.find(function(p) {
                                    return p.order_id == orderId;
                                });
                                
                                if (patientData) {
                                    $("#patientName").text(patientData.full_name || 'N/A');
                                    $("#patientSex").text(patientData.sex || 'N/A');
                                    $("#patientPhone").text(patientData.phone || 'N/A');
                                    console.log("Auto-load: Patient info set -", patientData.full_name);
                                }
                            }
                        },
                        error: function (response) {
                            console.log("Could not load patient info:", response);
                            // Set defaults
                            $("#patientName").text('N/A');
                            $("#patientSex").text('N/A');
                            $("#patientPhone").text('N/A');
                        }
                    });
                }

                // Initialize DataTable (check if not already initialized)
                if (!$.fn.DataTable.isDataTable('#datatable')) {
                    var table = $('#datatable').DataTable({
                        dom: 'Bfrtip',
                        buttons: ['excelHtml5'],
                        paging: true,
                        pageLength: 10,
                        lengthMenu: [10, 25, 50, 100],
                        responsive: true
                    });
                } else {
                    var table = $('#datatable').DataTable();
                }

                // Toggle for "All Available Tests (Optional Reference)"
                $('#radio2').on('change', function () {
                    if ($(this).is(':checked')) {
                        $('#additionalTests').removeClass('hidden');
                    } else {
                        $('#additionalTests').addClass('hidden');
                    }
                });

                // Toggle for "Lab Test Inputs Data (All Tests - Advanced)"
                $('#radio21').on('change', function () {
                    if ($(this).is(':checked')) {
                        $('#additionalTests1').removeClass('hidden');
                    } else {
                        $('#additionalTests1').addClass('hidden');
                    }
                });

            });

            // New function to update dynamic inputs (for new ordered tests interface)
            function updateDynamicInputs() {
                var id = $("#id67").val();
                
                console.log("Lab result ID (#id67):", id);
                
                if (!id) {
                    alert("Error: Lab result ID not found. Please try again.");
                    return;
                }
                
                // Initialize all fields to empty string (backend expects ALL parameters)
                var allFields = {
                    flexCheckGeneralUrineExamination1: '',
                    flexCheckProgesteroneFemale1: '',
                    flexCheckAmylase1: '',
                    flexCheckMagnesium1: '',
                    flexCheckPhosphorous1: '',
                    flexCheckCalcium1: '',
                    flexCheckChloride1: '',
                    flexCheckPotassium1: '',
                    flexCheckSodium1: '',
                    flexCheckUricAcid1: '',
                    flexCheckCreatinine1: '',
                    flexCheckUrea1: '',
                    flexCheckJGlobulin1: '',
                    flexCheckAlbumin1: '',
                    flexCheckTotalBilirubin1: '',
                    flexCheckAlkalinePhosphatesALP1: '',
                    flexCheckSGOTAST1: '',
                    flexCheckSGPTALT1: '',
                    flexCheckLiverFunctionTest1: '',
                    flexCheckTriglycerides1: '',
                    flexCheckTotalCholesterol1: '',
                    flexCheckHemoglobinA1c1: '',
                    flexCheckHDL1: '',
                    flexCheckLDL1: '',
                    flexCheckFSH1: '',
                    flexCheckEstradiol1: '',
                    flexCheckLH1: '',
                    flexCheckTestosteroneMale1: '',
                    flexCheckProlactin1: '',
                    flexCheckSeminalFluidAnalysis1: '',
                    flexCheckBHCG1: '',
                    flexCheckUrineExamination1: '',
                    flexCheckStoolExamination1: '',
                    flexCheckHemoglobin1: '',
                    flexCheckMalaria1: '',
                    flexCheckESR1: '',
                    flexCheckBloodGrouping1: '',
                    flexCheckBloodSugar1: '',
                    flexCheckCBC1: '',
                    flexCheckCrossMatching1: '',
                    flexCheckTPHA1: '',
                    flexCheckHIV1: '',
                    flexCheckHBV1: '',
                    flexCheckHCV1: '',
                    flexCheckBrucellaMelitensis1: '',
                    flexCheckBrucellaAbortus1: '',
                    flexCheckCRP1: '',
                    flexCheckRF1: '',
                    flexCheckASO1: '',
                    flexCheckToxoplasmosis1: '',
                    flexCheckTyphoid1: '',
                    flexCheckHpyloriAntibody1: '',
                    flexCheckStoolOccultBlood1: '',
                    flexCheckGeneralStoolExamination1: '',
                    flexCheckThyroidProfile1: '',
                    flexCheckT31: '',
                    flexCheckT41: '',
                    flexCheckTSH1: '',
                    flexCheckSpermExamination1: '',
                    flexCheckVirginalSwab1: '',
                    flexCheckTrichomonasVirginals1: '',
                    flexCheckHCG1: '',
                    flexCheckHpyloriAgStool1: '',
                    flexCheckFastingBloodSugar1: '',
                    flexCheckDirectBilirubin1: ''
                };
                
                // Map database field names to parameter names
                var fieldMapping = {
                    'General_urine_examination': 'flexCheckGeneralUrineExamination1',
                    'Progesterone_Female': 'flexCheckProgesteroneFemale1',
                    'Amylase': 'flexCheckAmylase1',
                    'Magnesium': 'flexCheckMagnesium1',
                    'Phosphorous': 'flexCheckPhosphorous1',
                    'Calcium': 'flexCheckCalcium1',
                    'Chloride': 'flexCheckChloride1',
                    'Potassium': 'flexCheckPotassium1',
                    'Sodium': 'flexCheckSodium1',
                    'Uric_acid': 'flexCheckUricAcid1',
                    'Creatinine': 'flexCheckCreatinine1',
                    'Urea': 'flexCheckUrea1',
                    'JGlobulin': 'flexCheckJGlobulin1',
                    'Albumin': 'flexCheckAlbumin1',
                    'Total_bilirubin': 'flexCheckTotalBilirubin1',
                    'Alkaline_phosphates_ALP': 'flexCheckAlkalinePhosphatesALP1',
                    'SGOT_AST': 'flexCheckSGOTAST1',
                    'SGPT_ALT': 'flexCheckSGPTALT1',
                    'Triglycerides': 'flexCheckTriglycerides1',
                    'Total_cholesterol': 'flexCheckTotalCholesterol1',
                    'Hemoglobin_A1c': 'flexCheckHemoglobinA1c1',
                    'High_density_lipoprotein_HDL': 'flexCheckHDL1',
                    'Low_density_lipoprotein_LDL': 'flexCheckLDL1',
                    'Follicle_stimulating_hormone_FSH': 'flexCheckFSH1',
                    'Estradiol': 'flexCheckEstradiol1',
                    'Luteinizing_hormone_LH': 'flexCheckLH1',
                    'Testosterone_Male': 'flexCheckTestosteroneMale1',
                    'Prolactin': 'flexCheckProlactin1',
                    'Seminal_Fluid_Analysis_Male_B_HCG': 'flexCheckSeminalFluidAnalysis1',
                    'Typhoid_hCG': 'flexCheckBHCG1',
                    'Urine_examination': 'flexCheckUrineExamination1',
                    'Stool_examination': 'flexCheckStoolExamination1',
                    'Hemoglobin': 'flexCheckHemoglobin1',
                    'Malaria': 'flexCheckMalaria1',
                    'ESR': 'flexCheckESR1',
                    'Blood_grouping': 'flexCheckBloodGrouping1',
                    'Blood_sugar': 'flexCheckBloodSugar1',
                    'CBC': 'flexCheckCBC1',
                    'Cross_matching': 'flexCheckCrossMatching1',
                    'TPHA': 'flexCheckTPHA1',
                    'Human_immune_deficiency_HIV': 'flexCheckHIV1',
                    'Hepatitis_B_virus_HBV': 'flexCheckHBV1',
                    'Hepatitis_C_virus_HCV': 'flexCheckHCV1',
                    'Brucella_melitensis': 'flexCheckBrucellaMelitensis1',
                    'Brucella_abortus': 'flexCheckBrucellaAbortus1',
                    'C_reactive_protein_CRP': 'flexCheckCRP1',
                    'Rheumatoid_factor_RF': 'flexCheckRF1',
                    'Antistreptolysin_O_ASO': 'flexCheckASO1',
                    'Toxoplasmosis': 'flexCheckToxoplasmosis1',
                    'Hpylori_antibody': 'flexCheckHpyloriAntibody1',
                    'Stool_occult_blood': 'flexCheckStoolOccultBlood1',
                    'General_stool_examination': 'flexCheckGeneralStoolExamination1',
                    'Thyroid_profile': 'flexCheckThyroidProfile1',
                    'Triiodothyronine_T3': 'flexCheckT31',
                    'Thyroxine_T4': 'flexCheckT41',
                    'Thyroid_stimulating_hormone_TSH': 'flexCheckTSH1',
                    'Sperm_examination': 'flexCheckSpermExamination1',
                    'Virginal_swab_trichomonas_virginals': 'flexCheckVirginalSwab1',
                    'Human_chorionic_gonadotropin_hCG': 'flexCheckHCG1',
                    'Hpylori_Ag_stool': 'flexCheckHpyloriAgStool1',
                    'Fasting_blood_sugar': 'flexCheckFastingBloodSugar1',
                    'Direct_bilirubin': 'flexCheckDirectBilirubin1'
                };
                
                // Collect values from dynamic inputs and map to parameter names
                $('#orderedTestsInputs input[name]').each(function() {
                    var fieldName = $(this).attr('name');
                    var fieldValue = $(this).val() || '';
                    var paramName = fieldMapping[fieldName];
                    
                    if (paramName) {
                        allFields[paramName] = fieldValue;
                        console.log("Mapping:", fieldName, "→", paramName, "=", fieldValue);
                    }
                });
                
                // Build AJAX data with ALL parameters
                var dataObj = { id: id };
                for (var key in allFields) {
                    dataObj[key] = allFields[key];
                }
                
                console.log("Sending update with", Object.keys(dataObj).length, "parameters");
                
                $.ajax({
                    url: 'test_details.aspx/updatetest',
                    data: JSON.stringify(dataObj),
                    dataType: "json",
                    type: 'POST',
                    contentType: "application/json",
                    success: function (response) {
                        console.log("Update successful:", response);
                        Swal.fire({
                            icon: 'success',
                            title: 'Success!',
                            text: 'Lab results updated successfully',
                            showConfirmButton: false,
                            timer: 1500
                        });
                        datadisplay();
                        $('#staticBackdrop').modal('hide');
                    },
                    error: function (response) {
                        console.log("Update error:", response);
                        alert("Error updating results: " + response.responseText);
                    }
                });
            }

            function updatekabinput() {

                var flexCheckHCV1 = $("#Hepatitis_C_virus_HCV1").val();
                var flexCheckGeneralUrineExamination1 = $("#flexCheckGeneralUrineExamination1").val();
                var flexCheckProgesteroneFemale1 = $("#flexCheckProgesteroneFemale1").val();
                var flexCheckAmylase1 = $("#flexCheckAmylase1").val();
                var flexCheckMagnesium1 = $("#flexCheckMagnesium1").val();
                var flexCheckPhosphorous1 = $("#flexCheckPhosphorous1").val();
                var flexCheckCalcium1 = $("#flexCheckCalcium1").val();
                var flexCheckChloride1 = $("#flexCheckChloride1").val();
                var flexCheckPotassium1 = $("#flexCheckPotassium1").val();
                var flexCheckSodium1 = $("#flexCheckSodium1").val();
                var flexCheckUricAcid1 = $("#flexCheckUricAcid1").val();
                var flexCheckCreatinine1 = $("#flexCheckCreatinine1").val();
                var flexCheckUrea1 = $("#flexCheckUrea1").val();
                var flexCheckJGlobulin1 = $("#flexCheckJGlobulin1").val();
                var flexCheckAlbumin1 = $("#flexCheckAlbumin1").val();
                var flexCheckTotalBilirubin1 = $("#flexCheckTotalBilirubin1").val();
                var flexCheckAlkalinePhosphatesALP1 = $("#flexCheckAlkalinePhosphatesALP1").val();
                var flexCheckSGOTAST1 = $("#flexCheckSGOTAST1").val();
                var flexCheckSGPTALT1 = $("#flexCheckSGPTALT1").val();
                var flexCheckLiverFunctionTest1 = $("#flexCheckLiverFunctionTest1").val();
                var flexCheckTriglycerides1 = $("#flexCheckTriglycerides1").val();
                var flexCheckTotalCholesterol1 = $("#flexCheckTotalCholesterol1").val();
                var flexCheckHemoglobinA1c1 = $("#flexCheckHemoglobinA1c1").val();
                var flexCheckHDL1 = $("#flexCheckHDL1").val();
                var flexCheckLDL1 = $("#flexCheckLDL1").val();
                var flexCheckFSH1 = $("#flexCheckFSH1").val();
                var flexCheckEstradiol1 = $("#flexCheckEstradiol1").val();
                var flexCheckLH1 = $("#flexCheckLH1").val();
                var flexCheckTestosteroneMale1 = $("#flexCheckTestosteroneMale1").val();
                var flexCheckProlactin1 = $("#flexCheckProlactin1").val();
                var flexCheckSeminalFluidAnalysis1 = $("#flexCheckSeminalFluidAnalysis1").val();
                var flexCheckBHCG1 = $("#flexCheckBHCG1").val();
                var flexCheckUrineExamination1 = $("#flexCheckUrineExamination1").val();
                var flexCheckStoolExamination1 = $("#flexCheckStoolExamination1").val();
                var flexCheckHemoglobin1 = $("#flexCheckHemoglobin1").val();
                var flexCheckMalaria1 = $("#flexCheckMalaria1").val();
                var flexCheckESR1 = $("#flexCheckESR1").val();
                var flexCheckBloodGrouping1 = $("#flexCheckBloodGrouping1").val();
                var flexCheckBloodSugar1 = $("#flexCheckBloodSugar1").val();
                var flexCheckCBC1 = $("#flexCheckCBC1").val();
                var flexCheckCrossMatching1 = $("#flexCheckCrossMatching1").val();
                var flexCheckTPHA1 = $("#flexCheckTPHA1").val();
                var flexCheckHIV1 = $("#flexCheckHIV1").val();
                var flexCheckHBV1 = $("#flexCheckHBV1").val();
                var flexCheckBrucellaMelitensis1 = $("#flexCheckBrucellaMelitensis1").val();
                var flexCheckBrucellaAbortus1 = $("#flexCheckBrucellaAbortus1").val();
                var flexCheckCRP1 = $("#flexCheckCRP1").val();
                var flexCheckRF1 = $("#flexCheckRF1").val();
                var flexCheckASO1 = $("#flexCheckASO1").val();
                var flexCheckToxoplasmosis1 = $("#flexCheckToxoplasmosis1").val();
                var flexCheckTyphoid1 = $("#flexCheckTyphoid1").val();
                var flexCheckHpyloriAntibody1 = $("#flexCheckHpyloriAntibody1").val();
                var flexCheckStoolOccultBlood1 = $("#flexCheckStoolOccultBlood1").val();
                var flexCheckGeneralStoolExamination1 = $("#flexCheckGeneralStoolExamination1").val();
                var flexCheckThyroidProfile1 = $("#flexCheckThyroidProfile1").val();
                var flexCheckT31 = $("#flexCheckT31").val();
                var flexCheckT41 = $("#flexCheckT41").val();
                var flexCheckTSH1 = $("#flexCheckTSH1").val();
                var flexCheckSpermExamination1 = $("#flexCheckSpermExamination1").val();
                var flexCheckVirginalSwab1 = $("#flexCheckVirginalSwab1").val();
                var flexCheckTrichomonasVirginals1 = $("#flexCheckTrichomonasVirginals1").val();
                var flexCheckHCG1 = $("#flexCheckHCG1").val();
                var flexCheckHpyloriAgStool1 = $("#flexCheckHpyloriAgStool1").val();
                var flexCheckFastingBloodSugar1 = $("#flexCheckFastingBloodSugar1").val();
                var flexCheckDirectBilirubin1 = $("#flexCheckDirectBilirubin1").val();
                var id = $("#id67").val();



                $.ajax({
                    url: 'test_details.aspx/updatetest',
                    data: "{'id':'" + id + "'," +
                        "'flexCheckLiverFunctionTest1':'" + flexCheckLiverFunctionTest1 + "'," +
                        "'flexCheckBloodGrouping1':'" + flexCheckBloodGrouping1 + "'," +
                        "'flexCheckMalaria1':'" + flexCheckMalaria1 + "'," +
                        "'flexCheckHemoglobin1':'" + flexCheckHemoglobin1 + "'," +
                        "'flexCheckHemoglobinA1c1':'" + flexCheckHemoglobinA1c1 + "'," +
                        "'flexCheckFastingBloodSugar1':'" + flexCheckFastingBloodSugar1 + "'," +
                        "'flexCheckHpyloriAgStool1':'" + flexCheckHpyloriAgStool1 + "'," +
                        "'flexCheckTrichomonasVirginals1':'" + flexCheckTrichomonasVirginals1 + "'," +
                        "'flexCheckVirginalSwab1':'" + flexCheckVirginalSwab1 + "'," +
                        "'flexCheckSpermExamination1':'" + flexCheckSpermExamination1 + "'," +
                        "'flexCheckTSH1':'" + flexCheckTSH1 + "'," +
                        "'flexCheckT41':'" + flexCheckT41 + "'," +
                        "'flexCheckHCG1':'" + flexCheckHCG1 + "'," +
                        "'flexCheckUrea1':'" + flexCheckUrea1 + "'," +
                        "'flexCheckT31':'" + flexCheckT31 + "'," +
                        "'flexCheckThyroidProfile1':'" + flexCheckThyroidProfile1 + "'," +
                        "'flexCheckBrucellaMelitensis1':'" + flexCheckBrucellaMelitensis1 + "'," +
                        "'flexCheckCrossMatching1':'" + flexCheckCrossMatching1 + "'," +
                        "'flexCheckCBC1':'" + flexCheckCBC1 + "'," +
                        "'flexCheckBloodSugar1':'" + flexCheckBloodSugar1 + "'," +
                        "'flexCheckUrea1':'" + flexCheckUrea1 + "'," +
                        "'flexCheckUrea1':'" + flexCheckUrea1 + "'," +
                        "'flexCheckESR1':'" + flexCheckESR1 + "'," +
                        "'flexCheckLDL1':'" + flexCheckLDL1 + "'," +
                        "'flexCheckHDL1':'" + flexCheckHDL1 + "'," +
                        "'flexCheckGeneralUrineExamination1':'" + flexCheckGeneralUrineExamination1 + "'," +
                        "'flexCheckTotalCholesterol1':'" + flexCheckTotalCholesterol1 + "'," +
                        "'flexCheckTriglycerides1':'" + flexCheckTriglycerides1 + "'," +
                        "'flexCheckSodium1':'" + flexCheckSodium1 + "'," +
                        "'flexCheckPotassium1':'" + flexCheckPotassium1 + "'," +
                        "'flexCheckChloride1':'" + flexCheckChloride1 + "'," +
                        "'flexCheckCalcium1':'" + flexCheckCalcium1 + "'," +
                        "'flexCheckPhosphorous1':'" + flexCheckPhosphorous1 + "'," +
                        "'flexCheckMagnesium1':'" + flexCheckMagnesium1 + "'," +
                        "'flexCheckCreatinine1':'" + flexCheckCreatinine1 + "'," +
                        "'flexCheckAmylase1':'" + flexCheckAmylase1 + "'," +
                        "'flexCheckProgesteroneFemale1':'" + flexCheckProgesteroneFemale1 + "'," +
                        "'flexCheckFSH1':'" + flexCheckFSH1 + "'," +
                        "'flexCheckEstradiol1':'" + flexCheckEstradiol1 + "'," +
                        "'flexCheckLH1':'" + flexCheckLH1 + "'," +
                        "'flexCheckTestosteroneMale1':'" + flexCheckTestosteroneMale1 + "'," +
                        "'flexCheckProlactin1':'" + flexCheckProlactin1 + "'," +
                        "'flexCheckSeminalFluidAnalysis1':'" + flexCheckSeminalFluidAnalysis1 + "'," +
                        "'flexCheckBHCG1':'" + flexCheckBHCG1 + "'," +
                        "'flexCheckUrineExamination1':'" + flexCheckUrineExamination1 + "'," +
                        "'flexCheckStoolExamination1':'" + flexCheckStoolExamination1 + "'," +
                        "'flexCheckTyphoid1':'" + flexCheckTyphoid1 + "'," +
                        "'flexCheckHpyloriAntibody1':'" + flexCheckHpyloriAntibody1 + "'," +
                        "'flexCheckStoolOccultBlood1':'" + flexCheckStoolOccultBlood1 + "'," +
                        "'flexCheckGeneralStoolExamination1':'" + flexCheckGeneralStoolExamination1 + "'," +
                        "'flexCheckCalciumBlood1':'" + flexCheckCalcium1 + "'," +
                        "'flexCheckG6PD':'" + flexCheckG6PD + "'," +
                        "'flexCheckAlkalinePhosphatesALP1':'" + flexCheckAlkalinePhosphatesALP1 + "'," +
                        "'flexCheckSGOTAST1':'" + flexCheckSGOTAST1 + "'," +
                        "'flexCheckSGPTALT1':'" + flexCheckSGPTALT1 + "'," +
                        "'flexCheckGammaGlutamylTransferase':'" + flexCheckGammaGlutamylTransferase + "'," +
                        "'flexCheckTotalProtein':'" + flexCheckTotalProtein + "'," +
                        "'flexCheckAlbumin1':'" + flexCheckAlbumin1 + "'," +
                        "'flexCheckJGlobulin1':'" + flexCheckJGlobulin1 + "'," +
                        "'flexCheckTotalBilirubin1':'" + flexCheckTotalBilirubin1 + "'," +
                        "'flexCheckDirectBilirubin1':'" + flexCheckDirectBilirubin1 + "'," +
                        "'flexCheckCreatineKinaseTotal':'" + flexCheckCreatineKinaseTotal + "'," +
                        "'flexCheckCKMB':'" + flexCheckCKMB + "'," +
                        "'flexCheckLactateDehydrogenase':'" + flexCheckLactateDehydrogenase + "'," +
                        "'flexCheckLipase':'" + flexCheckLipase + "'," +
                        "'flexCheckPhosphataseAcid':'" + flexCheckPhosphataseAcid + "'," +
                        "'flexCheckTroponinI':'" + flexCheckTroponinI + "'," +
                        "'flexCheckTroponinT':'" + flexCheckTroponinT + "'," +
                        "'flexCheckUricAcid1':'" + flexCheckUricAcid1 + "'," +
                        "'flexCheckBrucellaAbortus1':'" + flexCheckBrucellaAbortus1 + "'," +
                        "'flexCheckCRP1':'" + flexCheckCRP1 + "'," +
                        "'flexCheckRF1':'" + flexCheckRF1 + "'," +
                        "'flexCheckASO1':'" + flexCheckASO1 + "'," +
                        "'flexCheckToxoplasmosis1':'" + flexCheckToxoplasmosis1 + "'," +
                        "'flexCheckHBV1':'" + flexCheckHBV1 + "'," +
                        "'flexCheckHCV1':'" + flexCheckHCV1 + "'," +
                        "'flexCheckHIVAb1and2':'" + flexCheckHIV1 + "'," +
                        "'flexCheckCMV':'" + flexCheckCMV + "'," +
                        "'flexCheckEBVIgM':'" + flexCheckEBVIgM + "'," +
                        "'flexCheckRubella':'" + flexCheckRubella + "'," +
                        "'flexCheckAntiHAVIgMandIgG':'" + flexCheckAntiHAVIgMandIgG + "'," +
                        "'flexCheckSalmonellaParatyphiAH':'" + flexCheckSalmonellaParatyphiAH + "'," +
                        "'flexCheckSalmonellaParatyphiBH':'" + flexCheckSalmonellaParatyphiBH + "'," +
                        "'flexCheckSalmonellaTyphiOH':'" + flexCheckSalmonellaTyphiOH + "'," +
                        "'flexCheckRPRSyphillis':'" + flexCheckRPRSyphillis + "'," +
                        "'flexCheckTPHA1':'" + flexCheckTPHA1 + "'," +
                        "'flexCheckHIV1':'" + flexCheckHIV1 + "'," +
                        "'flexCheckHIV2':'" + flexCheckHIV2 + "'}",
                    dataType: 'json',
                    type: 'POST',
                    contentType: 'application/json; charset=utf-8',
                    success: function (response) {
                        console.log(response);
                        datadisplay();
                        $('#staticBackdrop').modal('hide');
                        Swal.fire('Successfully Updated!', 'You updated a new Patient!', 'success');
                    },
                    error: function (response) {
                        alert(response.responseText);
                        console.log(response);
                    }
                });
            }


            function callAjaxFunction() {



                var flexCheckHCV1 = $("#Hepatitis_C_virus_HCV1").val();
                var flexCheckGeneralUrineExamination1 = $("#flexCheckGeneralUrineExamination1").val();
                var flexCheckProgesteroneFemale1 = $("#flexCheckProgesteroneFemale1").val();
                var flexCheckAmylase1 = $("#flexCheckAmylase1").val();
                var flexCheckMagnesium1 = $("#flexCheckMagnesium1").val();
                var flexCheckPhosphorous1 = $("#flexCheckPhosphorous1").val();
                var flexCheckCalcium1 = $("#flexCheckCalcium1").val();
                var flexCheckChloride1 = $("#flexCheckChloride1").val();
                var flexCheckPotassium1 = $("#flexCheckPotassium1").val();
                var flexCheckSodium1 = $("#flexCheckSodium1").val();
                var flexCheckUricAcid1 = $("#flexCheckUricAcid1").val();
                var flexCheckCreatinine1 = $("#flexCheckCreatinine1").val();
                var flexCheckUrea1 = $("#flexCheckUrea1").val();
                var flexCheckJGlobulin1 = $("#flexCheckJGlobulin1").val();
                var flexCheckAlbumin1 = $("#flexCheckAlbumin1").val();
                var flexCheckTotalBilirubin1 = $("#flexCheckTotalBilirubin1").val();
                var flexCheckAlkalinePhosphatesALP1 = $("#flexCheckAlkalinePhosphatesALP1").val();
                var flexCheckSGOTAST1 = $("#flexCheckSGOTAST1").val();
                var flexCheckSGPTALT1 = $("#flexCheckSGPTALT1").val();
                var flexCheckLiverFunctionTest1 = $("#flexCheckLiverFunctionTest1").val();
                var flexCheckTriglycerides1 = $("#flexCheckTriglycerides1").val();
                var flexCheckTotalCholesterol1 = $("#flexCheckTotalCholesterol1").val();
                var flexCheckHemoglobinA1c1 = $("#flexCheckHemoglobinA1c1").val();
                var flexCheckHDL1 = $("#flexCheckHDL1").val();
                var flexCheckLDL1 = $("#flexCheckLDL1").val();
                var flexCheckFSH1 = $("#flexCheckFSH1").val();
                var flexCheckEstradiol1 = $("#flexCheckEstradiol1").val();
                var flexCheckLH1 = $("#flexCheckLH1").val();
                var flexCheckTestosteroneMale1 = $("#flexCheckTestosteroneMale1").val();
                var flexCheckProlactin1 = $("#flexCheckProlactin1").val();
                var flexCheckSeminalFluidAnalysis1 = $("#flexCheckSeminalFluidAnalysis1").val();
                var flexCheckBHCG1 = $("#flexCheckBHCG1").val();
                var flexCheckUrineExamination1 = $("#flexCheckUrineExamination1").val();
                var flexCheckStoolExamination1 = $("#flexCheckStoolExamination1").val();
                var flexCheckHemoglobin1 = $("#flexCheckHemoglobin1").val();
                var flexCheckMalaria1 = $("#flexCheckMalaria1").val();
                var flexCheckESR1 = $("#flexCheckESR1").val();
                var flexCheckBloodGrouping1 = $("#flexCheckBloodGrouping1").val();
                var flexCheckBloodSugar1 = $("#flexCheckBloodSugar1").val();
                var flexCheckCBC1 = $("#flexCheckCBC1").val();
                var flexCheckCrossMatching1 = $("#flexCheckCrossMatching1").val();
                var flexCheckTPHA1 = $("#flexCheckTPHA1").val();
                var flexCheckHIV1 = $("#flexCheckHIV1").val();
                var flexCheckHBV1 = $("#flexCheckHBV1").val();
                var flexCheckBrucellaMelitensis1 = $("#flexCheckBrucellaMelitensis1").val();
                var flexCheckBrucellaAbortus1 = $("#flexCheckBrucellaAbortus1").val();
                var flexCheckCRP1 = $("#flexCheckCRP1").val();
                var flexCheckRF1 = $("#flexCheckRF1").val();
                var flexCheckASO1 = $("#flexCheckASO1").val();
                var flexCheckToxoplasmosis1 = $("#flexCheckToxoplasmosis1").val();
                var flexCheckTyphoid1 = $("#flexCheckTyphoid1").val();
                var flexCheckHpyloriAntibody1 = $("#flexCheckHpyloriAntibody1").val();
                var flexCheckStoolOccultBlood1 = $("#flexCheckStoolOccultBlood1").val();
                var flexCheckGeneralStoolExamination1 = $("#flexCheckGeneralStoolExamination1").val();
                var flexCheckThyroidProfile1 = $("#flexCheckThyroidProfile1").val();
                var flexCheckT31 = $("#flexCheckT31").val();
                var flexCheckT41 = $("#flexCheckT41").val();
                var flexCheckTSH1 = $("#flexCheckTSH1").val();
                var flexCheckSpermExamination1 = $("#flexCheckSpermExamination1").val();
                var flexCheckVirginalSwab1 = $("#flexCheckVirginalSwab1").val();
                var flexCheckTrichomonasVirginals1 = $("#flexCheckTrichomonasVirginals1").val();
                var flexCheckHCG1 = $("#flexCheckHCG1").val();
                var flexCheckHpyloriAgStool1 = $("#flexCheckHpyloriAgStool1").val();
                var flexCheckFastingBloodSugar1 = $("#flexCheckFastingBloodSugar1").val();
                var flexCheckDirectBilirubin1 = $("#flexCheckDirectBilirubin1").val();

                var id = $("#medid").val();
                var prescid = $("#id111").val();

                $.ajax({
                    url: 'test_details.aspx/submitdata',
                    data: "{'id':'" + id + "'," +
                        "'prescid':'" + prescid + "'," +
                        "'flexCheckLiverFunctionTest1':'" + flexCheckLiverFunctionTest1 + "'," +
                        "'flexCheckBloodGrouping1':'" + flexCheckBloodGrouping1 + "'," +
                        "'flexCheckMalaria1':'" + flexCheckMalaria1 + "'," +
                        "'flexCheckHemoglobin1':'" + flexCheckHemoglobin1 + "'," +
                        "'flexCheckHemoglobinA1c1':'" + flexCheckHemoglobinA1c1 + "'," +
                        "'flexCheckFastingBloodSugar1':'" + flexCheckFastingBloodSugar1 + "'," +
                        "'flexCheckHpyloriAgStool1':'" + flexCheckHpyloriAgStool1 + "'," +
                        "'flexCheckTrichomonasVirginals1':'" + flexCheckTrichomonasVirginals1 + "'," +
                        "'flexCheckVirginalSwab1':'" + flexCheckVirginalSwab1 + "'," +
                        "'flexCheckSpermExamination1':'" + flexCheckSpermExamination1 + "'," +
                        "'flexCheckTSH1':'" + flexCheckTSH1 + "'," +
                        "'flexCheckT41':'" + flexCheckT41 + "'," +
                        "'flexCheckHCG1':'" + flexCheckHCG1 + "'," +
                        "'flexCheckUrea1':'" + flexCheckUrea1 + "'," +
                        "'flexCheckT31':'" + flexCheckT31 + "'," +
                        "'flexCheckThyroidProfile1':'" + flexCheckThyroidProfile1 + "'," +
                        "'flexCheckBrucellaMelitensis1':'" + flexCheckBrucellaMelitensis1 + "'," +
                        "'flexCheckCrossMatching1':'" + flexCheckCrossMatching1 + "'," +
                        "'flexCheckCBC1':'" + flexCheckCBC1 + "'," +
                        "'flexCheckBloodSugar1':'" + flexCheckBloodSugar1 + "'," +
                        "'flexCheckUrea1':'" + flexCheckUrea1 + "'," +
                        "'flexCheckUrea1':'" + flexCheckUrea1 + "'," +
                        "'flexCheckESR1':'" + flexCheckESR1 + "'," +
                        "'flexCheckLDL1':'" + flexCheckLDL1 + "'," +
                        "'flexCheckHDL1':'" + flexCheckHDL1 + "'," +
                        "'flexCheckGeneralUrineExamination1':'" + flexCheckGeneralUrineExamination1 + "'," +
                        "'flexCheckTotalCholesterol1':'" + flexCheckTotalCholesterol1 + "'," +
                        "'flexCheckTriglycerides1':'" + flexCheckTriglycerides1 + "'," +
                        "'flexCheckSodium1':'" + flexCheckSodium1 + "'," +
                        "'flexCheckPotassium1':'" + flexCheckPotassium1 + "'," +
                        "'flexCheckChloride1':'" + flexCheckChloride1 + "'," +
                        "'flexCheckCalcium1':'" + flexCheckCalcium1 + "'," +
                        "'flexCheckPhosphorous1':'" + flexCheckPhosphorous1 + "'," +
                        "'flexCheckMagnesium1':'" + flexCheckMagnesium1 + "'," +
                        "'flexCheckCreatinine1':'" + flexCheckCreatinine1 + "'," +
                        "'flexCheckAmylase1':'" + flexCheckAmylase1 + "'," +
                        "'flexCheckProgesteroneFemale1':'" + flexCheckProgesteroneFemale1 + "'," +
                        "'flexCheckFSH1':'" + flexCheckFSH1 + "'," +
                        "'flexCheckEstradiol1':'" + flexCheckEstradiol1 + "'," +
                        "'flexCheckLH1':'" + flexCheckLH1 + "'," +
                        "'flexCheckTestosteroneMale1':'" + flexCheckTestosteroneMale1 + "'," +
                        "'flexCheckProlactin1':'" + flexCheckProlactin1 + "'," +
                        "'flexCheckSeminalFluidAnalysis1':'" + flexCheckSeminalFluidAnalysis1 + "'," +
                        "'flexCheckBHCG1':'" + flexCheckBHCG1 + "'," +
                        "'flexCheckUrineExamination1':'" + flexCheckUrineExamination1 + "'," +
                        "'flexCheckStoolExamination1':'" + flexCheckStoolExamination1 + "'," +
                        "'flexCheckTyphoid1':'" + flexCheckTyphoid1 + "'," +
                        "'flexCheckHpyloriAntibody1':'" + flexCheckHpyloriAntibody1 + "'," +
                        "'flexCheckStoolOccultBlood1':'" + flexCheckStoolOccultBlood1 + "'," +
                        "'flexCheckGeneralStoolExamination1':'" + flexCheckGeneralStoolExamination1 + "'," +
                        "'flexCheckCalciumBlood1':'" + flexCheckCalcium1 + "'," +
                        "'flexCheckG6PD':'" + flexCheckG6PD + "'," +
                        "'flexCheckAlkalinePhosphatesALP1':'" + flexCheckAlkalinePhosphatesALP1 + "'," +
                        "'flexCheckSGOTAST1':'" + flexCheckSGOTAST1 + "'," +
                        "'flexCheckSGPTALT1':'" + flexCheckSGPTALT1 + "'," +
                        "'flexCheckGammaGlutamylTransferase':'" + flexCheckGammaGlutamylTransferase + "'," +
                        "'flexCheckTotalProtein':'" + flexCheckTotalProtein + "'," +
                        "'flexCheckAlbumin1':'" + flexCheckAlbumin1 + "'," +
                        "'flexCheckJGlobulin1':'" + flexCheckJGlobulin1 + "'," +
                        "'flexCheckTotalBilirubin1':'" + flexCheckTotalBilirubin1 + "'," +
                        "'flexCheckDirectBilirubin1':'" + flexCheckDirectBilirubin1 + "'," +
                        "'flexCheckCreatineKinaseTotal':'" + flexCheckCreatineKinaseTotal + "'," +
                        "'flexCheckCKMB':'" + flexCheckCKMB + "'," +
                        "'flexCheckLactateDehydrogenase':'" + flexCheckLactateDehydrogenase + "'," +
                        "'flexCheckLipase':'" + flexCheckLipase + "'," +
                        "'flexCheckPhosphataseAcid':'" + flexCheckPhosphataseAcid + "'," +
                        "'flexCheckTroponinI':'" + flexCheckTroponinI + "'," +
                        "'flexCheckTroponinT':'" + flexCheckTroponinT + "'," +
                        "'flexCheckUricAcid1':'" + flexCheckUricAcid1 + "'," +
                        "'flexCheckBrucellaAbortus1':'" + flexCheckBrucellaAbortus1 + "'," +
                        "'flexCheckCRP1':'" + flexCheckCRP1 + "'," +
                        "'flexCheckRF1':'" + flexCheckRF1 + "'," +
                        "'flexCheckASO1':'" + flexCheckASO1 + "'," +
                        "'flexCheckToxoplasmosis1':'" + flexCheckToxoplasmosis1 + "'," +
                        "'flexCheckHBV1':'" + flexCheckHBV1 + "'," +
                        "'flexCheckHCV1':'" + flexCheckHCV1 + "'," +
                        "'flexCheckHIVAb1and2':'" + flexCheckHIV1 + "'," +
                        "'flexCheckCMV':'" + flexCheckCMV + "'," +
                        "'flexCheckEBVIgM':'" + flexCheckEBVIgM + "'," +
                        "'flexCheckRubella':'" + flexCheckRubella + "'," +
                        "'flexCheckAntiHAVIgMandIgG':'" + flexCheckAntiHAVIgMandIgG + "'," +
                        "'flexCheckSalmonellaParatyphiAH':'" + flexCheckSalmonellaParatyphiAH + "'," +
                        "'flexCheckSalmonellaParatyphiBH':'" + flexCheckSalmonellaParatyphiBH + "'," +
                        "'flexCheckSalmonellaTyphiOH':'" + flexCheckSalmonellaTyphiOH + "'," +
                        "'flexCheckRPRSyphillis':'" + flexCheckRPRSyphillis + "'," +
                        "'flexCheckTPHA1':'" + flexCheckTPHA1 + "'," +
                        "'flexCheckHIV1':'" + flexCheckHIV1 + "'," +
                        "'flexCheckHIV2':'" + flexCheckHIV2 + "'}",

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
                            datadisplay();
                            $('#staticBackdrop').modal('hide');
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

            // Delegate click events for edit and delete buttons to the table
            $("#datatable").on("click", ".edit-btn", function (event) {
                event.preventDefault(); // Prevent default behavior
                var row = $(this).closest("tr");
                var prescid = $(this).data("id");
                var search = parseInt($("#label2").html());

                $("#id111").val(prescid);



                $.ajax({
                    type: "POST",
                    url: "test_details.aspx/getlapprocessed",
                    data: JSON.stringify({ prescid: prescid, orderId: "" }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console.log(response);

                        // Uncheck all checkboxes and hide them before processing the new data
                        uncheckAndHideAllCheckboxes();

                        // Access the nested data
                        var data = response.d[0];
                        document.getElementById('medid').value = data.med_id;
                        // Iterate over each property in the data
                        for (var key in data) {
                            if (data.hasOwnProperty(key)) {
                                var checkboxId = getCheckboxId(key);
                                var isChecked = data[key] !== "not checked";

                                // Find the checkbox element by id
                                var checkbox = document.getElementById(checkboxId);
                                if (checkbox) {
                                    checkbox.checked = isChecked;

                                    // Show the checkbox if it is checked, otherwise hide it
                                    var checkboxLabel = checkbox.parentNode; // Assuming the label is the parent element
                                    if (isChecked) {
                                        checkboxLabel.style.display = "block";
                                    } else {
                                        checkboxLabel.style.display = "none";
                                    }
                                }
                            }
                        }
                    },
                    error: function (response) {
                        alert(response.responseText);
                    }
                });

                // Function to uncheck all checkboxes and hide them
                function uncheckAndHideAllCheckboxes() {
                    var checkboxes = document.querySelectorAll('input[type="checkbox"]');
                    checkboxes.forEach(function (checkbox) {
                        checkbox.checked = false;
                        var checkboxLabel = checkbox.parentNode; // Assuming the label is the parent element
                        checkboxLabel.style.display = "none";
                    });
                }


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
                        // Add more mappings as needed
                        default: return null;
                    }
                }

                document.getElementById('update').style.display = 'none';
                document.getElementById('submit').style.display = 'inline-block';


                // Show the modal
                $('#staticBackdrop').modal('show');
            });








            // Delegate click events for edit and delete buttons to the table
            $("#datatable").on("click", ".edit1-btn", function (event) {
                event.preventDefault(); // Prevent default behavior
                var row = $(this).closest("tr");
                var prescid = $(this).data("id");
                
                // Get orderId from button's data attribute (stored when table was built)
                var orderId = $(this).data("orderid") || "";
                
                // If not in button, try URL parameter (for navigation from lab_waiting_list)
                if (!orderId) {
                    var urlParams = new URLSearchParams(window.location.search);
                    orderId = urlParams.get('id') || "";
                }
                
                console.log("Edit button clicked - prescid:", prescid, "orderId:", orderId);

                $("#id111").val(prescid);

                var lab_result_id = row.find("td:nth-child(10)").text().trim();
                $("#id67").val(lab_result_id);
                
                // Get patient info from the table row
                var patientName = row.find("td:nth-child(2)").text();
                var patientSex = row.find("td:nth-child(3)").text();
                var patientPhone = row.find("td:nth-child(5)").text();

                // Display patient info in the modal
                $("#patientName").text(patientName);
                $("#patientSex").text(patientSex);
                $("#patientPhone").text(patientPhone);

                // Show loading state
                $('#orderedTestsList').show().html('<div class="alert alert-info"><i class="fa fa-spinner fa-spin"></i> Loading ordered tests...</div>');
                $('#orderedTestsInputs').show().html('<div class="alert alert-info"><i class="fa fa-spinner fa-spin"></i> Loading input fields...</div>');

                // Hide old checkbox sections
                $('#chk1').addClass('hidden').hide();
                
                // Show the modal immediately
                $('#staticBackdrop').modal('show');

                // Function to uncheck all checkboxes and hide them
                function uncheckAndHideAllCheckboxes() {
                    var checkboxes = document.querySelectorAll('input[type="checkbox"]');
                    checkboxes.forEach(function (checkbox) {
                        checkbox.checked = false;
                        var checkboxLabel = checkbox.parentNode; // Assuming the label is the parent element
                        checkboxLabel.style.display = "none";
                    });
                }


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
                        // Add more mappings as needed
                        default: return null;
                    }
                }

                // First AJAX call - Get ordered tests for THIS specific order
                var ajaxCall1 = $.ajax({
                    type: "POST",
                    url: "test_details.aspx/getlapprocessed",
                    data: JSON.stringify({ prescid: prescid, orderId: orderId }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console.log("getlapprocessed response:", response);

                        // Uncheck all checkboxes and hide them before processing the new data
                        uncheckAndHideAllCheckboxes();

                        // Access the nested data
                        if (response.d && response.d.length > 0) {
                            var data = response.d[0];
                            document.getElementById('medid').value = data.med_id;
                            // Iterate over each property in the data
                            for (var key in data) {
                                if (data.hasOwnProperty(key)) {
                                    var checkboxId = getCheckboxId(key);
                                    var isChecked = data[key] !== "not checked";

                                    // Find the checkbox element by id
                                    var checkbox = document.getElementById(checkboxId);
                                    if (checkbox) {
                                        checkbox.checked = isChecked;

                                        // Show the checkbox if it is checked, otherwise hide it
                                        var checkboxLabel = checkbox.parentNode; // Assuming the label is the parent element
                                        if (isChecked) {
                                            checkboxLabel.style.display = "block";
                                        } else {
                                            checkboxLabel.style.display = "none";
                                        }
                                    }
                                }
                            }
                        }
                    },
                    error: function (response) {
                        alert("Error loading ordered tests: " + response.responseText);
                    }
                });

                // Second AJAX call - Get result values for THIS specific order
                var ajaxCall2 = $.ajax({
                    url: 'test_details.aspx/editlabmedic',
                    data: JSON.stringify({ prescid: prescid, orderId: orderId }),
                    dataType: "json",
                    type: 'POST',
                    contentType: "application/json",
                    success: function (response) {
                        console.log("editlabmedic response:", response);

                        if (response.d && response.d.length > 0) {
                            var data = response.d[0];
                            console.log("Result data:", data);
                            
                            // Map the input fields to the server-side field names
                            var fieldMap = {
                                Hepatitis_C_virus_HCV1: data.Hepatitis_C_virus_HCV,
                                flexCheckGeneralUrineExamination1: data.General_urine_examination,
                                flexCheckProgesteroneFemale1: data.Progesterone_Female,
                                flexCheckAmylase1: data.Amylase,
                                flexCheckMagnesium1: data.Magnesium,
                                flexCheckPhosphorous1: data.Phosphorous,
                                flexCheckCalcium1: data.Calcium,
                                flexCheckChloride1: data.Chloride,
                                flexCheckPotassium1: data.Potassium,
                                flexCheckSodium1: data.Sodium,
                                flexCheckUricAcid1: data.Uric_acid,
                                flexCheckCreatinine1: data.Creatinine,
                                flexCheckUrea1: data.Urea,
                                flexCheckJGlobulin1: data.JGlobulin,
                                flexCheckAlbumin1: data.Albumin,
                                flexCheckTotalBilirubin1: data.Total_bilirubin,
                                flexCheckAlkalinePhosphatesALP1: data.Alkaline_phosphates_ALP,
                                flexCheckSGOTAST1: data.SGOT_AST,
                                flexCheckSGPTALT1: data.SGPT_ALT,
                                flexCheckLiverFunctionTest1: data.LiverFunctionTest,
                                flexCheckTriglycerides1: data.Triglycerides,
                                flexCheckTotalCholesterol1: data.Total_cholesterol,
                                flexCheckHemoglobinA1c1: data.Hemoglobin_A1c,
                                flexCheckHDL1: data.High_density_lipoprotein_HDL,
                                flexCheckLDL1: data.Low_density_lipoprotein_LDL,
                                flexCheckFSH1: data.Follicle_stimulating_hormone_FSH,
                                flexCheckEstradiol1: data.Estradiol,
                                flexCheckLH1: data.Luteinizing_hormone_LH,
                                flexCheckTestosteroneMale1: data.Testosterone_Male,
                                flexCheckProlactin1: data.Prolactin,
                                flexCheckSeminalFluidAnalysis1: data.Seminal_Fluid_Analysis_Male_B_HCG,
                                flexCheckBHCG1: data.Typhoid_hCG,
                                flexCheckUrineExamination1: data.Urine_examination,
                                flexCheckStoolExamination1: data.Stool_examination,
                                flexCheckHemoglobin1: data.Hemoglobin,
                                flexCheckMalaria1: data.Malaria,
                                flexCheckESR1: data.ESR,
                                flexCheckBloodGrouping1: data.Blood_grouping,
                                flexCheckBloodSugar1: data.Blood_sugar,
                                flexCheckCBC1: data.CBC,
                                flexCheckCrossMatching1: data.Cross_matching,
                                flexCheckTPHA1: data.TPHA,
                                flexCheckHIV1: data.Human_immune_deficiency_HIV,
                                flexCheckHBV1: data.Hepatitis_B_virus_HBV,
                                flexCheckBrucellaMelitensis1: data.Brucella_melitensis,
                                flexCheckBrucellaAbortus1: data.Brucella_abortus,
                                flexCheckCRP1: data.C_reactive_protein_CRP,
                                flexCheckRF1: data.Rheumatoid_factor_RF,
                                flexCheckASO1: data.Antistreptolysin_O_ASO,
                                flexCheckToxoplasmosis1: data.Toxoplasmosis,
                                flexCheckTyphoid1: data.Typhoid_hCG,
                                flexCheckHpyloriAntibody1: data.Hpylori_antibody,
                                flexCheckStoolOccultBlood1: data.Stool_occult_blood,
                                flexCheckGeneralStoolExamination1: data.General_stool_examination,
                                flexCheckThyroidProfile1: data.Thyroid_profile,
                                flexCheckT31: data.Triiodothyronine_T3,
                                flexCheckT41: data.Thyroxine_T4,
                                flexCheckTSH1: data.Thyroid_stimulating_hormone_TSH,
                                flexCheckSpermExamination1: data.Sperm_examination,
                                flexCheckVirginalSwab1: data.Virginal_swab_trichomonas_virginals,
                                flexCheckTrichomonasVirginals1: data.Virginal_swab_trichomonas_virginals,
                                flexCheckHCG1: data.Human_chorionic_gonadotropin_hCG,
                                flexCheckHpyloriAgStool1: data.Hpylori_Ag_stool,
                                flexCheckFastingBloodSugar1: data.Fasting_blood_sugar,
                                flexCheckDirectBilirubin1: data.Direct_bilirubin
                            };

                            // Populate the input fields
                            for (var key in fieldMap) {
                                if (fieldMap.hasOwnProperty(key)) {
                                    var value = fieldMap[key];
                                    if (value !== null && value !== undefined && value !== "") {
                                        $("#" + key).val(value);
                                        console.log("Setting " + key + " = " + value);
                                    }
                                }
                            }
                        } else {
                            console.warn("No result data found for prescid:", prescid);
                        }
                    },
                    error: function (response) {
                        alert("Error loading result values: " + response.responseText);
                    }
                });

                // Wait for BOTH AJAX calls to complete before showing modal
                $.when(ajaxCall1, ajaxCall2).done(function(result1, result2) {
                    var orderedTestsData = result1[0].d;  // Array with ordered tests
                    var resultValuesData = result2[0].d;  // Array with result values
                    
                    console.log("Edit button: Data loaded for order ID:", orderId);
                    console.log("Edit button: Ordered tests:", orderedTestsData);
                    console.log("Edit button: Result values:", resultValuesData);
                    
                    if (orderedTestsData.length > 0) {
                        var orderedTests = orderedTestsData[0];
                        var resultValues = resultValuesData.length > 0 ? resultValuesData[0] : {};
                        
                        // Use the shared function to build the ordered tests display
                        buildOrderedTestsDisplay(orderedTests, resultValues);
                    } else {
                        $('#orderedTestsList').html('<div class="alert alert-warning">No ordered tests found.</div>');
                        $('#orderedTestsInputs').html('');
                    }
                    
                    // Show Update button, hide Submit button
                    document.getElementById('update').style.display = 'inline-block';
                    document.getElementById('submit').style.display = 'none';
                    
                    console.log("Edit button: Modal populated with ordered tests and results");
                }).fail(function() {
                    alert("Error loading data. Please try again.");
                });
                
                // Use the shared buildOrderedTestsDisplay function
                function displayOrderedTestsAndInputsForEdit(orderedTests, resultValues) {
                    buildOrderedTestsDisplay(orderedTests, resultValues);
                }
                
                // Legacy function kept for compatibility
                function displayOrderedTestsAndInputsForEditOld(orderedTests, resultValues) {
                    var orderedTestsList = '';
                    var orderedTestsInputs = '';
                    var testCount = 0;
                    
                    // Test name mapping
                    var testNames = {
                        'Albumin': 'Albumin',
                        'Alkaline_phosphates_ALP': 'Alkaline Phosphatase (ALP)',
                        'Amylase': 'Amylase',
                        'Antistreptolysin_O_ASO': 'Antistreptolysin O (ASO)',
                        'Blood_grouping': 'Blood Grouping',
                        'Blood_sugar': 'Blood Sugar',
                        'Brucella_abortus': 'Brucella Abortus',
                        'Brucella_melitensis': 'Brucella Melitensis',
                        'CBC': 'CBC (Complete Blood Count)',
                        'C_reactive_protein_CRP': 'C-Reactive Protein (CRP)',
                        'Calcium': 'Calcium',
                        'Chloride': 'Chloride',
                        'Creatinine': 'Creatinine',
                        'Cross_matching': 'Cross Matching',
                        'Direct_bilirubin': 'Direct Bilirubin',
                        'ESR': 'ESR',
                        'Estradiol': 'Estradiol',
                        'Fasting_blood_sugar': 'Fasting Blood Sugar',
                        'Follicle_stimulating_hormone_FSH': 'FSH',
                        'General_stool_examination': 'General Stool Examination',
                        'General_urine_examination': 'General Urine Examination',
                        'Hemoglobin': 'Hemoglobin',
                        'Hemoglobin_A1c': 'Hemoglobin A1c',
                        'Hepatitis_B_virus_HBV': 'Hepatitis B (HBV)',
                        'Hepatitis_C_virus_HCV': 'Hepatitis C (HCV)',
                        'High_density_lipoprotein_HDL': 'HDL Cholesterol',
                        'Hpylori_Ag_stool': 'H. Pylori Ag (Stool)',
                        'Hpylori_antibody': 'H. Pylori Antibody',
                        'Human_chorionic_gonadotropin_hCG': 'hCG',
                        'Human_immune_deficiency_HIV': 'HIV',
                        'JGlobulin': 'J Globulin',
                        'Low_density_lipoprotein_LDL': 'LDL Cholesterol',
                        'Luteinizing_hormone_LH': 'LH',
                        'Magnesium': 'Magnesium',
                        'Malaria': 'Malaria',
                        'Phosphorous': 'Phosphorous',
                        'Potassium': 'Potassium',
                        'Progesterone_Female': 'Progesterone',
                        'Prolactin': 'Prolactin',
                        'Rheumatoid_factor_RF': 'Rheumatoid Factor (RF)',
                        'SGOT_AST': 'SGOT (AST)',
                        'SGPT_ALT': 'SGPT (ALT)',
                        'Seminal_Fluid_Analysis_Male_B_HCG': 'Seminal Fluid Analysis',
                        'Sodium': 'Sodium',
                        'Sperm_examination': 'Sperm Examination',
                        'Stool_examination': 'Stool Examination',
                        'Stool_occult_blood': 'Stool Occult Blood',
                        'TPHA': 'TPHA',
                        'Testosterone_Male': 'Testosterone',
                        'Thyroid_profile': 'Thyroid Profile',
                        'Thyroid_stimulating_hormone_TSH': 'TSH',
                        'Thyroxine_T4': 'T4',
                        'Total_bilirubin': 'Total Bilirubin',
                        'Total_cholesterol': 'Total Cholesterol',
                        'Toxoplasmosis': 'Toxoplasmosis',
                        'Triglycerides': 'Triglycerides',
                        'Triiodothyronine_T3': 'T3',
                        'Typhoid_hCG': 'Typhoid',
                        'Urea': 'Urea',
                        'Uric_acid': 'Uric Acid',
                        'Urine_examination': 'Urine Examination',
                        'Virginal_swab_trichomonas_virginals': 'Vaginal Swab',
                        'Troponin_I': 'Troponin I (Cardiac marker)',
                        'CK_MB': 'CK-MB (Creatine Kinase-MB)',
                        'aPTT': 'aPTT (Activated Partial Thromboplastin Time)',
                        'INR': 'INR (International Normalized Ratio)',
                        'D_Dimer': 'D-Dimer',
                        'Vitamin_D': 'Vitamin D',
                        'Vitamin_B12': 'Vitamin B12',
                        'Ferritin': 'Ferritin (Iron storage)',
                        'VDRL': 'VDRL (Syphilis test)',
                        'Dengue_Fever_IgG_IgM': 'Dengue Fever (IgG/IgM)',
                        'Gonorrhea_Ag': 'Gonorrhea Ag',
                        'AFP': 'AFP (Alpha-fetoprotein)',
                        'Total_PSA': 'Total PSA (Prostate-Specific Antigen)',
                        'AMH': 'AMH (Anti-Müllerian Hormone)'
                    };
                    
                    // Loop through ordered tests to find which tests were ordered
                    for (var key in orderedTests) {
                        if (orderedTests.hasOwnProperty(key) && testNames[key]) {
                            var value = orderedTests[key];
                            // Check if this test was ordered (value is not empty and not "not checked")
                            if (value && value !== '' && value !== 'not checked' && value !== 'Not checked') {
                                testCount++;
                                var testName = testNames[key];
                                var resultValue = resultValues[key] || '';
                                
                                // Add to ordered tests list
                                orderedTestsList += '<span class="badge badge-primary mr-2 mb-2">' + testCount + '. ' + testName + '</span>';
                                
                                // Add input field for this test
                                orderedTestsInputs += '<div class="col-md-6 mb-3">' +
                                    '<label for="input_' + key + '" class="form-label">' + testName + '</label>' +
                                    '<input type="text" class="form-control" id="input_' + key + '" name="' + key + '" value="' + resultValue + '" placeholder="Enter result">' +
                                    '</div>';
                            }
                        }
                    }
                    
                    // Display the ordered tests list
                    if (testCount > 0) {
                        $('#orderedTestsList').html(
                            '<div class="alert alert-info">' +
                            '<h5><i class="fa fa-list-ul"></i> Ordered Tests (' + testCount + ')</h5>' +
                            orderedTestsList +
                            '</div>'
                        );
                        $('#orderedTestsInputs').html('<div class="row">' + orderedTestsInputs + '</div>');
                    } else {
                        $('#orderedTestsList').html('<div class="alert alert-warning">No tests ordered for this patient.</div>');
                        $('#orderedTestsInputs').html('');
                    }
                }

            });





            // Delegate click events for the plus button (Add Task) to show lab test modal
            $("#datatable").on("click", ".edit-btn", function (event) {
                event.preventDefault(); // Prevent default behavior
                var row = $(this).closest("tr");
                var prescid = $(this).data("id");

                $("#id111").val(prescid);

                // Get patient info from the table row
                var patientName = row.find("td:nth-child(2)").text();
                var patientSex = row.find("td:nth-child(3)").text();
                var patientPhone = row.find("td:nth-child(5)").text();

                // Display patient info in the modal
                $("#patientName").text(patientName);
                $("#patientSex").text(patientSex);
                $("#patientPhone").text(patientPhone);

                // Show loading state in ordered tests sections and make them visible
                $('#orderedTestsList').show().html('<div class=\"alert alert-info\"><i class=\"fa fa-spinner fa-spin\"></i> Loading ordered tests...</div>');
                $('#orderedTestsInputs').show().html('<div class=\"alert alert-info\"><i class=\"fa fa-spinner fa-spin\"></i> Loading input fields...</div>');

                // Show the modal
                $('#staticBackdrop').modal('show');

                // Fetch ordered tests data
                $.ajax({
                    type: "POST",
                    url: "test_details.aspx/getlapprocessed",
                    data: JSON.stringify({ prescid: prescid, orderId: "" }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        console.log('Lab Test Data:', response);
                        console.log('First Record:', response.d[0]);

                        if (!response.d || !response.d.length) {
                            $('#orderedTestsList').html('<div class=\"alert alert-warning\"><i class=\"fa fa-exclamation-triangle\"></i> No lab tests ordered for this patient.</div>');
                            $('#orderedTestsInputs').html('<div class=\"alert alert-warning\">No tests to enter.</div>');
                            return;
                        }

                        // Access the data
                        var data = response.d[0];
                        document.getElementById('medid').value = data.med_id;

                        // Display ordered tests and create input fields
                        displayOrderedTestsAndInputs(data);
                    },
                    error: function (response) {
                        $('#orderedTestsList').html('<div class=\"alert alert-danger\"><i class=\"fa fa-times\"></i> Error loading tests.</div>');
                        $('#orderedTestsInputs').html('<div class=\"alert alert-danger\">Unable to load input fields.</div>');
                        console.error('Error:', response.responseText);
                    }
                });

                document.getElementById('submit').style.display = 'inline-block';
            });




            // Function to display ordered tests and create input fields dynamically
            function displayOrderedTestsAndInputs(data) {
                var orderedTests = [];
                var orderedTestsHTML = '';
                var inputFieldsHTML = '';

                // Test name mapping
                var testNameMap = {
                    'Low_density_lipoprotein_LDL': 'LDL Cholesterol',
                    'High_density_lipoprotein_HDL': 'HDL Cholesterol',
                    'Total_cholesterol': 'Total Cholesterol',
                    'Triglycerides': 'Triglycerides',
                    'SGPT_ALT': 'SGPT (ALT)',
                    'SGOT_AST': 'SGOT (AST)',
                    'Alkaline_phosphates_ALP': 'Alkaline Phosphatase (ALP)',
                    'Total_bilirubin': 'Total Bilirubin',
                    'Direct_bilirubin': 'Direct Bilirubin',
                    'Albumin': 'Albumin',
                    'JGlobulin': 'Globulin',
                    'Urea': 'Urea',
                    'Creatinine': 'Creatinine',
                    'Uric_acid': 'Uric Acid',
                    'Sodium': 'Sodium',
                    'Potassium': 'Potassium',
                    'Chloride': 'Chloride',
                    'Calcium': 'Calcium',
                    'Phosphorous': 'Phosphorous',
                    'Magnesium': 'Magnesium',
                    'Amylase': 'Amylase',
                    'Hemoglobin': 'Hemoglobin',
                    'Malaria': 'Malaria',
                    'ESR': 'ESR',
                    'Blood_grouping': 'Blood Grouping',
                    'Blood_sugar': 'Blood Sugar',
                    'CBC': 'CBC',
                    'Cross_matching': 'Cross Matching',
                    'TPHA': 'TPHA',
                    'Human_immune_deficiency_HIV': 'HIV Test',
                    'Hepatitis_B_virus_HBV': 'Hepatitis B (HBV)',
                    'Hepatitis_C_virus_HCV': 'Hepatitis C (HCV)',
                    'Brucella_melitensis': 'Brucella Melitensis',
                    'Brucella_abortus': 'Brucella Abortus',
                    'C_reactive_protein_CRP': 'C-Reactive Protein (CRP)',
                    'Rheumatoid_factor_RF': 'Rheumatoid Factor (RF)',
                    'Antistreptolysin_O_ASO': 'ASO',
                    'Toxoplasmosis': 'Toxoplasmosis',
                    'Typhoid_hCG': 'Typhoid',
                    'Hpylori_antibody': 'H. Pylori Antibody',
                    'Stool_occult_blood': 'Stool Occult Blood',
                    'General_stool_examination': 'General Stool Examination',
                    'Thyroid_profile': 'Thyroid Profile',
                    'Triiodothyronine_T3': 'T3',
                    'Thyroxine_T4': 'T4',
                    'Thyroid_stimulating_hormone_TSH': 'TSH',
                    'Progesterone_Female': 'Progesterone (Female)',
                    'Follicle_stimulating_hormone_FSH': 'FSH',
                    'Estradiol': 'Estradiol',
                    'Luteinizing_hormone_LH': 'LH',
                    'Testosterone_Male': 'Testosterone (Male)',
                    'Prolactin': 'Prolactin',
                    'Seminal_Fluid_Analysis_Male_B_HCG': 'Seminal Fluid Analysis',
                    'Urine_examination': 'Urine Examination',
                    'Stool_examination': 'Stool Examination',
                    'Sperm_examination': 'Sperm Examination',
                    'Virginal_swab_trichomonas_virginals': 'Vaginal Swab',
                    'Human_chorionic_gonadotropin_hCG': 'hCG',
                    'Hpylori_Ag_stool': 'H. Pylori Ag (Stool)',
                    'Fasting_blood_sugar': 'Fasting Blood Sugar',
                    'Hemoglobin_A1c': 'HbA1c',
                    'General_urine_examination': 'General Urine Examination'
                };

                // Exclude these system fields from being treated as tests
                var excludedFields = ['med_id', 'prescid', 'date_taken', 'is_reorder', 'reorder_reason',
                    'original_order_id', '__type', 'full_name', 'sex', 'location', 'phone',
                    'date_registered', 'doctortitle', 'patientid', 'doctorid', 'amount',
                    'dob', 'status', 'lab_result_id', 'charge_name', 'charge_amount',
                    'lab_charge_paid', 'unpaid_lab_charges', 'order_id', 'last_order_date',
                    'patient_status', 'xray_status', 'xray_result_id', 'xrayid'];

                // Find all ordered tests (where value is not empty and not "not checked")
                for (var key in data) {
                    if (data.hasOwnProperty(key) &&
                        testNameMap[key] &&
                        excludedFields.indexOf(key) === -1) {

                        var value = data[key];

                        // Check if test is ordered: value should be "on", "checked", or any non-empty string except "not checked"
                        if (value &&
                            value !== "" &&
                            value !== "not checked" &&
                            value.toString().trim() !== "") {

                            orderedTests.push({
                                key: key,
                                name: testNameMap[key],
                                value: value
                            });
                        }
                    }
                }

                // Debug: Log what we found
                console.log('Ordered Tests Found:', orderedTests.length);
                console.log('Ordered Tests:', orderedTests);

                // Create ordered tests display
                if (orderedTests.length > 0) {
                    orderedTests.forEach(function (test) {
                        orderedTestsHTML += '<span class=\"ordered-test-badge\">' + test.name + '</span>';
                    });

                    // Create input fields for ordered tests (2 column layout)
                    orderedTests.forEach(function (test, index) {
                        // Convert database column name to flexCheck format (remove underscores, capitalize)
                        var fieldId = 'flexCheck' + test.key.split('_').map(function (word) {
                            return word.charAt(0).toUpperCase() + word.slice(1);
                        }).join('') + '1';

                        inputFieldsHTML += '<div class=\"col-md-6\">' +
                            '<div class=\"test-input-group\">' +
                            '<label for=\"' + fieldId + '\"><i class=\"fa fa-flask text-info\"></i> ' + test.name + '</label>' +
                            '<input type=\"text\" class=\"form-control\" id=\"' + fieldId + '\" ' +
                            'data-test-key=\"' + test.key + '\" placeholder=\"Enter result value\">' +
                            '</div>' +
                            '</div>';
                    });
                } else {
                    orderedTestsHTML = '<p class=\"mb-0 text-warning\"><i class=\"fa fa-info-circle\"></i> No tests ordered for this patient.</p>';
                    inputFieldsHTML = '<div class=\"alert alert-warning\"><i class=\"fa fa-exclamation-triangle\"></i> <strong>No tests to enter.</strong><br>Please check with the doctor if tests need to be ordered.</div>';
                }

                // Update the display
                $('#orderedTestsList').html(orderedTestsHTML);
                $('#orderedTestsInputs').html(inputFieldsHTML);

                console.log('Display updated. Badges:', orderedTests.length, 'Input fields:', orderedTests.length);
            }

            function datadisplay() {
                $.ajax({
                    url: 'lab_waiting_list.aspx/pendlap',
                    dataType: "json",
                    type: 'POST',
                    contentType: "application/json",
                    success: function (response) {
                        console.log(response);

                        $("#datatable tbody").empty();
                        // Function to determine button style based on status
                        function getStatusButton(status) {
                            var color;
                            // Handle both old and new status values
                            switch (status.toLowerCase()) {
                                case 'waiting':
                                    color = 'red';
                                    break;
                                case 'pending-lap':
                                case 'pending':
                                    color = 'orange';
                                    break;
                                case 'lap-processed':
                                case 'completed':
                                    color = 'green';
                                    break;
                                default:
                                    color = 'initial';
                            }
                            return "<button style='background-color:" + color + "; cursor:default; color:white; border:none; padding:5px 10px; border-radius:30%;' disabled>" + status + "</button>";
                        }

                        for (var i = 0; i < response.d.length; i++) {
                            var statusButton = getStatusButton(response.d[i].status);
                            var status = response.d[i].status.toLowerCase(); // Normalize to lowercase

                            // Build action buttons based on status
                            var actionButtons = "";
                            
                            // Show Plus button (Add Task) only if NOT completed
                            if (status !== 'lap-processed' && status !== 'completed') {
                                actionButtons += "<button type='button' class='edit-btn btn btn-link btn-primary btn-lg' data-id='" + response.d[i].prescid + "' data-bs-toggle='tooltip' title='Add Test Results'><i class='fa fa-plus'></i></button>";
                            }
                            
                            // Show Edit button only if completed (has results to edit)
                            if (status === 'lap-processed' || status === 'completed') {
                                actionButtons += "<button type='button' class='edit1-btn btn btn-link btn-primary btn-lg' data-id='" + response.d[i].prescid + "' data-orderid='" + response.d[i].order_id + "' data-bs-toggle='tooltip' title='Edit Results'><i class='fa fa-edit'></i></button>";
                            }

                            $("#datatable tbody").append(
                                "<tr>"
                                + "<td style='display:none'>" + response.d[i].doctorid + "</td>"
                                + "<td>" + response.d[i].full_name + "</td>"
                                + "<td>" + response.d[i].sex + "</td>"
                                + "<td>" + response.d[i].location + "</td>"
                                + "<td>" + response.d[i].phone + "</td>"
                                + "<td>" + response.d[i].amount + "</td>"
                                + "<td>" + response.d[i].dob + "</td>"
                                + "<td>" + response.d[i].date_registered + "</td>"
                                + "<td style='display:none'>" + response.d[i].prescid + "</td>"
                                + "<td style='display:none'>" + response.d[i].lab_result_id + "</td>"
                                + "<td>" + statusButton + "</td>"
                                + "<td>"
                                + actionButtons
                                + "</td>"
                                + "</tr>"
                            );
                        }
                    },
                    error: function (response) {
                        alert(response.responseText);
                    }
                });
            }


            datadisplay();


        </script>

        <script>
            (function () {
                document.addEventListener('DOMContentLoaded', function () {
                    try {
                        var params = new URLSearchParams(window.location.search);
                        var presetFromQuery = params.get('prescid');
                        var presetFromStorage = sessionStorage.getItem('labEditPrescid');
                        var targetPrescid = presetFromQuery || presetFromStorage;
                        if (targetPrescid) {
                            sessionStorage.removeItem('labEditPrescid');
                            setTimeout(function () {
                                openLabResultModalFromPrescid(targetPrescid);
                            }, 600);
                        }
                    } catch (err) {
                        console.error(err);
                    }
                });
            })();

            function openLabResultModalFromPrescid(prescid) {
                if (!prescid) {
                    return;
                }

                $("#id111").val(prescid);

                $.ajax({
                    type: "POST",
                    url: "test_details.aspx/getlapprocessed",
                    data: JSON.stringify({ prescid: prescid, orderId: "" }),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (response) {
                        if (!response.d || !response.d.length) {
                            Swal.fire('Info', 'No lab results were found for the selected patient.', 'info');
                            return;
                        }

                        resetLabCheckboxes();

                        var data = response.d[0];
                        if (data.med_id) {
                            document.getElementById('medid').value = data.med_id;
                        }

                        for (var key in data) {
                            if (!data.hasOwnProperty(key)) {
                                continue;
                            }

                            var checkboxId = mapLabDataKeyToCheckboxId(key);
                            if (!checkboxId) {
                                continue;
                            }

                            var checkbox = document.getElementById(checkboxId);
                            if (checkbox) {
                                var isChecked = data[key] !== "not checked";
                                checkbox.checked = isChecked;
                                var checkboxLabel = checkbox.parentNode;
                                if (checkboxLabel) {
                                    checkboxLabel.style.display = isChecked ? "block" : "none";
                                }
                            }
                        }

                        document.getElementById('update').style.display = 'inline-block';
                        document.getElementById('submit').style.display = 'none';
                        $('#staticBackdrop').modal('show');
                    },
                    error: function (response) {
                        Swal.fire('Error', response.responseText || 'Unable to load lab results.', 'error');
                    }
                });
            }

            function resetLabCheckboxes() {
                var checkboxes = document.querySelectorAll('input[type="checkbox"]');
                checkboxes.forEach(function (checkbox) {
                    checkbox.checked = false;
                    var checkboxLabel = checkbox.parentNode;
                    if (checkboxLabel) {
                        checkboxLabel.style.display = "none";
                    }
                });
            }

            function mapLabDataKeyToCheckboxId(dataKey) {
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
                    default: return null;
                }
            }
        </script>
    </asp:Content>