function Get-GLProtectedBranch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $False, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $BranchName
    )

    $Invoke_GitLabRequest = @{
        'Resource' = "projects/$ProjectID/protected_branches/$BranchName"
    }

    Write-Debug "[Get-GLProtectedBranch] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLProtectedBranch] Response: $($Response | Out-String)"

    return $Response
}