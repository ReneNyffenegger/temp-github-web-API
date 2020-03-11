set-strictMode -version 2

function uploadFileToGithub($localPath, $localFilename, $repoPath, $repoFilename, $repoName, $repoOwner, $message, $token) {

   #
   #      File content must be represented in base 64
   #
   $base64 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes("$localPath/$localFilename"))

   $url = "https://api.github.com/repos/$repoOwner/$repoName/contents/$repoPath/$repoFilename"

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


        write-warning 'Resource probably does not exist. Trying to create it'

        $body = '{{"message": "{0}", "content": "{1}" }}' -f $message, $base64

        $response = invoke-webrequest $url                                               `
          -method          PUT                                                           `
          -contentType     application/json                                              `
          -headers       @{Authorization = "bearer $token"}                              `
          -body            $body

        $response.GetType().FullName
        $response | select *

   }

#   $response

#   $response.GetType().FullName

}
