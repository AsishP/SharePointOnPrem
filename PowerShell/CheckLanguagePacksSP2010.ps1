# PowerShell script to display SharePoint products from the registry.

# location in registry to get info about installed software

$RegLoc = Get-ChildItem HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall

# Get SharePoint Products and language packs

write-host "Products and Language Packs"
write-host "-------------------------------------------"

$Programs = $RegLoc | 
	where-object { $_.PsPath -like "*\Office*" } | 
	foreach {Get-ItemProperty $_.PsPath} 

# output the info about Products and Language Packs

$Programs | fl DisplayName, DisplayVersion