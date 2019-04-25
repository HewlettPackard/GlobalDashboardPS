function Get-OVGDSANManager {
    <#
        .SYNOPSIS
            Retrieves the SAN Managers connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the SAN Managers on the specified Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 24/04-2019
            Version : 0.2.0
            Revised : 25/04-2019
            Changelog:
            0.2.0 -- Added support for querying, changed warning text when result is bigger than count
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to retrieve SAN Managers from
        .PARAMETER Entity
            The Id of the SAN Manager to retrieve
        .PARAMETER Name
            Filter on the Name of the SAN Manager to retrieve. Note that we search for an exact match
        .PARAMETER State
            Filter on the State of the SAN Manager to retrieve. Note that we search for an exact match
        .PARAMETER RefreshState
            Filter on the Refresh State of the SAN Manager to retrieve. Note that we search for an exact match
        .PARAMETER Status
            Filter on the Status of the SAN Manager to retrieve. Note that we search for an exact match
        .PARAMETER UserQuery
            Query string used for full text search
        .PARAMETER Count
            The count of SAN Managers to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDSANManager

            Lists the SAN Managers on the connected Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDSANManager -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Lists the SAN Manager on the connected Global Dashboard instance with the specified Id
        .EXAMPLE
            PS C:\> Get-OVGDSANManager -Name manager-01

            Lists the SAN Manager on the connected Global Dashboard instance with the specified Name
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Id")]
        [Parameter(ParameterSetName="Query")]
        $Server = $Global:OVGDPSServer,
        [Parameter(ParameterSetName="Id")]
        [alias("SANManager")]
        $Entity,
        [Parameter(ParameterSetName="Query")]
        $Name,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("OK","Warning","Critical","Disabled","Unknown")]
        $Status,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("ConfigurationPending", "Configured", "Configuring", "Deleting", "Discovered", "Managed", "Removing")]
        $State,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("RefreshPending", "Refreshing", "Stable", "Unknown")]
        $RefreshState,
        [Parameter(ParameterSetName="Query")]
        $UserQuery,
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Id")]
        [Parameter(ParameterSetName="Query")]
        $Count = 25
    )

    begin {
        $ResourceType = "san-managers"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        $searchFilters = @()
        $txtSearchFilters = @()

        if($Name){
            $searchFilters += 'name EQ "' + $Name + '"'
        }
        
        if($RefreshState){
            $searchFilters += 'refreshState EQ "' + $RefreshState + '"'
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

        Write-Verbose "Got a total of $($result.total) result(s)"
        if ($result.Count -lt $result.Total ) {
            Write-Warning "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDSANManager" -Object $result.members
        return $output
    }

    end {
    }
}