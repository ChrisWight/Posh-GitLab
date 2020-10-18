<#
.Synopsis
   Gets one or more links from a Gitlab Relase.
.DESCRIPTION
   Gets one or more links from a Gitlab Relase. Will either return all links for the given project and tag or a specific link if the LinkID is specified.
.EXAMPLE
   Get-GLReleaseLink -ProjectID 203 -TagName 'v1.0.0.15'
.EXAMPLE
   Get-GLReleaseLink -ProjectID 203 -TagName 'v1.0.0.15' -LinkId 14
#>
function Get-GLReleaseLink
{
    [CmdletBinding(DefaultParameterSetName = 'FindAll')]
    [Alias()]
    [OutputType()]
    param(
        # The ID of a project or urlencoded NAMESPACE/PROJECT_NAME of the project owned by the authenticated user
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = 'FindAll')]
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = 'FindSpecific')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        # The tag associated with the Release.
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'FindAll')]
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'FindSpecific')]
        [ValidateNotNullOrEmpty()]
        [String]
        $TagName,

        # The ID of the link.
        [Parameter(Mandatory = $False, Position = 2, ParameterSetName = 'FindSpecific')]
        [ValidateNotNullOrEmpty()]
        [String]
        $LinkID
    )
<#

    https://docs.gitlab.com/ee/api/releases/links.html


    GET /projects/:id/releases/:tag_name/assets/links

    Attribute	Type	Required	Description
    id	integer/string	yes	The ID or URL-encoded path of the project.
    tag_name	string	yes	The tag associated with the Release.


    GET /projects/:id/releases/:tag_name/assets/links/:link_id
    Attribute	Type	Required	Description
    id	integer/string	yes	The ID or URL-encoded path of the project.
    tag_name	string	yes	The tag associated with the Release.
    link_id	integer	yes	The ID of the link.

#>



    switch ($PSCmdlet.ParameterSetName) {
        'FindSpecific' {
            $Invoke_GitLabRequest = @{
                'Resource' = "projects/$ProjectID/releases/$TagName/$LinkID"
            }
        }
        'FindAll' {
            $Invoke_GitLabRequest = @{
                'Resource' = "projects/$ProjectID/releasesy/$TagName/assets/links"
            }
        }
    }

    Write-Debug "[Get-GLReleaseLink] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLReleaseLink] Response: $Response"

    return $Response
}