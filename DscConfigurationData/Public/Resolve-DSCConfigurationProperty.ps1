function Resolve-DscConfigurationProperty
{
    <#
        .Synopsis
            Searches DSC ConfigurationData metadata for a property. 
        .DESCRIPTION
            Searches DSC ConfigurationData metadata for a property. Getting the value based on this precident:
                $ConfigurationData.AllNodes.Node.Services.Name.PropertyName
                $ConfigurationData.SiteData.SiteName.Services.Name.PropertyName
                $ConfigurationData.Services.Name.PropertyName
                $ConfigurationData.AllNodes.Node.PropertyName
                $ConfigurationData.Sites.Name.PropertyName
                $ConfigurationData.PropertyName
            
            If -RsolutionBehavior AllValues used then array of values returned.

        .EXAMPLE
 $ConfigurationData = @{
                AllNodes = @(
                    @{
                        Name='Web01'
                        DataSource = 'ValueFromNode'
                        Location = 'NY'
                    },
                    @{
                        Name='Web02'
                        DataSource = 'ValueFromNode'
                    },
                    @{
                        Name='Web03'
                        DataSource = 'ValueFromNode'
                    }
                    
                )
                SiteData = @{ 
                    NY = @{ 
                        Services = @{
                            MyTestService = @{
                                DataSource = 'ValueFromSite' 
                            }
                        }
                    } 
                }
                Services = @{
                    MyTestService = @{
                        Nodes = @('Web01', 'Web03')
                        DataSource = 'ValueFromService'
                    }
                } 
            }
            
            Foreach ($Node in $ConfigurationData.AllNodes) {
                
                $Node.Name
                Resolve-DscConfigurationProperty -Node $Node -PropertyName DataSource -ConfigurationData $ConfigurationData 
            }

            Web01
            ValueFromSite
            Web02
            ValueFromNode
            Web03
            ValueFromService
        .EXAMPLE
            $ConfigurationData = @{
                AllNodes = @(
                    @{
                        Name='Web01'
                    },
                    @{
                        Name='Web02'
                    },
                     @{
                        Name='SQL01'
                    }
                    
                )
                SiteData = @{ }
                Services = @{
                    MyTestService = @{
                        Nodes = @('Web[0-9][0-9]')
                        DataSource = 'ValueFromService'
                    }
                } 
            }
            
            Foreach ($Node in $ConfigurationData.AllNodes) {
                
                $Node.Name
                Resolve-DscConfigurationProperty -Node $Node -PropertyName DataSource -ConfigurationData $ConfigurationData -DefaultValue 'ValueFromDefault'
            }


            Web01
            ValueFromService
            Web02
            ValueFromService
            SQL01
            ValueFromDefault    
    #>

    [cmdletbinding()]
    param (
        #The current node being evaluated for the specified property.
        [System.Collections.Hashtable] $Node,

        #By default, all services associated with a Node are checked for the specified Property.  If you want to filter this down to specific service(s), pass one or more strings to this parameter.  Wildcards are allowed.
        [ValidateNotNullOrEmpty()]
        [string[]] $ServiceName = '*',

        #The property that will be checked for.
        [parameter(Mandatory)]
        [string] $PropertyName,

        #By default, all results must return just one entry.  If you want to fetch values from multiple services or from all scopes, set this parameter to 'OneLevel' or 'AllValues', respectively.
        [ValidateSet('SingleValue', 'OneLevel', 'AllValues')]
        [string] $ResolutionBehavior = 'SingleValue',

        #If you want to override the default behavior of checking up-scope for configuration data, it can be supplied here.
        [System.Collections.Hashtable] $ConfigurationData,

        #If the specified PropertyName is not found in the hashtable and you specify a default value, that value will be returned.  If the specified PropertyName is not found and you have not specified a default value, the function will throw an error.
        [object] $DefaultValue
    )

    Write-Verbose ""
    if ($null -eq $ConfigurationData)
    {
        Write-Verbose ""
        Write-Verbose "Resolving ConfigurationData"

        $ConfigurationData = $PSCmdlet.GetVariableValue('ConfigurationData')

        if ($ConfigurationData -isnot [hashtable])
        {
            throw 'Failed to resolve ConfigurationData.  Please confirm that $ConfigurationData is property set in a scope above this Resolve-DscConfigurationProperty or passed to Resolve-DscConfigurationProperty via the ConfigurationData parameter.'
        }
    }
    $value = @()
    $doGetAllResults = $ResolutionBehavior -eq 'AllValues'

    Write-Verbose "Starting to evaluate $($Node.Name) for PropertyName: $PropertyName and resolution behavior: $ResolutionBehavior"

    if ($doGetAllResults -or $Value.count -eq 0)
    {
        $Value += @(Get-ServiceValue -Node $Node -ConfigurationData $ConfigurationData -PropertyName $PropertyName -ServiceName $ServiceName -AllValues:$doGetAllResults)
        Write-Verbose "Value after checking services is $Value"
    }

    if ($doGetAllResults -or $Value.count -eq 0)
    {
        $Value += @(Get-NodeValue -Node $Node -ConfigurationData $ConfigurationData -PropertyName $PropertyName)
        Write-Verbose "Value after checking the node is $Value"
    }

    if ($doGetAllResults -or $Value.count -eq 0)
    {
        $Value += @(Get-SiteValue -Node $Node -ConfigurationData $ConfigurationData -PropertyName $PropertyName)
        Write-Verbose "Value after checking the site is $Value"
    }

    if ($doGetAllResults -or $Value.count -eq 0)
    {
        $Value += @(Get-GlobalValue -ConfigurationData $ConfigurationData -PropertyName $PropertyName)
        Write-Verbose "Value after checking the global is $Value"
    }


    if (($ResolutionBehavior -eq 'SingleValue') -and ($Value.count -gt 1))
    {
        throw "More than one result was returned for $PropertyName for $($Node.Name).  Verify that your property configurations are correct.  If multiples are to be allowed, set -ResolutionBehavior to OneLevel or AllValues."
    }

    if ($Value.count -eq 0)
    {
        if ($PSBoundParameters.ContainsKey('DefaultValue'))
        {
            $Value = $DefaultValue
        }
        else
        {
            throw "Failed to resolve $PropertyName for $($Node.Name).  Please update your node, service, site, or all sites with a default value."
        }
    }

    return $Value
}

Set-Alias -Name 'Resolve-ConfigurationProperty' -Value 'Resolve-DscConfigurationProperty'
