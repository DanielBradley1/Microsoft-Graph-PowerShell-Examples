#####
# Author: Daniel Bradley
# LinkedIn: https://www.linkedin.com/in/danielbradley2/
# Twitter: https://twitter.com/DanielatOCN
# Website: https://ourcloudnetwork.com/
# Info: This script was written by Daniel Bradley for the Microsoft Graph PowerShell Zero to Hero Book
#####

##Import the Microsoft Graph Users module
Import-Module Microsoft.Graph.Users

##Connect to Microsoft Graph with the user read/write permission
Connect-MgGraph -scope User.ReadWrite.All

##Define the password profile settings within a hash table
$PasswordProfile = @{
    Password = "Helo123!"
    ForceChangePasswordNextSignIn = $true
    ForceChangePasswordNextSignInWithMfa = $true
}

##Create the new user account
New-MgUser -DisplayName "New User" -PasswordProfile $PasswordProfile `
-AccountEnabled -MailNickName "NewUser" `
-UserPrincipalName "newuser@ourcloudnetwork.com"
