@{
    # Set up a mini virtual environment...
    PSDependOptions = @{
        Target = 'C:\BuildOutput'
        AddToPath = $True
        Parameters = @{
            Force = $True
            Import = $True
        }
    }

    psdeploy = 'latest'
    buildhelpers = 'latest'
    pester = 'latest'
}