function Disconnect-OVGD {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        $Sessionkey = $Global:OVGDPSToken
    )

    begin {
    }

    process {
        Remove-OVGDSessionKey -Server $Server -Sessionkey $Sessionkey
    }

    end {
    }
}