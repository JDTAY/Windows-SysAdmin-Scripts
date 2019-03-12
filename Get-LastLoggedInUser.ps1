$computers = New-Object System.Collections.Generic.List[System.Object]

$computers.Add('FirstComp')
$computers.Add('SecondComp')
$computers.Add('ThirdComp')

foreach ($computer in $computers) {
    Get-ChildItem "\\$computer\c$\Users" | Sort-Object LastWriteTime -Descending | Select-Object Name, LastWriteTime -first 10
}