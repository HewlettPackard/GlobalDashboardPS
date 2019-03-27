# HPE Global Dashboard Powershell module

This is a work in progress repo for creating a PS module for working with the HPE Global Dashboard REST API

For now the following functions are available. Please note that the output is more or less the raw output from the API:

- Connect-OVGD
- New-OVGDSessionKey
- Disconnect-OVGD
- Remove-OVGDSessionKey
- Get-OVGDAppliance
- Get-OVGDCertificate
- Get-OVGDConvergedSystem
- Get-OVGDEnclosure
- Get-OVGDGroup
- Add-OVGDGroup
- Remove-OVGDGroup
- Get-OVGDGroupMember
- Get-OVGDServerHardware
- Get-OVGDServerProfile
- Get-OVGDServerProfileTemplate
- Get-OVGDStorageSystem
- BuildResource (private function)
- Invoke-OVGDRequest (private function)
- Set-InsecureSSL (private function)