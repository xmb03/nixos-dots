# nixos-dots

NixOS dotfiles with i3wm, pywal theming, LazyVim, and home-manager.

Forked from [i3-dots](https://github.com/xmb03/i3-dots) — ported from Arch Linux to NixOS.

## Features

- **i3wm** — full modular config with pywal-driven colors via Xresources
- **pywal** — single wallpaper pick colorschemes kitty, rofi, i3, zathura, nvim, zsh
- **LazyVim** — Neovim distribution with neopywal colorscheme
- **i3status-rust** — status bar with keyboard layout, volume, backlight, clock, power button
- **Rofi** — app launcher, clipboard manager (greenclip), window switcher, power menu
- **Zsh** — autosuggestions + syntax highlighting with dynamic pywal colors
- **kitty** — terminal with pywal color integration
- **redshift** — blue light filter
- **udiskie** — USB auto-mount

## Structure

```
flake.nix              ← nixpkgs (unstable) + home-manager
flake.lock
configuration.nix      ← system: bootloader, network, xserver, i3, pipewire
home.nix              ← home-manager entrypoint
modules/
  wm/
    i3.nix            ← i3 keybinds, autostart, bar, window colors
    i3-settings.nix   ← i3status-rust config
  term/kitty.nix      ← kitty + pywal colors
  shell/
    zsh.nix           ← zsh aliases, pywal integration, syntax highlighting
    bash.nix          ← bash aliases
  apps/
    rofi.nix          ← rofi launcher + powermenu theme
    zathura.nix       ← zathura + pywal colors
  editor/nvim.nix     ← LazyVim with neopywal (lua configs in ./lua/)
  gtk/gtk.nix         ← GTK3 bookmarks + fontconfig
  services/
    redshift.nix      ← blue light filter
    greenclip.nix     ← clipboard manager
    udiskie.nix       ← USB automount
  scripts/
    rofi-wallpaper.nix ← pywal wallpaper picker
    powermenu.nix      ← power menu (lock, logout, suspend, reboot, shutdown)
  hardware/
    monitor.nix       ← DP-0 1920×1200 @ 165Hz
    touchpad.nix      ← libinput natural scrolling
  theme/wal.nix       ← pywal template for zathura
```

## Keybindings

| Key | Action |
|---|---|
| `$mod+d` | Rofi app launcher |
| `$mod+v` | Rofi clipboard (greenclip) |
| `$mod+Tab` | Rofi window switcher |
| `$mod+w` | Firefox |
| `$mod+a` | Wallpaper picker |
| `$mod+p` | Power menu |
| `Print` | Full screenshot (flameshot) |
| `$mod+Shift+s` | Region screenshot (flameshot) |
| `$mod+j/k/l/;` | Focus (vim-style, also arrows) |
| `$mod+Shift+j/k/l/;` | Move window |
| XF86Audio{Lower,Raise,Mute}Volume | Volume controls |
| `$mod+r` | Resize mode |
| `$mod+1-0` | Workspace switch |

## Quick start

```bash
# Clone
sudo git clone https://github.com/xmb03/nixos-dots /etc/nixos

# Build
sudo nixos-rebuild switch --flake /etc/nixos#nixos

# Add wallpapers
mkdir -p ~/Pictures/Wallpapers
# drop .jpg files in there

# Pick first wallpaper (activates pywal)
$mod+a
```

## Commands

| Command | Action |
|---|---|
| `sudo nixos-rebuild switch --flake /etc/nixos#nixos` | Rebuild system |
| `sudo nix flake update --flake /etc/nixos` | Update nixpkgs |
| `sudo nix-collect-garbage -d` | Clean old generations |

## Requirements

- NixOS 26.05+
- Hardware: DP-0 monitor, touchpad

## License

MIT
