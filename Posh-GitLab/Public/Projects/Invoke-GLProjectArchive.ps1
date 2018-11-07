function Invoke-GLProjectArchive {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectID/archive"
        Method   = 'POST'
    }

    Write-Debug "[Invoke-GLProjectArchive] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Invoke-GLProjectArchive] Response: $Response"

    return $Response
}