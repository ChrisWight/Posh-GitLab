function New-GLCommit {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Branch,

        [Parameter(Mandatory = $True, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CommitMessage,

        [Parameter(Mandatory = $True)]
        [ValidateSet('create', 'delete', 'move', 'update')]
        [String]
        $Action,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $FilePath,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PreviousPath,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Content,

        [Parameter(Mandatory = $False)]
        [ValidateSet('text', 'base64')]
        [String]
        $Encoding = 'text',

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $LastCommitID,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $StartBranch,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AuthorName,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AuthorEmail
    )

    $ActionsArray = @{
        action    = $Action
        file_path = $FilePath
        encoding  = $Encoding
    }

    if ($PreviousPath) {
        [Void]$ActionsArray.Add('previous_path', $PreviousPath)
    }

    if ($Content) {
        [Void]$ActionsArray.Add('content', $Content)
    }

    if ($LastCommitID) {
        [Void]$ActionsArray.Add('last_commit_id', $LastCommitID)
    }

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/repository/commits"
        Method     = 'POST'
        Parameters = @{
            branch         = $Branch
            commit_message = $CommitMessage
            actions        = @(
                $ActionsArray
            )
        }
    }

    if ($StartBranch) {
        [Void]$ActionsArray.Add('start_branch', $StartBranch)
    }

    if ($AuthorEmail) {
        [Void]$ActionsArray.Add('author_email', $AuthorEmail)
    }

    if ($AuthorName) {
        [Void]$ActionsArray.Add('author_name', $AuthorName)
    }

    Write-Debug "[New-GLCommit] Invoke-GLRequest: $($Invoke_GitLabRequest | Out-String)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[New-GLCommit] Response: $($Response | Out-String)"

    return $Response
}