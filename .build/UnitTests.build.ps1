task UnitTests {
    Push-Location "$PSScriptRoot/../*/tests/Unit"
    Invoke-Pester
    Pop-Location
}