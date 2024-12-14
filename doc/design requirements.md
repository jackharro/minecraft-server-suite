# Design Requirements

jackharro likes to organise the features of a new project in a format like this file. It helps with scope creep and building an understanding of the codebase. This file will probably be made private and excluded by the gitignore.

## minecraft-server-suite

4. Make /run/tmp/tmux-minecraft/ where d:g:1001:rw and minecraft:minecraft
4.1. Should each server have a different socket, different window or different pane?

// I already wrote the design requirements in permissions.md, so this is a reverse-design requirements of the existing codebase

## minecraft-tmux-service

1. /var/minecraft is the working directory of one server

2. There is a named tmux socket specified by -L in cwd
	2.1. Commands can be sent to the tmux window that the server was started in
	2.2. 