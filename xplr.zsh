XPLR_TIEBREAK="index"
XPLR_LAYOUT="reverse"
XPLR_PREVIEW_CMD="~/.config/xplr/preview"
XPLR_PREVIEW_SETTINGS="right"
XPLR_MAXDEPTH="3"

xplr () {
	while true
	do
		sel=$(echo -e "$(fd -d $XPLR_MAXDEPTH)\\n.." | sk --tiebreak=$XPLR_TIEBREAK --layout=$XPLR_LAYOUT \
			-c "echo -e 'delete\nmove\ncopy' | grep '{}'" \
			--preview="$XPLR_PREVIEW_CMD {}" --preview-window=$XPLR_PREVIEW_SETTINGS \
			-p "xplr: " --cmd-prompt="action: ")

		[[ -d $sel ]] && cd $sel && continue

		[[ -e $sel ]] && xdg-open $sel 2> /dev/null

		[[ $sel == "" ]] && return

		[[ $sel == "delete" ]] && rm -rf $(fd -d $XPLR_MAXDEPTH | sk --tiebreak=$XPLR_TIEBREAK --layout=$XPLR_LAYOUT \
			-m -p "delete: ")

		[[ $sel == "move" ]] && mv $(fd -d $XPLR_MAXDEPTH | sk --tiebreak=$XPLR_TIEBREAK --layout=$XPLR_LAYOUT \
			-m -p "select file: ") \
			$(fd -d $XPLR_MAXDEPTH | sk --tiebreak=$XPLR_TIEBREAK --layout=$XPLR_LAYOUT \
			-c "fd | grep '{}' || echo {}" \
			-i --cmd-prompt="select destination: ")

		[[ $sel == "copy" ]] && cp $(fd -d $XPLR_MAXDEPTH | sk --tiebreak=$XPLR_TIEBREAK --layout=$XPLR_LAYOUT \
			-m -p "select file: ") \
			$(fd -d $XPLR_DEPTH | sk --tiebreak=$XPLR_TIEBREAK --layout=$XPLR_LAYOUT \
			-c "fd | grep '{}' || echo {}" \
			-i --cmd-prompt="select destination: ")
		done
	}
