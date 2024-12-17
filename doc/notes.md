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


