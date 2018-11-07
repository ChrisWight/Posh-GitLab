function Get-GLWikiPage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,
        
        [Parameter(Mandatory = $False, Position = 1, ParameterSetName = 'Slug')]
        [ValidateNotNullOrEmpty()]
        [String]
        $Slug,

        [Parameter(Mandatory = $False, ParameterSetName = 'Content')]
        [ValidateNotNullOrEmpty()]
        [Switch]
        $WithContent
    )

    $Resource = "projects/$ProjectID/wikis"

    if ($Slug) {
        $Resource = '{0}/{1}' -f $Resource, $Slug
    }

    $Invoke_GitLabRequest = @{
        Resource   = $Resource
        Parameters = @{}
    }

    if ($WithContent) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('with_content', 'true')
    }

    Write-Debug "[Get-GLWikiPage] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"
    
    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLWikiPage] Response: $($Response | Out-String)"
    
    return $Response
}