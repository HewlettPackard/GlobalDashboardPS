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
            Version : 0.4.0
            Revised : 25/04-2019
            Changelog:
            0.4.0 -- Reworked output
            0.3.0 -- Changed Entity parameter to Id, adding Name alias
            0.2.0 -- Added support for querying, changed warning text when result is bigger than count
            0.1.2 -- Fixed bug in help text and added link
            0.1.1 -- Added help text
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to retrieve Converged systems from
        .PARAMETER Id
            The Id of the Converged system to retrieve
        .PARAMETER SystemName
            Filter on the System name of the Converged system to retrieve. Note that we search for an exact match
        .PARAMETER Appliance
            Filter on the Appliance of the Converged system to retrieve. Note that we search for an exact match
        .PARAMETER Status
            Filter on the Status of the Converged system to retrieve. Note that we search for an exact match
        .PARAMETER UserQuery
            Query string used for full text search
        .PARAMETER Count
            The count of entities to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDConvergedSystem

            Retrieves all Converged systems connected to the Global Dashboard instance
        
        .EXAMPLE
            PS C:\> Get-OVGDConvergedSystem -Appliance appliance-01

            Retrieves the specific Converged system connected to the specified Appliance
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Id")]
        [Parameter(ParameterSetName="Query")]
        $Server = $Global:OVGDPSServer,
        [Parameter(ParameterSetName="Id")]
        [alias("Entity")]
        $Id,
        [Parameter(ParameterSetName="Query")]
        [alias("Name")]
        $SystemName,
        [Parameter(ParameterSetName="Query")]
        $Appliance,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("OK","Warning","Critical","Disabled","Unknown")]
        $Status,
        [Parameter(ParameterSetName="Query")]
        $UserQuery,
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Query")]
        $Count = 25
    )

    begin {
        $ResourceType = "converged-systems"
    }

    process {

        $Resource = BuildPath -Resource $ResourceType -Entity $Id

        $Query = "count=$Count"
        $searchFilters = @()
        $txtSearchFilters = @()

        if($SystemName){
            $searchFilters += 'systemName EQ "' + $SystemName + '"'
        }
        
        if($Appliance){
            $searchFilters += 'applianceName EQ "' + $Appliance + '"'
        }

        if($Status){
            $searchFilters += 'status EQ "' + $Status + '"'
        }

        if($UserQuery){
            $txtSearchFilters += "$UserQuery"
        }

        if($searchFilters){
            $filterQry = $searchFilters -join " AND "
            $Query += '&query="' + $filterQry + '"'
        }

        if($txtSearchFilters){
            $filterQry = $txtSearchFilters -join " AND "
            $Query += '&userQuery="' + $filterQry + '"'
        }

        
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
            $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDConvergedSystem" -Object $output
            return $result
        }

        

    }

    end {
    }
}