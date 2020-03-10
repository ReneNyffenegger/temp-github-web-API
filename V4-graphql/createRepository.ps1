#  $secString=convertTo-secureString $env:githubAPItoken -asPlainText -force

$response = invoke-webrequest `
    https://api.github.com/graphql            `
   -method         POST                       `
   -contentType    application/json           `
   -headers @{Authorization = "Bearer $env:githubAPItoken"} `
   -body '{ "query":
            "mutation { createRepository ( input: { name: \"the-foo-repo\", visibility: PRIVATE } ) { clientMutationId } } " 
          }'
          
$response.content          
          
#
#  Use -authentication in PowerShell 6 or 7 ?
#   -authentication bearer -token $secString   `
#          
