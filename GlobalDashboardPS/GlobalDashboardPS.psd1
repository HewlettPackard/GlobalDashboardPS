#
# Module manifest for module 'GlobalDashboard'
#
# Generated by: Rudi Martinsen / Intility AS
#
# Generated on: 27.03.2019
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'GlobalDashboardPS'

# Version number of this module.
ModuleVersion = '0.9.1'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '6eddfa4a-af27-4b47-863b-6dc42db3cb6a'

# Author of this module
Author = 'Rudi Martinsen / Intility AS'

# Company or vendor of this module
CompanyName = 'Intility AS'

# Copyright statement for this module
Copyright = '(c) 2019 Rudi Martinsen / Intility AS. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Powershell module for working with the HPE OneView Global Dashboard Rest API'

# Minimum version of the Windows PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
 FormatsToProcess = @('GlobalDashboardPS.Format.ps1xml')

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('New-OVGDGroup','Connect-OVGD','Disconnect-OVGD','Get-OVGDAppliance','Get-OVGDCertificate','Get-OVGDConvergedSystem',
'Get-OVGDEnclosure','Get-OVGDGroup','Get-OVGDGroupMember','Get-OVGDServerHardware','Get-OVGDServerProfile','Get-OVGDServerProfileTemplate',
'Get-OVGDStorageSystem','New-OVGDSessionKey','Remove-OVGDGroup','Remove-OVGDSessionKey','Add-OVGDAppliance','Set-OVGDAppliance','Remove-OVGDAppliance',
'Get-OVGDResourceAlert','Get-OVGDTask','Get-OVGDStorageVolume','Get-OVGDStoragePool','Get-OVGDSANManager','Get-OVGDManagedSAN')

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = ''

# Variables to export from this module
VariablesToExport = ''

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = ''

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @("HPE","OneViewGlobalDashboard","GlobalDashboard","OVGD","Hewlett-PackardEnterprise")

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/rumart/GlobalDashboardPS/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/rumart/GlobalDashboardPS'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = 'https://github.com/rumart/GlobalDashboardPS/blob/master/changelog.md'

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

