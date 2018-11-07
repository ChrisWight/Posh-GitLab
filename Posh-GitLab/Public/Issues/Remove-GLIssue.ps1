function Remove-GLIssue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $IssueID
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/issues/$IssueID"
        Method     = 'DELETE'
    }

    Write-Debug "[Remove-GLIssue] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"
    
    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Remove-GLIssue] Response: $($Response | Out-String)"

    return $Response
}