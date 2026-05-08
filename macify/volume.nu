# macOS volume control via osascript

# Get current output volume (0-100)
export def get [] {
    ^osascript -e 'output volume of (get volume settings)'
    | str trim
    | into int
}

# Set output volume (0-100), or read from pipe/arg
export def main [level?: int] {
    let value = if ($level == null) { $in } else { $level }
    ^osascript -e $'set volume output volume ($value)'
}

# Set output volume (0-100)
export def set [level: int] {
    ^osascript -e $'set volume output volume ($level)'
}

# Mute output
export def mute [] {
    ^osascript -e 'set volume with output muted'
}

# Unmute output
export def unmute [] {
    ^osascript -e 'set volume without output muted'
}

# Toggle mute state
export def toggle [] {
    let muted = (^osascript -e 'output muted of (get volume settings)' | str trim)
    if $muted == "true" { unmute } else { mute }
}

# Is the output muted?
export def muted? [] {
    (^osascript -e 'output muted of (get volume settings)' | str trim) == "true"
}
