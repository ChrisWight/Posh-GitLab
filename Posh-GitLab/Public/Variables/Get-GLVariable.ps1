<#
.Synopsis
   Gets one or more variables from Gitlab.
.DESCRIPTION
   Gets one or more variables from Gitlab. Either supply a ProjectID to target project variables or a Group ID to target group variables.
   Project variables will be targetted by default and support filtering by specifying an environment scope such as 'Production'
.EXAMPLE
   Get-GLVariable -ProjectID 203
.EXAMPLE
   Get-GLVariable -GroupID  44 -Name 'TEST_KEY'
.EXAMPLE
   Get-GLVariable -ProjectID  44 -Name 'TEST_KEY' -Filter Production
#>
function Get-GLVariable
{
    [CmdletBinding(DefaultParameterSetName = 'ProjectFindAll')]
    [Alias()]
    [OutputType()]
    param(

        # The ID of a project or urlencoded NAMESPACE/PROJECT_NAME of the project owned by the authenticated user
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = 'ProjectFindAll')]
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = 'ProjectFindSpecific')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = 'GroupFindAll')]
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = 'GroupFindSpecific')]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupID,

        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'ProjectFindSpecific')]
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'GroupFindSpecific')]
        [String]
        $Name,

        [Parameter(Mandatory = $False, Position = 2, ParameterSetName = 'ProjectFindSpecific')]
        [String]
        $Filter
    )
<#
https://docs.gitlab.com/ee/api/project_level_variables.html

GET /projects/:id/variables

Attribute	Type	required	Description
id	integer/string	yes	The ID of a project or urlencoded NAMESPACE/PROJECT_NAME of the project owned by the authenticated user

GET /projects/:id/variables/:key

Attribute	Type	required	Description
id	integer/string	yes	The ID of a project or urlencoded NAMESPACE/PROJECT_NAME of the project owned by the authenticated user
key	string	yes	The key of a variable
filter	hash	no	Available filters: [environment_scope]. See the filter parameter details.

https://docs.gitlab.com/ee/api/group_level_variables.html

GET /groups/:id/variables

Attribute	Type	required	Description
id	integer/string	yes	The ID of a group or URL-encoded path of the group owned by the authenticated user

GET /groups/:id/variables/:key

Attribute	Type	required	Description
id	integer/string	yes	The ID of a group or URL-encoded path of the group owned by the authenticated user
key	string	yes	The key of a variable
#>
    switch ($PSCmdlet.ParameterSetName)
    {
        'ProjectFindSpecific' { $Resource = "projects/$ProjectID/variables/$Name" }
        'GroupFindSpecific'   { $Resource = "groups/$GroupID/variables/$Name" }
        'ProjectFindAll'      { $Resource = "projects/$ProjectID/variables" }
        'GroupFindAll'        { $Resource = "groups/$GroupID/variables" }
    }
    # Update the Resource Url with the environment scope filter if it was specified
    if($PSBoundParameters.ContainsKey('Filter') -and $PSCmdlet.ParameterSetName -eq 'ProjectFindSpecfic')
    {
        #Add the type for URL encoding
        Add-Type -AssemblyName System.Web

        #URL encode environemnt scope variable as it will be passed in the Url
        $Filter = [System.Web.HttpUtility]::UrlEncode($Filter)

        #Add the filter to the Resource Url
        $Resource += "?filter[environment_scope]=$Filter"
    }

    $Invoke_GitLabRequest = @{
        'Resource' = $Resource
    }

    Write-Debug "[Get-GLVariable] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLVariable] Response: $Response"

    return $Response
}
