Param (
    [String[]]
    $GalleryRepository = (property GalleryRepository 'PSGallery'), #propagate the property if set, or use default

    [uri]
    $GalleryProxy = (. { try { property GalleryProxy } catch { } } ), #propagate or use $null

    [pscredential]
    $GalleryPSCredential = (. { try { property GalleryPSCredential } catch { } } ) #propagate or use $null
)

task InstallPSDepends {
    "Installing PSDepends from $GalleryRepository"
    "Proxy = $GalleryProxy"
    $installModuleParams = @{
        Name = 'PSDepend'
        Repository = @($GalleryRepository)
    }
    if ($GalleryPSCredential) {
        $installModuleParams.Add('Credential',$GalleryPSCredential)
    }
    Install-Module @installModuleParams
}

task ResolveDependencies InstallPSDepends, {
    'Resolving Dependencies'
    Invoke-PSDepend .\Dependencies.psd1 -Force
}

task SetBuildEnvironment ResolveDependencies, {
    'Set-BuildEnvironment'
    Set-BuildEnvironment
}


task ResolveTasksModuleDependencies {
    #look at each tasks' `#require -Module` statements
    # Download the module if not present
}