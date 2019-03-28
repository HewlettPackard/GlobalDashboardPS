function Remove-OVGDAppliance {
    <#
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param (
        $Server,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [alias("Appliance")]
        $Entity
    )
    BEGIN {
        $ResourceType = "appliances"

    }
    PROCESS {

        $Resource = BuildPath -Resource $ResourceType -Entity $Entity

        if ($PSCmdlet.ShouldProcess("ShouldProcess?")) {
            Invoke-OVGDRequest -Resource $Resource -Method DELETE
        }
    }
    END {

    }

}