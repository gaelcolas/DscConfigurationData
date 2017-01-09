function New-DscServiceMetadata {
    [cmdletbinding()]
    param (
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Name,
        [string[]]
        $Nodes,
        [string]
        $Path
    )

    begin {
        if ($psboundparameters.containskey('path')) {
                    $psboundparameters.Remove('path') | out-null
        }
        Resolve-ConfigurationDataPath -Path $Path

        $ServicesConfigurationPath = (join-path $script:ConfigurationDataPath 'Services')
    }
    process {
        $OutConfigurationDataFileParams = @{
            Parameters = $psboundparameters
            ConfigurationDataPath = $ServicesConfigurationPath
            DoNotIncludeName = $true
        }
        Out-ConfigurationDataFile @OutConfigurationDataFileParams
    }
}

