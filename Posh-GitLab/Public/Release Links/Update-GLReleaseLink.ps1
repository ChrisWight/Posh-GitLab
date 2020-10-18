<#
.Synopsis
   Updates a Relase link for a Gitlab Relase.
.DESCRIPTION
   Updates a Relase link for a Gitlab Relase.
.EXAMPLE
   Update-GLReleaseLink -ProjectID 203 -TagName 'v1.0.0.15' -LinkId 14 -UrlString = 'https://github.com/ChrisWight/Posh-GitLab'
.EXAMPLE
   Update-GLReleaseLink -ProjectID 203 -TagName 'v1.0.0.15'  -LinkId 14 -Name 'Github Repository'
#>
function Update-GLReleaseLink
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TagName,

        [Parameter(Mandatory = $True, Position = 2)]
        [String]
        $LinkID,

        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        [ValidateNotNullOrEmpty()]
        [String]
        $UrlString,

        [ValidateSet('other', 'runbook', 'image', 'package')]
        [ValidateNotNullOrEmpty()]
        [String]
        $LinkType = 'other'
    )
<#
PUT /projects/:id/releases/:tag_name/assets/links/:link_id

Attribute	Type	Required	Description
id	integer/string	yes	The ID or URL-encoded path of the project.
tag_name	string	yes	The tag associated with the Release.
link_id	integer	yes	The ID of the link.
name	string	no	The name of the link.
url	string	no	The URL of the link.
link_type	string	no	The type of the link: other, runbook, image, package. Defaults to other.
#>

    #Create a hashtable for parameters and add them if they have been specified when the function was called
    $GLParameters = @{tag_name= $TagName}

    foreach($ParameterName in ('Name','UrlString','LinkType'))
    {
        if($PSBoundParameters.ContainsKey($ParameterName))
        {
            [void]$GLParameters.Add($ParameterName,$PSBoundParameters[$ParameterName])
        }
    }

    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/releases/$TagName/assets/links/$LinkID"
        Method         = 'PUT'
        Parameters     = $GLParameters
    }

    Write-Debug "[Update-GLReleaseLink] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Update-GLReleaseLink] Response: $Response"

    return $Response
}