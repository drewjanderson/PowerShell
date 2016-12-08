# This function can be used to pull geolocation data that corresponds with the provided IP address.

Function Get-IPLocation ($IPAddress){
    $infoService = "http://freegeoip.net/xml/$IPAddress"
    $geoip = Invoke-RestMethod -Method Get -URI $infoService 
    $geoip.Response 
    }

Get-IPLocation -IPAddress 23.79.10.194