# Minecraft Remote Monitoring and Managment


A single init script which makes running multiple Minecraft servers easier for admins.

## Quick Installers

Install MC-RMM on a **debian box**:

    wget -q https://raw.githubusercontent.com/m4lfuncti0n/mc-rmm/master/installers/debian.sh -O /tmp/mc-rmm && bash /tmp/mc-rmm

Or install MC-RMM under **RedHat**:

	wget -q https://raw.githubusercontent.com/m4lfuncti0n/mc-rmm/master/installers/redhat.sh -O /tmp/mc-rmm && bash /tmp/mc-rmm

Or [suggest a new platform][issues].

## Getting Started

* Install MC-RMM on your box.
* Read the [changelog][changelog] to get a picture of how MC-RMM has evolved over time.

MC-RMM is released under the GPLv3 licence, which is included in the repository [here][licence]. I'm open to suggestions where licencing is concerned.

## Features

As well as starting, stopping and restarting MC-RMM has the following features:

* One script handles multiple servers, run two or more servers on one machine.
* Can create and start new servers with a single command, downloads the jars for you.
* Periodically makes backups of your worlds.
* Backup the entire server directory for complete protection.
* Load world's into RAM for faster access (reduces lag).
* Easily configurable global defaults, with per server overrides if needed.
* Apply server commands to one, multiple, or all servers in one go (useful for whitelisting a player on all servers.)
* Tab completion for all commands, makes everything faster and getting started a breeze.
* Keep server logs organsied by periodically "rolling" them.
* Organises jar files into groups (such as minecraft and craftbukkit) and links each server to a single jar. Includes automated download of new versions.
* Plethora of in-game commands (whitelist, blacklist, operator, gamemode, kick, say, time, toggledownfall, save)
* Send commands straight to the server via the command line.

## Support

1. If you find a problem with MC-RMM and you think the problem is one that requires changing code [submit an issue][issues] via GitHub.

## Upcoming features

* **QuickBackup:** If you store your backups non-locally (maybe on a NAS), QuickBackup optionally creates a backup locally for speed, and then moves it after your players are building again! My initial testing shows a 54 second network backup confaltes to 23 seconds of in-game time.
* **Restore:** Roll-back to an old world or whole server backup automatically.


## Versioning

MC-RMM uses semantic version numbers to better describe what code one might have installed, and indicate backwards incompatible changes.

Releases will be numbered in the following format:

`<major>.<minor>.<patch>`

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major (and resets the minor and patch)
* New additions without breaking backward compatibility bumps the minor (and resets the patch)
* Bug fixes and misc changes bumps the patch

For more information on SemVer, visit http://semver.org/.


## Acknowledgements

This code grew out of an old version of [Ahtenus' Minecraft Init Script][ahtenus-minecraft-init].


[ahtenus-minecraft-init]: https://github.com/Ahtenus/minecraft-init
[changelog]: https://github.com/m4lfiuncti0n/mc-rmm/master/CHANGELOG.markdown
[licence]: https://github.com/m4lfiuncti0n/mc-rmm/master/LICENSE.markdown
[issues]: https://github.com/m4lfiuncti0n/mc-rmm/issues
