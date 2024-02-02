#!/bin/bash

# Function to select history using peco
function peco_select_history() {
	local line=$(HISTTIMEFORMAT= history | \
	sort -r | sed -E s/^\ *[0-9]\+\ \+// | \
	peco --query "$READLINE_LINE" --layout=bottom-up)
	READLINE_LINE="$line"
	READLINE_POINT=${#line}
}

