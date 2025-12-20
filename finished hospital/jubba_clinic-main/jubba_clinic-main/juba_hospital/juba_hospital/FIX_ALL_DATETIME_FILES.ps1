# =====================================================
# FIX ALL DATETIME FILES - AUTOMATED SCRIPT
# =====================================================
# This script will:
# 1. Find all DateTime.Now usages in database operations
# 2. Replace with DateTimeHelper.Now
# 3. Create backup of each file before modifying
# =====================================================

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "DATETIME FIX AUTOMATION SCRIPT" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Files that need fixing based on search
$filesToFix = @(
    "add_lab.aspx.cs",
    "add_lab_charges.aspx.cs",
    "Add_patients.aspx.cs",
    "add_xray_charges.aspx.cs",
    "assignmed.aspx.cs",
    "assingxray.aspx.cs",
    "BedChargeCalculator.cs",
    "charge_history.aspx.cs",
    "doctor_inpatient.aspx.cs",
    "lab_completed_orders.aspx.cs",
    "lap_operation.aspx.cs",
    "manage_charges.aspx.cs",
    "medicine_inventory.aspx.cs",
    "Patient_Operation.aspx.cs",
    "pharmacy_pos.aspx.cs",
    "pharmacy_sales_history.aspx.cs",
    "take_xray.aspx.cs",
    "test_details.aspx.cs",
    "discharge_summary_print.aspx.cs"
)

$backupFolder = ".\DateTime_Backups_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
Write-Host "Backup folder created: $backupFolder" -ForegroundColor Green
Write-Host ""

$filesFixed = 0
$totalReplacements = 0

foreach ($file in $filesToFix) {
    $filePath = ".\$file"
    
    if (Test-Path $filePath) {
        Write-Host "Processing: $file" -ForegroundColor Yellow
        
        # Backup original file
        $backupPath = Join-Path $backupFolder $file
        Copy-Item $filePath $backupPath -Force
        
        # Read file content
        $content = Get-Content $filePath -Raw
        $originalContent = $content
        
        # Count replacements
        $matches = [regex]::Matches($content, 'DateTime\.Now(?![a-zA-Z])')
        $replacementCount = $matches.Count
        
        if ($replacementCount -gt 0) {
            # Replace DateTime.Now with DateTimeHelper.Now (but not DateTime.Now.ToString, etc.)
            $content = $content -replace 'DateTime\.Now(?![a-zA-Z])', 'DateTimeHelper.Now'
            
            # Save modified content
            Set-Content $filePath $content -NoNewline
            
            Write-Host "  ✓ Fixed $replacementCount occurrence(s)" -ForegroundColor Green
            $filesFixed++
            $totalReplacements += $replacementCount
        }
        else {
            Write-Host "  → No DateTime.Now found (already fixed or uses other methods)" -ForegroundColor Gray
        }
    }
    else {
        Write-Host "  ✗ File not found: $file" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "SUMMARY" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "Files processed: $($filesToFix.Count)" -ForegroundColor White
Write-Host "Files modified: $filesFixed" -ForegroundColor Green
Write-Host "Total replacements: $totalReplacements" -ForegroundColor Green
Write-Host "Backups saved to: $backupFolder" -ForegroundColor Yellow
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Review changes in Visual Studio" -ForegroundColor White
Write-Host "2. Build solution (Ctrl+Shift+B)" -ForegroundColor White
Write-Host "3. Fix any compilation errors" -ForegroundColor White
Write-Host "4. Deploy to server" -ForegroundColor White
Write-Host "5. Test thoroughly" -ForegroundColor White
Write-Host ""
Write-Host "If anything goes wrong, restore from: $backupFolder" -ForegroundColor Yellow
Write-Host "=======================================" -ForegroundColor Cyan
