Add-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue
#Find External Lists and their details
[string]$url = "<SiteCollectionURL>"
$results = @()
$count = 0
function Get-SPListCollection {
PARAM
(
[Parameter(ValueFromPipeline=$true)] [Microsoft.SharePoint.SPWeb] $SPWeb
)
BEGIN {
  }
END {
}
PROCESS {
  $SPWeb.Lists
  $SPWeb = $null
  [GC]::Collect()
}
}

Write-Host "Started Processing of Websites with External List"

foreach ($list in $(Get-SPWebApplication -Identity $url) | Get-SPSite -Limit ALL | Get-SPWeb -Limit ALL | Get-SPListCollection | where {$_.HasExternalDataSource -eq $true}){
$o = New-Object –TypeName PSObject
$o | Add-Member –MemberType NoteProperty –Name WebUrl –Value $list.ParentWeb.Url
$o | Add-Member –MemberType NoteProperty –Name ListTitle –Value $list.Title
$o | Add-Member –MemberType NoteProperty –Name DataSourceName –Value $list.DataSource.GetProperty("Entity")
$o | Add-Member –MemberType NoteProperty –Name DataSourceNamespace –Value $list.DataSource.GetProperty("EntityNamespace")
$o | Add-Member –MemberType NoteProperty –Name DataSourceSystem –Value $list.DataSource.GetProperty("LobSystemInstance")
$o | Add-Member –MemberType NoteProperty –Name DataSourceMethod –Value $list.DataSource.GetProperty("SpecificFinder")
#Write-Output $o  
$results += $o
$count++
}
Write-Host "Found " $count " External Lists - End Processing"
$results | Export-Csv "ExportExternalLists.csv"