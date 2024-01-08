<#
.SYNOPSIS
Generates a report of user-consented permissions to application in Microsoft Entra
.LINK
   https://ourcloudnetwork.com
   https://www.linkedin.com/in/danielbradley2/
.NOTES
   Version:        0.1
   Author:         Daniel Bradley
   Creation Date:  Monday, January 8th 2024, 6:54:33 am
   File: ApplicationUserConsentReport.ps1
   Copyright (c) 2024 Your Company

HISTORY:
2024-01-08	File Generated

.INPUTS
.OUTPUTS

.COMPONENT
 Required Modules: 
 Microsoft.Graph.Applications
 Microsoft.Graph.Users
 
.EXAMPLE
.\ApplicationUserConsentReport.ps1

.LICENSE
Use this code free of charge at your own risk.
Never deploy code into production if you do not know what it does.
#>

#Connect to graph
Connect-MgGraph -Scopes Application.Read.All, user.read.all

#Define output file name
$filename = "User_Permissions_Grant_Report.csv"

#Function will launch Windows explorer to select a folder
Function SelectFolder {
    $global:folderselection = New-Object System.Windows.Forms.OpenFileDialog -Property @{  
    InitialDirectory = [Environment]::GetFolderPath('Desktop')  
    CheckFileExists = 0  
    ValidateNames = 0  
    FileName = $filename  
    }
    $folderselection.ShowDialog() | Out-Null
}

#Gets all service principals with limited info
Write-host "Gathering service principals.." -ForegroundColor Yellow
$AllServicePrincipals = Get-MgServicePrincipal -All | Select Id, appid, DisplayName

#Send batch requests to gather all user grants, due to large number of service principals
Write-host "Indentifying user grants..." -ForegroundColor Yellow
$Report = @()
for($i=0;$i -lt $AllServicePrincipals.count;$i+=20){
    $batch = @{}
    $batch['requests'] = ($AllServicePrincipals[$i..($i+19)] | select @{n='id';e={$_.id}},@{n='method';e={'GET'}},`
		@{n='url';e={"/servicePrincipals/$($_.id)/oauth2PermissionGrants"}})
    $response = invoke-mggraphrequest -Method POST -URI "https://graph.microsoft.com/v1.0/`$batch" -body ($batch | convertto-json) -OutputType PSObject
    $Report += $response.responses
}
$UserGrants = $Report.body.value | Where {$_.ConsentType -eq "Principal"}

#Uses loop function to gather additional information such as the userprincipalname. It also correlates the service principal name.
Write-host "correlating information..." -ForegroundColor Yellow
$final = [System.Collections.Generic.List[Object]]::new()
Foreach ($Grant in $UserGrants){
    $user = $null
    $app = $null
    $user = Get-MgUser -UserId $Grant.principalId | Select UserPrincipalName
    $app = $AllServicePrincipals | Where {$_.id -eq $($grant.clientid)}
    $obj = [PSCustomObject][ordered]@{
        "Application" = $app.DisplayName
        "user" = $user.UserPrincipalName
        "permission" = ($grant.scope.Trim() -replace " ",", ")
    }
    $final.Add($obj)
}

#Run select folder function
Write-host "Please select a folder `n" -ForegroundColor Green
Start-Sleep -Seconds 2
SelectFolder

#Export file
$final | Export-CSV  -Path $folderselection.FileName -NoTypeInformation
Write-host "File saved! Click Enter to close... `n" -ForegroundColor Green
Write-host "        Script by  >>  Daniel Bradley   " -ForegroundColor cyan -BackgroundColor black
Write-host "            Visit  >>  ourcloudnetwork.com  " -ForegroundColor cyan -BackgroundColor black
Write-host "          Connect  >>  https://www.linkedin.com/in/danielbradley2/  " -ForegroundColor cyan -BackgroundColor black
Write-host "`n"
Pause
