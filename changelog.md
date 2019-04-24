# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Function for adding members to a group
- Function for removing members from a group
- Function for changing the name and/or the parent of a group
- Function for listing Storage pools
- Function for listing Storage volumes
- Function for listing Tasks (#3)
- Function for listing SAN Managers
- Function for listing Managed SANs
- Function for returning the sso url of an appliance
- Function for returning the sso url of a server hardware
- Function for returning the sso url of an enclosure
- Function for importing a server certificate
- Function for removing a server certificate
- Function for listing the configuration of the network interfaces
- Function for configuring a network interface
- Support paging
- Support queries
- Scriptanalyzer test

## [version 0.6.0] - 2019-04-24

### Added

- Support PSCredential (#1)
- Function for listing Resource Alerts (#2)

## [version 0.5.0] - 2019-04-23

### Changed

- Output format

## [version 0.4.6] - 2019-04-23

### Changed

- Validating method variable in the Invoke-OVGDRequest function

## [version 0.4.5] - 2019-04-17

### Fixed

- Tags in manifest file

## [version 0.4.4] - 2019-04-17

### Fixed

- Specified test in pipeline

## [version 0.4.3] - 2019-04-17

### Added

- CI pipeline

## [version 0.4.2] - 2019-04-17

### Added

- Help text

## [version 0.4.1] - 2019-04-17

### Changed

- Renamed group Add-OVGDGroup to New-OVGDGroup

## [version 0.4.0] - 2019-04-17

### Added

- Pester tests

## [version 0.3.0] - 2019-03-28

### Changed

- Renamed the module manifest file to the correct name

## [version 0.2.3] - 2019-03-28

### Added

- Function for Updating an appliance
- Function for Removing an appliance

### Changed

- Adding support for contenttype in Invoke-OVGDRequest cmdlet

## [version 0.2.2] - 2019-03-27

### Added

- Function for Adding an appliance

## [version 0.2.1] - 2019-03-27

### Changed

- Fixed some syntax based on PSScriptAnalyzer tests

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