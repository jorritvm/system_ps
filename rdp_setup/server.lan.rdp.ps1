Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

$server = "server.lan"
$width  = 1920
$height = 1080

Start-Process mstsc.exe -ArgumentList "/v:$server /w:$width /h:$height"