function Get-OVGDServerProfileTemplate {
    <#
        .SYNOPSIS
            Retrieves the Server profile templates connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Server profile templates on the specified Global Dashboard instance
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
            The Id of the Server Profile Template to retrieve
        .PARAMETER Count
            The count of profile templates to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDServerProfileTemplate

            Retrieves all Server Profile Templates connected to the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDServerProfileTemplate -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Retrieves the specific Server Profile Template with the specified ID
    #>
    [CmdletBinding()]
    param (
        $Server,
        [alias("ServerProfileTemplate")]
        $Entity,
        $Count = 25
    )

    begin {
        $ResourceType = "server-profile-templates"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        $result = Invoke-OVGDRequest -Resource $Resource -Query $Query -Verbose

        if ($result.Count -lt $result.Total ) {
            Write-Verbose "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDServerProfileTemplate" -Object $result.members
        return $output
    }

    end {
    }
}