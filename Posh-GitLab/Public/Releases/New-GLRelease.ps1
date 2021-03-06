<#
.Synopsis
   Create a new Gitlab release.
.DESCRIPTION
   Create a new Gitlab release.
.EXAMPLE
   New-GLRelease -ProjectID 203 -TagName 'v1.0.0.15' -Description 'This is my test release.'
#>
function New-GLRelease
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
        $TagName,

        # The description of the Release.
        [Parameter(Mandatory = $True, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Description
    )

    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/repository/tags/$TagName/release"
        Method         = 'POST'
        Parameters     = @{
            description = $Description
        }
    }

    Write-Debug "[New-GLRelease] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[New-GLRelease] Response: $Response"

    return $Response
}
