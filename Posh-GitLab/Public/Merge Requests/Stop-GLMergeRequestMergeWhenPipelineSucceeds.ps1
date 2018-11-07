function Stop-GLMergeRequestMergeWhenPipelineSucceeds {
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
        Resource = "projects/$ProjectID/merge_requests/$MergeRequestIID/cancel_merge_when_pipeline_succeeds"
        Method   = 'PUT'
    }

    Write-Debug "[Stop-GLMergeRequestMergeWhenPipelineSucceeds] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Debug "[Stop-GLMergeRequestMergeWhenPipelineSucceeds] Response: $($Response | Out-String)"

    return $Response
}