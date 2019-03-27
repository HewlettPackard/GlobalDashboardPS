function Add-OVGDGroup {
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