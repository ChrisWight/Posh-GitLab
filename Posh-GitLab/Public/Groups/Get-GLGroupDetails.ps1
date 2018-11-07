function Get-GLGroupDetails {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupID,

        [Parameter(Mandatory = $False)]
        [Switch]
        $WithCustomAttributes,

        [Parameter(Mandatory = $False)]
        [Switch]
        $WithProjects
    )

    $Invoke_GitLabRequest = @{
        Resource   = "groups/$GroupID"
        Parameters = @{}
    }

    if ($WithCustomAttributes) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('with_custom_attributes', 'true')
    }

    if ($WithProjects) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('with_projects', 'true')
    }

    Write-Debug "[Get-GLGroupDetails] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLGroupDetails] Results: $Response"

    return $Response
}