$targets = Import-Csv .\WinHosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip
    
$ht = @{
  ReferenceObject = Import-Csv .\Rubrics\Win10BaselineProcs.csv
  Property        = "hash", "path"
  PassThru        = $true
}

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\3317\Scripts\Procs.ps1

ForEach ($ip in $targets){
  $ht.DifferenceObject = $current |
    Where-Object {$_.pscomputername -eq $ip} |
      Sort-Object -Property hash, path -Unique
      
  Compare-Object @ht |
    Where-Object {$_.sideindicator -eq "=>" -and $_.path -ne $null}
}
