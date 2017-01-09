
function Out-ConfigurationDataFile {
    [cmdletbinding()]
    param(
        $Parameters,
        
        $ConfigurationDataPath, 
        
        [switch]
        $DoNotIncludeName,

        [switch]
        $Force
    )

    $StartingBlock = "@{"
    $EndingBlock = "}"
    $ExcludedParameters = [System.Management.Automation.Internal.CommonParameters].GetProperties().Name
    if ($DoNotIncludeName) {
        $ExcludedParameters += 'Name'
    }
    $ofs = "', '"

    $configuration = @(
        $StartingBlock
        foreach ($key in $Parameters.keys) {
            if ($ExcludedParameters -notcontains $key )
            {
                "    $key = '$($Parameters[$key])'"
            }
        }
        $EndingBlock
    )
    if (!(Test-Path (Join-Path $ConfigurationDataPath "$($Parameters['Name']).psd1")) -or $Force) {
        $configuration | Out-File (Join-Path $ConfigurationDataPath "$($Parameters['Name']).psd1") -Encoding Ascii
    }
    else {
        Write-Warning "Data not saved, file already exists. Use -Force to overwrite."
    }
}
