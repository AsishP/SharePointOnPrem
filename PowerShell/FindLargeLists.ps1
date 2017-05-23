Add-PSSnapin Microsoft.SharePoint.Powershell -ErrorAction SilentlyContinue
#Lists with values higher than threshold will be returned
[int]$threshold = 5000
[string]$url = "<SiteCollectionURL>"
$results = @()
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
foreach ($list in $(Get-SPWebApplication -Identity $url) | Get-SPSite -Limit ALL | Get-SPWeb -Limit ALL | Get-SPListCollection | where {$_.ItemCount -ge$threshold}){
$o = New-Object –TypeName PSObject
$o | Add-Member –MemberType NoteProperty –Name WebUrl –Value $list.ParentWeb.Url
$o | Add-Member –MemberType NoteProperty –Name ListTitle –Value $list.Title
$o | Add-Member –MemberType NoteProperty –Name ItemCount –Value $list.ItemCount
#Write-Output $o  
#Out-File -FilePath "ExportLargeLists.csv" -Append
$results += $o
}
$results | Export-Csv "ExportLargeLists.csv"