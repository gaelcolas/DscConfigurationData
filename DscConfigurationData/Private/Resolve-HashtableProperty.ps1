function Resolve-HashtableProperty
{
    [OutputType([bool])]
    param (
        [hashtable] $Hashtable,
        [string] $PropertyName,
        [ref] $Value
    )

    $properties = $PropertyName -split '\\'
    $currentNode = $Hashtable

    foreach ($property in $properties)
    {
        if ($currentNode -isnot [hashtable] -or -not $currentNode.ContainsKey($property)) { return $false }
        $currentNode = $currentNode[$property]
    }

    $Value.Value = $currentNode
    return $true
}