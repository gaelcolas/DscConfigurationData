function Get-TokenAreaInFile {
    Param(
        [Io.FileInfo]
        $file,

        [String]
        $TokenContent = 'Nodes'
    )

    $code = (Get-Content -Raw $file)
    $AST = [System.Management.Automation.PSParser]::Tokenize($code,[ref]$null)
    $NodeStart = $AST.where{$_.Content -eq $TokenContent -and $_.Type -eq 'Member'}

    $lastToken = $null
    Foreach ($Token in $AST) {
        if( $Token.Start -gt $NodeStart.Start -and
            (
                $Token.Type -eq 'StatementSeparator' -or
                    $Token.Type -eq 'NewLine' -and $lastToken.Type -ne 'Operator'
            )
        ) {
            $NodeEnd = $Token
            Break
        }
        $lastToken = $Token
    }
    #$AST | ? { $_.Start -gt $NodeStart.Start -and $_.Start -lt $NodeEnd.Start}
    return $NodeStart,$NodeEnd
}