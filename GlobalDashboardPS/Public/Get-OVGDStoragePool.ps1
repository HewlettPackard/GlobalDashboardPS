function Get-OVGDStoragePool {
    <#
        .SYNOPSIS
            Retrieves the Storage Pools connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Storage Pools on the specified Global Dashboard instance
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
            The Global Dashboard to retrieve Storage Pools from
        .PARAMETER Entity
            The Id of the Storage Pool to retrieve
        .PARAMETER StorageSystemName
            Filter on the Storage System of the Storage Pool to retrieve. Note that we search for an exact match
        .PARAMETER PrimaryKey
            Filter on the PrimaryKey of the Storage Pool to retrieve. Note that we search for an exact match
        .PARAMETER Family
            Filter on the Family of the Storage Pool to retrieve. Note that we search for an exact match
        .PARAMETER Status
            Filter on the Status of the Storage Pool to retrieve. Note that we search for an exact match
        .PARAMETER UserQuery
            Query string used for full text search
        .PARAMETER Count
            The count of Storage Pools to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDStoragePool

            Lists the Storage Pools on the connected Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDStoragePool -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Lists the Storage Pool on the connected Global Dashboard instance with the specified Id
        .EXAMPLE
            PS C:\> Get-OVGDStoragePool -Status Critical

            Lists the Storage Pool on the connected Global Dashboard instance with a critical status
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Id")]
        [Parameter(ParameterSetName="Query")]
        $Server = $Global:OVGDPSServer,
        [Parameter(ParameterSetName="Id")]
        [alias("StoragePool")]
        $Entity,
        [Parameter(ParameterSetName="Query")]
        $StoragePoolName,
        [Parameter(ParameterSetName="Query")]
        $StorageSystemName,
        [Parameter(ParameterSetName="Query")]
        $PrimaryKey,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("StoreServ","StoreVirtual")]
        $Family,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("OK","Warning","Critical","Disabled","Unknown")]
        $Status,
        [Parameter(ParameterSetName="Query")]
        $UserQuery,
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Id")]
        [Parameter(ParameterSetName="Query")]
        $Count = 25
    )

    begin {
        $ResourceType = "storage-pools"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $searchFilters = @()
        $txtSearchFilters = @()

        if($StoragePoolName){
            $searchFilters += 'name EQ "' + $StoragePoolName + '"'
        }

        if($StorageSystemName){
            $searchFilters += 'storageSystemName EQ "' + $StorageSystemName + '"'
        }

        if($PrimaryKey){
            $searchFilters += 'primaryKey EQ "' + $PrimaryKey + '"'
        }

        if($Family){
            $searchFilters += 'storageFamily EQ "' + $Family + '"'
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

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDStoragePool" -Object $result.members
        return $output
    }

    end {
    }
}