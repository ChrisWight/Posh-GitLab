function New-GLWikiPage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,
        
        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Content,

        [Parameter(Mandatory = $True, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Title,

        [Parameter(Mandatory = $False)]
        [ValidateSet('markdown', 'rdoc', 'asciidoc')]
        [String]
        $Format = 'markdown'
    )

    $Resource = "projects/$ProjectID/wikis"
    
    $Invoke_GitLabRequest = @{
        Resource   = $Resource
        Method     = 'POST'
        Parameters = @{
            content = $Content
            title   = $Title
        }
    }

    if ($Format) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('format', $Format.ToLower())
    }

    Write-Debug "[New-GLWikiPage] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest
    
    Write-Verbose "[New-GLWikiPage] Response: $Response"

    return $Response
}