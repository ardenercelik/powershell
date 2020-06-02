# Parameter help description
Param(
[Parameter(Mandatory=$True,Position=2)][String]$Name, # Parameter help description
[Parameter(Mandatory=$True,Position=1)][String]$Greeting
)


Write-Host $Greeting $Name

# Accepting input from the pipeline.
