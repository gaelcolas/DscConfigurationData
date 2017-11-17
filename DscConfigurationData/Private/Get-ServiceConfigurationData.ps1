function Get-ServiceConfigurationData {
    [cmdletbinding()]
    param ()

    $servicePath = Join-Path $script:ConfigurationDataPath 'Services'

    if (($script:ConfigurationData.Services.Keys.Count -eq 0) -and
        (Test-Path -Path $servicePath)) {
        Write-Verbose "Processing Services from $($script:ConfigurationDataPath))."
        foreach ( $item in (Get-ChildItem -Path $servicePath) ) {
            if ($importedObject = Get-FileProviderData -Path $item.FullName) {
                Write-Verbose "Loading data for Service $($item.basename) from $($item.fullname)."
                $script:ConfigurationData.Services.Add($item.BaseName, $importedObject)
            }
        }
    }
}
