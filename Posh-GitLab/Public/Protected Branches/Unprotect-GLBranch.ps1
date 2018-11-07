function Unprotect-GLBranch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $BranchName
    )

    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/protected_branches/$BranchName"
        Method         = 'DELETE'
    }
    
    Write-Debug "[Unprotect-GLBranch] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Unprotect-GLBranch] Response: $($Response | Out-String)"

    return $Response
}