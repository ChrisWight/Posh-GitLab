@{
    Parameters = @{
        StatusCode = 409
    }
    Output = @{
        StatusCode = 409
        StatusText = 'Conflict - A conflicting resource already exists, e.g. creating a project with a name that already exists'
        Successful = $False
        Type       = 'System.Collections.Hashtable'
    }
}