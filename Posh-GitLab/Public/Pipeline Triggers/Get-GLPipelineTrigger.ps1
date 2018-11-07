function Get-GLPipelineTrigger {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $False, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TriggerID
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectID/triggers"
    }

    if ($TriggerID) {
        $Invoke_GitLabRequest.Resource = ('{0}/{1}' -f $Invoke_GitLabRequest.Resource, $TriggerID)
    }

    Write-Debug "[Get-GLPipelineTrigger] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLPipelineTrigger] Response: $Response"

    return $Response
}