<#
.Synopsis
   Creates a new variable in Gitlab.
.DESCRIPTION
   Creates a new variable in Gitlab. Either supply a ProjectID to target project variables or a Group ID to target group variables.
   Project variables will be targetted by default and support filtering by specifying an environment scope such as 'Production'
.EXAMPLE
   New-GLVariable -ProjectID 203 -Name 'TEST_KEY' -Value = 'Test value'
.EXAMPLE
   New-GLVariable -GroupID 44 -Name 'TEST_KEY' -Value = 'Test value'
.EXAMPLE
   New-GLVariable -ProjectID 203 -Name 'TEST_KEY' -Value = 'Test value' -Masked $True -Protected $True -EnvironmentScope 'Development'
 #>
function New-GLVariable
{
    [CmdletBinding(DefaultParameterSetName = 'ProjectScope')]
    [Alias()]
    [OutputType()]
    param (
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

        [Parameter(Mandatory = $True, Position = 2)]
        [String]
        $Value,

        # The type of a variable. Available types are: env_var (default) and file
        [ValidateSet('env_var','file')]
        [String]
        $VariableType,

        #Whether the variable is protected
        [boolean]
        $Protected,

        #Whether the variable is masked
        [boolean]
        $Masked,

        # The environment_scope of the variable
        [Parameter(ParameterSetName = 'ProjectScope')]
        [ValidateNotNullOrEmpty()]
        [string]$EnvironmentScope,

        # Filter by the variables environment scope
        [Parameter(ParameterSetName = 'ProjectScope')]
        [ValidateNotNullOrEmpty()]
        [string]$Filter
    )
<#
https://docs.gitlab.com/ee/api/project_level_variables.html

POST /projects/:id/variables

Attribute	Type	required	Description
id	integer/string	yes	The ID of a project or urlencoded NAMESPACE/PROJECT_NAME of the project owned by the authenticated user
key	string	yes	The key of a variable; must have no more than 255 characters; only A-Z, a-z, 0-9, and _ are allowed
value	string	yes	The value of a variable
variable_type	string	no	The type of a variable. Available types are: env_var (default) and file
protected	boolean	no	Whether the variable is protected
masked	boolean	no	Whether the variable is masked
environment_scope	string	no	The environment_scope of the variable
https://docs.gitlab.com/ee/api/group_level_variables.html

POST /groups/:id/variables

Attribute	Type	required	Description
id	integer/string	yes	The ID of a group or URL-encoded path of the group owned by the authenticated user
key	string	yes	The key of a variable; must have no more than 255 characters; only A-Z, a-z, 0-9, and _ are allowed
value	string	yes	The value of a variable
variable_type	string	no	The type of a variable. Available types are: env_var (default) and file
protected	boolean	no	Whether the variable is protected
masked	boolean	no	Whether the variable is masked
#>

    #Create a hashtable for parameters and add them if they have been specified when the function was called
    $GLParameters = @{key    = $Name
                      value  = $Value}

    $ParameterConversion = @(@{Function='VariableType'; Gitlab='variable_type'}
                             @{Function='Protected'; Gitlab='protected'}
                             @{Function='Masked'; Gitlab='masked'}
                             @{Function='EnvironementScope'; Gitlab='environment_scope'}
                            )

    foreach($ParameterName in $ParameterConversion)
    {
        if($PSBoundParameters.ContainsKey($ParameterName.Function))
        {
            [void]$GLParameters.Add($ParameterName.Gitlab,$PSBoundParameters[$ParameterName.Function])
        }
    }

    # Work out the path based on the scope, either project or group
    if($PSCmdlet.ParameterSetName -eq 'ProjectScope')
    {
        $Resource = "projects/$ProjectID/variables"
    }
    else
    {
        $Resource = "groups/$GroupID/variables"
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
        Method         = 'POST'
        Parameters     = $GLParameters
    }

    Write-Debug "[New-GLVariable] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[New-GLVariable] Response: $Response"

    return $Response
}
