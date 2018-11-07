function Get-GLProjectUsers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/users"
    }

    Write-Debug "[Get-GLProjectUsers] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLProjectUsers] Response: $Response"

    return $Response
}