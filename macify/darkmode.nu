# macOS dark mode toggle via osascript

# Is dark mode enabled?
export def main [] {
    let r = (^osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode' | str trim)
    $r == "true"
}

# Toggle dark mode
export def toggle [] {
    ^osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'
}

# Enable dark mode
export def on [] {
    ^osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
}

# Disable dark mode
export def off [] {
    ^osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
}
