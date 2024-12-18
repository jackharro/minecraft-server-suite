# Minecraft Server Suite

## Set of configuration files and scripts for hosting one or more Minecraft servers on a machine

Minecraft Server Suite has these features:

- Use systemd to control the status of any number of Minecraft servers

- Open a tmux session for each Minecraft server so its i/o can be accessed

<!--INFO: minecraft-backup: minecraft seems to change the mtime of all world files, even if they aren't used. --checksum option should be used-->

- Include an automatic snapshot solution that:
    - Keeps all yearly snapshots
    - Keeps all monthly snapshots
    - Keeps the last 4 weekly snapshots
    - Keeps the last 7 daily snapshots
    - Keeps the last 24 hourly snapshots
    - Keeps the last 4 quarter-hourly snapshots
    - Keeps the last 5 minute snapshots

# Installation

## Prior to installation

<!--INFO: The ID numbers are not relevant but jackharro uses 1001. Maybe a script relies on this.-->

1. In /etc/passwd, create a system user (login shell is usr/sbin/nologin) called minecraft with home /home/minecraft.

`minecraft:x:1001:1001:Minecraft Server:/home/minecraft:/usr/sbin/nologin`

2. In /etc/group, create group minecraft and add your user to the group

`minecraft:x:1001:jackharro`

Important: for the minecraft user to maintain rwX access to files created by your user in /home/minecraft, we need to edit the ACL and set the group sticky bit

3. If /home/minecraft has any files, back it up and remove /home/minecraft

4. `# mkdir /home/minecraft && chown minecraft:minecraft /home/minecraft`

5. `chmod ug=rw,g+s,o=- /home/minecraft`

6. `setfacl -m d:u::rwX,d:g::rwX,d:o::- /home/minecraft`

See the output of `ls -l /home/minecraft` for the effect of the ACL when files are made by your user:

```
TODO
```

If you have issues with minecraft reading files created by your user, ensure that the `getfacl` output of that directory is something like this:

```
TODO
```
And change it if it isn't.

## Installation

By default, this installs files named:
<!-- We should only make one script file, minecraftctl. The different parts of the file should be concatenated by make. -->

```
/usr/local/bin/minecraft-server-ctl
/usr/local/bin/minecraft-server-backup
/etc/systemd/system/minecraft@.service
/etc/cron.d/minecraft-backup.conf
```

To install to /usr/local/bin, /etc/systemd/system and /etc/cron.d:

```
# make install
```

OR

```
# DESTDIR=/usr/bin make install
```

make will:

1. Move all non-minecraftctl files to target
2. Concatenate the files in src/ into target/minecraftctl
3. Set appropriate permissions to target/*
5. mv target/minecraftctl $BIN\_DIR
6. mv target/minecraft@.service $SYSTEMD\_DIR/system
7. mv target/minecraft-backup.conf $CRON\_DIR

# Usage

## Starting, stopping, restarting and enabling servers

<!--INFO: heading for systemd if more initds are supported
### SystemD
-->

`# systemctl start|stop|restart|enable minecraft@<version>`

Enabling a server will start the Minecraft server when the computer is turned on.

<!--TODO: change quotes-->

You will have to `port' the service if your initd is not systemd. PRs for different initds will be accepted.

## 

## Snapshotting
The backup is automatic and follows the rules outlined above. Running `make install` turns on the snapshot
