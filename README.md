# nushell-macify

A [Nushell](https://www.nushell.sh/) module that wraps common macOS automation primitives (`osascript`, `pbcopy`/`pbpaste`, `say`, `shortcuts`, `pmset`, `open`) into idiomatic, pipeline-friendly Nushell commands with completions.

Pure Nushell — no external dependencies beyond the macOS system tools that ship with the OS.

## Requirements

- macOS
- [Nushell](https://www.nushell.sh/) 0.90+ (anything recent should work)

## Installation

Clone the repo somewhere on your machine:

```nu
git clone https://github.com/kiil/nushell-macify.git ~/nushell-macify
```

Then load the module from your `config.nu`:

```nu
use ~/nushell-macify/macify
```

Or import individual submodules:

```nu
use ~/nushell-macify/macify notify
use ~/nushell-macify/macify clipboard
```

## Modules

The top-level `macify` module re-exports the following submodules.

### `notify` — Notification Center

```nu
macify notify "Build finished"
macify notify "Tests failed" --title "CI" --sound Sosumi
```

Sound name is tab-completed from the standard system sounds.

### `say` — text-to-speech

Wrapper around `say(1)`. Accepts text as an argument or from the pipeline.

```nu
macify say "Hello world"
"piped text" | macify say --voice Samantha --rate 200
macify say "save me" --output out.aiff
```

Voice completions are populated from `say -v '?'`.

### `clipboard`

```nu
macify clipboard                  # get clipboard contents
macify clipboard "hello"          # set
"piped" | macify clipboard        # set from pipe
macify clipboard get
macify clipboard set "hello"
macify clipboard clear
```

### `dialog` — AppleScript dialogs

```nu
macify dialog ask "What's your name?" --title "Hi" --default "World"
macify dialog ask "Password:" --hidden
macify dialog confirm "Proceed?"          # -> true / false
macify dialog alert "Something happened"
macify dialog choose ["red" "green" "blue"] --prompt "Pick a color"
macify dialog choose ["a" "b" "c"] --multiple
macify dialog file                        # -> POSIX path
macify dialog folder
```

Cancellation returns `null` (or `false` for `confirm`).

### `volume`

```nu
macify volume get        # 0-100
macify volume 50         # set (positional)
50 | macify volume       # set from pipe
macify volume set 75
macify volume mute
macify volume unmute
macify volume toggle
macify volume muted?     # -> bool
```

### `frontapp` — frontmost app / app control

```nu
macify frontapp                  # name of frontmost app
macify frontapp list             # all visible app names
macify frontapp activate "Safari"
macify frontapp quit "TextEdit"
macify frontapp hide "Finder"
```

App-name arguments are tab-completed from `/Applications`.

### `browser` — active tab inspection

Auto-detects which browser is frontmost (Safari, Chrome, Arc, Brave, Edge), with a `--browser` override.

```nu
macify browser              # { browser, url, title, content } of front tab
macify browser --reader     # Safari: toggle Reader View first for cleaner content
macify browser url
macify browser title
macify browser content      # innerText of active tab
macify browser content --reader   # Safari only
macify browser tabs         # all tabs in front window
macify browser open "https://example.com"
macify browser open "https://example.com" --browser "Arc"
```

Note: Safari requires "Allow JavaScript from Apple Events" to be enabled in the Develop menu for tab introspection.

### `shortcut` — Shortcuts.app

```nu
macify shortcut list
macify shortcut "My Shortcut"
"input text" | macify shortcut "My Shortcut"
macify shortcut "My Shortcut" --output result.txt
macify shortcut view "My Shortcut"
```

### `darkmode`

```nu
macify darkmode           # -> bool, is dark mode on?
macify darkmode toggle
macify darkmode on
macify darkmode off
```

### `power` — session and power controls

```nu
macify power lock
macify power display-sleep
macify power sleep
macify power logout       # shows confirmation dialog
macify power restart      # shows confirmation dialog
macify power shutdown     # shows confirmation dialog
```

## Examples

Notify when a long-running command finishes:

```nu
cargo build; macify notify $"Build done at (date now | format date '%H:%M')"
```

Speak the title of whatever you're looking at in the browser:

```nu
macify browser title | macify say
```

Pick a file via dialog and copy its path:

```nu
macify dialog file | macify clipboard
```

Toggle dark mode at sunset, with a notification:

```nu
macify darkmode toggle
macify notify $"Dark mode: (macify darkmode)"
```

## License

MIT
