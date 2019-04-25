function Get-OVGDResourceAlert {
    <#
        .SYNOPSIS
            Retrieve resource alerts from a Global Dashboard instance
        .DESCRIPTION
            This function will retrieve resource alerts on the connected Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 24/04-2019
            Version : 0.2.0
            Revised : 25/04-2019
            Changelog:
            0.2.0 -- Added support for querying and changed warning when result is bigger than count
            0.1.1 -- Added link to help text
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to work with, defaults to the Global variable OVGDPSServer
        .PARAMETER ResourceName
            Filter on the Resource Name of the Alert to retrieve. Note that we search for an exact match
        .PARAMETER Appliance
            Filter on the Appliance of the Alert Template to retrieve. Note that we search for an exact match
        .PARAMETER AlertType
            Filter on the AlertType of the Alert Template to retrieve. Note that we search for an exact match
        .PARAMETER HealthCategory
            Filter on the HealthCategory of the Alert Template to retrieve. Note that we search for an exact match
        .PARAMETER Severity
            Filter on the Severity of the Alert Template to retrieve. Note that we search for an exact match
        .PARAMETER AssignedTo
            Filter on the AssignedToUser of the Alert Template to retrieve. Note that we search for an exact match
        .PARAMETER State
            Filter on State of the Alert Template to retrieve. Note that we search for an exact match
        .PARAMETER UserQuery
            Query string used for full text search
        .PARAMETER Count
            The count of hardware to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDResourceAlert

            Returns the 25 latest resource alerts from the connected Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDResourceAlert -Count 50

            Returns the 50 latest resource alerts from the connected Global Dashboard instance
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Id")]
        [Parameter(ParameterSetName="Query")]
        $Server = $Global:OVGDPSServer,
        [Parameter(ParameterSetName="Query")]
        $ResourceName,
        [Parameter(ParameterSetName="Query")]
        $Appliance,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("server-hardware","server-profiles","logical-interconnects","interconnects","appliance","enclosures","storage-systems","storage-pools","storage-volumes")]
        $AlertType,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("Server","ServerProfile","RemoteSupport","Operational","None","Network","ManagementProcessor","Logs","logical-interconnect","interconnect","Firmware","Certificate Management")]
        $HealthCategory,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("Active","Cleared","Locked")]
        $State,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("Critical","Disabled","OK","Unknown","Warning")]
        $Severity,
        [Parameter(ParameterSetName="Query")]
        $AssignedTo,
        [Parameter(ParameterSetName="Query")]
        $UserQuery,
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Id")]
        [Parameter(ParameterSetName="Query")]
        $Count = 25
    )

    begin {
        $ResourceType = "resource-alerts"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType
        $Query = "count=$Count"
        
        $searchFilters = @()
        $txtSearchFilters = @()

        if($AlertType){
            $searchFilters += 'physicalResourceType EQ "' + $AlertType + '"'
        }

        if($HealthCategory){
            $searchFilters += 'healthCategory EQ "' + $HealthCategory + '"'
        }

        if($ResourceName){
            $searchFilters += 'associatedResourceName EQ "' + $ResourceName + '"'
        }
        
        if($State){
            $searchFilters += 'alertState EQ "' + $State + '"'
        }

        if($Severity){
            $searchFilters += 'severity EQ "' + $Severity + '"'
        }

        if($AssignedTo){
            $searchFilters += 'assignedToUser EQ "' + $AssignedTo + '"'
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

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDResourceAlert" -Object $result.members
        return $output
    }

    end {
    }
}