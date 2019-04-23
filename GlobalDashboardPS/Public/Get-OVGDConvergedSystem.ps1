function Get-OVGDConvergedSystem {
    <#
        .SYNOPSIS
            Retrieves Converged systems connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Converged systems on the specified Global Dashboard instance
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
            The Id of the Converged system to retrieve
        .PARAMETER Count
            The count of entities to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDConvergedSystem

            Retrieves all Converged systems connected to the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDConvergedSystem -Entity system-001

            Retrieves the specific Converged system with the name "system-001"
    #>
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [alias("System")]
        $Entity,
        $Count = 25
    )

    begin {
        $ResourceType = "converged-systems"
    }

    process {

        $Resource = BuildPath -Resource $ResourceType -Entity $Entity

        $result = Invoke-OVGDRequest -Resource $Resource

        if ($result.Count -lt $result.Total ) {
            Write-Verbose "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDConvergedSystem" -Object $result.members
        return $output

    }

    end {
    }
}