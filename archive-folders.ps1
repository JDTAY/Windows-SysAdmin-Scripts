<#
.SYNOPSIS
    Move all data from folders

.DESCRIPTION
    As above.

.NOTES
    AUTHOR  : Joanthon Taylor
    CREATED : 06-12-2018
    VERSION : 1.0 - Initial Revision

.INPUTS
None. This script does not accept pipelines

.OUTPUTS
None. This script does not output parameters

#>

#====================================================================================================
#                                             parameters
#====================================================================================================

#Paths
$Path = "C:\SomePath"
$ExpiryDate = (Get-Date).AddDays(-340)
#Set the error action preference to stop to handle errors as they occur
$ErrorActionPreference = "Stop"

#Override the verbose preference passed by Azure Automation - to keep verbose output clean
$VerbosePreference = "SilentlyContinue"

#endregion parameters
#====================================================================================================
#                                             Dot Source
#====================================================================================================
#region Dot Source

#Dot Source the AuscriptCore module for logging
. .\JonnyCore.ps1



#endregion Dot Source
#====================================================================================================
#                                             Main Code
#====================================================================================================
#region Main Code
#TraceLog examples

#Create an array of direcotires to be mirrored

#Get the directories from the source file share on the Isilon that we're moving from the above arra
Write-Host  "Getting the paths we need to move to Archive directories."

$Source = Get-ChildItem $Path -Directory
#Check to see Archive directory already exists

foreach ($parent in $Source) {
    if (Test-Path "$parent\Archive\") {
        Write-Host "Archive already exists at "$parent\Archive", starting the movement of the files."
    } else {
        Write-Host "Archive doesn't exist, creating it now at $($parent.FullName)\Archive"
        New-item -ItemType Directory -Path  "$($parent.FullName)\Archive" -WhatIf
    }
}
Write-Host "Grabbing the directories inside of $Parent to be moved."
$Children = Get-ChildItem -Path $Parent.Fullname -Directory

foreach ($Folder in $Children) {

    Write-Host "Getting all directories that have a LastWriteTime of 340 days."
    if ($Folder.LastWriteTime -le $ExpiryDate) {
        Move-Item -Path $Folder.FullName -Destination "$($parent.FullName)\Archive\$($Folder.Name)" -WhatIf
    } else {
        Write-Host "$Folder.FullName is not older than -1 day, leaving file as is."
    }
}

