function Get-GLProjectLanguages {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectID/languages"
    }

    Write-Debug "[Get-GLProjectLanguages] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLProjectLanguages] Response: $Response"

    return $Response
}