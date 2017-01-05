function Set-DscConfigurationCertificate {
    param (
        [parameter(Mandatory)]
        [string]
        $CertificateThumbprint
    )

    $path = "Cert:\LocalMachine\My\$CertificateThumbprint"

    if (Test-Path -Path $path)
    {
        $script:LocalCertificateThumbprint = $CertificateThumbprint
        $script:LocalCertificatePath = $path
    }
    else
    {
        throw "Certificate '$Thumbprint' does not exist in the Local Computer\Personal certificate store."
    }
}
