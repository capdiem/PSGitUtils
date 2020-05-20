$sparkles = [char]::ConvertFromUtf32('0x2728');
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
$fire = [char]::ConvertFromUtf32('0x1F525');
$recycle = [char]::ConvertFromUtf32('0x267B');
$truck = [char]::ConvertFromUtf32('0x1F69A');
$tada = [char]::ConvertFromUtf32('0x1F389');

$dicts = @(
  @{ code = ':sparkles:'; emoji = $sparkles; type = 'feat:' },
  @{ code = ':bug:'; emoji = $bug; type = 'fix:' },
  @{ code = ':boom:'; emoji = $boom; type = 'fix:' },
  @{ code = ':ok_hand:'; emoji = $ok_hand; type = 'fix:' },
  @{ code = ':lipstick:'; emoji = $lipstick; type = 'style:' },
  @{ code = ':speech_balloon:'; emoji = $speech_balloon; type = 'style:' },
  @{ code = ':art:'; emoji = $art; type = 'style:' },
  @{ code = ':white_check_mark:'; emoji = $white_check_mark; type = 'test:' },
  @{ code = ':wrench:'; emoji = $wrench; type = 'chore:' },
  @{ code = ':arrow_up:'; emoji = $arrow_up; type = 'chore:' },
  @{ code = ':arrow_down:'; emoji = $arrow_down; type = 'chore:' },
  @{ code = ':heavy_plus_sign:'; emoji = $heavy_plus_sign; type = 'chore:' },
  @{ code = ':heavy_minus_sign:'; emoji = $heavy_minus_sign; type = 'chore:' },
  @{ code = ':see_no_evil:'; emoji = $see_no_evil; type = 'chore:' },
  @{ code = ':pencil:'; emoji = $pencil; type = 'docs:' },
  @{ code = ':zap:'; emoji = $zap; type = 'perf:' },
  @{ code = ':fire:'; emoji = $fire; type = 'remove:' },
  @{ code = ':recycle:'; emoji = $recycle; type = 'refactor:' },
  @{ code = ':truck:'; emoji = $truck; type = 'refactor:' },
  @{ code = ':tada:'; emoji = $tada; type = 'init:' }
)

$GitUtilsConfig = @{
  Emoji = $true;
  Type  = $true;
}

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

  $feat = New-Object System.Management.Automation.Host.ChoiceDescription "&new feat$sparkles", 'Introducing new features.'
  $fix = New-Object System.Management.Automation.Host.ChoiceDescription "&fix bug$bug", 'Fixing a bug.'
  $breakingChanges = New-Object System.Management.Automation.Host.ChoiceDescription "&break changes$boom", 'Introducing breaking changes.'
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
  $remove = New-Object System.Management.Automation.Host.ChoiceDescription "remo&ve$fire", 'Removing code or files.'
  $refactor = New-Object System.Management.Automation.Host.ChoiceDescription "&refactor$recycle", 'Refactoring code.'
  $move = New-Object System.Management.Automation.Host.ChoiceDescription "&move or rename$truck", 'Moving or renaming files.'
  $init = New-Object System.Management.Automation.Host.ChoiceDescription "&init$tada", 'Initial commit.'

  $options = [System.Management.Automation.Host.ChoiceDescription[]](
    $feat,
    $fix,
    $breakingChanges,
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
    $init
  )

  $chooseIndex = $Host.UI.PromptForChoice($title, $promptMessage, $options, 1)

  if ($chooseIndex -le $dicts.Length) {
    [string]$newMessage

    if ($GitUtilsConfig.Emoji) {
      $newMessage = $dicts[$chooseIndex].code + ' '
    }

    if ($GitUtilsConfig.Type) {
      $newMessage = $newMessage + $dicts[$chooseIndex].type + ' '
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
    $Messages
  )

  process {
    foreach ($message in $Messages) {
      if ([string]::IsNullOrEmpty($message)) {
        continue;
      }

      $regex = '\:[a-z]\w*(\d|[a-z])*\:'
      if ($message -match $regex) {
        $matched = [regex]::match($message, $regex).Value

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

Set-Alias ggc Invoke-GitCommit
Set-Alias ggh Invoke-GitHistory
Set-Alias emojify Invoke-Emojify

Export-ModuleMember -Function Invoke-GitCommit, Invoke-GitHistory, Invoke-Emojify
Export-ModuleMember -Alias  ggc, ggh, emojify
Export-ModuleMember -Variable GitUtilsConfig
