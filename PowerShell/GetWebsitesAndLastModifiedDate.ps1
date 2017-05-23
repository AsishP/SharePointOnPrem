$results = @()
$gc = Start-SPAssignment
$site= $gc | get-spsite -Identity https://sitecollectionURL
Write-Host "Start processing ...."
foreach($web in $site.AllWebs)
{
    $obj = New-Object PSObject;
    $obj | Add-Member NoteProperty  WebSite  $($web.Title);
    $obj | Add-Member NoteProperty  WebUrl  $($web.URL);
    $obj | Add-Member NoteProperty  WebServerRelativeUrl  $($web.ServerRelativeUrl);
    $obj | Add-Member NoteProperty  LastContentModifiedDate  $($web.LastItemModifiedDate);
    $obj | Add-Member NoteProperty  Author  $($web.Author);
    $results += $obj;
}
Stop-SPAssignment $gc
Write-Host "End processing"
$results | Export-Csv "ExportWebSitesAndModifiedDate.csv"