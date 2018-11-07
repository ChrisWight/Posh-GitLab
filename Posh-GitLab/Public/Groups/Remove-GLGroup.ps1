function Remove-GLGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupID
    )

    $Invoke_GitLabRequest = @{
        Resource = "groups/$GroupID"
        Method = 'DELETE'
    }

    Write-Debug "[Remove-GLGroup] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Remove-GLGroup] Results: $Response"

    return $Response
}