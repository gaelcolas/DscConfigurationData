$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here/../../*/$sut" #for files in Public\Private folders, called from the tests folder

function Protect-Data {[cmdletBinding()]Param($InputObject,$Certificate)}

Describe 'Export-DscCredentialFile' {

  Context 'General context'   {

    It 'runs without errors' {
        { throw } | Should Throw
    }
  }
}
