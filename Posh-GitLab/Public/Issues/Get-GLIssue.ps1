function Get-GLIssue {
    [CmdletBinding(DefaultParametersetname = 'FindAll')]
    [Alias('Get-GLIssue')]
    param(
        [Parameter(Mandatory = $True, ParameterSetName = 'Group')]
        [ValidateNotNullOrEmpty()]
        [String]
        $GroupID,

        [Parameter(Mandatory = $True, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $True, ParameterSetName = 'SpecificIssue')]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, ParameterSetName = 'SpecificIssue')]
        [ValidateNotNullOrEmpty()]
        [String]
        $IssueID,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [Switch]
        $All,

        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateSet('opened', 'closed')]
        [String]
        $State,

        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateNotNullOrEmpty()]
        [String[]]
        $Labels,

        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Milestone,

        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateSet('created_by_me', 'assigned_to_me', 'all')]
        [String]
        $Scope = 'created_by_me',

        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateNotNullOrEmpty()]
        [String]
        $AuthorID,

        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateNotNullOrEmpty()]
        [String]
        $AssigneeID,

        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateSet('created_at', 'updated_at')]
        [String]
        $OrderBy = 'created_at',

        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateSet('asc', 'desc')]
        [String]
        $Sort = 'desc',

        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Search,
        
        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [DateTime]
        $CreatedAfter,

        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [DateTime]
        $CreatedBefore,

        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [DateTime]
        $UpdatedAfter,

        [Parameter(Mandatory = $False, ParameterSetName = 'Group')]
        [Parameter(Mandatory = $False, ParameterSetName = 'Project')]
        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [DateTime]
        $UpdatedBefore
    )

    switch ($PSCmdlet.ParameterSetName) {
        'Group' {
            $Resource = "groups/$GroupID/issues"
        }
        'SpecificIssue' {
            $Resource = "projects/$ProjectID/issues/$IssueID"
        }
        'Project' {
            $Resource = "projects/$ProjectID/issues"
        }
        'FindAll' {
            $Resource = 'issues'
        }
    }

    $Invoke_GitLabRequest = @{
        Resource   = $Resource
        Parameters = @{}
    }

    if (-not ($PSCmdlet.ParameterSetName -eq 'SpecificIssue')) {
        if ($State) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('state', $State)
        }

        if ($Labels) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('labels', ($Labels -Join ','))
        }

        if ($Milestone) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('milestone', $Milestone)
        }

        if ($Scope) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('scope', $Scope)
        }

        if ($AuthorID) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('author_id', $AuthorID)
        }

        if ($AssigneeID) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('assignee_id', $AssigneeID)
        }

        if ($OrderBy) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('order_by', $OrderBy)
        }

        if ($Sort) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('sort', $Sort)
        }

        if ($Search) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('search', $Search)
        }

        if ($CreatedAfter) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('created_after', $CreatedAfter)
        }

        if ($CreatedBefore) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('created_before', $CreatedBefore)
        }

        if ($UpdatedAfter) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('updated_after', $UpdatedAfter)
        }

        if ($UpdatedBefore) {
            [Void]$Invoke_GitLabRequest.Parameters.Add('updated_before', $UpdatedBefore)
        }
    }

    Write-Debug "[Get-GLIssue] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"
    
    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLIssue] Response: $($Response | Out-String)"

    return $Response
}