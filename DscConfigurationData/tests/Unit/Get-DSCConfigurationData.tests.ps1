Remove-Module DscConfigurationData -ErrorAction SilentlyContinue
Import-Module $PSScriptRoot\..\..\DscConfigurationData.psd1 -Force

Describe "Get-DSCConfigurationData Tests" {
    Set-DscConfigurationDataPath .\TestData\DSC_Configuration
    $ConfigurationData = Get-DscConfigurationData

    Context "AllNodes is in correct format" {
        it "Should be more than one object in AllNodes" {
            $ConfigurationData.AllNodes.Count | Should BeGreaterThan 1
        }

        it "All nodes should be hashtable types" {
            $ConfigurationData.AllNodes.Where({$_ -isnot [Hashtable]}) | Should BeNullOrEmpty
        }
    }

    Context "Valid file types are imported" {

        it "Imports node from psd1 file" {
            $ConfigurationData.AllNodes.Where( {$_.Name -eq 'WebServer01'} ) | Should Not BeNullOrEmpty
        }

        it "Imports node from json file" {
            $ConfigurationData.AllNodes.Where( {$_.Name -eq 'FileServer02'} ) | Should Not Be BeNullOrEmpty
        }

        it "Imports Service from psd1 file" {
            $ConfigurationData.Services.FileServer.ExampleProperty1 | Should Not BeNullOrEmpty
        }

        it "Imports Service from json file" {
            $ConfigurationData.Services.DatabaseServer.ExampleProperty1 | Should Not BeNullOrEmpty
        }

        it "Imports SiteData from psd1 file" {
            $ConfigurationData.SiteData.Site01.Name | Should Not BeNullOrEmpty
        }

        it "Imports SiteData from json file" {
            $ConfigurationData.SiteData.Site03.Name | Should Not BeNullOrEmpty
        }
    }
}