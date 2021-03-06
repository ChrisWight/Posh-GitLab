<#
.Synopsis
   Create Evidence for an existing Gitlab Release.
.DESCRIPTION
   Create Evidence for an existing Gitlab Release.
.EXAMPLE
   New-GLReleaseEvidence -ProjectID 203 -TagName 'v1.0.0.15'
#>
function New-GLReleaseEvidence
{
    [CmdletBinding()]
    [Alias()]
    [OutputType()]
    param (

        # ID or URL-encoded path of the project.
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        # The tag associated with the Release.
        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TagName
    )
<#
    https://docs.gitlab.com/ee/api/releases/

    POST /projects/:id/releases/:tag_name/evidence

    Attribute	Type	Required	Description
    id	integer/string	yes	The ID or URL-encoded path of the project.
    tag_name	string	yes	The tag where the release will be created from.
#>
    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/releases/$TagName/evidence"
        Method         = 'POST'
    }

    Write-Debug "[New-GLReleaseEvidence] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[New-GLReleaseEvidence] Response: $Response"

    return $Response
}
