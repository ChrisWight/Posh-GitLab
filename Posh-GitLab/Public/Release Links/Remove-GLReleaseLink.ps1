<#
.Synopsis
   Removes a new Relase link for a Gitlab Relase.
.DESCRIPTION
   Removes a new Relase link for a Gitlab Relase.
.EXAMPLE
   Remove-GLReleaseLink -ProjectID 203 -TagName 'v1.0.0.15' -LinkID 14
#>
function Remove-GLReleaseLink
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [String]
        $TagName,

        [Parameter(Mandatory = $True, Position = 1)]
        [String]
        $LinkID
    )
<#

DELETE /projects/:id/releases/:tag_name/assets/links/:link_id

Attribute	Type	Required	Description
id	integer/string	yes	The ID or URL-encoded path of the project.
tag_name	string	yes	The tag associated with the Release.
link_id	integer	yes	The ID of the link.

#>
    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/releases/$TagName/assets/links/$LinkID"
        Method         = 'DELETE'
    }

    Write-Debug "[Remove-GLReleaseLink] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Remove-GLReleaseLink] Response: $Response"

    return $Response
}