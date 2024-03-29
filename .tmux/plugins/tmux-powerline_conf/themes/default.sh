# Default Theme

tmux set -g status-left-style fg=#8a8a8a,bg=#080808
tmux set -g status-right-style fg=#8a8a8a,bg=#080808
tmux set -g status-style fg=#8a8a8a,bg=#080808

TMUX_POWERLINE_SEPARATOR_LEFT_BOLD="|"
TMUX_POWERLINE_SEPARATOR_LEFT_THIN="|"
TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD="|"
TMUX_POWERLINE_SEPARATOR_RIGHT_THIN="|"

TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_BACKGROUND_COLOR:-'235'}
TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR=${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR:-'255'}

TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_LEFTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_RIGHT_BOLD}
TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR=${TMUX_POWERLINE_DEFAULT_RIGHTSIDE_SEPARATOR:-$TMUX_POWERLINE_SEPARATOR_LEFT_BOLD}


# Format: segment_name background_color foreground_color [non_default_separator]

if [ -z $TMUX_POWERLINE_LEFT_STATUS_SEGMENTS ]; then
	TMUX_POWERLINE_LEFT_STATUS_SEGMENTS=(
		"tmux_session_info 234,bold 136" \
		# "hostname 33 0" \
		#"ifstat 30 255" \
		#"ifstat_sys 30 255" \
		# "lan_ip 24 255 ${TMUX_POWERLINE_SEPARATOR_RIGHT_THIN}" \
		# "wan_ip 24 255" \
		# "vcs_branch 29 88" \
		# "vcs_compare 60 255" \
		# "vcs_staged 64 255" \
		# "vcs_modified 9 255" \
		# "vcs_others 245 0" \
	)
fi

if [ -z $TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS ]; then
	TMUX_POWERLINE_RIGHT_STATUS_SEGMENTS=(
		#"earthquake 3 0" \
		# "pwd 89 211" \
		#"macos_notification_count 29 255" \
		# "mailcount 9 255" \
		# "now_playing 234 37" \
		#"cpu 240 136" \
		# "load 237 167" \
		#"tmux_mem_cpu_load 234 136" \
		# "battery 137 127" \
		# "weather 37 255" \
		#"rainbarf 0 ${TMUX_POWERLINE_DEFAULT_FOREGROUND_COLOR}" \
		#"xkb_layout 125 117" \
		#"date_day 235 136" \
		"prefix none #8a8a8a,none" \
		"many_attached none none" \
		"pane_sync none none" \
		"time #080808,none #8a8a8a ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
		"date #080808,none #8a8a8a ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
		"user #e4e4e4,bold #000000" \
		"hostname #e4e4e4,bold #000000" \
		#"utc_time 235 136 ${TMUX_POWERLINE_SEPARATOR_LEFT_THIN}" \
	)
fi
