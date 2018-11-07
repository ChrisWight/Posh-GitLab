function Remove-GLProject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectID"
        Method   = 'DELETE'
    }

    Write-Debug "[Remove-GLProject] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Remove-GLProject] Response: $Response"

    return $Response
}