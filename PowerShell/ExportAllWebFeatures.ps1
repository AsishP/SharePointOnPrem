$results = @()
Get-SPSite <SiteCollectionURL> |
Get-SPWeb -Limit ALL | % {
    
    Write-Host "Start processing of website - " $_.Title

    $webTitle = $_.Title
    $webURL = $_.Url
    Get-SPFeature -Web $_ -Limit All | % {

    $feature = $_; 
        $featuresDefn = (Get-SPFarm).FeatureDefinitions[$_.ID]; 
        $cc = [System.Globalization.CultureInfo]::CurrentCulture;

        $obj = New-Object PSObject;
        $obj | Add-Member NoteProperty  WebSite  $($webTitle);
        $obj | Add-Member NoteProperty  WebUrl  $($webURL);
        $obj | Add-Member NoteProperty  Title  $($featuresDefn.GetTitle($cc));
        $obj | Add-Member NoteProperty  FeatureID  $($_.ID);
        $obj | Add-Member NoteProperty  Hidden $($feature.Hidden);
        $obj | Add-Member NoteProperty  Description $($featuresDefn.GetDescription($cc));
        
        $results += $obj;
    }
    Write-Host "End processing of website - " $_.Title
 }
$results | Export-Csv "ExportWebFeatures.csv"