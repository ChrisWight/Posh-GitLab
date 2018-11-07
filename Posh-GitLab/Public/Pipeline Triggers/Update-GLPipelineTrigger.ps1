function Update-GLPipelineTrigger {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TriggerID,

        [Parameter(Mandatory = $False, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TriggerName
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectID/triggers/$TriggerID"
        Method   = 'PUT'
        Parameters = @{
            description = $TriggerName
        }
    }

    Write-Debug "[Update-GLPipelineTrigger] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Update-GLPipelineTrigger] Response: $Response"

    return $Response
}