# xmb03 NixOS Configuration — full documentation

## Repository structure

```
~/.config/nixos/
├── flake.nix                # Flake entry point (dependencies + build)
├── configuration.nix        # NixOS system config (boot, network, services, users)
├── hardware-configuration.nix # Auto-generated hardware scan (do not modify)
├── nvidia.nix               # NVIDIA driver + PRIME offload
├── home.nix                 # Home-manager: user module imports
├── modules/
│   ├── apps/
│   │   ├── rofi.nix         # Rofi theme (drun, colors from Stylix)
│   │   ├── yazi.nix         # Yazi file manager (plugins, keybinds)
│   │   └── basalt.nix       # Obsidian-like note taking in terminal
│   ├── editor/
│   │   ├── vim.nix          # Vim (LSP, rust-analyzer, floaterm)
│   │   ├── neovim.nix       # Neovim (telescope, cmp, treesitter, lsp)
│   │   └── neovim/init.lua  # Neovim Lua config
│   ├── firefox/
│   │   └── default.nix      # Firefox (extensions, telemetry, textfox)
│   ├── gtk/
│   │   └── gtk.nix          # GTK themes, bookmarks, fontconfig
│   ├── hardware/
│   │   ├── monitor.nix      # Xrandr: switch refresh rate on AC power
│   │   ├── touchpad.nix     # Libinput: touchpad config
│   │   ├── power.nix        # auto-cpufreq, thermald, AC udev rule
│   │   └── win.nix          # Windows NTFS partition mounting
│   ├── scripts/
│   │   ├── rofi-theme.nix   # Stylix theme picker via Rofi
│   │   ├── rofi-wallpaper.nix # Wallpaper picker via Rofi
│   │   └── powermenu.nix    # Power menu (Lock/Shutdown/...)
│   ├── services/
│   │   ├── networkmanager.nix # NetworkManager + DNS + IPv6 disable
│   │   ├── ollama.nix       # Ollama LLM server (CUDA)
│   │   ├── zapret.nix       # DPI bypass (GitHub, GitLab, SoundCloud)
│   │   ├── qbittorrent.nix  # Torrent client (headless, WebUI)
│   │   ├── redshift.nix     # Blue light filter (temperature, coordinates)
│   │   ├── clipmenu.nix     # Clipboard manager
│   │   └── udiskie.nix      # USB auto-mount
│   ├── shell/
│   │   └── zsh.nix          # Zsh (aliases, history, autocomplete)
│   ├── term/
│   │   └── kitty.nix        # Kitty terminal (padding, no decorations)
│   ├── theme/
│   │   └── stylix.nix       # Stylix: color scheme, fonts
│   ├── wm/
│   │   ├── i3.nix           # i3 (keybindings, gaps, startup, colors)
│   │   ├── i3-settings.nix  # i3status-rust (status bar blocks)
│   │   └── picom.nix        # Picom compositor (vsync, no effects)
│   └── zathura/
│       └── zathura.nix      # PDF reader (dark theme)
├── assets/
│   └── theme-icons/         # 303 PNG icons for Rofi theme picker
└── DOCS.md / DOCS_EN.md     # This documentation
```

---

## flake.nix — entry point

```
File:      ~/.config/nixos/flake.nix
Purpose:   Declares dependencies (inputs) and builds the system (outputs)
```

### inputs (lines 6-25)

| Input | URL | Purpose |
|-------|-----|---------|
| `nixpkgs` | `nixos-unstable` | Main package repository |
| `home-manager` | `master` | User-level configuration management |
| `stylix` | `nix-community/stylix` | Auto-theming from wallpaper colors |
| `textfox` | `adriankarlen/textfox` | Firefox theme matching Stylix |
| `nur` | `nix-community/NUR` | Community user packages |

**What to change:**
- For a stable kernel: `nixpkgs.url = "github:nixos/nixpkgs/nixos-26.11";` instead of `nixos-unstable`

### outputs (lines 28-61)

Builds `nixosConfigurations.nixos` from:
1. `./configuration.nix` — system settings
2. `stylix.nixosModules.stylix` — Stylix module
3. `home-manager.nixosModules.home-manager` — home-manager module
4. Inline block with home-manager settings

**What to change:**
- Line 56: `users.xmb03 = import ./home.nix;` — replace `xmb03` with your username

---

## configuration.nix — system

```
File:      ~/.config/nixos/configuration.nix
Purpose:   System settings: bootloader, network, services, users, packages
```

### imports (lines 9-21)

Imports modules from `modules/`. To disable a module, comment out its line.

**What to change:**
- To add a new module: write `./modules/hardware/my-module.nix` in the list

### boot (lines 24-34)

- `boot.loader.systemd-boot.enable = true;` — use systemd-boot
- `boot.loader.efi.canTouchEfiVariables = true;` — allow EFI variable changes
- `boot.loader.timeout = 0;` — no boot menu pause
- `boot.kernelPackages = pkgs.linuxPackages_latest;` — latest kernel

**What to change:**
- `timeout = 0;` → `timeout = 5;` — to show the boot menu

### networking (lines 38-39)

- `networking.hostName = "xmb03";` — **hostname**

**What to change:**
- `"xmb03"` → `"your-hostname"`

### time (line 43)

- `time.timeZone = "Europe/Moscow";` — **timezone**

**What to change:**
- `"Europe/Moscow"` → `"America/New_York"`, etc.

### nix.settings (lines 48-59)

- `experimental-features = [ "nix-command" "flakes" ];` — enable flakes
- `max-substitution-jobs = 128;` — max download threads
- `http-connections = 128;` — max connections
- `substituters = [ ... ];` — cache mirrors
- `auto-optimise-store = true;` — automatic deduplication

### i18n (lines 65-77)

System language English, regional formats Russian.

**What to change:**
- To remove Russian locale formats — delete the `extraLocaleSettings` block

### xserver (lines 81-106)

- `services.xserver.xkb.layout = "us,ru";` — **keyboard layouts**
- `services.xserver.xkb.options = "grp:alt_shift_toggle";` — **layout switch**
- `services.xserver.dpi = 96;` — display DPI
- `services.xserver.displayManager.lightdm.enable = true;` — LightDM login
- `services.displayManager.autoLogin.user = "xmb03";` — **auto-login user**

**What to change:**
- `"us,ru"` → `"us,de"` for German layout
- `"grp:alt_shift_toggle"` → `"grp:caps_toggle"` for CapsLock switching
- `"xmb03"` → `"your_user"`

### printing (line 110)

- `services.printing.enable = true;` — enable CUPS printing

### audio (lines 114-126)

- `services.pipewire.enable = true;` — PipeWire instead of PulseAudio
- `alsa.enable = true;` — ALSA support
- `pulse.enable = true;` — PulseAudio compatibility

### shell (line 131)

- `programs.zsh.enable = true;` — install Zsh system-wide

### users.users."xmb03" (lines 135-144)

- `isNormalUser = true;` — normal user
- `description = "xmb03";` — display name
- `shell = pkgs.zsh;` — **default shell**
- `extraGroups = [ "networkmanager" "wheel" ];` — **user groups**
- `packages = with pkgs; [ ];` — user-specific packages

**What to change:**
- `"xmb03"` → `"your_user"` everywhere in this block
- To set a password: add `hashedPassword = "$y$..."` or `initialPassword = "123";`

### nixpkgs.config (line 149)

- `nixpkgs.config.allowUnfree = true;` — allow proprietary packages (NVIDIA, Steam)

### environment.systemPackages (lines 152-159)

System-wide packages:
- `wget`, `curl`, `unzip`, `gcc`, `p7zip`, `steam-run`

**What to change:**
- Add/remove any package from the list

### system.stateVersion (line 165)

- `system.stateVersion = "26.05";` — initial install version. **DO NOT CHANGE**.

---

## home.nix — user

```
File:      ~/.config/nixos/home.nix
Purpose:   User-level configuration via home-manager
```

### imports (lines 9-29)

Imports all user modules from `modules/`.

**What to change:**
- To disable a module — comment out its line
- Also remove it from `configuration.nix` if it's a system module

### home (lines 32-37)

- `username = "xmb03";` — **username**
- `homeDirectory = "/home/xmb03";` — **home directory**
- `stateVersion = "26.05";` — do not change

**What to change:**
- `"xmb03"` → `"your_user"` in both lines
- `"/home/xmb03"` → `"/home/your_user"`

### stylix.targets (lines 40-54)

Which apps get themed by Stylix:
- `zathura`, `kitty`, `i3`, `rofi`, `yazi`, `neovim`, `gtk`, `dunst`, `firefox`

**What to change:**
- Any `enable = true` → `false` to disable theming for that app

### home.packages (lines 57-96)

User packages (only available to this user):
- `xdotool`, `xclip`, `bat`, `btop`, `fastfetch`, `git`, etc.

**What to change:**
- Add/remove packages as desired

### home.sessionVariables (line 102)

- `EDITOR = "vim";` — **default editor**

**What to change:**
- `"vim"` → `"nvim"` for Neovim

---

## nvidia.nix — NVIDIA

```
File:      ~/.config/nixos/nvidia.nix
Purpose:   NVIDIA driver, PRIME offload, power management
```

### hardware.graphics (lines 4-7)

- `enable = true;` — graphics support
- `enable32Bit = true;` — 32-bit app support (Steam)

### services.xserver.videoDrivers (line 9)

- `videoDrivers = [ "nvidia" ];` — use NVIDIA driver

### hardware.nvidia (lines 11-29)

- `modesetting.enable = true;` — enable modesetting
- `open = true;` — open kernel module (NVIDIA GSP)
- `nvidiaSettings = true;` — GUI control panel
- `package = config.boot.kernelPackages.nvidiaPackages.latest;` — latest driver
- `prime.nvidiaBusId = "PCI:1:0:0";` — **NVIDIA GPU Bus ID**
- `prime.intelBusId = "PCI:0:2:0";` — **Intel iGPU Bus ID**
- `prime.offload.enable = true;` — PRIME render offload
- `powerManagement.finegrained = true;` — fine-grained power management

**What to change:**
- Get Bus ID: `lspci | grep -E "VGA|3D"`
- Example: `"PCI:1:0:0"` for NVIDIA, `"PCI:0:2:0"` for Intel

### boot.kernelModules (line 31)

- `kernelModules = [ "nvidia-uvm" ];` — Unified Memory module for CUDA

### nvidia-offload (lines 33-39)

Script to run apps on NVIDIA:
```
nvidia-offload <command>
```

---

## modules/hardware/win.nix — Windows NTFS

```
File:      ~/.config/nixos/modules/hardware/win.nix
Purpose:   Mount Windows partitions at Linux boot
```

### boot.supportedFilesystems (line 4)

- `boot.supportedFilesystems = [ "ntfs" ];` — enable ntfs3 kernel driver

### fileSystems."/mnt/win/win-c" (lines 6-9)

```nix
fileSystems."/mnt/win/win-c" = {
  device = "/dev/disk/by-uuid/38087FA8087F6432";
  fsType = "ntfs3";
  options = [ "rw" "uid=1000" "gid=100" "umask=002" "nofail" ];
};
```

- `"/mnt/win/win-c"` — **mount path**
- `device = "/dev/disk/by-uuid/..."` — **partition UUID** (get via `sudo blkid`)
- `fsType = "ntfs3";` — ntfs3 driver (in-kernel, faster than ntfs-3g)
- `options`:
  - `rw` — read & write
  - `uid=1000` — file owner (1000 = xmb03)
  - `gid=100` — group (100 = users)
  - `umask=002` — permissions 775 for dirs, 664 for files (group can write)
  - `nofail` — don't halt boot if partition is missing

### fileSystems."/mnt/win/win-d" (lines 10-13)

Same for the second Windows partition (D:).

**What to change:**
- UUID: `38087FA8087F6432` and `60AA662CAA65FEC2` → your UUIDs (`sudo blkid | grep ntfs`)
- `uid=1000` → your uid (`id`)
- `gid=100` → your gid
- Change paths if you want different mount locations

### users.users.qbittorrent.extraGroups (line 15)

- `extraGroups = [ "users" ];` — adds qbittorrent user to the users group (needed so qBittorrent can write to NTFS with uid=1000,gid=100)

### systemd.tmpfiles.settings."win-symlinks" (lines 17-25)

Creates symlinks in `~/win/` → `/mnt/win/` for convenient access from home.

**What to change:**
- `"/home/xmb03/win/win-c"` → `"/home/your_user/win/win-c"`
- `user = "xmb03"` → `user = "your_user"`

---

## modules/hardware/monitor.nix — display

```
File:      ~/.config/nixos/modules/hardware/monitor.nix
Purpose:   Switch refresh rate (165Hz on AC, 60Hz on battery)
```

- Checks `/sys/class/power_supply/AC/online`:
  - 1 (on AC): `xrandr --rate 165`
  - 0 (battery): `xrandr --rate 60.09`

**What to change:**
- `--output eDP-1` → your output (`xrandr` to list)
- `--mode 1920x1200` → your resolution
- `--rate 165 / 60.09` → your refresh rates

---

## modules/hardware/touchpad.nix — touchpad

```
File:      ~/.config/nixos/modules/hardware/touchpad.nix
Purpose:   Touchpad configuration via libinput
```

Settings:
- `naturalScrolling = true;` — reverse scroll (macOS-like)
- `tapping = true;` — tap to click
- `accelProfile = "adaptive";` — adaptive speed
- `accelSpeed = "-0.39";` — sensitivity (negative = slower)
- `disableWhileTyping = true;` — disable while typing

**What to change:**
- `accelSpeed = "-0.39"` → adjust sensitivity
- `naturalScrolling = false` → normal scroll

---

## modules/hardware/power.nix — power

```
File:      ~/.config/nixos/modules/hardware/power.nix
Purpose:   CPU power management, thermald, auto-cpufreq, AC udev
```

### CPU Governor (line 6)

- `powerManagement.cpuFreqGovernor = "powersave";` — default powersave

### thermald (line 8)

- `services.thermald.enable = true;` — Intel thermal daemon

### auto-cpufreq (lines 12-21)

Auto-switches between battery and AC:
- On battery: `powersave`, `turbo = never`
- On AC: `performance`, `turbo = auto`

### upower (lines 23-28)

- `percentageLow = 15;` — low battery
- `percentageCritical = 5;` — critical
- `percentageAction = 3;` — at 3% powers off

### udev AC rule (lines 30-38)

Runs xrandr to change refresh rate when AC is connected/disconnected.

**What to change:**
- `xrandr --output eDP-1 --mode 1920x1200` → your parameters
- `XAUTHORITY=/home/xmb03/.Xauthority` → your path
- `/home/xmb03` → your home directory

---

## modules/services/qbittorrent.nix — torrents

```
File:      ~/.config/nixos/modules/services/qbittorrent.nix
Purpose:   qBittorrent-nox headless as systemd service, WebUI on 8080
```

### enable, openFirewall, webuiPort (lines 5-7)

- `enable = true;` — enable
- `openFirewall = true;` — open ports in firewall
- `webuiPort = 8080;` — **WebUI port**

### extraArgs (line 9)

- `extraArgs = [ "--confirm-legal-notice" ];` — accept license on first run

### serverConfig.LegalNotice (line 12)

- `LegalNotice.Accepted = true;` — accept license agreement

### serverConfig.Preferences.WebUI (lines 14-15)

- `Username = "xmb03";` — **login username**
- `Password_PBKDF2 = "eG1iMDNfc2FsdF8xNmIh:BJ/a2jW8LE0njGJyqTTv6ER+7/KGFMWwswpyt74lbl5yDkIqPPtC8iHUVEkOQhOJI5WrUDd1Lzav0baJeJy4w";` — **password hash**

**What to change:**
- `Username = "xmb03";` → `Username = "your_user";`
- `Password_PBKDF2 = "..."` — generate a new hash. Format: `base64(salt):base64(hash)`, algorithm PBKDF2-HMAC-SHA512, 100000 iterations, 16-byte salt, 64-byte hash.

  **Generation script:**
  ```python
  import hashlib, base64
  password = b'123'
  salt = b'your_salt_16bytes!'  # exactly 16 bytes, any string works
  hash_bytes = hashlib.pbkdf2_hmac('sha512', password, salt, 100000, dklen=64)
  result = base64.b64encode(salt).decode().rstrip('=') + ':' + base64.b64encode(hash_bytes).decode().rstrip('=')
  print(result)
  ```

### serverConfig.Preferences.Downloads (line 17)

- `SavePath = "/mnt/win/win-d/Games";` — **download path**

**What to change:**
- `"/mnt/win/win-d/Games"` → your path

### serverConfig.BitTorrent.Session (lines 19-35)

Performance settings:

| Parameter | Value | Description |
|----------|-------|-------------|
| `DiskCache.Size` | 64 | Max RAM cache (MB). Prevents qBittorrent from eating all memory |
| `DiskCache.TTL` | 15 | Cache lifetime (seconds). Lower = faster RAM cleanup |
| `AsyncIOThreads` | 4 | Disk I/O threads. 4 is optimal |
| `CoalesceReadWrite` | true | Groups small chunks for less disk I/O |
| `SendBufferLowWatermark` | 2 | Lower send buffer limit (saves RAM) |
| `SendBufferWatermark` | 8 | Upper send buffer limit |
| `SendBufferWatermarkFactor` | 50 | Send buffer multiplier |
| `QueueingSystemEnabled` | false | Download all torrents immediately, no queue |
| `MaxConnections` | 200 | Max total connections. 200 keeps the OS happy |
| `MaxConnectionsPerTorrent` | 40 | Connections per torrent |
| `GlobalMaxUploads` | 30 | Max simultaneous uploads |
| `SendToSocketBufferSizeMethod` | 0 | Let Linux kernel manage send buffers |
| `ReceiveFromSocketBufferSizeMethod` | 0 | Same for receive buffers |
| `DHT` | true | DHT (find peers without tracker) |
| `LSD` | false | Local discovery (unnecessary) |
| `Encryption` | 1 | 1 = prefer encryption (bypasses DPI) |
| `AnonymousMode` | true | Hide User-Agent and local IP |

---

## modules/services/networkmanager.nix — network

```
File:      ~/.config/nixos/modules/services/networkmanager.nix
Purpose:   NetworkManager, DNS, IPv6 disable, fast boot
```

### networking.networkmanager (lines 28-47)

- `enable = true;` — enable NetworkManager
- `dhcp = "internal";` — built-in DHCP client (faster than dhclient)
- `settings.connection."ipv4.dhcp-timeout" = 10;` — DHCP timeout
- `settings.wifi.scan-rand-mac-address = false;` — don't randomize MAC (needed for enterprise WiFi)
- `settings.connectivity.interval = 0;` — disable connectivity check
- `logLevel = "INFO";` — log level

### networking.nameservers (line 53)

- `nameservers = [ "77.88.8.8" "8.8.8.8" ];` — **DNS servers**

**What to change:**
- `"77.88.8.8"` (Yandex DNS) and `"8.8.8.8"` (Google DNS) → your DNS

### networking.enableIPv6 (line 59)

- `enableIPv6 = false;` — **disable IPv6**

**What to change:**
- `false` → `true` if you need IPv6

### systemd.services (line 65)

- `NetworkManager-wait-online.enable = false;` — don't wait for network at boot (faster)

---

## modules/services/ollama.nix — LLM

```
File:      ~/.config/nixos/modules/services/ollama.nix
Purpose:   Ollama (Llama, Mistral, etc.) as systemd service with CUDA
```

- `package = pkgs.ollama-cuda;` — CUDA build (uses NVIDIA)
- `host = "127.0.0.1";` — **local access only**
- `port = 11434;` — API port
- `openFirewall = false;` — don't open port externally

**What to change:**
- `host = "0.0.0.0";` — for network access (be careful!)
- `port = 11434;` → different port

---

## modules/services/zapret.nix — DPI bypass

```
File:      ~/.config/nixos/modules/services/zapret.nix
Purpose:   Bypass DPI blocks for GitHub, GitLab, SoundCloud
```

- `configureFirewall = true;` — configures nftables
- `httpSupport = true;` — HTTP support
- `udpSupport = false;` — no UDP (less overhead)
- `params` — DPI desync parameters
- `whitelist` — domains to apply bypass to

**What to change:**
- Add/remove domains in `whitelist`

---

## modules/services/redshift.nix — blue light filter

```
File:      ~/.config/nixos/modules/services/redshift.nix
Purpose:   Automatic color temperature shifting
```

- `latitude = "55.7558";` — **Moscow latitude**
- `longitude = "37.6173";` — **Moscow longitude**
- `temperature.day = 6500;` — daytime temp (neutral)
- `temperature.night = 3500;` — nighttime (warm, less blue)
- `settings.redshift.dusk-time = "20:00";` — manual dusk
- `settings.redshift.dawn-time = "07:00";` — manual dawn
- `fade = 1;` — transition smoothness

**What to change:**
- Coordinates to your location (get from maps.google.com)
- Dusk/dawn times

---

## modules/services/clipmenu.nix — clipboard

```
File:      ~/.config/nixos/modules/services/clipmenu.nix
Purpose:   Clipboard history manager
```

- `home.packages = [ pkgs.clipmenu ];` — install clipmenu
- `systemd.user.services.clipmenud` — user-level systemd service
  - `ExecStart = "${pkgs.clipmenu}/bin/clipmenud";` — start daemon
  - `Restart = "on-failure";` — restart on error

Invocation via Rofi: `Mod4+v` → `clipmenu -p Clip`

---

## modules/services/udiskie.nix — USB

```
File:      ~/.config/nixos/modules/services/udiskie.nix
Purpose:   Automatic USB drive mounting
```

- `services.udiskie.enable = true;` — enable

---

## modules/wm/i3.nix — window manager

```
File:      ~/.config/nixos/modules/wm/i3.nix
Purpose:   i3 config: keybindings, gaps, colors, startup, bars
```

### modifier (line 13)

- `modifier = "Mod4";` — **modifier key** (Mod4 = Super/Windows)

**What to change:**
- `"Mod4"` → `"Mod1"` for Alt

### floating (lines 16-20)

- `border = 1;` — 1px border on floating windows
- `titlebar = false;` — no title bar

### window (lines 22-32)

- `border = 1;` — 1px border on all windows
- `titlebar = false;` — no title bar
- `hideEdgeBorders = "none";` — don't hide borders at screen edges
- `commands` — remove Firefox border: `border none` for class `"(?i)firefox"`

### colors (lines 34-50)

Border colors from Stylix (base00 — theme background color).

### gaps (lines 52-55)

```nix
gaps = {
  inner = 2;  # gap between windows (pixels)
  outer = 15; # gap from screen edges
};
```

**What to change:**
- `inner = 2` → different value
- `outer = 15` → different value

### bars (lines 57-71)

Status bar based on Stylix + i3status-rust:
- `position = "bottom";` — bar at bottom
- `statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";` — status command
- `trayOutput = "primary";` — tray on primary monitor

### startup (lines 74-85)

Startup programs:

| Command | Purpose |
|---------|---------|
| `xset r rate 200 50` | Key repeat rate (200ms delay, 50 chars/s) |
| `dex --autostart --environment i3` | XDG autostart |
| `rofi-wallpaper --restore` | Restore last wallpaper |
| `xss-lock -- i3lock -n -c 000000` | Lock on suspend |
| `nm-applet` | NetworkManager tray icon |

### keybindings (lines 88-180)

**Hotkey table:**

| Key | Action |
|-----|--------|
| `Print` | Full screenshot (maim → clipboard + ~/Pictures) |
| `Mod4+Shift+s` | Area screenshot |
| `Mod4+w` | Firefox |
| `Mod4+d` | Rofi drun (app launcher) |
| `Mod4+v` | Clipmenu (clipboard history) |
| `Mod4+Tab` | Rofi (all modes) |
| `Mod4+p` | Power menu (powermenu) |
| `Mod4+a` | Wallpaper picker (rofi-wallpaper) |
| `Mod4+Shift+a` | Theme picker (rofi-theme) |
| `Mod4+r` | Resize mode |
| `Mod4+t` | Kitty terminal |
| `Mod4+q` | Close window |
| `Mod4+j/k/l/;` | Focus: left/down/up/right |
| `Mod4+Shift+j/k/l/;` | Move window |
| `Mod4+h` | Horizontal split |
| `Mod4+f` | Fullscreen toggle |
| `Mod4+s` | Stacking layout |
| `Mod4+e` | Toggle split |
| `Mod4+Shift+space` | Toggle floating |
| `Mod4+space` | Focus mode toggle |
| `Mod4+1-0` | Workspaces 1-10 |
| `Mod4+Shift+1-0` | Move window to workspace |
| `Mod4+Shift+c` | Reload i3 config |
| `Mod4+Shift+r` | Restart i3 |
| `Mod4+Shift+e` | Exit i3 |
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Mute |
| `XF86AudioPlay/Next/Prev` | Media control (playerctl) |

**What to change:**
- Any key can be reassigned by editing the string
- Key names: `Mod4`, `Mod1`, `Shift`, `Control`, `Print`, `XF86Audio*`

### resize mode (lines 183-197)

Resize mode (enter: `Mod4+r`):
- `h/j/k/l` or arrow keys — resize

---

## modules/wm/i3-settings.nix — status bar

```
File:      ~/.config/nixos/modules/wm/i3-settings.nix
Purpose:   i3status-rust blocks (clock, sound, network, battery, music)
```

- `theme = "native";` — built-in theme
- `icons = "awesome4";` — icon set

### Blocks (left to right):

1. **keyboard_layout** — layout (EN/RU), click → switch
2. **backlight** — screen brightness
3. **battery** — battery percentage (hidden when charging)
4. **sound** — volume (pipewire)
5. **music** — current track (MPRIS), click → nowplaying script
6. **net** — network status, click → `kitty -e nmtui`
7. **time** — clock (HH:MM)
8. **custom** — power button → `powermenu`

**What to change:**
- Per-block settings: `format`, `interval`, `click`

---

## modules/wm/picom.nix — compositor

```
File:      ~/.config/nixos/modules/wm/picom.nix
Purpose:   Picom (transparency, vsync, shadows — all off for performance)
```

- `backend = "glx";` — GLX backend (OpenGL)
- `vSync = true;` — vertical sync
- `shadow = false;` — no shadows
- `fade = false;` — no animations
- Most parameters disabled for maximum performance

---

## modules/apps/rofi.nix — launcher

```
File:      ~/.config/nixos/modules/apps/rofi.nix
Purpose:   Rofi config (theme, colors from Stylix, keys)
```

### programs.rofi (lines 6-18)

- `font = "JetBrainsMono Nerd Font 14";` — 14px font
- `pass.enable = true;` — pass password manager
- `theme = "drun";` — drun theme (app list)

### drun.rasi theme (lines 20-184)

Full Rofi theme with Stylix colors:
- `background` — from base00 (theme background)
- `foreground` — from base05 (text)
- `lightbg` — from base01
- `selected-normal-background` — from base07 (highlight)

**What to change:**
- `font` — font
- `width: 800px;` — window width
- `padding: 20px;` — padding
- `element-icon size: 1.5em;` — icon size
- Any color variable can be changed

---

## modules/apps/yazi.nix — file manager

```
File:      ~/.config/nixos/modules/apps/yazi.nix
Purpose:   Yazi terminal file manager with plugins
```

### plugins

- `diff` — diff viewer
- `git` — git status
- `smart-enter` — smart Enter
- `chmod` — permissions
- `compress` — archiving

### settings

- `show_hidden = true;` — show hidden files
- `sort_dir_first = true;` — directories first
- `linemode = "size";` — show file sizes
- `opener.edit = "vim";` — editor

### keymap

- `gg` — go to top
- `G` — go to bottom

---

## modules/apps/basalt.nix — notes

```
File:      ~/.config/nixos/modules/apps/basalt.nix
Purpose:   Obsidian-like note-taking in the terminal
```

- Built from source (`rustPlatform.buildRustPackage`)
- `configFile:"basalt/config.toml"` — settings
- `ctrl+alt+e` — open note in vim
- `basalt` alias: `BASALT_EXP_VAULT_PATH=/home/xmb03/Documents/xmb03 basalt`

**What to change:**
- Vault path: `/home/xmb03/Documents/xmb03` → your path

---

## modules/shell/zsh.nix — shell

```
File:      ~/.config/nixos/modules/shell/zsh.nix
Purpose:   Zsh: aliases, history, autocomplete, syntax highlighting
```

### home.sessionPath (line 10)

- `$HOME/.npm-global/bin` — global npm packages path

### home.packages (lines 14-27)

- `zsh-completions` — completion system
- `yc` — custom script: `yc <file>` copies file content to clipboard

### programs.zsh (lines 29-72)

- `history.size = 10000;` — 10000 history entries
- `autosuggestion.enable = true;` — autosuggestions
- `syntaxHighlighting.enable = true;` — syntax highlighting

### localVariables (lines 55-57)

- `PROMPT = "%F{4}>%f ";` — prompt: blue `> `

**What to change:**
- `"${config.home.homeDirectory}/.zsh_history"` — history file path
- `PROMPT = "%F{4}>%f ";` — customize your prompt

### Aliases (lines 60-77)

| Alias | Command | Purpose |
|-------|---------|---------|
| `up` | `cd ~/.config/nixos && git add . && nixos-rebuild switch --elevate=sudo --flake .#nixos` | **Build the system** |
| `c` | `clear` | Clear screen |
| `cat` | `bat` | Cat with syntax highlighting |
| `b` | `bat` | Bat shortcut |
| `l` | `ls -lh` | File listing |
| `la` | `ls -lha` | List with hidden files |
| `..` | `cd ..` | Go up |
| `...` | `cd ../..` | Go up twice |
| `f` | `fastfetch` | System info |
| `mem` | `free -h` | Memory usage |
| `disk` | `df -h` | Disk usage |
| `top` | `btop` | System monitor |
| `m` | `mpv` | Video player |
| `p` | `python` | Python |
| `dn` | `sudo nix-collect-garbage --delete-older-than 30d` | **Clean old NixOS generations** (only cleans /nix/store, doesn't touch home files) |
| `tgw` | `steam-run ~/nixtest/apps/TgWsProxy_linux_amd64` | Telegram proxy |
| `v` | `vim` | Vim |
| `n` | `nvim` | Neovim |
| `yb` | `yazi ~/Documents/xmb03` | Yazi in notes folder |

**What to change:**
- Any alias can be modified
- `dn` is safe — only removes garbage older than 30 days

---

## modules/term/kitty.nix — terminal

```
File:      ~/.config/nixos/modules/term/kitty.nix
Purpose:   Kitty terminal with minimal design
```

- `bold_font = "auto";` — auto bold
- `window_padding_width = 9;` — text padding from window edges
- `hide_window_decorations = "yes";` — no window decorations
- `enable_audio_bell = "no";` — no bell sound
- `confirm_os_window_close = 0;` — no close confirmation

---

## modules/theme/stylix.nix — theming

```
File:      ~/.config/nixos/modules/theme/stylix.nix
Purpose:   Stylix: color scheme, fonts, polarity
```

### base16Scheme (line 9)

- `base16Scheme = "${pkgs.base16-schemes}/share/themes/grayscale-dark.yaml";` — **current color scheme**

**What to change:**
- Replace `grayscale-dark.yaml` with any scheme (list via `rofi-theme`)
- Rofi auto-changes this line when you pick a theme (`Mod4+Shift+a`)

### polarity (line 12)

- `polarity = "dark";` — dark theme

### fonts (lines 15-31)

- `monospace = { package = pkgs.nerd-fonts.jetbrains-mono; name = "JetBrainsMono Nerd Font"; };` — font
- Sizes: `applications = 11; desktop = 10; popups = 10; terminal = 11;`

**What to change:**
- `package` — different font package
- `name` — different font name
- `sizes` — sizes per app type

---

## modules/scripts/rofi-theme.nix — theme picker

```
File:      ~/.config/nixos/modules/scripts/rofi-theme.nix
Purpose:   Stylix theme selection via Rofi with icons and auto-build
```

### How it works

1. Finds `base16-schemes` directory in /nix/store
2. For each scheme: if an icon exists in `assets/theme-icons/` → adds to Rofi
3. Rofi shows a 4×3 grid with icon (2-color strip) and name
4. On selection: sed replaces `base16Scheme` in `stylix.nix`
5. Kitty opens and runs `nixos-rebuild switch`

### element-icon (line 35)

- `size: 6em;` — icon height
- `columns: 4; lines: 3; padding: 3px;` — 4×3 grid, compact

**What to change:**
- `size: 6em;` → larger/smaller for icon size
- `lines: 3;` → 2 or 4 for different row count

### Icons

303 PNG files in `assets/theme-icons/`. Format: 160×12 pixels, 2 colors (base00 + base05).

If a new Stylix scheme is added, generate an icon:
```bash
SCHEME_FILE="path/to/new/scheme.yaml"
NAME=$(basename "$SCHEME_FILE" .yaml)
B00=$(grep -E '^\s+base00:' "$SCHEME_FILE" | sed 's/.*"#\(.*\)"/\1/')
B05=$(grep -E '^\s+base05:' "$SCHEME_FILE" | sed 's/.*"#\(.*\)"/\1/')
python3 -c "
from PIL import Image
b00 = tuple(int('$B00'[i:i+2], 16) for i in (0,2,4))
b05 = tuple(int('$B05'[i:i+2], 16) for i in (0,2,4))
img = Image.new('RGB', (160, 12))
pixels = [(b00 if x < 80 else b05) for x in range(160) for y in range(12)]
img.putdata(pixels)
img.save('assets/theme-icons/$NAME.png')
"
```

---

## modules/scripts/rofi-wallpaper.nix — wallpaper

```
File:      ~/.config/nixos/modules/scripts/rofi-wallpaper.nix
Purpose:   Wallpaper picker via Rofi, remembers last choice (+ --restore)
```

### How it works

- `--restore` — reads `~/.cache/wallpaper-current` and sets wallpaper (called at i3 startup)
- Without args — opens Rofi with 3×3 grid, shows previews from `~/Pictures/Wallpapers/`
- On selection: `feh --bg-fill`, saves path to cache

**What to change:**
- `WALL_DIR="$HOME/Pictures/Wallpapers"` → your wallpaper folder
- `columns: 3; lines: 3;` — change grid
- `element-icon size: 8em;` — change preview size

---

## modules/scripts/powermenu.nix — power menu

```
File:      ~/.config/nixos/modules/scripts/powermenu.nix
Purpose:   Rofi power menu with Lock, Logout, Suspend, Hibernate, Reboot, Shutdown
```

Options:
- **Lock**: `i3lock -c 000000` (black screen)
- **Logout**: `i3-msg exit`
- **Suspend**: `systemctl suspend`
- **Hibernate**: `systemctl hibernate`
- **Reboot**: `systemctl reboot`
- **Shutdown**: `systemctl poweroff`

---

## modules/editor/vim.nix — Vim

```
File:      ~/.config/nixos/modules/editor/vim.nix
Purpose:   Vim with LSP (rust-analyzer), floaterm, fzf
```

### Plugins

- `vim-commentary` — commenting (gc/gc)
- `vim-floaterm` — terminal inside Vim (Ctrl+/)
- `fzf-vim` — file search
- `rust-vim` — Rust highlighting
- `vim-lsp` — LSP client

### Settings

- `number = true;` — line numbers
- `relativenumber = true;` — relative numbers
- `tabstop = 4; shiftwidth = 4; expandtab = true;` — 4-space tabs
- `mouse = "a";` — mouse support

### extraConfig

- `clipboard=unnamedplus` — system clipboard
- `Tab` → LSP completion or tab
- Arrow keys disabled (vim-way)
- `Ctrl+/` → floaterm
- `rust-analyzer` via vim-lsp

### home.packages

- `cargo`, `rustc`, `rustfmt`, `clippy`, `rust-analyzer` — Rust tooling

---

## modules/editor/neovim.nix — Neovim

```
File:      ~/.config/nixos/modules/editor/neovim.nix
Purpose:   Neovim with Telescope, nvim-cmp, Treesitter, LSP
```

### Plugins

- `telescope-nvim` — fuzzy finder
- `nvim-cmp` — autocompletion
- `cmp-nvim-lsp` — LSP source for cmp
- `luasnip` — snippets
- `nvim-treesitter` — syntax highlighting
- `nvim-lspconfig` — LSP config
- `toggleterm-nvim` — terminal
- `mini-align` — alignment

### init.lua

Reads from `./neovim/init.lua` (separate file for readability).

### home.packages

- `pyright` — Python LSP
- `nil` — Nix LSP
- `lua-language-server` — Lua LSP
- `typescript-language-server` — TS/JS LSP
- `marksman` — Markdown LSP
- `ripgrep` — for Telescope
- `fd` — for Telescope

---

## modules/firefox/default.nix — Firefox

```
File:      ~/.config/nixos/modules/firefox/default.nix
Purpose:   Firefox with forced extensions, textfox, telemetry disabled
```

### Forced extensions (lines 6-32)

Installed via Firefox policies:

| ID | Extension |
|----|-----------|
| `uBlock0@raymondhill.net` | uBlock Origin |
| `{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}` | Search by Image |
| `jid1-MnnxcxisBPnSXQ@jetpack` | Privacy Badger |
| `vimium-c@gdh1995.cn` | Vimium C |
| `{531906d3-e22f-4a6c-a102-8057b88a1a63}` | SingleFile |
| `addon@darkreader.org` | Dark Reader |
| `{rto@rto.rto}` | Rutracker Add-on |

**What to change:**
- Add/remove extensions (find ID on addons.mozilla.org)
- `installation_mode = "force_installed"` — cannot be disabled
- `installation_mode = "allowed"` — can be disabled

### Search (lines 41-44)

- `search.default = "ddg";` — DuckDuckGo by default

### Telemetry disable (lines 45-56)

- All `telemetry`, `datareporting`, `ping-centre` → false
- `browser.toolbars.bookmarks.visibility = "never";` — hide bookmarks bar

### textfox (lines 58-61)

- `textfox.enable = true;` — Stylix-themed Firefox
- `profiles = [ "default" ];` — applies to default profile

---

## modules/gtk/gtk.nix — GTK

```
File:      ~/.config/nixos/modules/gtk/gtk.nix
Purpose:   GTK bookmarks, DPI, fonts
```

- `Xft.dpi = 96;` — DPI via Xresources
- `gtk3.bookmarks` — file manager bookmarks: Pictures, Documents, apps, Projects

**What to change:**
- Add your bookmarks to `bookmarks`
- `Xft.dpi = 96;` → `Xft.dpi = 144;` for HiDPI

### fonts.fontconfig (lines 25-33)

- `defaultFonts.monospace = [ "JetBrainsMono Nerd Font Mono" ];`
- `defaultFonts.sansSerif = [ "JetBrainsMono Nerd Font" ];`
- `defaultFonts.serif = [ "JetBrainsMono Nerd Font" ];`

---

## modules/zathura/zathura.nix — PDF

```
File:      ~/.config/nixos/modules/zathura/zathura.nix
Purpose:   PDF reader with dark theme
```

- `selection-clipboard = "clipboard";` — copy selected text to clipboard
- `recolor = true;` — invert colors (dark theme)
- `recolor-keephue = true;` — keep image colors intact

---

## Checklist: Changing the username

If you want to use your own username instead of `xmb03`, change these files:

| File | What to change |
|------|---------------|
| `flake.nix:56` | `users.xmb03` → `users.your_user` |
| `configuration.nix:100-102` | `autoLogin.user = "xmb03"` |
| `configuration.nix:135-144` | `users.users."xmb03"` → `users.users."your_user"` |
| `home.nix:33-34` | `username = "xmb03"`, `homeDirectory = "/home/xmb03"` |
| `i3.nix` | no direct references (xss-lock uses XAUTHORITY) |
| `power.nix:37` | `/home/xmb03/.Xauthority`, `sudo -u xmb03` |
| `win.nix:18,21` | `/home/xmb03/win/...`, `user = "xmb03"` |
| `qbittorrent.nix:14` | `Username = "xmb03"` |
| `zsh.nix` | `$HOME` auto (from homeDirectory) |
| `basalt.nix:28` | `BASALT_EXP_VAULT_PATH=/home/xmb03/...` |
| `rofi-theme.nix` | `ICONS_DIR`, `STYLIX_FILE`, `FLAKE_DIR` (absolute paths) |
| `rofi-wallpaper.nix` | `CACHE`, `WALL_DIR` (via $HOME — fine) |

---

## Checklist: Changing passwords

### Sudo / system login

```nix
# In configuration.nix, inside users.users."xmb03":
initialPassword = "your_password";  # first time only
# or (after first build):
hashedPassword = "hash";  # generate via: mkpasswd -m sha-512
```

**Generate hash:** `mkpasswd -m sha-512` (enter password, get hash).

### qBittorrent

See `modules/services/qbittorrent.nix` section — PBKDF2 generation script above.

### Firefox

Passwords are stored in Firefox itself (password manager), not in config files.

---

## Building and commands

```
up    → cd ~/.config/nixos && git add . && nixos-rebuild switch --elevate=sudo --flake .#nixos
dn    → sudo nix-collect-garbage --delete-older-than 30d
```

After changing any file:
1. `git add` (if it's a new file)
2. `up` (or `nixos-rebuild switch --flake .#nixos --impure --elevate=sudo`)
3. `dn` — occasionally, to clean old generations

**Important:** `--impure` is required because Stylix accesses absolute /nix/store paths.
**Important:** Use `--offline` only if you're certain all packages are already cached.
**Important:** If nix warns about dirty git tree — it's harmless, just a warning.

---

## Troubleshooting

- **No sound?** Check `pavucontrol` or `pactl info`
- **NVIDIA not working?** Check `nvidia-smi`, Bus ID in `nvidia.nix`
- **Windows partitions not mounting?** Verify UUIDs via `sudo blkid`
- **Rofi not opening?** Check `rofi -show drun`
- **Strange errors in Nix?** Use `--show-trace` for the full error log

---

*Generated for xmb03 / nixos-dots configuration*
