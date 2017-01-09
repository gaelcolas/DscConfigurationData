
function Find-NodeInService
{
    [CmdletBinding()]
    [OutputType([bool])]
    Param
    (
        # ConfigurationData Node Hashtable     
        [hashtable]
        $Node,

        # ConfigurationData Service Node Array
        [String[]]
        $ServiceNodes
    )
    foreach ($serviceNode in $ServiceNodes) 
    {
        
        if ($serviceNode.IndexOfAny('\.$^+?{}[]') -ge 0)
        {
           Write-Verbose   "Checking if Node [$($node.Name)] -match [$serviceNode]"
            if ($node.Name -Match $serviceNode)
            {
                
               return $true
            }

        }
        elseif ($serviceNode.contains('*'))
        {
            
           Write-Verbose   "Checking if Node [$($node.Name)] -like [$serviceNode]"
            if ($node.Name -like $serviceNode)
            {
               
               return $true
            }
        }
        else 
        {
           Write-Verbose   "Checking if Node [$($node.Name)] -eq [$serviceNode]"
            if ($node.Name -eq $serviceNode)
            {
               return  $true
            }
        }
    }
    return $false
}
