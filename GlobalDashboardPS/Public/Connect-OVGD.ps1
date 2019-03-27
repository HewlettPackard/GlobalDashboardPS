function Connect-OVGD {
    [cmdletbinding()]
    param (
        $Server,
        $UserName,
        [SecureString]
        $Password = (Read-Host -Prompt "Password please" -AsSecureString),
        $Directory = "local"
    )

    BEGIN {
        if($IgnoreSSL){
            Set-InsecureSSL
        }
    }
    PROCESS {
        New-OVGDSessionKey -Server $Server -Username $Username -Password $Password -LoginDomain $Directory
    }
    END {

    }

}