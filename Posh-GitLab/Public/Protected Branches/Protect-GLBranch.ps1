function Protect-GLBranch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $BranchName,

        [ValidateSet('Maintainer', 'Developer', '40', '30')]
        [String]
        $PushAccessLevel = 'Maintainer',

        [ValidateSet('Maintainer', 'Developer', '40', '30')]
        [String]
        $MergeAccessLevel = 'Maintainer'
    )

    $AccessLevels = Get-GLAccessLevels $PushAccessLevel $MergeAccessLevel

    Write-Information "Access levels: $($AccessLevels | Out-String)"

    $Invoke_GitLabRequest = @{
        Resource        = "projects/$ProjectID/protected_branches/$BranchName"
        Method          = 'POST'
        Parameters      = @{
            push_access_level   = $AccessLevels.Push
            merge_access_level  = $AccessLevels.Merge
        }
    }
    
    Write-Debug "[Protect-GLBranch] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Protect-GLBranch] Response: $($Response | Out-String)"

    return $Response
}