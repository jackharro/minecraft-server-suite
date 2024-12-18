Copyright (C)  2024 Jack Harrington.
Permission is granted to copy, distribute and/or modify this document
under the terms of the GNU Free Documentation License, Version 1.3
or any later version published by the Free Software Foundation;
with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
A copy of the license is included in the section entitled "GNU
Free Documentation License".

# permissions
setfacl can have d:user::rwX / d:group::rwX

# make a shared session in tmux
tmux -S /tmp/shareds new -s sharedsession

## we cannot make /tmp/minecraft and use setfacl to add permissions
/tmp says:
A directory made available for applications that need a place to create temporary files. Applications shall be allowed to create files in this directory, but shall not assume that such files are preserved between invocations of the application.

## this pattern could be useful
The following attaches to session 0 or creates a new session:

tmux new-session -t 0 || tmux


