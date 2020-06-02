
#Dosyaya yazı yazma örnek
$Procs = Get-Process | where {$_.CPU -gt 100}
Out-File -FilePath .\Process.txt -InputObject $Procs -Encoding ASCII -Width 50

Get-Alias | Out-File -FilePath .\Alias.txt
Get-Command | Out-File -FilePath .\Command.txt
Select-String -Path .\*.txt -Pattern 'Get'

