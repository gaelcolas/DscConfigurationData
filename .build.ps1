Param (
    [String[]]
    $GalleryRepository, #used in ResolveDependencies, has default

    [Uri]
    $GalleryProxy #used in ResolveDependencies, $null if not specified
)

Get-ChildItem -Path "$PSScriptRoot/.build/" -Recurse -Include *.ps1 -Verbose |
    Foreach-Object {
        "Importing file $($_.BaseName)" 
        . $_.FullName 
    }

task . ResolveDependencies, SetBuildVariable, UnitTests, DoSomething,FailBuildIfFailedUnitTest, IntegrationTests
#task . ResolveDependencies, SetBuildVariable, UnitTestsStopOnFail, IntegrationTests