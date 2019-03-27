function Invoke-OVGDRequest {
    [CmdletBinding()]
    param(
        $Protocol = "https",
        $Port = 443,
        $System = $global:OVGDPSServer,
        #$Path,
        $Resource,
        $Body,
        $Query,
        # [ValidateRange("GET","POST","DELETE")]
        $Method = "GET",
        $SessionKey = $global:OVGDPSToken,
        [switch]
        $IgnoreSSL = $true
    )

    BEGIN {
        if($IgnoreSSL){
            Set-InsecureSSL
        }
    }
    PROCESS {
        if($Resource -notlike "/rest/*"){
             Write-Verbose "InPath: $Resource"

            $Resource = "/rest/" + $Resource
        }

        $Path += $Resource
        Write-Verbose "Path: $path"
        Write-Verbose "Host: $system"
        $URIBuilder = New-Object System.UriBuilder -ArgumentList @($Protocol, $System, $Port, $Path)
        $Uribuilder.Query = $query
        Write-Verbose "qry: $($uribuilder.query)"

        $headers = @{}
        $headers["X-Api-Version"] = 2

        if($SessionKey){
            $headers["Auth"] = $sessionkey
        }

        Write-Verbose "URI: $($uribuilder.uri)"
        $response = Invoke-RestMethod -Method $Method -Uri $URIBuilder.Uri -Headers $headers -Body $Body -ContentType "application/json" -ErrorVariable apiErr -Verbose

    }
    END {
        if($apiErr){
            Write-Verbose $apiErr.InnerException
        }
        $response
    }
}