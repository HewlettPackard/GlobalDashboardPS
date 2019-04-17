function New-OVGDGroup {
    <#
        .SYNOPSIS
            Create a new Global Dashboard group
        .DESCRIPTION
            This function will create a new logical group in the connected Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.1.1
            Revised : 17/04-2019
            Changelog:
            0.1.1 -- Added help text
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .PARAMETER Server
            The Global Dashboard to work with, defaults to the Global variable OVGDPSServer
        .PARAMETER GroupName
            The Name of the Group to create
        .PARAMETER Parent
            The Id of the Parent group
        .EXAMPLE
            PS C:\> New-OVGDGroup -GroupName MyGroup
            
            Creates a logical group on the connected Global Dashboard instance with the name "MyGroup"
        .EXAMPLE
            PS C:\> New-OVGDGroup -GroupName MyGroup -Parent /rest/groups/xxxxxxxx-xxxx-xxxx-xxxx-2e4e1f02b0c0
            
            Creates a logical group on the connected Global Dashboard instance with the name "MyGroup" as a child group of the specified parent
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        $Server = $Global:OVGDPSServer,
        [parameter(Mandatory=$true)]
        $GroupName,
        $Parent
    )

    begin {
        $ResourceType = "groups"
        $Method = "POST"
    }

    process {

        $body = @{
            "name" = $GroupName
            "parentUri" = $Parent
        } | ConvertTo-Json

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Invoke-OVGDRequest -Resource $ResourceType -Method $Method -Body $body
        }
        # else {
        #     Write-Output "This will create the logical group $group on server $server"
        # }

    }

    end {
    }
}