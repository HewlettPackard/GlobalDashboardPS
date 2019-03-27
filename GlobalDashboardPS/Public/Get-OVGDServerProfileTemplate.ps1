function Get-OVGDServerProfileTemplate {
    [CmdletBinding()]
    param (
        $Server,
        [alias("ServerProfileTemplate")]
        $Entity,
        $Count = 25
    )
    
    begin {
        $ResourceType = "server-profile-templates"
    }
    
    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        Invoke-OVGDRequest -Resource $Resource -Query $Query -Verbose
    }
    
    end {
    }
}