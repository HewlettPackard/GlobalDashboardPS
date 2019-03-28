function Remove-OVGDSessionKey {
    [CmdletBinding(SupportsShouldProcess)]
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

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Invoke-OVGDRequest -Method DELETE -System $Server -Resource login-sessions
        }

        $local:OVGDPSToken = $null
        $local:OVGDPSServer = $null
    }

    end {

    }
}