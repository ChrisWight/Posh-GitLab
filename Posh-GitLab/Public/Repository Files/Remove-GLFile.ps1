function Remove-GLFile {
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

        [Parameter(Mandatory = $True, Position = 3)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CommitMessage,

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
        Method         = 'DELETE'
        Parameters     = @{
            branch          = $Branch
            commit_message  = $CommitMessage
        }
        ReturnResponse = $True
    }

    if ($StartBranch) {
        [void]$Invoke_GitLabRequest.Parameters.Add('start_branch', $StartBranch)
    }

    if ($LastCommitID) {
        [void]$Invoke_GitLabRequest.Parameters.Add('last_commit_id', $LastCommitID)
    }

    if ($AuthorEmail) {
        [void]$Invoke_GitLabRequest.Parameters.Add('author_email', $AuthorEmail)
    }

    if ($AuthorName) {
        [void]$Invoke_GitLabRequest.Parameters.Add('author_name', $AuthorName)
    }

    Write-Debug "[Remove-GLFile] Invoke-GLRequest: $($Invoke_GitLabRequest | Out-String)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Remove-GLFile] Response: $($Response | Out-String)"

    return $Response
}