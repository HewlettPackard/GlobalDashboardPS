function Get-OVGDCertificate {
    <#
        .SYNOPSIS
            Retrieves instance certificates on the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the instance certificates on the specified Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.1.2
            Revised : 24/04-2019
            Changelog:
            0.1.2 -- Fixed bug in help text and added link
            0.1.1 -- Added help text
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to retrieve certificate from
        .EXAMPLE
            PS C:\> Get-OVGDCertificate

            Retrieves all instance certificates on the Global Dashboard instance
    #>
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer
    )

    begin {
        $Resource = "certificates/https/remote/$Server"
    }

    process {
        $result = Invoke-OVGDRequest -Resource $Resource

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDCertificate" -Object $result
        return $output
    }

    end {
    }
}