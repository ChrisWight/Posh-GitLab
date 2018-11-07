function Get-GLTag {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $False, Position = 1, ParameterSetName = 'FindSpecific')]
        [String]
        $TagName,

        [Parameter(ParameterSetName = 'FindAll')]
        [ValidateSet('name', 'updated')]
        [String]
        $OrderBy = 'updated',

        [Parameter(ParameterSetName = 'FindAll')]
        [ValidateSet('asc', 'desc')]
        [String]
        $Sort = 'desc'
    )

    switch ($PSCmdlet.ParameterSetName) {
        'FindSpecific' {
            $Invoke_GitLabRequest = @{
                'Resource' = "projects/$ProjectID/repository/tags/$TagName";
            }
        }
        'FindAll' {
            $Invoke_GitLabRequest = @{
                'Resource' = "projects/$ProjectID/repository/tags";
                'Parameters' = @{
                    order_by = $OrderBy
                    sort     = $Sort
                }
            }
        }
    }

    Write-Debug "[Get-GLTag] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLTag] Response: $Response"

    return $Response
}