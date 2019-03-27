function Get-OVGDCertificate {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer
    )

    begin {
        $Resource = "certificates/https/remote/$Server"
    }

    process {
        Invoke-OVGDRequest -Resource $Resource
    }

    end {
    }
}