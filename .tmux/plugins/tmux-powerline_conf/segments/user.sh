# exit the script if any statement returns a non-true return value

_is_enabled() {
  ( ([ x"$1" = x"enabled" ] || [ x"$1" = x"true" ] || [ x"$1" = x"yes" ] || [ x"$1" = x"1" ]) && return 0 ) || return 1
}

_tty_info() {
  tty="${1##/dev/}"
  uname -s | grep -q "CYGWIN" && cygwin=true

  if [ x"$cygwin" = x"true" ]; then
    ps -af | tail -n +2 | awk -v tty="$tty" '
      ((/ssh/ && !/-W/) || !/ssh/) && $4 == tty {
        user[$2] = $1; parent[$2] = $3; child[$3] = $2
      }
      END {
        for (i in parent)
        {
          j = i
          while (parent[j])
            j = parent[j]

          if (!(i in child) && j != 1)
          {
            file = "/proc/" i "/cmdline"; getline command < file; close(file)
            gsub(/\0/, " ", command)
            print i, user[i], command
            exit
          }
        }
      }
    '
  else
    ps -t "$tty" -o user=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX -o pid= -o ppid= -o command= | awk '
      NR > 1 && ((/ssh/ && !/-W/) || !/ssh/) {
        user[$2] = $1; parent[$2] = $3; child[$3] = $2; for (i = 4 ; i <= NF; ++i) command[$2] = i > 4 ? command[$2] FS $i : $i
      }
      END {
        for (i in parent)
        {
          j = i
          while (parent[j])
            j = parent[j]

          if (!(i in child) && j != 1)
          {
            print i, user[i], command[i]
            exit
          }
        }
      }
    '
  fi
}

_ssh_or_mosh_args() {
  args=$(printf '%s' "$1" | awk '/ssh/ && !/vagrant ssh/ && !/autossh/ && !/-W/ { $1=""; print $0; exit }')
  if [ -z "$args" ]; then
    args=$(printf '%s' "$1" | grep 'mosh-client' | sed -E -e 's/.*mosh-client -# (.*)\|.*$/\1/' -e 's/-[^ ]*//g' -e 's/\d:\d//g')
  fi

 printf '%s' "$args"
}

_username() {
  tty=${1:-$(tmux display -p '#{pane_tty}')}
  ssh_only=$2

  tty_info=$(_tty_info "$tty")
  command=$(printf '%s' "$tty_info" | cut -d' ' -f3-)

  ssh_or_mosh_args=$(_ssh_or_mosh_args "$command")
  if [ -n "$ssh_or_mosh_args" ]; then
    # shellcheck disable=SC2086
    username=$(ssh -G $ssh_or_mosh_args 2>/dev/null | awk 'NR > 2 { exit } ; /^user / { print $2 }')
    # shellcheck disable=SC2086
    [ -z "$username" ] && username=$(ssh -T -o ControlPath=none -o ProxyCommand="sh -c 'echo %%username%% %r >&2'" $ssh_or_mosh_args 2>&1 | awk '/^%username% / { print $2; exit }')
  else
    if ! _is_enabled "$ssh_only"; then
      username=$(printf '%s' "$tty_info" | cut -d' ' -f2)
    fi
  fi

  printf '%s' "$username"

  if [ x"$username" = x"root" ]; then
    tmux show -gqv '@root'
  fi
}

_hostname() {
  tty=${1:-$(tmux display -p '#{pane_tty}')}
  ssh_only=$2

  tty_info=$(_tty_info "$tty")
  command=$(printf '%s' "$tty_info" | cut -d' ' -f3-)

  ssh_or_mosh_args=$(_ssh_or_mosh_args "$command")
  if [ -n "$ssh_or_mosh_args" ]; then
    # shellcheck disable=SC2086
    hostname=$(ssh -G $ssh_or_mosh_args 2>/dev/null | awk 'NR > 2 { exit } ; /^hostname / { print $2 }')
    # shellcheck disable=SC2086
    [ -z "$hostname" ] && hostname=$(ssh -T -o ControlPath=none -o ProxyCommand="sh -c 'echo %%hostname%% %h >&2'" $ssh_or_mosh_args 2>&1 | awk '/^%hostname% / { print $2; exit }')
    #shellcheck disable=SC1004
    hostname=$(echo "$hostname" | awk '\
    { \
      if ($1~/^[0-9.:]+$/) \
        print $1; \
      else \
        split($1, a, ".") ; print a[1] \
    }')
  else
    if ! _is_enabled "$ssh_only"; then
      hostname=$(command hostname -s)
    fi
  fi

  printf '%s' "$hostname"
}

_root() {
  tty=${1:-$(tmux display -p '#{pane_tty}')}
  username=$(_username "$tty" false)

  if [ x"$username" = x"root" ]; then
    tmux show -gqv '@root'
  else
    echo ""
  fi
}

run_segment() {
    _username #{pane_tty} false #D
    return 0
}
