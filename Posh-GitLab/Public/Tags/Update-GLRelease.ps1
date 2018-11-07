function Update-GLRelease {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TagName,

        [Parameter(Mandatory = $True, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Description
    )

    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/repository/tags/$TagName/release"
        Method         = 'POST'
        Parameters     = @{
            description = $Description
        }
    }

    Write-Debug "[Update-GLRelease] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Update-GLRelease] Response: $Response"
    
    return $Response
}