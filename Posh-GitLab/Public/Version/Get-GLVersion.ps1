function Get-GLVersion {
    [CmdletBinding()]
    param ()

    $Invoke_GitLabRequest = @{
        'Resource' = "version"
    }

    Write-Debug "[Get-GLVersion] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLVersion] Response: $($Response | Out-String)"

    return $Response
}