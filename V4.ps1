#
#    $ghv4 = [githubWebAPI_V4]::new($env:githubAPItoken)
#    $ghv4.createRepository('test-one', 'PUBLIC')
#
#  --------------------------------------------------
#
#    upload-file-to-RN temp-github-web-API / . V4.ps1 


set-strictMode -version 2

class githubWebAPI_V4 {

  [String] hidden $token;

   githubWebAPI_V4([String] $token_) {
       $this.token = $token_
   }

  [Microsoft.PowerShell.Commands.HtmlWebResponseObject] request($query_nl) {

   #
   # Apparently, graphql and/or github does not allow new lines in the query string.
   # So, replace them
   #
      $query = $query_nl.replace("`n", '').replace("`r", '')

   #
   #  JSON Request: Escape double quotes
   #
      $query = $query.replace('"', '\"')

      write-verbose "query = $query"

      $body  = '{{ "query": "{0}" }}' -f $query

      $response = invoke-webrequest `
          https://api.github.com/graphql                          `
         -method         POST                                     `
         -contentType    application/json                         `
         -headers @{Authorization = "Bearer $($this.token)"}      `
         -body           $body

       write-host $response.GetType().FullName

       return $response
   }

   [bool] createRepository([String] $name, [String] $visibility) {

      if ($visibility -notIn 'PUBLIC', 'PRIVATE', 'INTERNAL') {
         write-error "visibility not in 'PUBLIC', 'PRIVATE', 'INTERNAL'"
         return $false;
      }

      $query = '
      mutation {{
         createRepository (
            input: {{
               name      : "{0}",
               visibility:  {1}
            }}
         )
         {{
             clientMutationId
         }}
     }}'  -f $name, $visibility
 

#    write-verbose $query
     $response = $this.request($query)
 
    #
    # Note: response might be '200 OK' even if repository was not created.
    #
       write-host "$($response.StatusCode) $($response.StatusDescription)"
       return $response.StatusCode -eq '200'
   }

}