# nixos-dots

NixOS + home-manager + pywal dotfiles.

## Структура

```
flake.nix              ← nixpkgs (unstable) + home-manager
configuration.nix      ← system: boot, network, xserver, i3, pipewire
home.nix              ← home-manager: imports, пакеты, .Xresources
modules/
  wm/i3.nix           ← i3 extraConfig (keybinds, autostart, bar, цвета)
  wm/i3-settings.nix  ← i3status-rust (keyboard, sound, backlight, clock, poweroff)
  term/kitty.nix      ← kitty + wal colors
  shell/zsh.nix       ← zsh + wal integration (colors.sh, sequences)
  shell/bash.nix      ← bash aliases
  apps/rofi.nix       ← rofi (drun, clipboard, powermenu) + wal colors
  apps/zathura.nix    ← zathura + wal colors
  editor/nvim.nix     ← neovim LazyVim + neopywal
  gtk/gtk.nix         ← gtk3 bookmarks + fontconfig
  services/redshift.nix
  services/greenclip.nix
  services/udiskie.nix
  scripts/rofi-wallpaper.nix  ← wal + feh (выбор обоев через rofi)
  scripts/powermenu.nix       ← power menu (lock/logout/suspend/reboot/shutdown)
  hardware/monitor.nix
  hardware/touchpad.nix
  theme/wal.nix       ← pywal template для zathura
```

## Перенос из i3-dots — отчёт

**Источник:** https://github.com/xmb03/i3-dots (Arch Linux, pywal)

**Цель:** NixOS + home-manager

### Перенесено (81%)

| Компонент | Статус |
|---|---|
| i3 (keybinds, autostart, bar, resize, workspace) | ✅ |
| i3 цвета (set_from_resource, pywal) | ✅ |
| i3status-rust (keyboard, sound, backlight, clock, poweroff) | ✅ |
| kitty + include wal colors | ✅ |
| rofi + powermenu (wal theme) | ✅ |
| zathura + wal template | ✅ |
| zsh (wal integration, aliases, highlighting) | ✅ |
| bash aliases | ✅ |
| .Xresources #include wal | ✅ |
| touchpad (libinput) | ✅ |
| fontconfig (JetBrainsMono) | ✅ |
| GTK bookmarks | ✅ |
| redshift | ✅ |
| powermenu script | ✅ |
| rofi-wallpaper (wal -i + feh) | ✅ |
| монитор (xrandr DP-0 1920x1200@165) | ✅ |
| zathura pywal template | ✅ |
| greenclip | ✅ |
| udiskie | ✅ |

### Частично перенесено

| Компонент | Статус | Что не хватает |
|---|---|---|
| rofi-wallpaper | ⚠️ 93% | `wal-telegram --wal` (нет в nixpkgs) |
| GTK тема | ⚠️ 50% | нет `gtk.css` (кастомная тёмная тема) |

### Не перенесено

| Компонент | Что есть в i3-dots |
|---|---|
| ❌ nvim plugins | `example.lua` — 12 конфигов (telescope, lsp, treesitter, mason, lualine, cmp-emoji, gruvbox, trouble, typescript...) |
| ❌ nvim lazy-lock.json | 35 пинов плагинов |
| ❌ nvim stylua.toml | форматтер |
| ❌ nvim .neoconf.json | lua_ls + neodev |
| ❌ dconf | GSettings дамп |

### Удалено (stylix → pywal)

| Было | Стало |
|---|---|
| `stylix` input в flake.nix | удалён |
| `stylix.nixosModules.stylix` | удалён |
| `modules/theme/stylix.nix` | `modules/theme/wal.nix` |
| `set_from_resource` gruvbox дефолты | `set_from_resource` pywal дефолты |
| catppuccin (nvim) | neopywal |
| `withPython3 = true;` (nvim) | удалён (deprecated) |

### Исправленные ошибки

| Ошибка | Исправление |
|---|---|
| Дубль `services.libinput.enable` | удалён из `configuration.nix` |
| `[block.click]` (TOML) | → `[[block.click]]` |
| `monitorConfig = "1920x1200_165.00"` | → `xrandr` в i3 extraConfig |
| `exec_always ln -sf` в rofi-wallpaper | удалён (избыточен) |
| `stylix.targets.*` не включены | не актуально (stylix удалён) |
| flake.lock с orphaned nodes | почищен |
