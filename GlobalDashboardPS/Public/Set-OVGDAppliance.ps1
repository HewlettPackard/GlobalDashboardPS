function Set-OVGDAppliance {
    <#
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        $Server,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [alias("Appliance")]
        $Entity,
        [Parameter(ParameterSetName="Name")]
        $NewName,
        [Parameter(ParameterSetName="Refresh")]
        [switch]
        $Refresh,
        [Parameter(ParameterSetName="Reconnect")]
        [switch]
        $Reconnect,
        [Parameter(ParameterSetName="Reconnect")]
        $Username,
        [Parameter(ParameterSetName="Reconnect")]
        [securestring]
        $Password,
        [Parameter(ParameterSetName="Reconnect")]
        $LoginDomain
    )
    BEGIN {
        $ResourceType = "appliances"
        $operation = "replace"
    }
    PROCESS {

        if ($Reconnect -and !$Password) {
            $Password = Read-Host -Prompt "Password please" -AsSecureString
            $unsecPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
            $value = [PSCustomObject]@{
                username = $Username
                password = $unsecPass
                loginDomain = $LoginDomain
            } #| ConvertTo-Json
            $opPath = "/credential"
        }
        elseif($Refresh) {
            $value = "refreshPending"
            $opPath = "/status"
        }
        else {
            $value = $NewName
            $opPath = "/applianceName"
        }

        $abody = [PSCustomObject]@{
            op = $operation
            path = $opPath
            value = $value
        } #| ConvertTo-Json

        $body = ConvertTo-Json @($abody)
        Write-Verbose $body

        $Resource = BuildPath -Resource $ResourceType -Entity $Entity

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Invoke-OVGDRequest -Resource $Resource -Method PATCH -Body $body -ContentType "application/json-patch+json" -Verbose
        }
    }
    END {

    }

}