$fileName = 'overwrite-file.ps1'
$fileToUpload = "$pwd\$fileName"

$base64 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($fileToUpload))

$repo='temp-github-web-API'
$pathInRepo='V3'

$response = invoke-restMethod `
    https://api.github.com/repos/ReneNyffenegger/$repo/contents/$pathInRepo/$fileName            `
   -headers @{Authorization = "Bearer $env:githubAPItoken"}

$sha = $response.sha

$body = '{{"message": "upload", "content": "{0}", "sha": "{1}" }}' -f $base64, $sha

invoke-webrequest `
    https://api.github.com/repos/ReneNyffenegger/$repo/contents/$pathInRepo/$fileName            `
   -method         PUT                        `
   -contentType    application/json           `
   -headers @{Authorization = "Bearer $env:githubAPItoken"} `
   -body $body