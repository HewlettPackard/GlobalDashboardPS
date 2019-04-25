function Get-OVGDStorageSystem {
    <#
        .SYNOPSIS
            Retrieves the Storage Systems connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Storage Systems on the specified Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.2.0
            Revised : 25/04-2019
            Changelog:
            0.2.0 -- Added support for querying and changed warning when result is bigger than count
            0.1.2 -- Fixed bug in help text and added link
            0.1.1 -- Added help text
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to retrieve Storage System from
        .PARAMETER Entity
            The Id of the Storage System to retrieve
        .PARAMETER StorageSystemName
            The ServerName of Storage System to retrieve. Note that we search for an exact match
        .PARAMETER PrimaryKey
            Filter on PrimaryKey of Storage System to retrieve. Note that we search for an exact match
        .PARAMETER Family
            Filter on Family of Storage System to retrieve. Note that we search for an exact match
        .PARAMETER SupportsFC
            Filter on Storage System that has SupportsFC set to true. Note that we search for an exact match
        .PARAMETER SupportsISCSI
            Filter on Storage System that has SupportsFC set to true. Note that we search for an exact match
        .PARAMETER Status
            Filter on Status of Storage System to retrieve. Note that we search for an exact match
        .PARAMETER State
            Filter on State of Storage System to retrieve. Note that we search for an exact match
        .PARAMETER UserQuery
            Query string used for full text search
        .PARAMETER Count
            The count of hardware to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDServerHardware

            Retrieves all server hardware connected to the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDServerHardware -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

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
        $Server = $Global:OVGDPSServer,
        [Parameter(ParameterSetName="Id")]
        [alias("StorageSystem")]
        $Entity,
        [Parameter(ParameterSetName="Query")]
        $StorageSystemName,
        [Parameter(ParameterSetName="Query")]
        $PrimaryKey,
        [Parameter(ParameterSetName="Query")]
        [switch]
        $SupportsFC,
        [Parameter(ParameterSetName="Query")]
        [switch]
        $SupportsISCSI,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("StoreServ","StoreVirtual")]
        $Family,
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
        $ResourceType = "storage-systems"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        $searchFilters = @()
        $txtSearchFilters = @()

        if($StorageSystemName){
            $searchFilters += 'name EQ "' + $StorageSystemName + '"'
        }

        if($PrimaryKey){
            $searchFilters += 'primaryKey EQ "' + $PrimaryKey + '"'
        }

        if($Family){
            $searchFilters += 'family EQ "' + $Family + '"'
        }

        if($SupportsFC){
            $searchFilters += 'supportsFC EQ "true"'
        }

        if($SupportsISCSI){
            $searchFilters += 'supportsISCSI EQ "true"'
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

        Write-Verbose "Found $($result.total) number of results"
        if ($result.Count -lt $result.Total ) {
            Write-Warning "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDStorageSystem" -Object $result.members
        return $output
    }

    end {
    }
}