function Get-OVGDServerHardware {
    <#
        .SYNOPSIS
            Retrieves the Server hardware connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Server hardware on the specified Global Dashboard instance
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
            The Global Dashboard to remove connection from
        .PARAMETER Entity
            The Id of the Hardware to retrieve
        .PARAMETER Count
            The count of hardware to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDServerHardware

            Retrieves all server hardware connected to the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDServerHardware -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Retrieves the specific Server Hardware with the specified ID
    #>
    [CmdletBinding()]
    param (
        $Server,
        [alias("ServerHardware")]
        $Entity,
        $Count = 25
    )

    begin {
        $ResourceType = "server-hardware"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        Invoke-OVGDRequest -Resource $Resource -Query $Query -Verbose
    }

    end {
    }
}