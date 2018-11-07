function Move-GLIssue {
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
        Resource = "projects/$ProjectID/issues/$IssueID/move"
        Method   = 'POST'
        Parameters = @{
            to_project_id = $ToProjectID
        }
    }

    Write-Debug "[Move-GLIssue] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"
    
    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Move-GLIssue] Response: $($Response | Out-String)"

    return $Response
}