#require -Module ProtectedData
function Export-DscCredentialFile
{
    <#
      .SYNOPSIS
      Create a PSD1 file with a list of UserName = EncryptedCredential
    
      .DESCRIPTION
      This function encrypts the Credential parts of an hashtable looking like
      @{'key1' = [PSCredential];'key2' = [PSCredential];}
      before creating a PSD1 file out of this data, looking like:
      @{
          'UserName1' = 'MUvk0a1JIRz79Zw6B08nnMy4OG222pRBzvGxmQ6QCIVi7936kxfC3ATwMK...'
          'UserName2' = 'crCcrLoQmFwI5wS7jm0B7To1M0HzQvlZVS4KKy22VJSk1rYJFtkBWisvwS...'
      }
    
      .EXAMPLE
      $secpasswd = ConvertTo-SecureString 'P@ssw0rd' -AsPlainText -Force
      $mycreds = New-Object System.Management.Automation.PSCredential ('username', $secpasswd)
      Export-DscCredentialFile -Hashtable (@{'username'=$secpasswd}) -Path C:\DSC_Configuration\Credentials\PasswordStore.encrypted.psd1
    
      .PARAMETER Hashtable
      The Hashtable parameter is a lookup hashtable with the Username as key and the [PSCredential] as value.
    
      .PARAMETER Path
      The Path parameter is the full Path where you want the encrypted password stored.
      
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable] $Hashtable,

        [Parameter(Mandatory)]
        [string] $Path
    )

    Write-Verbose "Encrypting $($Hashtable.Count) credentials for export."

    $newTable = @{}

    try
    {
        foreach ($key in $HashTable.Keys)
        {
            Write-Verbose "Encrypting credential of user $key"

            $protectedData = Protect-Data -InputObject $HashTable[$key] -Certificate $script:LocalCertificatePath -ErrorAction Stop
            $xml = [System.Management.Automation.PSSerializer]::Serialize($protectedData, 5)
            $bytes = [System.Text.Encoding]::UTF8.GetBytes($xml)
            $base64 = [System.Convert]::ToBase64String($bytes)

            $newTable[($key)] = $base64
        }
    }
    catch
    {
        throw
    }

    Write-Verbose "Encryption complete.  Saving credentials to file $Path"

    '@{' | Out-File $Path -Encoding utf8
    foreach ($key in $newTable.Keys)
    {
        "    '$key' = '$($newTable[$key])'" | Out-File $Path -Append -Encoding utf8
    }
    '}' | Out-File $Path -Append -Encoding utf8
}
