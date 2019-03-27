function Get-OVGDAppliance {
    <#
    #>
    [CmdletBinding()]
    param (
        $Server,
        [Parameter(Mandatory=$false,ValueFromPipeline=$true)]
        [alias("Appliance")]
        $Entity,
        $Count = 25
    )
    BEGIN {
        $ResourceType = "appliances"

    }
    PROCESS {
        $Resource = BuildPath -Resource $ResourceType -Entity $Entity

        Invoke-OVGDRequest -Resource $Resource
    }
    END {

    }

}