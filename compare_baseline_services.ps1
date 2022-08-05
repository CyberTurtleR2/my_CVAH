$targets = Import-Csv .\Winhosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip
    
$ht = @{
  ReferenceObject = Import-Csv .\Rubrics\Win7ServiceBaseline.csv
  Property        = "ServiceName"
  PassThru        = $true
}

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\3317\Scripts\services.ps1

ForEach ($ip in $targets){
  $ht.DifferenceObject = $current |
    Where-Object {$_.pscomputername -eq $ip} |
      Sort-Object -Property ServiceName -Unique
  Compare-Object @ht |
    Where-Object {$_.sideindicator -eq "=>"}
}
