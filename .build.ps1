Param (
    [String[]]
    $GalleryRepository, #used in ResolveDependencies, has default

    [Uri]
    $GalleryProxy #used in ResolveDependencies, $null if not specified
)
Get-ChildItem -Path "$PSScriptRoot/.build/" -Recurse -Include *.build.ps1 -Verbose |
    Foreach-Object {
        Write-Verbose "Importing task file $($_.BaseName)" 
        . $_.FullName 
    }

task . ResolveDependencies, {
    'Default Task Reached'
}