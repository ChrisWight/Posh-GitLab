function Get-GLFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Filepath,

        [Parameter(Mandatory = $True, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Reference,

        [Switch]
        $Raw
    )

    $Resource = "projects/$ProjectID/repository/files/$Filepath"

    if ($Raw) {
        $Resource = '{0}/raw' -f $Resource
    }

    $Invoke_GitLabRequest = @{
        Resource        = $Resource
        Parameters      = @{
            ref = $Reference
        }
        ReturnResponse  = $True
    }

    Write-Debug "[Get-GLFile] Invoke-GLRequest: $($Invoke_GitLabRequest | Out-String)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLFile] Response: $($Response | Out-String)"

    return $Response
}