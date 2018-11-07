function Compare-GLRepositoryItems {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $From,

        [Parameter(Mandatory = $True, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $To,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Straight
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/repository/compare"
        Parameters = @{
            from     = $From
            to       = $To
        }
    }

    if ($Straight) {
        $Invoke_GitLabRequest.Parameters.Add('straight', 'true')
    }

    Write-Debug "[Compare-GLRepositoryItems] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Compare-GLRepositoryItems] Response: $Response"

    return $Response
}