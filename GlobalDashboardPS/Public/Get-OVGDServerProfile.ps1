function Get-OVGDServerProfile {
    <#
        .SYNOPSIS
            Retrieves the Server profiles connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Server profiles on the specified Global Dashboard instance
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
            The Id of the Server Profile to retrieve
        .PARAMETER Count
            The count of profiles to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDServerProfile

            Retrieves all Server Profiles connected to the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDServerProfile -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Retrieves the specific Server Profile with the specified ID
    #>
    [CmdletBinding()]
    param (
        $Server,
        [alias("ServerProfile")]
        $Entity,
        $Count = 25
    )

    begin {
        $ResourceType = "server-profiles"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        $result = Invoke-OVGDRequest -Resource $Resource -Query $Query

        if ($result.Count -lt $result.Total ) {
            Write-Verbose "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDServerProfile" -Object $result.members
        return $output
    }

    end {
    }
}