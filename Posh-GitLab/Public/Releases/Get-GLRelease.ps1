<#
.Synopsis
   Gets one or more GItlab releases.
.DESCRIPTION
   Gets one or more Gitlab Releases. Either return all releases or search by tag name.
.EXAMPLE
   Get-GLRelease -ProjectID 203 -TagName 'v1.0.0.15'
.EXAMPLE
   Get-GLRelease -ProjectID 203 -TagName 'v1.0.0.15' -LinkId 14
#>
function Get-GLRelease
{
    [CmdletBinding(DefaultParameterSetName = 'FindAll')]
    [Alias()]
    [OutputType()]
    param(

        # ID or URL-encoded path of the project.
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        # The tag associated with the Release.
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'FindSpecific')]
        [String]
        $TagName,

        #The field to use as order. Either released_at (default) or created_at.
        [Parameter(ParameterSetName = 'FindAll')]
        [ValidateSet('default', 'created_at')]
        [String]
        $OrderBy = 'default',

        # The direction of the order. Either desc (default) for descending order or asc for ascending
        [Parameter(ParameterSetName = 'FindAll')]
        [ValidateSet('asc', 'desc')]
        [String]
        $Sort = 'desc'
    )
<#
    https://docs.gitlab.com/ee/api/releases/


    GET /projects/:id/releases

    Attribute	Type	Required	Description
    id	integer/string	yes	The ID or URL-encoded path of the project.
    order_by	string	no	The field to use as order. Either released_at (default) or created_at.
    sort	string	no	The direction of the order. Either desc (default) for descending order or asc for ascending

    GET /projects/:id/releases/:tag_name

    Attribute	Type	Required	Description
    id	integer/string	yes	The ID or URL-encoded path of the project.
    tag_name	string	yes	The tag where the release will be created from.
#>
    switch ($PSCmdlet.ParameterSetName) {
        'FindSpecific' {
            $Invoke_GitLabRequest = @{
                'Resource' = "projects/$ProjectID/releases/$TagName";
            }
        }
        'FindAll' {
            $Invoke_GitLabRequest = @{
                'Resource' = "projects/$ProjectID/releases";
                'Parameters' = @{
                    order_by = $OrderBy
                    sort     = $Sort
                }
            }
        }
    }

    Write-Debug "[Get-GLRelease] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLRelease] Response: $Response"

    return $Response
}
