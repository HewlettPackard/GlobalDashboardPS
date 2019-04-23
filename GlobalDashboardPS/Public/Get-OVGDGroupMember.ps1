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
        .PARAMETER Entity
            The Id of the Group to retrieve members from
        .EXAMPLE
            PS C:\> Get-OVGDGroupMember -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Lists the members of the group with the specified Id
    #>
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [Parameter(Mandatory=$true)]
        [alias("Group")]
        $Entity#,
        #$Count = 25
    )

    begin {
        $ResourceType = "groups"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity

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