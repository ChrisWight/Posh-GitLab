function Get-GLBranch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,

        [Parameter(Mandatory = $False, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $BranchName
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectID/repository/branches"
    }

    if ($BranchName) {
        $Invoke_GitLabRequest.Resource = ('{0}/{1}' -f $Invoke_GitLabRequest.Resource, $BranchName)
    }

    Write-Debug "[Get-GLBranch] Invoke-GLRequest: $($Invoke_GitLabRequest | Out-String)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLBranch] Response: $($Response | Out-String)"
    
    return $Response
}