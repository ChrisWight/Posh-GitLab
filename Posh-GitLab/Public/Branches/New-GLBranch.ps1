function New-GLBranch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $BranchName,

        [Parameter(Mandatory = $True, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SourceBranch
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/repository/branches"
        Method     = "POST"
        Parameters = @{
            branch = $BranchName
            ref    = $SourceBranch
        }
    }

    Write-Debug "Invoke-GLRequest: $($Invoke_GitLabRequest | Out-String)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[New-GLBranch] Response: $($Response | Out-String)"
    
    return $Response
}