<#
.NOTES

    Adapted from https://github.com/ngetchell/PSGitLab

#>
function Get-GLResults {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $True, Position = 0)]
        [String]
        $StatusCode,

        [Parameter(Mandatory = $False, Position = 1)]
        [String[]]
        $ExitCode
    )

    switch ($StatusCode) {
        '200' {
            $Text = 'OK - The GET, PUT or DELETE request was successful, the resource(s) itself is returned as JSON'
            $Successful = $True
        }
        '201' {
            $Text = 'Created - The POST request was successful and the resource is returned as JSON'
            $Successful = $True
        }
        '204' {
            $Text = 'The server has successfully fulfilled the request and that there is no additional content to send in the response payload body.'
            $Successful = $True
        }
        '304' {
            $Text = 'Indicates that the resource has not been modified since the last request.'
            $Successful = $False
        }
        '400' {
            $Text = 'Bad Request - A required attribute of the API request is missing, e.g. the title of an issue is not given'
            $Successful = $False
        }
        '401' {
            $Text = 'Unauthorized - The user is not authenticated, a valid user token is necessary, see above'
            $Successful = $False
        }
        '403' {
            $Text = 'Forbidden - The request is not allowed, e.g. the user is not allowed to delete a project'
            $Successful = $False
        }
        '404' {
            $Text = 'Not Found - A resource could not be accessed, e.g. an ID for a resource could not be found'
            $Successful = $False
        }
        '405' {
            $Text = 'Method Not Allowed - The request is not supported'
            $Successful = $False
        }
        '409' {
            $Text = 'Conflict - A conflicting resource already exists, e.g. creating a project with a name that already exists'
            $Successful = $False
        }
        '412' {
            $Text = 'Indicates the request was denied. May happen if the If-Unmodified-Since header is provided when trying to delete a resource, which was modified in between.'
            $Successful = $False
        }
        '422' {
            $Text = 'Unprocessable - The entity could not be processed'
            $Successful = $False
        }
        '500' {
            $Text = 'Server Error - While handling the request something went wrong on the server side'
            $Successful = $False
        }
    }

    if ($ExitCode -contains $StatusCode) {
        $Successful = $True
    }
    
    return @{
        StatusCode = $StatusCode
        StatusText = $Text
        Successful = $Successful
    }
}