# PSGitUtils

Providers emoji supports for Git commit and Git log.

# Usage

- Invoke-GitCommit

  Same as `git commit -m`, but provides choices of types. It would generate the message like `[<emoji> ][<type>: ]<message>`. You can modify `$GitUtilsConfig` to decide whether or not generating emoji and type.

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
  > $GitUtilsConfig.Type = $False
  > $GitUtilsConfig.Emoji = $False
  ```

# References

- [Gitmoji](https://gitmoji.carloscuesta.me/)

- [Semantic Commit Messages](https://seesparkbox.com/foundry/semantic_commit_messages)
