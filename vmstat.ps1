Connect-VIServer

$StartDate = Read-Host "Enter start date. Format: dd/mm/yyyy"
$EndDate = Read-Host "Enter Finish date. Format: dd/mm/yyyy"

$allvms = @()
$allhosts = @()
$alldstores = @()
$hosts = Get-VMHost
$vms = Get-Vm
$dstores = Get-Datastore

foreach($vmHost in $hosts){
  $hoststat = "" | Select HostName, NumCPU, CpuTotalGHz, MemoryTotalMB, MemAvg, CPUAvg, ProcNum, CoresPerProc
  $hoststat.HostName = $vmHost.name
  $hoststat.NumCPU = $vmHost.NumCPU
  $hoststat.CpuTotalGHz = $vmHost.CpuTotalMHz/1000
  $hoststat.MemoryTotalMB = $vmHost.MemoryTotalMB
  $hoststat.ProcNum = $vmHost.ExtensionData.Hardware.CpuInfo.NumCpuPackages
  $hoststat.CoresPerProc = $hoststat.NumCPU/$hoststat.ProcNum
  
  $statcpu = Get-Stat -Entity ($vmHost) -start $StartDate" 00:00:00" -Finish $EndDate" 23:59:59" -MaxSamples 10000 -stat cpu.usage.average
  $statmem = Get-Stat -Entity ($vmHost) -start $StartDate" 00:00:00" -Finish $EndDate" 23:59:59" -MaxSamples 10000 -stat mem.consumed.average

  $cpu = $statcpu | Measure-Object -Property value -Average
  $mem = $statmem | Measure-Object -Property value -Average
   
  $hoststat.CPUAvg = $cpu.Average*$vmHost.CpuTotalMHz/100
  $hoststat.MemAvg = $mem.Average/1024
  
  $allhosts += $hoststat
}
$allhosts | Select HostName, NumCPU, CpuTotalGHz, MemoryTotalMB, MemAvg, CPUAvg, ProcNum, CoresPerProc | Export-Csv -Encoding UTF8 ".\Hosts.csv" -noTypeInformation

foreach($vm in $vms){
  $vmstat = "" | Select VmName,OS,CPUAvg,MemAvg,HDD,Pur1,Pur2,Pur3,Pur4,Pur5,Pur6,Pur7,Pur8,Pur9,Pur10,Pur11,Pur12,Pur13,Pur14,Pur15,Pur16,Pur17,Pur18,Pur19,Pur20,Pur21,Pur22,Pur23,Pur24,Pur25,Pur26,Pur27,Pur28,Pur29,Pur30,Pur31
  $vmstat.VmName = $vm.name
  $vmstat.OS = $vm.guest.OSFullName
  
  $vmstat.Pur1 =  ($vm | Get-Annotation -Name "¿— Ë œ  1").Value
  $vmstat.Pur2 =  ($vm | Get-Annotation -Name "¿— Ë œ  2").Value
  $vmstat.Pur3 =  ($vm | Get-Annotation -Name "¿— Ë œ  3").Value
  $vmstat.Pur4 =  ($vm | Get-Annotation -Name "¿— Ë œ  4").Value
  $vmstat.Pur5 =  ($vm | Get-Annotation -Name "¿— Ë œ  5").Value
  $vmstat.Pur6 =  ($vm | Get-Annotation -Name "¿— Ë œ  6").Value
  $vmstat.Pur7 =  ($vm | Get-Annotation -Name "¿— Ë œ  7").Value
  $vmstat.Pur8 =  ($vm | Get-Annotation -Name "¿— Ë œ  8").Value
  $vmstat.Pur9 =  ($vm | Get-Annotation -Name "¿— Ë œ  9").Value
  $vmstat.Pur10 =  ($vm | Get-Annotation -Name "¿— Ë œ  10").Value
  $vmstat.Pur11 =  ($vm | Get-Annotation -Name "¿— Ë œ  11").Value
  $vmstat.Pur12 =  ($vm | Get-Annotation -Name "¿— Ë œ  12").Value
  $vmstat.Pur13 =  ($vm | Get-Annotation -Name "¿— Ë œ  13").Value
  $vmstat.Pur14 =  ($vm | Get-Annotation -Name "¿— Ë œ  14").Value

  $vmstat.Pur15 =  ($vm | Get-Annotation -Name "–ÓÎ¸*1").Value
  $vmstat.Pur16 =  ($vm | Get-Annotation -Name "–ÓÎ¸*2").Value

  $vmstat.Pur17 =  ($vm | Get-Annotation -Name "—”¡ƒ").Value
  $vmstat.Pur18 =  ($vm | Get-Annotation -Name "»Œƒ").Value
  $vmstat.Pur19 =  ($vm | Get-Annotation -Name "—Â„ÏÂÌÚ").Value

  $vmstat.Pur20 =  ($vm | Get-Annotation -Name "»——*1").Value
  $vmstat.Pur21 =  ($vm | Get-Annotation -Name "»——*2").Value

  $vmstat.Pur22 =  ($vm | Get-Annotation -Name "»—1*1").Value
  $vmstat.Pur23 =  ($vm | Get-Annotation -Name "»—1*2").Value
  $vmstat.Pur24 =  ($vm | Get-Annotation -Name "»—1*3").Value
  $vmstat.Pur25 =  ($vm | Get-Annotation -Name "»—1*4").Value
  $vmstat.Pur26 =  ($vm | Get-Annotation -Name "»—1*5").Value

  $vmstat.Pur27 =  ($vm | Get-Annotation -Name "»—2*1").Value
  $vmstat.Pur28 =  ($vm | Get-Annotation -Name "»—2*2").Value
  $vmstat.Pur29 =  ($vm | Get-Annotation -Name "»—2*3").Value
  $vmstat.Pur30 =  ($vm | Get-Annotation -Name "»—2*4").Value
  $vmstat.Pur31 =  ($vm | Get-Annotation -Name "»—2*5").Value

  $statcpu = Get-Stat -Entity ($vm) -start $StartDate" 00:00:00" -Finish $EndDate" 23:59:59" -MaxSamples 10000 -stat cpu.usageMhz.average
  $statmem = Get-Stat -Entity ($vm) -start $StartDate" 00:00:00" -Finish $EndDate" 23:59:59" -MaxSamples 10000 -stat mem.consumed.average
  $vmhdd = $vm | Get-HardDisk
  $stathdd = 0
  foreach ($dsk in $vmhdd) {
    $stathdd = $stathdd+$dsk.CapacityGb
  }

  $cpu = $statcpu | Measure-Object -Property value -Average
  $mem = $statmem | Measure-Object -Property value -Average
    
  $vmstat.CPUAvg = $cpu.Average
  $vmstat.MemAvg = $mem.Average
  $vmstat.HDD = $stathdd
  $allvms += $vmstat
}
$allvms | Select VmName, OS, CPUAvg, MemAvg, HDD, Pur1,Pur2,Pur3,Pur4,Pur5,Pur6,Pur7,Pur8,Pur9,Pur10,Pur11,Pur12,Pur13,Pur14,Pur15,Pur16,Pur17,Pur18,Pur19,Pur20,Pur21,Pur22,Pur23,Pur24,Pur25,Pur26,Pur27,Pur28,Pur29,Pur30,Pur31 | Export-Csv -Encoding UTF8 ".\VMs.csv" -noTypeInformation

foreach($dstore in $dstores) {
  $storestat = "" | Select Name, CapacityGb, FreeSpaceGb
  $storestat.Name = $dstore.Name
  $storestat.CapacityGB = $dstore.CapacityGB
  $storestat.FreeSpaceGB = $dstore.FreeSpaceGB

  $alldstores += $storestat
}
$alldstores | Select Name, CapacityGB, FreeSpaceGB | Export-Csv -Encoding UTF8 ".\Datastores.csv" -noTypeInformation

Disconnect-VIServer -Force -Confirm:$false
