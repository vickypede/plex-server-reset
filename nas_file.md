You said:
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Install the latest PowerShell for new features and improvements! https://aka.ms/PSWindows

PS C:\WINDOWS\system32> ssh victor@10.0.0.140
The authenticity of host '10.0.0.140 (10.0.0.140)' can't be established.
ED25519 key fingerprint is SHA256:Hc3ggvoVs/QaM2RBIaMjNOUajBzEPOHD0A6W4AUYcGs.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? y
Please type 'yes', 'no' or the fingerprint: yes
Warning: Permanently added '10.0.0.140' (ED25519) to the list of known hosts.
victor@10.0.0.140's password:

Using terminal commands to modify system configs, execute external binary
files, add files, or install unauthorized third-party apps may lead to system
damages or unexpected behavior, or cause data loss. Make sure you are aware of
the consequences of each command and proceed at your own risk.

Warning: Data should only be stored in shared folders. Data stored elsewhere
may be deleted when the system is updated/restarted.

victor@ds225plus:~$ sudo -i

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

Password:
root@ds225plus:~# find /volume* -maxdepth 6 -name "Preferences.xml" 2>/dev/null | grep -i "Plex Media Server"
/volume1/PlexMediaServer/AppData/Plex Media Server/Preferences.xml
root@ds225plus:~#




