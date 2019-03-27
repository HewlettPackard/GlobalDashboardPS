function Get-OVGDGroup {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [alias("Group")]
        $Entity,
        $Count = 25
    )
    
    begin {
        $ResourceType = "groups"
    }
    
    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        Invoke-OVGDRequest -Resource $Resource

    }
    
    end {
    }
}