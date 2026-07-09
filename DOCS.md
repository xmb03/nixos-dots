# xmb03 NixOS Configuration — полная документация

## Структура репозитория

```
~/.config/nixos/
├── flake.nix                # Входная точка флейка (зависимости + сборка)
├── configuration.nix        # Системный конфиг NixOS (буут, сеть, сервисы, юзеры)
├── hardware-configuration.nix # Авто-сгенерированный скрипт железа (не трогать)
├── nvidia.nix               # NVIDIA драйвер + PRIME offload
├── home.nix                 # Home-manager: импорт пользовательских модулей
├── modules/
│   ├── apps/
│   │   ├── rofi.nix         # Тема Rofi (drun, цвета из Stylix)
│   │   ├── yazi.nix         # Файловый менеджер Yazi (плагины, хоткеи)
│   │   └── basalt.nix       # Obsidian-подобная заметочница Basalt
│   ├── editor/
│   │   ├── vim.nix          # Vim (LSP, rust-analyzer, floaterm)
│   │   ├── neovim.nix       # Neovim (telescope, cmp, treesitter, lsp)
│   │   └── neovim/init.lua  # Neovim Lua-конфиг
│   ├── firefox/
│   │   └── default.nix      # Firefox (расширения, телеметрия, textfox)
│   ├── gtk/
│   │   └── gtk.nix          # GTK темы, bookmarks, fontconfig
│   ├── hardware/
│   │   ├── monitor.nix      # Xrandr: смена частоты по питанию
│   │   ├── touchpad.nix     # Libinput: тачпад (тап, скролл, скорость)
│   │   ├── power.nix        # auto-cpufreq, термальд, AC udev правило
│   │   └── win.nix          # Монтирование Windows NTFS разделов
│   ├── scripts/
│   │   ├── rofi-theme.nix   # Пинкер тем Stylix через Rofi
│   │   ├── rofi-wallpaper.nix # Пинкер обоев через Rofi
│   │   └── powermenu.nix    # Меню питания (Lock/Shutdown/...)
│   ├── services/
│   │   ├── networkmanager.nix # NetworkManager + DNS + отключение IPv6
│   │   ├── ollama.nix       # Ollama LLM сервер (CUDA)
│   │   ├── zapret.nix       # Обход DPI (GitHub, GitLab, SoundCloud)
│   │   ├── qbittorrent.nix  # Торрент-клиент (фон, WebUI)
│   │   ├── redshift.nix     # Синий фильтр (температура, координаты)
│   │   ├── clipmenu.nix     # Менеджер буфера обмена
│   │   └── udiskie.nix      # Автомонтирование USB
│   ├── shell/
│   │   └── zsh.nix          # Zsh (алиасы, история, автодополнение)
│   ├── term/
│   │   └── kitty.nix        # Kitty терминал (padding, без рамок)
│   ├── theme/
│   │   └── stylix.nix       # Stylix: схема цветов, шрифты
│   ├── wm/
│   │   ├── i3.nix           # i3 (клавиши, gaps, startup, цвета)
│   │   ├── i3-settings.nix  # i3status-rust (блоки статус-бара)
│   │   └── picom.nix        # Пиком (композитор, vsync)
│   └── zathura/
│       └── zathura.nix      # PDF читалка (тёмная тема)
├── assets/
│   └── theme-icons/         # 303 PNG иконки для Rofi theme picker
└── DOCS.md                  # Этот файл
```

---

## flake.nix — входная точка

```
Файл:      ~/.config/nixos/flake.nix
Назначение: Описывает зависимости (inputs) и собирает систему (outputs)
```

### inputs (строки 6-25)

| Input | URL | Назначение |
|-------|-----|-----------|
| `nixpkgs` | `nixos-unstable` | Главный репозиторий пакетов |
| `home-manager` | `master` | Управление пользовательскими настройками |
| `stylix` | `nix-community/stylix` | Авто-темизация цветов из обоев |
| `textfox` | `adriankarlen/textfox` | Тема Firefox в стиле стиликса |
| `nur` | `nix-community/NUR` | Пользовательские пакеты сообщества |

**Что менять под себя:**
- Если нужно стабильное ядро: `nixpkgs.url = "github:nixos/nixpkgs/nixos-26.11";` вместо `nixos-unstable`

### outputs (строки 28-61)

Собирает конфигурацию `nixosConfigurations.nixos` из:
1. `./configuration.nix` — системные настройки
2. `stylix.nixosModules.stylix` — модуль стиликса
3. `home-manager.nixosModules.home-manager` — модуль home-manager
4. Встроенный блок с настройками home-manager

**Что менять под себя:**
- Строка 56: `users.xmb03 = import ./home.nix;` — заменить `xmb03` на своё имя пользователя

---

## configuration.nix — система

```
Файл:      ~/.config/nixos/configuration.nix
Назначение: Системные настройки: загрузчик, сеть, сервисы, пользователи, пакеты
```

### imports (строки 9-21)

Подключает модули из `modules/`. Если хочешь отключить какой-то модуль — просто удали или закомментируй строку.

**Что менять:**
- Чтобы добавить новый модуль: дописать `./modules/hardware/мой-модуль.nix` в список

### boot (строки 24-34)

- `boot.loader.systemd-boot.enable = true;` — systemd-boot загрузчик
- `boot.loader.efi.canTouchEfiVariables = true;` — разрешить менять EFI
- `boot.loader.timeout = 0;` — без паузы при загрузке
- `boot.kernelPackages = pkgs.linuxPackages_latest;` — самое свежее ядро

**Что менять:**
- `timeout = 0;` → `timeout = 5;` — если нужно меню загрузчика

### networking (строки 38-39)

- `networking.hostName = "xmb03";` — **имя компьютера в сети**

**Что менять:**
- `"xmb03"` → `"твоё-имя"`

### time (строка 43)

- `time.timeZone = "Europe/Moscow";` — **часовой пояс**

**Что менять:**
- `"Europe/Moscow"` → `"America/New_York"` и т.д.

### nix.settings (строки 48-59)

- `experimental-features = [ "nix-command" "flakes" ];` — включает флейки и nix команды
- `max-substitution-jobs = 128;` — макс. потоков для скачивания
- `http-connections = 128;` — макс. соединений
- `substituters = [ ... ];` — зеркала для кеша
- `auto-optimise-store = true;` — автоматическая дедупликация

### i18n (строки 65-77)

Локализация: язык системы английский, региональные форматы — русские.

**Что менять:**
- Если не нужны русские форматы — удалить весь блок `extraLocaleSettings`

### xserver (строки 81-106)

- `services.xserver.xkb.layout = "us,ru";` — **раскладки клавиатуры**
- `services.xserver.xkb.options = "grp:alt_shift_toggle";` — **переключение раскладки**
- `services.xserver.dpi = 96;` — DPI экрана
- `services.xserver.displayManager.lightdm.enable = true;` — LightDM логин
- `services.displayManager.autoLogin.user = "xmb03";` — **автовход**

**Что менять:**
- `"us,ru"` → `"us,de"` для немецкой раскладки
- `"grp:alt_shift_toggle"` → `"grp:caps_toggle"` для переключения по CapsLock
- `"xmb03"` → `"твой_юзер"`

### printing (строка 110)

- `services.printing.enable = true;` — включить печать (CUPS)

### audio (строки 114-126)

- `services.pipewire.enable = true;` — PipeWire вместо PulseAudio
- `alsa.enable = true;` — поддержка ALSA
- `pulse.enable = true;` — PulseAudio-совместимость

### shell (строка 131)

- `programs.zsh.enable = true;` — установка Zsh в систему

### users.users."xmb03" (строки 135-144)

- `isNormalUser = true;` — обычный пользователь
- `description = "xmb03";` — отображаемое имя
- `shell = pkgs.zsh;` — **шелл по умолчанию**
- `extraGroups = [ "networkmanager" "wheel" ];` — **группы пользователя**
- `packages = with pkgs; [ ];` — пользовательские пакеты

**Что менять:**
- `"xmb03"` → `"твой_юзер"` везде в этом блоке
- Чтобы задать пароль (если не нужен автовход): добавить `hashedPassword = "$y$..."` или `initialPassword = "123";`

### nixpkgs.config (строка 149)

- `nixpkgs.config.allowUnfree = true;` — разрешить проприетарные пакеты (NVIDIA, Steam)

### environment.systemPackages (строки 152-159)

Системные пакеты, доступные всем пользователям:
- `wget`, `curl`, `unzip`, `gcc`, `p7zip`, `steam-run`

**Что менять:**
- Добавить/удалить любой пакет из списка

### system.stateVersion (строка 165)

- `system.stateVersion = "26.05";` — версия при первом установке. **НЕ МЕНЯТЬ**.

---

## home.nix — пользователь

```
Файл:      ~/.config/nixos/home.nix
Назначение: Управление пользовательскими настройками через home-manager
```

### imports (строки 9-29)

Подключает все модули из `modules/`. Каждая строка импортирует один модуль.

**Что менять:**
- Если хочешь отключить модуль — закомментируй его строку
- Не забудь также убрать его из `configuration.nix` если это системный модуль

### home (строки 32-37)

- `username = "xmb03";` — **имя пользователя**
- `homeDirectory = "/home/xmb03";` — **домашняя папка**
- `stateVersion = "26.05";` — не менять

**Что менять:**
- `"xmb03"` → `"твой_юзер"` в обеих строках
- `"/home/xmb03"` → `"/home/твой_юзер"`

### stylix.targets (строки 40-54)

Какие приложения темизировать через Stylix:
- `zathura`, `kitty`, `i3`, `rofi`, `yazi`, `neovim`, `gtk`, `dunst`, `firefox`

**Что менять:**
- Любой `enable = true` → `false` чтобы отключить темизацию для приложения

### home.packages (строки 57-96)

Пользовательские пакеты (доступны только этому пользователю):
- `xdotool`, `xclip`, `bat`, `btop`, `fastfetch`, `git`, и т.д.

**Что менять:**
- Добавить/убрать пакеты по желанию

### home.sessionVariables (строка 102)

- `EDITOR = "vim";` — **редактор по умолчанию**

**Что менять:**
- `"vim"` → `"nvim"` для Neovim

---

## nvidia.nix — NVIDIA

```
Файл:      ~/.config/nixos/nvidia.nix
Назначение: Драйвер NVIDIA, PRIME offload, power management
```

### hardware.graphics (строки 4-7)

- `enable = true;` — поддержка графики
- `enable32Bit = true;` — поддержка 32-битных приложений (Steam)

### services.xserver.videoDrivers (строка 9)

- `videoDrivers = [ "nvidia" ];` — использовать NVIDIA драйвер

### hardware.nvidia (строки 11-29)

- `modesetting.enable = true;` — режим настройки
- `open = true;` — открытый модуль ядра (NVIDIA GSP)
- `nvidiaSettings = true;` — GUI-панель управления
- `package = config.boot.kernelPackages.nvidiaPackages.latest;` — последняя версия драйвера
- `prime.nvidiaBusId = "PCI:1:0:0";` — **Bus ID видеокарты NVIDIA**
- `prime.intelBusId = "PCI:0:2:0";` — **Bus ID встроенной Intel**
- `prime.offload.enable = true;` — PRIME offload (переключение GPU)
- `powerManagement.finegrained = true;` — управление питанием

**Что менять:**
- Bus ID можно узнать через `lspci | grep -E "VGA|3D"`
- Пример: `"PCI:1:0:0"` — для NVIDIA, `"PCI:0:2:0"` — для Intel

### boot.kernelModules (строка 31)

- `kernelModules = [ "nvidia-uvm" ];` — модуль Unified Memory для CUDA

### nvidia-offload (строки 33-39)

Скрипт для запуска приложений на NVIDIA:
```
nvidia-offload <команда>
```

---

## modules/hardware/win.nix — Windows NTFS

```
Файл:      ~/.config/nixos/modules/hardware/win.nix
Назначение: Монтирование Windows-разделов при загрузке Linux
```

### boot.supportedFilesystems (строка 4)

- `boot.supportedFilesystems = [ "ntfs" ];` — включает поддержку ntfs3 в ядре

### fileSystems."/mnt/win/win-c" (строки 6-9)

```nix
fileSystems."/mnt/win/win-c" = {
  device = "/dev/disk/by-uuid/38087FA8087F6432";
  fsType = "ntfs3";
  options = [ "rw" "uid=1000" "gid=100" "umask=002" "nofail" ];
};
```

- `"/mnt/win/win-c"` — **путь монтирования**
- `device = "/dev/disk/by-uuid/..."` — **UUID раздела** (узнать через `sudo blkid`)
- `fsType = "ntfs3";` — драйвер ntfs3 (встроен в ядро, быстрее ntfs-3g)
- `options`:
  - `rw` — чтение и запись
  - `uid=1000` — владелец всех файлов (1000 = xmb03)
  - `gid=100` — группа (100 = users)
  - `umask=002` — права 775 для папок, 664 для файлов (группа может писать)
  - `nofail` — не останавливать загрузку если раздела нет

### fileSystems."/mnt/win/win-d" (строки 10-13)

То же самое для второго Windows-раздела (D:).

**Что менять:**
- UUID: `38087FA8087F6432` и `60AA662CAA65FEC2` → свои UUID (команда: `sudo blkid | grep ntfs`)
- `uid=1000` → свой uid (команда: `id`)
- `gid=100` → свою gid
- Если хочешь монтировать в другое место — меняй пути

### users.users.qbittorrent.extraGroups (строка 15)

- `extraGroups = [ "users" ];` — добавляет пользователя qbittorrent в группу users (нужно чтобы qBittorrent мог писать на NTFS с uid=1000,gid=100)

### systemd.tmpfiles.settings."win-symlinks" (строки 17-25)

Создаёт симлинки в `~/win/` → `/mnt/win/` чтобы было удобно ходить из домашней папки.

**Что менять:**
- `"/home/xmb03/win/win-c"` → `"/home/твой_юзер/win/win-c"`
- `user = "xmb03"` → `user = "твой_юзер"`

---

## modules/hardware/monitor.nix — монитор

```
Файл:      ~/.config/nixos/modules/hardware/monitor.nix
Назначение: Переключение частоты обновления (165Hz на питании, 60Hz на батарее)
```

- Проверяет `/sys/class/power_supply/AC/online`:
  - Если 1 (на питании): `xrandr --rate 165`
  - Если 0 (батарея): `xrandr --rate 60.09`

**Что менять:**
- `--output eDP-1` → свой вывод (узнать через `xrandr`)
- `--mode 1920x1200` → своё разрешение
- `--rate 165 / 60.09` → свои частоты

---

## modules/hardware/touchpad.nix — тачпад

```
Файл:      ~/.config/nixos/modules/hardware/touchpad.nix
Назначение: Настройка тачпада через libinput
```

Параметры:
- `naturalScrolling = true;` — обратный скролл (как на macOS)
- `tapping = true;` — тап для клика
- `accelProfile = "adaptive";` — адаптивная скорость
- `accelSpeed = "-0.39";` — чувствительность (отрицательное = медленнее)
- `disableWhileTyping = true;` — отключение при печати

**Что менять:**
- `accelSpeed = "-0.39"` → изменить скорость
- `naturalScrolling = false` → обычный скролл

---

## modules/hardware/power.nix — питание

```
Файл:      ~/.config/nixos/modules/hardware/power.nix
Назначение: Управление питанием CPU, термальд, авто-частота, AC udev
```

### CPU Governor (строка 6)

- `powerManagement.cpuFreqGovernor = "powersave";` — по умолчанию энергосбережение

### thermald (строка 8)

- `services.thermald.enable = true;` — термальный демон Intel

### auto-cpufreq (строки 12-21)

Автоматическое переключение между батареей и питанием:
- На батарее: `powersave`, `turbo = never`
- На питании: `performance`, `turbo = auto`

### upower (строки 23-28)

- `percentageLow = 15;` — низкий заряд
- `percentageCritical = 5;` — критический
- `percentageAction = 3;` — при 3% выключение

### udev правило AC (строки 30-38)

При подключении/отключении питания запускает xrandr для смены частоты.

**Что менять:**
- `xrandr --output eDP-1 --mode 1920x1200` → свои параметры
- `XAUTHORITY=/home/xmb03/.Xauthority` → свой путь
- `/home/xmb03` → свой home

---

## modules/services/qbittorrent.nix — торренты

```
Файл:      ~/.config/nixos/modules/services/qbittorrent.nix
Назначение: qBittorrent-nox в фоне как systemd-сервис, WebUI на 8080
```

### enable, openFirewall, webuiPort (строки 5-7)

- `enable = true;` — включить
- `openFirewall = true;` — открыть порты в файрволе
- `webuiPort = 8080;` — **порт WebUI**

### extraArgs (строка 9)

- `extraArgs = [ "--confirm-legal-notice" ];` — подтвердить лицензию при первом запуске

### serverConfig.LegalNotice (строка 12)

- `LegalNotice.Accepted = true;` — принять лицензионное соглашение

### serverConfig.Preferences.WebUI (строки 14-15)

- `Username = "xmb03";` — **имя пользователя для входа**
- `Password_PBKDF2 = "eG1iMDNfc2FsdF8xNmIh:BJ/a2jW8LE0njGJyqTTv6ER+7/KGFMWwswpyt74lbl5yDkIqPPtC8iHUVEkOQhOJI5WrUDd1Lzav0baJeJy4w";` — **хеш пароля**

**Что менять:**
- `Username = "xmb03";` → `Username = "твой_юзер";`
- `Password_PBKDF2 = "..."` — сгенерировать новый хеш. Формат: `base64(salt):base64(hash)`, где алгоритм PBKDF2-HMAC-SHA512, 100000 итераций, 16 байт соль, 64 байта хеш.

  **Скрипт для генерации:**
  ```python
  import hashlib, base64
  password = b'123'
  salt = b'твоя_соль_16байт!'  # ровно 16 байт, можно любые
  hash_bytes = hashlib.pbkdf2_hmac('sha512', password, salt, 100000, dklen=64)
  result = base64.b64encode(salt).decode().rstrip('=') + ':' + base64.b64encode(hash_bytes).decode().rstrip('=')
  print(result)
  ```

### serverConfig.Preferences.Downloads (строка 17)

- `SavePath = "/mnt/win/win-d/Games";` — **путь сохранения загрузок**

**Что менять:**
- `"/mnt/win/win-d/Games"` → свой путь

### serverConfig.BitTorrent.Session (строки 19-35)

Настройки производительности:

| Параметр | Значение | Что делает |
|----------|----------|-----------|
| `DiskCache.Size` | 64 | Максимум кеша в RAM (MB). 64 MB — не даёт qBittorrent сожрать всю память |
| `DiskCache.TTL` | 15 | Время жизни кеша (секунды). Чем меньше, тем быстрее чистится RAM |
| `AsyncIOThreads` | 4 | Потоки для дисковых операций. 4 — оптимум |
| `CoalesceReadWrite` | true | Группирует мелкие куски при чтении/записи — меньше нагрузки на диск |
| `SendBufferLowWatermark` | 2 | Нижний порог буфера отправки (сэкономит RAM) |
| `SendBufferWatermark` | 8 | Верхний порог буфера отправки |
| `SendBufferWatermarkFactor` | 50 | Множитель буфера отправки |
| `QueueingSystemEnabled` | false | Качать все торренты сразу, без очереди |
| `MaxConnections` | 200 | Максимум соединений всего. 200 — не забивает ОС |
| `MaxConnectionsPerTorrent` | 40 | Соединений на один торрент |
| `GlobalMaxUploads` | 30 | Максимум одновременных раздач |
| `SendToSocketBufferSizeMethod` | 0 | Отдать управление буферами ядру Linux |
| `ReceiveFromSocketBufferSizeMethod` | 0 | То же для приёма |
| `DHT` | true | DHT (поиск пиров без трекера) |
| `LSD` | false | Локальный поиск (не нужен) |
| `Encryption` | 1 | 1 = предпочитать шифрование (обходит DPI) |
| `AnonymousMode` | true | Скрывать User-Agent и локальный IP |

---

## modules/services/networkmanager.nix — сеть

```
Файл:      ~/.config/nixos/modules/services/networkmanager.nix
Назначение: NetworkManager, DNS, отключение IPv6, быстрая загрузка
```

### networking.networkmanager (строки 28-47)

- `enable = true;` — включить NetworkManager
- `dhcp = "internal";` — встроенный DHCP-клиент (быстрее dhclient)
- `settings.connection."ipv4.dhcp-timeout" = 10;` — таймаут DHCP
- `settings.wifi.scan-rand-mac-address = false;` — не рандомить MAC (нужно для корпоративных WiFi)
- `settings.connectivity.interval = 0;` — отключить проверку подключения
- `logLevel = "INFO";` — уровень логов

### networking.nameservers (строка 53)

- `nameservers = [ "77.88.8.8" "8.8.8.8" ];` — **DNS сервера**

**Что менять:**
- `"77.88.8.8"` (Яндекс DNS) и `"8.8.8.8"` (Google DNS) → свои DNS

### networking.enableIPv6 (строка 59)

- `enableIPv6 = false;` — **отключить IPv6**

**Что менять:**
- `false` → `true` если нужен IPv6

### systemd.services (строка 65)

- `NetworkManager-wait-online.enable = false;` — не ждать сеть при загрузке (быстрее)

---

## modules/services/ollama.nix — LLM

```
Файл:      ~/.config/nixos/modules/services/ollama.nix
Назначение: Ollama (Llama, Mistral и др.) как systemd-сервис с CUDA
```

- `package = pkgs.ollama-cuda;` — сборка с CUDA (использует NVIDIA)
- `host = "127.0.0.1";` — **только локальный доступ**
- `port = 11434;` — порт API
- `openFirewall = false;` — порт не открывать наружу

**Что менять:**
- `host = "0.0.0.0";` — если нужен доступ из сети (осторожно!)
- `port = 11434;` → другой порт

---

## modules/services/zapret.nix — обход DPI

```
Файл:      ~/.config/nixos/modules/services/zapret.nix
Назначение: Обход блокировок (DPI) для GitHub, GitLab, SoundCloud
```

- `configureFirewall = true;` — настраивает nftables
- `httpSupport = true;` — поддержка HTTP
- `udpSupport = false;` — без UDP (меньше нагрузки)
- `params` — параметры десинхронизации DPI
- `whitelist` — сайты, к которым применяется обход

**Что менять:**
- Добавить/убрать домены в `whitelist`

---

## modules/services/redshift.nix — синий фильтр

```
Файл:      ~/.config/nixos/modules/services/redshift.nix
Назначение: Автоматическая смена цветовой температуры экрана
```

- `latitude = "55.7558";` — **широта Москвы**
- `longitude = "37.6173";` — **долгота Москвы**
- `temperature.day = 6500;` — дневная температура (нейтральная)
- `temperature.night = 3500;` — ночная (тёплая, меньше синего)
- `settings.redshift.dusk-time = "20:00";` — закат (вручную)
- `settings.redshift.dawn-time = "07:00";` — рассвет
- `fade = 1;` — плавность перехода

**Что менять:**
- Координаты на свои (можно найти через maps.google.com)
- Время заката/рассвета

---

## modules/services/clipmenu.nix — буфер обмена

```
Файл:      ~/.config/nixos/modules/services/clipmenu.nix
Назначение: Менеджер истории буфера обмена
```

- `home.packages = [ pkgs.clipmenu ];` — установить clipmenu
- `systemd.user.services.clipmenud` — systemd-сервис на уровне пользователя
  - `ExecStart = "${pkgs.clipmenu}/bin/clipmenud";` — запуск демона
  - `Restart = "on-failure";` — перезапуск при ошибке

Вызов через Rofi: `Mod4+v` → `clipmenu -p Clip`

---

## modules/services/udiskie.nix — USB

```
Файл:      ~/.config/nixos/modules/services/udiskie.nix
Назначение: Автоматическое монтирование USB-флешек
```

- `services.udiskie.enable = true;` — включить

---

## modules/wm/i3.nix — оконный менеджер

```
Файл:      ~/.config/nixos/modules/wm/i3.nix
Назначение: Конфигурация i3: клавиши, gaps, цвета, стартап, бары
```

### modifier (строка 13)

- `modifier = "Mod4";` — **клавиша-модификатор** (Mod4 = Super/Windows)

**Что менять:**
- `"Mod4"` → `"Mod1"` для Alt

### floating (строки 16-20)

- `border = 1;` — рамка 1px у плавающих окон
- `titlebar = false;` — без заголовка

### window (строки 22-32)

- `border = 1;` — рамка 1px у всех окон
- `titlebar = false;` — без заголовка
- `hideEdgeBorders = "none";` — не прятать рамки у краёв
- `commands` — убрать рамку у Firefox: `border none` для класса `"(?i)firefox"`

### colors (строки 34-50)

Цвета рамок — из Stylix (base00 — фоновый цвет темы).

### gaps (строки 52-55)

```nix
gaps = {
  inner = 2;  # отступы между окнами (пиксели)
  outer = 15; # отступы от краёв экрана
};
```

**Что менять:**
- `inner = 2` → другое значение
- `outer = 15` → другое значение

### bars (строки 57-71)

Статус-бар на основе Stylix + i3status-rust:
- `position = "bottom";` — бар снизу
- `statusCommand = "i3status-rs ~/.config/i3status-rust/config-default.toml";` — команда статуса
- `trayOutput = "primary";` — трей на главном мониторе

### startup (строки 74-85)

Программы при запуске:

| Команда | Назначение |
|---------|-----------|
| `xset r rate 200 50` | Скорость повтора клавиш (200ms задержка, 50 символов/с) |
| `dex --autostart --environment i3` | XDG автозапуск |
| `rofi-wallpaper --restore` | Восстановить последние обои |
| `xss-lock -- i3lock -n -c 000000` | Блокировка при сне |
| `nm-applet` | Иконка NetworkManager в трее |

### keybindings (строки 88-180)

**Таблица всех горячих клавиш:**

| Клавиша | Действие |
|---------|----------|
| `Print` | Скриншот всего экрана (маим → clipboard + ~/Pictures) |
| `Mod4+Shift+s` | Скриншот области |
| `Mod4+w` | Firefox |
| `Mod4+d` | Rofi drun (запуск приложений) |
| `Mod4+v` | Clipmenu (история буфера) |
| `Mod4+Tab` | Rofi (все режимы) |
| `Mod4+p` | Меню питания (powermenu) |
| `Mod4+a` | Выбор обоев (rofi-wallpaper) |
| `Mod4+Shift+a` | Выбор темы Stylix (rofi-theme) |
| `Mod4+r` | Режим изменения размера окон |
| `Mod4+t` | Kitty терминал |
| `Mod4+q` | Закрыть окно |
| `Mod4+j/k/l/;` | Фокус: влево/вниз/вверх/вправо |
| `Mod4+Shift+j/k/l/;` | Переместить окно |
| `Mod4+h` | Горизонтальный сплит |
| `Mod4+f` | Полноэкранный режим |
| `Mod4+s` | Стекинг (вкладки) |
| `Mod4+e` | Переключить сплит |
| `Mod4+Shift+space` | Переключить плавающий режим |
| `Mod4+space` | Переключить фокус |
| `Mod4+1-0` | Рабочие столы 1-10 |
| `Mod4+Shift+1-0` | Переместить окно на стол |
| `Mod4+Shift+c` | Перезагрузить конфиг i3 |
| `Mod4+Shift+r` | Перезапустить i3 |
| `Mod4+Shift+e` | Выйти из i3 |
| `XF86AudioRaiseVolume` | Громче |
| `XF86AudioLowerVolume` | Тише |
| `XF86AudioMute` | Выключить звук |
| `XF86AudioPlay/Next/Prev` | Воспроизведение (playerctl) |

**Что менять:**
- Любую клавишу можно переназначить, изменив строку
- Названия клавиш: `Mod4`, `Mod1`, `Shift`, `Control`, `Print`, `XF86Audio*`

### resize mode (строки 183-197)

Режим изменения размера (вход: `Mod4+r`):
- `h/j/k/l` или стрелки — изменить размер

---

## modules/wm/i3-settings.nix — статус-бар

```
Файл:      ~/.config/nixos/modules/wm/i3-settings.nix
Назначение: Блоки i3status-rust (часы, звук, сеть, батарея, музыка)
```

- `theme = "native";` — встроенная тема
- `icons = "awesome4";` — набор иконок

### Блоки (слева направо):

1. **keyboard_layout** — раскладка (EN/RU), клик → переключение
2. **backlight** — яркость экрана
3. **battery** — процент батареи (скрыт при зарядке)
4. **sound** — громкость (pipewire)
5. **music** — текущий трек (MPRIS), клик → nowplaying скрипт
6. **net** — сеть, клик → `kitty -e nmtui`
7. **time** — часы (HH:MM)
8. **custom** — кнопка питания → `powermenu`

**Что менять:**
- Настройки каждого блока: `format`, `interval`, `click`

---

## modules/wm/picom.nix — композитор

```
Файл:      ~/.config/nixos/modules/wm/picom.nix
Назначение: Picom (прозрачность, vsync, тени — всё выключено для производительности)
```

- `backend = "glx";` — GLX бекенд (OpenGL)
- `vSync = true;` — вертикальная синхронизация
- `shadow = false;` — тени выключены
- `fade = false;` — анимации выключены
- Большинство параметров отключены для максимальной производительности

---

## modules/apps/rofi.nix — лаунчер

```
Файл:      ~/.config/nixos/modules/apps/rofi.nix
Назначение: Конфигурация Rofi (тема, цвета из Stylix, клавиши)
```

### programs.rofi (строки 6-18)

- `font = "JetBrainsMono Nerd Font 14";` — шрифт 14px
- `pass.enable = true;` — менеджер паролей pass
- `theme = "drun";` — тема drun (список приложений)

### Тема drun.rasi (строки 20-184)

Полная тема Rofi с цветами из Stylix:
- `background` — из base00 (фон темы)
- `foreground` — из base05 (текст)
- `lightbg` — из base01
- `selected-normal-background` — из base07 (выделение)

**Что менять:**
- `font` — шрифт
- `width: 800px;` — ширина окна
- `padding: 20px;` — отступы
- `element-icon size: 1.5em;` — размер иконки
- Можно изменить любую цветовую переменную

---

## modules/apps/yazi.nix — файловый менеджер

```
Файл:      ~/.config/nixos/modules/apps/yazi.nix
Назначение: Yazi терминальный файловый менеджер с плагинами
```

### plugins

- `diff` — просмотр diff
- `git` — git статус
- `smart-enter` — умный Enter
- `chmod` — права доступа
- `compress` — архивация

### settings

- `show_hidden = true;` — показывать скрытые файлы
- `sort_dir_first = true;` — папки сверху
- `linemode = "size";` — показывать размеры
- `opener.edit = "vim";` — редактор

### keymap

- `gg` — в начало
- `G` — в конец

---

## modules/apps/basalt.nix — заметки

```
Файл:      ~/.config/nixos/modules/apps/basalt.nix
Назначение: Obsidian-подобная заметочница в терминале
```

- Собирается из исходников (`rustPlatform.buildRustPackage`)
- `configFile:"basalt/config.toml"` — настройки
- `ctrl+alt+e` — открыть заметку в vim
- `basalt` алиас: `BASALT_EXP_VAULT_PATH=/home/xmb03/Documents/xmb03 basalt`

**Что менять:**
- Путь к хранилищу: `/home/xmb03/Documents/xmb03` → свой

---

## modules/shell/zsh.nix — шелл

```
Файл:      ~/.config/nixos/modules/shell/zsh.nix
Назначение: Zsh: алиасы, история, автодополнение, подсветка
```

### home.sessionPath (строка 10)

- `$HOME/.npm-global/bin` — путь для глобальных npm-пакетов

### home.packages (строки 14-27)

- `zsh-completions` — автодополнение
- `yc` — кастомный скрипт: `yc <файл>` копирует содержимое в буфер обмена

### programs.zsh (строки 29-72)

- `history.size = 10000;` — история 10000 команд
- `autosuggestion.enable = true;` — автоподсказки
- `syntaxHighlighting.enable = true;` — подсветка синтаксиса

### localVariables (строки 55-57)

- `PROMPT = "%F{4}>%f ";` — приглашение: синий `> `

**Что менять:**
- `"${config.home.homeDirectory}/.zsh_history"` — путь к файлу истории
- `PROMPT = "%F{4}>%f ";` — можно изменить на любой

### Алиасы (строки 60-77)

| Алиас | Команда | Назначение |
|-------|---------|-----------|
| `up` | `cd ~/.config/nixos && git add . && nixos-rebuild switch --elevate=sudo --flake .#nixos` | **Собрать систему** |
| `c` | `clear` | Очистить экран |
| `cat` | `bat` | Кошка с подсветкой |
| `b` | `bat` | Шорткат для bat |
| `l` | `ls -lh` | Список файлов |
| `la` | `ls -lha` | Список со скрытыми |
| `..` | `cd ..` | На уровень вверх |
| `...` | `cd ../..` | На два уровня вверх |
| `f` | `fastfetch` | Инфо о системе |
| `mem` | `free -h` | Память |
| `disk` | `df -h` | Диски |
| `top` | `btop` | Монитор системы |
| `m` | `mpv` | Видеоплеер |
| `p` | `python` | Python |
| `dn` | `sudo nix-collect-garbage --delete-older-than 30d` | **Очистить старые генерации NixOS** (не трогает файлы в ~, чистит только /nix/store) |
| `tgw` | `steam-run ~/nixtest/apps/TgWsProxy_linux_amd64` | Telegram прокси |
| `v` | `vim` | Vim |
| `n` | `nvim` | Neovim |
| `yb` | `yazi ~/Documents/xmb03` | Yazi в папке заметок |

**Что менять:**
- Любой алиас можно изменить
- `dn` безопасен — удаляет только мусор старше 30 дней

---

## modules/term/kitty.nix — терминал

```
Файл:      ~/.config/nixos/modules/term/kitty.nix
Назначение: Kitty терминал с минималистичным дизайном
```

- `bold_font = "auto";` — авто-жирный
- `window_padding_width = 9;` — отступ текста от краёв окна
- `hide_window_decorations = "yes";` — без рамок окна
- `enable_audio_bell = "no";` — без звукового сигнала
- `confirm_os_window_close = 0;` — без подтверждения закрытия

---

## modules/theme/stylix.nix — темизация

```
Файл:      ~/.config/nixos/modules/theme/stylix.nix
Назначение: Stylix: цветовая схема, шрифты, полярность
```

### base16Scheme (строка 9)

- `base16Scheme = "${pkgs.base16-schemes}/share/themes/grayscale-dark.yaml";` — **текущая цветовая схема**

**Что менять:**
- Заменить `grayscale-dark.yaml` на любую другую схему (список в `/mnt/win/win-c/...` через `rofi-theme`)
- Рофи автоматически меняет эту строку при выборе темы (`Mod4+Shift+a`)

### polarity (строка 12)

- `polarity = "dark";` — тёмная тема

### fonts (строки 15-31)

- `monospace = { package = pkgs.nerd-fonts.jetbrains-mono; name = "JetBrainsMono Nerd Font"; };` — шрифт
- Размеры: `applications = 11; desktop = 10; popups = 10; terminal = 11;`

**Что менять:**
- `package` — другой пакет шрифта
- `name` — другое имя шрифта
- `sizes` — размеры для каждого типа приложений

---

## modules/scripts/rofi-theme.nix — пинкер тем

```
Файл:      ~/.config/nixos/modules/scripts/rofi-theme.nix
Назначение: Выбор темы Stylix через Rofi с иконками и автоматическим билдом
```

### Как работает

1. Ищет папку `base16-schemes` в /nix/store
2. Для каждой схемы: если есть иконка в `assets/theme-icons/` → добавляет в Rofi
3. Rofi показывает сетку 4×3 с иконкой (2-цветная полоска) и названием
4. При выборе: sed заменяет `base16Scheme` в `stylix.nix`
5. Kitty открывается, запускает `nixos-rebuild switch`

### element-icon (строка 35)

- `size: 6em;` — высота иконки
- `columns: 4; lines: 3; padding: 3px;` — сетка 4×3, компактно

**Что менять:**
- `size: 6em;` → больше/меньше для изменения размера иконок
- `lines: 3;` → 2 или 4 для другого количества строк

### Иконки

303 PNG файла в `assets/theme-icons/`. Формат: 160×12 пикселей, 2 цвета (base00 + base05).

Если добавилась новая схема Stylix — нужно сгенерировать иконку:
```bash
SCHEME_FILE="путь/к/новой/схеме.yaml"
NAME=$(basename "$SCHEME_FILE" .yaml)
# достать base00 и base05
B00=$(grep -E '^\s+base00:' "$SCHEME_FILE" | sed 's/.*"#\(.*\)"/\1/')
B05=$(grep -E '^\s+base05:' "$SCHEME_FILE" | sed 's/.*"#\(.*\)"/\1/')
# создать PNG
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

## modules/scripts/rofi-wallpaper.nix — обои

```
Файл:      ~/.config/nixos/modules/scripts/rofi-wallpaper.nix
Назначение: Выбор обоев через Rofi, запоминание последних (+ --restore)
```

### Как работает

- `--restore` — читает `~/.cache/wallpaper-current` и ставит обои (вызывается при старте i3)
- Без аргумента — открывает Rofi с сеткой 3×3, показывает превью из `~/Pictures/Wallpapers/`
- При выборе: `feh --bg-fill`, сохраняет путь в кеш

**Что менять:**
- `WALL_DIR="$HOME/Pictures/Wallpapers"` → своя папка с обоями
- `columns: 3; lines: 3;` — изменить сетку
- `element-icon size: 8em;` — изменить размер превью

---

## modules/scripts/powermenu.nix — меню питания

```
Файл:      ~/.config/nixos/modules/scripts/powermenu.nix
Назначение: Rofi меню с Lock, Logout, Suspend, Hibernate, Reboot, Shutdown
```

Выбор:
- **Lock**: `i3lock -c 000000` (чёрный экран)
- **Logout**: `i3-msg exit`
- **Suspend**: `systemctl suspend`
- **Hibernate**: `systemctl hibernate`
- **Reboot**: `systemctl reboot`
- **Shutdown**: `systemctl poweroff`

---

## modules/editor/vim.nix — Vim

```
Файл:      ~/.config/nixos/modules/editor/vim.nix
Назначение: Vim с LSP (rust-analyzer), floaterm, fzf
```

### Плагины

- `vim-commentary` — комментирование (gc/gc)
- `vim-floaterm` — терминал внутри Vim (Ctrl+/)
- `fzf-vim` — поиск файлов
- `rust-vim` — подсветка Rust
- `vim-lsp` — LSP клиент

### Настройки

- `number = true;` — номера строк
- `relativenumber = true;` — относительные номера
- `tabstop = 4; shiftwidth = 4; expandtab = true;` — табуляция 4 пробела
- `mouse = "a";` — мышь

### extraConfig

- `clipboard=unnamedplus` — системный буфер обмена
- `Tab` → LSP автодополнение или табуляция
- Стрелки отключены (vim-way)
- `Ctrl+/` → floaterm
- `rust-analyzer` подключён через vim-lsp

### home.packages

- `cargo`, `rustc`, `rustfmt`, `clippy`, `rust-analyzer` — инструменты Rust

---

## modules/editor/neovim.nix — Neovim

```
Файл:      ~/.config/nixos/modules/editor/neovim.nix
Назначение: Neovim с Telescope, nvim-cmp, Treesitter, LSP
```

### Плагины

- `telescope-nvim` — поиск файлов/текста/...
- `nvim-cmp` — автодополнение
- `cmp-nvim-lsp` — LSP источник для cmp
- `luasnip` — сниппеты
- `nvim-treesitter` — подсветка синтаксиса
- `nvim-lspconfig` — LSP конфигурация
- `toggleterm-nvim` — терминал
- `mini-align` — выравнивание

### init.lua

Читается из `./neovim/init.lua` (не встроен в home.nix для читаемости).

### home.packages

- `pyright` — Python LSP
- `nil` — Nix LSP
- `lua-language-server` — Lua LSP
- `typescript-language-server` — TS/JS LSP
- `marksman` — Markdown LSP
- `ripgrep` — для Telescope
- `fd` — для Telescope

---

## modules/firefox/default.nix — Firefox

```
Файл:      ~/.config/nixos/modules/firefox/default.nix
Назначение: Firefox с расширениями, textfox, отключение телеметрии
```

### Принудительные расширения (строки 6-32)

Устанавливаются через политики Firefox:

| ID | Расширение |
|----|-----------|
| `uBlock0@raymondhill.net` | uBlock Origin |
| `{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}` | Search by Image |
| `jid1-MnnxcxisBPnSXQ@jetpack` | Privacy Badger |
| `vimium-c@gdh1995.cn` | Vimium C |
| `{531906d3-e22f-4a6c-a102-8057b88a1a63}` | SingleFile |
| `addon@darkreader.org` | Dark Reader |
| `{rto@rto.rto}` | Rutracker Add-on |

**Что менять:**
- Добавить/убрать расширение (ID можно найти на addons.mozilla.org)
- `installation_mode = "force_installed"` — нельзя отключить
- `installation_mode = "allowed"` — можно отключить

### Поиск (строки 41-44)

- `search.default = "ddg";` — DuckDuckGo по умолчанию

### Отключение телеметрии (строки 45-56)

- Все `telemetry`, `datareporting`, `ping-centre` → false
- `browser.toolbars.bookmarks.visibility = "never";` — скрыть панель закладок

### textfox (строки 58-61)

- `textfox.enable = true;` — тема Firefox в стиле Stylix
- `profiles = [ "default" ];` — для профиля default

---

## modules/gtk/gtk.nix — GTK

```
Файл:      ~/.config/nixos/modules/gtk/gtk.nix
Назначение: GTK закладки, DPI, шрифты
```

- `Xft.dpi = 96;` — DPI через Xresources
- `gtk3.bookmarks` — закладки в файловом менеджере: Pictures, Documents, apps, Projects

**Что менять:**
- Добавить свои закладки в `bookmarks`
- `Xft.dpi = 96;` → `Xft.dpi = 144;` для HiDPI

### fonts.fontconfig (строки 25-33)

- `defaultFonts.monospace = [ "JetBrainsMono Nerd Font Mono" ];`
- `defaultFonts.sansSerif = [ "JetBrainsMono Nerd Font" ];`
- `defaultFonts.serif = [ "JetBrainsMono Nerd Font" ];`

---

## modules/zathura/zathura.nix — PDF

```
Файл:      ~/.config/nixos/modules/zathura/zathura.nix
Назначение: PDF читалка с тёмной темой
```

- `selection-clipboard = "clipboard";` — копировать выделенный текст в буфер
- `recolor = true;` — инвертировать цвета (тёмная тема)
- `recolor-keephue = true;` — не инвертировать цвета картинок

---

## Чеклист «Смена пользователя»

Если хочешь использовать не `xmb03`, а другое имя — нужно заменить в этих файлах:

| Файл | Что менять |
|------|-----------|
| `flake.nix:56` | `users.xmb03` → `users.твой_юзер` |
| `configuration.nix:100-102` | `autoLogin.user = "xmb03"` |
| `configuration.nix:135-144` | `users.users."xmb03"` → `users.users."твой_юзер"` |
| `home.nix:33-34` | `username = "xmb03"`, `homeDirectory = "/home/xmb03"` |
| `i3.nix` | нет прямых упоминаний (xss-lock использует XAUTHORITY) |
| `power.nix:37` | `/home/xmb03/.Xauthority`, `sudo -u xmb03` |
| `win.nix:18,21` | `/home/xmb03/win/...`, `user = "xmb03"` |
| `qbittorrent.nix:14` | `Username = "xmb03"` |
| `zsh.nix` | `$HOME` автоматом (от homeDirectory) |
| `basalt.nix:28` | `BASALT_EXP_VAULT_PATH=/home/xmb03/...` |
| `rofi-theme.nix` | `ICONS_DIR`, `STYLIX_FILE`, `FLAKE_DIR` (абсолютные пути) |
| `rofi-wallpaper.nix` | `CACHE`, `WALL_DIR` (через $HOME — ок) |

---

## Чеклист «Смена паролей»

### Sudo / вход в систему

```nix
# В configuration.nix, внутри users.users."xmb03":
initialPassword = "ваш_пароль";  # только при первом создании
# или (после первого билда):
hashedPassword = "хеш";  # сгенерировать через: mkpasswd -m sha-512
```

**Генерация хеша:** `mkpasswd -m sha-512` (ввести пароль, получить хеш).

### qBittorrent

Смотри раздел `modules/services/qbittorrent.nix` — скрипт генерации PBKDF2.

### Firefox

Пароли хранятся в самом Firefox (менеджер паролей), не в конфигах.

---

## Сборка и команды

```
up    → cd ~/.config/nixos && git add . && nixos-rebuild switch --elevate=sudo --flake .#nixos
dn    → sudo nix-collect-garbage --delete-older-than 30d
```

После изменения любого файла:
1. `git add` (если файл новый)
2. `up` (или `nixos-rebuild switch --flake .#nixos --impure --elevate=sudo`)
3. `dn` — иногда, чтобы очистить старые генерации

**Важно:** `--impure` обязателен из-за Stylix (он обращается к абсолютным путям /nix/store).
**Важно:** Используй `--offline` только если уверен, что все пакеты уже в кеше.
**Важно:** Если nix жалуется на dirty git tree — ничего страшного, это просто предупреждение.

---

## Советы

- **Не работает звук?** Проверь `pavucontrol` или `pactl info`
- **Не работает NVIDIA?** Проверь `nvidia-smi`, Bus ID в `nvidia.nix`
- **Не монтируются Windows разделы?** Проверь UUID через `sudo blkid`
- **Не открывается Rofi?** Проверь `rofi -show drun`
- **Strange errors in Nix?** Используй `--show-trace` для полного лога

---

*Сгенерировано для конфигурации xmb03 / nixos-dots*
