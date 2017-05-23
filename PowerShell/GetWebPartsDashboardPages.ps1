#Enumerate all webparts in Dashboard Pages
function EnumAllWebPartsOfSiteCollection($Url, $WebRelURL) {
    $site = Get-SPSite -Identity $Url
	$web = $site.OpenWeb($WebRelURL) 
    $allFiles = @()
	Write-Host "Processing Web:" $web.Url -NoNewLine
	$pages = $null
	$pages = $web.Lists["Dashboards"]
	if ($pages) {
		foreach ($item in $pages.Items) {
			$allFiles += $item.File
		}
	}
    foreach ($file in $allFiles) {
        $fileUrl = $Url + $file.ServerRelativeUrl
        $manager = $file.GetLimitedWebPartManager([System.Web.UI.WebControls.Webparts.PersonalizationScope]::Shared);
        $wps = $manager.webparts
        $manager.Dispose()
        $wps | select-object @{Expression={$file.Web.Url};Label="Web URL"},@{Expression={$fileUrl};Label="Page URL"}, DisplayTitle, IsVisible, @{Expression={$_.GetType().ToString()};Label="Type"}
    }
	Write-Host " - completed"
}

$row = EnumAllWebPartsOfSiteCollection '<SiteCollectionURL>' '<WebRelativeURL>'
$row | Out-GridView
$row | Export-Csv "ExportWebPartsDashboard.csv"