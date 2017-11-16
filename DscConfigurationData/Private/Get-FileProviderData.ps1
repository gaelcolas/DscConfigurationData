#Requires -module powershell-yaml
#Using Module Datum

function Get-FileProviderData {
    [CmdletBinding()]
    Param(
        $Path,

        [AllowNull()]
        $DataOptions
    )
    foreach ($File in (get-childitem -Path $Path -File)) {
        $FilePath = $File.FullName
        Write-Verbose "Getting File Provider Data for Path: $FilePath"
        switch ($File.Extension) {
            '.psd1' { Import-PowerShellDataFile $FilePath | ConvertTo-Hashtable}
            '.json' { Get-Content -Raw $FilePath | ConvertFrom-Json | ConvertTo-Hashtable }
            '.yml' { convertfrom-yaml (Get-Content -raw $FilePath) | ConvertTo-Hashtable }
            '.ejson' { Get-Content -Raw $FilePath | ConvertFrom-Json | ConvertTo-ProtectedDatum -UnprotectOptions $DataOptions}
            '.eyaml' { ConvertFrom-Yaml (Get-Content -Raw $FilePath) | ConvertTo-ProtectedDatum -UnprotectOptions $DataOptions}
            '.epsd1' { Import-PowerShellDatafile $FilePath | ConvertTo-ProtectedDatum -UnprotectOptions $DataOptions}
            Default { Get-Content -Raw $FilePath }
        }
    }
}