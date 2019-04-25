function Get-OVGDTask {
    <#
        .SYNOPSIS
            Retrieves the Tasks on the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Tasks on the specified Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 24/04-2019
            Version : 0.3.0
            Revised : 25/04-2019
            Changelog:
            0.3.0 -- Reworked output
            0.2.0 -- Changed entity param to Id
            0.1.1 -- Fixed bug in help text and added link
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to retrieve Tasks from
        .PARAMETER Id
            The Id of the Task to retrieve
        .PARAMETER Count
            The count of Tasks to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDTask

            Retrieves all Tasks on the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDTask -Id xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Retrieves the specific Task with the specified ID
    #>
    [CmdletBinding()]
    param (
        $Server,
        [alias("Entity")]
        $Id,
        $Count = 25
    )

    begin {
        $ResourceType = "tasks"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Id
        $Query = "count=$Count"
        $result = Invoke-OVGDRequest -Resource $Resource -Query $Query

        Write-Verbose "Got $($result.count) number of results"

        if ($result.Count -lt $result.Total ) {
            Write-Warning "The result has been paged. Total number of results is: $($result.total)"
        }
        
        if($result.Count -ge 1){
            Write-Verbose "Found $($result.total) number of results"
            $output = $result.members
        }
        elseif($result.Count -eq 0){
            return $null
        }
        elseif($result.category -eq $ResourceType){
            $output = $result
        }
        else{
            return $result
        }

        if($Output){
            $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDTask" -Object $output
            return $output
        }
    }

    end {
    }
}