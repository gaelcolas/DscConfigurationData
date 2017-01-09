function New-Credential
{
    param (
        [string]
        $username,
        $password
    )

    if ($password -isnot [securestring])
    {
        $password = $password | ConvertTo-SecureString -AsPlainText -Force
    }

    return ([System.Management.Automation.PSCredential]::new($username, $password))
}
