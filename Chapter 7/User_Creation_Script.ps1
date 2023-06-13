<#

Written for the Microsoft Graph PowerShell Administrators Handbook
Author: Daniel Bradley
LinkedIn: https://www.linkedin.com/in/danielbradley2/

**This code is free to use for whatever**
Example: .\User Creation Script.ps1 -firstName Daniel -LastName Bradley -domain ourcloudnetwork.com

#>

#Defined parameters
Param(
    [Parameter(Mandatory)]
    [String]
    ${FirstName},

    [Parameter(Mandatory)]
    [String]
    ${LastName},
    
    [Parameter(Mandatory)]
    [String]
    ${Domain}
)

#This function will validate if the user already exists. If it does, the script will terminate
function UserValidation{ 
    $checkuser = Get-MgUser -userid $UserPrincipalName
    if ($UserPrincipalName) {
        Write-host " `n User already exist with this username, terminating script" -ForegroundColor Yellow
        Pause 5
        Exit
    }
}

#Validate user input for the -firstname parameter
if ((($firstName | Measure-Object -Character).Characters -ge 64) -or $FirstName -notmatch '^[a-z]+$'){
    Write-host "`n FirstName must be less that 64 characters and contain only characters from a-Z" -ForegroundColor Red
    exit
}
#Validate user input for the -lastname parameter
if ((($LastName | Measure-Object -Character).Characters -ge 64) -or $FirstName -notmatch '^[a-z]+$'){
    Write-host "`n LastName must be less that 64 characters and contain only characters from a-Z" -ForegroundColor Red
    exit
}
#Validate user input for the -domain parameter
if ((($Domain | Measure-Object -Character).Characters -ge 64) -or $FirstName -notmatch '^[a-z]+$'){
    Write-host "`n FirstName must be less that 64 characters and contain only characters from a-Z" -ForegroundColor Red
    exit
}

#Define authorisation parameters
$ApplicationId = "EXAMPLE"
$SecuredPassword = "EXAMPLE"
$tenantID = "EXAMPLE"

#Converts the Secure Password string to a secure string
$SecuredPasswordPassword = ConvertTo-SecureString `
-String $SecuredPassword -AsPlainText -Force

#Create a PowerShell credential object to use in our connection command
$ClientSecretCredential = New-Object `
-TypeName System.Management.Automation.PSCredential `
-ArgumentList $ApplicationId, $SecuredPasswordPassword

#Connect to Microsoft Graph
Connect-MgGraph -TenantId $tenantID -ClientSecretCredential $ClientSecretCredential

#Create the necessary variable for the New-MgUser command
$DisplayName = "$FirstName $LastName"
$MailNickname = "$FirstName.$LastName"
$UserPrincipalName = "$MailNickName@$Domain"
$PasswordProfile = @{
  Password = 'Helo123!'
  ForceChangePasswordNextSignIn = $true
  ForceChangePasswordNextSignInWithMfa = $true
}

#Create a new user
Try {
    New-MgUser -DisplayName $DisplayName -PasswordProfile $PasswordProfile -MailNickname $MailNickname -UserPrincipalName $UserPrincipalName -AccountEnabled -erroraction Stop
}
catch { 
   #Perform validation function
   UserValidation
}
