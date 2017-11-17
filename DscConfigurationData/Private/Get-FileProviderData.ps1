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
            Default { Get-Content -Raw $FilePath }
        }
    }
}