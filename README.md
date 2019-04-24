# HPE OneView Global Dashboard Powershell module

[![Build status](https://ci.appveyor.com/api/projects/status/4309as0cbnf0j3j5?svg=true)](https://ci.appveyor.com/project/rumart/globaldashboardps)

This is a work in progress repo for creating a PS module for working with the HPE OneView Global Dashboard REST API. Keep track of changes in the [changelog](changelog.md)

The module is published to the [Powershell Gallery](https://www.powershellgallery.com/packages/GlobalDashboardPS). To install directly (note that you need to have Powershell get for this, please refer to the PS Gallery for more information):

```powershell
Install-Module -Name GlobalDashboardPS -Repository PSGallery
```

For now the following functions are available:

- Connect-OVGD
- New-OVGDSessionKey
- Disconnect-OVGD
- Remove-OVGDSessionKey
- Get-OVGDAppliance
- Add-OVGDAppliance
- Set-OVGDAppliance (note! the Refresh option does not work at this point)
- Remove-OVGDAppliance
- Get-OVGDCertificate
- Get-OVGDConvergedSystem
- Get-OVGDEnclosure
- Get-OVGDGroup
- New-OVGDGroup
- Remove-OVGDGroup
- Get-OVGDResourceAlerts
- Get-OVGDGroupMember
- Get-OVGDServerHardware
- Get-OVGDServerProfile
- Get-OVGDServerProfileTemplate
- Get-OVGDStorageSystem
- BuildResource (private function)
- Invoke-OVGDRequest (private function)
- Set-InsecureSSL (private function)
- Add-OVGDTypeName (private function)