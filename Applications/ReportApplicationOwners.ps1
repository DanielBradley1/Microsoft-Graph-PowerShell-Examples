<#
.SYNOPSIS
Exports application owners. Utilises request batching
.LINK
   https://ourcloudnetwork.com
   https://www.linkedin.com/in/danielbradley2/
   https://twitter.com/DanielatOCN
.NOTES
   Version:        0.1
   Author:         Daniel Bradley
   Creation Date:  Monday, January 15th 2024, 6:57:19 am
   File: ReportApplicationOwners.ps1
   Copyright (c) 2024 our cloud network ltd

HISTORY:

.OUTPUTS
Modify line 66 "$owners | Export-CSV -Path C:\temp\Appowners.csv"

.COMPONENT
 Required Modules: 
 Microsoft.Graph.Authentication
 Microsoft.Graph.Beta.Applications

.LICENSE
Use this code free of charge at your own risk.
Never deploy code into production if you do not know what it does.
#>

#Connect to Microsoft Graph
Connect-MgGraph -Scopes Application.Read.All

#Get all applications
$AllApps = Get-MgBetaApplication -All 

#Initialise array 
$Report = @()

#Send batch requests to get application owners
for($i=0;$i -lt $AllApps.count;$i+=20){
    $batch = @{}
    $batch['requests'] = ($AllApps[$i..($i+19)] | select @{n='id';e={$_.id}},@{n='method';e={'GET'}},`
		@{n='url';e={"/applications/$($_.id)/owners"}})
    $response = invoke-mggraphrequest -Method POST -URI "https://graph.microsoft.com/v1.0/`$batch" -body ($batch | convertto-json) -OutputType PSObject -ResponseHeadersVariable string
    $Report += $response.responses
}

#Create a new array list
$owners = [System.Collections.Generic.List[Object]]::new()

#Loop through locally caches items and add to array list
Foreach ($app in $report) {
     If (($app.body.value.userprincipalname).count -ge 1) {
        $owner = $app.body.value.userprincipalname -join ", "
     } else {
        $owner = $app.body.value.userprincipalname
     }
     $obj = [PSCustomObject][ordered]@{
        "Application" = ($allapps | Where {$_.id -eq $app.id} | Select DisplayName).displayname
        "Owners" = $owner
    }
    $owners.Add($obj)
}

#Export to CSV
$owners | Export-CSV -Path C:\temp\Appowners.csv