function Add-OVGDGroup {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [parameter(Mandatory=$true)]
        $GroupName,        
        $Parent
    )
    
    begin {
        $ResourceType = "groups"
        $Method = "POST"
    }
    
    process {

        $body = @{
            "name" = $GroupName
            "parentUri" = $Parent
        } | ConvertTo-Json

        Invoke-OVGDRequest -Resource $ResourceType -Method $Method -Body $body

    }
    
    end {
    }
}