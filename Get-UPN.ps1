$oldSuffix = '@old.suffix'
$newSuffix = '@newsuffic.com.au'
$OU = 'ou=Staff,ou=_Managed Users,dc=jdtay,dc=local'

$ListUsers = Get-ADUser -Filter "userPrincipalName -like '*$oldSuffix'" -SearchBase $OU
$UPNs = $ListUsers.UserPrincipalName

if ($null -ne $UPNs) {
    foreach ($UPN in $UPNs) {
        Write-Host "Replacing $UPN's old UPN of $oldSuffix with $newSuffix"
        $NewUPN = $UPN.Replace($oldSuffix, $newSuffix)
        $Identity = $NewUPN.Replace($newSuffix, "")
        try {
            Write-Host "Trying to change users UPN with $Identity"
            Set-ADUser -UserPrincipalName $NewUPN -identity $Identity
        } catch {
            Write-Host "ERROR: User's name breaks character limit of 20, limiting username of $identity to 20 characters and retrying"
            $FuckingCharacterLimits = "long.usernamesomethingyeah".substring(0,20)
            Set-ADUser -UserPrincipalName $NewUPN -identity $FuckingCharacterLimits
        }
        try {
            $UpdatedUPN = Get-ADUser -Filter "userPrincipalName -like '*$NewUPN*'" -SearchBase $OU
            Write-Host "SUCCESS: $UPN's UPN has been changed to: $($UpdatedUPN.UserPrincipalName)"
        }
        catch {
            Write-Host "ERROR: Didn't change $UPN's UPN"
            Throw
        }
    }
} else {
        Write-Host "INFORMATION: No users with $oldSuffix were found in $OU"
}
