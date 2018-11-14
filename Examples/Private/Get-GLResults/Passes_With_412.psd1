@{
    Parameters = @{
        StatusCode = 412
    }
    Output = @{
        StatusCode = 412
        StatusText = 'Indicates the request was denied. May happen if the If-Unmodified-Since header is provided when trying to delete a resource, which was modified in between.'
        Successful = $False
        Type       = 'System.Collections.Hashtable'
    }
}