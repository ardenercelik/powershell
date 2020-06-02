
#ilyas abi script deneme çalışma
$lockedFile = "C:\windows\SYSTEM32\dwmapi.dll"
$x = Get-Process | foreach{$processVar = $_;$_.Modules | foreach{if($_.FileName -eq $lockedFile){$processVar.Name + " PID:" + $processVar.id}}}

$x >> processsss.txt
