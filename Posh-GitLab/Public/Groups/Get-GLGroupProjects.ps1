function Get-GLGroupProjects {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupID,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Search,

        [Parameter(Mandatory = $False)]
        [ValidateSet('public', 'internal', 'private')]
        [String]
        $Visibility,

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
        $Archived,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Simple,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Owned,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Starred,

        [Parameter(Mandatory = $False)]
        [Switch]
        $WithIssuesEnabled,

        [Parameter(Mandatory = $False)]
        [Switch]
        $WithMergeRequestsEnabled,

        [Parameter(Mandatory = $False)]
        [Switch]
        $WithCustomAttributes
    )

    $Invoke_GitLabRequest = @{
        Resource   = "groups/$GroupID/projects"
        Parameters = @{
            order_by = $Order
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

    if ($Starred) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('starred', 'true')
    }

    if ($WithIssuesEnabled) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('with_issues_enabled', 'true')
    }

    if ($WithMergeRequestsEnabled) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('with_merge_requests_enabled', 'true')
    }

    if ($WithCustomAttributes) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('with_custom_attributes', 'true')
    }

    Write-Debug "[Get-GLGroupProjects] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLGroupProjects] Results: $Response"

    return $Response
}