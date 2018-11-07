function Get-GLMergeRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,

        [Parameter(Mandatory = $False, ParameterSetName = 'SpecifiedMR')]
        [ValidateNotNullOrEmpty()]
        [String]
        $MergeRequestIID,
        
        [Parameter(Mandatory = $False, ParameterSetName = 'SpecifiedMR')]
        [ValidateSet('Opened', 'Closed', 'Locked', 'Merged')]
        [String]
        $State,

        [Parameter(Mandatory = $False)]
        [ValidateSet('Created', 'Updated')]
        [String]
        $OrderedBy
    )

    $Invoke_GitLabRequest = @{
        'Resource' = "projects/$ProjectID/merge_requests/$MergeRequestIID/merge"
        'Method'   = 'PUT'
    }
    
    Write-Debug "Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Debug "[Get-GLMergeRequest] Response: $($Response | Out-String)"

    return $Response
}