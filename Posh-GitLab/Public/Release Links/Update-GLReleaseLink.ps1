<#
.Synopsis
   Updates a link for a Gitlab Release.
.DESCRIPTION
   Updates a link for a Gitlab Release.
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

        # The ID of the link.
        [Parameter(Mandatory = $True, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $LinkID,

        # The name of the link.
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        # The URL of the link.
        [ValidateNotNullOrEmpty()]
        [String]
        $Url,

        # The type of the link: other, runbook, image, package. Defaults to other.
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

    $ParameterConversion = @(@{Function='Name'; Gitlab='key'},
                             @{Function='Url'; Gitlab='url'},
                             @{Function='LinkType'; Gitlab='link_type'}
                            )

    foreach($ParameterName in $ParameterConversion)
    {
        if($PSBoundParameters.ContainsKey($ParameterName.Function))
        {
            [void]$GLParameters.Add($ParameterName.Gitlab,$PSBoundParameters[$ParameterName.Function])
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