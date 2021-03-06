[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$new = [char]::ConvertFromUtf32('0x1F195');
$bug = [char]::ConvertFromUtf32('0x1F41B');
$boom = [char]::ConvertFromUtf32('0x1F4A5');
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
$pencil2 = [char]::ConvertFromUtf32('0x0270f');
$memo = [char]::ConvertFromUtf32('0x1f4dd');
$bulb = [char]::ConvertFromUtf32('0x1f4a1');
$zap = [char]::ConvertFromUtf32('0x26A1');
$fire = [char]::ConvertFromUtf32('0x1F525');
$recycle = [char]::ConvertFromUtf32('0x267B');
$truck = [char]::ConvertFromUtf32('0x1F69A');
$tada = [char]::ConvertFromUtf32('0x1F389');
$hammer = [char]::ConvertFromUtf32('0x1f528');
$construction = [char]::ConvertFromUtf32('0x1f6a7');
$children_crossing = [char]::ConvertFromUtf32('0x1f6b8');

$dicts = @(
  @{ code = ':sparkles:'; emoji = $sparkles; },
  @{ code = ':new:'; emoji = $new; },
  @{ code = ':boom:'; emoji = $boom; },
  @{ code = ':bug:'; emoji = $bug; },
  @{ code = ':speech_balloon:'; emoji = $speech_balloon; },
  @{ code = ':ok_hand:'; emoji = $ok_hand; },
  @{ code = ':lipstick:'; emoji = $lipstick; },
  @{ code = ':art:'; emoji = $art; },
  @{ code = ':white_check_mark:'; emoji = $white_check_mark; },
  @{ code = ':wrench:'; emoji = $wrench; },
  @{ code = ':arrow_up:'; emoji = $arrow_up; },
  @{ code = ':arrow_down:'; emoji = $arrow_down; },
  @{ code = ':heavy_plus_sign:'; emoji = $heavy_plus_sign; },
  @{ code = ':heavy_minus_sign:'; emoji = $heavy_minus_sign; },
  @{ code = ':see_no_evil:'; emoji = $see_no_evil; },
  @{ code = ':pencil2:'; emoji = $pencil; },
  @{ code = ':memo:'; emoji = $memo; },
  @{ code = ':bulb:'; emoji = $bulb; },
  @{ code = ':zap:'; emoji = $zap; },
  @{ code = ':wastebasket:'; emoji = $wastebasket; },
  @{ code = ':fire:'; emoji = $fire; },
  @{ code = ':recycle:'; emoji = $recycle; },
  @{ code = ':truck:'; emoji = $truck; },
  @{ code = ':tada:'; emoji = $tada; },
  @{ code = ':hammer:'; emoji = $hammer; },
  @{ code = ':construction:'; emoji = $construction; },
  @{ code = ':children_crossing:'; emoji = $children_crossing; }
)

$typeOptions = [System.Management.Automation.Host.ChoiceDescription[]] (
  (New-Object System.Management.Automation.Host.ChoiceDescription "&feat", "New features."),
  (New-Object System.Management.Automation.Host.ChoiceDescription "fi&x", "Bug fix."),
  (New-Object System.Management.Automation.Host.ChoiceDescription "&docs", "Changes to documentation."),
  (New-Object System.Management.Automation.Host.ChoiceDescription "&style", "Formatting, missing semi clons, etc. No production code change."),
  (New-Object System.Management.Automation.Host.ChoiceDescription "&refactor", "Refactoring production code."),
  (New-Object System.Management.Automation.Host.ChoiceDescription "&test", "Adding missing tests, refactoring tests; no production code change."),
  (New-Object System.Management.Automation.Host.ChoiceDescription "&chore", "Updating grunt tasks etc; no production code change."),
  (New-Object System.Management.Automation.Host.ChoiceDescription "&emoji", "Other emojis but no type is required(e.g.: working,)."),
  (New-Object System.Management.Automation.Host.ChoiceDescription "&notype", "No type.")
)

$featOptions = [System.Management.Automation.Host.ChoiceDescription[]] @(
  "$new(New &feat)",
  "$boom(&Break changes)"
  "$tada(Beg&in a project)",
  "(&No emoji)"
)

$fixOptions = [System.Management.Automation.Host.ChoiceDescription[]](
  "$bug(&Fix bugs)",
  "$speech_balloon(Add or update &text and literals)",
  "$pencil2(Fix t&ypos)",
  "(&No emoji)"
)

$styleOptions = [System.Management.Automation.Host.ChoiceDescription[]](
  "$lipstick(Add or update the UI and &style files)",
  "$art(Improve structure / &format of the code)",
  "(&No emoji)"
)

$testOptions = [System.Management.Automation.Host.ChoiceDescription[]](
  "$white_check_mark(Add or update &tests)",
  "(&No emoji)"
)

$choreOptions = [System.Management.Automation.Host.ChoiceDescription[]](
  "$wrench(Add or update &configuration files)",
  "$arrow_up(&Upgrade dependencies.)",
  "$arrow_down(&Downgrade dependencies)",
  "$heavy_plus_sign(&Add a dependency)",
  "$heavy_minus_sign(&Remove a dependency)",
  "$see_no_evil(Add or update a .&gitignore file)",
  "$hammer(Add or update development scripts)",
  "(&No emoji)"
)

$docsOptions = [System.Management.Automation.Host.ChoiceDescription[]](
  "$memo(Add or update &documentation.)",
  "$bulb(Add or update &comments in source code)",
  "(&No emoji)"
)

$refactorOptions = [System.Management.Automation.Host.ChoiceDescription[]](
  "$recycle(&Refactor code)",
  "$zap(Improve &performance)",
  "$truck(&Move or rename resources(e.g.: files, paths, routes))",
  "$fire(Remove code or &files)",
  "(&No emoji)"
)

$emojiOptions = [System.Management.Automation.Host.ChoiceDescription[]](
  "$construction(Work in &progress)",
  "$children_crossing(Improve &user experience / usability)"
)

$global:GitUtilsConfig = @{
  Emoji = $true;
  Type  = $true;
  Scope = $true;
}
$config = $global:GitUtilsConfig

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
Format-GitCommitMessage 'Initial commit'
#>
function Format-GitCommitMessage {
  param(
    [Parameter(Mandatory = $true)]
    [string]$message
  )
  [string]$type
  [string]$emoji
  [string]$scope

  [int]$step = 1

  if ($config.Emoji -or $config.Type) {
    $typeIndex = (Get-Host).UI.PromptForChoice("Committing messages...", "${step}. Please choose a type for this changes that you commit:", $typeOptions, 8)
    $step++

    Write-Host
    $choiceMessage = "${step}. Please choose an emoji:"
    $step++

    switch ($typeIndex) {
      0 {
        if ($config.Emoji) {
          $featIndex = (Get-Host).UI.PromptForChoice("", $choiceMessage, $featOptions, 0)
          switch ($featIndex) {
            0 { $emoji = $new }
            1 { $emoji = $boom }
            2 { $emoji = $tada }
            Default { }
          }
        }

        $type = "feat"
      }
      1 {
        if ($config.Emoji) {
          $fixIndex = (Get-Host).UI.PromptForChoice("", $choiceMessage, $fixOptions, 0)
          switch ($fixIndex) {
            0 { $emoji = $bug }
            1 { $emoji = $speech_balloon }
            2 { $emoji = $pencil2 }
          }
        }

        $type = "fix"
      }
      2 {
        if ($config.Emoji) {
          $docsIndex = (Get-Host).UI.PromptForChoice("", $choiceMessage, $docsOptions, 0)
          switch ($docsIndex) {
            0 { $emoji = $memo }
            1 { $emoji = $bulb }
          }
        }

        $type = "docs"
      }
      3 {
        if ($config.Emoji) {
          $styleIndex = (Get-Host).UI.PromptForChoice("", $choiceMessage, $styleOptions, 0)
          switch ($styleIndex) {
            0 { $emoji = $lipstick }
            1 { $emoji = $art }
          }
        }

        $type = "style"
      }
      4 {
        if ($config.Emoji) {
          $refactorIndex = (Get-Host).UI.PromptForChoice("", $choiceMessage, $refactorOptions, 0)
          switch ($refactorIndex) {
            0 { $emoji = $recycle }
            1 { $emoji = $zap }
            2 { $emoji = $truck }
          }
        }

        $type = "refactor"
      }
      5 {
        if ($config.Emoji) {
          $testIndex = (Get-Host).UI.PromptForChoice("", $choiceMessage, $testOptions, 0)
          switch ($testIndex) {
            0 { $emoji = $white_check_mark }
          }
        }

        $type = "test"
      }
      6 {
        if ($config.Emoji) {
          $choreIndex = (Get-Host).UI.PromptForChoice("", $choiceMessage, $choreOptions, 0)
          switch ($choreIndex) {
            0 { $emoji = $wrench }
            1 { $emoji = $arrow_up }
            2 { $emoji = $arrow_down }
            3 { $emoji = $heavy_plus_sign }
            4 { $emoji = $heavy_minus_sign }
            5 { $emoji = $see_no_evil }
          }
        }

        $type = "chore"
      }
      7 {
        if ($config.Emoji) {
          $emojiIndex = (Get-Host).UI.PromptForChoice("", $choiceMessage, $emojiOptions, 0)
          switch ($emojiIndex) {
            0 { $emoji = $construction }
            1 { $emoji = $children_crossing }
          }
        }
      }
    }
  }

  if ($config.Scope) {
    Write-Host
    Write-Host "${step}. Please input the scope about this commit, or press the Enter key to skip:"
    $scope = Read-Host
  }

  Write-Host

  [string]$newMessage

  if ($config.Type) {
    $newMessage += $type
  }

  if ($config.Scope -and ![string]::IsNullOrEmpty($scope)) {
    $newMessage += "(" + $scope + ")"
  }

  if (![string]::IsNullOrEmpty($newMessage)) {
    $newMessage += ": "
  }

  if ($config.Emoji -and ![string]::IsNullOrEmpty($emoji)) {
    $newMessage += $emoji + " "
  }

  return $newMessage + $message
}

<#
.EXAMPLE
Invoke-GitCommit 'Initial commit'
#>
function Invoke-GitCommit {
  param (
    [Parameter(Mandatory = $true, HelpMessage = 'The commit message for git.')]
    [Alias('m')]
    [string]$message,
    # --no-verify
    [switch]$noVerify
  )

  try {
    $null = Get-Command git -ErrorAction stop
  }
  catch {
    Write-Error 'Could not find Git, please install Git first.'
    return
  }

  [System.Collections.ArrayList]$params = @()
  if ($noVerify) {
    $params.Add("--no-verify")
  }

  $newMessage = Format-GitCommitMessage $message

  git commit -m $newMessage $params
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

      $values = ($message | Select-String $regex -AllMatches).Matches.Value

      foreach ($item in $values) {
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
    return
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

Export-ModuleMember -Function Invoke-GitCommit, Format-GitCommitMessage, Invoke-GitHistory, Invoke-Emojify, Invoke-GitAdd, Invoke-GitBranch, Invoke-GitStatus, Invoke-GitCheckout, Invoke-GitPull, Invoke-GitPush, Invoke-GitReset, Invoke-GitDiff
Export-ModuleMember -Alias  ggc, ggl, emojify, gga, ggb, ggs, ggck, ggpl, ggps, ggrst, ggd
Export-ModuleMember -Variable $global:GitUtilsConfig
