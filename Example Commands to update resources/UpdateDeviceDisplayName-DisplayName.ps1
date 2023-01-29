#####
# Author: Daniel Bradley
# LinkedIn: https://www.linkedin.com/in/danielbradley2/
# Twitter: https://twitter.com/DanielatOCN
# Website: https://ourcloudnetwork.com/
# Info: This script was written by Daniel Bradley for the Microsoft Graph PowerShell Zero to Hero Book
#####

Import-Module Microsoft.Graph.Identity.DirectoryManagement
Connect-MgGraph Device.ReadWrite.All

$device = Get-MgDevice -Search "displayName:TargetDevice" -ConsistencyLevel eventual

Update-MgDevice -DeviceId $device.Id -DisplayName "MyNewDisplayName"