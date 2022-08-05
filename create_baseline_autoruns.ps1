$targets = Import-Csv .\Winhosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip

ICM -CN $targets -CR $creds -FilePath .\autoruns.ps1 -ArgumentList (,(Get-Content .\Autoruns.txt)) | Export-Csv .\Win10AutoRunsBaseline.csv
