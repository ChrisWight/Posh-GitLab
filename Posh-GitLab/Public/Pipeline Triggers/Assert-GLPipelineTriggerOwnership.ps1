function Assert-GLPipelineTriggerOwnership {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TriggerID
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectID/triggers/$TriggerID/take_ownership"
        Method   = 'POST'
    }

    Write-Debug "[Assert-GLPipelineTriggerOwnership] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Assert-GLPipelineTriggerOwnership] Response: $Response"

    return $Response
}