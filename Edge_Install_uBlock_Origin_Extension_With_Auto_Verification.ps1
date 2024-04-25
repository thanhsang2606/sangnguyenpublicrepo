# This script is using for Microsoft Edge - uBlock Origin extension installation

Import-Module $env:SyncroModule

$extensionID = "odfafepnkmbhccpbejgmiehpchacaeak"
$updateURL = "https://edge.microsoft.com/extensionwebstorebase/v1/crx"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist"

Log-Activity -Message "Initiating installation of uBlock Origin on Edge" -EventName "uBlock Origin Installation"
New-Item -Path $regPath -Force | Out-Null
$extensionValue = "$extensionID;$updateURL"
$regKey = "1"
New-ItemProperty -Path $regPath -Name $regKey -Value $extensionValue -PropertyType String -Force

# Verification of the installation
if (Test-Path $regPath) {
    $installedExtensions = Get-ItemProperty -Path $regPath
    $isInstalledCorrectly = $false
    $extensionDetails = ""
    foreach ($value in $installedExtensions.PSObject.Properties) {
        if ($value.Value -like "*$extensionID*") {
            $isInstalledCorrectly = $true
            $extensionDetails = $value.Value
            break
        }
    }

    if ($isInstalledCorrectly) {
        Log-Activity -Message "uBlock Origin was correctly installed." -EventName "Verification Successful"
        $successMessage = "uBlock Origin was correctly installed on Edge. Details: $extensionDetails"
        Send-Email -To "thanhsang@somewherelse.com" -Subject "uBlock Origin installation and verification successful" -Body $successMessage
    } else {
        Log-Activity -Message "Verification failed: uBlock Origin was not installed correctly." -EventName "Verification Failed"
        Send-Email -To "thanhsang@somewherelse.com" -Subject "uBlock Origin installation and verification failed" -Body "uBlock Origin has not been installed correctly on Edge."
    }
} else {
    Log-Activity -Message "Installation failed: Registry path does not exist." -EventName "Installation Failed"
    Send-Email -To "thanhsang@somewherelse.com" -Subject "uBlock Origin Installation Failed" -Body "The registry path does not exist. Installation did not proceed as expected."
}


