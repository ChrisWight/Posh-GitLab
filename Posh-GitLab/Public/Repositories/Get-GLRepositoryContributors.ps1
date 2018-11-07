function Get-GLRepositoryContributors {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,
        
        [Parameter(Mandatory = $False)]
        [ValidateSet('Name', 'Email', 'Commits')]
        [String]
        $OrderBy = 'commits',

        [Parameter(Mandatory = $False)]
        [ValidateSet('asc', 'desc')]
        [String]
        $SortBy = 'desc'
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/repository/contributors"
        Parameters = @{
            order_by = $OrderBy.ToLower()
            sort     = $SortBy.ToLower()
        }
    }

    Write-Debug "[Get-GLRepositoryContributors] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Debug "[Get-GLRepositoryContributors] Response: $Response"

    return $Response
}