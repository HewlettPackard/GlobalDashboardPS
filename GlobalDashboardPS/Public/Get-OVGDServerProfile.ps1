function Get-OVGDServerProfile {
    <#
        .SYNOPSIS
            Retrieves the Server profiles connected to the Global Dashboard instance
        .DESCRIPTION
            This function will retrieve the Server profiles on the specified Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.4.0
            Revised : 25/04-2019
            Changelog:
            0.4.0 -- Changed Entity parameter to Id, adding Name alias
            0.3.0 -- Added support for querying and changed warning when result is bigger than count
            0.2.2 -- Fixed bug in help text and added link
            0.2.1 -- Added help text
            0.2.0 -- Added count param
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to retrieve Server Profiles from
        .PARAMETER Id
            The Id of the Server Profile to retrieve
        .PARAMETER ServerName
            Filter on the ServerName of the Server Profile to retrieve. Note that we search for an exact match
        .PARAMETER SerialNumber
            Filter on the SerialNumber of the Server Profile to retrieve. Note that we search for an exact match
        .PARAMETER Appliance
            Filter on the Appliance of the Server Profile to retrieve. Note that we search for an exact match
        .PARAMETER Status
            Filter on the Status of the Server Profile to retrieve. Note that we search for an exact match
        .PARAMETER State
            Filter on State of the Server Profile to retrieve. Note that we search for an exact match
        .PARAMETER TemplateCompliance
            Filter on the Template Compliance of the Server Profile to retrieve. Note that we search for an exact match
        .PARAMETER UserQuery
            Query string used for full text search
        .PARAMETER Count
            The count of Server Profile to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDServerProfile

            Retrieves all Server Profiles connected to the Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDServerProfile -Id xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Retrieves the specific Server Profile with the specified ID
        .EXAMPLE
            PS C:\> Get-OVGDServerProfile -ServerName my-server-name-001

            Searches for a Server Profile associated with the specified servername
        .EXAMPLE
            PS C:\> Get-OVGDServerProfile -UserQuery "Proliant DL360"

            Performs a full text search and matches all attributes for the specified string
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
        $ServerProfileName,
        [Parameter(ParameterSetName="Query")]
        $Appliance,
        [Parameter(ParameterSetName="Query")]
        $SerialNumber,
        [Parameter(ParameterSetName="Query")]
        $ServerName,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("Compliant","NonCompliant","Unknown")]
        $TemplateCompliance,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("OK","Warning","Critical","Disabled","Unknown")]
        $Status,
        [Parameter(ParameterSetName="Query")]
        [ValidateSet("Normal","CreateFailed","UpdateFailed","Unknown")]
        $State,
        [Parameter(ParameterSetName="Query")]
        $UserQuery,
        [Parameter(ParameterSetName="Default")]
        [Parameter(ParameterSetName="Id")]
        [Parameter(ParameterSetName="Query")]
        $Count = 25
    )

    begin {
        $ResourceType = "server-profiles"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Id
        $Query = "count=$Count"
        $searchFilters = @()
        $txtSearchFilters = @()
        
        if($ServerProfileName){
            $searchFilters += 'name EQ "' + $ServerProfileName + '"'
        }

        if($SerialNumber){
            $searchFilters += 'serialNumber EQ "' + $SerialNumber + '"'
        }

        if($Appliance){
            $searchFilters += 'applianceName EQ "' + $Appliance + '"'
        }

        if($ServerName){
            $searchFilters += 'serverName EQ "' + $ServerName + '"'
        }

        if($TemplateCompliance){
            $searchFilters += 'templateCompliance EQ "' + $TemplateCompliance + '"'
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

        $result = Invoke-OVGDRequest -Resource $Resource -Query $Query #-Verbose

        Write-Verbose "Found $($result.total) number of results"
        if ($result.Count -lt $result.Total ) {
            Write-Warning "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDServerProfile" -Object $result.members
        return $output
    }

    end {
    }
}