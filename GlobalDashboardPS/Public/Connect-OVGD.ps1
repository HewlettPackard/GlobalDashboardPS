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
            Version : 0.1.1
            Revised : 17/04-2019
            Changelog:
            0.1.1 -- Added help text
        .LINK
            https://github.com/rumart/GlobalDashboardPS
        .LINK
            https://developer.hpe.com/blog/accessing-the-hpe-oneview-global-dashboard-api
        .PARAMETER Server
            The Global Dashboard to connect to
        .PARAMETER UserName
            The Username of a user with access to the Global Dashboard instance
        .PARAMETER Password
            The Password of the specified user
        .PARAMETER Directory
            The Directory of the specified user, defaults to local
        .EXAMPLE
            PS C:\> Connect-OVGD -Server 1.1.1.1 -UserName user01

            Connects to the specified Global Dashboard instance with the specified user. The function will prompt for the password of the user
    #>
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