function Invoke-GLRequest {
    [CmdletBinding()]
    param(
        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Resource = 'user',

        [ValidateSet('GET', 'POST', 'PUT', 'DELETE')]
        [String]
        $Method = 'GET',

        [Hashtable]
        $Parameters = @{},

        [String[]]
        $ExitCode,

        [Int]
        $PerPage = 100
    )

    if (-not ($Script:GitLabAPI)) {
        Throw [System.Management.Automation.ParameterBindingException] 'GitLab API is not configured yet. Run Set-GLServer first!'
    }

    [System.Collections.ArrayList] $QueryString = @()

    if ($Method -eq 'GET') {
        foreach ($Param in $Parameters.GetEnumerator()) {
            $Name = [uri]::EscapeDataString($Param.Name)
            $Value = [uri]::EscapeDataString($Param.Value)
            [Void]$QueryString.Add("${Name}=${Value}")
        }

        $Parameters = @{'PRIVATE-TOKEN' = $Script:GitLabAPI.PrivateToken}
    } elseif (($method -eq 'PUT') -or ($method -eq 'POST')) {
        $Body = ConvertTo-Json $Parameters
        $Parameters = @{'PRIVATE-TOKEN' = $Script:GitLabAPI.PrivateToken}
    } else {
        [Void]$Parameters.Add('PRIVATE-TOKEN', $Script:GitLabAPI.PrivateToken)
    }

    [String]$QueryString = $QueryString -join '&'

    $Invoke_RestMethod = @{
        Method          = $Method
        Uri             = ('{0}/api/v{1}/{2}?{3}' -f $Script:GitLabApi.Server, $Script:GitLabAPI.APIVersion, $Resource, $QueryString).Trim("?")
        Headers         = $Parameters
        UseBasicParsing = $True
        ErrorAction     = 'Stop'
    }

    if ($Body) {
        [Void]$Invoke_RestMethod.Add('Body', $Body)
        [Void]$Invoke_RestMethod.Add('ContentType', 'application/json')
    }

    Write-Debug "Invoke-WebRequest: $($Invoke_RestMethod | Out-String)"

    $Response = Invoke-WebRequest @Invoke_RestMethod

    if (($Response.GetType().FullName -eq 'Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject') -and (($Response | Out-String).Trim().StartsWith('<!DOCTYPE html>'))) {
        Throw [System.Security.Authentication.AuthenticationException] "It doesn't appear that you're logged in. Rerun Set-GLServer and verify PrivateToken has correct permissions."
    }

    $Results = Get-GLResults $Response.StatusCode $ExitCode

    Write-Debug "Results: $($Results | Out-String)"

    if (-not ($Results.Successful)) {
        Throw $Results.Text
    }

    try {
        $Content = ConvertFrom-Json $Response.Content
    } catch [System.ArgumentException] {
        $Content = $Response.Content
    }
    
    if ($Response.Headers.Link) {
        while ($Response.Headers.Link.Split(',').Trim().Split(';').Trim() -icontains 'rel="next"') {
            foreach ($link in $Response.Headers.Link.Split(',').Trim()) {
                $rel_link = $link.Split(';').Trim()
                if ($rel_link[1] -eq 'rel="next"') {
                    $Invoke_RestMethod.set_item('Uri', $rel_link[0].Replace('<', '').Replace('>', ''))
                    break
                }
            }

            Write-Debug "Invoke-WebRequest: $($Invoke_RestMethod | Out-String)"
            $Response = Invoke-WebRequest @Invoke_RestMethod

            $Results = Get-GLResults $Response.StatusCode $ExitCode

            Write-Debug "Results: $($Results | Out-String)"

            if (-not ($Results.Successful)) {
                Throw $Results.Text
            }
            
            try {
                $Content += ConvertFrom-Json $Response.Content
            } catch [System.ArgumentException] {
                $Content += $Response.Content
            }
        }
    }

    return $Content
}