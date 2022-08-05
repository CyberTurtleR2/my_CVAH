$targets = Import-Csv .\Winhosts.csv |
  Where-Object {$_.os -eq "Win10"} |
    Select-Object -ExpandProperty ip
    
$ht = @{
  ReferenceObject = Import-Csv .\Rubrics\LocalAccountsBaseline.csv
  Property        = "direction", "action", "localaddress", "remoteaddress", "localport", "remoteport"
  PassThru        = $true
}

$current = Invoke-Command -ComputerName $targets -Credential $creds -FilePath ..\3317\Scripts\firewall.ps1

ForEach ($ip in $targets){
  $ht.DifferenceObject = $current |
    Where-Object {$_.pscomputername -eq $ip} |
      Sort-Object -Property direction, action, localaddress, remoteaddress, localport, remoteport -Unique
  Compare-Object @ht |
    Select-Object -Property *, @{n = "IP"; e = {"$IP"}}
}
