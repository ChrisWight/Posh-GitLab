function New-GLPipelineTrigger {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TriggerName
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectID/triggers"
        Method   = 'POST'
        Parameters = @{
            description = $TriggerName
        }
    }

    Write-Debug "[New-GLPipelineTrigger] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[New-GLPipelineTrigger] Response: $Response"

    return $Response
}