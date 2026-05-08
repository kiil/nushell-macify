# macOS power / session controls

# Lock the screen
export def lock [] {
    ^osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}'
}

# Put the display to sleep
export def display-sleep [] {
    ^pmset displaysleepnow
}

# Put the system to sleep
export def sleep [] {
    ^osascript -e 'tell application "System Events" to sleep'
}

# Log out the current user (with confirmation dialog)
export def logout [] {
    ^osascript -e 'tell application "System Events" to log out'
}

# Restart the system (with confirmation dialog)
export def restart [] {
    ^osascript -e 'tell application "System Events" to restart'
}

# Shut down the system (with confirmation dialog)
export def shutdown [] {
    ^osascript -e 'tell application "System Events" to shut down'
}
