function Get-AllNodesConfigurationData {
    [cmdletbinding()]
    param ()

    $nodePath = Join-Path -Path $script:ConfigurationDataPath -ChildPath 'AllNodes\'

    if (($script:ConfigurationData.AllNodes.Count -eq 0) -and (Test-Path -Path $nodePath)) {
        Write-Verbose "Processing AllNodes from $($script:ConfigurationDataPath)."

        $Script:ConfigurationData.AllNodes = @()
        $script:ConfigurationData.AllNodes += (Import-ConfigurationDataObject -Path $nodePath)
    }
}




