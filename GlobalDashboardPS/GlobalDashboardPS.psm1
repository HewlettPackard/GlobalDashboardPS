
function BuildResourcePath {
    [CmdletBinding()]
    param (
        $Resource,
        $Entity
    )
    if ($Entity) {
        if($Entity -is [string]){
            $Resource += "/$Entity"
        }
        elseif ($Entity -is [object]) {
            if ($Entity.category -eq $Resource) {
                $Resource = $Entity.uri
            }
            else {
                $Resource += "/$($Entity.id)"
            }
        }
    }
    return $resource
}

function Set-InsecureSSL {
add-type @" 
    using System.Net; 
    using System.Security.Cryptography.X509Certificates; 
    public class TrustAllCertsPolicy : ICertificatePolicy { 
        public bool CheckValidationResult( 
            ServicePoint srvPoint, X509Certificate certificate, 
            WebRequest request, int certificateProblem) { 
            return true; 
        } 
    } 
"@  
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
    [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
}

function Invoke-OVGDRequest {
    [CmdletBinding()]
    param(
        $Protocol = "https",
        $Port = 443,
        $System = $Global:OVGDPSServer,
        $Path,
        $Resource,
        $Body,
        $Query,
        # [ValidateRange("GET","POST","DELETE")]
        $Method = "GET",
        $SessionKey = $Global:OVGDPSToken,
        [switch]
        $IgnoreSSL = $true
    )

    BEGIN {
        if($IgnoreSSL){
            Set-InsecureSSL
        }
    }
    PROCESS {
        if($Resource -notlike "/rest/*"){
             Write-Verbose "InPath: $Resource"

            $Resource = "/rest/" + $Resource
        }

        $Path += $Resource
        Write-Verbose "Path: $path"

        $URIBuilder = New-Object System.UriBuilder -ArgumentList @($Protocol, $System, $Port, $Path)
        $Uribuilder.Query = $query
        Write-Verbose "qry: $($uribuilder.query)"
        
        $headers = @{} 
        $headers["X-Api-Version"] = 2

        if($SessionKey){
            $headers["Auth"] = $sessionkey
        }
        
        Write-Verbose "URI: $($uribuilder.uri)"
        $response = Invoke-RestMethod -Method $Method -Uri $URIBuilder.Uri -Headers $headers -Body $Body -ContentType "application/json" -ErrorVariable apiErr -Verbose

    }
    END {
        if($apiErr){
            Write-Verbose $apiErr.InnerException
        }
        $response
    }
}

function New-OVGDSessionKey{
    <#
    
    #>
    [CmdletBinding()]
        param(
            [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
            $Server,
            [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
            $Username,
            [Parameter(Mandatory=$true, ValueFromPipeline=$false)]
            [securestring]
            $Password,
            [Parameter(Mandatory=$false, ValueFromPipeline=$false)]
            #[ValidateSet("your-domain-here","local")]
            $LoginDomain,
            [switch]
            $IgnoreSSL
        )
    
    
    if($IgnoreSSL){
     Set-InsecureSSL
    }

    $global:OVGDPSServer = $server
    
    $unsecPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))

    $body = [PSCustomObject]@{
        authLoginDomain = $LoginDomain
        userName = $UserName
        password = $unsecPass
    } | ConvertTo-Json
    #Write-Verbose $body
    $response = Invoke-OVGDRequest -Method Post -System $Server -Resource login-sessions -Body $body -Verbose
    
    $sessionkey = $response.token
    $global:OVGDPSToken = $sessionkey
    
    
}

function Remove-OVGDSessionKey {
    [CmdletBinding()]
    param (
        $Server,
        $Sessionkey
    )
    
    begin {
        if (!$Sessionkey -and !$Global:OVGDPSToken) {
            Write-Error "No session key found to delete"
        }

    }
    
    process {
        Invoke-OVGDRequest -Method DELETE -System $Server -Resource login-sessions
        $Global:OVGDPSToken = $null
        $Global:OVGDPSServer = $null
    }
    
    end {
        
    }
}

function Connect-OVGD {
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
        
        New-OVGDSessionKey -Server $Server -Username $Username -Password $Password -LoginDomain $Directory -IgnoreSSL -Verbose
        
    }
    END {

    }

}

function Disconnect-OVGD {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        $Sessionkey = $Global:OVGDPSToken
    )
    
    begin {
    }
    
    process {
        Remove-OVGDSessionKey -Server $Server -Sessionkey $Sessionkey
    }
    
    end {
    }
}

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
        $Resource = BuildResourcePath -Resource $ResourceType -Entity $Entity

        Invoke-OVGDRequest -Resource $Resource
    }
    END {

    }
    

}

function Add-OVGDAppliance {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
    }
    
    process {
    }
    
    end {
    }
}

function Get-OVGDCertificate {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer
    )
    
    begin {
        $Resource = "certificates/https/remote/$Server"
    }
    
    process {
        Invoke-OVGDRequest -Resource $Resource 
    }
    
    end {
    }
}

function Add-OVGDCertificate {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
    }
    
    process {
    }
    
    end {
    }
}

function Remove-OVGDCertificate {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
    }
    
    process {
        throw NotImplemented;
    }
    
    end {
    }
}

function Get-OVGDConvergedSystem {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [alias("System")]
        $Entity,
        $Count = 25
    )
    
    begin {
        $ResourceType = "converged-systems"
    }
    
    process {
        
        $Resource = BuildResourcePath -Resource $ResourceType -Entity $Entity

        Invoke-OVGDRequest -Resource $Resource

    }
    
    end {
    }
}

function Get-OVGDEnclosure {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [alias("Enclosure")]
        $Entity,
        $Count = 25
    )
    
    begin {
        $ResourceType = "enclosures"
    }
    
    process {

        $Resource = BuildResourcePath -Resource $ResourceType -Entity $Entity
        Invoke-OVGDRequest -Resource $Resource

    }
    
    end {
    }
}

function Get-OVGDGroup {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [alias("Group")]
        $Entity,
        $Count = 25
    )
    
    begin {
        $ResourceType = "groups"
    }
    
    process {
        $Resource = BuildResourcePath -Resource $ResourceType -Entity $Entity
        Invoke-OVGDRequest -Resource $Resource

    }
    
    end {
    }
}

function Add-OVGDGroup {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [parameter(Mandatory=$true)]
        $GroupName,        
        $Parent
    )
    
    begin {
        $ResourceType = "groups"
        $Method = "POST"
    }
    
    process {

        $body = @{
            "name" = $GroupName
            "parentUri" = $Parent
        } | ConvertTo-Json

        Invoke-OVGDRequest -Resource $ResourceType -Method $Method -Body $body

    }
    
    end {
    }
}

# function Set-OVGDGroup {
#     [CmdletBinding()]
#     param (
#         $Server = $Global:OVGDPSServer,
#         [parameter(Mandatory=$true)]
#         $Group,
#         $NewName,
#         $NewParent
#     )
    
#     begin {
#         $ResourceType = "groups"
#     }
    
#     process {
#         $Resource = BuildResourcePath -Resource $ResourceType -Entity $Group
#         $ExistGroup = Get-OVGDGroup -Server $Server -Group $Group
#     }
    
#     end {
#     }
# }

function Get-OVGDGroupMember {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [Parameter(Mandatory=$true)]
        [alias("Group")]
        $Entity#,
        #$Count = 25
    )
    
    begin {
        $ResourceType = "groups"
    }
    
    process {
        $Resource = BuildResourcePath -Resource $ResourceType -Entity $Entity
        
        Invoke-OVGDRequest -Resource ($Resource + "/members")

    }
    
    end {
    }
}

# function Add-OVGDGroupMember {
#     [CmdletBinding()]
#     param (
#         $Server = $Global:OVGDPSServer,
#         [parameter(Mandatory=$true)]
#         $Group,
#         $Member
#     )
    
#     begin {
#     }
    
#     process {
#     }
    
#     end {
#     }
# }

# function Remove-OVGDGroupMember {
#     [CmdletBinding()]
#     param (
#         $Server = $Global:OVGDPSServer,
#         [parameter(Mandatory=$true)]
#         $Group,
#         $Member
#     )
    
#     begin {
#     }
    
#     process {
#     }
    
#     end {
#     }
# }

function Remove-OVGDGroup {
    [CmdletBinding()]
    param (
        $Server = $Global:OVGDPSServer,
        [parameter(Mandatory=$true)]
        $Group
    )
    
    begin {
        $ResourceType = "groups"
    }
    
    process {
        $Resource = BuildResourcePath -Resource $ResourceType -Entity $Group
        Write-Verbose $resource
        Invoke-OVGDRequest -Method DELETE -Resource $resource -Verbose
    }
    
    end {
    }
}

function Get-OVGDServerHardware {
    [CmdletBinding()]
    param (
        $Server,
        [alias("ServerHardware")]
        $Entity,
        $Count = 25
    )
    
    begin {
        $ResourceType = "server-hardware"
    }
    
    process {
        $Resource = BuildResourcePath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        Invoke-OVGDRequest -Resource $Resource -Query $Query
    }
    
    end {
    }
}

function Get-OVGDServerProfile {
    [CmdletBinding()]
    param (
        $Server,
        [alias("ServerProfile")]
        $Entity,
        $Count = 25
    )
    
    begin {
        $ResourceType = "server-profiles"
    }
    
    process {
        $Resource = BuildResourcePath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        Invoke-OVGDRequest -Resource $Resource -Query $Query
    }
    
    end {
    }
}

function Get-OVGDServerProfileTemplate {
    [CmdletBinding()]
    param (
        $Server,
        [alias("ServerProfileTemplate")]
        $Entity,
        $Count = 25
    )
    
    begin {
        $ResourceType = "server-profile-templates"
    }
    
    process {
        $Resource = BuildResourcePath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        Invoke-OVGDRequest -Resource $Resource -Query $Query -Verbose
    }
    
    end {
    }
}

function Get-OVGDStorageSystem {
    [CmdletBinding()]
    param (
        $Server,
        [alias("StorageSystem")]
        $Entity,
        $Count = 25
    )
    
    begin {
        $ResourceType = "storage-systems"
    }
    
    process {
        $Resource = BuildResourcePath -Resource $ResourceType -Entity $Entity
        $Query = "count=$Count"
        Invoke-OVGDRequest -Resource $Resource -Query $Query
    }
    
    end {
    }
}
