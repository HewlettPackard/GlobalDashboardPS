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
            Version : 0.1.0
            Revised : 
            Changelog:
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
        .PARAMETER Count
            The count of Storage Pools to retrieve, defaults to 25
        .EXAMPLE
            PS C:\> Get-OVGDStoragePool

            Lists the Storage Pools on the connected Global Dashboard instance
        .EXAMPLE
            PS C:\> Get-OVGDStoragePool -Entity xxxxxxxx-xxxx-xxxx-xxxx-54e195f27f36

            Lists the Storage Pool on the connected Global Dashboard instance with the specified Id
    #>
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [alias("StoragePool")]
        $Entity,
        $Count = 25
    )

    begin {
        $ResourceType = "storage-pools"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $result = Invoke-OVGDRequest -Resource $Resource

        if ($result.Count -lt $result.Total ) {
            Write-Verbose "The result has been paged. Total number of results is: $($result.total)"
        }

        $output = Add-OVGDTypeName -TypeName "GlobalDashboardPS.OVGDStoragePool" -Object $result.members
        return $output
    }

    end {
    }
}