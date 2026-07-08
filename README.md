# xmb03 NixOS Configuration

Personal NixOS + home-manager configuration for GIGABYTE G6X9MG laptop (Intel i7-13650HX + NVIDIA RTX 4050).

## Quick start on a new machine

```bash
# 1. Clone
git clone https://github.com/xmb03/nixos-dots.git ~/.config/nixos

# 2. Generate hardware config for YOUR machine
sudo nixos-generate-config --show-hardware-config > ~/.config/nixos/hardware-configuration.nix

# 3. Edit configuration.nix — change hostname, user, timezone, locale, etc.
#    See "What to change per-machine" below

# 4. Rebuild
sudo nixos-rebuild switch --flake ~/.config/nixos#nixos

# 5. Set user password
passwd
```

## What to change per-machine

| File | What to change |
|---|---|
| `hardware-configuration.nix` | **Regenerate** via `nixos-generate-config --show-hardware-config` |
| `configuration.nix` | `networking.hostName`, `time.timeZone`, keyboard layout, username |
| `nvidia.nix` | `nvidiaBusId` and `intelBusId` (see `lspci` output) |
| `home.nix` | `home.username`, `home.homeDirectory` |

### Finding NVIDIA/Intel bus IDs

```bash
lspci | grep -E "VGA|3D"
# Example output:
# 00:02.0 VGA compatible controller: Intel Corporation ...
# 01:00.0 3D controller: NVIDIA Corporation AD107M [GeForce RTX 4050 Max-Q / Mobile]
```

Convert to Nix format: `"PCI:bus:device:function"` (hex without leading zeros).  
For the example above: `intelBusId = "PCI:0:2:0"`, `nvidiaBusId = "PCI:1:0:0"`.

## File-by-file reference

### Root files

| File | Purpose |
|---|---|
| `flake.nix` | Flake entry point. Defines nixpkgs channel, inputs (home-manager, stylix, textfox, NUR), and the NixOS configuration. Home-manager is integrated as a NixOS module. |
| `configuration.nix` | NixOS system config. Bootloader, kernel, networking, X11/LightDM, PipeWire, printing, locale, user accounts, system packages. Imports all modules from `modules/`. |
| `hardware-configuration.nix` | **Auto-generated.** Disk layout, kernel modules, CPU microcode. Run `nixos-generate-config` to create. |
| `nvidia.nix` | NVIDIA driver + PRIME Offload. Intel iGPU drives display, NVIDIA used only via `nvidia-offload` command. D3Cold enabled (GPU suspends on battery). |
| `home.nix` | home-manager entry point. Imports all user-level modules. Lists user packages (maim, rofi, dunst, kitty, etc.). |

### `/modules/wm/` — Window Manager

| File | Purpose |
|---|---|
| `i3.nix` | i3 window manager: keybindings (vim-style), window borders, gaps, bar config, startup programs, resize mode. |
| `i3-settings.nix` | i3status-rust bar: blocks (keyboard layout, backlight, battery, volume, music, network, clock, power menu). Battery block hides text on charger. |
| `picom.nix` | Compositor: GLX backend, vsync on. No shadows, no fade, no blur, no animations. Pure bugfix compositing. |

### `/modules/hardware/` — Hardware

| File | Purpose |
|---|---|
| `monitor.nix` | Auto-switch refresh rate at X startup: 165 Hz on AC, 60.09 Hz on battery. Uses `xrandr`. |
| `power.nix` | Power management: `auto-cpufreq` (powersave on battery, performance on AC), `thermald`, `powertop`, `upower`. **Udev rule** for switching refresh rate on AC plug/unplug. NVIDIA finegrained PM. |
| `touchpad.nix` | libinput touchpad configuration (tap-to-click, natural scrolling, etc.). |

### `/modules/services/` — Services

| File | Purpose |
|---|---|
| `networkmanager.nix` | NetworkManager: internal DHCP, static DNS (Yandex + Google), IPv6 disabled, `wait-online` disabled (fast boot). |
| `redshift.nix` | Blue-light filter: 6500K day / 3500K night, Moscow coords, smooth 1s fade. |
| `clipmenu.nix` | Clipboard history manager (systemd user service). Access via `Mod4+v`. |
| `udiskie.nix` | Automatic USB drive mounting. |
| `ollama.nix` | Ollama LLM server with CUDA (runs on NVIDIA via offload). |
| `zapret.nix` | DPI bypass for Russia. Whitelist: GitHub, GitLab, SoundCloud. |

### `/modules/apps/` — Applications

| File | Purpose |
|---|---|
| `rofi.nix` | Application launcher: Stylix-themed `.rasi`, drun mode, pass integration, custom colors. |
| `yazi.nix` | File manager: plugins (diff, git, smart-enter, chmod, compress), show hidden files, vim opener. |
| `basalt.nix` | TUI Obsidian client (basalt-tui), built from source. |

### `/modules/editor/` — Editors

| File | Purpose |
|---|---|
| `vim.nix` | Vim config: clipboard=unnamedplus, floaterm (Ctrl+/), fzf, LSP (rust-analyzer). Arrow keys disabled. |
| `neovim.nix` | Neovim config: telescope, nvim-cmp (LSP/buffer/path), luasnip, treesitter, LSP servers (pyright, nil, lua-ls, typescript, marksman). |
| `neovim/init.lua` | Neovim init Lua (loaded via `initLua`). |

### `/modules/` — Other

| File | Purpose |
|---|---|
| `firefox/default.nix` | Firefox: force-installed extensions (uBlock Origin, Dark Reader, Vimium C, SingleFile, Privacy Badger, Search by Image), textfox theme, search = DuckDuckGo, telemetry off. |
| `gtk/gtk.nix` | GTK theme, fontconfig (JetBrainsMono for all font categories), file manager bookmarks. |
| `shell/zsh.nix` | Zsh: autosuggestions, syntax highlighting, history (10k, shared), aliases (`up`, `n`, `cat→bat`, `top→btop`, `dn` for GC), custom scripts (`yc`). |
| `term/kitty.nix` | Kitty terminal: window padding 9px, hide decorations, audio bell off. |
| `theme/stylix.nix` | Stylix theming: grayscale-dark scheme, JetBrainsMono fonts. |
| `zathura/zathura.nix` | PDF viewer: clipboard selection, dark recolor with hue preservation. |
| `scripts/powermenu.nix` | Rofi power menu: Lock / Logout / Suspend / Hibernate / Reboot / Shutdown. Accessed via `Mod4+p`. |
| `scripts/rofi-wallpaper.nix` | Rofi wallpaper picker: grid view, sets feh wallpaper, copies to Stylix assets for rebuild. |

## Keybindings

| Keys | Action |
|---|---|
| **Launcher / Apps** | |
| `Mod4 + d` | App launcher (rofi drun → "Apps") |
| `Mod4 + Tab` | Rofi generic launcher |
| `Mod4 + v` | Clipboard history (clipmenu → "Clip") |
| `Mod4 + a` | Wallpaper picker (rofi) |
| `Mod4 + p` | Power menu (lock / logout / suspend / reboot / shutdown) |
| **Applications** | |
| `Mod4 + w` | Firefox |
| `Mod4 + t` | Kitty terminal |
| `Mod4 + q` | Kill focused window |
| **Screenshots** | |
| `Print` | Fullscreen capture → clipboard + file (in `~/Pictures/`) |
| `Mod4 + Shift + s` | Region capture → clipboard + file |
| **Focus (vim-style)** | |
| `Mod4 + j/k/l/;` | Focus left / down / up / right |
| `Mod4 + ←/↓/↑/→` | Same (arrow keys) |
| **Move windows** | |
| `Mod4 + Shift + j/k/l/;` | Move window left / down / up / right |
| `Mod4 + Shift + ←/↓/↑/→` | Same (arrow keys) |
| **Layout** | |
| `Mod4 + h` | Horizontal split |
| `Mod4 + f` | Toggle fullscreen |
| `Mod4 + s` | Stacking layout |
| `Mod4 + e` | Toggle split layout |
| `Mod4 + Shift + Space` | Toggle floating |
| `Mod4 + Space` | Toggle focus (tiling ↔ floating) |
| `Mod4 + r` | Resize mode (arrows / vi-keys) |
| **Workspaces** | |
| `Mod4 + 0-9` | Switch to workspace N |
| `Mod4 + Shift + 0-9` | Move window to workspace N |
| **Media / Volume** | |
| `XF86AudioRaiseVolume` | Volume +10% |
| `XF86AudioLowerVolume` | Volume -10% |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioPlay / Next / Prev` | Media controls |
| **System** | |
| `Mod4 + Shift + c` | Reload i3 config |
| `Mod4 + Shift + r` | Restart i3 |
| `Mod4 + Shift + e` | Exit i3 (confirmation dialog) |

## Power management

| Feature | Implementation |
|---|---|
| CPU governor | `auto-cpufreq` — powersave on battery, performance on AC |
| Turbo | Disabled on battery, enabled on AC |
| Refresh rate | 60.09 Hz on battery, 165 Hz on AC |
| NVIDIA GPU | D3Cold (runtime suspend) on battery, wakes only via `nvidia-offload` |
| Switch on AC change | udev rule (`ac-refresh`) triggers xrandr + optional GPU PM |

## Stack

| Component | Choice |
|---|---|
| Distribution | NixOS 26.11 (unstable) |
| Window manager | i3 |
| Compositor | Picom (GLX vsync, no effects) |
| Display manager | LightDM (auto-login) |
| Bar | i3status-rust |
| Launcher | Rofi |
| Terminal | Kitty |
| Shell | Zsh |
| Editor | Vim + Neovim |
| File manager | Yazi |
| Browser | Firefox (textfox theme) |
| Notifications | Dunst |
| Clipboard | clipmenu (rofi frontend) |
| Screenshots | maim (+ slop for region) |
| GPU drivers | NVIDIA open kernel modules, PRIME Offload |
| Theming | Stylix (grayscale-dark) |
| Audio | PipeWire |
| LLM | Ollama (CUDA) |

## Commands

```bash
# Full rebuild
sudo nixos-rebuild switch --flake ~/.config/nixos#nixos

# Garbage collection
sudo nix-collect-garbage -d && sudo nix-collect-garbage --delete-older-than 30d

# Run app on NVIDIA GPU (instead of Intel)
nvidia-offload <command>

# Home-manager only (user-level changes)
home-manager switch --flake ~/.config/nixos
```
