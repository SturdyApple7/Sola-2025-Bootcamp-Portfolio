#My1stPowerShellScript.ps1
# By: Mekhi Garcia, 1308 August 5th, 2025

# Define the path of the csv File
$csvPath = "$HOME\Documents\Powershell-Scripts\Prohibited-applications.csv"

# Step 1: Verify the csv Exist 
if (-Not ( Test-path -path $csvpath)) {
    Write-Host "CSV file not found at $csvpath"
    exit 1
}

# Step 2: import the csv file
$Prohibitedapps = Import-Csv -path $csvpath 

# Step 3: loop through each enty in the app list
foreach ($app in $Prohibitedapps) {
    $processName = $app.PackageName
    $displayName = $app.ApplicationName
    $reason = $app.Justification

    Write-Host ""
    Write-Host "Checking for Prohibited Application: $displayName ($processName)"
    Write-Host "Justification: $reason"

# Step 4: Check if the app is installed via chocolatey 
$chocoList = Choco list --local-only | Select-String -Pattern "^$displayName"

if ($chocoList) { 
    # Step 5: try to uninstall via Chocolatey if found
    try {
        Write-Host "Starting Uninstall of $displayName using Chocolatey..."
        choco uninstall $displayName -y
        Write-Host "The uninstall of $displayName was successfully done using Chocolatey."
    } catch { 
        Write-Host "Failed to Uninstall $displayName using Chocolatey. Error: $_"
    }
} else {
    # Step 6 if error using Chocolatey check using Get-Package 
    Write-Host "$displayName is not installed using Chocolatey. analyzing other installed packages..."

    $installed = Get-Package | Where-Object {
       $_.Name -like "*$displayName*" -or $_.Name -like "*$processName*"
    }

    if ($installed) {
        Write-Host "$displayName Happens to be installed on the system, but not managed by Chocolatey."
    } else {
        Write-Host "Error $displayName not installed on this system"
   }
 }
}