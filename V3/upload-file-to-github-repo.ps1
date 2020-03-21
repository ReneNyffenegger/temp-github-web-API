#
#   upload-file-to-github-repo . upload-file-to-github-repo.ps1 /V3 upload-file-to-github-repo.ps1 temp-github-web-API ReneNyffenegger 'n/a' $env:githubAPItoken
#
#   Assign 'continue' to preference variable $verbosePreference
#   for verbose output.
#

set-strictMode -version 2

function upload-file-to-github-repo($localPath, $localFilename, [String] $repoPath, $repoFilename, $repoName, $repoOwner, $message, $token) {
   #
   #  $repoPath must start with a slash. 
   #
   if ($repoPath.substring(0, 1) -ne '/') {
      write-error "repoPath $repoPath does not begin with a slash"
      return
   }

   #
   #      File content must be represented in base 64
   #
   $localFileAbsolutePath = (resolve-path "$localPath/$localFilename").providerPath

   write-verbose "localFileAbsolutePath: $localFileAbsolutePath"

   if (! (test-path $localFileAbsolutePath)) {
   #
   #  TODO: is this test necessary? resolve-path seems to
   #  throws an error if the path does not exist.
   #
      "$localFileAbsolutePath does not exist"
       return
   }

   $base64 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($localFileAbsolutePath.ToString()))
   if ($base64 -eq $null) {
      "base64 conversion failed for $($localFileAbsolutePath)"
       return
   }


   #
   #   Make sure repoPath ends in slash
   #
   if ( $repoPath.substring($repoPath.length-1) -ne '/') {
      $repoPath = "$repoPath/"
   }

   $url = "https://api.github.com/repos/$repoOwner/$repoName/contents$repoPath$repoFilename"

   try {

    #
    #     TODO: PowerShell 7 introduces option -skipHTTPErrorCheck
    #           This option should probably be used in order to have
    #           see what HTTP status code was returned.
    #
    # github API token is required for private repositories

      $response = invoke-restMethod                      `
         $url                                            `
        -headers @{Authorization = "bearer $token"}

   }
   catch [System.Net.WebException] {
     #
     #  I am too lazy to evaluate the details and just assume
     #  that this is a 404. So the resource needs to be created
     #
        write-verbose 'Resource probably does not exist. Trying to create it'

        $body = '{{"message": "{0}", "content": "{1}" }}' -f $message, $base64

     #
     #  TODO: of course, if the url $url does not exist on the webserver,
     #  the following invocation fails.
     #
        $response = invoke-webrequest $url                                               `
          -method          PUT                                                           `
          -contentType     application/json                                              `
          -headers       @{Authorization = "bearer $token"}                              `
          -body            $body

      #
      # expected: 201 Created
      #
        write-verbose "$($response.StatusCode) $($response.StatusDescription)"
        return
   }
   write-verbose "file seems to exit, updating it"
   $sha = $response.sha
   write-verbose "SHA = $sha"

   $body = '{{"message": "{0}", "content": "{1}", "sha": "{2}" }}' -f $message, $base64, $sha

   $response = invoke-webrequest $url                                               `
     -method          PUT                                                           `
     -contentType     application/json                                              `
     -headers       @{Authorization = "bearer $token"}                              `
     -body            $body
}