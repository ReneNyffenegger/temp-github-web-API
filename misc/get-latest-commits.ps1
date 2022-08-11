#
#    https://stackoverflow.com/a/69636012/180275
#
$url = 'https://api.github.com/users/ReneNyffenegger/events/public'

$resBody = invoke-webRequest $url


$cont = $resBody.content
$json = convertFrom-json $cont

foreach ($x in $json) {
  '{0,5} {1,-15} {2,-30}' -f $x.id, $x.type, $x.repo.name
#  $x 
}
