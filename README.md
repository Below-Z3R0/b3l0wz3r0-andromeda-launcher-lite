# Andromeda Launcher Lite

A lightweight, Plasma 6-focused fork of [Andromeda Launcher](https://github.com/EliverLara/AndromedaLauncher), itself based on [mmcklauncher](https://github.com/SnoutBug/mmcklauncher).

This fork keeps the original launcher experience while adding a category sidebar, configurable app labels, Qt 6 effects, and targeted performance and compatibility fixes.

## Highlights

- Category sidebar in the **All Apps** view
- Configurable application labels in grid mode
- Search, favorites, recent items, and system actions
- Reusable grid/list delegates for smoother navigation
- Conditional effects to reduce unnecessary GPU work
- Qt 6 / KDE Plasma 6 API cleanup
- Independent plugin ID: `b3l0wz3r0-andromeda-launcher-lite`

## Requirements

- KDE Plasma 6.0 or newer
- Qt 6 with the Plasma, Kirigami, KSvg, Kicker, and Qt Quick Effects modules normally provided by a Plasma installation

## Installation

### From Git

```bash
git clone https://github.com/Below-Z3R0/b3l0wz3r0-andromeda-launcher-lite.git
cd b3l0wz3r0-andromeda-launcher-lite
kpackagetool6 --type Plasma/Applet --install .
```

If an older copy is already installed, update it instead:

```bash
kpackagetool6 --type Plasma/Applet --upgrade .
```

Then restart Plasma or sign out and back in. On X11, you can reload the shell with:

```bash
kquitapp6 plasmashell && kstart plasmashell
```

### Uninstall

```bash
kpackagetool6 --type Plasma/Applet --remove b3l0wz3r0-andromeda-launcher-lite
```

## Usage

1. Right-click the desktop or panel and choose **Add Widgets**.
2. Search for **Andromeda Launcher Lite**.
3. Drag it to the desktop or panel.
4. Right-click the widget and select **Configure Andromeda Launcher Lite** to customize its layout and appearance.

## Development checks

Validate the package layout without touching the active installation:

```bash
rm -rf /tmp/andromeda-launcher-lite-check
kpackagetool6 --type Plasma/Applet \
  --packageroot /tmp/andromeda-launcher-lite-check \
  --install .
```

Run static QML checks with the Qt 6 `qmllint` executable available on your distribution.

## Credits and license

Andromeda Launcher Lite is a fork of [EliverLara/AndromedaLauncher](https://github.com/EliverLara/AndromedaLauncher), which is based on [SnoutBug/mmcklauncher](https://github.com/SnoutBug/mmcklauncher). Original contributor notices are preserved in the source files.

Licensed under the [GNU General Public License v2.0 or later](LICENSE). Bundled Feather and Lucide icons retain their respective licenses under `contents/ui/icons/`.
