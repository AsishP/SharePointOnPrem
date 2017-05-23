$farm = Get-SPFarm 
$cacheService = $farm.Services | where {$_.Name -eq "AppFabricCachingService"}
$accnt = Get-SPManagedAccount -Identity "mining\sp_svc_dist_cache"
$cacheService.ProcessIdentity.CurrentIdentityType = "SpecificUser"
$cacheService.ProcessIdentity.ManagedAccount = $accnt
$cacheService.ProcessIdentity.Update()
$cacheService.ProcessIdentity.Deploy()