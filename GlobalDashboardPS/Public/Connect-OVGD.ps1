function Connect-OVGD {
    <#
        .SYNOPSIS
            Create a connection to a Global Dashboard instance
        .DESCRIPTION
            This function will create a connection to the specified Global Dashboard instance
        .NOTES
            Info
            Author : Rudi Martinsen / Intility AS
            Date : 25/03-2019
            Version : 0.2.0
            Revised : 24/04-2019
            Changelog:
            0.2.0 -- Added PS Credential support
            0.1.1 -- Added help text
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .LINK
            https://rudimartinsen.com/2019/04/23/hpe-oneview-global-dashboard-powershell-module/
        .PARAMETER Server
            The Global Dashboard to connect to
        .PARAMETER UserName
            The Username of a user with access to the Global Dashboard instance
        .PARAMETER Password
            The Password of the specified user
        .PARAMETER Directory
            The Directory of the specified user, defaults to local
        .PARAMETER Credential
            A PSCredential to be sent to the login function
        .EXAMPLE
            PS C:\> Connect-OVGD -Server 1.1.1.1 -UserName user01

            Connects to the specified Global Dashboard instance with the specified user. The function will prompt for the password of the user
        .EXAMPLE
            PS C:\> Connect-OVGD -Server 1.1.1.1 -Credential (get-credential)

            Connects to the specified Global Dashboard instance with a PS Credential
    #>
    [cmdletbinding(DefaultParameterSetName="Username")]
    param (
        [Parameter(ParameterSetName="PSCred",Position=0)]    
        [Parameter(ParameterSetName="Username",Position=0)]
        [Parameter(Mandatory=$true)]
        $Server,
        [Parameter(ParameterSetName="Username")]
        $UserName,
        [Parameter(ParameterSetName="Username")]
        [SecureString]
        $Password,
        [Parameter(ParameterSetName="PSCred")]    
        [Parameter(ParameterSetName="Username")]
        $Directory,
        [Parameter(ParameterSetName="PSCred")]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    BEGIN {
        if($IgnoreSSL){
            Set-InsecureSSL
        }
        if($Credential){
            $UserName = $Credential.GetNetworkCredential().UserName
            $Password = $Credential.GetNetworkCredential().SecurePassword
            
            if(!$Directory){
                $Directory = $Credential.GetNetworkCredential().Domain
            }
        }
        else{
            if(!$UserName){
                $UserName = (Read-Host -Prompt "Type your username")    
            }
            if(!$Password){
               $Password = (Read-Host -Prompt "Type your password" -AsSecureString)
            }
            if(!$Directory){
                $Directory = (Read-Host -Prompt "Type your directory (default: local)")
                if(!$Directory){
                    $Directory = "local"
                }
            }
        }
    }
    PROCESS {
        Write-Verbose "About to login user $UserName"
        New-OVGDSessionKey -Server $Server -Username $Username -Password $Password -LoginDomain $Directory
    }
    END {

    }

}