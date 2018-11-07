function New-GLIssue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Title,

        [Parameter(Mandatory = $False, Position = 2)]
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
        [ValidateNotNullOrEmpty()]
        [String]
        $CreatedAt,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $DueDate,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $MRToResolveDiscussionOf,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $DiscussionToResolve
    )
    
    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/issues"
        Method     = 'POST'
        Parameters = @{
            title       = $Title
            description = $Description
        }
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

    if ($CreatedAt) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('created_at', $CreatedAt)
    }

    if ($DueDate) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('due_date', $DueDate)
    }

    if ($MRToResolveDiscussionOf) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('merge_request_to_resolve_discussions_of', $MRToResolveDiscussionOf)
    }

    if ($DiscussionToResolve) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('discussion_to_resolve', $DiscussionToResolve)
    }

    Write-Debug "Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"
    
    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "Successfully detected issue(s)"

    return $response
}