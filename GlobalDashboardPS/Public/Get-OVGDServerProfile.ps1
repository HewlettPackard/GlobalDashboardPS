function Get-OVGDServerProfile {
    [CmdletBinding()]
    param (
        $Server,
        [alias("ServerProfile")]
        $Entity,
        $Count = 25
    )

    begin {
        $ResourceType = "server-profiles"
    }

    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        Invoke-OVGDRequest -Resource $Resource -Query $Query
    }

    end {
    }
}