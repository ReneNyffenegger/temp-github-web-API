$secString=convertTo-secureString $env:githubAPItoken -asPlainText -force


### get repo info

$repo = ...

curl.exe -u x:$env:githubAPItoken  https://api.github.com/repos/ReneNyffenegger/$repo

invoke-webrequest https://api.github.com/repos/ReneNyffenegger/$repo -authentication bearer -token $secString
invoke-webrequest https://api.github.com/repos/ReneNyffenegger/$repo -headers @{Authorization = "Bearer $env:githubAPItoken"}

### Trying to upload file

$fileToUpload = "$pwd\classes.ps1"
$base64 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($fileToUpload))

$txt = '{{"message": "upload",  "committer": {{"name": "nm", "email": "email@abfall.ch"}}, "content": "{0}" }}' -f $base64
curl.exe -i -X PUT -u x:$env:githubAPItoken -d "$txt" https://api.github.com/repos/ReneNyffenegger/temp-PowerShell/misc/sqlite3/classes.ps1
