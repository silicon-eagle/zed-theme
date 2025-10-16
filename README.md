# zed-theme
A collection of GitHub-style themes for the Zed editor.

## Included Themes
- GitHub Light Default
![GitHub Dark Default screenshot](assets/20251016_screenshot_dm.png)
- GitHub Dark Default
![GitHub Light Default screenshot](assets/20251016_screenshot_lm.png)

## Installation

Copy the theme JSON file (e.g. `github.json`) into your local Zed `themes` directory.

Unix-like systems:
`~/.config/zed/themes`

Windows:
`%APPDATA%\Roaming\Zed\themes`

If the `themes` directory doesn’t exist yet, create it.

After copying:
1. Open Zed.
2. Press `Ctrl+Shift+P` / `Cmd+Shift+P` and choose "Themes: Select Theme".
3. Pick "GitHub Light Default" or "GitHub Dark Default".

### Using the PowerShell script (Windows)

Instead of copying manually, you can run the helper script that overwrites the theme in your Zed themes directory:

From the repository root:
```
.\scripts\replace_theme.ps1
```

If script execution is blocked, you can run:
```
powershell -ExecutionPolicy Bypass -File .\scripts\replace_theme.ps1
```

Optional parameters:
- `-ThemeName <name>`  Destination file name (without .json), default: github
- `-Source <path>`     Custom source JSON path (defaults to the repo's themes\github.json)
- `-SkipBackup`        Overwrite without creating a timestamped .bak

Examples:
```
.\scripts\replace_theme.ps1 -ThemeName github-bright
.\scripts\replace_theme.ps1 -Source "C:\work\zed-theme\themes\github.json" -SkipBackup
```

After running the script, select the theme in Zed via the command palette as described above.

## Notes
- Dark theme base background: `#010409` with editor surface `#0d1117`.
- Light theme uses classic GitHub light palette.
- Feel free to customize further by editing `github.json`.
- The idea is that I make it into an official theme for Zed, but for now I haven't had the time to do so.

## Contributing
Submit improvements or additional variants (High Contrast, Colorblind, Dimmed) by opening a pull request.
