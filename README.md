> **⚠️ WARNING — NOT A GENERAL-PURPOSE CONFIG**
> This is my personal NixOS configuration. It is **not** designed to be cloned and used as-is by anyone else.
> Hardcoded paths, user-specific settings (name `xmb03`), KDE Plasma + i3 hybrid setup, and machine-specific
> hardware configs are baked in. Treat this as a reference / inspiration, not a reusable template.

---

## Screenshots

![desktop](Pictures/20260705_110940.png)
![rofi](Pictures/20260705_101455.png)

---

## Structure

```
.
├── configuration.nix              # NixOS system config
├── hardware-configuration.nix     # Auto-generated (do not edit)
├── home.nix                       # home-manager user config
├── flake.nix                      # Flake entry point
├── nvidia.nix                     # NVIDIA GPU driver module (PRIME offload)
├── Pictures/                      # Screenshots
├── modules/
│   ├── apps/
│   │   ├── rofi.nix               # Rofi launcher (theme, pass, drun)
│   │   ├── yazi.nix               # Yazi file manager (plugins, keymap)
│   │   └── basalt.nix             # TUI Obsidian (basalt-tui)
│   ├── editor/
│   │   ├── vim.nix                # Vim config (LSP, plugins)
│   │   ├── neovim.nix             # Neovim config (LSP, treesitter, cmp)
│   │   └── neovim/init.lua        # Neovim init Lua
│   ├── firefox/default.nix        # Firefox config & extensions (textfox)
│   ├── gtk/gtk.nix                # GTK settings, fontconfig, bookmarks
│   ├── hardware/
│   │   ├── monitor.nix            # Monitor resolution (xrandr, AC-aware)
│   │   ├── touchpad.nix           # Touchpad (libinput)
│   │   └── power.nix              # Power mgmt (auto-cpufreq, thermald, powertop)
│   ├── scripts/
│   │   ├── powermenu.nix          # Rofi power menu
│   │   └── rofi-wallpaper.nix     # Rofi wallpaper picker
│   ├── services/
│   │   ├── clipmenu.nix           # Clipboard manager (clipmenu)
│   │   ├── networkmanager.nix     # NetworkManager tunings (DNS, DHCP, IPv6 off)
│   │   ├── ollama.nix             # Ollama LLM server (CUDA)
│   │   ├── redshift.nix           # Blue-light filter
│   │   ├── udiskie.nix            # Auto-mount USB
│   │   └── zapret.nix             # DPI bypass
│   ├── shell/zsh.nix              # Zsh config (aliases, history, plugins)
│   ├── term/kitty.nix             # Kitty terminal
│   ├── theme/
│   │   ├── stylix.nix             # Stylix theme (wallpaper colors)
│   │   └── assets/                # Wallpaper symlink for Stylix
│   ├── wm/
│   │   ├── i3.nix                 # i3 keybindings & settings
│   │   ├── i3-settings.nix        # i3status-rust bar
│   │   ├── picom.nix              # Picom compositor (GLX vsync)
│   │   └── power-char             # Power icon
│   └── zathura/zathura.nix        # PDF viewer
```

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
| `Print` | Fullscreen capture → clipboard + file |
| `Mod4 + Shift + p` | Region capture → clipboard + file |
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

## Stack

| Component | Choice |
|---|---|---|
| Window manager | i3 (with KDE Plasma 6 login) |
| Compositor | Picom (GLX vsync) |
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
| Screenshots | maim |
| Theming | Stylix |
| Audio | PipeWire |
| LLM | Ollama (CUDA) |
| Notes | Basalt (TUI Obsidian) |
| DPI bypass | zapret |

## Applying changes

```bash
# Full system rebuild
sudo nixos-rebuild switch --flake .#nixos

# home-manager only
home-manager switch --flake .
```

## Adding a new module

1. Create `modules/<category>/<name>.nix`
2. Add `./modules/<category>/<name>.nix` to the `imports` list in `home.nix`
3. Rebuild with `nixos-rebuild switch`
