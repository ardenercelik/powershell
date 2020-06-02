param (
    [string]$home_to_deinstall = $(throw "Enter ORACLE_HOME to deinstall: ")
)

$folder_to_use="C:\bim"

write "ORACLE_HOME: $home_to_deinstall"
write "FILE FOLDER: $folder_to_use"

if(Test-Path $home_to_deinstall){

	if(Test-Path "$home_to_deinstall\network\admin\tnsnames.ora"){
		write "Discovered TNS: Yes"
		Copy-Item "$home_to_deinstall\network\admin\tnsnames.ora" -Destination $folder_to_use -Force -Confirm:$false | Out-Null
		write "Backed up as: $folder_to_use\tnsnames.ora"
	}

    $deinstall = gci $ORACLE_HOME -recurse -filter 'deinstall.bat' -ErrorAction SilentlyContinue | select -first 1
    if($deinstall){
		$d = rm $env:temp\ora_uninstall\ -Recurse -Force -ErrorAction:SilentlyContinue
		$d = md $env:temp\ora_uninstall\ -ErrorAction:SilentlyContinue
		& $deinstall.FullName -checkonly -o $env:temp\ora_uninstall\ 2>&1
		$response = gci "$env:temp\ora_uninstall\" -recurse -filter '*.rsp' -ErrorAction SilentlyContinue | sort CreationTime -desc | select -first 1
		if(!$response){
			"ORACLE_HOME=$home_to_deinstall" | Out-File -FilePath "$folder_to_use\response.rsp"
			$response = Get-Item "$folder_to_use\response.rsp"
		}

		write "Response File to Use: $($response.Name)"
		write "Please wait while deinstalling..."
		Try{
			& $deinstall.FullName -silent -paramfile $response.FullName 2>&1 | tee -Variable uninstall_result

			# If(Select-String -InputObject $uninstall_result -SimpleMatch "Oracle deinstall tool successfully cleaned up temporary directories."){
				# write "Deinstall completed successfully."
				# Remove-Item "$home_to_deinstall*" -Recurse -Force -Confirm:$false -EA:0
				# write "$home_to_deinstall folder deleted."
			# }else{
				# $f = [System.Collections.ArrayList]@()
				# $uninstall_result | % {
					# If(Select-String -InputObject $_ -SimpleMatch "Failed to delete the file"){
						# if($_ -match "'(.*)'"){ $f += $matches[1] }
					# }
				# }
				# $f = $f | select -Unique
				# Get-Process | foreach{$processVar = $_;$_.Modules | foreach{if($_.FileName -eq $lockedFile){$processVar.Name + " PID:" + $processVar.id}}}
			# }
			
		}Catch{
			write "Deinstall failed. Check logs"
			write $_
		}


	}else{
		Write-Error "deinstall.bat not found in $home_to_deinstall"
	}
}else{
	Write-Error "$home_to_deinstall not found"
}

