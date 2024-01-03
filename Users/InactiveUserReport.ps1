<#
AUTHOR: Daniel Bradley
LINKEDIN: https://www.linkedin.com/in/danielbradley2/
TWITTER: https://twitter.com/DanielatOCN
WEBSITE: https://ourcloudnetwork.com/
Info: This script was written by Daniel Bradley for the ourcloudnetwork.com blog
#>

#Connect to Microsoft Graph
Connect-MgGraph -scope User.Read.All, AuditLog.read.All

#Gather all users in tenant
$AllUsers = Get-MgBetaUser -All -Property signinactivity

#Create a new empty array list object
$Report = [System.Collections.Generic.List[Object]]::new()

Foreach ($user in $AllUsers)
{
    #Null variables
    $SignInActivity = $null
    $Licenses = $null

    #Display progress output
    Write-host "Gathering sign-in information for $($user.DisplayName)" -ForegroundColor Cyan

    #Get current user information
    $licenses = (Get-MgBetaUserLicenseDetail -UserId $User.id).SkuPartNumber -join ", "

    #Create informational object to add to report
    $obj = [pscustomobject][ordered]@{
            DisplayName                = $user.DisplayName
            UserPrincipalName          = $user.UserPrincipalName
            Licenses                   = $licenses
            LastInteractiveSignIn      = $User.SignInActivity.LastSignInDateTime
            LastNonInteractiveSignin   = $User.SignInActivity.LastNonInteractiveSignInDateTime
            LastSuccessfullSignInDate  = $User.SignInActivity.AdditionalProperties.lastSuccessfulSignInDateTime
        }
    
    #Add current user info to report
    $report.Add($obj)
}

$report | Export-CSV -path C:\temp\Microsoft365_User_Activity-Report.csv -NoTypeInformation
