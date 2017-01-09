param
(
    [string]
    $ConfigurationDataPath,

    [string]
    $LocalCertificateThumbprint
)

if ([string]::IsNullOrEmpty($LocalCertificateThumbprint))
{
    try
    {
        $LocalCertificateThumbprint = (Get-DscLocalConfigurationManager -ErrorAction Stop).CertificateId
    }
    catch { }
}

if ($LocalCertificateThumbprint)
{
    $LocalCertificatePath = "cert:\LocalMachine\My\$LocalCertificateThumbprint"
}
else
{
    $LocalCertificatePath = ''
}

$ConfigurationData = @{AllNodes=@(); Credentials=@{}; Services=@{}; SiteData =@{}}

Get-ChildItem -Path "$PSScriptRoot\Private" | ForEach-Object {
    . $_.FullName
    Write-Verbose -Message ('Loading {0}' -f $_.BaseName)
}

Get-ChildItem -Path "$PSScriptRoot\Public" | ForEach-Object {
    . $_.FullName
    Write-Verbose -Message ('Loading and exporting {0}' -f $_.BaseName)
    Export-ModuleMember -Function $_.BaseName
} 
