Copyright (C)  2024 Jack Harrington.
Permission is granted to copy, distribute and/or modify this document
under the terms of the GNU Free Documentation License, Version 1.3
or any later version published by the Free Software Foundation;
with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
A copy of the license is included in the section entitled "GNU
Free Documentation License".

# Design Requirements

jackharro likes to organise the features of a new project in a format like this file. It helps with scope creep and building an understanding of the codebase. This file will probably be made private and excluded by the gitignore.

## minecraft-server-suite
1. There is one tmux socket, minecraft, and one tmux session, minecraft
    1.1. more than
    1.2. chgrp /tmp/tmux/minecraft minecraft



// I already wrote the design requirements in permissions.md, so this is a reverse-design requirements of the existing codebase

## minecraft-tmux-service

1. /var/minecraft is the working directory of one server

2. There is a named tmux socket specified by -L
	2.1. Commands can be sent to the tmux window that the server was started in

3. Abstraction: mc\_command:
    3.1. send-keys to -L minecraft
    3.2. return exit code of tmux
    3.3. Command supports spaces

4. command: stop
    4.1. Warn the players
    4.2. mc\_command kickall (plugin)
    4.3. mc\_command stop
    4.4. Tell user if the server failed to stop (exit code of mc\_command is nonzero)
    4.5. Warn if server is actually not stopping

5. command: reload
    5.1. send reload to server (plugin)
