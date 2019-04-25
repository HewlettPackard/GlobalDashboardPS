function Get-OVGDGroupMember {
    <#
        .SYNOPSIS
            Retrieve members from a Global Dashboard groups
        .DESCRIPTION
            This function will retrieve the members of a logical groups on the connected Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.2.0
            Revised : 25/04-2019
            Changelog:
            0.2.0 -- Changed Entity parameter to Id
            0.1.1 -- Added help text
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to work with, defaults to the Global variable OVGDPSServer
        .PARAMETER Id
            The Id of the Group to retrieve members from
        .EXAMPLE
            PS C:\> Get-OVGDGroupMember -Id xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Lists the members of the group with the specified Id
    #>
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [Parameter(Mandatory=$true)]
        [alias("Group")]
        $Id
    )

    begin {
        $ResourceType = "groups"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Id

        $result = Invoke-OVGDRequest -Resource ($Resource + "/members")

        if ($result.Count -lt $result.Total ) {
            Write-Verbose "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDGroupMember" -Object $result.items
        return $output
    }

    end {
    }
}