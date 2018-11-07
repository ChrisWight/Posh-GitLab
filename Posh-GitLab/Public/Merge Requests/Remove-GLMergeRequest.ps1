function Remove-GLMergeRequest {
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
        Resource = "projects/$ProjectID/merge_requests/$MergeRequestIID"
        Method   = 'DELETE'
    }

    Write-Debug "[Remove-GLMergeRequest] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Debug "[Remove-GLMergeRequest] Response: $($Response | Out-String)"

    return $Response
}