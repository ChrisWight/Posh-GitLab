function New-GLProjectFork {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Namespace
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/fork"
        Method     = 'POST'
        Parameters = @{
            namespace = $Namespace
        }
    }

    Write-Debug "[New-GLProjectFork] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[New-GLProjectFork] Response: $Response"

    return $Response
}