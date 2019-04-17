function Add-OVGDAppliance {
    <#
        .SYNOPSIS
            Adds a OneView applicane to Global Dashboard
        .DESCRIPTION
            This function will add a OneView appliance to the specified Global Dashboard instance
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
            The Global Dashboard to work with, defaults to the Global variable OVGDPSServer
        .PARAMETER ApplianceName
            The Name of the OneView appliance to add
        .PARAMETER ApplianceIP
            The IP Address of the OneView appliance to add
        .PARAMETER Username
            The Username of a user with access to the OneView appliance you want to add
        .PARAMETER Password
            The Password of the specified user
        .PARAMETER LoginDomain
            The LoginDomain of the specified user, defaults to local
        .EXAMPLE
            PS C:\> Add-OVGDAppliance -ApplianceIp 10.10.10.10 -ApplianceName oneview-001
            
            Adds the specified OV appliance to the connected Global Dashboard instance
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        $Server,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [alias("Appliance")]
        $ApplianceName,
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [alias("IP")]
        $ApplianceIP,
        $Username,
        [securestring]
        $Password = (Read-Host -Prompt "Provide your password please" -AsSecureString),
        $LoginDomain = "local"
    )
    BEGIN {
        $ResourceType = "appliances"
    }
    PROCESS {
        $unsecPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        $body = [PSCustomObject]@{
            address = $ApplianceIP
            applianceName = $ApplianceName
            loginDomain = $LoginDomain
            username = $UserName
            password = $unsecPass
        } | ConvertTo-Json
        Write-Verbose $body

        $Resource = BuildPath -Resource $ResourceType

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Invoke-OVGDRequest -Resource $Resource -Method POST -Body $body
        }
    }
    END {

    }

}