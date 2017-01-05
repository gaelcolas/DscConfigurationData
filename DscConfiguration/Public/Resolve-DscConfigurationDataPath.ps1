function Resolve-DscConfigurationDataPath {
    [CmdletBinding()]
    param (
        [parameter()]
        [string]
        $Path
    )
    Write-Verbose "Resolving the DSC Configuration Data Path"
    if ( -not ($psboundparameters.containskey('Path')) -or [string]::IsNullOrEmpty($Path)) {
        Write-Verbose "No Path Specified"
        if ([string]::isnullorempty($script:ConfigurationDataPath)) {
            if ($env:ConfigurationDataPath -and (test-path $env:ConfigurationDataPath)) {
                $path = $env:ConfigurationDataPath
                Write-Verbose "Using Configuration Data Path from Environment Variable: $env:ConfigurationDataPath"
            }
            elseif (!$script:ConfigurationDataPath -and (Test-Path (Join-Path $Pwd.Path 'AllNodes'))) {
                $Path = $Pwd.Path
                Write-Verbose "Using ConfigurationData Path from current Directory $Path"
            }
            else {
                Throw "Configuration Data Path not found"
            }
        }
        else {
            $path = $script:ConfigurationDataPath
        }
    }

    if ( -not ([string]::isnullorempty($path)) ) {
        Set-DscConfigurationDataPath -path $path
        Write-Verbose "Dsc Configuration Data Path set to $Path"
    }
}
Set-Alias -Name 'Resolve-ConfigurationDataPath' -Value 'Resolve-DscConfigurationDataPath'

