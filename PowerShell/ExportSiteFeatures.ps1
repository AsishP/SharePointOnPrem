Get-SPSite <siteCollectionURL> | % {

    $results = @()

    Get-SPFeature -Site $_ -Limit All | % {

    $feature = $_; 
        $featuresDefn = (Get-SPFarm).FeatureDefinitions[$_.ID]; 
        $cc = [System.Globalization.CultureInfo]::CurrentCulture;

        $obj = New-Object PSObject;
        $obj | Add-Member NoteProperty  Title  $($featuresDefn.GetTitle($cc));
        $obj | Add-Member NoteProperty  FeatureID  $($_.ID);
        $obj | Add-Member NoteProperty  Hidden $($feature.Hidden);
        $obj | Add-Member NoteProperty  Description $($featuresDefn.GetDescription($cc));
        
        $results += $obj;
    }
    $results | FT -auto;
    $results | Export-Csv "ExportSiteFeatures.csv"
}