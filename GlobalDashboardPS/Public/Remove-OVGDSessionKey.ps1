function Remove-OVGDSessionKey {
    <#
        .SYNOPSIS
            Delete a session key from the Global Dashboard instance
        .DESCRIPTION
            This function will remove the specified session key from the connected Global Dashboard instance
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
        .PARAMETER Sessionkey
            The sessionkey to remove
        .EXAMPLE
            PS C:\> Remove-OVGDSessionKey -Sessionkey xxxxxxxxx-xxx
            
            Removes the specified sessionkey from the connected Global Dashboard instance
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        $Server,
        $Sessionkey
    )

    begin {
        if (!$Sessionkey -and !$Global:OVGDPSToken) {
            Write-Error "No session key found to delete"
        }

    }

    process {

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Invoke-OVGDRequest -Method DELETE -System $Server -Resource login-sessions
        }

        $local:OVGDPSToken = $null
        $local:OVGDPSServer = $null
    }

    end {

    }
}