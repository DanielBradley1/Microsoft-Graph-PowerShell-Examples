#Used to trigger workflow from legacy auth application

Connect-MgGraph -certicate.....

#Get all users
$AllUsers = Get-MgBetaUser -All -Property SignInActivity

Foreach ($mguser in $allusers){
    #Checking if Sign in activity is null
    If ($mguser.SignInActivity.AdditionalProperties.lastSuccessfulSignInDateTime -eq $null) {
        #Skip item in loop if null as ext property update will fail
        Continue
    }
    #Get local AD users based on matching userprincipalname
    $aduser = $null
    $aduser = Get-AdUser -filter "userprincipalname -eq '$($mguser.userprincipalname)'"
    #attempt to update extensionattribute9
    try {
        Write-host "Updating for $($aduser.sAMAccountName)"
        Set-ADUser -Identity $aduser.sAMAccountName -Replace @{extensionAttribute9 = ($mguser.SignInActivity.AdditionalProperties.lastSuccessfulSignInDateTime)}
        Write-host "Update successful for $($aduser.sAMAccountName)" -ForegroundColor Green
    }
    catch {
        Write-host "Unable to update $($aduser.sAMAccountName)"
    }
}

