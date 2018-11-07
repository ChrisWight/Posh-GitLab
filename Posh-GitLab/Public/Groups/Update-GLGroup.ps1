function Update-GLGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupID,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory = $False)]
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
        $Visibility,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $LFSEnabled
    )

    $Invoke_GitLabRequest = @{
        Resource = "groups/$GroupID"
        Method   = 'PUT'
        Parameters = @{}
    }

    if ($Name) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('name', $Name)
    }

    if ($Path) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('path', $Path)
    }

    if ($Description) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('description', $Description)
    }

    if ($Visibility) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('visibility', $Visibility)
    }

    if ($LFSEnabled) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('lfs_enabled', 'true')
    }

    if ($RequestAccessEnabled) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('request_access_enabled', 'true')
    }

    Write-Debug "[Update-GLGroup] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Update-GLGroup] Results: $Response"

    return $Response
}