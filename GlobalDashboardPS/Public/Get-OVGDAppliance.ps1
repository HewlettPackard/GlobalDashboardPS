function Get-OVGDAppliance {
    <#
        .SYNOPSIS
            Retrieves appliances connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the appliances connected to the specified Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.2.2
            Revised : 24/04-2019
            Changelog:
            0.2.2 -- Fixed minor bug in help text, added link
            0.2.1 -- Added help text
            0.2.0 -- Added count param
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to retrieve appliances from
        .PARAMETER Entity
            The appliance to retrieve
        .PARAMETER Count
            The count of appliances to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDAppliance

            Retrieves all OneView appliances connected to the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDAppliance -Entity oneview-001

            Retrieves the specific OneView appliances with the name "oneview-001"
    #>
    [CmdletBinding()]
    param (
        $Server,
        [Parameter(Mandatory=$false,ValueFromPipeline=$true)]
        [alias("Appliance")]
        $Entity,
        $Count = 25
    )
    BEGIN {
        $ResourceType = "appliances"

    }
    PROCESS {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity

        $result = Invoke-OVGDRequest -Resource $Resource

        if ($result.Count -lt $result.Total ) {
            Write-Verbose "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDAppliance" -Object $result.members
        return $output

    }
    END {

    }

}