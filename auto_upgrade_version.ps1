[string]$line = Get-Content '.\PSGitUtils\PSGitUtils.psd1' | Select-String 'ModuleVersion'

[string]$version = $line.Split('''')[1]

[int[]]$numbers = $version.Split('.')

$options = [System.Management.Automation.Host.ChoiceDescription[]](
  (New-Object System.Management.Automation.Host.ChoiceDescription "&major", "MAJOR version when you make incompatible API changes."),
  (New-Object System.Management.Automation.Host.ChoiceDescription "m&inor", "MINOR version when you add functionality in a backwards compatible manner."),
  (New-Object System.Management.Automation.Host.ChoiceDescription "&patch", "PATCH version when you make backwards compatible bug fixes.")
)

$chooseIndex = $Host.UI.PromptForChoice("Set new version", "Choose a label for generating new version.", $options, 2)

$numbers[$chooseIndex] = $numbers[$chooseIndex] + 1

$newVersion = $numbers -join '.'

$newLine = $line.Replace($version, $newVersion)
