function Disconnect-OVGD {
    <#
        .SYNOPSIS
            Removes a connection to a Global Dashboard instance
        .DESCRIPTION
            This function will remove a connection session to the specified Global Dashboard instance
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
        .PARAMETER Sessionkey
            The sessionkey to delete
        .EXAMPLE
            PS C:\> Disconnect-OVGD -Server 1.1.1.1 -Sessionkey xxxxxxxxx-xxx

            Removes the login session from the specified Global Dashboard instance
    #>
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        $Sessionkey = $Global:OVGDPSToken
    )

    begin {
    }

    process {
        Remove-OVGDSessionKey -Server $Server -Sessionkey $Sessionkey
    }

    end {
    }
}