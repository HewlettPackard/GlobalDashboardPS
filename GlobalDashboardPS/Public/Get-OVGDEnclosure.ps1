function Get-OVGDEnclosure {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [alias("Enclosure")]
        $Entity,
        $Count = 25
    )
    
    begin {
        $ResourceType = "enclosures"
    }
    
    process {

        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        Invoke-OVGDRequest -Resource $Resource

    }
    
    end {
    }
}