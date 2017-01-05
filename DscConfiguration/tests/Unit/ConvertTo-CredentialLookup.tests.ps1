$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here/../../*/$sut" #for files in Public\Private folders, called from the tests folder

function New-Credential { Param($username,$password) }

Describe 'ConvertTo-CredentialLookup' {

    Mock -CommandName New-Credential -MockWith {param($username,$password) return @{$username = $password} } -Verifiable

    Context 'Basic Test with 1 entry' {
        $testInput = @{'username'='Password'}

        It 'runs without errors by Parameter' {
            { ConvertTo-CredentialLookup -PasswordHashtable $testInput  } | Should Not Throw
        }

        It 'runs without errors by Pipeline input' {
            { $testInput | ConvertTo-CredentialLookup } | Should Not Throw
        }

        It 'Calls New-Credential once for one password'     {
            ConvertTo-CredentialLookup -PasswordHashtable $testInput | Should not BeNullOrEmpty
            { Assert-MockCalled -CommandName New-Credential -Times 1 -Scope It -Exactly } | Should not Throw
        }

        It 'Ensures the value passed to New-Credential are correct' {
            $result = ConvertTo-CredentialLookup -PasswordHashtable $testInput
            $result['username'] | Should BeOfType [hashtable] #In this case, the mock returns hashtable
            $result['username']['username'] | Should beExactly 'Password'
        }
    }
}
