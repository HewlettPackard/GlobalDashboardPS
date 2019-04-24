function Get-OVGDEnclosure {
    <#
        .SYNOPSIS
            Retrieves Enclosures connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Enclosures on the specified Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.2.0
            Revised : 24/04-2019
            Changelog:
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
            The Global Dashboard to retrieve Enclosures from
        .PARAMETER Entity
            The Id of the Enclosure to retrieve
        .PARAMETER EnclosureName
            The ServerName of Enclosure to retrieve. Note that we search for an exact match
        .PARAMETER SerialNumber
            Filter on SerialNumber of Enclosure to retrieve. Note that we search for an exact match
        .PARAMETER Appliance
            Filter on Appliance of Enclosure to retrieve. Note that we search for an exact match
        .PARAMETER Type
            Filter on EnclosureType of Enclosure to retrieve. Note that we search for an exact match
        .PARAMETER Status
            Filter on Status of Enclosure to retrieve. Note that we search for an exact match
        .PARAMETER State
            Filter on State of Enclosure to retrieve. Note that we search for an exact match
        .PARAMETER UserQuery
            Query string used for full text search
        .PARAMETER Count
            The count of Enclosure to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDEnclosure

            Retrieves all Enclosures connected to the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDEnclosure -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Retrieves the specific Enclosure with the specified ID
        .EXAMPLE
            PS C:\> Get-OVGDEnclosure -EnclosureName Encl1

            Searches for a Enclosure with the specified Enclosure Name
        .EXAMPLE
            PS C:\> Get-OVGDEnclosure -UserQuery "c7000 Enclosure G3"

            Performs a full text search and matches all attributes for the specified string
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Id")]
        [Parameter(ParameterSetName="Query")]
        $Server = $Global:OVGDPSServer,
        [Parameter(ParameterSetName="Id")]
        [alias("Enclosure")]
        $Entity,
        [Parameter(ParameterSetName="Query")]
        $EnclosureName,
        [Parameter(ParameterSetName="Query")]
        $SerialNumber,
        [Parameter(ParameterSetName="Query")]
        $Appliance,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("C3000","C7000")]
        $Type,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("OK","Warning","Critical","Disabled","Unknown")]
        $Status,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("Configured","Unknown")]
        $State,
        [Parameter(ParameterSetName="Query")]
        $UserQuery,
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Id")]
        [Parameter(ParameterSetName="Query")]
        $Count = 25
    )

    begin {
        $ResourceType = "enclosures"
    }

    process {

        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        $searchFilters = @()
        $txtSearchFilters = @()

        if($EnclosureName){
            $searchFilters += 'name EQ "' + $EnclosureName + '"'
        }
        
        if($SerialNumber){
            $searchFilters += 'serialNumber EQ "' + $SerialNumber + '"'
        }

        if($Appliance){
            $searchFilters += 'applianceName EQ "' + $Appliance + '"'
        }

        if($Type){
            $searchFilters += 'enclosureType EQ "' + $Type + '"'
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

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDEnclosure" -Object $result.members
        return $output

    }

    end {
    }
}