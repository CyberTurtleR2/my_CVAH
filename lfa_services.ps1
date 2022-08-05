$targets = Import-Csv .\WinHost.csv |
    Where-Object {$_.os -eq "Win10"} |
        Select-Object -ExpandProperty ip

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\3317\Scripts\services.ps1

$current | Sort-Object -Property pscomputername, ServiceName -Unique |
    Group-Object ServiceName |
        Where-Object {$_.count -le 2} |
            Select-Object -ExpandProperty Group
