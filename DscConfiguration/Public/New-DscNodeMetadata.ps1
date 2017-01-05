function New-DscNodeMetadata
{
    <#
        .Synopsis
            Creates a new Dsc metadata file describing a node.
        .Description
            Create a new Dsc metadata file to populate AllNodes in a Dsc Configuration.
        .Example
            New-DscNodeMetadata -Name NY-TestSQL01 -Location NY -ServerType VM
        .Example
            New-DscNodeMetadata -Name NY-TestService01 -Location NY -ServerType Physical
    #>
    param
    (
        #Server name, same as ActiveDirectory server account name.
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            Position = 1
        )]
        [string]
        $Name,

        #Data center or site the server is in.
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName,
            Position = 2
        )]
        [string]
        $Location,

        #Unique identifier for this node.  Will automatically generate one if not supplied.
        [parameter(
            ValueFromPipelineByPropertyName
        )]
        [ValidateNotNullOrEmpty()]
        [string]
        $NodeName,

        #Path to the AllNodes subfolder in the configuration data folder.
        #Defaults to ${repository root}/Configuration/AllNodes
        [parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $MemberOfServices = @(),

        [switch]
        $Force
    )
    begin
    {
        if ($psboundparameters.containskey('path')) {
                    $psboundparameters.Remove('path') | out-null
        }
        Write-Verbose "Resolving Path for ConfigData"
        Resolve-ConfigurationDataPath -Path $Path -Verbose:([bool]$psboundparameters['verbose'])
        
        $AllNodesConfigurationPath = (join-path $script:ConfigurationDataPath 'AllNodes')
        Write-Verbose "Using $AllNodesConfigurationPath for AllNodes Path"
    }
    process
    {
        if (-not $psboundparameters.containskey('NodeName')){
            $psboundparameters.Add('NodeName', $Name)
            Write-Verbose "Adding $name as WMF5 Named Configuration NodeName."
        }
        $psboundparameters.Remove('Force') | Out-Null
        Out-ConfigurationDataFile -Parameters $psboundparameters -ConfigurationDataPath $AllNodesConfigurationPath -Force:([bool]$Force)
    }
}

function New-DscServiceMetadata {
    [cmdletbinding()]
    param (
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string]
        $Name,
        [string[]]
        $Nodes,
        [string]
        $Path
    )

    begin {
        if ($psboundparameters.containskey('path')) {
                    $psboundparameters.Remove('path') | out-null
        }
        Resolve-ConfigurationDataPath -Path $Path

        $ServicesConfigurationPath = (join-path $script:ConfigurationDataPath 'Services')
    }
    process {
        $OutConfigurationDataFileParams = @{
            Parameters = $psboundparameters
            ConfigurationDataPath = $ServicesConfigurationPath
            DoNotIncludeName = $true
        }
        Out-ConfigurationDataFile @OutConfigurationDataFileParams
    }
}

function New-DscSiteMetadata {
    [cmdletbinding()]
    param (
        [string]
        $Name,
        [string]
        $Path
    )

    begin {
        if ($psboundparameters.containskey('path')) {
                    $psboundparameters.Remove('path') | out-null
        }
        Resolve-ConfigurationDataPath -Path $Path

        $SiteDataConfigurationPath = (join-path $script:ConfigurationDataPath 'SiteData')
    }
    process {
        Out-ConfigurationDataFile -Parameters $psboundparameters -ConfigurationDataPath $SiteDataConfigurationPath
    }
}



