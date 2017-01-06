task IntegrationTests {
    Push-Location "$PSScriptRoot/../*/tests/Integration"
    Invoke-Pester
    Pop-Location
}