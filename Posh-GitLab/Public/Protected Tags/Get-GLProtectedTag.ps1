<#
.Synopsis
   Gets one or more Gitlab protected tags. This is for protecting tags, to get a tag see Get-GLTag.
.DESCRIPTION
   Gets one or more Gitlab protected tags. This is for protecting tags, to get a tag see Get-GLTag. Either return all protected tags or search by name or wildcard.
.EXAMPLE
   Get-GLProtectedTag -ProjectID 203 -TagName 'v1.0.0.15'
.EXAMPLE
   Get-GLProtectedTag -ProjectID 203 -TagName 'v*'
#>
function Get-GLProtectedTag
{
    [CmdletBinding(DefaultParameterSetName = 'FindAll')]
    [Alias()]
    [OutputType()]
    param(

        # ID or URL-encoded path of the project.
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'FindAll')]
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'FindSpecific')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        # The name of the tag or wildcard
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'FindSpecific')]
        [String]
        $TagName

    )
<#
    https://docs.gitlab.com/ee/api/protected_tags.html


    GET /projects/:id/protected_tags

    Attribute	Type	Required	Description
    id	integer/string	yes	The ID or URL-encoded path of the project owned by the authenticated user

    GET /projects/:id/protected_tags/:name

    Attribute	Type	Required	Description
    id	integer/string	yes	The ID or URL-encoded path of the project owned by the authenticated user
    name	string	yes	The name of the tag or wildcard
#>
    switch ($PSCmdlet.ParameterSetName) {
        'FindSpecific' {
            $Resource = "projects/$ProjectID/protected_tags/$TagName"
        }
        'FindAll' {
            $Resource = "projects/$ProjectID/protected_tags"
        }
    }

    $Invoke_GitLabRequest = @{
        'Resource' = $Resource
    }
    Write-Debug "[Get-GLProtectedTag] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLProtectedTag] Response: $Response"

    return $Response
}
