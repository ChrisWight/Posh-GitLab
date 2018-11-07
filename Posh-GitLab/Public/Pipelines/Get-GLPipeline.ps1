function Get-GLPipeline {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [String]
        $ProjectID,

        [Parameter(Mandatory = $False, Position = 1, ParameterSetName = 'FindSpecific')]
        [ValidateNotNullOrEmpty()]
        [String]
        $PipelineID,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateSet('running', 'pending', 'finished', 'branches', 'tags')]
        [String]
        $Scope,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateSet('running', 'pending', 'success', 'failed', 'canceled', 'skipped')]
        [String]
        $Status,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [String]
        $Reference,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [String]
        $SHA,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [Switch]
        $YamlErrors,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [String]
        $Name,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [String]
        $Username,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateSet('id', 'status', 'ref', 'user_id')]
        [String]
        $OrderBy,

        [Parameter(Mandatory = $False, ParameterSetName = 'FindAll')]
        [ValidateSet('asc', 'desc')]
        [String]
        $SortBy
    )

    $Resource = "projects/$ProjectID/pipelines"

    if ($PipelineID) {
        $Resource = '{0}/{1}' -f $Resource, $PipelineID
    }

    $Invoke_GitLabRequest = @{
        Resource   = $Resource
        Parameters = @{}
    }

    if ($Scope) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('scope', $Scope.ToLower())
    }

    if ($Status) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('status', $Status.ToLower())
    }

    if ($Reference) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('ref', $Reference.ToLower())
    }

    if ($SHA) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('sha', $SHA.ToLower())
    }

    if ($YamlErrors) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('yaml_errors', 'true')
    }

    if ($Name) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('name', $Name.ToLower())
    }

    if ($Username) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('username', $Username.ToLower())
    }

    if ($OrderBy) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('order_by', $OrderBy.ToLower())
    }

    if ($SortBy) {
        [Void]$Invoke_GitLabRequest.Parameters.Add('sort', $SortBy.ToLower())
    }
    
    Write-Debug "[Get-GLPipeline] Invoke-GLRequest: $($Invoke_GitLabRequest | ConvertTo-Json)"

    $Response = Invoke-GLRequest @Invoke_GitLabRequest

    Write-Verbose "[Get-GLPipeline] Response: $Response"

    return $Response
}