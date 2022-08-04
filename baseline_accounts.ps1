$targets = Import-Csv .\Winhosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip
    
$ht = @{
  ReferenceObject = Import-Csv .\Rubrics\LocalAccountsBaseline.csv
  Property        = "name"
  PassThru        = $true
}

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\3317\Scripts\accounts.ps1

ForEach ($ip in $targets){
  $ht.DifferenceObject = $current |
    Where-Object {$_.pscomputername -eq $ip} |
      Sort-Object -Property name -Unique
  Compare-Object @ht |
    Where-Object {$_.sideindicator -eq "=>"}
}
