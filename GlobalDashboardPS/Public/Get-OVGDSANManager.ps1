function Get-OVGDSANManager {
    <#
        .SYNOPSIS
            Retrieves the SAN Managers connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the SAN Managers on the specified Global Dashboard instance
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
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to retrieve SAN Managers from
        .PARAMETER Entity
            The Id of the SAN Manager to retrieve
        .PARAMETER Count
            The count of SAN Managers to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDSANManager

            Lists the SAN Managers on the connected Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDSANManager -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Lists the SAN Manager on the connected Global Dashboard instance with the specified Id
    #>
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [alias("SANManager")]
        $Entity,
        $Count = 25
    )

    begin {
        $ResourceType = "san-managers"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $result = Invoke-OVGDRequest -Resource $Resource

        if ($result.Count -lt $result.Total ) {
            Write-Verbose "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDSANManager" -Object $result.members
        return $output
    }

    end {
    }
}