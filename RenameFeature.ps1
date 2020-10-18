#Renames functions and filenames. Used when creating functions for an API feature
$Folder = 'C:\Git\Posh-GitLab\Posh-GitLab\Public\Protected Tags'

$Search = 'GLRelease'
$FileSuffix = '-todo'
$Replace = 'GLProtectedTag'

#Rename Files
Get-ChildItem $Folder | ForEach-Object {
    $File = $_
    if($File.fullname -match $Search)
    {
        $NewName = "$($File.BaseName -replace $Search, $Replace)$FileSuffix$($File.Extension)"
        $File | rename-item -NewName $NewName
    }
}

#Replace text within files
Get-ChildItem $Folder  | ForEach-Object {
    $File = $_
    (get-content $File.Fullname) -replace $Search, $Replace | out-file $File.FullName

}