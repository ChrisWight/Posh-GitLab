function Remove-GLTag {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TagName
    )

    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/repository/tags/$TagName"
        Method         = 'DELETE'
    }

    Write-Debug "[Remove-GLTag] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Remove-GLTag] Response: $Response"

    return $Response
}