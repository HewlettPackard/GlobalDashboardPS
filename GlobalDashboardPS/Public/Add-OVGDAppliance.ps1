function Add-OVGDAppliance {
    <#
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        $Server,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [alias("Appliance")]
        $ApplianceName,
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [alias("IP")]
        $ApplianceIP,
        $Username,
        [securestring]
        $Password = (Read-Host -Prompt "Password please" -AsSecureString),
        $LoginDomain = "local"
    )
    BEGIN {
        $ResourceType = "appliances"

    }
    PROCESS {
        $unsecPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        $body = [PSCustomObject]@{
            address = $ApplianceIP
            applianceName = $ApplianceName
            loginDomain = $LoginDomain
            username = $UserName
            password = $unsecPass
        } | ConvertTo-Json
        Write-Verbose $body

        $Resource = BuildPath -Resource $ResourceType

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Invoke-OVGDRequest -Resource $Resource -Method POST -Body $body
        }
    }
    END {

    }

}