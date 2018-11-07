function Get-GLRepositoryTree {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,
        
        [Parameter(Mandatory = $False, Position = 1)]
        [String]
        $Reference,

        [Parameter(Mandatory = $False, Position = 2)]
        [String]
        $Path,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Recursive
    )

    $Invoke_GitLabRequest = @{
        'Resource' = "projects/$ProjectID/repository/tree"
    }

    Write-Debug "[Get-GLRepositoryTree] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Debug "[Get-GLRepositoryTree] Response: $Response"

    return $Response
}