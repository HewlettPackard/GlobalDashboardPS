function Get-OVGDResourceAlerts {
    <#
        .SYNOPSIS
            Retrieve resource alerts from a Global Dashboard instance
        .DESCRIPTION
            This function will retrieve resource alerts on the connected Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 24/04-2019
            Version : 0.1.0
            Revised : 
            Changelog:
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .PARAMETER Server
            The Global Dashboard to work with, defaults to the Global variable OVGDPSServer
        .PARAMETER Count
            The count of hardware to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDResourceAlerts

            Returns the 25 latest resource alerts from the connected Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDResourceAlerts -Count 50

            Returns the 50 latest resource alerts from the connected Global Dashboard instance
    #>
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        $Count = 25
    )

    begin {
        $ResourceType = "resource-alerts"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType
        $Query = "count=$Count"
        
        $result = Invoke-OVGDRequest -Resource $Resource -Query $Query

        if ($result.Count -lt $result.Total ) {
            Write-Verbose "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDResourceAlerts" -Object $result.members
        return $output
    }

    end {
    }
}