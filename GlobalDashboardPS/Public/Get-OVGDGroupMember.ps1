function Get-OVGDGroupMember {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [Parameter(Mandatory=$true)]
        [alias("Group")]
        $Entity#,
        #$Count = 25
    )
    
    begin {
        $ResourceType = "groups"
    }
    
    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity
        
        Invoke-OVGDRequest -Resource ($Resource + "/members")

    }
    
    end {
    }
}