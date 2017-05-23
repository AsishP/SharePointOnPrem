$webappUrl = "http://localhost" 
$webapp = Get-SPWebApplication $webappUrl 
$allWebsCount = 0 
$webapp.Sites | % { $allWebsCount += $_.AllWebs.Count; $_.Dispose(); } 
 
Write-Host "There are" $allWebsCount "webs" -ForegroundColor Green