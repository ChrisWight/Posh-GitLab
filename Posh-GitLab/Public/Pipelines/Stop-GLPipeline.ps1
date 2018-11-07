function Stop-GLPipeline {
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
        Resource   = "projects/$ProjectID/pipelines/$PipelineID/cancel"
        Method     = 'POST'
    }

    Write-Debug "[Stop-GLPipeline] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Stop-GLPipeline] Response: $Response"

    return $Response
}