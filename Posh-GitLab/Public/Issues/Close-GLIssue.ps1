function Close-GLIssue {
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

    $Update_GitLabIssue = @{
        ProjectID = $ProjectID
        IssueID   = $IssueID
        State     = 'close'
    }

    Write-Debug "[Close-GLIssue] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"
    
    $Response = Update-GLIssue @Update_GitLabIssue

    Write-Verbose "[Close-GLIssue] Results: $($Response | Out-String)"

    return $Response
}