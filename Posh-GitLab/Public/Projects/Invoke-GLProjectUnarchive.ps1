function Invoke-GLProjectUnarchive {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectID/unarchive"
        Method   = 'POST'
    }

    Write-Debug "[Invoke-GLProjectUnarchive] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Invoke-GLProjectUnarchive] Response: $Response"

    return $Response
}