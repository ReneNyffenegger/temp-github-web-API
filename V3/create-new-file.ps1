$fileName = 'create-new-file.ps1'
$fileToUpload = "$pwd\$fileName"

$body = '{{"message": "upload", "content": "{0}" }}' -f $base64

$repo='temp-github-web-API'
$pathInRepo='V3'

invoke-webrequest `
    https://api.github.com/repos/ReneNyffenegger/$repo/contents/$pathInRepo/$fileName            `
   -method         PUT                        `
   -contentType    application/json           `
   -headers @{Authorization = "Bearer $env:githubAPItoken"} `
   -body $body
