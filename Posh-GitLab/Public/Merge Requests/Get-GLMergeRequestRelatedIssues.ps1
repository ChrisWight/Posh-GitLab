function Get-GLMergeRequestRelatedIssues {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $MergeRequestIID
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectID/merge_requests/$MergeRequestIID/closes_issues"
    }

    Write-Debug "[Get-GLMergeRequestRelatedIssues] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Debug "[Get-GLMergeRequestRelatedIssues] Response: $($Response | Out-String)"

    return $Response
}