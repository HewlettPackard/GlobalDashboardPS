function Get-OVGDServerHardware {
    [CmdletBinding()]
    param (
        $Server,
        [alias("ServerHardware")]
        $Entity,
        $Count = 25
    )
    
    begin {
        $ResourceType = "server-hardware"
    }
    
    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        Invoke-OVGDRequest -Resource $Resource -Query $Query -Verbose
    }
    
    end {
    }
}