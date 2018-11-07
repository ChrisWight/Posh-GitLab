function Restart-GLPipeline {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PipelineID
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/pipelines/$PipelineID/retry"
        Method     = 'POST'
    }

    Write-Debug "[Restart-GLPipeline] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Restart-GLPipeline] Response: $Response"

    return $Response
}