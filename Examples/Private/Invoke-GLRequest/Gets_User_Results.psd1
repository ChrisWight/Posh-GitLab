@{
    Parameters = @{
        Resource = 'User'
    }
    GitLabAPI  = @{
        Server       = 'https://gitlab.domain.com'
        PrivateToken = 'lasdjflaskjfdlacv8o034'
        APIVersion   = 'v4'
    }
    Output     = @{
        Type = 'System.Management.Automation.PSCustomObject'
    }
}