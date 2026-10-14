# inbox: show messages on new interactive shell
if status is-interactive
    set -l inbox_dir "$HOME/.local/messages"
    if test -d "$inbox_dir"
        set -l msg_count (count $inbox_dir/*.msg 2>/dev/null)
        if test "$msg_count" -gt 0
            inbox list
        end
    end
end
