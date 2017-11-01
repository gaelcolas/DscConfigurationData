function Get-SiteDataConfigurationData {
    [cmdletbinding()]
    param ()

    $sitePath = Join-Path -Path $script:ConfigurationDataPath -ChildPath 'SiteData'

    if (($script:ConfigurationData.SiteData.Keys.Count -eq 0) -and
        (Test-Path -Path $sitePath)) {
        Write-Verbose "Processing SiteData from $($script:ConfigurationDataPath))."
        foreach ( $item in (Get-ChildItem $sitePath) ) {
            if ($importedObject = Import-ConfigurationDataObject -Path $item.FullName) {
                Write-Verbose "Loading data for site $($item.basename) from $($item.fullname)."
                $script:ConfigurationData.SiteData.Add($item.BaseName, ($importedObject))
            }
        }
    }
}
