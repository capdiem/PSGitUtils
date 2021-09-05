# PSGitUtils

- Provides emoji supports for Git commit and Git log.
- Provides some easier commands that encapsulating git commands.

## Install

```powershell
> Install-Module -Name PSGitUtils
```

# Usage

- Invoke-GitCommit

  Same as `git commit -m`, but provides choices of types. It would generate the message like `<type>(<scope>): <emoji> subject`. You can modify `$GitUtilsConfig` to decide whether or not generating emoji and type.

  ```powershell
  > Invoke-GitCommit "New Commit"
  > ggc "New Commit"
  ```

- Invoke-GitHistory

  Same as `git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'`, but replaces [Gitmoji code](https://gitmoji.carloscuesta.me/) with emoji.

  ```powershell
  > Invoke-GitHistory
  > Invoke-GitHistory 20
  > ggh
  > ggh 20
  ```

- GitUtilsConfig

  ```powershell
  > $GitUtilsConfig.Type = $True  # determine whether to show the <type>, default show
  > $GitUtilsConfig.Scope = $True # determine whether to show the <scope>, default show
  > $GitUtilsConfig.Emoji = $True # determine whether to show the <emoji>, default show
  > $GitUtilsConfig.EmojiFirst = $False # determine whether to place the <emoji> in front of <type>, default no
  ```

- Other Aliases

  ```powershell
  > gga   # git add [.|args]
  > ggb   # git branch [-av|args]
  > ggbd  # git branch -d [args] with user interactions
  > ggbs  # Try to delete the local branches that no longer exist on the remote
  > ggck  # git checkout [args], user interactions if args is empty
  > ggckb # git checkout -b <branch-name>
  > ggc   # git commit -m <msg> with user interactions
  > ggd   # git diff [args]
  > ggpl  # git pull [args]
  > ggps  # git push [args]
  > ggrst # git reset [args]
  > ggs   # git status [args]
  ```

## Best Practices

```powershell
# open default profile
> notepad $PROFILE
# copy the following code and paste it into $PROFILE
if (Get-Module PSGitUtils -ListAvailable) {
  Import-Module PSGitUtils         # initialize variables
  $GitUtilsConfig.Emoji = $false   # do not pick and insert <emoji>

  Set-Alias ga gga
  Set-Alias gb ggb
  Set-Alias gbd ggbd
  Set-Alias gbs ggbs
  Set-Alias gck ggck
  Set-Alias gckb ggckb
  Remove-Item 'Alias:\gcm' -Force
  Set-Alias gcm ggc
  Set-Alias gcmd Get-Command
  Set-Alias gd ggd
  Set-Alias gh ggl
  Set-Alias gpl ggpl
  Remove-Item 'Alias:\gps' -Force
  Set-Alias gps ggps
  Set-Alias grst ggrst
  Set-Alias gs ggs
}

# use (some examples...)
> gs # git status
> gh # git log
> gcm "test" # git commit -m "test"
```

![Example of Invoke-GitCommit](assets/Invoke-GitCommit.gif)

## References

- [Gitmoji](https://gitmoji.carloscuesta.me/)
- [Semantic Commit Messages](https://seesparkbox.com/foundry/semantic_commit_messages)
- [git commit emoji 使用指南](https://github.com/liuchengxu/git-commit-emoji-cn)
- [emoji.dic](https://gist.github.com/Polkm/fe2e4fb940e4e1569684feb503433e3e)
