function Get-OVGDTask {
    <#
        .SYNOPSIS
            Retrieves the Storage Systems connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Storage Systems on the specified Global Dashboard instance
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
            The Id of the Storage System to retrieve
        .PARAMETER Count
            The count of Storage Systems to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDTask

            Retrieves all Tasks on the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDTask -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Retrieves the specific Task with the specified ID
    #>
    [CmdletBinding()]
    param (
        $Server,
        [alias("Task")]
        $Entity,
        $Count = 25
    )

    begin {
        $ResourceType = "tasks"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        $result = Invoke-OVGDRequest -Resource $Resource -Query $Query

        if ($result.Count -lt $result.Total ) {
            Write-Verbose "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDTask" -Object $result.members
        return $output
    }

    end {
    }
}