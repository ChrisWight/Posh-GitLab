function Update-GLWikiPage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,
        
        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Slug,

        [Parameter(Mandatory = $True, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Title,

        [Parameter(Mandatory = $True, Position = 3)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Content,

        [Parameter(Mandatory = $False)]
        [ValidateSet('markdown', 'rdoc', 'asciidoc')]
        [String]
        $Format = 'markdown'
    )

    $Invoke_GitLabRequest = @{
        Resource   = "projects/$ProjectId/wikis/$Slug"
        Method     = 'PUT'
        Parameters = @{
            content = $Content
            title   = $Title
            format  = $Format
        }
    }

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Update-GLWikiPage] Response: $($Response | Out-String)"
    
    return $Response
}


