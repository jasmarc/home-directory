[[ -r ~/.bashrc ]] && . ~/.bashrc

if [ `hostname` == 'jmarcell-mbpro.local' ]; then
    # Source SSH settings, if applicable

    if [ -f "${SSH_ENV}" ]; then
	 . ${SSH_ENV} > /dev/null
	 ps -x | grep "^ *${SSH_AGENT_PID}" | grep ssh-agent$ > /dev/null || {
	     start_agent;
	 }
    else
	 start_agent;
    fi
fi