function Get-GLProject {
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
}