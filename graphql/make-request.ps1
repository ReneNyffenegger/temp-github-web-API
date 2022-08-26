#
#  $json = ./make-request $githubToken __schema.graphql
#  $json.__schema.types
#

param (
   [string] $token,
   [string] $param
)

set-strictMode -version 3

if (test-path $param -errorAction ignore) {
   $query_nl = get-content -raw $param
}
else {
   $query_nl = $param
}


# $query = $query_nl
# $query = $query_nl.replace("`n", '*').replace("`r", '')

   #
   # Apparently, graphql and/or github does not allow new lines in the query string.
   # So, replace them
   #
$query = $query_nl -replace '(?m)#.*$', ''
$query = $query.replace("`n", '').replace("`r", '')
# $query = ($query_nl -replace "`n", "") -replace "`r", ''

   #
   #  JSON Request: Escape double quotes
   #
$query = $query.replace('"', '\"')


$body  = '{{ "query": "{0}" }}' -f $query
# $body  = '{{ "{0}" }}' -f $query

# $body

$response = invoke-webrequest `
    https://api.github.com/graphql                  `
   -method         POST                             `
   -contentType    application/json                 `
   -headers      @{Authorization = "Bearer $token"} `
   -body           $body


$json = convertFrom-json $response.content


if ($json.psObject.properties['errors']) {
   throw $json.errors.message
}

# $response

# (convertFrom-json ($response.content)).data
$json.data
