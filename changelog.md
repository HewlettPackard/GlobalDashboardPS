# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Pester tests
- Scriptanalyzer test
- Function for adding members to a group
- Function for removing members from a group
- Function for changing the name and/or the parent of a group
- Function for listing Storage pools
- Function for listing Storage volumes
- Function for listing Tasks
- Function for listing SAN Managers
- Function for listing Resource Alerts
- Function for listing Managed SANs
- Function for Adding an appliance
- Function for Updating an appliance
- Function for Removing an appliance
- Function for returning the sso url of an appliance
- Function for returning the sso url of a server hardware
- Function for returning the sso url of an enclosure
- Function for importing a server certificate
- Function for removing a server certificate
- Function for listing the configuration of the network interfaces
- Function for configuring a network interface
- Support paging
- Support queries
- CI pipeline

### Changed

- Output format

## [version 0.2.1] - 2019-03-27

### Changed

- Fixed some syntax based on PSScriptAnalyzer tests
- Added ShouldProcess support on functions

## [version 0.2.0] - 2019-03-27

### Added

- Added README
- Added changelog
- Module manifest

### Changed

- Moved functions to separate files

## [version 0.1.1] - 2019-03-27

### Changed

- Changed name of function that creates resource path

## [version 0.1.0] - 2019-03-25

### Added

- Initial commit of module. All contained in a single psm1 file
  - Following functions are added:
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