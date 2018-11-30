[String]           $ModuleName = 'Posh-GitLab'
[IO.FileInfo]      $PesterFile = [IO.FileInfo] ([String] (Resolve-Path -Path $MyInvocation.MyCommand.Path))
[IO.DirectoryInfo] $ProjectRoot = Split-Path $pesterFile.Directory -Parent
While ((Split-Path $ProjectRoot.FullName -Leaf) -ne $ModuleName) {
    $ProjectRoot = Split-Path $ProjectRoot.FullName -Parent
}
[IO.DirectoryInfo] $PrivateDirectory = ([String] (Join-Path (Join-Path -Path $ProjectRoot.FullName -ChildPath 'Posh-GitLab' -Resolve) -ChildPath 'Private' -Resolve))
[IO.DirectoryInfo] $ExampleDirectory = ([String] (Get-ChildItem (Join-Path -Path $ProjectRoot.FullName -ChildPath 'Examples' -Resolve) -Filter (($PesterFile.Name).Split('.')[0]) -Directory -Recurse).FullName)
[IO.FileInfo] $TestFile = Join-Path -Path $PrivateDirectory -ChildPath ($PesterFile.Name -replace '\.Tests\.', '.') -Resolve

# . $TestFile.FullName
Get-ChildItem $PrivateDirectory | % { . $_.FullName }

[System.Collections.ArrayList] $Tests = @()
$Examples = Get-ChildItem $ExampleDirectory "*.psd1" -File

foreach ($Example in $Examples) {
    [Hashtable] $Test = @{
        Name = $Example.BaseName.Replace('_', ' ')
    }
    Write-Verbose "Test: $($Test | ConvertTo-Json)"

    foreach ($ExampleData in (Import-PowerShellDataFile -LiteralPath $Example.FullName).GetEnumerator()) {
        $Test.Add($ExampleData.Name, $ExampleData.Value) | Out-Null
    }

    Write-Verbose "Test: $($Test | ConvertTo-Json)"
    $Tests.Add($Test) | Out-Null
}

Describe $TestFile.Name {
    foreach ($Test in $Tests) {
        Mock Invoke-WebRequest {
            $File = Get-ChildItem (Join-Path -Path $ExampleDirectory -ChildPath 'References' -Resolve) -Filter ('{0}.json' -f $Test.Parameters.Resource) -File
            return (Get-Content $File.FullName | Out-String | ConvertFrom-Json)
        }
        
        Mock Write-Warning {
            Write-Debug $Message
        }

        Remove-Variable -Scope 'Script' -Name 'RequestResponse' -Force -ErrorAction SilentlyContinue
        Remove-Variable -Scope 'Script' -Name 'GitLabAPI' -Force -ErrorAction SilentlyContinue

        if ($test.GitLabAPI) {
            $script:GitLabAPI = $test.GitLabAPI
        }

        Context $Test.Name {
            [hashtable] $Parameters = $Test.Parameters

            if ($Test.Output.Throws) {
                It "Invoke-GLRequest Throws" {
                    { $script:RequestResponse = Invoke-GLRequest @Parameters } | Should Throw
                }
                continue
            }

            It "Invoke-GLRequest" {
                { $script:RequestResponse = Invoke-GLRequest @Parameters } | Should Not Throw
            }

            It "Invoke-GLRequest returns valid type" {
                $script:RequestResponse.GetType().FullName | Should Be $test.Output.Type
            }
        }
    }
}