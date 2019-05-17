# path to ssh-agent-wsl should be set beforehand as $_ssh_agent_wsl

if [[ ! -z $_ssh_agent_wsl ]]; then
  eval $("$_ssh_agent_wsl" | sed '/echo/d' )
  unset _ssh_agent_wsl # _ssh_agent_sock
fi
