@{
    Parameters = @{
        StatusCode = 400
    }
    Output = @{
        StatusCode = 400
        StatusText = 'Bad Request - A required attribute of the API request is missing, e.g. the title of an issue is not given'
        Successful = $False
        Type       = 'System.Collections.Hashtable'
    }
}