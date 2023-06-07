#Application ID: 7ee555a5-fd8b-4509-8d83-685f863
#Tenant ID:      4e67cd72-f73a-42aa-a841-b8dd6ec3
#Value:          Vbl8Q~qQxkoFrrt7rvzL8lTqo0I7lJUCEs
#Secret ID:      929b644e-28a7-4457-9bc9-48c20

#New-MgUser -DisplayName ‘Daniel B -PasswordProfile $PassProfile -AccountEnabled -MailNickName ‘Daniel Bradley’ -UserPrincipalName dbra’

Param(
    [Parameter(Mandatory)]
    [System.String]
    ${FirstName},

    [Parameter(Mandatory)]
    [System.String]
    ${LastName}
)

$ApplicationId = "7ee555a5-fd8b-4509-8d83-685f863e"
$SecuredPassword = "Vbl8Q~qQxkoFrrt7rvzL8lTqo0I7lJUCEs"
$tenantID = "4e67cd72-f73a-42aa-a841-b8dd6ec"

$SecuredPasswordPassword = ConvertTo-SecureString `
-String $SecuredPassword -AsPlainText -Force

$ClientSecretCredential = New-Object `
-TypeName System.Management.Automation.PSCredential `
-ArgumentList $ApplicationId, $SecuredPasswordPassword

Connect-MgGraph -TenantId $tenantID -ClientSecretCredential $ClientSecretCredential
