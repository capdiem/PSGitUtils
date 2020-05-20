$dicts = @(
  @{ code = ':sparkles:'; emoji = '✨'; type = 'feat:' }
  @{ code = ':bug:'; emoji = '🐛'; type = 'fix:' }
  @{ code = ':boom:'; emoji = '💥'; type = 'fix:' }
  @{ code = ':ok_hand:'; emoji = '👌'; type = 'fix:' }
  @{ code = ':lipstick:'; emoji = '💄'; type = 'style:' }
  @{ code = ':speech_balloon:'; emoji = '💬'; type = 'style:' }
  @{ code = ':art:'; emoji = '🎨'; type = 'style:' }
  @{ code = ':white_check_mark:'; emoji = '✅'; type = 'test:' }
  @{ code = ':wrench:'; emoji = '🔧'; type = 'chore:' }
  @{ code = ':arrow_up:'; emoji = '⬆'; type = 'chore:' }
  @{ code = ':arrow_down:'; emoji = '⬇'; type = 'chore:' }
  @{ code = ':heavy_plus_sign:'; emoji = '➕'; type = 'chore:' }
  @{ code = ':heavy_minus_sign:'; emoji = '➖'; type = 'chore:' }
  @{ code = ':see_no_evil:'; emoji = '🙈'; type = 'chore:' }
  @{ code = ':pencil:'; emoji = '📝'; type = 'docs:' }
  @{ code = ':zap:'; emoji = '⚡️'; type = 'perf:' }
  @{ code = ':fire:'; emoji = '🔥'; type = 'remove:' }
  @{ code = ':recycle:'; emoji = '♻️'; type = 'refactor:' }
  @{ code = ':truck:'; emoji = '🚚'; type = 'refactor:' }
  @{ code = ':tada:'; emoji = '🎉'; type = 'init:' }
)

$GitUtilsConfig = @{
  Emoji = $true;
  Type  = $true;
}

<#
.EXAMPLE
Invoke-GitCommit "Initial commit"
#>
function Invoke-GitCommit {
  param (
    [Parameter(Mandatory = $true, HelpMessage = "The commit message for git.")]
    [Alias("m")]
    [string]$message
  )

  try {
    $null = Get-Command git -ErrorAction stop
  }
  catch {
    Write-Error "Could not find Git, please install Git first."
    exit
  }

  [string]$title = "Git Commit"
  [string]$promptMessage = "Commit standard message with emoji by Git"

  $feat = New-Object System.Management.Automation.Host.ChoiceDescription "&new feat✨", "Introducing new features."
  $fix = New-Object System.Management.Automation.Host.ChoiceDescription "&fix🐛", "Fixing a bug."
  $breakingChanges = New-Object System.Management.Automation.Host.ChoiceDescription "&break changes💥", "Introducing breaking changes."
  $ok = New-Object System.Management.Automation.Host.ChoiceDescription "&ok👌", "Updating code due to code review changes."
  $style = New-Object System.Management.Automation.Host.ChoiceDescription "&style💄", "Updating the UI and style files."
  $typo = New-Object System.Management.Automation.Host.ChoiceDescription "t&ypo💬", "Updating text and literals."
  $art = New-Object System.Management.Automation.Host.ChoiceDescription "&art🎨", "improving structure / format of the code."
  $test = New-Object System.Management.Automation.Host.ChoiceDescription "&test✅", "Updating tests."
  $chore = New-Object System.Management.Automation.Host.ChoiceDescription "&chore🔧", "Changing configuration files."
  $upgrade = New-Object System.Management.Automation.Host.ChoiceDescription "&upgrade⬆", "Upgrading dependencies."
  $downgrade = New-Object System.Management.Automation.Host.ChoiceDescription "do&wngrade⬇", "Downgrading dependencies."
  $addDependencies = New-Object System.Management.Automation.Host.ChoiceDescription "&+dependency➕", "Adding a dependency."
  $removeDependencies = New-Object System.Management.Automation.Host.ChoiceDescription "&-dependency➖", "Removing a dependency."
  $gitignore = New-Object System.Management.Automation.Host.ChoiceDescription "&gitignore🙈", "Adding or updating a .gitignore file"
  $docs = New-Object System.Management.Automation.Host.ChoiceDescription "&docs📝", "Writing docs."
  $perf = New-Object System.Management.Automation.Host.ChoiceDescription "&perf⚡️", "Improving performance."
  $remove = New-Object System.Management.Automation.Host.ChoiceDescription "remo&ve🔥", "Removing code or files."
  $refactor = New-Object System.Management.Automation.Host.ChoiceDescription "&refactor♻️", "Refactoring code."
  $move = New-Object System.Management.Automation.Host.ChoiceDescription "&move or rename🚚", "Moving or renaming files."
  $init = New-Object System.Management.Automation.Host.ChoiceDescription "&init🎉", "Initial commit."

  $options = [System.Management.Automation.Host.ChoiceDescription[]](
    $feat,
    $fix,
    $breakingChanges,
    $ok,
    $style,
    $typo,
    $art,
    $test,
    $chore,
    $upgrade,
    $downgrade,
    $addDependencies,
    $removeDependencies,
    $gitignore,
    $docs,
    $perf,
    $remove,
    $refactor,
    $move,
    $init
  )

  $chooseIndex = $Host.UI.PromptForChoice($title, $promptMessage, $options, $options.Count - 1)

  if ($chooseIndex -le $dicts.Length) {
    [string]$newMessage

    if ($GitUtilsConfig.Emoji) {
      $newMessage = $dicts[$chooseIndex].code + ' '
    }

    if ($GitUtilsConfig.Type) {
      $newMessage = $newMessage + $dicts[$chooseIndex].type + ' '
    }

    $newMessage = $newMessage + $message

    git.ps1 commit -m $newMessage
  }
  else {
    git.ps1 commit -m $message
  }

}

<#
.EXAMPLE
Invoke-Emojify ":boom:"
#>
function Invoke-Emojify {
  [CmdletBinding()]
  param (
    [Parameter(
      Position = 0,
      Mandatory = $False,
      ValueFromPipeline = $True,
      ValueFromPipelineByPropertyName = $True
    )]
    [string[]]
    $Messages
  )

  process {
    foreach ($message in $Messages) {
      if ($message -match '\:[a-z][a-z]*\:') {
        $matched = [regex]::match($message, '\:[a-z][a-z]*\:').Value

        foreach ($table in $dicts) {
          if ($table.code -eq $matched) {
            $message = $message.Replace($matched, $table.emoji)
            break
          }
        }
      }

      $message
    }
  }
}

<#
.EXAMPLE
Invoke-GitHistory
Invoke-GitHistory 20
#>
function Invoke-GitHistory {
  param (
    [Parameter(HelpMessage = "The number of logs need to show.")]
    [Alias("c")]
    [int]$count = 10
  )

  $arg = "-" + $count.ToString()

  [string[]]$logs = git.ps1 log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit $arg

  Invoke-Emojify($logs)
}

Remove-Item 'Alias:\gcm' -Force
Set-Alias gcm Invoke-GitCommit
Set-Alias gh Invoke-GitHistory
Set-Alias emojify Invoke-Emojify

Export-ModuleMember -Function Invoke-GitCommit, Invoke-GitHistory, Invoke-Emojify
Export-ModuleMember -Alias  gcm, gh, emojify
Export-ModuleMember -Variable GitUtilsConfig
