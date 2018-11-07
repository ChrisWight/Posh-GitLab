function New-GLTag {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $TagName,

        [Parameter(Mandatory = $True, Position = 2)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Reference,
        
        [ValidateNotNullOrEmpty()]
        [String]
        $Message,
        
        [ValidateNotNullOrEmpty()]
        [String]
        $Description
    )

    $Invoke_GitLabRequest = @{
        Resource       = "projects/$ProjectID/repository/tags"
        Method         = 'POST'
        Parameters     = @{
            tag_name            = $TagName
            ref                 = $Reference
            message             = $Message
            release_description = $Description
        }
    }

    Write-Debug "[New-GLTag] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest
    
    Write-Verbose "[New-GLTag] Response: $Response"

    return $Response
}