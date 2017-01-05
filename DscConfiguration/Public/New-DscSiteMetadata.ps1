function New-DscSiteMetadata {
    [cmdletbinding()]
    param (
        [string]
        $Name,
        [string]
        $Path
    )

    begin {
        if ($psboundparameters.containskey('path')) {
                    $psboundparameters.Remove('path') | out-null
        }
        Resolve-ConfigurationDataPath -Path $Path

        $SiteDataConfigurationPath = (join-path $script:ConfigurationDataPath 'SiteData')
    }
    process {
        Out-ConfigurationDataFile -Parameters $psboundparameters -ConfigurationDataPath $SiteDataConfigurationPath
    }
}

