function Get-GLSubGroups {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupID,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $SkipGroups,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Search,

        [Parameter(Mandatory = $False)]
        [ValidateSet('name', 'path', 'id')]
        [String]
        $Order = 'name',

        [Parameter(Mandatory = $False)]
        [ValidateSet('asc', 'desc')]
        [String]
        $Sort = 'asc',

        [Parameter(Mandatory = $False)]
        [Switch]
        $AllAvailable,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Statistics,

        [Parameter(Mandatory = $False)]
        [Switch]
        $WithCustomAttributes,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Owned
    )

    $Invoke_GitLabRequest = @{
        Resource   = "groups/$GroupID/subgroups"
        Parameters = @{
            order_by = $Order
            sort = $Sort
        }
    }

    if ($SkipGroups) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('skip_groups', ($SkipGroups -join ','))
    }
    
    if ($Search) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('search', $Search)
    }
    
    if ($Statistics) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('statistics', 'true')
    }

    if ($WithCustomAttributes) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('with_custom_attributes', 'true')
    }

    if ($Owned) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('owned', 'true')
    }

    Write-Debug "[Get-GLSubGroups] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLSubGroups] Results: $Response"

    return $Response
}