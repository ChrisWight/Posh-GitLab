<#
.Synopsis
   Remove a Gitlab release
.DESCRIPTION
   Remove a GItlab release.
.EXAMPLE
   Remove-GLRelease -ProjectID 203 -TagName 'v1.0.0.15'
#>
function Remove-GLRelease
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

        # The tag where the release will be deleted from.
        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TagName
    )
<#
https://docs.gitlab.com/ee/api/releases/

DELETE /projects/:id/releases/:tag_name

Attribute	Type	Required	Description
id	integer/string	yes	The ID or URL-encoded path of the project.
tag_name	string	yes	The tag where the release will be created from.
#>
    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/releases/$TagName"
        Method         = 'DELETE'
    }

    Write-Debug "[Remove-GLRelease] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Remove-GLRelase] Response: $Response"

    return $Response
}