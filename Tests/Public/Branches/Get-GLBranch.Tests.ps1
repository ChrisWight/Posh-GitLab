[String]           $ModuleName = 'GitLab-API'
[String]           $ProjectDirectoryName = 'Branches'
[IO.FileInfo]      $PesterFile = [IO.FileInfo] ([String] (Resolve-Path -Path $MyInvocation.MyCommand.Path))
[IO.DirectoryInfo] $ProjectRoot = Split-Path $pesterFile.Directory -Parent
While ((Split-Path $ProjectRoot.FullName -Leaf) -ne $ModuleName) {
    $ProjectRoot = Split-Path $ProjectRoot.FullName -Parent
}
[IO.DirectoryInfo] $PrivateDirectory = ([String] (Join-Path (Join-Path -Path $ProjectRoot.FullName -ChildPath 'GitLab-API' -Resolve) -ChildPath 'Private' -Resolve))
[IO.DirectoryInfo] $ProjectDirectory = ([String] (Get-ChildItem (Join-Path -Path $ProjectRoot.FullName -ChildPath 'GitLab-API' -Resolve) -Filter $ProjectDirectoryName -Directory -Recurse).FullName)
[IO.DirectoryInfo] $ExampleDirectory = ([String] (Get-ChildItem (Join-Path -Path $ProjectRoot.FullName -ChildPath 'Examples' -Resolve) -Filter (($pesterFile.Name).Split('.')[0]) -Directory -Recurse).FullName)
[IO.FileInfo] $TestFile = Join-Path -Path $ProjectDirectory -ChildPath ($pesterFile.Name -replace '\.Tests\.', '.') -Resolve

. $TestFile.FullName
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
        Mock Write-Warning {
            Write-Debug $Message
        }

        Remove-Variable -Scope 'Script' -Name 'RequestResponse' -Force -ErrorAction SilentlyContinue

        Context $Test.Name {
            [hashtable] $Parameters = $Test.Parameters

            if ($Test.Output.Throws) {
                It "Get-GitLabBranch Throws" {
                    { $script:RequestResponse = Get-GitLabBranch @Parameters } | Should Throw
                }
                continue
            }

            It "Get-GitLabBranch" {
                { $script:RequestResponse = Get-GitLabBranch @Parameters } | Should Not Throw
            }
        }
    }
}