<#
AUTHOR: Daniel Bradley
LINKEDIN: https://www.linkedin.com/in/danielbradley2/
TWITTER: https://twitter.com/DanielatOCN
WEBSITE: https://ourcloudnetwork.com/
Info: This script was written by Daniel Bradley for the ourcloudnetwork.com blog
#>

####### Script Notes ######
# This script is designed to use the Invoke-MgGraphRequest cmdlet to retrieve the current LAPS password from Azure AD for single specific device.
# Example: Get-LapsAADPassword.ps1 -DeviceName Win11Desktop02
###########################

###### Parameters ######
[cmdletbinding()]
param
(
    [string]$DeviceName
    )

Write-Host "Checking for Microsoft Graph Modules" -ForegroundColor Cyan
#Install MS Graph if not available
if (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication) {} 
else {
    Write-Host "Installing Microsoft Graph"
    Install-Module -Name Microsoft.Graph -Scope CurrentUser -Repository PSGallery -Force
    Write-Host "Microsoft Graph Authentication Installed"
}

#Connect to Microsoft Graph
Write-host "Connecting to Microsoft Graph" -ForegroundColor Cyan
Connect-Mggraph -Scope DeviceLocalCredential.Read.All, Device.Read.All

Write-host "Checking Session" -ForegroundColor Yellow
if ((Get-MgContext).Scopes -match "Device") {}
else {
    Do {
    Write-Host "Session not established, retrying authentication..." -ForegroundColor Yellow
    Connect-Mggraph -Scope DeviceLocalCredential.Read.All, Device.Read.All
    $var++
    } Until ((Get-MgContext).Scopes -ne $null -or $var -eq 3)
	If ((Get-MgContext).Scopes -match "Device") {
		Write-host "Connection successful" -foregroundcolor Green
	} else {
		Write-host "Connection not successful, exiting script." -foregroundcolor Yellow
		return
	}
}

Write-Host "Looking for $DeviceName"

#Define your device name here
#$DeviceName = "Win11Desktop02"
#Store the device id value for your target device
$DeviceId = (Get-MgDevice | Where-Object {$_.DisplayName -eq $DeviceName} | Select DeviceId).DeviceId

If ($DeviceId -eq $null){
    Write-host "Device not found! Exiting script." -ForegroundColor Yellow
    Return
}

#Generate a new correlation ID
$correlationID = [System.Guid]::NewGuid()

#Define the URI path
$uri = 'beta/deviceLocalCredentials/' + $DeviceId
$uri = $uri + '?$select=credentials'

#Build the request header
$headers = @{}
$headers.Add('ocp-client-name', 'Get-LapsAADPassword Windows LAPS Cmdlet')
$headers.Add('ocp-client-version', '1.0')
$headers.Add('client-request-id', $correlationID)

#Initation the request to Microsoft Graph for the LAPS password
$Response = Invoke-MgGraphRequest -Method GET -Uri $URI -Headers $headers

#Decode the LAPS password from Base64
$passwordb64 = ($Response.credentials).PasswordBase64
$password = $passwordb64 | %{[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($_))}
Write-host "$Password"

Disconnect-MgGraph | out-null
