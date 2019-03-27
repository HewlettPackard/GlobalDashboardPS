function New-OVGDSessionKey{
    [CmdletBinding()]
        param(
            [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
            $Server,
            [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
            $Username,
            [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
            [securestring]
            $Password,
            [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
            #[ValidateSet("your-domain-here","local")]
            $LoginDomain,
            [switch]
            $IgnoreSSL
        )
    
    if($IgnoreSSL){
     Set-InsecureSSL
    }

    $unsecPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))

    $body = [PSCustomObject]@{
        authLoginDomain = $LoginDomain
        userName = $UserName
        password = $unsecPass
    } | ConvertTo-Json
    #Write-Verbose $body
    $response = Invoke-OVGDRequest -Method Post -System $Server -Resource login-sessions -Body $body -Verbose
    
    $sessionkey = $response.token
    
    $global:OVGDPSServer = $server
    $global:OVGDPSToken = $sessionkey
    
}