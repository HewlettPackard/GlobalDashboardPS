function Set-OVGDAppliance {
    <#
        .SYNOPSIS
            Perform changes to a OneView appliance
        .DESCRIPTION
            This function can perform the following changes on a OneView appliance on the connected Global Dashboard instance:
              - Change name
              - Refresh the connection to the OneView appliance
              - Reconnect the OneView appliance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.3.1
            Revised : 17/04-2019
            Changelog:
            0.3.1 -- Added help text
            0.3.0 -- Added reconnect
            0.2.0 -- Added refresh
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .PARAMETER Server
            The Global Dashboard to work with, defaults to the Global variable OVGDPSServer
        .PARAMETER Entity
            The Id of the OneView appliance to work with
        .PARAMETER NewName
            Set a new name for the OneView appliance
        .PARAMETER Refresh
            Refresh the connection to the specified OneView appliance
        .PARAMETER Reconnect
            Reconnect to the specified OneView appliance
        .PARAMETER UserName
            The Username of a user with access to the Global Dashboard instance
        .PARAMETER Password
            The Password of the specified user
        .PARAMETER Directory
            The Directory of the specified user
        .EXAMPLE
            PS C:\> Set-OVGDAppliance -Entity xxxxxxxx-xxxx-xxxx-xxxx-1b2841850e85 -NewName newname-001
            
            Renames the specified appliance to "newname-001" on the Global Dashboard instance
        .EXAMPLE
            PS C:\> Set-OVGDAppliance -Entity xxxxxxxx-xxxx-xxxx-xxxx-1b2841850e85 -Refresh
            
            Refresh the connection to the specified OneView appliance
        .EXAMPLE
            PS C:\> Set-OVGDAppliance -Entity xxxxxxxx-xxxx-xxxx-xxxx-1b2841850e85 -Reconnect -Username user-01
            
            Reconnect the specified appliance with the specified user. The function will prompt for the password of the user
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        $Server,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [alias("Appliance")]
        $Entity,
        [Parameter(ParameterSetName="Name")]
        $NewName,
        [Parameter(ParameterSetName="Refresh")]
        [switch]
        $Refresh,
        [Parameter(ParameterSetName="Reconnect")]
        [switch]
        $Reconnect,
        [Parameter(ParameterSetName="Reconnect")]
        $Username,
        [Parameter(ParameterSetName="Reconnect")]
        [securestring]
        $Password,
        [Parameter(ParameterSetName="Reconnect")]
        $LoginDomain
    )
    BEGIN {
        $ResourceType = "appliances"
        $operation = "replace"
    }
    PROCESS {

        if ($Reconnect -and !$Password) {
            $Password = Read-Host -Prompt "Please provide a password" -AsSecureString
            $unsecPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
            $value = [PSCustomObject]@{
                username = $Username
                password = $unsecPass
                loginDomain = $LoginDomain
            } #| ConvertTo-Json
            $opPath = "/credential"
        }
        elseif($Refresh) {
            $value = "refreshPending"
            $opPath = "/status"
        }
        else {
            $value = $NewName
            $opPath = "/applianceName"
        }

        $abody = [PSCustomObject]@{
            op = $operation
            path = $opPath
            value = $value
        } #| ConvertTo-Json

        $body = ConvertTo-Json @($abody)
        Write-Verbose $body

        $Resource = BuildPath -Resource $ResourceType -Entity $Entity

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Invoke-OVGDRequest -Resource $Resource -Method PATCH -Body $body -ContentType "application/json-patch+json" -Verbose
        }
    }
    END {

    }

}