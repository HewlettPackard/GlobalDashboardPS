$PublicFunctions  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$PrivateFunctions = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($file in @($PublicFunctions + $PrivateFunctions))
{
    Try
    {
        . $file.FullName
    }
    Catch
    {
        Write-Error -Message "Failed to import $($file.fullname): $_"
    }
}

Export-ModuleMember -Function $PublicFunctions.Basename