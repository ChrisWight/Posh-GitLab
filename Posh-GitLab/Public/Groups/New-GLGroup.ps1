function New-GLGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Path,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Description,

        [Parameter(Mandatory = $False)]
        [ValidateSet('private', 'internal', 'public')]
        [String]
        $Visibility = 'internal',

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $LFSEnabled,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $RequestAccessEnabled,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ParentGroupID
    )

    $Invoke_GitLabRequest = @{
        Resource = 'groups'
        Method   = 'POST'
        Parameters = @{
            name = $Name
            path = $Path
            visibility = $Visibility
        }
    }

    if ($Description) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('description', $Description)
    }

    if ($ParentGroupID) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('parent_id', $ParentGroupID)
    }

    if ($LFSEnabled) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('lfs_enabled', 'true')
    }

    if ($RequestAccessEnabled) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('request_access_enabled', 'true')
    }

    Write-Debug "[New-GLGroup] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[New-GLGroup] Results: $Response"

    return $Response
}