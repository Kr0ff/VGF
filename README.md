To enable automatic screen detection and resizing in vmware in linux machines with i3 window manager, couple of systemd commands
have to be initiated.

This will enable and start the services which are installed by "open-vm-tools".

Also, to enable copying and pasting from "host to guest" and "guest to host" in i3, the following line must be added in the i3 config file:

```bash
bindsym exec vmware-user-suid-wrapper --no-startup-id
```
or
```bash
bindsym exec vmware-user --no-startup-id
```

--------------------------

[!] This has been tested on Arch Linux only
--------------------------

```console
git clone https://github.com/Kr0ff/VMWare-Guest-FullScreen
```



