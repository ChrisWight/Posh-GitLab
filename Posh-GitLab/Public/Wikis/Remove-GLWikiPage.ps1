function Remove-GLWikiPage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,
        
        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Slug
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectId/wikis/$Slug"
        Method   = 'DELETE'
    }

    Write-Debug "[Remove-GLWikiPage] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest
    
    Write-Verbose "[Remove-GLWikiPage] Response: $($Response | Out-String)"

    return $Response
}