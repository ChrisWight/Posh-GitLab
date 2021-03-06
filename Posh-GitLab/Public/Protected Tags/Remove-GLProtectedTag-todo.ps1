<#
.Synopsis
   Remove a Gitlab protected tag. This unprotects tags, for removing a tag see Remove-GLTag
.DESCRIPTION
   Remove a GItlab protected tag. This unprotects tags, for removing a tag see Remove-GLTag
.EXAMPLE
   Remove-GLProtectedTag -ProjectID 203 -TagName 'v1.0.0.15'
#>
function Remove-GLProtectedTag
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    param(

        # ID or URL-encoded path of the project.
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        # The tag to unprotect
        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TagName
    )
<#
    https://docs.gitlab.com/ee/api/protected_tags.html

    DELETE /projects/:id/protected_tags/:name

    curl --request DELETE --header "PRIVATE-TOKEN: <your_access_token>" "https://gitlab.example.com/api/v4/projects/5/protected_tags/*-stable"

    Attribute	Type	Required	Description
    id	integer/string	yes	The ID or URL-encoded path of the project owned by the authenticated user
    name	string	yes	The name of the tag
#>
    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/releases/$TagName"
        Method         = 'DELETE'
    }

    Write-Debug "[Remove-GLProtectedTag] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Remove-GLRelase] Response: $Response"

    return $Response
}
