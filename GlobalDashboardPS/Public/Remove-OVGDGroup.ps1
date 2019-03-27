function Remove-OVGDGroup {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [parameter(Mandatory=$true)]
        $Group
    )
    
    begin {
        $ResourceType = "groups"
    }
    
    process {
        $Resource = BuildPath -Resource $ResourceType -Entity $Group
        Write-Verbose $resource
        Invoke-OVGDRequest -Method DELETE -Resource $resource -Verbose
    }
    
    end {
    }
}