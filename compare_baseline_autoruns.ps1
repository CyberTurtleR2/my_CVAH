$targets = Import-Csv .\Winhosts.csv |
  Where-Object {$_.os -like "*2012*"} |
    Select-Object -ExpandProperty ip
    
$ht = @{
  ReferenceObject = Import-Csv .\Rubrics\WinServer2012AutoBaseline.csv
  Property        = "Key_ValueName"
  PassThru        = $true
}

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\3317\Scripts\autoruns.ps1 -ArgumentList (,(Get-Content .\Autorunkeys.txt))

ForEach ($ip in $targets){
  $ht.DifferenceObject = $current |
    Where-Object {$_.pscomputername -eq $ip} |
      Sort-Object -Property Key_Valuename -Unique
  Compare-Object @ht |
    Where-Object {$_.sideindicator -eq "=>"}
}
