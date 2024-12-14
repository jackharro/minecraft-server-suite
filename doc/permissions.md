Design Requirements
===================
1. Use users to control file permissions
    1.1. minecraft user that a) runs java b) runs cron and c) does not run tmux
    1.2. jackharro user that a) runs tmux at startup of machine (not at logon)

2. jackharro can make files in /home/minecraft that minecraft can use
    2.1. 770 aka ug=rwx o= permissions

3. systemd is used to control which games are running
    3.1. naming conventions/organisation
        3.1.1. /home/minecraft/<game>
        3.1.2. system/minecraft@.service
        3.1.3. systemctl enable minecraft@<game>
    3.2. The same .service file is used by all games


Means to an end
===============

1.
---
How can we satisfy 1.1a and 1.2a?
ps -u minecraft shows java
ps -u jackharro shows tmux
java is run under a tmux window

This is further complicated by 3 as the Unit.User is minecraft and ExecStart is /home/minecraft/<game>/start. Without systemd, the tmux window could execute a 

2.
---

setfacl—set file access control lists
    • setfacl -m <acl\_list> <file>
    • ACL or acl\_spec looks like this:
        d/* for default \*/:[ug]:<uid>:<permissions>
        where permissions ∈ {r,w,x,X,s}
In this context, we try `sudo setfacl -m d:u:1001:rwX,d:g:1001:rwX /home/minecraft`

Which results in the directory and file:
drwxrws---+ 2 jackharro minecraft 4096 Dec 12 18:42 dir
-rw-rw----+ 1 jackharro minecraft    0 Dec 12 18:42 file

Which works perfectly. Files are not executable by default, directories are executable. The setguid bit ensures that the group is always minecraft.

Lets try with g-s on /home/minecraft:

drwxrwx---+ 2 jackharro jackharro 4096 Dec 12 18:45 dir
-rw-rw----+ 1 jackharro jackharro    0 Dec 12 18:45 file


As expected, the group is now jackharro but g+rw is still applied. So what is the point of uid in the ACL?

By the way, a touched dir/file has g+rw permissions.
