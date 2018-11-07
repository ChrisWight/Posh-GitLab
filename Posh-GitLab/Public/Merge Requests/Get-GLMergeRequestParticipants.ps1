function Get-GLMergeRequestParticipants {
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
        Resource = "projects/$ProjectID/merge_requests/$MergeRequestIID/participants"
    }

    Write-Debug "[Get-GLMergeRequestParticipants] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Debug "[Get-GLMergeRequestParticipants] Response: $($Response | Out-String)"

    return $Response
}