function New-OVGDSessionKey{
    [CmdletBinding(SupportsShouldProcess)]
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
            $LoginDomain
        )

    $unsecPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))

    $body = [PSCustomObject]@{
        authLoginDomain = $LoginDomain
        userName = $UserName
        password = $unsecPass
    } | ConvertTo-Json

    if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
        $response = Invoke-OVGDRequest -Method Post -System $Server -Resource login-sessions -Body $body
    }
    # else {
    #     Write-Output "This will create a new session key on server $server"
    # }

    $sessionkey = $response.token

    $global:OVGDPSServer = $server
    $global:OVGDPSToken = $sessionkey
}