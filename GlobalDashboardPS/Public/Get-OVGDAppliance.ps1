function Get-OVGDAppliance {
    <#
        .SYNOPSIS
            Retrieves appliances connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the appliances connected to the specified Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.5.0
            Revised : 25/04-2019
            Changelog:
            0.5.0 -- Reworked output
            0.4.0 -- Changed Entity parameter to Id, adding Name alias
            0.3.1 -- Updated help text
            0.3.0 -- Added support for querying, changed text when result is bigger than count
            0.2.2 -- Fixed minor bug in help text, added link
            0.2.1 -- Added help text
            0.2.0 -- Added count param
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to retrieve appliances from
        .PARAMETER Id
            The Id of the Appliance to retrieve
        .PARAMETER ApplianceName
            Filter on ApplianceName of Appliance to retrieve. Note that we search for an exact match
        .PARAMETER ApplianceLocation
            Filter on ApplianceLocation of Appliance to retrieve. Note that we search for an exact match
        .PARAMETER Status
            Filter on Status of Appliance to retrieve. Note that we search for an exact match
        .PARAMETER State
            Filter on State of Appliance to retrieve. Note that we search for an exact match
        .PARAMETER UserQuery
            Query string used for full text search
        .PARAMETER Count
            The count of appliances to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDAppliance

            Retrieves all OneView appliances connected to the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDAppliance -ApplianceName Appliance01

            Searches for a OneView Appliance with the specified Appliance Name
        .EXAMPLE
            PS C:\> Get-OVGDAppliance -UserQuery "c7000 Enclosure G3"

            Performs a full text search and matches all attributes for the specified string
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Id")]
        [Parameter(ParameterSetName="Query")]
        $Server,
        [Parameter(Mandatory=$false,ValueFromPipeline=$true)]
        [Parameter(ParameterSetName="Id")]
        [alias("Entity")]
        $Id,
        [Parameter(ParameterSetName="Query")]
        [alias("Name")]
        $ApplianceName,
        [Parameter(ParameterSetName="Query")]
        $ApplianceLocation,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("OK","Warning","Critical")]
        $Status,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("Online","Offline","Failed","Unknown")]
        $State,
        [Parameter(ParameterSetName="Query")]
        $UserQuery,
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Query")]
        $Count = 25
    )
    BEGIN {
        $ResourceType = "appliances"

    }
    PROCESS {
        $Resource = BuildPath -Resource $ResourceType -Entity $Id
        $Query = "count=$Count"
        $searchFilters = @()
        $txtSearchFilters = @()

        if($ApplianceName){
            $searchFilters += 'applianceName EQ "' + $ApplianceName + '"'
        }

        if($ApplianceLocation){
            $searchFilters += 'applianceLocation EQ "' + $ApplianceLocation + '"'
        }

        if($Status){
            $searchFilters += 'status EQ "' + $Status + '"'
        }

        if($State){
            $searchFilters += 'state EQ "' + $State + '"'
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

        if ($result.Count -lt $result.Total ) {
            Write-Warning "The result has been paged. Total number of results is: $($result.total)"
        }

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
            $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDAppliance" -Object $output
            return $output
        }

    }
    END {

    }

}