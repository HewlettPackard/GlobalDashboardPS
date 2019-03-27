function Remove-OVGDGroup {
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
            Write-Output "This will delete the group $Group on server $server"
        }
        else {
            Invoke-OVGDRequest -Method DELETE -Resource $resource -Verbose
        }
    }

    end {
    }
}