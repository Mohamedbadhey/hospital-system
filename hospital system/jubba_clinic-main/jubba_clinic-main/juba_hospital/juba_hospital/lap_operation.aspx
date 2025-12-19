<%@ Page Title="" Language="C#" MasterPageFile="~/doctor.Master" AutoEventWireup="true" CodeBehind="lap_operation.aspx.cs" Inherits="juba_hospital.lap_operation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        

            <!-- Modal -->
<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
  <div class="modal-dialog modal-xl">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="staticBackdropLabel1">Lab Tests</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
            <input style="display:none" id="id111" />
                   <input style="display:none"  id="medid" />
          
          <div class="row">
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
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckLDL">
    <label class="form-check-label" for="flexCheckLDL">
        Low-density lipoprotein (LDL)
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckHDL">
    <label class="form-check-label" for="flexCheckHDL">
        High-density lipoprotein (HDL)
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckTotalCholesterol">
    <label class="form-check-label" for="flexCheckTotalCholesterol">
        Total cholesterol
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckTriglycerides">
    <label class="form-check-label" for="flexCheckTriglycerides">
        Triglycerides
    </label>
</div>  
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckSodium">
        <label class="form-check-label" for="flexCheckSodium">
            Sodium
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckPotassium">
        <label class="form-check-label" for="flexCheckPotassium">
            Potassium
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckChloride">
        <label class="form-check-label" for="flexCheckChloride">
            Chloride
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckCalcium">
        <label class="form-check-label" for="flexCheckCalcium">
            Calcium
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckPhosphorous">
        <label class="form-check-label" for="flexCheckPhosphorous">
            Phosphorous
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckMagnesium">
        <label class="form-check-label" for="flexCheckMagnesium">
            Magnesium
        </label>
    </div>
                <div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckCreatinine">
    <label class="form-check-label" for="flexCheckCreatinine">
        Creatinine
    </label>
</div>
   
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckAmylase">
        <label class="form-check-label" for="flexCheckAmylase">
            Amylase
        </label>
    </div>
                
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckProgesteroneFemale">
        <label class="form-check-label" for="flexCheckProgesteroneFemale">
            Progesterone (Female)
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckFSH">
        <label class="form-check-label" for="flexCheckFSH">
            Follicle stimulating hormone (FSH)
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckEstradiol">
        <label class="form-check-label" for="flexCheckEstradiol">
            Estradiol
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckLH">
        <label class="form-check-label" for="flexCheckLH">
            Luteinizing hormone (LH)
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckTestosteroneMale">
        <label class="form-check-label" for="flexCheckTestosteroneMale">
            Testosterone (Male)
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckProlactin">
        <label class="form-check-label" for="flexCheckProlactin">
            Prolactin
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckSeminalFluidAnalysis">
        <label class="form-check-label" for="flexCheckSeminalFluidAnalysis">
            Seminal Fluid Analysis (Male)
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckBHCG">
        <label class="form-check-label" for="flexCheckBHCG">
            B-HCG
        </label>
    </div>
 
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckUrineExamination">
        <label class="form-check-label" for="flexCheckUrineExamination">
            Urine examination
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckStoolExamination">
        <label class="form-check-label" for="flexCheckStoolExamination">
            Stool examination
        </label>
    </div>

    </div>



        <div class="col-4">
                             

<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckUricAcid">
    <label class="form-check-label" for="flexCheckUricAcid">
        Uric acid
    </label>
</div>
    
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckBrucellaAbortus">
        <label class="form-check-label" for="flexCheckBrucellaAbortus">
            Brucella abortus
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckCRP">
        <label class="form-check-label" for="flexCheckCRP">
            C-reactive protein (CRP)
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckRF">
        <label class="form-check-label" for="flexCheckRF">
            Rheumatoid factor (RF)
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckASO">
        <label class="form-check-label" for="flexCheckASO">
            Antistreptolysin O (ASO)
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckToxoplasmosis">
        <label class="form-check-label" for="flexCheckToxoplasmosis">
            Toxoplasmosis
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckTyphoid">
        <label class="form-check-label" for="flexCheckTyphoid">
            Typhoid (hCG)
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckHpyloriAntibody">
        <label class="form-check-label" for="flexCheckHpyloriAntibody">
            H.pylori antibody
        </label>
    </div>
  
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckStoolOccultBlood">
        <label class="form-check-label" for="flexCheckStoolOccultBlood">
            Stool occult blood
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckGeneralStoolExamination">
        <label class="form-check-label" for="flexCheckGeneralStoolExamination">
            General stool examination
        </label>
    </div>
  
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckThyroidProfile">
        <label class="form-check-label" for="flexCheckThyroidProfile">
            Thyroid profile
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckT3">
        <label class="form-check-label" for="flexCheckT3">
            Triiodothyronine (T3)
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckT4">
        <label class="form-check-label" for="flexCheckT4">
            Thyroxine (T4)
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckTSH">
        <label class="form-check-label" for="flexCheckTSH">
            Thyroid stimulating hormone (TSH)
        </label>
    </div>
  

    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckSpermExamination">
        <label class="form-check-label" for="flexCheckSpermExamination">
            Sperm examination
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckVirginalSwab">
        <label class="form-check-label" for="flexCheckVirginalSwab">
            Virginal swab
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckTrichomonasVirginals">
        <label class="form-check-label" for="flexCheckTrichomonasVirginals">
            Trichomonas virginals
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckHCG">
        <label class="form-check-label" for="flexCheckHCG">
            Human chorionic gonadotropin (hCG)
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckHpyloriAgStool">
        <label class="form-check-label" for="flexCheckHpyloriAgStool">
            H.pylori Ag (stool)
        </label>
    </div>
   
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckFastingBloodSugar">
        <label class="form-check-label" for="flexCheckFastingBloodSugar">
            Fasting blood sugar
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckHemoglobinA1c">
        <label class="form-check-label" for="flexCheckHemoglobinA1c">
            Hemoglobin A1c
        </label>
    </div>
    <div class="form-check">
        <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckGeneralUrineExamination">
        <label class="form-check-label" for="flexCheckGeneralUrineExamination">
            General urine examination
        </label>
    </div>
    </div>

       <div class="col-4">

                                          
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckLiverFunctionTest">
    <label class="form-check-label" for="flexCheckLiverFunctionTest">
        Liver function test
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckSGPTALT">
    <label class="form-check-label" for="flexCheckSGPTALT">
        SGPT (ALT)
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckSGOTAST">
    <label class="form-check-label" for="flexCheckSGOTAST">
        SGOT (AST)
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckAlkalinePhosphatesALP">
    <label class="form-check-label" for="flexCheckAlkalinePhosphatesALP">
        Alkaline phosphates (ALP)
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckTotalBilirubin">
    <label class="form-check-label" for="flexCheckTotalBilirubin">
        Total bilirubin
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckDirectBilirubin">
    <label class="form-check-label" for="flexCheckDirectBilirubin">
        Direct bilirubin
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckAlbumin">
    <label class="form-check-label" for="flexCheckAlbumin">
        Albumin
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckJGlobulin">
    <label class="form-check-label" for="flexCheckJGlobulin">
        JGlobulin
    </label>
</div>
   
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckUrea">
    <label class="form-check-label" for="flexCheckUrea">
        Urea
    </label>
</div>

                       <div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckHemoglobin">
    <label class="form-check-label" for="flexCheckHemoglobin">
        Hemoglobin
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckMalaria">
    <label class="form-check-label" for="flexCheckMalaria">
        Malaria
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckESR">
    <label class="form-check-label" for="flexCheckESR">
        ESR
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckBloodGrouping">
    <label class="form-check-label" for="flexCheckBloodGrouping">
        Blood grouping
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckBloodSugar">
    <label class="form-check-label" for="flexCheckBloodSugar">
        Blood sugar
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckCBC">
    <label class="form-check-label" for="flexCheckCBC">
        CBC
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckCrossMatching">
    <label class="form-check-label" for="flexCheckCrossMatching">
        Cross matching
    </label>
</div>

<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckTPHA">
    <label class="form-check-label" for="flexCheckTPHA">
        TPHA
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckHIV">
    <label class="form-check-label" for="flexCheckHIV">
        Human immune deficiency (HIV)
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckHBV">
    <label class="form-check-label" for="flexCheckHBV">
        Hepatitis B virus (HBV)
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckHCV">
    <label class="form-check-label" for="flexCheckHCV">
        Hepatitis C virus (HCV)
    </label>
</div>
<div class="form-check">
    <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckBrucellaMelitensis">
    <label class="form-check-label" for="flexCheckBrucellaMelitensis">
        Brucella melitensis
    </label>
</div>
       </div>

       <div class="col-4">
           <!-- Cardiac Markers -->
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckTroponinI">
               <label class="form-check-label" for="flexCheckTroponinI">
                   Troponin I (Cardiac marker)
               </label>
           </div>
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckCKMB">
               <label class="form-check-label" for="flexCheckCKMB">
                   CK-MB (Creatine Kinase-MB)
               </label>
           </div>
           
           <!-- Coagulation Tests -->
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckAPTT">
               <label class="form-check-label" for="flexCheckAPTT">
                   aPTT (Activated Partial Thromboplastin Time)
               </label>
           </div>
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckINR">
               <label class="form-check-label" for="flexCheckINR">
                   INR (International Normalized Ratio)
               </label>
           </div>
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckDDimer">
               <label class="form-check-label" for="flexCheckDDimer">
                   D-Dimer
               </label>
           </div>
           
           <!-- Vitamins and Minerals -->
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckVitaminD">
               <label class="form-check-label" for="flexCheckVitaminD">
                   Vitamin D
               </label>
           </div>
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckVitaminB12">
               <label class="form-check-label" for="flexCheckVitaminB12">
                   Vitamin B12
               </label>
           </div>
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckFerritin">
               <label class="form-check-label" for="flexCheckFerritin">
                   Ferritin (Iron storage)
               </label>
           </div>
           
           <!-- Additional Infectious Disease Tests -->
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckVDRL">
               <label class="form-check-label" for="flexCheckVDRL">
                   VDRL (Syphilis test)
               </label>
           </div>
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckDengueFever">
               <label class="form-check-label" for="flexCheckDengueFever">
                   Dengue Fever (IgG/IgM)
               </label>
           </div>
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckGonorrheaAg">
               <label class="form-check-label" for="flexCheckGonorrheaAg">
                   Gonorrhea Ag
               </label>
           </div>
           
           <!-- Tumor Markers -->
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckAFP">
               <label class="form-check-label" for="flexCheckAFP">
                   AFP (Alpha-fetoprotein)
               </label>
           </div>
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckTotalPSA">
               <label class="form-check-label" for="flexCheckTotalPSA">
                   Total PSA (Prostate-Specific Antigen)
               </label>
           </div>
           
           <!-- Fertility Test -->
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckAMH">
               <label class="form-check-label" for="flexCheckAMH">
                   AMH (Anti-Müllerian Hormone)
               </label>
           </div>

           <!-- New Tests Added -->
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckElectrolyteTest">
               <label class="form-check-label" for="flexCheckElectrolyteTest">
                   Electrolyte Test
               </label>
           </div>
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckCRPTiter">
               <label class="form-check-label" for="flexCheckCRPTiter">
                   CRP Titer
               </label>
           </div>
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckUltra">
               <label class="form-check-label" for="flexCheckUltra">
                   Ultra
               </label>
           </div>
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckTyphoidIgG">
               <label class="form-check-label" for="flexCheckTyphoidIgG">
                   Typhoid IgG
               </label>
           </div>
           <div class="form-check">
               <input class="custom-control-input custom-checkbox" type="checkbox" value="" id="flexCheckTyphoidAg">
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
        <button type="button" onclick="callAjaxFunction()" class="btn btn-primary">Update</button>
      </div>
    </div>
  </div>
</div>
         <div class="col-md-12">
                <div class="card">
                  <div class="card-header">
                    <div class="d-flex align-items-center">
                      <h4 class="card-title"> Pending Lap Operation</h4>
                   
                    </div>
                  </div>
                  <div class="card-body">
            

                    <div class="table-responsive">
                      <table
                        id="datatable"
                        class="display table table-striped table-hover"
                      >
                        <thead>
                          <tr>
                             <th>Name</th>
 <th>Sex</th>
 <th>Location</th>
 <th>Phone</th>
                                        <th>Amount</th>
                               <th>D.O.B</th>
 <th>Date Registered</th>
 <th>Doctor Title</th>
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
 <th>Doctor Title</th>
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
            <script src="assets/js/plugin/datatables/datatables.min.js"></script>
      <script src="Scripts/jquery-3.4.1.min.js"></script>
    <script>

        function callAjaxFunction() {
      
            var flexCheckHDL, flexCheckLDL, flexCheckTotalCholesterol, flexCheckTriglycerides, flexCheckLiverFunctionTest, flexCheckSGPTALT, flexCheckSGOTAST, flexCheckAlkalinePhosphatesALP, flexCheckTotalBilirubin, flexCheckDirectBilirubin, flexCheckAlbumin, flexCheckJGlobulin, flexCheckUrea, flexCheckCreatinine, flexCheckUricAcid, flexCheckSodium, flexCheckPotassium, flexCheckChloride, flexCheckCalcium, flexCheckPhosphorous, flexCheckMagnesium, flexCheckAmylase, flexCheckProgesteroneFemale, flexCheckFSH, flexCheckEstradiol, flexCheckLH, flexCheckTestosteroneMale, flexCheckProlactin, flexCheckSeminalFluidAnalysis, flexCheckBHCG, flexCheckUrineExamination, flexCheckStoolExamination, flexCheckHemoglobin, flexCheckMalaria, flexCheckESR, flexCheckBloodGrouping, flexCheckBloodSugar, flexCheckCBC, flexCheckCrossMatching, flexCheckTPHA, flexCheckHIV, flexCheckHBV, flexCheckHCV, flexCheckBrucellaMelitensis, flexCheckBrucellaAbortus, flexCheckCRP, flexCheckRF, flexCheckASO, flexCheckToxoplasmosis, flexCheckTyphoid, flexCheckHpyloriAntibody, flexCheckStoolOccultBlood, flexCheckGeneralStoolExamination, flexCheckThyroidProfile, flexCheckT3, flexCheckT4, flexCheckTSH, flexCheckSpermExamination, flexCheckVirginalSwab, flexCheckTrichomonasVirginals, flexCheckHCG, flexCheckHpyloriAgStool, flexCheckFastingBloodSugar, flexCheckHemoglobinA1c, flexCheckGeneralUrineExamination, flexCheckTroponinI, flexCheckCKMB, flexCheckAPTT, flexCheckINR, flexCheckDDimer, flexCheckVitaminD, flexCheckVitaminB12, flexCheckFerritin, flexCheckVDRL, flexCheckDengueFever, flexCheckGonorrheaAg, flexCheckAFP, flexCheckTotalPSA, flexCheckAMH;
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

            // New tests - Cardiac Markers
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

            // Coagulation Tests
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

            // Vitamins and Minerals
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

            // Additional Infectious Disease Tests
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

            // Tumor Markers
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

            // Fertility Test
            flexCheckAMH = $('#flexCheckAMH');
            if (flexCheckAMH.prop('checked')) {
                flexCheckAMH = flexCheckAMH.next('label').text().trim();
            } else {
                flexCheckAMH = 'not checked';
            }

            // Example for flexCheckSpermExamination
            flexCheckSpermExamination = $('#flexCheckSpermExamination');
            if (flexCheckSpermExamination.prop('checked')) {
                flexCheckSpermExamination = flexCheckSpermExamination.next('label').text().trim();
            } else {
                flexCheckSpermExamination = 'not checked';
            }

            // Example for flexCheckVirginalSwab
            flexCheckVirginalSwab = $('#flexCheckVirginalSwab');
            if (flexCheckVirginalSwab.prop('checked')) {
                flexCheckVirginalSwab = flexCheckVirginalSwab.next('label').text().trim();
            } else {
                flexCheckVirginalSwab = 'not checked';
            }

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


            // Example for flexCheckPAPSmear
            flexCheckTyphoid = $('#flexCheckTyphoid');
            if (flexCheckTyphoid.prop('checked')) {
                flexCheckTyphoid = flexCheckTyphoid.next('label').text().trim();
            } else {
                flexCheckTyphoid = 'not checked';
            }



          

            var id = $("#medid").val();
     

            $.ajax({
                url: 'lap_operation.aspx/updateLabTest',
                data: "{'id':'" + id + "','flexCheckDirectBilirubin':'" + flexCheckDirectBilirubin + "','flexCheckGeneralUrineExamination':'" + flexCheckGeneralUrineExamination + "','flexCheckProgesteroneFemale':'" + flexCheckProgesteroneFemale + "','flexCheckAmylase':'" + flexCheckAmylase + "','flexCheckMagnesium':'" + flexCheckMagnesium + "','flexCheckPhosphorous':'" + flexCheckPhosphorous + "','flexCheckCalcium':'" + flexCheckCalcium + "','flexCheckChloride':'" + flexCheckChloride + "','flexCheckPotassium':'" + flexCheckPotassium + "','flexCheckSodium':'" + flexCheckSodium + "','flexCheckUricAcid':'" + flexCheckUricAcid + "','flexCheckCreatinine':'" + flexCheckCreatinine + "','flexCheckUrea':'" + flexCheckUrea + "','flexCheckJGlobulin':'" + flexCheckJGlobulin + "','flexCheckAlbumin':'" + flexCheckAlbumin + "','flexCheckTotalBilirubin':'" + flexCheckTotalBilirubin + "','flexCheckAlkalinePhosphatesALP':'" + flexCheckAlkalinePhosphatesALP + "','flexCheckSGOTAST':'" + flexCheckSGOTAST + "','flexCheckSGPTALT':'" + flexCheckSGPTALT + "','flexCheckLiverFunctionTest':'" + flexCheckLiverFunctionTest + "','flexCheckTriglycerides':'" + flexCheckTriglycerides + "','flexCheckTotalCholesterol':'" + flexCheckTotalCholesterol + "','flexCheckHemoglobinA1c':'" + flexCheckHemoglobinA1c + "','flexCheckHDL':'" + flexCheckHDL + "','flexCheckLDL':'" + flexCheckLDL + "','flexCheckFSH':'" + flexCheckFSH + "','flexCheckEstradiol':'" + flexCheckEstradiol + "','flexCheckLH':'" + flexCheckLH + "','flexCheckTestosteroneMale':'" + flexCheckTestosteroneMale + "','flexCheckProlactin':'" + flexCheckProlactin + "','flexCheckSeminalFluidAnalysis':'" + flexCheckSeminalFluidAnalysis + "','flexCheckBHCG':'" + flexCheckBHCG + "','flexCheckUrineExamination':'" + flexCheckUrineExamination + "','flexCheckStoolExamination':'" + flexCheckStoolExamination + "','flexCheckHemoglobin':'" + flexCheckHemoglobin + "','flexCheckMalaria':'" + flexCheckMalaria + "','flexCheckESR':'" + flexCheckESR + "','flexCheckBloodGrouping':'" + flexCheckBloodGrouping + "','flexCheckBloodSugar':'" + flexCheckBloodSugar + "','flexCheckCBC':'" + flexCheckCBC + "','flexCheckCrossMatching':'" + flexCheckCrossMatching + "','flexCheckTPHA':'" + flexCheckTPHA + "','flexCheckHIV':'" + flexCheckHIV + "','flexCheckHBV':'" + flexCheckHBV + "','flexCheckHCV':'" + flexCheckHCV + "','flexCheckBrucellaMelitensis':'" + flexCheckBrucellaMelitensis + "','flexCheckBrucellaAbortus':'" + flexCheckBrucellaAbortus + "','flexCheckCRP':'" + flexCheckCRP + "','flexCheckRF':'" + flexCheckRF + "','flexCheckASO':'" + flexCheckASO + "','flexCheckToxoplasmosis':'" + flexCheckToxoplasmosis + "','flexCheckTyphoid':'" + flexCheckTyphoid + "','flexCheckHpyloriAntibody':'" + flexCheckHpyloriAntibody + "','flexCheckStoolOccultBlood':'" + flexCheckStoolOccultBlood + "','flexCheckGeneralStoolExamination':'" + flexCheckGeneralStoolExamination + "','flexCheckThyroidProfile':'" + flexCheckThyroidProfile + "','flexCheckT3':'" + flexCheckT3 + "','flexCheckT4':'" + flexCheckT4 + "','flexCheckTSH':'" + flexCheckTSH + "','flexCheckSpermExamination':'" + flexCheckSpermExamination + "','flexCheckVirginalSwab':'" + flexCheckVirginalSwab + "','flexCheckTrichomonasVirginals':'" + flexCheckTrichomonasVirginals + "','flexCheckHCG':'" + flexCheckHCG + "','flexCheckHpyloriAgStool':'" + flexCheckHpyloriAgStool + "','flexCheckFastingBloodSugar':'" + flexCheckFastingBloodSugar + "','flexCheckTroponinI':'" + flexCheckTroponinI + "','flexCheckCKMB':'" + flexCheckCKMB + "','flexCheckAPTT':'" + flexCheckAPTT + "','flexCheckINR':'" + flexCheckINR + "','flexCheckDDimer':'" + flexCheckDDimer + "','flexCheckVitaminD':'" + flexCheckVitaminD + "','flexCheckVitaminB12':'" + flexCheckVitaminB12 + "','flexCheckFerritin':'" + flexCheckFerritin + "','flexCheckVDRL':'" + flexCheckVDRL + "','flexCheckDengueFever':'" + flexCheckDengueFever + "','flexCheckGonorrheaAg':'" + flexCheckGonorrheaAg + "','flexCheckAFP':'" + flexCheckAFP + "','flexCheckTotalPSA':'" + flexCheckTotalPSA + "','flexCheckAMH':'" + flexCheckAMH + "' }",
                contentType: 'application/json; charset=utf-8',

                dataType: 'json',
                type: 'POST',
                success: function (response) {
                    console.log(response);
             
              
                        $('#staticBackdrop').modal('hide');
                    
                    Swal.fire(
                        'Successfully Updated !',
                        'You updated a new Patient!',
                        'success'
                    )
          


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
                    // New test mappings
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
                    // Add more mappings as needed
                    default: return null;
                }
            }



            // Show the modal
            $('#staticBackdrop').modal('show');
        });


        // Delegate click events for edit and delete buttons to the table
        $("#datatable").on("click", ".edit-btn", function (event) {
            event.preventDefault(); // Prevent default behavior
            var row = $(this).closest("tr");
            var doctorid = $(this).data("id");
            document.getElementById("id1").value = doctorid;
            var name = row.find("td:nth-child(2)").text(); 
            var sex = row.find("td:nth-child(3)").text(); 
            var location = row.find("td:nth-child(4)").text();
            var phone = row.find("td:nth-child(5)").text();
            var amount = row.find("td:nth-child(6)").text();
            var dob = row.find("td:nth-child(7)").text();
            var patientid = row.find("td:nth-child(10)").text();
            $("#name").val(name);
            $("#sex").val(sex);
            $("#location").val(location);
            $("#phone").val(phone);
            $("#amount").val(amount);
            $("#dob").val(dob);
            $("#pid").val(patientid);
       
            $.ajax({
                type: "POST",
                url: "Patient_Operation.aspx/getdoctors",
                data: JSON.stringify({ doctorid: doctorid }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    console.log(response);

                    var doctorSelect = $("[id*=doctor]"); // Assuming you have a select element for doctors

                    doctorSelect.empty(); // Clear existing options for doctors

                    // Populate the doctor select element with all doctors
                    $.each(response.d.doctorList, function () {
                        doctorSelect.append($("<option></option>").val(this.Value).html(this.Text));
                    });

                    // Set the selected doctor
                    if (response.d.selectedDoctorId) {
                        doctorSelect.val(response.d.selectedDoctorId);
                    }
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });

            // Show the modal
            $('#editmodal').modal('show');
        });
        $(document).ready(function () {
            $("#datatable").DataTable({});
        });



        $(document).ready(function () {






            var search = parseInt($("#label2").html());

            $.ajax({
                url: 'lap_processed.aspx/lapprocessed',
                data: "{'search':'" + search + "'}",
                dataType: "json",
                type: 'POST',
                contentType: "application/json",
                success: function (response) {
                    console.log(response);

                    $("#datatable tbody").empty();

                    for (var i = 0; i < response.d.length; i++) {
                        $("#datatable tbody").append(
                            "<tr style='cursor:pointer' onclick='passValue(this)'>"
                            + "<td style='display:none'>" + response.d[i].doctorid + "</td>"
                            + "<td>" + response.d[i].full_name + "</td>"
                            + "<td>" + response.d[i].sex + "</td>"
                            + "<td>" + response.d[i].location + "</td>"
                            + "<td>" + response.d[i].phone + "</td>"
                            + "<td>" + response.d[i].amount + "</td>"
                            + "<td>" + response.d[i].dob + "</td>"
                            + "<td>" + response.d[i].date_registered + "</td>"
                            + "<td style='display:none'>" + response.d[i].prescid + "</td>"
                            + "<td><button style='background-color:red; curser:off;   color:white; border:none; padding:5px 10px;  border-radius:30%;' disabled>" + response.d[i].status + "</button></td>"
                            + "<td>"
                            + "<div class='d-flex gap-2 flex-wrap justify-content-center'>"
                            + "<button type='button' class='edit-btn btn btn-link btn-primary btn-lg' data-id='" + response.d[i].prescid + "' data-bs-toggle='tooltip' title='Edit Task'><i class='fa fa-edit'></i></button>"
                            + "<button type='button' class='btn btn-outline-primary btn-sm' onclick='openVisitSummary(event, " + response.d[i].prescid + ")'>Print Visit</button>"
                            + "</div>"
                            + "</td>"

                            + "</tr>"
                        );
                    }




                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        });

        function openVisitSummary(evt, prescid) {
            if (evt && evt.stopPropagation) {
                evt.stopPropagation();
            }
            if (!prescid) {
                return;
            }
            window.open('visit_summary_print.aspx?prescid=' + encodeURIComponent(prescid), '_blank');
        }
    </script>
</asp:Content>
