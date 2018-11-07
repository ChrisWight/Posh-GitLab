function New-GLMarkdownPost {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Text,

        [Parameter(Mandatory = $False, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Project,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $UseFlavored
    )

    $Invoke_GitLabRequest = @{
        Resource   = 'markdown'
        Method     = 'POST'
        Parameters = @{
            text = $Text
            gfm  = if ($UseFlavored) { 'true' } else { 'false' }
        }
    }

    if ($Project) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('project', $Project)
    }

    Write-Debug "[New-GLMarkdownPost] Invoke-GLRequest: $($Invoke_GitLabRequest | Out-String)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[New-GLMarkdownPost] Response: $($Response | Out-String)"
    
    return $Response
}