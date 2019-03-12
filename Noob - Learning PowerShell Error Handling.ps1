#Courtesy of Wayne Hoggett

#Provided by Wayne for documentation and build purposes
#Get ErrorActionPreference, default is continue
$ErrorActionPreference
$ErrorActionPreference = "Continue"

#Non-Terminating Error
Get-ChildItem "C:\xyz"

#Terminating Error
$num = 5 /0

#Non Terminating Error
try {
    Get-ChildItem "C:\xyz"
    Write-Host "Didn't enter catch block"
} catch {
    Write-Host "Entered catch block"
}

#Terminating Error
try {
   $num = 5 /0
    Write-Host "Didn't enter catch block"
} catch {
    Write-Host "Entered catch block"
}

#ErrorActionPreference
$ErrorActionPreference = "Stop"

#Non Terminating Error, now terminates
try {
    Get-ChildItem "C:\xyz"
    Write-Host "Didn't enter catch block"
} catch {
    Write-Host "Entered catch block"
    Write-Host $_
}

#Deciding when to catch
##use erroraction SilentlyContinue on the call to skip logging
try {
    Get-ChildItem "C:\xyz" -ErrorAction SilentlyContinue
    Write-Host "Didn't enter catch block"
} catch {
    Write-Host "Entered catch block"
}
 
##Catch, log and continue
try {
    Get-ChildItem "C:\xyz"
    Write-Host "Didn't enter catch block"
} catch {
    Write-Host "Entered catch block"
    Write-Host $_
}
Write-Host "Continued"

#Handling errors within a function
function Get-Something {
    try {
        Write-Host "Getting something"
        Get-ChildItem "C:\xyz"
        Write-Host "Didn't enter catch block"
    } catch {
        Write-Host "Didn't get something"
    }
}

try {
    Get-Something
} catch {
    Write-Host "Failed to execute Get-Something"
    Write-Host $_
}

#Throw back to the caller
function Get-Something {
    try {
        Write-Host "Getting something"
        Get-ChildItem "C:\xyz"
        Write-Host "Didn't enter catch block"
    } catch {
        Write-Host "Didn't get something"
        throw
    }
}

try {
    Get-Something
} catch {
    Write-Host "Failed to execute Get-Something"
    Write-Host $_
}