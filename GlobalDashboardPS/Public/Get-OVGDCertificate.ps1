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
            Version : 0.1.1
            Revised : 17/04-2019
            Changelog:
            0.1.1 -- Added help text
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .PARAMETER Server
            The Global Dashboard to remove connection from
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

        if ($result.Count -lt $result.Total ) {
            Write-Verbose "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDCertificate" -Object $result
        return $output
    }

    end {
    }
}