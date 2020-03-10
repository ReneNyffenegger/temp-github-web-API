$secString=convertTo-secureString $env:githubAPItoken -asPlainText -force
$repo = ...

curl.exe -u x:$env:githubAPItoken  https://api.github.com/repos/ReneNyffenegger/$repo

invoke-webrequest https://api.github.com/repos/ReneNyffenegger/$repo -authentication bearer -token $secString
invoke-webrequest https://api.github.com/repos/ReneNyffenegger/$repo -headers @{Authorization = "Bearer $env:githubAPItoken"}
