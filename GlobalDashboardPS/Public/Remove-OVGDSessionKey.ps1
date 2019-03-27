function Remove-OVGDSessionKey {
    [CmdletBinding()]
    param (
        $Server,
        $Sessionkey
    )
    
    begin {
        if (!$Sessionkey -and !$Global:OVGDPSToken) {
            Write-Error "No session key found to delete"
        }

    }
    
    process {
        Invoke-OVGDRequest -Method DELETE -System $Server -Resource login-sessions
        $local:OVGDPSToken = $null
        $local:OVGDPSServer = $null
    }
    
    end {
        
    }
}