Import-Module $PSScriptRoot\..\PSGitUtils\PSGitUtils.psd1 -Force

$Global:singleCode = ":boom: break changes"
$Global:singleCodes = ":boom: break chages", ":bug: fix: something wrong!"
$Global:multiCode = ":construction: fix: Use :children_crossing: instead of :fire:"

Describe "PSGitUtils" {

  Context "Invoke-Emojify" {

    It "success for single-Gitmoji string" {
      Invoke-Emojify $Global:singleCode | Should -Be '💥 break changes'
    }

    It "success for single-Gitmoji array" {
      Invoke-Emojify $Global:singleCodes | Should -be "💥 break chages", "🐛 fix: something wrong!"
    }

    It "success for muilt-Gitmoji string" {
      Invoke-Emojify $Global:multiCode | Should -be "🚧 fix: Use 🚸 instead of 🔥"
    }

    It "success for no-Gitmoji string" {
      $str = "feat: Add README.md"
      Invoke-Emojify $str | Should -be $str
    }

    It "success for alias emojify" {
      emojify $multiCode | Should -be "🚧 fix: Use 🚸 instead of 🔥"
    }
  }

  Context "Format-GitCommitMessage" {
    It "GitUtilsConfig has right default value" {
      $GitUtilsConfig.Type | Should -Be $true
      $GitUtilsConfig.Emoji | Should -Be $true
      $GitUtilsConfig.Scope | Should -Be $true
    }

    It "Contains type, emoji and scope" {
      Mock Get-Host {
        [pscustomobject] @{
          ui = Add-Member -PassThru -Name PromptForChoice -InputObject ([pscustomobject] @{}) -Type ScriptMethod -Value { return 0 }
        }
      }

      Mock Read-Host {
        return "Caching"
      }

      Mock Write-Host {}

      $message = Format-GitCommitMessage "Add a new feature"

      $message | Should -Contain "feat(Caching): 🆕 Add a new feature"
    }

    It "Contains scope and emoji, but no type" {
      $GitUtilsConfig.Type = $false

      Mock Get-Host {
        [pscustomobject] @{
          ui = Add-Member -PassThru -Name PromptForChoice -InputObject ([pscustomobject] @{}) -Type ScriptMethod -Value { return 0 }
        }
      }

      Mock Read-Host {
        return "Caching"
      }

      Mock Write-Host {}

      $message = Format-GitCommitMessage "Add a new feature"

      $message | Should -Contain "(Caching): 🆕 Add a new feature"

      $GitUtilsConfig.Type = $true
    }

    It "Contains type and emoji, but no emoji" {
      $GitUtilsConfig.Scope = $false

      Mock Get-Host {
        [pscustomobject] @{
          ui = Add-Member -PassThru -Name PromptForChoice -InputObject ([pscustomobject] @{}) -Type ScriptMethod -Value { return 0 }
        }
      }

      Mock Read-Host {
        return "Caching"
      }

      Mock Write-Host {}

      $message = Format-GitCommitMessage "Add a new feature"

      $message | Should -Contain "feat: 🆕 Add a new feature"

      $GitUtilsConfig.Scope = $true
    }

    It "Contains type and scope, but no emoji" {
      $GitUtilsConfig.Emoji = $false

      Mock Get-Host {
        [pscustomobject] @{
          ui = Add-Member -PassThru -Name PromptForChoice -InputObject ([pscustomobject] @{}) -Type ScriptMethod -Value { return 0 }
        }
      }

      Mock Read-Host {
        return "Caching"
      }

      Mock Write-Host {}

      $message = Format-GitCommitMessage "Add a new feature"

      $message | Should -Contain "feat(Caching): Add a new feature"

      $GitUtilsConfig.Emoji = $true
    }

    It "Contains emoji, but no type and scope" {
      $GitUtilsConfig.Type = $false
      $GitUtilsConfig.Scope = $false

      Mock Get-Host {
        [pscustomobject] @{
          ui = Add-Member -PassThru -Name PromptForChoice -InputObject ([pscustomobject] @{}) -Type ScriptMethod -Value { return 0 }
        }
      }

      Mock Read-Host {
        return "Caching"
      }

      Mock Write-Host {}

      $message = Format-GitCommitMessage "Add a new feature"

      $message | Should -Contain "🆕 Add a new feature"

      $GitUtilsConfig.Type = $true
      $GitUtilsConfig.Scope = $true
    }

    It "Contains scope, but no type and emoji" {
      $GitUtilsConfig.Type = $false
      $GitUtilsConfig.Emoji = $false

      Mock Get-Host {
        [pscustomobject] @{
          ui = Add-Member -PassThru -Name PromptForChoice -InputObject ([pscustomobject] @{}) -Type ScriptMethod -Value { return 0 }
        }
      }

      Mock Read-Host {
        return "Caching"
      }

      Mock Write-Host {}

      $message = Format-GitCommitMessage "Add a new feature"

      $message | Should -Contain "(Caching): Add a new feature"

      $GitUtilsConfig.Type = $true
      $GitUtilsConfig.Emoji = $true
    }

    It "Contains type, but no emoji and scope" {
      $GitUtilsConfig.Scope = $false
      $GitUtilsConfig.Emoji = $false

      Mock Get-Host {
        [pscustomobject] @{
          ui = Add-Member -PassThru -Name PromptForChoice -InputObject ([pscustomobject] @{}) -Type ScriptMethod -Value { return 0 }
        }
      }

      Mock Read-Host {
        return "Caching"
      }

      Mock Write-Host {}

      $message = Format-GitCommitMessage "Add a new feature"

      $message | Should -Contain "feat: Add a new feature"

      $GitUtilsConfig.Scope = $true
      $GitUtilsConfig.Emoji = $true
    }

    It "No type, scope and emoji" {
      $GitUtilsConfig.Type = $false
      $GitUtilsConfig.Emoji = $false
      $GitUtilsConfig.Scope = $false

      Mock Get-Host {
        [pscustomobject] @{
          ui = Add-Member -PassThru -Name PromptForChoice -InputObject ([pscustomobject] @{}) -Type ScriptMethod -Value { return 0 }
        }
      }

      Mock Read-Host {
        return "Caching"
      }

      Mock Write-Host {}

      $message = Format-GitCommitMessage "Add a new feature"

      $message | Should -Contain "Add a new feature"

      $GitUtilsConfig.Type = $true
      $GitUtilsConfig.Emoji = $true
      $GitUtilsConfig.Scope = $true
    }
  }
}