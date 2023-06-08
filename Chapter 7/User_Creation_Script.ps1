#Application ID: 7ee555a5-fd8b-4509-8d83-685f863e9232
#Tenant ID:      4e67cd72-f73a-42aa-a841-b8dd6ec328ca
#Value:          Vbl8Q~qQxkoFrrt7rvzL8lTqo0I7lJUCEs~mxa~I
#Secret ID:      929b644e-28a7-4457-9bc9-48c20d95b84c

#New-MgUser -DisplayName ‘Daniel Bradley’ -PasswordProfile $PassProfile -AccountEnabled -MailNickName ‘Daniel Bradley’ -UserPrincipalName dbradley@ourcloudnetwork.com’

Param(
    [Parameter(Mandatory)]
    [System.String]
    ${FirstName},

    [Parameter(Mandatory)]
    [System.String]
    ${LastName},
    
    [Parameter(Mandatory)]
    [System.String]
    ${Domain}
)

if ((($firstName | Measure-Object -Character).Characters -ge 64) -or $FirstName -notmatch '^[a-z]+$'){
    Write-host "`n FirstName must be less that 64 characters and contain only characters from a-Z" -ForegroundColor Red
}
if ((($LastName | Measure-Object -Character).Characters -ge 64) -or $FirstName -notmatch '^[a-z]+$'){
    Write-host "`n LastName must be less that 64 characters and contain only characters from a-Z" -ForegroundColor Red
}
if ((($Domain | Measure-Object -Character).Characters -ge 64) -or $FirstName -notmatch '^[a-z]+$'){
    Write-host "`n FirstName must be less that 64 characters and contain only characters from a-Z" -ForegroundColor Red
}

$ApplicationId = "7ee555a5-fd8b-4509-8d83-685f863e9232"
$SecuredPassword = "Vbl8Q~qQxkoFrrt7rvzL8lTqo0I7lJUCEs~mxa~I"
$tenantID = "4e67cd72-f73a-42aa-a841-b8dd6ec328ca"

$SecuredPasswordPassword = ConvertTo-SecureString `
-String $SecuredPassword -AsPlainText -Force

$ClientSecretCredential = New-Object `
-TypeName System.Management.Automation.PSCredential `
-ArgumentList $ApplicationId, $SecuredPasswordPassword

#Connect-MgGraph -TenantId $tenantID -ClientSecretCredential $ClientSecretCredential

