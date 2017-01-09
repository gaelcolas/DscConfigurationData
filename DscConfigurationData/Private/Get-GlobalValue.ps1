
function Get-GlobalValue
{
    [cmdletbinding()]
    param (
        [string]
        $PropertyName,
        [System.Collections.Hashtable]
        $ConfigurationData
    )

    return Resolve-SiteProperty -ConfigurationData $ConfigurationData -PropertyName $PropertyName -Site All
}
