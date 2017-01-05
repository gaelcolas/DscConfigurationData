function Import-LegacyDscCredentialFile
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $EncryptedFilePath
    )

    $DecryptedDataFile = $null

    try
    {
        $DecryptedDataFile = ConvertFrom-EncryptedFile -path $EncryptedFilePath -CertificatePath $script:LocalCertificatePath -ErrorAction Stop

        Write-Verbose "Loading $($DecryptedDataFile.BaseName) into Credentials."
        $Credentials = Get-Hashtable $DecryptedDataFile.FullName -ErrorAction Stop

        return $Credentials | ConvertTo-CredentialLookup
    }
    catch
    {
        throw
    }
    finally
    {
        if ($null -ne $DecryptedDataFile)
        {
            Remove-PlainTextPassword $DecryptedDataFile.FullName
        }
    }
}