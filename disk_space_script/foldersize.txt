$divisor = "";
$csv = $( import-csv ./input.csv -Delimiter ';' ) 
$_div="";

$divisor = $csv.Divisor;
$decimals = $csv.Decimals;
$mTo = $csv.To;
$mFrom = $csv.From;
$mSubject = $csv.Subject;
$template = Get-Content $( $csv.MailTemplate );
$outputFile = $csv.OutputFile;

$folderSizeBlock = "";

switch($divisor) {
    "KB" { $_div = "1KB"; break}
    "MB" { $_div = "1MB"; break}
    "GB" { $_div = "1GB"; break}
    "TB" { $_div = "1TB"; break}
    default { $_div = "1MB"; $divisor = "MB"; break}
}

$numberFormat = "0";
if($decimals -gt 0) {
    $numberFormat += ".";
}


for($i = 0; $i -lt $decimals; $i++) {
    $numberFormat += "0";
}


$parents = $($csv.Paths).Split('|');
foreach ($parent in $parents) 
{
    $folderSizeBlock += "<div style=`"border: 1px dotted black;`">"
    $folderSizeBlock += "$parent`n`r";
    $folderSizeBlock += "<ul>`n`r";
    $children = $( Get-ChildItem $parent -Directory )
    foreach($path in $children) 
    {
        $sum =  (Get-ChildItem $path.FullName -Recurse | Measure-Object -Property Length -Sum).Sum / $_div;
        $result = $sum.ToString($numberFormat);
        $text = [string]::Format("{0}: {1} {2}", $path, $result, $divisor) 

        $folderSizeBlock += "<li>$text</li>`n`r"
    }
    $folderSizeBlock += "</ul>`n`r";
    $folderSizeBlock += "</div>" ;
}
$mBody = $template.Replace("+FOLDER_SIZE_BLOCK+", $folderSizeBlock);
$mBody = $mBody.Replace("+SERVER_NAME+", $($env:computername));
$mSubject = $mSubject.Replace("+SERVER_NAME+", $($env:computername));
$mBody | Out-file $outputFile

$SmtpClient = new-object system.net.mail.smtpClient
$MailMessage = new-object system.net.mail.mailmessage
$SmtpClient.host = "smtp.belgrid.net"
$MailMessage.From = $mFrom
$MailMessage.To.add($mTO)
$MailMessage.Subject = $mSubject
$MailMessage.Body = $mBody
$MailMessage.IsBodyHtml = $true
$SmtpClient.Send($mailmessage)


# SIG # Begin signature block
# MIIMtAYJKoZIhvcNAQcCoIIMpTCCDKECAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUdgJ6N2bYfmwOuoFk1xlLEAUX
# jfugggoaMIIEPTCCAyWgAwIBAgITSgAAAA3eRdgmzcKYFAAAAAAADTANBgkqhkiG
# 9w0BAQsFADAfMR0wGwYDVQQDExRFbGlhIE9mZmxpbmUgUm9vdCBDQTAeFw0xOTA3
# MjQxNDA3NTNaFw0zOTA3MjQxNDE3NTNaMEwxEzARBgoJkiaJk/IsZAEZFgNuZXQx
# FzAVBgoJkiaJk/IsZAEZFgdCZWxncmlkMRwwGgYDVQQDExNFbGlhIElOVCBJc3N1
# aW5nIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5XVvG7mn1zs4
# PBf9ihWOx0RQwFTzcCegmMQGWPLQgzJN5/mLLrqiIzawOU2V6Yi2Mzr3StusU6gw
# ZknUA4QoIPBtQS+NrtETWo5vPp4jqBBzDe2oZi9I7aAgDmVPGN+3/Ajo5cSKLdKA
# bi+cyNS1UqSW2x6nuIEZVpzLFSMLKl5awpMwUqKskEG17fG/2Xi0qiL9HSwaRNQi
# qLAGNSL/p7xOkSO2kEjwnugSCSnuTRziZHB75KKsX6/Pj/qoHiR3Ve36jwOAjPfT
# 6RsQglfmmcevIOYSWAhwObZZgaaTUogHmqtp44BzQ6RVdz2C1poPetQxzbwxTjsF
# VFYiOfuJZwIDAQABo4IBQzCCAT8wEAYJKwYBBAGCNxUBBAMCAQEwIwYJKwYBBAGC
# NxUCBBYEFFgjssUKhjy7PTSEsKSNq6Ice1JaMB0GA1UdDgQWBBT0A00Ag20xo7oB
# zx+VXY9YeDKLBTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRtkYT36tD6lW84qoQDBKRJ
# kFNfUTBABgNVHR8EOTA3MDWgM6Axhi9odHRwOi8vY2RwLmJlbGdyaWQubmV0L0Vs
# aWFfT2ZmbGluZV9Sb290X0NBLmNybDBLBggrBgEFBQcBAQQ/MD0wOwYIKwYBBQUH
# MAKGL2h0dHA6Ly9jZHAuYmVsZ3JpZC5uZXQvRWxpYV9PZmZsaW5lX1Jvb3RfQ0Eu
# Y3J0MA0GCSqGSIb3DQEBCwUAA4IBAQAWKhhsmU8AYraDlkpESPOuMNaplk2hrbg2
# Fxy6KMa0XRp4uxXTv3tvx0S5j2Di5qV1VeVf5MnoqLs6Xw/maEJZylad3svnqzq/
# AUf5tjRMdJfOZU3vsUSGW1ge2U233LBjtFbTdBc3RmH4jZO3azH1YDkJQ6fRhzTG
# UZ/tCR6WZesSwibmO21VDKeQ5o0WlTk3NHv10CICqUBsLYLh+iEIe/FvNi1dxXDc
# GM5ZKBrrbFLuF63wOy34gs5A7GiB7WTOomrSL0Dk4i25irzMW+W44mQDqH3nhpjX
# bZ2hU3vCJ7pr8+U8qwuJ//n8NL4XvAlTZ7rTqTC4eH10Yz50D7AYMIIF1TCCBL2g
# AwIBAgITNAAAABlFBoKwd2G+egABAAAAGTANBgkqhkiG9w0BAQsFADBMMRMwEQYK
# CZImiZPyLGQBGRYDbmV0MRcwFQYKCZImiZPyLGQBGRYHQmVsZ3JpZDEcMBoGA1UE
# AxMTRWxpYSBJTlQgSXNzdWluZyBDQTAeFw0xOTA4MTQxMjIxMDRaFw0yOTA4MTEx
# MjIxMDRaMBsxGTAXBgNVBAMTEFNURUFNIFBTIFNpZ25pbmcwggEiMA0GCSqGSIb3
# DQEBAQUAA4IBDwAwggEKAoIBAQDPbeNRlN+gKO5qYTZKj3AiJn7kHL0Ub+r/yHwn
# Pc/DlpCp0AQFLcF1f5nyIQeepCC7dFWDcRSURSt8J9gPSdy/mWcCnJ2tyerSsGTZ
# HG3da+gGULZP5ITgMO05mc9kdKFGAaS03s09CQwuHob7cdF07b7wOehYOXh6TYTC
# SVcEOOLVEdp0niVNsMwpG2TE27t67QCoXnrc1rNoD225+kA+kInf+qj19rd1B8i1
# AQzOBm8GVKsn7BdSF1Fs4/D3o7Ael6kICavJQ8yVpLN6CobnoyyD0vdBJX56HfkT
# jr4kpBDxL9W3aNIZ1TP5aqiwlOB57LSqLzF7m1QoeW14cvlVAgMBAAGjggLfMIIC
# 2zA+BgkrBgEEAYI3FQcEMTAvBicrBgEEAYI3FQiEmNRlhNvSbYf9iymBt/4UhJS3
# P4FkhPOmbIemu2kCAWQCAQwwEwYDVR0lBAwwCgYIKwYBBQUHAwMwDgYDVR0PAQH/
# BAQDAgeAMBsGCSsGAQQBgjcVCgQOMAwwCgYIKwYBBQUHAwMwHQYDVR0OBBYEFKPA
# wA32ZBRprdxoLiSzmBFpLCkMMB8GA1UdIwQYMBaAFPQDTQCDbTGjugHPH5Vdj1h4
# MosFMIIBCgYDVR0fBIIBATCB/jCB+6CB+KCB9YaBwmxkYXA6Ly8vQ049RWxpYSUy
# MElOVCUyMElzc3VpbmclMjBDQSxDTj1JU09DRVJUMDEsQ049Q0RQLENOPVB1Ymxp
# YyUyMEtleSUyMFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24s
# REM9QmVsZ3JpZCxEQz1uZXQ/Y2VydGlmaWNhdGVSZXZvY2F0aW9uTGlzdD9iYXNl
# P29iamVjdENsYXNzPWNSTERpc3RyaWJ1dGlvblBvaW50hi5odHRwOi8vY2RwLmJl
# bGdyaWQubmV0L0VsaWFfSU5UX0lzc3VpbmdfQ0EuY3JsMIIBBwYIKwYBBQUHAQEE
# gfowgfcwgbgGCCsGAQUFBzAChoGrbGRhcDovLy9DTj1FbGlhJTIwSU5UJTIwSXNz
# dWluZyUyMENBLENOPUFJQSxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1T
# ZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9uLERDPUJlbGdyaWQsREM9bmV0P2NBQ2Vy
# dGlmaWNhdGU/YmFzZT9vYmplY3RDbGFzcz1jZXJ0aWZpY2F0aW9uQXV0aG9yaXR5
# MDoGCCsGAQUFBzAChi5odHRwOi8vY2RwLmJlbGdyaWQubmV0L0VsaWFfSU5UX0lz
# c3VpbmdfQ0EuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBZPgIgImgjU1JAA+M0hLTj
# zYjnX5NILiIP4zH+ZkovfYpd31ikHBdyUbig+YKFxk7ZbIYlwRLUGWtK5R14EmRy
# 6xoKHUG8gCU8W7Si3At1fthzRaB1sLfw/fmUyDlpwLxk5k85KGpUgMI+5pJbVgye
# 6irgPYR9yvJ0O0TG3hfy3etYy3PYnTclMx/ssrhBcYMExPBNHUCaNvQs9BE5treR
# L8popMvJmJIG7oz9+M/EJUQsn7hT0VzwPJY6N7++aHKqvyaMtuMhSXJOzkdJlLeR
# QipzEVwu8l1/NNOBd1ga9RQvNqWwE5S1hxSkHnMY2TQvnne0wsj/IH6q7kv4Nrki
# MYICBDCCAgACAQEwYzBMMRMwEQYKCZImiZPyLGQBGRYDbmV0MRcwFQYKCZImiZPy
# LGQBGRYHQmVsZ3JpZDEcMBoGA1UEAxMTRWxpYSBJTlQgSXNzdWluZyBDQQITNAAA
# ABlFBoKwd2G+egABAAAAGTAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAig
# AoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgEL
# MQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUwg+Lfhe0QUnG9+ca+3rs
# grr9E1swDQYJKoZIhvcNAQEBBQAEggEAMmS3drXrhg1Hu8SpspNfX+d6VLswr9K3
# 9JP8RxRKXWD0uG/q6owy+EtfvsaFgakEk/D+1tu7/LAO6xDJ3GZk1m3qidw1iPQy
# fbWp5vfkfbolGuOsd7hgTp9dFdzhIjPPYAV0Y9NhG3E/jGh5nokadoQ0dtYS60HI
# V6Hel/VZnwTxYtkFEHYcIVwA6KGUN3G22hmMLCAjdY7Vkrg89+VxFDgbbsxJi3kI
# p+ZRGJsL3++lLultFWaL7fZ2WFf6vMLXb20iTIUAhlCxYipFUEX8+F6AokNJMPIX
# wxaQCCoumd3ZMyqh/xZuqtGrdM6WsHDfInunXYM+OZ4Yfjj8SG1LNw==
# SIG # End signature block
