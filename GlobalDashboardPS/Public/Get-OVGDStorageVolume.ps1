function Get-OVGDStorageVolume {
    <#
        .SYNOPSIS
            Retrieves the Storage Volumes connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Storage Volumes on the specified Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 24/04-2019
            Version : 0.3.0
            Revised : 25/04-2019
            Changelog:
            0.3.0 -- Changed Entity parameter to Id, adding Name alias
            0.2.0 -- Added support for querying, changed warning text when result is bigger than count
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to retrieve Storage Volumes from
        .PARAMETER Id
            The Id of the Storage Volume to retrieve
        .PARAMETER StorageVolumeName
            Filter on the Name of the Storage Volume to retrieve. Note that we search for an exact match
        .PARAMETER PrimaryKey
            Filter on the PrimaryKey of the Storage Volume to retrieve. Note that we search for an exact match
        .PARAMETER ProvisioningType
            Filter on the Provisioning Type of the Storage Volume to retrieve. Note that we search for an exact match
        .PARAMETER TemplateConsistency
            Filter on the Template Consistency of the Storage Volume to retrieve. Note that we search for an exact match
        .PARAMETER State
            Filter on the State of the Storage Volume to retrieve. Note that we search for an exact match
        .PARAMETER Status
            Filter on the Status of the Storage Volume to retrieve. Note that we search for an exact match
        .PARAMETER UserQuery
            Query string used for full text search
        .PARAMETER Count
            The count of Storage Volumes to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDStorageVolume

            Lists the Storage Volumes on the connected Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDStorageVolume -Id xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Lists the Storage Volume on the connected Global Dashboard instance with the specified Id
        .EXAMPLE
            PS C:\> Get-OVGDStorageVolume -TemplateConsistency Inconsistent

            Lists the Storage Volume on the connected Global Dashboard instance with an Inconsistent Template Consistency
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
        $StorageVolumeName,
        [Parameter(ParameterSetName="Query")]
        $PrimaryKey,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("Thin","Full")]
        $ProvisioningType,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("Consistent","Inconsistent")]
        $TemplateConsistency,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("AddFailed", "Adding", "Configured", "Connected", "Copying", "CreateFailed", "Creating", "DeleteFailed", "Deleting", "Discovered", "Managed", "Normal", "UpdateFailed", "Updating")]
        $State,
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
        $ResourceType = "storage-volumes"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Id
        $searchFilters = @()
        $txtSearchFilters = @()

        if($StorageVolumeName){
            $searchFilters += 'name EQ "' + $StorageVolumeName + '"'
        }

        if($PrimaryKey){
            $searchFilters += 'primaryKey EQ "' + $PrimaryKey + '"'
        }

        if($ProvisioningType){
            $searchFilters += 'provisioningType EQ "' + $ProvisioningType + '"'
        }

        if($TemplateConsistency){
            $searchFilters += 'templateConsistency EQ "' + $TemplateConsistency + '"'
        }

        if($State){
            $searchFilters += 'state EQ "' + $State + '"'
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

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDStorageVolume" -Object $result.members
        return $output
    }

    end {
    }
}