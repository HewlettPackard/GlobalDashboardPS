function Get-OVGDServerHardware {
    <#
        .SYNOPSIS
            Retrieves the Server hardware connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Server hardware on the specified Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.5.1
            Revised : 25/04-2019
            Changelog:
            0.5.0 -- Reworked output, fixed missing query for state
            0.4.0 -- Changed Entity parameter to Id, adding Name alias
            0.3.2 -- Updated help text
            0.3.1 -- Changed message when result is bigger than requested count
            0.3.0 -- Adding support for query
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
            The Global Dashboard to retrieve Server Hardware from
        .PARAMETER Id
            The Id of the Hardware to retrieve
        .PARAMETER ServerName
            Filter on the ServerName of hardware to retrieve. Note that we search for an exact match
        .PARAMETER SerialNumber
            Filter on SerialNumber of hardware to retrieve. Note that we search for an exact match
        .PARAMETER Appliance
            Filter on Appliance of hardware to retrieve. Note that we search for an exact match
        .PARAMETER Status
            Filter on Status of hardware to retrieve. Note that we search for an exact match
        .PARAMETER State
            Filter on State of hardware to retrieve. Note that we search for an exact match
        .PARAMETER ILO
            Filter on ILO Version (iLO4 / iLO5) of hardware to retrieve. Note that we search for an exact match
        .PARAMETER UserQuery
            Query string used for full text search
        .PARAMETER Count
            The count of hardware to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDServerHardware

            Retrieves all server hardware connected to the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDServerHardware -Id xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Retrieves the specific Server Hardware with the specified ID
        .EXAMPLE
            PS C:\> Get-OVGDServerHardware -ServerName my-server-name-001

            Searches for a server with the specified servername
        .EXAMPLE
            PS C:\> Get-OVGDServerHardware -UserQuery "Proliant DL360"

            Performs a full text search and matches all attributes for the specified string
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Id")]
        [Parameter(ParameterSetName="Query")]
        $Server,
        [Parameter(ParameterSetName="Id")]
        [alias("Entity")]
        $Id,
        [Parameter(ParameterSetName="Query")]
        [alias("Name")]
        $ServerName,
        [Parameter(ParameterSetName="Query")]
        $SerialNumber,
        [Parameter(ParameterSetName="Query")]
        $Appliance,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("OK","Warning","Critical")]
        $Status,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("ProfileApplied","NoProfileApplied","ProfileError","Monitored","Unmanaged")]
        $State,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("iLO4","iLO5")]
        $ILO,
        [Parameter(ParameterSetName="Query")]
        $UserQuery,
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Query")]
        $Count = 25
    )

    begin {
        $ResourceType = "server-hardware"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Id
        
        $Query = "count=$Count"
        $searchFilters = @()
        $txtSearchFilters = @()
        
        if($ServerName){
            $searchFilters += 'name EQ "' + $ServerName + '"'
        }

        if($SerialNumber){
            $searchFilters += 'serialNumber EQ "' + $SerialNumber + '"'
        }

        if($Appliance){
            $searchFilters += 'applianceName EQ "' + $Appliance + '"'
        }

        if($Status){
            $searchFilters += 'status EQ "' + $Status + '"'
        }

        if($State){
            $searchFilters += 'state EQ "' + $State + '"'
        }

        if($ILO){
            $searchFilters += 'mpModel EQ "' + $ILO + '"'
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
        
        $result = Invoke-OVGDRequest -Resource $Resource -Query $Query #-Verbose

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
            $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDServerHardware" -Object $output
            return $output
        }
    }

    end {
    }
}