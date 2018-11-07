function New-GLPipeline {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Reference
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/pipeline"
        Method     = 'POST'
        Parameters = @{
            ref       = $Reference
        }
    }

    Write-Debug "[New-GLPipeline] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[New-GLPipeline] Response: $Response"

    return $Response
}