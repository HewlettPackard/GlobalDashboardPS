function Get-OVGDConvergedSystem {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [alias("System")]
        $Entity,
        $Count = 25
    )

    begin {
        $ResourceType = "converged-systems"
    }

    process {

        $Resource = BuildPath -Resource $ResourceType -Entity $Entity

        Invoke-OVGDRequest -Resource $Resource

    }

    end {
    }
}