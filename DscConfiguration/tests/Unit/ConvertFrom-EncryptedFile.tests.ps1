$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here/../../*/$sut" #for files in Public\Private folders, called from the tests folder

Describe 'ConvertFrom-EncryptedFile' {

  Context 'General context'   {

    It 'runs without errors' {
        { ConvertFrom-EncryptedFile } | Should Not Throw
    }
    It 'does something' {
      
    }
    It 'does not return anything'     {
      ConvertFrom-EncryptedFile | Should BeNullOrEmpty 
    }
  }
}
