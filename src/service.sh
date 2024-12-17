#!/bin/bash
# minecraft-server-suite — configs and scripts to manage multiple Minecraft
# servers on one machine
#
# Copyright (C) 2024 Jack Harrington
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
# 
# Get a copy of the source at
# https://github.com/jackharro/minecraft-server-suite

mc_ver=$(basename "$(pwd)")
MC_HOME="/home/minecraft/${mc_ver}"
# do we really need a PID file?
MC_PID_FILE="$MC_HOME/minecraft-server.pid"
# no, each server has mc_home/start
# MC_START_CMD="java -Xmx8G -Xms256M -jar spigot.jar"

tmx_sckt="minecraft"
tmx_sess=""

is_server_running() {
	tmux -L ${tmx_sckt} has-session -t ${tmx_sess} > /dev/null 2>&1
	return $?
}

mc_command() {
	cmd="$1"
	tmux -L ${tmx_sckt} send-keys -t ${tmx_sess}.0 "$cmd" ENTER
	return $?
}

start_server() {
        # use tmux -L -has-session
	if is_server_running; then
		echo "Server already running"
		return 1
	fi
	echo "Starting minecraft server in tmux session"
	tmux -L ${tmx_sckt} new-session -c $MC_HOME -s ${tmx_sess} -d "$MC_START_CMD"

	pid=$(tmux -L ${tmx_sckt} list-sessions -F '#{pane_pid}')
	if [ "$(echo $pid | wc -l)" -ne 1 ]; then
		echo "Could not determine PID, multiple active sessions"
		return 1
	fi
	echo -n $pid > "$MC_PID_FILE"

	return $?
}

stop_server() {
	if ! is_server_running; then
		echo "Server is not running!"
		return 1
	fi

	# Warn players
	echo "Warning players"
	mc_command "title @a times 3 14 3"
	for i in {10..1}; do
		mc_command "title @a subtitle {\"text\":\"in $i seconds\",\"color\":\"gray\"}"
		mc_command "title @a title {\"text\":\"Shutting down\",\"color\":\"dark_red\"}"
		sleep 1
	done

	# Issue shutdown
	echo "Kicking players"
	mc_command "kickall"
	echo "Stopping server"
	mc_command "stop"
	if [ $? -ne 0 ]; then
		echo "Failed to send stop command to server"
		return 1
	fi

	# Wait for server to stop
	wait=0
	while is_server_running; do
		sleep 1

		wait=$((wait+1))
		if [ $wait -gt 60 ]; then
			echo "Could not stop server, timeout"
			return 1
		fi
	done

	rm -f "$MC_PID_FILE"

	return 0
}

reload_server() {
	tmux -L ${tmx_sckt} send-keys -t ${tmx_sess}.0 "reload" ENTER
	return $?
}

attach_session() {
	if ! is_server_running; then
		echo "Cannot attach to server session, server not running"
		return 1
	fi

	tmux -L ${tmx_sckt} attach-session -t ${tmx_sess}
	return 0
}

case "$1" in
start)
	start_server
	exit $?
	;;
stop)
	stop_server
	exit $?
	;;
reload)
	reload_server
	exit $?
	;;
attach)
	attach_session
	exit $?
	;;
*)
	echo "Usage: ${0} <start|stop|reload|attach>"
	exit 2
	;;
esac

