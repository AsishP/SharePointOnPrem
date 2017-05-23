# Copied from: https://sharepoint.stackexchange.com/questions/12847/how-do-i-find-in-which-subsites-a-webpart-feature-is-used
# Basis: http://www.glynblogs.com/2011/07/listing-all-web-parts-in-a-site-collection-with-powershell.html
# Modified by http://sharepoint.stackexchange.com/users/2509/tarjeieo
function EnumAllWebPartsOfSiteCollection($Url) {
    $site = new-object Microsoft.SharePoint.SPSite $Url 
    $allFiles = @()
    foreach($web in $site.AllWebs) {
        Write-Host "Processing Web:" $web.Url -NoNewLine
        if ([Microsoft.SharePoint.Publishing.PublishingWeb]::IsPublishingWeb($web)) {
            $pWeb = [Microsoft.SharePoint.Publishing.PublishingWeb]::GetPublishingWeb($web)
            $pages = $pWeb.PagesList

            foreach ($item in $pages.Items) {
                $allFiles += $item.File
            }
        }
        $pages = $null
        $pages = $web.Lists["Site Pages"]
        if ($pages) {
            foreach ($item in $pages.Items) {
                $allFiles += $item.File
            }
        }
        foreach ($file in $web.Files) {
            $allFiles += $file
        }
        $web.Dispose()
        Write-Host " - completed"
    }
    foreach ($file in $allFiles) {
        $fileUrl = $Url + $file.ServerRelativeUrl
        $manager = $file.GetLimitedWebPartManager([System.Web.UI.WebControls.Webparts.PersonalizationScope]::Shared);
        $wps = $manager.webparts
        $manager.Dispose()
        $wps | select-object @{Expression={$file.Web.Url};Label="Web URL"},@{Expression={$fileUrl};Label="Page URL"}, DisplayTitle, IsVisible, @{Expression={$_.GetType().ToString()};Label="Type"}
    }
    $site.Dispose()
}

$row = EnumAllWebPartsOfSiteCollection('http://test:1337')
$row | Out-GridView