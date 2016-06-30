#!/bin/bash

function oom_adj_exec() {
	while getopts ':n:' opt; do
		case $opt in
			n)
				if grep -q '^-\?[0-9]\+$' <(echo "$OPTARG"); then
					if [ "$OPTARG" -ge -1000 -a "$OPTARG" -le 1000 ]; then
						oom_score_adjust=$OPTARG
					else
						echo "Acceptable values for -n are from -1000 to 1000" >&2
						return 255
					fi
				else
					echo "Improper format for -n: $OPTARG" >&2
					return 255
				fi
				break
				;;
			:)
				echo "option -$OPTARG requires a value" >&2
				return 255
				;;
			*)
				echo "Unknown option -$opt" >&2
				return 255
				;;
		esac
	done

	command=${@:$OPTIND}
	
	# job control requires the monitor option which
	# is usually not set for non-interactive shells
	prev_state=$(set +o | grep monitor)
	set -o monitor

	$command &
	pid=$!

	echo "$oom_score_adjust" > /proc/$pid/oom_score_adj

	fg %% > /dev/null

	ecode=$?

	# restore the previous states of the shell
	$prev_state

	return $ecode
}

oom_adj_exec $@
