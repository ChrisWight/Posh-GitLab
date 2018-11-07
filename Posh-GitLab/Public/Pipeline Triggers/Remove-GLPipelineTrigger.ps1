function Remove-GLPipelineTrigger {
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
        Resource = "projects/$ProjectID/triggers/$TriggerID"
        Method   = 'DELETE'
    }

    Write-Debug "[Remove-GLPipelineTrigger] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Remove-GLPipelineTrigger] Response: $Response"

    return $Response
}