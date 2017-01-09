function Get-DscEncryptedPassword
{
    [cmdletbinding(DefaultParameterSetName='ByStoreName')]
    param (
        [parameter(
            ParameterSetName = 'ByStoreName',
            ValueFromPipelineByPropertyName,
            Mandatory
        )]
        [Alias('BaseName')]
        [string]
        $StoreName,

        [parameter(
            ParameterSetName = 'ByStoreName'
        )]
        [string]
        $Path = (Join-path $script:ConfigurationDataPath 'Credentials'),
        
        [parameter(
            ParameterSetName = 'ByPipeline',
            ValueFromPipelineByPropertyName,
            Mandatory
        )]
        [Alias('FullName')]
        [string]
        $EncryptedFilePath,
        
        [parameter()]
        [string[]]
        $UserName
    )

    begin
    {
        if (-not $script:LocalCertificatePath -or -not (Test-Path -LiteralPath $script:LocalCertificatePath))
        {
            throw 'You must first set the local encryption certificate before calling Get-DscEncryptedPassword.  Use the Set-DscConfigurationCertificate command.'
        }
    }

    process
    {
        if (Test-LocalCertificate)
        {
            if (-not $PSBoundParameters.ContainsKey('EncryptedFilePath'))
            {
                $EncryptedFilePath = Join-Path $Path "$StoreName.psd1.encrypted"
            }

            Write-Verbose "Decrypting $EncryptedFilePath."
            $hashtable = $null

            try
            {
                $hashtable = Import-DscCredentialFile -Path $EncryptedFilePath -ErrorAction Stop
            }
            catch
            {
                Write-Error "Could not import encrypted credentials from file '$EncryptedFilePath': $($_.Exception.Message)"
                return
            }

            if ($PSBoundParameters.ContainsKey('UserName'))
            {
                $newHashTable = @{}
                foreach ($user in $UserName)
                {
                    $newHashTable[$user] = $hashtable[$user]
                }
                $hashtable = $newHashTable
            }

            return $hashtable
        }
    }
}
