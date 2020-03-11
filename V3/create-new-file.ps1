$fileName = 'upload-sources.ps1'
$fileToUpload = "$pwd\$fileName"
$body = '{{"message": "upload", "content": "{0}" }}' -f $base64

$repo=...
$pathInRepo=...

invoke-webrequest `
    https://api.github.com/repos/ReneNyffenegger/$repo/contents/$pathInRepo/$fileName            `
   -method         PUT                        `
   -contentType    application/json           `
   -headers @{Authorization = "Bearer $env:githubAPItoken"} `
   -body $body
