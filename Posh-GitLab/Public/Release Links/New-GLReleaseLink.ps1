<#
.Synopsis
   Creates a new link for a Gitlab Release.
.DESCRIPTION
   Creates a new link for a Gitlab Release.
.EXAMPLE
   New-GLReleaseLink -ProjectID 203 -TagName 'v1.0.0.15' -Name 'Github Repository' -UrlString = 'https://github.com/ChrisWight/Posh-GitLab'
.EXAMPLE
   New-GLReleaseLink -ProjectID 203 -TagName 'v1.0.0.15' -Name 'Github Repository' -UrlString = 'https://github.com/ChrisWight/Posh-GitLab' -LinkType 'image'
#>
function New-GLReleaseLink
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    param (

        # The ID of a project or urlencoded NAMESPACE/PROJECT_NAME of the project owned by the authenticated user
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        # The tag associated with the Release.
        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TagName,

        # The name of the link.
        [Parameter(Mandatory = $True, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        # The URL of the link.
        [Parameter(Mandatory = $True, Position = 3)]
        [ValidateNotNullOrEmpty()]
        [String]
        $UrlString,

        # The type of the link: other, runbook, image, package. Defaults to other.
        [ValidateSet('other', 'runbook', 'image', 'package')]
        [ValidateNotNullOrEmpty()]
        [String]
        $LinkType = 'other'
    )
<#

    https://docs.gitlab.com/ee/api/releases/links.html


    POST /projects/:id/releases/:tag_name/assets/links

id	integer/string	yes	The ID or URL-encoded path of the project.
tag_name	string	yes	The tag associated with the Release.
name	string	yes	The name of the link.
url	string	yes	The URL of the link.
link_type	string	no	The type of the link: other, runbook, image, package. Defaults to other.

#>
    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/releases/$TagName/assets/links"
        Method         = 'POST'
        Parameters     = @{
            tag_name            = $TagName
            name                = $Name
            url_string          = $URLString
            link_type           = $LinkType
        }
    }

    Write-Debug "[New-GLReleaseLink] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[New-GLReleaseLink] Response: $Response"

    return $Response
}