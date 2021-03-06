<#
.Synopsis
   Removes a variable from Gitlab.
.DESCRIPTION
   Removes a variable from Gitlab. Either supply a ProjectID to target project variables or a Group ID to target group variables.
   Project variables will be targetted by default and support filtering by specifying an environment scope such as 'Production'
.EXAMPLE
   Remove-GLVariable -ProjectID 203 -Name 'TEST_KEY'
.EXAMPLE
   Remove-GLVariable -GroupID 44 -Name 'TEST_KEY'
.EXAMPLE
   Remove-GLVariable -ProjectID 203 -Name 'TEST_KEY' -Filter 'Production'
#>
function Remove-GLVariable {
    [CmdletBinding(DefaultParameterSetName = 'ProjectScope')]
    [Alias()]
    [OutputType([PSCustomObject])]
    param(

        # The ID of a project or urlencoded NAMESPACE/PROJECT_NAME of the project owned by the authenticated user
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = 'ProjectScope')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        #The ID of a group or URL-encoded path of the group owned by the authenticated user
        [Parameter(Mandatory = $True, Position = 0, ParameterSetName = 'GroupScope')]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupID,

        # The key of a variable
        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Name,

        # Filter by the variables environment scope
        [Parameter(ParameterSetName = 'ProjectScope')]
        [ValidateNotNullOrEmpty()]
        [string]$Filter

    )

<#
https://docs.gitlab.com/ee/api/project_level_variables.html

DELETE /projects/:id/variables/:key

Attribute	Type	required	Description
id	integer/string	yes	The ID of a project or urlencoded NAMESPACE/PROJECT_NAME of the project owned by the authenticated user
key	string	yes	The key of a variable
filter	hash	no	Available filters: [environment_scope]. See the filter parameter details.


https://docs.gitlab.com/ee/api/group_level_variables.html

DELETE /groups/:id/variables/:key

Attribute	Type	required	Description
id	integer/string	yes	The ID of a group or URL-encoded path of the group owned by the authenticated user
key	string	yes	The key of a variable
#>

    # Work out the path based on the scope, either projects or groups
    if($PSCmdlet.ParameterSetName -eq 'ProjectScope')
    {
        $Resource = "projects/$ProjectID/variables/$Name"
    }
    else
    {
        $Resource = "groups/$GroupID/variables/$Name"
    }

    # Update the Resource Url with the environment scope filter if it was specified
    if($PSBoundParameters.ContainsKey('Filter'))
    {
        #Add the type for URL encoding
        Add-Type -AssemblyName System.Web

        #URL encode environemnt scope variable as it will be passed in the Url
        $Filter = [System.Web.HttpUtility]::UrlEncode($Filter)

        #Add the filter to the Resource Url
        $Resource += "?filter[environment_scope]=$Filter"
    }

    $Invoke_GitLabRequest = @{
        Resource       = $Resource
        Method         = 'DELETE'
    }

    Write-Debug "[Remove-GLVariable] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Remove-GLVariable] Response: $Response"

    return $Response
}