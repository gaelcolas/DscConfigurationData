#From Chris Dent's BuildTask repo
#https://github.com/indented-automation/BuildTools/blob/master/build_tasks.ps1

Task MergeModule {
    # Merge individual PS1 files into a single PSM1.
    
    # Use the same case as the manifest.
    $moduleName = (Get-Item "source\$moduleName.psd1").BaseName

    $fileStream = New-Object System.IO.FileStream("$projectPath\$Script:version\$moduleName.psm1", 'Create')
    $writer = New-Object System.IO.StreamWriter($fileStream)

    Get-ChildItem 'source' -Filter *.ps1 -Recurse | Where-Object { $_.FullName -notlike "*source\examples*" -and $_.Extension -eq '.ps1' } | ForEach-Object {
        Get-Content $_.FullName | ForEach-Object {
            $writer.WriteLine($_.TrimEnd())
        }
        $writer.WriteLine()
    }

    if (Test-Path 'source\InitializeModule.ps1') {
        $writer.WriteLine('InitializeModule')
    }

    $writer.Close()
    $fileStream.Close()
}