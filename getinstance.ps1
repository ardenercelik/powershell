#dosyadan okuyucaz, silemediğimiz dll leri hangi processler kullanıyor bunları ekrana bastırıcaz.
# Parameter help description
# Param(
#     [Parameter(Mandatory=$true)]
#     [ValidateScript({Test-Path $_ -PathType 'any'})]
#     [string] $inputFilePath
# )

#log dosyamız
$inputFilePath = "C:\Users\103556\Desktop\ps\uninstall_result.txt"
$outputFilePath = "C:\Users\103556\Desktop\ps\output.txt"
#dosyada aradığımız keyword
$keyWord = "*Failed to delete the file*"


#Filter a text file for a given keyword.
function filterTextDocument {
    param (
        $inputFilePath
    )
        $f = foreach($line in [System.IO.File]::ReadLines($inputFilePath))
        {
            if($line -like $keyWord ) {$line}        
        }
        
        return $f   
}

#Fetch dll paths
function getDLL {
    param (
        $f
    )
    $dll = [System.Collections.ArrayList]@()
    foreach($line in $f)
    {
        if ($line -match "'(.*)'")
            {$dll += $matches[1]}
        
    }
    $dll = $dll | Select-Object -Unique
    return $dll 
}

function getResult {
    param (
        $lockedFiles
    )
    $z = foreach($lockedFile in $lockedFiles) { 
        "`n------------------------------------`n" + $lockedFile  + "`n------------------------------------"
        Get-Process | foreach{

            #değişkenleri dönüştürdü
            $processVar = $_;$_.Modules | foreach{
                if($_.FileName -eq $lockedFile){
 
                    #process servis mi ona bakıyor.
                    $serviceName = Get-WmiObject win32_service | ? { $_.ProcessId -like "*$($processVar.id)*" } | select -ExpandProperty Name
                    
                   
                    $processVar.Name + " PID:" + $processVar.id + " Service Name: " + $serviceName + "`n"
                }
            }
        }
    }
    return $z 
}



#fonksyionları çağırdık
$x = filterTextDocument($inputFilePath)
#dll isimlerini dosyaya yazdırıyor. deneme için kullandım.
$x >> deneme1.txt
$lockedFiles = getDll($x)



getResult($lockedFiles) | Out-File -FilePath .\outpuadt1.txt
#sonucu yazdırıyor



#Get-WmiObject win32_service | select -First 2 | select *
#Get-Process | select -First 1 | select * pathnameler eşleşicek



#/ sonrasını alıyor $processPath.Path -replace '.*\\'