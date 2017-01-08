Param (
    [String[]]
    $GalleryRepository = (property GalleryRepository 'PSGallery'), #propagate the property if set, or use default

    [uri]
    $GalleryProxy = $(try { property GalleryProxy } catch { }), #propagate or use $null

    [pscredential]
    $GalleryPSCredential = $(try { property GalleryPSCredential } catch { }), #propagate or use $null

    [string]
    $LineSeparation = (property LineSeparation ('-' * 78)) 
)

task InstallPSDepends {
    $LineSeparation
    "Installing PSDepends from $GalleryRepository"
    ""
    "`tProxy = $GalleryProxy"
    "`tCredentialUser = $($GalleryPSCredential.UserName)"

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
    $LineSeparation
    'Resolving Dependencies'
    Invoke-PSDepend .\Dependencies.psd1 -Force
}

task ResolveTasksModuleDependencies {
    #look at each tasks' `#require -Modules` statements
    # Download the module if not present
}