if (( $+commands[powershell.exe] )); then
  # integrates with ssh-agent-wsl
  # path to executable should be set beforehand as $_ssh_agent_wsl
  if [[ ! -z $_ssh_agent_wsl ]]; then
    eval $("$_ssh_agent_wsl" | sed '/echo/d' )
    unset _ssh_agent_wsl # _ssh_agent_sock
  fi

  _windows_username=$(powershell.exe '$env:UserName')
  _windows_username="${_windows_username//$'\r'}"
  # dir bookmark
  hash -d -- winhome="/mnt/c/Users/$_windows_username"
  # suffix alias for .bat files
  alias -s bat='cmd.exe /c'

  if (( $+commands[mpv.com] )); then
    alias mpv=mpv.com
  fi

  if [[ -d "/mnt/c/Users/$_windows_username/iCloudDrive" ]]; then
    hash -d -- iCloud="/mnt/c/Users/$_windows_username/iCloudDrive"
  fi

  unset _windows_username

  # workaround wsl gripes
  umask 022
  SHELL=/bin/zsh
fi
