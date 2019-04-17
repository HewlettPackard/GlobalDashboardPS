function Get-OVGDGroup {
    <#
        .SYNOPSIS
            Retrieve Global Dashboard groups
        .DESCRIPTION
            This function will retrieve logical groups from the connected Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.2.1
            Revised : 17/04-2019
            Changelog:
            0.2.1 -- Added help text
            0.2.0 -- Added count param
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .PARAMETER Server
            The Global Dashboard to work with, defaults to the Global variable OVGDPSServer
        .PARAMETER Entity
            The Id of the Group to retrieve
        .EXAMPLE
            PS C:\> Get-OVGDGroup

            Lists the groups on the connected Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDGroup -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Lists the groups on the connected Global Dashboard instance with the specified Id
    #>
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [alias("Group")]
        $Entity,
        $Count = 25
    )

    begin {
        $ResourceType = "groups"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        Invoke-OVGDRequest -Resource $Resource

    }

    end {
    }
}