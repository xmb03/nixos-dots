# Build

## С нуля на новой NixOS машине

```bash
# 1. Установить NixOS (любым способом)
# 2. Склонировать конфиги
sudo mv /etc/nixos /etc/nixos.bak
sudo git clone https://github.com/xmb03/nixos-dots /etc/nixos

# 3. Собрать систему
sudo nixos-rebuild switch --flake /etc/nixos#nixos

# 4. Создать папку для обоев
mkdir -p ~/Pictures/Wallpapers
# Положить туда .jpg/.png файлы

# 5. Выбрать первые обои (активирует pywal)
# Через i3: $mod+a (или в терминале:)
rofi-wallpaper
```

## Обновление после изменений в конфигах

```bash
# Если конфиги в /etc/nixos:
sudo nixos-rebuild switch --flake /etc/nixos#nixos

# Если из GitHub:
sudo nixos-rebuild switch --flake github:xmb03/nixos-dots#nixos
```

## Обновление flake.lock

```bash
sudo nix flake lock --flake /etc/nixos
```

## Обновление nixpkgs

```bash
sudo nix flake update --flake /etc/nixos
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

## Очистка старых поколений

```bash
sudo nix-collect-garbage -d
nix-collect-garbage -d
```

## Хоткеи i3 (основные)

| Клавиша | Действие |
|---|---|
| `$mod+d` | Rofi (запуск приложений) |
| `$mod+a` | Выбор обоев (pywal) |
| `$mod+p` | Power menu |
| `$mod+w` | Firefox |
| `Print` | Скриншот всего экрана |
| `$mod+Shift+s` | Скриншот области |
| `$mod+r` | Resize mode |

## После первого билда проверить

- [ ] `rofi-wallpaper` — выбрать обои, цвета обновились?
- [ ] `kitty` — открывается, цвета от wal?
- [ ] `nvim` — LazyVim установился, цвета neopywal?
- [ ] `$mod+p` — powermenu работает?
- [ ] `$mod+v` — clipboard (greenclip)?
- [ ] Тачпад — natural scrolling?
- [ ] Монитор — 1920×1200 @ 165Гц?
- [ ] Звук — клавиши громкости?
- [ ] Уведомления — dunst?
