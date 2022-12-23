
run_segment() {
	tmux display -p '#{?client_prefix,⌨ ,}'
	return 0
}
