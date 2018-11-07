function Get-GLRepositoryBlob {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [String]
        $SHA,

        [Parameter(Mandatory = $False)]
        [Switch]
        $Raw
    )

    $Resource = "projects/$ProjectID/repository/blobs/$SHA"

    if ($Raw) {
        $Resource = '{0}/raw' -f $Resource
    }

    $Invoke_GitLabRequest = @{
        'Resource' = $Resource
    }

    Write-Debug "[Get-GLRepositoryBlob] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLRepositoryBlob] Response: $Response"

    return $Response
}