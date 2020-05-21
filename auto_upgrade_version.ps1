[string]$selected = Select-String '.\PSGitUtils\PSGitUtils.psd1' -Pattern 'ModuleVersion'
[string]$version = $selected.Split('''')[1]
[int[]]$numbers = $version.Split('.')

Write-Host "Current version is $version." -ForegroundColor Cyan

$options = [System.Management.Automation.Host.ChoiceDescription[]](
  (New-Object System.Management.Automation.Host.ChoiceDescription "&major", "MAJOR version when you make incompatible API changes."),
  (New-Object System.Management.Automation.Host.ChoiceDescription "m&inor", "MINOR version when you add functionality in a backwards compatible manner."),
  (New-Object System.Management.Automation.Host.ChoiceDescription "&patch", "PATCH version when you make backwards compatible bug fixes.")
)

$chooseIndex = $Host.UI.PromptForChoice("Set new version", "Choose a label for generating new version.", $options, 2)
$numbers[$chooseIndex] = $numbers[$chooseIndex] + 1

$newVersion = $numbers -join '.'

(Get-Content '.\PSGitUtils\PSGitUtils.psd1').Replace($version, $newVersion) | Set-Content '.\PSGitUtils\PSGitUtils.psd1'

Write-Host "New version is $newVersion." -ForegroundColor Green
Write-Host "Update version successfully!" -ForegroundColor Green
