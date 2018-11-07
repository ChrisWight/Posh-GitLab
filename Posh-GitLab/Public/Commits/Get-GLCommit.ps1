function Get-GLCommit {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindSpecific')]
        [ValidateNotNullOrEmpty()]
        [String]
        $SHA,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Reference,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateNotNullOrEmpty()]
        [DateTime]
        $Since,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateNotNullOrEmpty()]
        [DateTime]
        $Until,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Filepath,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [Switch]
        $All,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Stats
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectID/repository/commits"
        Parameters = @{}
    }

    if ($SHA) {
        $Invoke_GitLabRequest.Resource = '{0}/{1}' -f $Invoke_GitLabRequest.Resource, $SHA
    }

    if ($Reference) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('ref_name', $Reference)
    }
    
    if ($Since) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('since', $Since)
    }
    
    if ($Until) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('until', $Until)
    }
    
    if ($Filepath) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('path', $Filepath)
    }
    
    if ($All) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('all', 'true')
    }

    if ($Stats) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('with_stats', 'true')
    }
    
    Write-Debug "[Get-GLCommit] Invoke-GLRequest: $($Invoke_GitLabRequest | Out-String)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLCommit] Response: $($Response | Out-String)"

    return $Response
}