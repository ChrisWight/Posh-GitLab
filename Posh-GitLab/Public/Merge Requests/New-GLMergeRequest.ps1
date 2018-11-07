function New-GLMergeRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $SourceBranch,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TargetBranch,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Title,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AssigneeID,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Description,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TargetProjectID,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Labels,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $MilestoneID,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $RemoveSourceBranch,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $AllowCollaboration,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $Squash
    )
    
    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/merge_requests"
        Method     = 'POST'
        Parameters = @{
            source_branch = $SourceBranch
            target_branch = $TargetBranch
            title         = $Title
        }
    }

    if ($AssigneeID) {
        [void]$Invoke_GitLabRequest.Parameters.Add('assignee_id', $AssigneeID)
    }

    if ($Description) {
        [void]$Invoke_GitLabRequest.Parameters.Add('description', $Description)
    }

    if ($TargetProjectID) {
        [void]$Invoke_GitLabRequest.Parameters.Add('target_project_id', $TargetProjectID)
    }

    if ($Labels) {
        [void]$Invoke_GitLabRequest.Parameters.Add('labels', $Labels)
    }

    if ($MilestoneID) {
        [void]$Invoke_GitLabRequest.Parameters.Add('milestore_id', $MilestoneID)
    }

    if ($RemoveSourceBranch) {
        [void]$Invoke_GitLabRequest.Parameters.Add('remove_source_branch', 'true')
    }

    if ($AllowCollaboration) {
        [void]$Invoke_GitLabRequest.Parameters.Add('allow_collaboration', 'true')
    }

    if ($Squash) {
        [void]$Invoke_GitLabRequest.Parameters.Add('squash', $Squash)
    }

    Write-Debug "[New-GLMergeRequest] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Debug "[New-GLMergeRequest] Response: $($Response | Out-String)"

    return $Response    
}