function Remove-OVGDGroup {
    <#
        .SYNOPSIS
            Delete a Global Dashboard group
        .DESCRIPTION
            This function will remove a logical group in the connected Global Dashboard instance
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
        .PARAMETER Group
            The Id of the Group to delete
        .EXAMPLE
            PS C:\> Remove-OVGDGroup -Group xxxxxxxx-xxxx-xxxx-xxxx-1b2841850e85
            
            Deletes the logical group on the connected Global Dashboard instance with the specified uri
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        $Server = $Global:OVGDPSServer,
        [parameter(Mandatory=$true)]
        $Group
    )

    begin {
        $ResourceType = "groups"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Group
        Write-Verbose $resource

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Invoke-OVGDRequest -Method DELETE -Resource $resource -Verbose
        }
        # else {
        #     Write-Output "This will delete the group $Group on server $server"
        # }
    }

    end {
    }
}