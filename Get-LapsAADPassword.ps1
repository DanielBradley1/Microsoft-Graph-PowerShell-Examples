
Write-Host "Checking for Microsoft Graph Modules" -ForegroundColor Cyan
#Install MS Graph if not available
if (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication) {
    Write-Host "OK" -ForegroundColor Green
} 
else {
    Write-Host "Installing Microsoft Graph"
    Install-Module -Name Microsoft.Graph -Scope CurrentUser -Repository PSGallery -Force
    Write-Host "Microsoft Graph Authentication Installed"
}

#Connect to Microsoft Graph
Write-host "Connecting to Microsoft Graph" -ForegroundColor Cyan
Connect-Mggraph -Scope DeviceLocalCredential.Read.All, Device.Read.All

#Checking Connection
Function Check-MgContext
{
    if ((Get-MgContext).Scopes -match "Device") {
        Continue
    } 
    else {
        Do {
        Write-Host "Session not established, retrying authentication..." -ForegroundColor Yellow
        Connect-Mggraph -Scope DeviceLocalCredential.Read.All, Device.Read.All
        } While ((Get-MgContext).Scopes -eq $null)
        Write-Host "Session established" -ForegroundColor Green
    }
}

#Run Function
Check-MgContext

#Define your device name here
$DeviceName = "Win11Desktop02"
#Store the device id value for your target device
$DeviceId = (Get-MgDevice | Where-Object {$_.DisplayName -eq $DeviceName} | Select DeviceId).DeviceId

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
$passwordb64 | %{[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($_))}
