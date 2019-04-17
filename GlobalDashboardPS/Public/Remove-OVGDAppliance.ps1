function Remove-OVGDAppliance {
    <#
        .SYNOPSIS
            Remove a OneView appliance from the Global Dashboard instance
        .DESCRIPTION
            This function will remove a Oneview appliance from the connected Global Dashboard instance
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
        .PARAMETER Entity
            The Id of the OneView appliance to remove
        .EXAMPLE
            PS C:\> Remove-OVGDAppliance -Entity xxxxxxxx-xxxx-xxxx-xxxx-1b2841850e85
            
            Removes the OneView appliance with the specified uri from the connected Global Dashboard instance
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        $Server,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [alias("Appliance")]
        $Entity
    )
    BEGIN {
        $ResourceType = "appliances"

    }
    PROCESS {

        $Resource = BuildPath -Resource $ResourceType -Entity $Entity

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Invoke-OVGDRequest -Resource $Resource -Method DELETE
        }
    }
    END {

    }

}