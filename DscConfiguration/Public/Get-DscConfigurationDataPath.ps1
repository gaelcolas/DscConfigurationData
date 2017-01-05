function Get-DscConfigurationDataPath {

    $script:ConfigurationDataPath
}
Set-Alias -Name 'Get-ConfigurationDataPath' -Value 'Get-DscConfigurationDataPath'
