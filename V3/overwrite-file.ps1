$secString=convertTo-secureString $env:githubAPItoken -asPlainText -force
# invoke-webrequest https://api.github.com/repos/ReneNyffenegger/ldp-Ordnung -authentication bearer -token $secString
# invoke-webrequest https://api.github.com/repos/ReneNyffenegger/ldp-Ordnung -headers @{Authorization = "Bearer $env:githubAPItoken"}
curl.exe -u x:$env:githubAPItoken  https://api.github.com/repos/ReneNyffenegger/$repo


$fileToUpload = "$pwd\upload-sources.ps1"
# $fileToUpload = "$pwd\classes.ps1"
$base64 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($fileToUpload))
# curl.exe -u x:$env:githubAPItoken --upload-file upload-sources.ps1 https://api.github.com/ReneNyffenegger/repos/ReneNyffenegger/temp-PowerShell/misc/sqlite3/upload-sources.ps1
$txt = '{{"message": "upload",  "committer": {{"name": "nm", "email": "email@abfall.ch"}}, "content": "{0}" }}' -f $base64
# $txt
curl.exe -i -X PUT -u x:$env:githubAPItoken -d "$txt" https://api.github.com/repos/ReneNyffenegger/temp-PowerShell/misc/sqlite3/classes.ps1
# curl.exe -i -X PUT -u x:$env:githubAPItoken -d "$txt" https://api.github.com/repos/ReneNyffenegger/temp-PowerShell/misc/sqlite3/classes.ps1

# curl.exe https://api.github.com/hub