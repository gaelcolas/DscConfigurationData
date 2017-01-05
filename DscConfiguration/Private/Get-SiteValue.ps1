
function Get-SiteValue
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

    if ($null -eq $Node -or -not $Node.ContainsKey('Location')) { return }

    return Resolve-SiteProperty -PropertyName $PropertyName -ConfigurationData $ConfigurationData -Site $Node.Location
}