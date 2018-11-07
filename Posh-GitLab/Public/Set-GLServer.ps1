function Set-GLServer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Server = $env:GitLabServer,

        [Parameter(Mandatory = $True, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [String]
        $PrivateToken = $env:GitLabPrivateToken,

        [Parameter(Mandatory = $False)]
        [ValidateNotNullOrEmpty()]
        [String]
        $APIVersion = '4'
    )

    $Script:GitLabAPI = @{
        Server = $Server
        PrivateToken = $PrivateToken
        APIVersion = $APIVersion
    }
}