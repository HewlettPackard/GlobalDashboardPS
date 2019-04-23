function Add-OVGDTypeName {
    [CmdletBinding()]
    param (
        [parameter(Mandatory = $true)]
        [System.String]
        $Typename,

        [Parameter(Mandatory = $false)]
        [System.Object]
        $Object
    )

    begin {
    }

    process {
        if($Object){
            foreach ($item in $Object) {
                $item.PSOBject.TypeNames.Insert(0,$Typename)
                Write-Output $item
            }
        }
        else {

        }
    }
    end {
    }
}
