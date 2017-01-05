
function ShouldProcessService
{
    param (
        [string] $ServiceName,
        [hashtable] $Service,
        [string[]] $Filter = '*',
        [hashtable] $Node
    )

    $isNodeAssociatedWithService = ($Node.Name -and (Find-NodeInService -Node $Node -ServiceNodes $Service.Nodes)) -or
                                   ($Node['MemberOfServices'] -contains $ServiceName)

    if (-not $isNodeAssociatedWithService)
    {
        return $false
    }

    foreach ($pattern in $Filter)
    {
        if ($ServiceName -like $pattern)
        {
            return $true
        }
    }

    return $false
}