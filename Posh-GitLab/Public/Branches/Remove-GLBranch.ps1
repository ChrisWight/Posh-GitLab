function Remove-GLBranch {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectId,

        [Parameter(Mandatory = $True, Position = 1, ParameterSetName = "SpecificBranch")]
        [ValidateNotNullOrEmpty()]
        [String]
        $BranchName,

        [Parameter(Mandatory = $True, ParameterSetName = "Merged")]
        [Switch]
        $RemoveMerged
    )

    $Invoke_GitLabRequest = @{
        Method         = "DELETE"
    }

    if ($RemoveMerged) {
        [Void]$Invoke_GitLabRequest.Add('Resource', "projects/$ProjectID/repository/merged_branches")
    } else {
        [Void]$Invoke_GitLabRequest.Add('Resource', "projects/$ProjectID/repository/branches")
        [Void]$Invoke_GitLabRequest.Add('Parameters', @{
                branch = $BranchName
            }
        )
    }

    Write-Debug "[Remove-GLBranch] Invoke-GLRequest: $($Invoke_GitLabRequest | Out-String)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Remove-GLBranch] Response: $($Response | Out-String)"
    
    return $Response
}