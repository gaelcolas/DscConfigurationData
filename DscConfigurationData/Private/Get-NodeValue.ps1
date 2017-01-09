function Get-NodeValue
{
    [cmdletbinding()]
    param (
        [System.Collections.Hashtable]
        $Node,
        [string]
        $PropertyName,
        [System.Collections.Hashtable]
        $ConfigurationData
    )

    if ($null -eq $Node) { return }

    $resolved = $null

    Write-Verbose "    Checking Node: $($Node.Name)"

    if (Resolve-HashtableProperty -Hashtable $Node -PropertyName $PropertyName -Value ([ref] $resolved))
    {
        Write-Verbose "        Found Node Value: $resolved"
        $resolved
    }

    Write-Verbose "    Finished checking Node $($Node.Name)"
}