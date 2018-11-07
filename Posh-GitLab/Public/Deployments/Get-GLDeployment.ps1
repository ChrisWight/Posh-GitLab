function Get-GLDeployment {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $DeploymentID
    )

    $Invoke_GitLabRequest = @{
        Resource = "projects/$ProjectID/deployments"
    }

    if ($DeploymentID) {
        $Invoke_GitLabRequest.Resource = '{0}/{1}' -f $Invoke_GitLabRequest.Resource, $DeploymentID
    }

    Write-Debug "[Get-GLDeployment] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLDeployment] Results: $Response"

    return $Response
}