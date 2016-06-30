# oom_adj - Launch a process with a modified oom_score adjustment

## Disclaimer

If you have a system that is being disrupted by `oom-killer` runs your utmost priority needs to be to stop that. Your machine has become memory-starved and will likely be highly unstable.

This script is intended as a stop-gap to protect cricital processes [eg: backups] from being killed.

## Usage

Note: This script must be run as root as it needs to modify values in `/proc` for a process other than itself.

### Command Line

    oom_adj.sh -n <adjustment magnitude> <command>
	
* `-n` can be any value between -1000 [never kill] and 1000 [always kill]
* `<command>` must be a simple, one-off command. If you need to do more then you should create a script and call `oom_adj.sh` from within it as-needed.