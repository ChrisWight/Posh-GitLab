function Approve-GLMergeRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $MergeRequestIID,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CommitMessage,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SHA,

        [Parameter(Mandatory = $False)]
        [Switch]
        $RemoveSourceBranch,

        [Parameter(Mandatory = $False)]
        [Switch]
        $MergeWhenPipelineSucceeds
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectID/merge_requests/$MergeRequestIID/merge"
        Method   = 'PUT'
        Parameters = @{}
    }

    if ($CommitMessage) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('merge_commit_message', $CommitMessage)
    }

    if ($SHA) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('sha', $SHA)
    }

    if ($RemoveSourceBranch) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('should_remove_source_branch', 'true')
    }

    if ($MergeWhenPipelineSucceeds) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('merge_when_pipeline_succeeds', 'true')
    }

    Write-Debug "[Approve-GLMergeRequest] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"
    
    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Debug "[Approve-GLMergeRequest] Response: $($Response | Out-String)"

    return $Response
}