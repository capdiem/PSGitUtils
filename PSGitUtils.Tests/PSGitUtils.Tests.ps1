Import-Module $PSScriptRoot\..\PSGitUtils\PSGitUtils.psd1 -Force

Describe "PSGitUtils" {
  $singleCode = ":boom: break changes"
  $singleCodes = ":boom: break chages", ":bug: fix: something wrong!"
  $multiCode = ":construction: fix: Use :children_crossing: instead of :fire:"

  Context "Invoke-Emojify" {
    It "success for single-Gitmoji string" {
      Invoke-Emojify $singleCode | Should Be '💥 break changes'
    }

    It "success for single-Gitmoji array" {
      Invoke-Emojify $singleCodes | Should be "💥 break chages", "🐛 fix: something wrong!"
    }

    It "success for muilt-Gitmoji string" {
      Invoke-Emojify $multiCode | Should be "🚧 fix: Use 🚸 instead of 🔥"
    }

    It "success for no-Gitmoji string" {
      $str = "feat: Add README.md"
      Invoke-Emojify $str | Should be $str
    }

    It "success for alias emojify" {
      emojify $multiCode | Should be "🚧 fix: Use 🚸 instead of 🔥"
    }
  }
}