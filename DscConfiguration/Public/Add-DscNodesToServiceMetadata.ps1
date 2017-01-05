function Add-DscNodesToServiceMetadata {
    Param(
        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [string[]]
        $Nodes,

        [parameter(
            Mandatory,
            ValueFromPipelineByPropertyName
        )]
        [String]
        $Service,

        [string]
        $Path
    )

    begin {
        if ($psboundparameters.containskey('path')) {
                    $psboundparameters.Remove('path') | out-null
        }
        Resolve-ConfigurationDataPath -Path $Path

        $ServicesConfigurationPath = (join-path $script:ConfigurationDataPath 'Services')
        $ServiceFile = Join-Path $ServicesConfigurationPath "$Service.psd1"
        if(!(Test-Path $ServiceFile)) {
            Throw "Service $Service does not exist in Config Data"
        }
    }

    process {
        $ExistingData = Invoke-Expression "Data { $( Get-Content -raw $ServiceFile )}"
        $NodeTokenStart,$NodeTokenEnd = Get-TokenAreaInFile -File $ServiceFile -TokenContent 'Nodes'
        $originalFile = Get-Content -Raw $ServiceFile
        $Nodes =  ($Nodes + $ExistingData.Nodes) | Select -Unique
        $fileContent = $originalFile.Substring(0,$NodeTokenStart.Start) +"Nodes =  '$($Nodes -join "', '")'" + $originalFile.Substring($NodeTokenEnd.Start,$originalFile.Length - $NodeTokenEnd.Start)
        $fileContent | Out-File -FilePath $ServiceFile -Encoding ascii -Force
    }
}