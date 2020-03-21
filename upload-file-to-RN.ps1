#
#   upload-file-to-RN temp-github-web-API '' . upload-file-to-RN.ps1 
#

function upload-file-to-RN($repoName, $repoPath, $localPath, $fileName)  {

# $localPath, $localFilename, $repoPath, $repoFilename, $repoName, $repoOwner, $message, $token

   upload-file-to-github-repo              `
        -localPath     $localPath          `
        -localFilename $fileName           `
        -repoPath      $repoPath           `
        -repoFileName  $fileName           `
        -repoName      $repoName           `
        -repoOwner     ReneNyffenegger     `
        -message      'n/a'                `
        -token         $env:githubAPItoken
}