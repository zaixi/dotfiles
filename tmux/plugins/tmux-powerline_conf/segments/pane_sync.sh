
run_segment() {
	tmux display -p '#{?pane_synchronized,🔒,}'
	return 0
}
