[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$sparkles = [char]::ConvertFromUtf32('0x2728');
$new = [char]::ConvertFromUtf32('0x1F195');
$bug = [char]::ConvertFromUtf32('0x1F41B');
$boom = [char]::ConvertFromUtf32('0x1F4A5');
$ok_hand = [char]::ConvertFromUtf32('0x1F44C');
$lipstick = [char]::ConvertFromUtf32('0x1F484');
$speech_balloon = [char]::ConvertFromUtf32('0x1F4AC');
$art = [char]::ConvertFromUtf32('0x1F3A8');
$white_check_mark = [char]::ConvertFromUtf32('0x2705');
$wrench = [char]::ConvertFromUtf32('0x1F527');
$arrow_up = [char]::ConvertFromUtf32('0x2B06');
$arrow_down = [char]::ConvertFromUtf32('0x2B07');
$heavy_plus_sign = [char]::ConvertFromUtf32('0x2795');
$heavy_minus_sign = [char]::ConvertFromUtf32('0x2796');
$see_no_evil = [char]::ConvertFromUtf32('0x1F648');
$pencil = [char]::ConvertFromUtf32('0x1F4DD');
$zap = [char]::ConvertFromUtf32('0x26A1');
$wastebasket = [char]::ConvertFromUtf32('0x1F5D1');
$fire = [char]::ConvertFromUtf32('0x1F525');
$recycle = [char]::ConvertFromUtf32('0x267B');
$truck = [char]::ConvertFromUtf32('0x1F69A');
$tada = [char]::ConvertFromUtf32('0x1F389');

$dicts = @(
  @{ index = -99; code = ':sparkles:'; emoji = $sparkles; type = 'feat:' },
  @{ index = 0; code = ':new:'; emoji = $new; type = 'feat:' },
  @{ index = 1; code = ':boom:'; emoji = $boom; type = 'feat:' },
  @{ index = 2; code = ':bug:'; emoji = $bug; type = 'fix:' },
  @{ index = 3; code = ':ok_hand:'; emoji = $ok_hand; type = 'fix:' },
  @{ index = 4; code = ':lipstick:'; emoji = $lipstick; type = 'style:' },
  @{ index = 5; code = ':speech_balloon:'; emoji = $speech_balloon; type = 'style:' },
  @{ index = 6; code = ':art:'; emoji = $art; type = 'style:' },
  @{ index = 7; code = ':white_check_mark:'; emoji = $white_check_mark; type = 'test:' },
  @{ index = 8; code = ':wrench:'; emoji = $wrench; type = 'chore:' },
  @{ index = 9; code = ':arrow_up:'; emoji = $arrow_up; type = 'chore:' },
  @{ index = 10; code = ':arrow_down:'; emoji = $arrow_down; type = 'chore:' },
  @{ index = 11; code = ':heavy_plus_sign:'; emoji = $heavy_plus_sign; type = 'chore:' },
  @{ index = 12; code = ':heavy_minus_sign:'; emoji = $heavy_minus_sign; type = 'chore:' },
  @{ index = 13; code = ':see_no_evil:'; emoji = $see_no_evil; type = 'chore:' },
  @{ index = 14; code = ':pencil:'; emoji = $pencil; type = 'docs:' },
  @{ index = 15; code = ':zap:'; emoji = $zap; type = 'perf:' },
  @{ index = 16; code = ':wastebasket:'; emoji = $wastebasket; type = 'remove:' },
  @{ index = -16; code = ':fire:'; emoji = $fire; type = 'remove:' },
  @{ index = 17; code = ':recycle:'; emoji = $recycle; type = 'refactor:' },
  @{ index = 18; code = ':truck:'; emoji = $truck; type = 'refactor:' },
  @{ index = 19; code = ':tada:'; emoji = $tada; type = 'init:' }
)

$GitUtilsConfig = @{
  Emoji = $true;
  Type  = $true;
}

function Invoke-GitAdd {
  if ($args.Count -eq 0) {
    git add .
  }
  else {
    git add $args
  }
}

## git branch [-a|$args]
function Invoke-GitBranch {
  if ($args.Count -eq 0) {
    git branch -av
  }
  else {
    git branch $args
  }
}

## git status
function Invoke-GitStatus { git status $args }

## git checkout [$args]
function Invoke-GitCheckout { git checkout $args }

## git pull
function Invoke-GitPull { git pull $args }

## git push
function Invoke-GitPush { git push $args }

## git reset
function Invoke-GitReset { git reset $args }

## git diff
function Invoke-GitDiff { git diff $args }

<#
.EXAMPLE
Invoke-GitCommit 'Initial commit'
#>
function Invoke-GitCommit {
  param (
    [Parameter(Mandatory = $true, HelpMessage = 'The commit message for git.')]
    [Alias('m')]
    [string]$message
  )

  try {
    $null = Get-Command git -ErrorAction stop
  }
  catch {
    Write-Error 'Could not find Git, please install Git first.'
    exit
  }

  [string]$title = 'Git Commit'
  [string]$promptMessage = 'Commit standard message with emoji by Git'

  $feat = New-Object System.Management.Automation.Host.ChoiceDescription "&new feat$new", 'Introducing new features.'
  $breakingChanges = New-Object System.Management.Automation.Host.ChoiceDescription "&break changes$boom", 'Introducing breaking changes.'
  $fix = New-Object System.Management.Automation.Host.ChoiceDescription "&fix bug$bug", 'Fixing a bug.'
  $ok = New-Object System.Management.Automation.Host.ChoiceDescription "&ok$ok_hand", 'Updating code due to code review changes.'
  $style = New-Object System.Management.Automation.Host.ChoiceDescription "&style$lipstick", 'Updating the UI and style files.'
  $typo = New-Object System.Management.Automation.Host.ChoiceDescription "t&ypo$speech_balloon", 'Updating text and literals.'
  $artc = New-Object System.Management.Automation.Host.ChoiceDescription "form&at code$art", 'improving structure / format of the code.'
  $test = New-Object System.Management.Automation.Host.ChoiceDescription "&test$white_check_mark", 'Updating tests.'
  $chore = New-Object System.Management.Automation.Host.ChoiceDescription "&chore$wrench", 'Changing configuration files.'
  $upgrade = New-Object System.Management.Automation.Host.ChoiceDescription "&upgrade$arrow_up", 'Upgrading dependencies.'
  $downgrade = New-Object System.Management.Automation.Host.ChoiceDescription "do&wngrade$arrow_down", 'Downgrading dependencies.'
  $addDependencies = New-Object System.Management.Automation.Host.ChoiceDescription "&+dependency$heavy_plus_sign", 'Adding a dependency.'
  $removeDependencies = New-Object System.Management.Automation.Host.ChoiceDescription "&-dependency$heavy_minus_sign", 'Removing a dependency.'
  $gitignore = New-Object System.Management.Automation.Host.ChoiceDescription "&gitignore$see_no_evil", 'Adding or updating a .gitignore file'
  $docs = New-Object System.Management.Automation.Host.ChoiceDescription "&docs$pencil", 'Writing docs.'
  $perf = New-Object System.Management.Automation.Host.ChoiceDescription "&perf$zap", 'Improving performance.'
  $remove = New-Object System.Management.Automation.Host.ChoiceDescription "remo&ve$wastebasket", 'Removing code or files.'
  $refactor = New-Object System.Management.Automation.Host.ChoiceDescription "&refactor$recycle", 'Refactoring code.'
  $move = New-Object System.Management.Automation.Host.ChoiceDescription "&move or rename$truck", 'Moving or renaming files.'
  $init = New-Object System.Management.Automation.Host.ChoiceDescription "&init$tada", 'Initial commit.'
  $plain = New-Object System.Management.Automation.Host.ChoiceDescription "p&lain", 'No emoji, no type.'

  $options = [System.Management.Automation.Host.ChoiceDescription[]](
    $feat,
    $breakingChanges,
    $fix,
    $ok,
    $style,
    $typo,
    $artc,
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
    $init,
    $plain
  )

  $chooseIndex = $Host.UI.PromptForChoice($title, $promptMessage, $options, 2)

  if ($chooseIndex -lt $dicts.Length - 1) {
    [string]$newMessage

    $dict = $dicts.Where( { $_.index -eq $chooseIndex }, 'First')

    if ($GitUtilsConfig.Emoji) {
      $newMessage = $dict.code + ' '
    }

    if ($GitUtilsConfig.Type) {
      $newMessage = $newMessage + $dict.type + ' '
    }

    $newMessage = $newMessage + $message

    git commit -m $newMessage
  }
  else {
    git commit -m $message
  }

}

<#
.EXAMPLE
Invoke-Emojify ':boom:'
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
    $messages
  )

  process {
    foreach ($message in $messages) {
      if ([string]::IsNullOrEmpty($message)) {
        continue;
      }

      $regex = '\:[a-z]\w*(\d|[a-z])*\:'

      $matches = ($message | Select-String $regex -AllMatches).Matches.Value

      foreach ($item in $matches) {
        $dict = $dicts.Where( { $_.code -eq $item }, 'First')
        $message = $message -replace ($item, $dict.emoji)
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
    [Parameter(HelpMessage = 'The number of logs need to show.')]
    [Alias('c')]
    [int]$count = 10
  )

  try {
    $null = Get-Command git -ErrorAction stop
  }
  catch {
    Write-Error 'Could not find Git, please install Git first.'
    exit
  }

  $arg = '-' + $count.ToString()

  [string[]]$logs = git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit $arg

  Invoke-Emojify($logs)
}

Set-Alias gga Invoke-GitAdd
Set-Alias ggc Invoke-GitCommit
Set-Alias ggb Invoke-GitBranch
Set-Alias ggs Invoke-GitStatus
Set-Alias ggck Invoke-GitCheckout
Set-Alias ggpl Invoke-GitPull
Set-Alias ggps Invoke-GitPush
Set-Alias ggrst Invoke-GitReset
Set-Alias ggd Invoke-GitDiff
Set-Alias ggl Invoke-GitHistory
Set-Alias emojify Invoke-Emojify

Export-ModuleMember -Function Invoke-GitCommit, Invoke-GitHistory, Invoke-Emojify, Invoke-GitAdd, Invoke-GitBranch, Invoke-GitStatus, Invoke-GitCheckout, Invoke-GitPull, Invoke-GitPush, Invoke-GitReset, Invoke-GitDiff
Export-ModuleMember -Alias  ggc, ggl, emojify, gga, ggb, ggs, ggck, ggpl, ggps, ggrst, ggd
Export-ModuleMember -Variable GitUtilsConfig
