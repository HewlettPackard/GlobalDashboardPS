function Set-InsecureSSL {
    [cmdletbinding(SupportsShouldProcess)]
    param()

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

    if($PSCmdlet.ShouldProcess("ShouldProcess?")){

    }
    else {
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
        $AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
        [System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols
    }

}