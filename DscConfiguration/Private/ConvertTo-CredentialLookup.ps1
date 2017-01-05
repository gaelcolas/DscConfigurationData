function ConvertTo-CredentialLookup
{
    <#
      .SYNOPSIS
      Transforms a @{'UserName'='Password'} to @{'username'=[PSCredential]} for lookup
    
      .DESCRIPTION
      This function takes a hashtable of username/password and creates a lookup directory of
      username/PSCredential objects. This allows a lookup of credentials based on username.
    
      .EXAMPLE
      $LookupDirectory = @{'admin'='P@ssw0rd';'admin2'='P@ssw0rd2'} | ConvertToCredentialLookup
      New-PSSession -ComputerName server01 -Credential $LookupDirectory['admin']
    
      .PARAMETER PasswordHashtable
      A hashtable where the key/value pairs match the username/plainTextPassword respectively.

    #>
    param (
        [parameter(
            ValueFromPipeline,
            Mandatory
        )]
        [System.Collections.Hashtable]
        $PasswordHashtable
    )
    begin
    {
        $CredentialHashtable = @{}
    }
    
    Process
    {
        foreach ($key in $PasswordHashtable.Keys)
        {
            Write-Verbose "Creating new credential for $key"
            $CredentialHashtable.Add($key, (New-Credential -username $key -password $PasswordHashtable[$key]))
        }
    }
    end
    {
        $CredentialHashtable
    }
}
