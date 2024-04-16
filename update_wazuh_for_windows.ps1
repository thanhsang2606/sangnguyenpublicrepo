# This script uses to fix Wazuh Agent disconnected issue only.
# Written by SangNguyen.
#
#
# Use instruction:
## Download this file
## Right click and "Run as Administrator"
$configFile = "C:\Program Files (x86)\ossec-agent\ossec.conf"
$backupFile = "C:\Program Files (x86)\ossec-agent\ossec.conf.bk"
$serviceName = "Wazuh"
Copy-Item -Path $configFile -Destination $backupFile -Force
Write-Output "Backing up configuration file"
$content = Get-Content $configFile
$newNodes = @'
      <max_retries>100</max_retries>
      <retry_interval>15</retry_interval>
'@
$modifiedContent = $content | ForEach-Object {
    $_
    if ($_ -match '<protocol>tcp</protocol>') {
        $newNodes
    }
}
Write-Output "Updating new configure"
$modifiedContent | Set-Content -Path $configFile
Restart-Service -Name $serviceName -Force
Write-Output "Restarting Wazuh service"
Write-Output "Update completed"
