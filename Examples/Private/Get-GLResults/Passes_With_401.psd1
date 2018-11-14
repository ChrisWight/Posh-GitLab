@{
    Parameters = @{
        StatusCode = 401
    }
    Output = @{
        StatusCode = 401
        StatusText = 'Unauthorized - The user is not authenticated, a valid user token is necessary, see above'
        Successful = $False
        Type       = 'System.Collections.Hashtable'
    }
}