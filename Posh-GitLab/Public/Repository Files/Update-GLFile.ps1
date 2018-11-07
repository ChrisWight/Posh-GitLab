function Update-GLFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Filepath,

        [Parameter(Mandatory = $True, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Branch,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Content,

        [Parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CommitMessage,

        [Parameter(Mandatory = $False)]
        [ValidateSet('text', 'base64')]
        [String]
        $Encoding = 'text',

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $NewBranch,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $StartBranch,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AuthorEmail,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $AuthorName,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $LastCommitID
    )

    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/repository/files/$Filepath"
        Method         = 'PUT'
        Parameters     = @{
            branch          = $Branch
            content         = $Content
            commit_message  = $CommitMessage
            encoding        = $Encoding
        }
        ReturnResponse = $True
    }

    if ($StartBranch) {
        [void]$Invoke_GitLabRequest.Parameters.Add('start_branch', $StartBranch)
    }

    if ($AuthorEmail) {
        [void]$Invoke_GitLabRequest.Parameters.Add('author_email', $AuthorEmail)
    }

    if ($AuthorName) {
        [void]$Invoke_GitLabRequest.Parameters.Add('author_name', $AuthorName)
    }

    if ($LastCommitID) {
        [void]$Invoke_GitLabRequest.Parameters.Add('last_commit_id', $LastCommitID)
    }

    Write-Debug "[Update-GLFile] Invoke-GLRequest: $($Invoke_GitLabRequest | Out-String)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Update-GLFile] Response: $($Response | Out-String)"

    return $Response
}