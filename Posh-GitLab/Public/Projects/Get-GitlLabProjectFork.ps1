function Get-GitlLabProjectFork {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $False, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Search,

        [ValidateSet('public', 'internal', 'private')]
        [String]
        $Visibility,

        [ValidateSet('id', 'name', 'path', 'created_at', 'updated_at', 'last_activity_at')]
        [String]
        $OrderBy = 'created_at',

        [ValidateSet('asc', 'desc')]
        [String]
        $Sort = 'desc',

        [Switch]
        $Archived,

        [Switch]
        $Simple,

        [Switch]
        $Owned,

        [Switch]
        $Membership,

        [Switch]
        $Starred,

        [Switch]
        $Statistics,

        [Switch]
        $WithCustomAttributes,

        [Switch]
        $WithIssuesEnabled,

        [Switch]
        $WithMergeRequestsEnabled,

        [ValidateSet('Guest', 'Reporter', 'Developer', 'Maintainer', 'Owner')]
        [String]
        $MinimumAccessLevel
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/forks"
        Parameters = @{
            order_by = $OrderBy
            sort     = $Sort
        }
    }

    if ($Search) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('search', $Search)
    }

    if ($Visibility) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('visibility', $Visibility)
    }

    if ($Archived) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('archived', 'true')
    }

    if ($Simple) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('simple', 'true')
    }

    if ($Owned) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('owned', 'true')
    }

    if ($Membership) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('membership', 'true')
    }

    if ($Starred) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('starred', 'true')
    }

    if ($Statistics) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('statistics', 'true')
    }

    if ($WithCustomAttributes) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('with_custom_attributes', 'true')
    }

    if ($WithIssuesEnabled) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('with_issues_enabled', 'true')
    }

    if ($WithMergeRequestsEnabled) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('with_merge_requests_enabled', 'true')
    }

    if ($Membership) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('membership', (Get-GLAccessLevels $Membership))
    }

    Write-Debug "[Get-GitlLabProjectFork] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GitlLabProjectFork] Response: $Response"

    return $Response
}