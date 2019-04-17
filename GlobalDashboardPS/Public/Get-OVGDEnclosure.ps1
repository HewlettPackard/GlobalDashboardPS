function Get-OVGDEnclosure {
    <#
        .SYNOPSIS
            Retrieves Enclosures connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Enclosures on the specified Global Dashboard instance
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
        .PARAMETER Entity
            The Id of the Enclosure to retrieve
        .PARAMETER Count
            The count of entities to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDEnclosure

            Retrieves all Enclosures connected to the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDEnclosure -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Retrieves the specific Enclosure with the specified ID
    #>
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [alias("Enclosure")]
        $Entity,
        $Count = 25
    )

    begin {
        $ResourceType = "enclosures"
    }

    process {

        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        Invoke-OVGDRequest -Resource $Resource

    }

    end {
    }
}