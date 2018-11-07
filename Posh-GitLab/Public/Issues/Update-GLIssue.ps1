function Update-GLIssue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $IssueID,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Title,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Description,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $Confidential,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AssigneeIDs,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $MilestoneID,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Labels,

        [Parameter(Mandatory = $False)]
        [ValidateSet('close', 'reopen')]
        [String]
        $State,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [DateTime]
        $UpdatedAt,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [DateTime]
        $DueDate,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $DiscussionLocked
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/issues/$IssueID"
        Method     = 'PUT'
        Parameters = @{}
    }

    if ($Title) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('title', $Title)
    }

    if ($Description) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('description', $Description)
    }

    if ($Confidential) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('confidential', 'true')
    }

    if ($AssigneeIDs) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('assignee_ids', $AssigneeIDs)
    }

    if ($MilestoneID) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('milestone_id', $MilestoneID)
    }

    if ($Labels) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('labels', ($Labels -Join ','))
    }

    if ($State) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('state_event', $State)
    }
    
    if ($UpdatedAt) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('updated_at', $UpdatedAt)
    }

    if ($DueDate) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('due_date', $DueDate)
    }

    if ($DiscussionLocked) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('discussion_locked', $DiscussionLocked)
    }

    Write-Debug "[Update-GLIssue] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"
    
    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Update-GLIssue] Response: $($Response | Out-String)"

    return $Response
}