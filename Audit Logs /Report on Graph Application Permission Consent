# Connect to Microsoft Graph
Connect-MgGraph -Scope AuditLog.Read.All, application.read.all

# Select beta profile of Graph API
Select-MgProfile -name beta

# Get Date minus 7 days
$a = $(get-date).AddDays(-7).ToString("yyyy-MM-dd")

# Get application consent logs
$uri = "https://graph.microsoft.com/beta/auditLogs/directoryAudits?`$filter=ActivityDateTime ge $a and ActivityDisplayName eq 'Consent to application'"
$logs = Invoke-MgGraphRequest -uri $uri -Method Get -OutputType PSObject | select -expand value

# Create Report object
$Report = [System.Collections.Generic.List[Object]]::new()

# Loop through each log
ForEach ($log in $logs) {
    # null temporary variable
    $id = $null
    $app = $null

    # Get current app id
    $id = ($t.additionalDetails).GetEnumerator() | Where-Object {$_.Key -eq 'AppID'}

    # Get Application Name
    if ($t.targetResources.type -eq "ServicePrincipal"){
        $App = Get-MgServicePrincipal -Filter "AppId eq '$($id.value)'"
    } else {
        $app = Get-MgApplication -Filter "AppId eq '$($id.value)'"
    }    

    # build report object
    $obj = [PSCustomObject][ordered]@{
        "App Name"      = $app.DisplayName
        "Admin Consent" = (($log.targetResources.modifiedProperties) | Where-Object {$_.DisplayName -eq 'ConsentContext.IsAdminConsent'}).NewValue
        "Consented by"  = $log.initiatedBy.user.userPrincipalName
    }
    $report.Add($obj)
 }
