function Get-OVGDStorageSystem {
    [CmdletBinding()]
    param (
        $Server,
        [alias("StorageSystem")]
        $Entity,
        $Count = 25
    )
    
    begin {
        $ResourceType = "storage-systems"
    }
    
    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        Invoke-OVGDRequest -Resource $Resource -Query $Query
    }
    
    end {
    }
}