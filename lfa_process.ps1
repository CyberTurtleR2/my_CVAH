$targets = Import-Csv .\WinHost.csv |
    Where-Object {$_.os -eq "Win10"} |
        Select-Object -ExpandProperty ip

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\3317\Scripts\procs.ps1

$current | Sort-Object -Property pscomputername, hash -Unique |
    Group-Object hash |
        Where-Object {$_.count -le 2} |
            Select-Object -ExpandProperty Group
