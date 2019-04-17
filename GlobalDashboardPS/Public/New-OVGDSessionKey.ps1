function New-OVGDSessionKey{
    <#
        .SYNOPSIS
            Creates a session key on the Global Dashboard instance
        .DESCRIPTION
            This function will create a session key on the connected Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.1.1
            Revised : 17/04-2019
            Changelog:
            0.1.1 -- Added help text
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .PARAMETER Server
            The Global Dashboard to connect to
        .PARAMETER UserName
            The Username of a user with access to the Global Dashboard instance
        .PARAMETER Password
            The Password of the specified user
        .PARAMETER Directory
            The Directory of the specified user, defaults to local
        .EXAMPLE
            PS C:\> New-OVGDSessionKey -Server gd-01 -Username user01 -Password zxxxxxx
            
            Creates a sessionkey on the connected Global Dashboard instance
    #>
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