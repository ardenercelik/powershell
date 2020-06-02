#loop örnek
for ($i = 0; $i -lt 10; $i++) {
    notepad
}

start-sleep -s 2

for ($i = 0; $i -lt 10; $i++) {
    (Get-Process | where {$_.name -eq "notepad"}).kill()
}

