
function Get-ServiceValue
{
    [CmdletBinding()]
    param (
        [hashtable] $Node,
        [string] $PropertyName,
        [hashtable] $ConfigurationData,
        [string[]] $ServiceName = '*',
        [switch] $AllValues
    )

    if ($null -eq $Node) { return }

    $servicesTable = $ConfigurationData['Services']
    if ($servicesTable -isnot [hashtable]) { return }

    $resolved = $null
    foreach ($keyValuePair in $servicesTable.GetEnumerator())
    {
        $name = $keyValuePair.Key
        $serviceValue = $keyValuePair.Value

        if (-not (ShouldProcessService -ServiceName $name -Service $serviceValue -Filter $ServiceName -Node $node))
        {
            continue
        }

        Write-Verbose "    Checking Service $name"

        $value = @()

        if ($value.Count -eq 0 -or $AllValues)
        {
            Write-Verbose "        Checking Node override for Service $name"
            if (Resolve-HashtableProperty -Hashtable $Node -PropertyName "Services\$name\$PropertyName" -Value ([ref] $resolved))
            {
                $value += $resolved
            }
        }

        if ($value.Count -eq 0 -or $AllValues)
        {
            Write-Verbose "        Checking Site override for Service $name"

            $siteName = $Node.Location
            if (Resolve-HashtableProperty -Hashtable $ConfigurationData -PropertyName "SiteData\$siteName\Services\$name\$PropertyName" -Value ([ref] $resolved))
            {
                $value += $resolved
            }
        }

        if (($value.Count -eq 0 -or $AllValues) -and $serviceValue -is [hashtable])
        {
            Write-Verbose "        Checking Global value for Service $name"
            if (Resolve-HashtableProperty -Hashtable $serviceValue -PropertyName $PropertyName -Value ([ref] $resolved))
            {
                $value += $resolved
            }
        }

        if ($value.Count -gt 0)
        {
            Write-Verbose "        Found Service Value: $value"
            $value
        }

        Write-Verbose "    Finished checking Service $name"
    }
}