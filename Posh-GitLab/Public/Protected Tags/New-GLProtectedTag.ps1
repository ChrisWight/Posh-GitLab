<#
.Synopsis
   Create a new Gitlab protected tag. This protects tags, to create tags see New-GLTag
.DESCRIPTION
   Create a new Gitlab protected tag. This protects tags, to create tags see New-GLTag
.EXAMPLE
   New-GLProtectedTag -ProjectID 203 -TagName 'v1.0.0.15'
.EXAMPLE
   New-GLProtectedTag -ProjectID 203 -TagName 'v1.0.0.15' -CreateAccessLevel 30 -AccessLevelDescription 'Developer + Maintainer'
#>
function New-GLProtectedTag
{
    [CmdletBinding(DefaultParameterSetName = 'DefaultAccessLevel')]
    [Alias()]
    [OutputType()]
    param (

        # ID or URL-encoded path of the project.
        [Parameter(ParameterSetName = 'DefaultAccessLevel')]
        [Parameter(ParameterSetName = 'CreateAccessLevel')]
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        # The name of the tag or wildcard
        [Parameter(ParameterSetName = 'DefaultAccessLevel')]
        [Parameter(ParameterSetName = 'CreateAccessLevel')]
        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TagName,

        # Access levels allowed to create (defaults: 40, maintainer access level)
        [Parameter(Mandatory=$True, ParameterSetName = 'CreateAccessLevel')]
        [ValidateNotNullOrEmpty()]
        [string]
        $CreateAccessLevel,

        # Description for the access level
        [Parameter(Mandatory=$True, ParameterSetName = 'CreateAccessLevel')]
        [ValidateNotNullOrEmpty()]
        [string]
        $AccessLevelDescription
    )
<#
    https://docs.gitlab.com/ee/api/protected_tags.html

    POST /projects/:id/protected_tags

    Attribute	Type	Required	Description
    id	integer/string	yes	The ID or URL-encoded path of the project owned by the authenticated user
    name	string	yes	The name of the tag or wildcard
    create_access_level	string	no	Access levels allowed to create (defaults: 40, maintainer access level)
#>
    $GLParameters = @{
        name = $TagName
    }

    if($PSCmdlet.ParameterSetName -eq 'CreateAccessLevel')
    {
        $AccessLevel = @{
            access_level        = $CreateAccessLevel
            access_description  = $AccessLevelDescription
        }

        [void]$GLParameeters.Add('create_access_level',$AccessLevel)
    }

    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/protected_tags"
        Method         = 'POST'
        Parameters     = $GLParameters
    }

    Write-Debug "[New-GLProtectedTag] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[New-GLProtectedTag] Response: $Response"

    return $Response
}
