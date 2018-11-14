@{
    Parameters = @{
        StatusCode = 403
    }
    Output = @{
        StatusCode = 403
        StatusText = 'Forbidden - The request is not allowed, e.g. the user is not allowed to delete a project'
        Successful = $False
        Type       = 'System.Collections.Hashtable'
    }
}