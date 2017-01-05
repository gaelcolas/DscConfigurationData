
function Resolve-SiteProperty
{
    [cmdletbinding()]
    param (
        [string]
        $PropertyName,
        [System.Collections.Hashtable]
        $ConfigurationData,
        [string]
        $Site
    )

    $resolved = $null

    Write-Verbose "    Checking Site $Site"
    if (Resolve-HashtableProperty -Hashtable $ConfigurationData -PropertyName "SiteData\$Site\$PropertyName" -Value ([ref] $resolved))
    {
        Write-Verbose "        Found Site Value: $resolved"
        $resolved
    }

    Write-Verbose "    Finished checking Site $Site"
}
