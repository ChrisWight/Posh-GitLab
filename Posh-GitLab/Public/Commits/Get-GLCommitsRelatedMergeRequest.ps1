function Get-GLCommitsRelatedMergeRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindSpecific')]
        [ValidateNotNullOrEmpty()]
        [String]
        $SHA
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/repository/commits/$SHA/merge_requests"
    }

    Write-Debug "[Get-GLCommitsRelatedMergeRequest] Invoke-GLRequest: $($Invoke_GitLabRequest | Out-String)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLCommitsRelatedMergeRequest] Response: $($Response | Out-String)"

    return $Response
}