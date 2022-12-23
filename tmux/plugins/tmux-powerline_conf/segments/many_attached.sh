
run_segment() {
	tmux display -p '#{?session_many_attached,👓 ,}'
	return 0
}
