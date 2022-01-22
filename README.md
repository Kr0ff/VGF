To enable automatic screen detection and resizing in VMWare for Linux virtual machines with i3 window manager, couple of systemd commands
have to be initiated.

The script will download, enable and start the services which are installed by "open-vm-tools".

Also, to enable copying and pasting from "host to guest" and vice versa in i3, the following line must be added in the i3 config file:

```bash
exec vmware-user-suid-wrapper --no-startup-id
```

or

```bash
exec vmware-user --no-startup-id
```

At the moment the following distributions are supported

- Ubuntu
- Fedora
- Arch Linux
- Kali Linux
- ParrotSec OS

Get the script and run it:

```bash
git clone https://github.com/Kr0ff/VMWare-Guest-FullScreen
cd VMWare-Guest-FullScreen
chmod +x enable-fullscreen.sh
./enable-fullscreen.sh
```

### Please note that the folder where the scripts look for if the i3 config exists is
- `$HOME/.config/i3/config`

**This is the default folder where the i3 config is placed upon installing the package**


