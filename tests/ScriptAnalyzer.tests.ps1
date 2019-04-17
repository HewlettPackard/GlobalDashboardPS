$projectRoot = Resolve-Path "$PSScriptRoot\.."
$scripts = Get-ChildItem $projectRoot -Include *.ps1,*.psm1,*.psd1 -Recurse
Describe 'Testing against PSSA rules' {

    Context "Checking all files against Powershell ScriptAnalyzer"{
        It "Checking files exists" {
            $script.count | Should Not Be 0
        }
        It "Checking if Invoke-ScriptAnalyzer exists" {
            { Get-Command Invoke-ScriptAnalyzer -ErrorAction Stop } | Should Not Throw
        }
    }

    $scriptAnalyzerRules = Get-ScriptAnalyzerRule | Where-Object {$_.RuleName -ne "PSAvoidGlobalVars" -and $_.RuleName -ne "PSAvoidDefaultValueSwitchParameter"}

    foreach($script in $scripts){
        Context "PSSA Standard Rules - $($script.name)" {
            forEach ($rule in $scriptAnalyzerRules) {
                It "$script Should pass $($rule.RuleName)" {
                    (Invoke-ScriptAnalyzer -Path $script -IncludeRule $rule).Count | Should Be 0
                }
            }
        }
    }
}