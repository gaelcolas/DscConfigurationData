function Import-ConfigurationDataObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path
    )
    
    begin {
    }
    
    process {
        $filesToProcess = Get-ChildItem -Path $Path 

        foreach ($file in $filesToProcess) {
            switch ($file.Extension) {
                '.psd1' { 
                    Get-HashTable -path $file.FullName |
                        foreach-object {
                        $_            
                    }
                }                 
                '.json' {
                    Get-Content $file.FullName -Raw | 
                        ConvertFrom-Json |
                        Foreach-Object {
                        $_ | Convert-PSObjectToHashTable           
                    }
                }
                Default { Write-Verbose "[ConvertFrom-TextFile] Extension for file $($fileToProcess.name) not recognised. Skipping" }
            }
        }
    }
    
    end {
    }
}